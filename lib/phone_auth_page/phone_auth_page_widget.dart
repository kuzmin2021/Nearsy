import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'phone_auth_page_model.dart';
export 'phone_auth_page_model.dart';

/// Phone auth placeholder screen kept for future OTP work.
class PhoneAuthPageWidget extends StatefulWidget {
  const PhoneAuthPageWidget({super.key});

  static String routeName = 'PhoneAuthPage';
  static String routePath = '/auth/phone';

  @override
  State<PhoneAuthPageWidget> createState() => _PhoneAuthPageWidgetState();
}

class _PhoneAuthPageWidgetState extends State<PhoneAuthPageWidget> {
  late PhoneAuthPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PhoneAuthPageModel());
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: double.infinity,
                height: constraints.maxHeight,
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/start_screen_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x55FFFFFF),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80.0,
                      left: 42.0,
                      right: 42.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pop();
                                },
                                child: Container(
                                  width: 42.0,
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC9B0FF),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.favorite_border,
                                color: FloterTheme.of(context).primary,
                                size: 46.0,
                              ),
                            ],
                          ),
                          Container(
                            height: 20.0,
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'phone_auth.title' /* Phone auth */,
                            ),
                            style: FloterTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FloterTheme.of(context)
                                        .headlineSmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'phone_auth.label_1' /* This screen is kept in the app... */,
                            ),
                            maxLines: 2,
                            style: FloterTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                    Positioned(
                      left: 42.0,
                      right: 42.0,
                      bottom: constraints.maxHeight * 0.10,
                      child: Container(
                        height: 38.0,
                        alignment: AlignmentDirectional.centerStart,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Text(
                            '+61 | Your phone number',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
