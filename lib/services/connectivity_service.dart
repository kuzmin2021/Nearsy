import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/core/config/app_config.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  Timer? _timer;

  void init() {
    _check();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _check());
  }

  Future<void> _check() async {
    try {
      final response = await http
          .get(
            Uri.parse('${AppConfig.supabaseUrl}/rest/v1/'),
            headers: {'apikey': AppConfig.supabaseAnonKey},
          )
          .timeout(const Duration(seconds: 5));
      _setOnline(true);
    } catch (_) {
      _setOnline(false);
    }
  }

  void _setOnline(bool online) {
    if (online != _isOnline) {
      _isOnline = online;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
