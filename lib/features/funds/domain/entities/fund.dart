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

  @override
  List<Object?> get props => [id, name, category, minimumAmount];
}
