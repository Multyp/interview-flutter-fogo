// Global imports
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';

abstract class BluetoothRepository {
  Stream<List<BluetoothDeviceModel>> scanDevices();
}
