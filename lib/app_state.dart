import 'package:flutter/material.dart';

class FTAppState extends ChangeNotifier {
  static FTAppState _instance = FTAppState._internal();

  factory FTAppState() {
    return _instance;
  }

  FTAppState._internal();

  static void reset() {
    _instance = FTAppState._internal();
  }

  Future initializePersistedState() async {}

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
