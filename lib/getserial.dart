import 'package:flutter/services.dart';

class SerialNumber {
  static const platform = MethodChannel('com.example.yourapp/serial');

  Future<String?> getSerialNumber() async {
    try {
      final String serial = await platform.invokeMethod('getSerialNumber');
      return serial;
    } on PlatformException catch (e) {
      print("Failed to get serial number: '${e.message}'.");
      return null;
    }
  }
}
