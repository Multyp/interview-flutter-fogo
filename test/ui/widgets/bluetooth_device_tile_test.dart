import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';
import 'package:interview_flutter_fogo/ui/widgets/bluetooth_device_tile.dart';

void main() {
  final testDevice = BluetoothDeviceModel(
    name: 'Test Device',
    address: '00:11:22:33:44:55',
    rssi: -70,
  );

  testWidgets('renders device information correctly', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BluetoothDeviceTile(device: testDevice),
        ),
      ),
    );

    // Assert
    expect(find.text('Test Device'), findsOneWidget);
    expect(find.text('00:11:22:33:44:55'), findsOneWidget);
    expect(find.text('Signal: Good'), findsOneWidget);
    expect(find.byIcon(Icons.bluetooth_rounded), findsOneWidget);
  });

  testWidgets('calls onTap callback when tapped', (tester) async {
    // Arrange
    bool wasTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BluetoothDeviceTile(
            device: testDevice,
            onTap: () => wasTapped = true,
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.byType(BluetoothDeviceTile));
    await tester.pump();

    // Assert
    expect(wasTapped, true);
  });

  testWidgets('renders with correct styling', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BluetoothDeviceTile(device: testDevice),
        ),
      ),
    );

    // Assert
    final card = tester.widget<Card>(find.byType(Card));
    expect(card.elevation, 0);
    expect(card.color, Colors.white);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(BluetoothDeviceTile),
        matching: find.byType(Container),
      ).first,
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.blue[50]);
  });
}