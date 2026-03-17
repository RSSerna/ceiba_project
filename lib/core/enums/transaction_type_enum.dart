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
}
