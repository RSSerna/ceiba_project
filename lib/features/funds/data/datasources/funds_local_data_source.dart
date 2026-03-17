import 'dart:async';

import '../../../../core/enums/enums.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/persistence_service.dart';
import '../models/fund_model.dart';
import '../models/fund_transaction_model.dart';

abstract class FundsLocalDataSource {
  Future<List<FundModel>> getFunds();
  Future<double> getBalance();
  Future<List<FundTransactionModel>> getTransactions();
  Future<void> subscribe({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  });
  Future<void> cancel({required String fundId});
}

class FundsLocalDataSourceImpl implements FundsLocalDataSource {
  final PersistenceService persistenceService;

  FundsLocalDataSourceImpl({required this.persistenceService});

  static const _initialBalance = 500000.0;

  final List<FundModel> _funds = const [
    FundModel(
      id: '1',
      name: 'FPV_BTG_PACTUAL_RECAUDADORA ',
      category: 'FPV',
      minimumAmount: 50000,
    ),
    FundModel(
      id: '2',
      name: 'FPV_BTG_PACTUAL_ECOPETROL ',
      category: 'FPV',
      minimumAmount: 100000,
    ),
    FundModel(
      id: '3',
      name: 'DEUDAPRIVADA',
      category: 'FIC',
      minimumAmount: 25000,
    ),
    FundModel(
      id: '4',
      name: 'FDO-ACCIONES',
      category: 'FIC',
      minimumAmount: 250000,
    ),
    FundModel(
      id: '5',
      name: 'FPV_BTG_PACTUAL_DINAMICA',
      category: 'FIC',
      minimumAmount: 100000,
    ),
  ];

  double _balance = _initialBalance;
  final List<FundTransactionModel> _transactions = [];
  final Map<String, double> _subscriptions = {};

  @override
  Future<List<FundModel>> getFunds() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Try to load from persistence first
    final persistedFunds = await persistenceService.loadFunds();
    if (persistedFunds.isNotEmpty) {
      return persistedFunds
          .map(
            (f) => FundModel(
              id: f.id,
              name: f.name,
              category: f.category,
              minimumAmount: f.minimumAmount,
            ),
          )
          .toList();
    }

    // If no persisted data, use default and save
    await persistenceService.saveFunds(_funds);
    return List<FundModel>.unmodifiable(_funds);
  }

  @override
  Future<double> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Try to load from persistence first
    final persistedBalance = await persistenceService.loadBalance();
    if (persistedBalance > 0) {
      _balance = persistedBalance;
      return _balance;
    }

    // If no persisted data, use default and save
    await persistenceService.saveBalance(_initialBalance);
    return _balance;
  }

  @override
  Future<List<FundTransactionModel>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Try to load from persistence first
    final persistedTransactions = await persistenceService.loadTransactions();
    if (persistedTransactions.isNotEmpty) {
      _transactions.clear();
      _transactions.addAll(
        persistedTransactions.map(
          (t) => FundTransactionModel(
            id: t.id,
            fundId: t.fundId,
            fundName: t.fundName,
            type: t.type,
            amount: t.amount,
            notificationMethod: t.notificationMethod,
            createdAt: t.createdAt,
          ),
        ),
      );
      final sorted = List<FundTransactionModel>.from(_transactions);
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sorted;
    }

    // If no persisted data, use default (empty) and save
    await persistenceService.saveTransactions(_transactions);
    return [];
  }

  @override
  Future<void> subscribe({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final fund = _funds.firstWhere(
      (it) => it.id == fundId,
      orElse: () => throw InvalidSubscriptionException('Fondo no encontrado'),
    );

    if (amount < fund.minimumAmount) {
      throw InvalidSubscriptionException(
        'El monto mínimo para este fondo es ${fund.minimumAmount.toStringAsFixed(0)}',
      );
    }

    if (amount > _balance) {
      throw InsufficientBalanceException(
        'Saldo insuficiente para hacer esta suscripción',
      );
    }

    _balance -= amount;
    _subscriptions[fundId] = (_subscriptions[fundId] ?? 0) + amount;

    _transactions.add(
      FundTransactionModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        fundId: fund.id,
        fundName: fund.name,
        type: TransactionType.subscribe,
        amount: amount,
        notificationMethod: notificationMethod,
        createdAt: DateTime.now(),
      ),
    );
    // Save updated state to persistence
    await persistenceService.saveAll(_funds, _transactions, _balance);
    print('Test');
    print(
      '${(await persistenceService.loadTransactions()).length} transactions after subscribe',
    );
  }

  @override
  Future<void> cancel({required String fundId}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final subscribedAmount = _subscriptions[fundId] ?? 0;
    if (subscribedAmount <= 0) {
      throw InvalidSubscriptionException(
        'No hay suscripción activa para este fondo',
      );
    }

    _balance += subscribedAmount;
    _subscriptions.remove(fundId);

    final fund = _funds.firstWhere(
      (it) => it.id == fundId,
      orElse: () => throw InvalidSubscriptionException('Fondo no encontrado'),
    );

    _transactions.add(
      FundTransactionModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        fundId: fund.id,
        fundName: fund.name,
        type: TransactionType.cancel,
        amount: subscribedAmount,
        notificationMethod: NotificationMethod.email,
        createdAt: DateTime.now(),
      ),
    );

    // Save updated state to persistence
    await persistenceService.saveAll(_funds, _transactions, _balance);
  }
}
