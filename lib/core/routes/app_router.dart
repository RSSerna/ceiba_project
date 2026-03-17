import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/funds/presentation/bloc/funds_bloc.dart';
import '../../../features/funds/presentation/pages/funds_page.dart';
import '../../../injection.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
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
}
