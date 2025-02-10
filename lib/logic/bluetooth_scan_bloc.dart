// Global imports
import 'package:flutter_bloc/flutter_bloc.dart';

// Local imports
import 'package:interview_flutter_fogo/core/bluetooth_repository.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_event.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_state.dart';

class BluetoothScanBloc extends Bloc<BluetoothScanEvent, BluetoothScanState> {
  final BluetoothRepository _repository;

  BluetoothScanBloc(this._repository) : super(BluetoothScanInitial()) {
    on<StartScan>((event, emit) async {
      emit(BluetoothScanLoading());
      try {
        await emit.forEach(
          _repository.scanDevices(),
          onData: (devices) => BluetoothScanLoaded(devices: devices),
          onError: (error, _) => BluetoothScanError(error.toString()),
        );
      } catch (e) {
        emit(BluetoothScanError(e.toString()));
      }
    });
  }
}
