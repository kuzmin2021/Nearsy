import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';

Future<void> ensureCurrentUserProfile() async {
  final userId = currentUserUid;
  if (userId.isEmpty) {
    return;
  }

  final existingProfiles = await ProfilesTable().queryRows(
    queryFn: (query) => query.eqOrNull('user_id', userId).limit(1),
  );
  if (existingProfiles.isNotEmpty) {
    return;
  }

  try {
    await ProfilesTable().insert({
      'user_id': userId,
      'email': currentUserEmail,
      'display_name': '',
      'catchphrase': '',
    });
  } catch (_) {
    // A parallel auth listener may have created the row first.
  }
}
