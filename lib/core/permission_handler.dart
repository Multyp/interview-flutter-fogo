import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class BluetoothPermissionHandler {
  static Future<bool> checkAndRequestPermissions() async {

    // For Android 12+ we need both bluetooth scan and location permissions
    if (Platform.isAndroid) {
      final bluetoothScan = await Permission.bluetoothScan.status;
      final bluetoothConnect = await Permission.bluetoothConnect.status;
      final location = await Permission.locationWhenInUse.status;

      if (!bluetoothScan.isGranted || !bluetoothConnect.isGranted || !location.isGranted) {
        final results = await Future.wait([
          Permission.bluetoothScan.request(),
          Permission.bluetoothConnect.request(),
          Permission.locationWhenInUse.request(),
        ]);

        return results.every((status) => status.isGranted);
      }
      return true;
    }

    // For iOS we need bluetooth permission
    if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.status;
      if (!bluetooth.isGranted) {
        final result = await Permission.bluetooth.request();
        return result.isGranted;
      }
      return true;
    }
    return false;
  }
}