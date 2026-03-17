import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/funds/domain/entities/fund.dart';
import '../../features/funds/domain/entities/fund_transaction.dart';

class PersistenceService {
  static const String _fundsKey = 'funds';
  static const String _transactionsKey = 'transactions';
  static const String _balanceKey = 'balance';

  Future<void> saveFunds(List<Fund> funds) async {
    final prefs = await SharedPreferences.getInstance();
    final fundsJson = funds.map((f) => f.toJson()).toList();
    await prefs.setStringList(
      _fundsKey,
      fundsJson.map((e) => jsonEncode(e)).toList(),
    );
  }

  Future<List<Fund>> loadFunds() async {
    final prefs = await SharedPreferences.getInstance();
    final fundsJson = prefs.getStringList(_fundsKey) ?? [];
    return fundsJson.map((e) => Fund.fromJson(jsonDecode(e))).toList();
  }

  Future<void> saveTransactions(List<FundTransaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = transactions.map((t) => t.toJson()).toList();
    await prefs.setStringList(
      _transactionsKey,
      transactionsJson.map((e) => jsonEncode(e)).toList(),
    );
  }

  Future<List<FundTransaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];

    return transactionsJson
        .map((e) => FundTransaction.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> saveBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, balance);
  }

  Future<double> loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_balanceKey) ?? 0.0;
  }

  Future<void> saveAll(
    List<Fund> funds,
    List<FundTransaction> transactions,
    double balance,
  ) async {
    await Future.wait([
      saveFunds(funds),
      saveTransactions(transactions),
      saveBalance(balance),
    ]);
  }

  Future<Map<String, dynamic>> loadAll() async {
    final results = await Future.wait([
      loadFunds(),
      loadTransactions(),
      loadBalance(),
    ]);

    return {
      'funds': results[0] as List<Fund>,
      'transactions': results[1] as List<FundTransaction>,
      'balance': results[2] as double,
    };
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
