// Global imports
import 'dart:io';

// Local imports
import 'package:permission_handler/permission_handler.dart';


class BluetoothPermissionHandler {
  static Future<bool> checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      final bluetoothScan = await Permission.bluetoothScan.status;
      if (!bluetoothScan.isGranted) {
        final scanResult = await Permission.bluetoothScan.request();
        if (!scanResult.isGranted) {
          return false;
        }
      }

      final bluetoothConnect = await Permission.bluetoothConnect.status;
      if (!bluetoothConnect.isGranted) {
        final connectResult = await Permission.bluetoothConnect.request();
        if (!connectResult.isGranted) {
          return false;
        }
      }

      final location = await Permission.locationWhenInUse.status;
      if (!location.isGranted) {
        final locationResult = await Permission.locationWhenInUse.request();
        return locationResult.isGranted;
      }

      return true;
    }

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

  static Future<bool> arePermissionsGranted() async {
    if (Platform.isAndroid) {
      final bluetoothScan = await Permission.bluetoothScan.status;
      final bluetoothConnect = await Permission.bluetoothConnect.status;
      final location = await Permission.locationWhenInUse.status;

      return bluetoothScan.isGranted &&
             bluetoothConnect.isGranted &&
             location.isGranted;
    }

    if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.status;
      return bluetooth.isGranted;
    }

    return false;
  }
}
