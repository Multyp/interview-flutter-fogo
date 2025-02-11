import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:interview_flutter_fogo/core/bluetooth_repository.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_bloc.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_event.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_state.dart';
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';

import 'bluetooth_scan_bloc_test.mocks.dart';

@GenerateMocks([BluetoothRepository])
void main() {
  late BluetoothRepository mockRepository;
  late BluetoothScanBloc bloc;

  setUp(() {
    mockRepository = MockBluetoothRepository();
    bloc = BluetoothScanBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be BluetoothScanInitial', () {
    expect(bloc.state, isA<BluetoothScanInitial>());
  });

  group('StartScan', () {
    final devices = [
      BluetoothDeviceModel(
        name: 'Test Device 1',
        address: '00:11:22:33:44:55',
        rssi: -70,
      ),
    ];

    blocTest<BluetoothScanBloc, BluetoothScanState>(
      'emits [Loading, Loaded] when scan is successful',
      build: () {
        when(mockRepository.scanDevices())
            .thenAnswer((_) => Stream.value(devices));
        return bloc;
      },
      act: (bloc) => bloc.add(StartScan()),
      expect: () => [
        isA<BluetoothScanLoading>(),
        isA<BluetoothScanLoaded>()
            .having((state) => state.devices, 'devices', devices)
            .having((state) => state.isScanning, 'isScanning', true),
      ],
    );

    blocTest<BluetoothScanBloc, BluetoothScanState>(
      'emits [Loading, Error] when scan fails',
      build: () {
        when(mockRepository.scanDevices())
            .thenAnswer((_) => Stream.error('Scan failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(StartScan()),
      expect: () => [
        isA<BluetoothScanLoading>(),
        isA<BluetoothScanError>()
            .having((state) => state.message, 'message', 'Scan failed'),
      ],
    );
  });

  group('StopScan', () {
    blocTest<BluetoothScanBloc, BluetoothScanState>(
      'updates isScanning to false when stopping scan',
      seed: () => BluetoothScanLoaded(devices: [], isScanning: true),
      build: () => bloc,
      act: (bloc) => bloc.add(StopScan()),
      expect: () => [
        isA<BluetoothScanLoaded>()
            .having((state) => state.devices, 'devices', [])
            .having((state) => state.isScanning, 'isScanning', false),
      ],
    );
  });
}
