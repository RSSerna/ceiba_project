part of 'funds_bloc.dart';

enum FundsStatus { initial, loading, success, failure }

class FundsState extends Equatable {
  final FundsStatus status;
  final List<Fund> funds;
  final double balance;
  final List<FundTransaction> transactions;
  final String? errorMessage;

  const FundsState({
    this.status = FundsStatus.initial,
    this.funds = const [],
    this.balance = 0,
    this.transactions = const [],
    this.errorMessage,
  });

  FundsState copyWith({
    FundsStatus? status,
    List<Fund>? funds,
    double? balance,
    List<FundTransaction>? transactions,
    String? errorMessage,
  }) {
    return FundsState(
      status: status ?? this.status,
      funds: funds ?? this.funds,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    funds,
    balance,
    transactions,
    errorMessage,
  ];
}
