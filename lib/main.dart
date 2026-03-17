import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';
import 'features/funds/presentation/bloc/funds_bloc.dart';
import 'features/funds/presentation/pages/funds_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const CeibaApp());
}

class CeibaApp extends StatelessWidget {
  const CeibaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTG - Fondos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 25, 90, 180),
        ),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => getIt<FundsBloc>()..add(const LoadFunds()),
        child: const FundsPage(),
      ),
    );
  }
}
