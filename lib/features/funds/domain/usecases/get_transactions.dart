import '../../../../core/usecases/usecase.dart';
import '../entities/fund_transaction.dart';
import '../repositories/funds_repository.dart';

class GetTransactions implements UseCase<List<FundTransaction>, NoParams> {
  final FundsRepository getTransactionsRepository;

  GetTransactions({required this.getTransactionsRepository});

  @override
  Future<Result<List<FundTransaction>>> call(NoParams params) {
    return getTransactionsRepository.getTransactions();
  }
}
