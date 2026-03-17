import '../../../../core/enums/enums.dart';
import '../../domain/entities/fund_transaction.dart';

class FundTransactionModel extends FundTransaction {
  const FundTransactionModel({
    required super.id,
    required super.fundId,
    required super.fundName,
    required super.type,
    required super.amount,
    required super.notificationMethod,
    required super.createdAt,
  });

  factory FundTransactionModel.fromJson(Map<String, dynamic> json) {
    return FundTransactionModel(
      id: json['id'] as String,
      fundId: json['fundId'] as String,
      fundName: json['fundName'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.subscribe,
      ),
      amount: (json['amount'] as num).toDouble(),
      notificationMethod: NotificationMethod.values.firstWhere(
        (e) => e.name == json['notificationMethod'],
        orElse: () => NotificationMethod.email,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundId': fundId,
      'fundName': fundName,
      'type': type.name,
      'amount': amount,
      'notificationMethod': notificationMethod.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
