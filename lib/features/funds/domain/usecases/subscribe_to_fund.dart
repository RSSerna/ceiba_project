import '../../../../core/enums/notification_type_enum.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/funds_repository.dart';

class SubscribeToFundParams {
  final String fundId;
  final double amount;
  final NotificationMethod notificationMethod;

  SubscribeToFundParams({
    required this.fundId,
    required this.amount,
    required this.notificationMethod,
  });
}

class SubscribeToFund implements UseCase<void, SubscribeToFundParams> {
  final FundsRepository subscribeRepository;

  SubscribeToFund({required this.subscribeRepository});

  @override
  Future<Result<void>> call(SubscribeToFundParams params) {
    return subscribeRepository.subscribeToFund(
      fundId: params.fundId,
      amount: params.amount,
      notificationMethod: params.notificationMethod,
    );
  }
}
