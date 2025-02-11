// Global imports
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local imports
import 'package:interview_flutter_fogo/core/bluetooth_repository.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_event.dart';
import 'package:interview_flutter_fogo/logic/bluetooth_scan_state.dart';

class BluetoothScanBloc extends Bloc<BluetoothScanEvent, BluetoothScanState> {
  final BluetoothRepository _repository;
  StreamSubscription? _scanSubscription;

  BluetoothScanBloc(this._repository) : super(BluetoothScanInitial()) {
    on<StartScan>((event, emit) async {
      emit(BluetoothScanLoading());
      try {
        await _scanSubscription?.cancel();
        final completer = Completer<void>();
        _scanSubscription = _repository.scanDevices().listen(
          (devices) {
            if (!emit.isDone) {
              emit(BluetoothScanLoaded(devices: devices, isScanning: true));
            }
          },
          onError: (error) {
            if (!emit.isDone) {
              emit(BluetoothScanError(error.toString()));
            }
            completer.complete();
          },
          onDone: () {
            completer.complete();
          },
          cancelOnError: true,
        );
        await completer.future;
      } catch (e) {
        if (!emit.isDone) {
          emit(BluetoothScanError(e.toString()));
        }
      }
    });

    on<StopScan>((event, emit) async {
      await _scanSubscription?.cancel();
      _scanSubscription = null;

      if (state is BluetoothScanLoaded) {
        final currentState = state as BluetoothScanLoaded;
        emit(currentState.copyWith(isScanning: false));
      }
    });
  }

  @override
  Future<void> close() async {
    await _scanSubscription?.cancel();
    return super.close();
  }
}
