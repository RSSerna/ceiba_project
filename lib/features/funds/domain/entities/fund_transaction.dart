import 'package:equatable/equatable.dart';

import '../../../../core/enums/enums.dart';

/// Represents a user action against a fund (suscription/cancellation).
class FundTransaction extends Equatable {
  final String id;
  final String fundId;
  final String fundName;
  final TransactionType type;
  final double amount;
  final NotificationMethod notificationMethod;
  final DateTime createdAt;

  const FundTransaction({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.type,
    required this.amount,
    required this.notificationMethod,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    fundId,
    fundName,
    type,
    amount,
    notificationMethod,
    createdAt,
  ];
}
