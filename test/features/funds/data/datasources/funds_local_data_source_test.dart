import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ceiba_project/core/enums/enums.dart';
import 'package:ceiba_project/core/errors/exceptions.dart';
import 'package:ceiba_project/core/services/persistence_service.dart';
import 'package:ceiba_project/features/funds/data/datasources/funds_local_data_source.dart';
import 'package:ceiba_project/features/funds/data/models/fund_transaction_model.dart';

import 'funds_local_data_source_test.mocks.dart';

@GenerateMocks([PersistenceService])
void main() {
  late FundsLocalDataSourceImpl dataSource;
  late MockPersistenceService mockPersistenceService;

  setUp(() {
    mockPersistenceService = MockPersistenceService();
    dataSource = FundsLocalDataSourceImpl(
      persistenceService: mockPersistenceService,
    );
  });

  group('FundsLocalDataSourceImpl', () {
    var testTransactions = [
      FundTransactionModel(
        id: '1',
        fundId: '1',
        fundName: 'Fund1',
        type: TransactionType.subscribe,
        amount: 100000,
        notificationMethod: NotificationMethod.email,
        createdAt: DateTime.now(),
      ),
    ];

    test('getFunds should return funds from persistence or default', () async {
      when(mockPersistenceService.loadFunds()).thenAnswer((_) async => []);

      final result = await dataSource.getFunds();

      expect(result, isNotEmpty);
      verify(mockPersistenceService.loadFunds()).called(1);
    });

    test(
      'getBalance should return balance from persistence or default',
      () async {
        when(mockPersistenceService.loadBalance()).thenAnswer((_) async => 0.0);

        final result = await dataSource.getBalance();

        expect(result, 500000.0);
        verify(mockPersistenceService.loadBalance()).called(1);
      },
    );

    test(
      'getTransactions should return transactions from persistence',
      () async {
        when(
          mockPersistenceService.loadTransactions(),
        ).thenAnswer((_) async => testTransactions);

        final result = await dataSource.getTransactions();

        expect(result, isNotEmpty);
        verify(mockPersistenceService.loadTransactions()).called(1);
      },
    );

    test(
      'cancel should throw InvalidSubscriptionException if no subscription',
      () async {
        expect(
          () => dataSource.cancel(fundId: '1'),
          throwsA(isA<InvalidSubscriptionException>()),
        );
      },
    );
  });
}
