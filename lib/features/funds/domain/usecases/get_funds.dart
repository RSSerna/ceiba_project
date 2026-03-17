import '../../../../core/usecases/usecase.dart';
import '../entities/fund.dart';
import '../repositories/funds_repository.dart';

class GetFunds implements UseCase<List<Fund>, NoParams> {
  final FundsRepository getFundsRepository;

  GetFunds({required this.getFundsRepository});

  @override
  Future<Result<List<Fund>>> call(NoParams params) {
    return getFundsRepository.getFunds();
  }
}
