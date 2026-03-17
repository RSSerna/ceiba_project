import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/utils.dart';
import '../bloc/funds_bloc.dart';
import 'funds_loading_skeleton.dart';
import 'funds_tab.dart';
import 'transactions_tab.dart';

class FundsPage extends StatelessWidget {
  const FundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BTG - Fondos'), centerTitle: true),
      body: BlocConsumer<FundsBloc, FundsState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status == FundsStatus.failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final isInitialLoading =
              state.status == FundsStatus.loading && state.funds.isEmpty;
          final showOverlay =
              state.status == FundsStatus.loading && state.funds.isNotEmpty;

          if (isInitialLoading) {
            return const FundsLoadingSkeleton();
          }

          return DefaultTabController(
            length: 2,
            child: Stack(
              children: [
                Column(
                  children: [
                    _BalanceHeader(balance: state.balance),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Fondos'),
                        Tab(text: 'Historial'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          FundsTab(state: state),
                          TransactionsTab(transactions: state.transactions),
                        ],
                      ),
                    ),
                  ],
                ),
                if (showOverlay)
                  Positioned.fill(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        color: Colors.black26,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  final double balance;

  const _BalanceHeader({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo disponible',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            formatCurrency(balance),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
