import 'package:finance_track/core/models/budget_model.dart';
import 'package:finance_track/core/models/getmonthlysummary_model.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class HomeServices {
  Future<List<TransactionModel>> getTransactions({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<void> addTransaction(TransactionModel transaction);

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String transactionId);

  Future<MonthlySummary> getMonthlySummary({
    required DateTime startDate,
    required DateTime endDate,
  });
}

class HomeRemoteData implements HomeServices {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<List<TransactionModel>> getTransactions({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await supabaseClient.rpc(
      'get_monthly_transactions',
      params: {
        'uid': supabaseClient.auth.currentUser!.id,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.add(Duration(days: 1)).toIso8601String(),
      },
    );
    final data = response as List;
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await supabaseClient.from('transactions').insert(transaction.toJson());
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await supabaseClient
        .from('transactions')
        .update(transaction.toJson())
        .eq('id', transaction.id ?? '');
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await supabaseClient.from('transactions').delete().eq('id', transactionId);
  }

  @override
  Future<MonthlySummary> getMonthlySummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await supabaseClient
        .rpc(
          'get_monthly_summary',
          params: {
            'uid': supabaseClient.auth.currentUser?.id,
            'start_date': startDate.toIso8601String(),
            'end_date': endDate.toIso8601String(),
          },
        )
        .select();

    if (response.isEmpty) {
      return const MonthlySummary(
        totalIncome: 0,
        totalExpense: 0,
        totalBalance: 0,
        monthlyBudget: 0,
        remainingBudget: 0,
      );
    }

    final data = response.first;
    return MonthlySummary.fromMap(data);
  }
}
