import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'contact_us_page_model.dart';

export 'contact_us_page_model.dart';

/// Figma contact us feedback form.
class ContactUsPageWidget extends StatefulWidget {
  const ContactUsPageWidget({super.key});

  static String routeName = 'ContactUsPage';
  static String routePath = '/contact-us';

  @override
  State<ContactUsPageWidget> createState() => _ContactUsPageWidgetState();
}

class _ContactUsPageWidgetState extends State<ContactUsPageWidget> {
  late ContactUsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContactUsPageModel());

    _model.contactMessageFieldTextController ??= TextEditingController();
    _model.contactMessageFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  TextStyle _bodyStyle(BuildContext context, {Color? color}) =>
      FloterTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color ?? FloterTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w400,
            fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            lineHeight: 1.2,
          );

  String get _emailValue =>
      currentUserEmail.trim().isNotEmpty ? currentUserEmail.trim() : '-';

  Future<void> _submitFeedback() async {
    final userId = currentUserUid;
    final message = _model.contactMessageFieldTextController.text.trim();
    if (_isSubmitting) {
      return;
    }
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLabels.of(context).get(
              'contact_us.message_required' /* Please enter a message. */,
            ),
          ),
          duration: const Duration(milliseconds: 3000),
        ),
      );
      return;
    }
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLabels.of(context).get(
              'contact_us.submit_error' /* Could not send feedback. */,
            ),
          ),
          duration: const Duration(milliseconds: 3000),
        ),
      );
      return;
    }

    safeSetState(() {
      _isSubmitting = true;
    });
    try {
      await SupaFlow.client.from('feedback').insert({
        'user_id': userId,
        'email': currentUserEmail,
        'message': message,
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLabels.of(context).get(
              'contact_us.submit_success' /* Thanks for your feedback. */,
            ),
          ),
          duration: const Duration(milliseconds: 3000),
        ),
      );
      context.pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLabels.of(context).get(
              'contact_us.submit_error' /* Could not send feedback. */,
            ),
          ),
          duration: const Duration(milliseconds: 3000),
        ),
      );
    } finally {
      if (mounted) {
        safeSetState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FloterTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              43.0,
              29.0,
              67.0,
              28.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloterIconButton(
                        borderRadius: 8.0,
                        buttonSize: 48.0,
                        fillColor: FloterTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FloterTheme.of(context).primaryText,
                          size: 32.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      Expanded(
                        child: Text(
                          AppLabels.of(context).get(
                            'contact_us.title' /* Contact us */,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FloterTheme.of(context).titleLarge.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FloterTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                                color: FloterTheme.of(context).primaryText,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                                fontStyle: FloterTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                                lineHeight: 1.2,
                              ),
                        ),
                      ),
                    ].divide(const SizedBox(width: 20.0)),
                  ),
                  const SizedBox(height: 34.0),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: _bodyStyle(context),
                      children: [
                        TextSpan(
                          text:
                              '${AppLabels.of(context).get('contact_us.your_email' /* Your email */)}: ',
                          style: _bodyStyle(
                            context,
                            color: FloterTheme.of(context).secondaryText,
                          ),
                        ),
                        TextSpan(text: _emailValue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17.0),
                  SizedBox(
                    height: 285.0,
                    child: TextFormField(
                      controller: _model.contactMessageFieldTextController,
                      focusNode: _model.contactMessageFieldFocusNode,
                      onChanged: (_) {
                        _model.message =
                            _model.contactMessageFieldTextController.text;
                      },
                      obscureText: false,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: AppLabels.of(context).get(
                          'contact_us.let_us_know_what_you_think' /* Let us know what you think... */,
                        ),
                        hintStyle: _bodyStyle(
                          context,
                          color: FloterTheme.of(context)
                              .primaryText
                              .withOpacity(0.5),
                        ).override(
                          fontStyle: FontStyle.italic,
                        ),
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                          15.0,
                          12.0,
                          15.0,
                          12.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FloterTheme.of(context).primaryText,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FloterTheme.of(context).primaryText,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: FloterTheme.of(context).primaryBackground,
                      ),
                      style: _bodyStyle(context),
                      validator: _model
                          .contactMessageFieldTextControllerValidator
                          .asValidator(context),
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: _isSubmitting
                        ? null
                        : () async {
                            await _submitFeedback();
                          },
                    child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9C6FF),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        AppLabels.of(context).get(
                          'contact_us.submit' /* Submit */,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _bodyStyle(context).override(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
