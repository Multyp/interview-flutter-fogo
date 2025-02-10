import 'package:flutter/material.dart';

class BluetoothDeviceModel {
  final String name;
  final String address;
  final int rssi;

  BluetoothDeviceModel({
    required this.name,
    required this.address,
    required this.rssi,
  });

  String get signalStrength {
    if (rssi >= -60) return 'Excellent';
    if (rssi >= -70) return 'Good';
    if (rssi >= -80) return 'Fair';
    return 'Poor';
  }

  Color get signalColor {
    if (rssi >= -60) return Colors.green;
    if (rssi >= -70) return Colors.lightGreen;
    if (rssi >= -80) return Colors.orange;
    return Colors.red;
  }
}