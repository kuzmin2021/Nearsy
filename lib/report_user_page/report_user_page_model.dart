import 'package:flutter/material.dart';

import '/floter/floter_util.dart';

class ReportUserPageModel extends FloterModel {
  final int conversationId;
  final String reportedUserId;

  TextEditingController? descriptionController;
  VoidCallback? onStateChanged;

  ReportUserPageModel({
    required this.conversationId,
    required this.reportedUserId,
  });

  @override
  void initState(BuildContext context) {
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    descriptionController?.dispose();
  }
}
