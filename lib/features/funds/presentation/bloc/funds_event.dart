part of 'funds_bloc.dart';

abstract class FundsEvent extends Equatable {
  const FundsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFundsEvent extends FundsEvent {
  const LoadFundsEvent();
}

class SubscribeToFundRequested extends FundsEvent {
  final String fundId;
  final double amount;
  final NotificationMethod notificationMethod;

  const SubscribeToFundRequested({
    required this.fundId,
    required this.amount,
    required this.notificationMethod,
  });

  @override
  List<Object?> get props => [fundId, amount, notificationMethod];
}

class CancelSubscriptionRequestedEvent extends FundsEvent {
  final String fundId;

  const CancelSubscriptionRequestedEvent({required this.fundId});

  @override
  List<Object?> get props => [fundId];
}
