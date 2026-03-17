import '../../domain/entities/fund.dart';

class FundModel extends Fund {
  const FundModel({
    required super.id,
    required super.name,
    required super.category,
    required super.minimumAmount,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json[_id] as String,
      name: json[_name] as String,
      category: json[_category] as String,
      minimumAmount: (json[_minimumAmount] as num).toDouble(),
    );
  }

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _category = 'category';
  static const String _minimumAmount = 'minimumAmount';
}
