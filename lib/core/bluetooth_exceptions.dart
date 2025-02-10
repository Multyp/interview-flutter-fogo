class BluetoothPermissionException implements Exception {
  final String message;
  BluetoothPermissionException(this.message);
}

class BluetoothDisabledException implements Exception {
  final String message;
  BluetoothDisabledException(this.message);
}

class BluetoothScanException implements Exception {
  final String message;
  BluetoothScanException(this.message);
}
