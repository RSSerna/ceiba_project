import '../../../../core/enums/notification_type_enum.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fund.dart';
import '../entities/fund_transaction.dart';

abstract class FundsRepository {
  Future<Result<List<Fund>>> getFunds();
  Future<Result<double>> getBalance();
  Future<Result<List<FundTransaction>>> getTransactions();
  Future<Result<void>> subscribeToFund({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  });
  Future<Result<void>> cancelSubscription({required String fundId});
}
