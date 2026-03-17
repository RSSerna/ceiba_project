import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FundsBloc>()..add(const LoadFundsEvent()),
          child: const FundsPage(),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BTG - Fondos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 25, 90, 180),
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
