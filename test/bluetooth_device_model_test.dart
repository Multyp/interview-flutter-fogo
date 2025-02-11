import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';

void main() {
  group('BluetoothDeviceModel', () {
    test('should create BluetoothDeviceModel instance', () {
      final device = BluetoothDeviceModel(
        name: 'Test Device',
        address: '00:11:22:33:44:55',
        rssi: -70,
      );

      expect(device.name, 'Test Device');
      expect(device.address, '00:11:22:33:44:55');
      expect(device.rssi, -70);
    });

    group('signalStrength', () {
      test('should return Excellent for RSSI >= -60', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -55,
        );
        expect(device.signalStrength, 'Excellent');
      });

      test('should return Good for RSSI >= -70', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -65,
        );
        expect(device.signalStrength, 'Good');
      });

      test('should return Fair for RSSI >= -80', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -75,
        );
        expect(device.signalStrength, 'Fair');
      });

      test('should return Poor for RSSI < -80', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -85,
        );
        expect(device.signalStrength, 'Poor');
      });
    });

    group('signalColor', () {
      test('should return green for RSSI >= -60', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -55,
        );
        expect(device.signalColor, Colors.green);
      });

      test('should return lightGreen for RSSI >= -70', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -65,
        );
        expect(device.signalColor, Colors.lightGreen);
      });

      test('should return orange for RSSI >= -80', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -75,
        );
        expect(device.signalColor, Colors.orange);
      });

      test('should return red for RSSI < -80', () {
        final device = BluetoothDeviceModel(
          name: 'Test Device',
          address: '00:11:22:33:44:55',
          rssi: -85,
        );
        expect(device.signalColor, Colors.red);
      });
    });
  });
}
