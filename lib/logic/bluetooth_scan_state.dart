// Local imports
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';

abstract class BluetoothScanState {}

class BluetoothScanInitial extends BluetoothScanState {}

class BluetoothScanLoading extends BluetoothScanState {}

class BluetoothScanLoaded extends BluetoothScanState {
  final List<BluetoothDeviceModel> devices;
  BluetoothScanLoaded({required this.devices});
}

class BluetoothScanError extends BluetoothScanState {
  final String message;
  BluetoothScanError(this.message);
}
