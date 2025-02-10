// Global imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local imports
import 'package:interview_flutter_fogo/logic/bluetooth_scan_bloc.dart';
import 'package:interview_flutter_fogo/ui/pages/home_page.dart';
import 'package:interview_flutter_fogo/data/repositories/bluetooth_repository_impl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BluetoothScanBloc(BluetoothRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
