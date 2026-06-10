import '/backend/supabase/supabase.dart';

class ReportService {
  Future<void> submitReport({
    required String reporterId,
    required String reportedId,
    required int conversationId,
    required String details,
  }) async {
    await SupaFlow.client.from('reports').insert({
      'reporter': reporterId,
      'reported': reportedId,
      'conversation_id': conversationId,
      'details': details,
      'reason': 'user_report',
      'status': 'pending',
    });
  }
}
