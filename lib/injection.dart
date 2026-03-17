import 'package:get_it/get_it.dart';

import 'features/funds/data/datasources/funds_local_data_source.dart';
import 'features/funds/data/repositories/funds_repository_impl.dart';
import 'features/funds/domain/repositories/funds_repository.dart';
import 'features/funds/domain/usecases/cancel_subscription.dart';
import 'features/funds/domain/usecases/get_balance.dart';
import 'features/funds/domain/usecases/get_funds.dart';
import 'features/funds/domain/usecases/get_transactions.dart';
import 'features/funds/domain/usecases/subscribe_to_fund.dart';
import 'features/funds/presentation/bloc/funds_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Features - Funds
  getIt.registerLazySingleton<FundsLocalDataSource>(
    () => FundsLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<FundsRepository>(
    () => FundsRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<GetFunds>(
    () => GetFunds(getFundsRepository: getIt()),
  );
  getIt.registerLazySingleton<GetBalance>(
    () => GetBalance(balanceRepository: getIt()),
  );
  getIt.registerLazySingleton<GetTransactions>(
    () => GetTransactions(getTransactionsRepository: getIt()),
  );
  getIt.registerLazySingleton<SubscribeToFund>(
    () => SubscribeToFund(subscribeRepository: getIt()),
  );
  getIt.registerLazySingleton<CancelSubscription>(
    () => CancelSubscription(cancelRepository: getIt()),
  );

  getIt.registerFactory<FundsBloc>(
    () => FundsBloc(
      getFunds: getIt(),
      getBalance: getIt(),
      getTransactions: getIt(),
      subscribeToFund: getIt(),
      cancelSubscription: getIt(),
    ),
  );
}
