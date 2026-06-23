import 'package:http/http.dart' as http;

import '/services/connectivity_service.dart';

class OfflineAwareHttpClient extends http.BaseClient {
  OfflineAwareHttpClient(this._inner, this._connectivity);

  final http.Client _inner;
  final ConnectivityService _connectivity;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final response = await _inner.send(request);
      _connectivity.reportSuccess();
      return response;
    } catch (_) {
      _connectivity.reportFailure();
      rethrow;
    }
  }
}
