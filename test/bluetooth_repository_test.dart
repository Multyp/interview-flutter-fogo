import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter_fogo/core/bluetooth_exceptions.dart';
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';
import 'package:interview_flutter_fogo/data/repositories/bluetooth_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:interview_flutter_fogo/core/bluetooth_repository.dart';
import 'package:interview_flutter_fogo/core/permission_handler.dart';

import 'bluetooth_repository_test.mocks.dart';

@GenerateMocks([
  FlutterBluePlus,
  BluetoothPermissionHandler,
  ScanResult,
  BluetoothDevice,
])
void main() {
  late BluetoothRepository repository;
  late MockBluetoothPermissionHandler mockPermissionHandler;

  setUp(() {
    mockPermissionHandler = MockBluetoothPermissionHandler();
    repository = BluetoothRepositoryImpl(permissionHandler: mockPermissionHandler);
  });

  group('scanDevices', () {
    test('throws BluetoothPermissionException when permissions not granted',
        () async {
      when(mockPermissionHandler.arePermissionsGranted())
          .thenAnswer((_) async => false);
      when(mockPermissionHandler.checkAndRequestPermissions())
          .thenAnswer((_) async => false);

      expect(
        repository.scanDevices(),
        emitsError(isA<BluetoothPermissionException>()),
      );
    });

    /*test('throws BluetoothDisabledException when bluetooth is off', () async {
      when(mockPermissionHandler.arePermissionsGranted())
          .thenAnswer((_) async => true);
      when(FlutterBluePlus.adapterState)
          .thenAnswer((_) => Stream.value(BluetoothAdapterState.off));

      expect(
        repository.scanDevices(),
        emitsError(isA<BluetoothDisabledException>()),
      );
    });

    test('emits list of BluetoothDeviceModel when scan is successful',
        () async {
      when(mockPermissionHandler.arePermissionsGranted())
          .thenAnswer((_) async => true);
      when(FlutterBluePlus.adapterState)
          .thenAnswer((_) => Stream.value(BluetoothAdapterState.on));

      final mockScanResult = MockScanResult();
      final mockDevice = MockBluetoothDevice();
      when(mockDevice.platformName).thenReturn('Test Device');
      when(mockDevice.remoteId)
          .thenReturn(DeviceIdentifier('00:11:22:33:44:55'));
      when(mockScanResult.device).thenReturn(mockDevice);
      when(mockScanResult.rssi).thenReturn(-70);

      when(FlutterBluePlus.scanResults)
          .thenAnswer((_) => Stream.value([mockScanResult]));

      expect(
        repository.scanDevices(),
        emits(
          [
            isA<BluetoothDeviceModel>()
                .having((d) => d.name, 'name', 'Test Device')
                .having((d) => d.address, 'address', '00:11:22:33:44:55')
                .having((d) => d.rssi, 'rssi', -70),
          ],
        ),
      );
    });*/
  });
}
