// Global imports
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:interview_flutter_fogo/core/bluetooth_exceptions.dart';

// Local imports
import 'package:interview_flutter_fogo/core/bluetooth_repository.dart';
import 'package:interview_flutter_fogo/core/permission_handler.dart';
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  @override
  Stream<List<BluetoothDeviceModel>> scanDevices() async* {
    final permissionsGranted = await BluetoothPermissionHandler.arePermissionsGranted();

    if (!permissionsGranted) {
      final permissionsRequested = await BluetoothPermissionHandler.checkAndRequestPermissions();
      if (!permissionsRequested) {
        throw BluetoothPermissionException('Bluetooth permissions not granted');
      }
    }

    if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.off) {
      throw BluetoothDisabledException('Bluetooth is turned off');
    }

    try {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

      yield* FlutterBluePlus.scanResults.map((results) {
        return results
          .where((r) => r.device.platformName.isNotEmpty) // Filter out devices with no name
          .map((r) => BluetoothDeviceModel(
            name: r.device.platformName,
            address: r.device.remoteId.toString(),
            rssi: r.rssi,
          )).toList();
      });
    } catch (e) {
      throw BluetoothScanException('Failed to scan: ${e.toString()}');
    }
  }
}