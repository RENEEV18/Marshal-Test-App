package com.example.marshal_test_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL_DEVICE = "com.example.marshal_test_app/device_info"
    private val EVENT_CHANNEL_BATTERY = "com.example.marshal_test_app/battery"
    private val METHOD_CHANNEL_IMAGE = "com.example.marshal_test_app/image_picker"

    private var batteryReceiver: BroadcastReceiver? = null
    private var pendingResult: MethodChannel.Result? = null

    private val REQUEST_CODE_PICK_IMAGE = 101
    private val REQUEST_CODE_PERMISSION = 102

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Device Info Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_DEVICE)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getDeviceInfo" -> {
                        try {
                            val pm = applicationContext.packageManager
                            val pInfo = pm.getPackageInfo(packageName, 0)
                            val info = mapOf(
                                "model" to Build.MODEL,
                                "manufacturer" to Build.MANUFACTURER,
                                "androidVersion" to Build.VERSION.RELEASE,
                                "sdkInt" to Build.VERSION.SDK_INT,
                                "appVersion" to (pInfo.versionName ?: "unknown"),
                                "packageName" to packageName
                            )
                            result.success(info)
                        } catch (e: PackageManager.NameNotFoundException) {
                            result.error("NOT_FOUND", "Package info not found", null)
                        } catch (e: Exception) {
                            result.error("ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Battery Info EventChannel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_BATTERY)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    val sticky = applicationContext.registerReceiver(null, filter)
                    sticky?.let {
                        val level = getBatteryPercentFromIntent(it)
                        events?.success(level)
                    }

                    batteryReceiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent?) {
                            if (intent == null) return
                            val level = getBatteryPercentFromIntent(intent)
                            events?.success(level)
                        }
                    }
                    applicationContext.registerReceiver(batteryReceiver, filter)
                }

                override fun onCancel(arguments: Any?) {
                    try {
                        batteryReceiver?.let { applicationContext.unregisterReceiver(it) }
                    } catch (_: Exception) {}
                    batteryReceiver = null
                }
            })

        // Image Picker MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_IMAGE)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickImage" -> pickImageFromGallery(result)
                    else -> result.notImplemented()
                }
            }
    }

    // Utility: Get battery percentage
    private fun getBatteryPercentFromIntent(intent: Intent): Int {
        val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        if (level >= 0 && scale > 0) {
            return ((level.toFloat() / scale.toFloat()) * 100f).toInt()
        }
        val bm = applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val capacity = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        return if (capacity >= 0) capacity else -1
    }

    // Image picker logic
    private fun pickImageFromGallery(result: MethodChannel.Result) {
        val permission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            android.Manifest.permission.READ_MEDIA_IMAGES
        } else {
            android.Manifest.permission.READ_EXTERNAL_STORAGE
        }

        if (checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED) {
            pendingResult = result
            requestPermissions(arrayOf(permission), REQUEST_CODE_PERMISSION)
        } else {
            openGallery(result)
        }
    }

    private fun openGallery(result: MethodChannel.Result) {
        pendingResult = result
        val intent = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
        startActivityForResult(intent, REQUEST_CODE_PICK_IMAGE)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_PERMISSION) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                openGallery(pendingResult!!)
            } else {
                pendingResult?.error("PERMISSION_DENIED", "Permission denied by user", null)
                pendingResult = null
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_PICK_IMAGE && resultCode == RESULT_OK && data != null) {
            val uri = data.data
            val path = uri?.let { getPathFromUri(it) }
            pendingResult?.success(path)
            pendingResult = null
        }
    }

    private fun getPathFromUri(uri: Uri): String? {
        val projection = arrayOf(MediaStore.Images.Media.DATA)
        contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
            val columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            cursor.moveToFirst()
            return cursor.getString(columnIndex)
        }
        return null
    }
}
