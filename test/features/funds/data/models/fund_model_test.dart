import 'package:flutter_test/flutter_test.dart';
import 'package:ceiba_project/features/funds/data/models/fund_model.dart';

void main() {
  group('FundModel', () {
    const testFund = FundModel(
      id: '1',
      name: 'Test Fund',
      category: 'FPV',
      minimumAmount: 50000,
    );

    test('fromJson should return a valid FundModel', () {
      final json = {
        'id': '1',
        'name': 'Test Fund',
        'category': 'FPV',
        'minimumAmount': 50000,
      };

      final result = FundModel.fromJson(json);

      expect(result, testFund);
    });

    test('toJson should return a valid Map', () {
      final result = testFund.toJson();

      final expected = {
        'id': '1',
        'name': 'Test Fund',
        'category': 'FPV',
        'minimumAmount': 50000,
      };

      expect(result, expected);
    });
  });
}
