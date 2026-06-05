import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_page_model.dart';
export 'auth_page_model.dart';

/// Starts Email OTP and email/password authentication.
class AuthPageWidget extends StatefulWidget {
  const AuthPageWidget({super.key});

  static String routeName = 'AuthPage';
  static String routePath = '/auth';

  @override
  State<AuthPageWidget> createState() => _AuthPageWidgetState();
}

class _AuthPageWidgetState extends State<AuthPageWidget> {
  late AuthPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
          child: Container(
            width: double.infinity,
            height: 926.0,
            child: Stack(
              alignment: AlignmentDirectional(0.0, 0.0),
              children: [
                Image.asset(
                  'assets/images/start_screen_bg.png',
                  width: double.infinity,
                  height: 926.0,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 926.0,
                  decoration: BoxDecoration(
                    color: Color(0x55FFFFFF),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(42.0, 92.0, 42.0, 42.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: FloterTheme.of(context).primary,
                                size: 68.0,
                              ),
                              Text(
                                AppLabels.of(context).get(
                                  'auth.nearsy' /* Nearsy */,
                                ),
                                style: FloterTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FloterTheme.of(context)
                                            .headlineMedium
                                            .fontWeight,
                                        fontStyle: FloterTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                      color: FloterTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FloterTheme.of(context)
                                          .headlineMedium
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'auth.meet_near_keep_it_easy' /* Meet near. Keep it easy */,
                            ),
                            textAlign: TextAlign.center,
                            style: FloterTheme.of(context).titleLarge.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FloterTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .titleLarge
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                          ),
                          Container(
                            height: 44.0,
                          ),
                          FTButtonWidget(
                            onPressed: () async {
                              context.pushNamed(EmailAuthPageWidget.routeName);
                            },
                            iconData: Icons.arrow_forward,
                            text: AppLabels.of(context).get(
                              'auth.continue_with_email' /* Continue with email */,
                            ),
                            options: FTButtonOptions(
                              width: double.infinity,
                              height: 52.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  4.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFC9B0FF),
                              textStyle: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              iconSize: 20.0,
                              iconColor: Colors.black,
                              iconAlignment: IconAlignment.end,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          FTButtonWidget(
                            onPressed: () async {
                              context.pushNamed(PhoneAuthPageWidget.routeName);
                            },
                            iconData: Icons.arrow_forward,
                            text: AppLabels.of(context).get(
                              'auth.continue_with_phone' /* Continue with phone */,
                            ),
                            options: FTButtonOptions(
                              width: double.infinity,
                              height: 52.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  4.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFC9B0FF),
                              textStyle: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              iconSize: 20.0,
                              iconColor: Colors.black,
                              iconAlignment: IconAlignment.end,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          Container(
                            height: 28.0,
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'auth.by_signing_up_you_agree_to_the_terms_of' /* By signing up you agree to the... */,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: FloterTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .bodySmall
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodySmall
                                      .fontStyle,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'auth.service_and_privacy_policy' /* Service and Privacy Policy */,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: FloterTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .bodySmall
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodySmall
                                      .fontStyle,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ].divide(SizedBox(height: 16.0)),
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
