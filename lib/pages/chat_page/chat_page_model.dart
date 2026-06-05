import '/floter/floter_util.dart';
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';

class ChatPageModel extends FloterModel<ChatPageWidget> {
  ///  Local state fields for this page.

  String? messageText = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for MessageTextField widget.
  FocusNode? messageTextFieldFocusNode;
  TextEditingController? messageTextFieldTextController;
  String? Function(BuildContext, String?)?
      messageTextFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    messageTextFieldFocusNode?.dispose();
    messageTextFieldTextController?.dispose();
  }
}
