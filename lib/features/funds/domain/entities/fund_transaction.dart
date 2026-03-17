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

  factory FundTransaction.fromJson(Map<String, dynamic> json) {
    return FundTransaction(
      id: json[_id] as String,
      fundId: json[_fundId] as String,
      fundName: json[_fundName] as String,
      type: TransactionType.fromName(json[_type] as String),
      amount: (json[_amount] as num).toDouble(),
      notificationMethod: NotificationMethodExtension.fromString(
        json[_notificationMethod] as String,
      ),
      createdAt: DateTime.parse(json[_createdAt] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _id: id,
      _fundId: fundId,
      _fundName: fundName,
      _type: type.name,
      _amount: amount,
      _notificationMethod: notificationMethod.name,
      _createdAt: createdAt.toIso8601String(),
    };
  }

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

  static const String _id = 'id';
  static const String _fundId = 'fundId';
  static const String _fundName = 'fundName';
  static const String _type = 'type';
  static const String _amount = 'amount';
  static const String _notificationMethod = 'notificationMethod';
  static const String _createdAt = 'createdAt';
}
