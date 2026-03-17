import 'package:equatable/equatable.dart';

/// Represents an investment fund available for subscription.
class Fund extends Equatable {
  final String id;
  final String name;
  final String category;
  final double minimumAmount;

  const Fund({
    required this.id,
    required this.name,
    required this.category,
    required this.minimumAmount,
  });

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      minimumAmount: (json['minimumAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'minimumAmount': minimumAmount,
    };
  }

  @override
  List<Object?> get props => [id, name, category, minimumAmount];
}
