import 'package:flutter/material.dart';

import '../../../../core/util/utils.dart';
import '../../domain/entities/fund_transaction.dart';

class TransactionTile extends StatelessWidget {
  final FundTransaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: transaction.type.color.withAlpha(25),
        child: Icon(transaction.type.icon, color: transaction.type.color),
      ),
      title: Text(
        '${transaction.type.label} • ${formatFundName(transaction.fundName)}',
      ),
      subtitle: Text(
        '${formatCurrency(transaction.amount)} • ${transaction.notificationMethod.name.toUpperCase()}',
      ),
      trailing: Text(
        '${transaction.createdAt.hour.toString().padLeft(2, '0')}:${transaction.createdAt.minute.toString().padLeft(2, '0')}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
