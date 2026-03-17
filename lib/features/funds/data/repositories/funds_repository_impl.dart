import '../../../../core/enums/notification_type_enum.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/fund_transaction.dart';
import '../../domain/repositories/funds_repository.dart';
import '../datasources/funds_local_data_source.dart';

class FundsRepositoryImpl implements FundsRepository {
  final FundsLocalDataSource localDataSource;

  FundsRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<Fund>>> getFunds() async {
    try {
      final funds = await localDataSource.getFunds();
      return Result.success(funds);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<double>> getBalance() async {
    try {
      final balance = await localDataSource.getBalance();
      return Result.success(balance);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<FundTransaction>>> getTransactions() async {
    try {
      final transactions = await localDataSource.getTransactions();
      return Result.success(transactions);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> subscribeToFund({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  }) async {
    try {
      await localDataSource.subscribe(
        fundId: fundId,
        amount: amount,
        notificationMethod: notificationMethod,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> cancelSubscription({required String fundId}) async {
    try {
      await localDataSource.cancel(fundId: fundId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is InsufficientBalanceException) {
      return InsufficientBalanceFailure();
    }
    if (e is InvalidSubscriptionException) {
      return InvalidSubscriptionFailure(e.message);
    }

    return UnknownFailure();
  }
}
