// Automatic Floter imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'index.dart'; // Imports other custom actions
import '/floter/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/app_state.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';

Future<void> loadCurrentProfileState() async {
  final userId = currentUserUid;
  final emptySlots = <String>[
    '__add_photo__',
    '__empty_photo__',
    '__empty_photo__'
  ];

  bool validName(String? rawName) {
    final name = (rawName ?? '').trim();
    if (name.isEmpty || name.runes.length > 20) {
      return false;
    }
    return RegExp(r'[A-Za-z\u0400-\u04FF]').hasMatch(name);
  }

  String clean(String? value) => value?.trim() ?? '';

  if (userId.isEmpty) {
    FTAppState().update(() {
      FTAppState().profileIsOnboarded = false;
    });
    return;
  }

  final profiles = await ProfilesTable().queryRows(
    queryFn: (query) => query.eqOrNull('user_id', userId).limit(1),
  );
  final profile = profiles.isNotEmpty ? profiles.first : null;
  final displayName = clean(profile?.displayName);

  final photos = await UserPhotosTable().queryRows(
    queryFn: (query) => query
        .eqOrNull('user_id', userId)
        .order('slot', ascending: true)
        .order('order', ascending: true)
        .limit(6),
  );
  final slots = <String>[];
  for (final photo in photos) {
    final url = clean(photo.photoUrl);
    if (url.isNotEmpty) {
      slots.add(url);
    }
    if (slots.length >= 6) {
      break;
    }
  }
  FTAppState().profileIsOnboarded =
      validName(displayName) && (profile?.isOnboarded ?? false);
}
