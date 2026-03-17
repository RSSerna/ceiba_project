import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/util/currency_input_formatter.dart';
import '../../../../core/util/utils.dart';
import '../../domain/entities/fund.dart';
import '../bloc/funds_bloc.dart';
import '../widgets/fund_tile.dart';

class FundsTab extends StatelessWidget {
  final FundsState state;

  const FundsTab({super.key, required this.state});

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
                    CancelSubscriptionRequestedEvent(fundId: fund.id),
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
