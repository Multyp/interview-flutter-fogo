// Global imports
import 'package:flutter/material.dart';

// Local imports
import 'package:interview_flutter_fogo/data/models/bluetooth_device_model.dart';

class BluetoothDeviceTile extends StatelessWidget {
  final BluetoothDeviceModel device;
  final VoidCallback? onTap;

  const BluetoothDeviceTile({
    super.key, 
    required this.device,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Stack(
          children: [
            Icon(Icons.bluetooth, size: 30),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: device.signalColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          device.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device.address),
            Text(
              'Signal: ${device.signalStrength}',
              style: TextStyle(color: device.signalColor),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
