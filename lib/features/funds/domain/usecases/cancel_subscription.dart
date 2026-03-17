import '../../../../core/usecases/usecase.dart';
import '../repositories/funds_repository.dart';

class CancelSubscriptionParams {
  final String fundId;

  CancelSubscriptionParams({required this.fundId});
}

class CancelSubscription implements UseCase<void, CancelSubscriptionParams> {
  final FundsRepository cancelRepository;

  CancelSubscription({required this.cancelRepository});

  @override
  Future<Result<void>> call(CancelSubscriptionParams params) {
    return cancelRepository.cancelSubscription(fundId: params.fundId);
  }
}
