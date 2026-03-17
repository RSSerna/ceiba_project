import 'package:ceiba_project/features/funds/presentation/pages/funds_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/util/currency_input_formatter.dart';
import '../../../../core/util/utils.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/fund_transaction.dart';
import '../bloc/funds_bloc.dart';
import '../widgets/fund_tile.dart';
import '../widgets/transaction_tile.dart';

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
                          _FundsTab(state: state),
                          _TransactionsTab(transactions: state.transactions),
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

class _FundsTab extends StatelessWidget {
  final FundsState state;

  const _FundsTab({required this.state});

  double _subscribedAmount(String fundId) {
    final amount = state.transactions.fold<double>(0, (previous, transaction) {
      if (transaction.fundId != fundId) return previous;
      switch (transaction.type) {
        case TransactionType.subscribe:
          return previous + transaction.amount;
        case TransactionType.cancel:
          return previous - transaction.amount;
      }
    });

    return amount.clamp(0, double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    if (state.funds.isEmpty) {
      return const Center(child: Text('No hay fondos para mostrar'));
    }

    return ListView.builder(
      itemCount: state.funds.length,
      itemBuilder: (context, index) {
        final fund = state.funds[index];
        final subscribedAmount = _subscribedAmount(fund.id);

        return FundTile(
          fund: fund,
          subscribedAmount: subscribedAmount,
          balance: state.balance,
          onSubscribe: () => _showSubscribeDialog(context, fund),
          onCancel: subscribedAmount > 0
              ? () {
                  context.read<FundsBloc>().add(
                    CancelSubscriptionRequested(fundId: fund.id),
                  );
                }
              : null,
        );
      },
    );
  }

  Future<void> _showSubscribeDialog(BuildContext context, Fund fund) async {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    var notificationMethod = NotificationMethod.email;
    final bloc = context.read<FundsBloc>();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Suscribir a fondo'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Monto mínimo ${formatCurrency(fund.minimumAmount)}'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Monto a suscribir',
                        prefixText: 'COP \$',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un monto válido';
                        }
                        final amount = double.tryParse(
                          value.replaceAll('.', ''),
                        );
                        if (amount == null) {
                          return 'Ingresa un valor numérico';
                        }
                        if (amount < fund.minimumAmount) {
                          return 'El monto mínimo es ${formatCurrency(fund.minimumAmount)}';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    RadioGroup<NotificationMethod>(
                      groupValue: notificationMethod,
                      onChanged: (value) {
                        setState(() {
                          notificationMethod = value!;
                        });
                      },
                      child: Column(
                        children: [
                          RadioListTile<NotificationMethod>(
                            title: const Text('Email'),
                            value: NotificationMethod.email,
                          ),
                          RadioListTile<NotificationMethod>(
                            title: const Text('SMS'),
                            value: NotificationMethod.sms,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) return;
                    final amount = double.parse(
                      amountController.text.replaceAll('.', ''),
                    );
                    bloc.add(
                      SubscribeToFundRequested(
                        fundId: fund.id,
                        amount: amount,
                        notificationMethod: notificationMethod,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    ).then(
      (_) => WidgetsBinding.instance.addPostFrameCallback((_) {
        amountController.dispose();
      }),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  final List<FundTransaction> transactions;

  const _TransactionsTab({required this.transactions});

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
