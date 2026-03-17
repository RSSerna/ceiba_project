import 'package:equatable/equatable.dart';

import '../../../../core/enums/notification_type_enum.dart';

abstract class FundsEvent extends Equatable {
  const FundsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFunds extends FundsEvent {
  const LoadFunds();
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

class CancelSubscriptionRequested extends FundsEvent {
  final String fundId;

  const CancelSubscriptionRequested({required this.fundId});

  @override
  List<Object?> get props => [fundId];
}
