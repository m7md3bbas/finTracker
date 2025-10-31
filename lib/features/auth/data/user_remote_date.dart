import 'package:finance_track/core/models/budget_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRemoteDate {
  final supabaseClient = Supabase.instance.client;
  get user => supabaseClient.auth.currentUser;

  Future<void> addBudget(BudgetModel budget) async {
    await supabaseClient.from('budgets').insert(budget.toJson());
  }

  Future<BudgetModel?> getBudget(String userId, int month, int year) async {
    final res = await supabaseClient
        .from('budgets')
        .select()
        .eq('user_id', userId)
        .eq('month', month)
        .eq('year', year)
        .maybeSingle();

    if (res == null) return null;
    return BudgetModel.fromJson(res);
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await supabaseClient
        .from('budgets')
        .update({'amount': budget.amount})
        .eq('user_id', budget.userId)
        .eq('month', budget.month)
        .eq('year', budget.year);
  }

  Future<void> deleteBudget(String budgetId) async {
    await supabaseClient.from('budgets').delete().eq('id', budgetId);
  }

  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
