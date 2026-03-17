import 'package:ceiba_project/core/enums/enums.dart';
import 'package:ceiba_project/core/services/persistence_service.dart';
import 'package:ceiba_project/features/funds/domain/entities/fund.dart';
import 'package:ceiba_project/features/funds/domain/entities/fund_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PersistenceService persistenceService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    persistenceService = PersistenceService();
  });

  group('PersistenceService', () {
    const testFunds = [
      Fund(id: '1', name: 'Fund1', category: 'FPV', minimumAmount: 50000),
    ];

    final testTransactions = [
      FundTransaction(
        id: '1',
        fundId: '1',
        fundName: 'Fund1',
        type: TransactionType.subscribe,
        amount: 100000,
        notificationMethod: NotificationMethod.email,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      ),
    ];

    const testBalance = 500000.0;

    test('saveFunds and loadFunds should persist funds', () async {
      await persistenceService.saveFunds(testFunds);

      final loaded = await persistenceService.loadFunds();

      expect(loaded, testFunds);
    });

    test(
      'saveTransactions and loadTransactions should persist transactions',
      () async {
        await persistenceService.clearAll();
        await persistenceService.saveTransactions(testTransactions);

        final loaded = await persistenceService.loadTransactions();

        expect(loaded, testTransactions);
      },
    );

    test('saveBalance and loadBalance should persist balance', () async {
      await persistenceService.saveBalance(testBalance);

      final loaded = await persistenceService.loadBalance();

      expect(loaded, testBalance);
    });
  });
}
