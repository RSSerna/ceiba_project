import 'package:flutter/material.dart' show IconData, Icons, Color, Colors;

enum TransactionType {
  subscribe(
    label: 'Suscripción',
    icon: Icons.add_circle_outline,
    color: Colors.green,
  ),
  cancel(
    label: 'Cancelación',
    icon: Icons.remove_circle_outline,
    color: Colors.red,
  );

  const TransactionType({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  static TransactionType fromName(String name) {
    return TransactionType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('No TransactionType with name $name'),
    );
  }
}
