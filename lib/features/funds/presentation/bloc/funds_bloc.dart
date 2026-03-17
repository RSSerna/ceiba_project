import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ceiba_project/core/errors/failures.dart';
import 'package:ceiba_project/core/usecases/usecase.dart';
import 'package:ceiba_project/features/funds/domain/usecases/cancel_subscription.dart';
import 'package:ceiba_project/features/funds/domain/usecases/get_balance.dart';
import 'package:ceiba_project/features/funds/domain/usecases/get_funds.dart';
import 'package:ceiba_project/features/funds/domain/usecases/get_transactions.dart';
import 'package:ceiba_project/features/funds/domain/usecases/subscribe_to_fund.dart';

import 'funds_event.dart';
import 'funds_state.dart';

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
    on<LoadFunds>(_onLoadFunds);
    on<SubscribeToFundRequested>(_onSubscribe);
    on<CancelSubscriptionRequested>(_onCancel);
  }

  Future<void> _onLoadFunds(LoadFunds event, Emitter<FundsState> emit) async {
    emit(state.copyWith(status: FundsStatus.loading, errorMessage: null));

    final fundsResult = await getFunds(const NoParams());
    final balanceResult = await getBalance(const NoParams());
    final transactionsResult = await getTransactions(const NoParams());

    if (fundsResult.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(fundsResult.failure!),
        ),
      );
      return;
    }

    if (balanceResult.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(balanceResult.failure!),
        ),
      );
      return;
    }

    if (transactionsResult.isFailure) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: _failureMessage(transactionsResult.failure!),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: FundsStatus.success,
        funds: fundsResult.value!,
        balance: balanceResult.value!,
        transactions: transactionsResult.value!,
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

    add(const LoadFunds());
  }

  Future<void> _onCancel(
    CancelSubscriptionRequested event,
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

    add(const LoadFunds());
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
