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
      appBar: AppBar(
        title: Text("Bluetooth Scanner"),
        actions: [
          BlocBuilder<BluetoothScanBloc, BluetoothScanState>(
            builder: (context, state) {
              if (state is BluetoothScanLoading) {
                return Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: BlocConsumer<BluetoothScanBloc, BluetoothScanState>(
        listener: (context, state) {
          if (state is BluetoothScanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BluetoothScanLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Scanning for devices...'),
                ],
              ),
            );
          }

          if (state is BluetoothScanLoaded) {
            if (state.devices.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth_disabled, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No devices found'),
                    SizedBox(height: 8),
                    Text(
                      'Try scanning again',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BluetoothScanBloc>().add(StartScan());
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: state.devices.length,
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
                Icon(Icons.bluetooth_searching, size: 48, color: Colors.blue),
                SizedBox(height: 16),
                Text('Press the button to start scanning'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<BluetoothScanBloc>().add(StartScan()),
        icon: Icon(Icons.bluetooth_searching),
        label: Text('Scan'),
      ),
    );
  }
}
