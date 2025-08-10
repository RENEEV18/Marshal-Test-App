package com.example.marshal_test_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){
    private val METHOD_CHANNEL = "com.example.marshal_test_app/device_info"
    private val EVENT_CHANNEL = "com.example.marshal_test_app/battery"

    private var batteryReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
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

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                // Send current/backing battery immediately and then listen for updates
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
                // register live receiver
                applicationContext.registerReceiver(batteryReceiver, filter)
            }

            override fun onCancel(arguments: Any?) {
                try {
                    batteryReceiver?.let { applicationContext.unregisterReceiver(it) }
                } catch (e: Exception) {
                    // ignore
                }
                batteryReceiver = null
            }
        })
    }

    private fun getBatteryPercentFromIntent(intent: Intent): Int {
        val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        if (level >= 0 && scale > 0) {
            return ((level.toFloat() / scale.toFloat()) * 100f).toInt()
        }
        // fallback to BatteryManager capacity if available
        val bm = applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val capacity = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        return if (capacity >= 0) capacity else -1
    }
}
