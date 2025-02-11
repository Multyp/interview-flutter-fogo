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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: BlocConsumer<BluetoothScanBloc, BluetoothScanState>(
          listener: (context, state) {
            if (state is BluetoothScanError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red[400],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(16),
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: Text(
                    'Bluetooth Devices',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  backgroundColor: Colors.grey[100],
                  elevation: 0,
                  actions: [
                    if (state is BluetoothScanLoading)
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue[400]!,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: _buildBody(context, state),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _buildScanButton(context),
    );
  }

  Widget _buildBody(BuildContext context, BluetoothScanState state) {
    if (state is BluetoothScanLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
              ),
              SizedBox(height: 24),
              Text(
                'Scanning for devices...',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is BluetoothScanLoaded) {
      if (state.devices.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            child: Column(
              children: [
                Icon(
                  Icons.bluetooth_disabled_rounded,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 24),
                Text(
                  'No devices found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pull down to refresh',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<BluetoothScanBloc>().add(StartScan());
        },
        color: Colors.blue[400],
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 100),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Column(
          children: [
            Icon(
              Icons.bluetooth_searching_rounded,
              size: 64,
              color: Colors.blue[400],
            ),
            SizedBox(height: 24),
            Text(
              'Start Scanning',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: BlocBuilder<BluetoothScanBloc, BluetoothScanState>(
        builder: (context, state) {
          final bool isScanning = state.isScanning;

          return FloatingActionButton.extended(
            onPressed: () {
              if (isScanning) {
                context.read<BluetoothScanBloc>().add(StopScan());
              } else {
                context.read<BluetoothScanBloc>().add(StartScan());
              }
            },
            icon: Icon(
              isScanning 
                  ? Icons.stop_rounded
                  : Icons.bluetooth_searching_rounded,
            ),
            label: Text(isScanning ? 'Stop' : 'Scan'),
            elevation: 2,
            backgroundColor: isScanning ? Colors.red[400] : Colors.blue[400],
          );
        },
      ),
    );
  }
}
