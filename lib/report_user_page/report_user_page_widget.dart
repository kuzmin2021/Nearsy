import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/services/chat_service.dart';
import '/services/report_service.dart';
import 'report_user_page_model.dart';

export 'report_user_page_model.dart';

class ReportUserPageWidget extends StatefulWidget {
  const ReportUserPageWidget({
    super.key,
    required this.conversationId,
    required this.reportedUserId,
  });

  final int conversationId;
  final String reportedUserId;

  static String routeName = 'ReportUserPage';
  static String routePath = '/report-user';

  @override
  State<ReportUserPageWidget> createState() => _ReportUserPageWidgetState();
}

class _ReportUserPageWidgetState extends State<ReportUserPageWidget> {
  late ReportUserPageModel _model;
  bool _isSubmitting = false;

  final _reportService = ReportService();

  @override
  void initState() {
    super.initState();
    _model = ReportUserPageModel(
      conversationId: widget.conversationId,
      reportedUserId: widget.reportedUserId,
    );
    _model.initState(context);
    _model.onStateChanged = () => safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final details = _model.descriptionController?.text.trim() ?? '';
    final reporterId = currentUserUid;
    if (reporterId.isEmpty || details.isEmpty) return;
    _isSubmitting = true;
    safeSetState(() {});
    try {
      await _reportService.submitReport(
        reporterId: reporterId,
        reportedId: widget.reportedUserId,
        conversationId: widget.conversationId,
        details: details,
      );
      _showThankYouDialog();
      final chatService = ChatService();
      await chatService.blockUser(reporterId, widget.reportedUserId);
      await chatService.deleteConversation(widget.conversationId);
      await chatService.deleteMatch(reporterId, widget.reportedUserId);
    } catch (_) {}
    _isSubmitting = false;
    safeSetState(() {});
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          width: 313,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 1),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLabels.of(context).get('report_user.thank_you'),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // close dialog
                    context.pop(); // go back to chats
                  },
                  child: Container(
                    width: 100,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB6B8BA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppLabels.of(context).get('report_user.ok'),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloterIconButton(
                  borderRadius: 8,
                  buttonSize: 48,
                  fillColor: theme.primaryBackground,
                  icon: Icon(
                    Icons.arrow_back,
                    color: theme.primaryText,
                    size: 24,
                  ),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: 18),
                Text(
                  AppLabels.of(context).get('report_user.title'),
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: TextFormField(
                        controller: _model.descriptionController,
                        maxLines: 10,
                                                textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                          hintText: AppLabels.of(context)
                              .get('report_user.description_hint'),
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFB6B8BA),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _isSubmitting ? null : _submitReport,
                    child: Container(
                      width: 100,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB6B8BA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              AppLabels.of(context).get('report_user.submit'),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
