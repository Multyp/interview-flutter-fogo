// Global imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local imports
import 'package:interview_flutter_fogo/logic/bluetooth_scan_bloc.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_event.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_state.dart';
import 'package:interview_flutter_fogo/ui/widgets/bluetooth_device_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<BluetoothScanBloc, BluetoothScanState>(
        listener: (context, state) {
          if (state is BluetoothScanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context, state),
                Expanded(
                  child: _buildDevicesList(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BluetoothScanState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bluetooth Scanner',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildScanButton(context, state),
        ],
      ),
    );
  }

  Widget _buildScanButton(BuildContext context, BluetoothScanState state) {
    final isScanning = state.isScanning;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (isScanning) {
            context.read<BluetoothScanBloc>().add(StopScan());
          } else {
            context.read<BluetoothScanBloc>().add(StartScan());
          }
        },
        icon: Icon(
          isScanning ? Icons.stop_rounded : Icons.bluetooth_searching_rounded,
          color: Colors.white,
        ),
        label: Text(
          isScanning ? 'Stop Scanning' : 'Start Scan',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isScanning ? Colors.red.shade400 : Colors.blue.shade500,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesList(BuildContext context, BluetoothScanState state) {
    if (state is BluetoothScanLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
            ),
            const SizedBox(height: 16),
            const Text(
              'Scanning for devices...',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (state is BluetoothScanLoaded && state.devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_disabled_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No devices found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (state is BluetoothScanLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<BluetoothScanBloc>().add(StartScan());
        },
        color: Colors.blue.shade400,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.devices.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return BluetoothDeviceTile(
              device: state.devices[index],
              onTap: () {
                // Handle device selection
              },
            );
          },
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching_rounded,
            size: 48,
            color: Colors.blue.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Start scanning to find devices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
