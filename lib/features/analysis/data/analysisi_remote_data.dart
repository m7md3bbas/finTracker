import 'package:finance_track/core/models/analysis_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalysisService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AnalysisModel?> getUserAnalysis({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await supabase.rpc(
        'get_user_analysis_by_date',
        params: {
          'uid': supabase.auth.currentUser?.id,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      print('getUserAnalysis response: $response');

      if (response == null || (response as List).isEmpty) return null;
      return AnalysisModel.fromJson(Map<String, dynamic>.from(response[0]));
    } catch (e) {
      print('Error in getUserAnalysis: $e');
      return null;
    }
  }

  Future<List<DateTime>> getAvailableDates() async {
    final response = await supabase.rpc(
      'get_transaction_dates',
      params: {'uid': supabase.auth.currentUser?.id},
    );
    if (response == null) return [];
    return (response as List).map((e) => DateTime.parse(e['tr_date'])).toList();
  }
}
