import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FTAppState extends ChangeNotifier {
  static FTAppState _instance = FTAppState._internal();

  factory FTAppState() {
    return _instance;
  }

  FTAppState._internal();

  static void reset() {
    _instance = FTAppState._internal();
  }

  static const _keyLastCheckedMatchAt = 'last_checked_match_at';

  DateTime? _lastCheckedMatchAt;
  DateTime? get lastCheckedMatchAt => _lastCheckedMatchAt;

  Future initializePersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyLastCheckedMatchAt);
    if (stored != null) {
      _lastCheckedMatchAt = DateTime.tryParse(stored);
    }
  }

  Future<void> updateLastCheckedMatchAt(DateTime value) async {
    _lastCheckedMatchAt = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastCheckedMatchAt, value.toUtc().toIso8601String());
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  /// Whether the current profile can leave onboarding.
  bool _profileIsOnboarded = false;
  bool get profileIsOnboarded => _profileIsOnboarded;
  set profileIsOnboarded(bool value) {
    _profileIsOnboarded = value;
  }
}
