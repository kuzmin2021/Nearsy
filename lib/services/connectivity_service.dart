import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void reportSuccess() {
    if (!_isOnline) {
      _isOnline = true;
      notifyListeners();
    }
  }

  void reportFailure() {
    if (_isOnline) {
      _isOnline = false;
      notifyListeners();
    }
  }
}
