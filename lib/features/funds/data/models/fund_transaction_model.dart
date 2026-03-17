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
      id: json[_id] as String,
      fundId: json[_fundId] as String,
      fundName: json[_fundName] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json[_type],
        orElse: () => TransactionType.subscribe,
      ),
      amount: (json[_amount] as num).toDouble(),
      notificationMethod: NotificationMethod.values.firstWhere(
        (e) => e.name == json[_notificationMethod],
        orElse: () => NotificationMethod.email,
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

  static const String _id = 'id';
  static const String _fundId = 'fundId';
  static const String _fundName = 'fundName';
  static const String _type = 'type';
  static const String _amount = 'amount';
  static const String _notificationMethod = 'notificationMethod';
  static const String _createdAt = 'createdAt';
}
