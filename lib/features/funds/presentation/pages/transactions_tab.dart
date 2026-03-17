import 'package:flutter/material.dart';

import '../../domain/entities/fund_transaction.dart';
import '../widgets/transaction_tile.dart';

class TransactionsTab extends StatelessWidget {
  final List<FundTransaction> transactions;

  const TransactionsTab({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Aún no hay transacciones.'));
    }

    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return TransactionTile(transaction: transactions[index]);
      },
    );
  }
}
