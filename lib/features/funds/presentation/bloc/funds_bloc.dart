import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/notification_type_enum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/fund_transaction.dart';
import '../../domain/usecases/cancel_subscription.dart';
import '../../domain/usecases/get_balance.dart';
import '../../domain/usecases/get_funds.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/subscribe_to_fund.dart';

part 'funds_event.dart';
part 'funds_state.dart';

class FundsBloc extends Bloc<FundsEvent, FundsState> {
  final GetFunds getFunds;
  final GetBalance getBalance;
  final GetTransactions getTransactions;
  final SubscribeToFund subscribeToFund;
  final CancelSubscription cancelSubscription;

  FundsBloc({
    required this.getFunds,
    required this.getBalance,
    required this.getTransactions,
    required this.subscribeToFund,
    required this.cancelSubscription,
  }) : super(const FundsState()) {
    on<LoadFundsEvent>(_onLoadFunds);
    on<SubscribeToFundRequested>(_onSubscribe);
    on<CancelSubscriptionRequestedEvent>(_onCancel);
  }

  Future<void> _onLoadFunds(
    LoadFundsEvent event,
    Emitter<FundsState> emit,
  ) async {
    emit(state.copyWith(status: FundsStatus.loading, errorMessage: null));

    final fundsResult = await getFunds(const NoParams());
    final balanceResult = await getBalance(const NoParams());
    final transactionsResult = await getTransactions(const NoParams());

    print('Funds result: ${fundsResult.isFailure}');
    if (fundsResult.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(fundsResult.failure!),
        ),
      );
      return;
    }

    print('Balance result: ${balanceResult.isFailure}');
    if (balanceResult.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(balanceResult.failure!),
        ),
      );
      return;
    }

    print('Transactions result: ${transactionsResult.isFailure}');
    if (transactionsResult.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(transactionsResult.failure!),
        ),
      );
      return;
    }

    print('Correct');

    final funds = fundsResult.value!;
    final balance = balanceResult.value!;
    final transactions = transactionsResult.value!;

    emit(
      state.copyWith(
        status: FundsStatus.success,
        funds: funds,
        balance: balance,
        transactions: transactions,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubscribe(
    SubscribeToFundRequested event,
    Emitter<FundsState> emit,
  ) async {
    emit(state.copyWith(status: FundsStatus.loading, errorMessage: null));

    final result = await subscribeToFund(
      SubscribeToFundParams(
        fundId: event.fundId,
        amount: event.amount,
        notificationMethod: event.notificationMethod,
      ),
    );

    if (result.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(result.failure!),
        ),
      );
      return;
    }

    add(const LoadFundsEvent());
  }

  Future<void> _onCancel(
    CancelSubscriptionRequestedEvent event,
    Emitter<FundsState> emit,
  ) async {
    emit(state.copyWith(status: FundsStatus.loading, errorMessage: null));

    final result = await cancelSubscription(
      CancelSubscriptionParams(fundId: event.fundId),
    );

    if (result.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(result.failure!),
        ),
      );
      return;
    }

    add(const LoadFundsEvent());
  }

  String _failureMessage(Failure failure) {
    if (failure is InvalidSubscriptionFailure) {
      return failure.message;
    }
    if (failure is InsufficientBalanceFailure) {
      return 'Saldo insuficiente';
    }

    return 'Ocurrió un error inesperado';
  }
}
