import '/floter/floter_util.dart';
import '/index.dart';
import 'auth_page_widget.dart' show AuthPageWidget;
import 'package:flutter/material.dart';

class AuthPageModel extends FloterModel<AuthPageWidget> {
  ///  Local state fields for this page.

  String? email = '';

  String? password = '';

  String? authMethod = 'phone';

  String? emailMode = 'signIn';

  String? phone = '';

  String? confirmPassword = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
