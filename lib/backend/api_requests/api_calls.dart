import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/floter/floter_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start SupabaseAuthRest Group Code

class SupabaseAuthRestGroup {
  static String getBaseUrl() => 'https://mkmyybajywmljytduftp.supabase.co';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rbXl5YmFqeXdtbGp5dGR1ZnRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5MDkxNDcsImV4cCI6MjA5MzQ4NTE0N30.DVlVT6CgXQ7G7HHCwjqAflj_8_PxHm6FLV15jLy5yt8',
  };
  static SendMagicLinkCall sendMagicLinkCall = SendMagicLinkCall();
}

class SendMagicLinkCall {
  Future<ApiCallResponse> call({
    String? email = '',
  }) async {
    final baseUrl = SupabaseAuthRestGroup.getBaseUrl();

    final ffApiRequestBody = '''
{"email":"${email}","create_user":true}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SendMagicLink',
      apiUrl: '${baseUrl}/auth/v1/otp',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rbXl5YmFqeXdtbGp5dGR1ZnRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5MDkxNDcsImV4cCI6MjA5MzQ4NTE0N30.DVlVT6CgXQ7G7HHCwjqAflj_8_PxHm6FLV15jLy5yt8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End SupabaseAuthRest Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
