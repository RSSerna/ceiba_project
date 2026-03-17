import 'package:flutter_test/flutter_test.dart';
import 'package:ceiba_project/core/enums/enums.dart';
import 'package:ceiba_project/features/funds/data/models/fund_transaction_model.dart';

void main() {
  group('FundTransactionModel', () {
    final testTransaction = FundTransactionModel(
      id: '1',
      fundId: 'fund1',
      fundName: 'Test Fund',
      type: TransactionType.subscribe,
      amount: 100000,
      notificationMethod: NotificationMethod.email,
      createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
    );

    test('fromJson should return a valid FundTransactionModel', () {
      final json = {
        'id': '1',
        'fundId': 'fund1',
        'fundName': 'Test Fund',
        'type': 'subscribe',
        'amount': 100000,
        'notificationMethod': 'email',
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      final result = FundTransactionModel.fromJson(json);

      expect(result, testTransaction);
    });

    test('toJson should return a valid Map', () {
      final result = testTransaction.toJson();

      final expected = {
        'id': '1',
        'fundId': 'fund1',
        'fundName': 'Test Fund',
        'type': 'subscribe',
        'amount': 100000,
        'notificationMethod': 'email',
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      expect(result, expected);
    });
  });
}
