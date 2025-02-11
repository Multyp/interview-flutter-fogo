// Local imports
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';

abstract class BluetoothScanState {
  bool get isScanning => false;
}

class BluetoothScanInitial extends BluetoothScanState {}

class BluetoothScanLoading extends BluetoothScanState {
  @override
  bool get isScanning => true;
}

class BluetoothScanLoaded extends BluetoothScanState {
  final List<BluetoothDeviceModel> devices;
  final bool _isScanning;

  BluetoothScanLoaded({
    required this.devices,
    bool isScanning = false,
  }) : _isScanning = isScanning;

  @override
  bool get isScanning => _isScanning;

  BluetoothScanLoaded copyWith({
    List<BluetoothDeviceModel>? devices,
    bool? isScanning,
  }) {
    return BluetoothScanLoaded(
      devices: devices ?? this.devices,
      isScanning: isScanning ?? _isScanning,
    );
  }
}

class BluetoothScanError extends BluetoothScanState {
  final String message;
  BluetoothScanError(this.message);
}
