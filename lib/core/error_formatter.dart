class ErrorFormatter {
  static String formatBluetoothError(dynamic error) {
    if (error is String) return error;

    // Handle specific bluetooth exceptions
    if (error.toString().contains('BluetoothPermissionException')) {
      return 'Bluetooth permissions are required to scan for devices';
    }
    if (error.toString().contains('BluetoothDisabledException')) {
      return 'Please enable Bluetooth to scan for devices';
    }
    if (error.toString().contains('BluetoothScanException')) {
      return 'Failed to scan for Bluetooth devices';
    }

    // Default error message
    return 'An unexpected error occurred while scanning for devices';
  }
}
