import '../../../../core/usecases/usecase.dart';
import '../repositories/funds_repository.dart';

class GetBalance implements UseCase<double, NoParams> {
  final FundsRepository balanceRepository;

  GetBalance({required this.balanceRepository});

  @override
  Future<Result<double>> call(NoParams params) {
    return balanceRepository.getBalance();
  }
}
