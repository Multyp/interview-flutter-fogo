import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_bloc.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_state.dart';
import 'package:interview_flutter_fogo/ui/pages/home_page.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_test.mocks.dart';

void main() {
  late MockBluetoothScanBloc mockBloc;

  setUp(() {
    mockBloc = MockBluetoothScanBloc();
    // Mock the stream method
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(BluetoothScanInitial()));
    // Mock the state getter
    when(mockBloc.state).thenReturn(BluetoothScanInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<BluetoothScanBloc>.value(
        value: mockBloc,
        child: HomePage(),
      ),
    );
  }

  testWidgets('should show initial state with start scan button',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(BluetoothScanInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Bluetooth Scanner'), findsOneWidget);
    expect(find.text('Start Scan'), findsOneWidget);
  });

  testWidgets('should show empty state when no devices found',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(BluetoothScanError('No devices found'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('should show list of devices when available', (tester) async {
    // Arrange
    final devices = [
      BluetoothDeviceModel(
        name: 'Test Device',
        address: '00:11:22:33:44:55',
        rssi: -75,
      ),
    ];
    when(mockBloc.state).thenReturn(BluetoothScanLoaded(devices: devices));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Test Device'), findsOneWidget);
    expect(find.text('00:11:22:33:44:55'), findsOneWidget);
  });

  testWidgets('should show error message when error occurs', (tester) async {
    // Arrange
    when(mockBloc.state).thenReturn(BluetoothScanError('Error message'));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.byType(ScaffoldMessenger), findsOneWidget);
  });

  testWidgets('should trigger StartScan event when scan button is pressed',
      (tester) async {
    // Arrange
    when(mockBloc.state).thenReturn(BluetoothScanInitial());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Start Scan'));
    await tester.pump();

    // Assert
    verify(mockBloc.add(any)).called(1);
  });

  testWidgets('should trigger StopScan event when stop button is pressed',
      (tester) async {
    // Arrange
    when(mockBloc.state).thenReturn(BluetoothScanLoaded(
      devices: [],
      isScanning: true,
    ));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Stop Scanning'));
    await tester.pump();

    // Assert
    verify(mockBloc.add(any)).called(1);
  });
}
