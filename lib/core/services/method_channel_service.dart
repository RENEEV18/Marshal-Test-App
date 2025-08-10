import 'dart:developer';

import 'package:flutter/services.dart';

class MethodChannelService {
  // First initialise a method channel for the device info
  static const MethodChannel _methodChannel = MethodChannel('com.example.marshal_test_app/device_info');
  // Initialise event channel for fetching live battery
  static const EventChannel _eventChannel = EventChannel('com.example.marshal_test_app/battery');

  // Fuction for device and app info
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final result = await _methodChannel.invokeMethod('getDeviceInfo');
      if (result == null) return {};
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      log("Platform Channel Error : ${e.message.toString()}");
      return {"error": e.message ?? "Platform Error"};
    } catch (e) {
      log("Unknown Error : ${e.toString()}");
      return {'error': 'unknown error'};
    }
  }

  // Function for event channel (Live battery event) - Stream
  static Stream<int> getBatteryInfo() {
    return _eventChannel.receiveBroadcastStream().map<int>((event) {
      if (event is int) {
        return event;
      } else if (event is double) {
        return event.toInt();
      } else if (event is Map && event['level'] != null) {
        return (event['level'] as num).toInt();
      }
      return -1;
    });
  }
}
