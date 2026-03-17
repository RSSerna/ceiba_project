import 'package:ceiba_project/core/util/utils.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/fund.dart';

class FundTile extends StatelessWidget {
  final Fund fund;
  final double subscribedAmount;
  final double balance;
  final VoidCallback onSubscribe;
  final VoidCallback? onCancel;

  const FundTile({
    super.key,
    required this.fund,
    required this.subscribedAmount,
    required this.balance,
    required this.onSubscribe,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubscription = subscribedAmount > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatFundName(fund.name),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(fund.category),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mínimo: ${formatCurrency(fund.minimumAmount)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            if (hasSubscription) ...[
              const SizedBox(height: 8),
              Text(
                'Suscrito: ${formatCurrency(subscribedAmount)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: balance >= fund.minimumAmount
                        ? onSubscribe
                        : null,
                    child: const Text('Suscribir'),
                  ),
                ),
                if (hasSubscription) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
