import 'package:finance_track/core/models/getmonthlysummary_model.dart';
import 'package:finance_track/core/models/notification_model.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/supabase/notifications/local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationManager {
  NotificationManager._();
  static final NotificationManager _instance = NotificationManager._();
  static NotificationManager get instance => _instance;

  final LocalNotifications _localNotifications = LocalNotifications();
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> checkBudgetWarning(
    MonthlySummary summary,
    DateTime selectedTime,
  ) async {
    if (summary.monthlyBudget == null ||
        summary.monthlyBudget! <= 0 ||
        summary.remainingBudget == null) {
      return;
    }

    final budgetUsed =
        (summary.monthlyBudget! - summary.remainingBudget!) /
        summary.monthlyBudget!;
    final userId = supabaseClient.auth.currentUser?.id ?? '';
    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'budget_warning')
        .eq('meta_data->>month', selectedTime.month.toString())
        .eq('meta_data->>year', selectedTime.year.toString())
        .maybeSingle();

    if (existing != null) return;
    if (budgetUsed >= 0.8 && budgetUsed < 1.0) {
      await supabaseClient
          .from('notifications')
          .insert(
            NotificationModel(
              userId: supabaseClient.auth.currentUser?.id ?? '',
              title: 'Budget Warning',
              metaData: {
                'month': selectedTime.month,
                'year': selectedTime.year,
              },
              message:
                  'You have used over 80% of your monthly budget. Please review your expenses.',
              type: 'budget_warning',
              isRead: false,
              createdAt: DateTime.now(),
            ).toJson(),
          )
          .then(
            (value) => _localNotifications.showNotification(
              title: 'Budget Warning',
              body:
                  'You have used over 80% of your monthly budget. Please review your expenses.',
              payload: 'budget_warning',
            ),
          );
    } else if (budgetUsed >= 1.0) {
      await supabaseClient
          .from('notifications')
          .insert(
            NotificationModel(
              userId: supabaseClient.auth.currentUser?.id ?? '',
              title: 'Budget Warning',
              metaData: {
                'month': selectedTime.month,
                'year': selectedTime.year,
              },
              message:
                  'You have used over 100% of your monthly budget. Please review your expenses.',
              type: 'budget_warning',
              isRead: false,
              createdAt: DateTime.now(),
            ).toJson(),
          )
          .then(
            (value) => _localNotifications.showNotification(
              title: 'Budget Warning',
              body:
                  'You have used over 100% of your monthly budget. Please review your expenses.',
              payload: 'budget_warning',
            ),
          );
    }
  }

  Future<void> checkBudgetOverrun(
    MonthlySummary summary,
    DateTime selectedMonth,
  ) async {
    if (summary.monthlyBudget == null ||
        summary.monthlyBudget! <= 0 ||
        summary.remainingBudget == null ||
        summary.remainingBudget! >= 0) {
      return;
    }

    final overrunAmount = (summary.remainingBudget! * -1);
    final userId = supabaseClient.auth.currentUser?.id ?? '';
    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'budget_overrun')
        .eq('meta_data->>month', selectedMonth.month.toString())
        .eq('meta_data->>year', selectedMonth.year.toString())
        .maybeSingle();
    if (existing != null) return;
    await supabaseClient
        .from('notifications')
        .insert(
          NotificationModel(
            userId: supabaseClient.auth.currentUser?.id ?? '',
            title: 'Budget Overrun',
            metaData: {
              'month': selectedMonth.month,
              'year': selectedMonth.year,
              'overrunAmount': overrunAmount,
            },
            message:
                'You\'ve exceeded your budget by \$${overrunAmount.toStringAsFixed(2)} this month (${selectedMonth.year}-${selectedMonth.month}).',
            type: 'budget_overrun',
            isRead: false,
            createdAt: DateTime.now(),
          ).toJson(),
        )
        .then(
          (value) => _localNotifications.showNotification(
            title: '⚠️ Budget Alert!',
            body:
                'You\'ve exceeded your budget by \$${overrunAmount.toStringAsFixed(2)} this month (${selectedMonth.year}-${selectedMonth.month}).',
            payload: 'budget_overrun',
          ),
        );
  }

  Future<void> sendDailySummary(
    double todayExpenses,
    DateTime selectedMonth,
  ) async {
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';

    final userId = supabaseClient.auth.currentUser?.id ?? '';
    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'daily_summary')
        .eq('meta_data->>date', key)
        .maybeSingle();

    if (existing == null && todayExpenses > 0) {
      await supabaseClient.from('notifications').insert({
        'user_id': userId,
        'title': 'Daily Summary',
        'message': 'You spent \$${todayExpenses.toStringAsFixed(2)} today.',
        'meta_data': {
          'date': key,
          'month': selectedMonth.month,
          'year': selectedMonth.year,
          'expenses': todayExpenses,
        },
        'type': 'daily_summary',
        'is_read': false,
        'created_at': today.toIso8601String(),
      });
    }
  }

  Future<void> sendWeeklySummary() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final weekKey =
        '${startOfWeek.year}-${startOfWeek.month}-${startOfWeek.day}';

    final userId = supabaseClient.auth.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'weekly_summary')
        .eq('meta_data->>week_key', weekKey)
        .maybeSingle();
    if (existing != null) return;

    await supabaseClient.from('notifications').insert({
      'user_id': userId,
      'title': 'Weekly Summary',
      'message': 'Your weekly summary is ready.',
      'meta_data': {
        'week_key': weekKey,
        'start': startOfWeek.toIso8601String(),
        'end': endOfWeek.toIso8601String(),
      },
      'type': 'weekly_summary',
      'is_read': false,
      'created_at': now.toIso8601String(),
    });
  }

  Future<void> sendNewMonthNotification() async {
    final now = DateTime.now();
    final userId = supabaseClient.auth.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'new_month')
        .eq('meta_data->>month', now.month.toString())
        .eq('meta_data->>year', now.year.toString())
        .maybeSingle();
    if (existing != null) return;

    await supabaseClient.from('notifications').insert({
      'user_id': userId,
      'title': 'New Month',
      'message': 'A new month has started. Set your budget and goals.',
      'meta_data': {'month': now.month, 'year': now.year},
      'type': 'new_month',
      'is_read': false,
      'created_at': now.toIso8601String(),
    });
  }

  Future<void> sendGoalProgressNotification() async {
    final now = DateTime.now();
    final userId = supabaseClient.auth.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final dateKey = '${now.year}-${now.month}-${now.day}';
    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'goal_progress')
        .eq('meta_data->>date_key', dateKey)
        .maybeSingle();
    if (existing != null) return;

    await supabaseClient.from('notifications').insert({
      'user_id': userId,
      'title': 'Goal Progress',
      'message': 'Check your goal progress and keep it up!',
      'meta_data': {'date': now.toIso8601String(), 'date_key': dateKey},
      'type': 'goal_progress',
      'is_read': false,
      'created_at': now.toIso8601String(),
    });
  }

  Future<void> sendMilestoneNotification(String message) async {
    final now = DateTime.now();
    final userId = supabaseClient.auth.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final dateKey = '${now.year}-${now.month}-${now.day}';
    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'milestone')
        .eq('meta_data->>date_key', dateKey)
        .eq('message', message)
        .maybeSingle();
    if (existing != null) return;

    await supabaseClient.from('notifications').insert({
      'user_id': userId,
      'title': 'Milestone Reached',
      'message': message,
      'meta_data': {'date': now.toIso8601String(), 'date_key': dateKey},
      'type': 'milestone',
      'is_read': false,
      'created_at': now.toIso8601String(),
    });
  }

  Future<void> sendInactivityReminder() async {
    final now = DateTime.now();
    final userId = supabaseClient.auth.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final key = '${now.year}-${now.month}-${now.day}';
    final existing = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'inactivity')
        .eq('meta_data->>date', key)
        .maybeSingle();
    if (existing != null) return;

    await supabaseClient.from('notifications').insert({
      'user_id': userId,
      'title': 'We miss you',
      'message':
          'No recent activity detected. Log today’s expenses to stay on track.',
      'meta_data': {'date': key},
      'type': 'inactivity',
      'is_read': false,
      'created_at': now.toIso8601String(),
    });
  }

  double calculateTodayExpenses(List<TransactionModel> transactions) {
    final today = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == 'expense' &&
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
