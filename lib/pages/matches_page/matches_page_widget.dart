import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'matches_page_model.dart';
export 'matches_page_model.dart';

/// Lists matched conversations and opens chat threads.
class MatchesPageWidget extends StatefulWidget {
  const MatchesPageWidget({super.key});

  static String routeName = 'MatchesPage';
  static String routePath = '/matches';

  @override
  State<MatchesPageWidget> createState() => _MatchesPageWidgetState();
}

class _MatchesPageWidgetState extends State<MatchesPageWidget> {
  late MatchesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MatchesPageModel());
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
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(23.0, 36.0, 23.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLabels.of(context).get(
                                    'matches.chats' /* Chats */,
                                  ),
                                  style: FloterTheme.of(context)
                                      .titleLarge
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FloterTheme.of(context)
                                                  .titleLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FloterTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                        ),
                                        color: FloterTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        fontWeight: FloterTheme.of(context)
                                            .titleLarge
                                            .fontWeight,
                                        fontStyle: FloterTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                            FloterIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              fillColor: FloterTheme.of(context)
                                  .primaryBackground,
                              icon: Icon(
                                Icons.tune,
                                color: FloterTheme.of(context).primaryText,
                                size: 22.0,
                              ),
                              onPressed: () async {
                                context.pushNamed(
                                    ChatPreferencesPageWidget.routeName);
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              ChatPageWidget.routeName,
                              queryParameters: {
                                'conversationId': serializeParam(
                                  _model.conversationId,
                                  ParamType.int,
                                ),
                              }.withoutNulls,
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(32.0),
                                    child: CachedNetworkImage(
                                      fadeInDuration: Duration(milliseconds: 0),
                                      fadeOutDuration:
                                          Duration(milliseconds: 0),
                                      imageUrl:
                                          'https://www.figma.com/api/mcp/asset/20dbdff4-2d1c-4bf5-849e-179720053bfe',
                                      width: 64.0,
                                      height: 64.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLabels.of(context).get(
                                            'skip' /* Kirill, 38 */,
                                          ),
                                          style: FloterTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FloterTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FloterTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          AppLabels.of(context).get(
                                            'matches.you_normur' /* You: Normur */,
                                          ),
                                          maxLines: 1,
                                          style: FloterTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FloterTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FloterTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FloterTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: FloterTheme.of(context)
                                        .secondaryText,
                                    size: 20.0,
                                  ),
                                  Icon(
                                    Icons.notifications,
                                    color: FloterTheme.of(context).primary,
                                    size: 20.0,
                                  ),
                                ].divide(SizedBox(width: 12.0)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(32.0),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 0),
                                    fadeOutDuration: Duration(milliseconds: 0),
                                    imageUrl:
                                        'https://www.figma.com/api/mcp/asset/fe773ad3-348a-49a7-947f-b79a5d8c4f82',
                                    width: 64.0,
                                    height: 64.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLabels.of(context).get(
                                          'skip' /* Fyodor, 45 */,
                                        ),
                                        style: FloterTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FloterTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        AppLabels.of(context).get(
                                          'matches.you_how_big_is_your' /* You: How big is your... */,
                                        ),
                                        maxLines: 1,
                                        style: FloterTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FloterTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FloterTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                  ),
                                ),
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: FloterTheme.of(context)
                                      .secondaryText,
                                  size: 20.0,
                                ),
                                Icon(
                                  Icons.notifications,
                                  color: FloterTheme.of(context).primary,
                                  size: 20.0,
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(32.0),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 0),
                                    fadeOutDuration: Duration(milliseconds: 0),
                                    imageUrl:
                                        'https://www.figma.com/api/mcp/asset/01b4e54c-459a-4795-93a0-eaa3c7d03d76',
                                    width: 64.0,
                                    height: 64.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLabels.of(context).get(
                                          'skip' /* Stepan, 29 */,
                                        ),
                                        style: FloterTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FloterTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        AppLabels.of(context).get(
                                          'matches.sure_see_you_at_bla' /* Sure, see you at bla... */,
                                        ),
                                        maxLines: 1,
                                        style: FloterTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FloterTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FloterTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                  ),
                                ),
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: FloterTheme.of(context)
                                      .secondaryText,
                                  size: 20.0,
                                ),
                                Icon(
                                  Icons.notifications,
                                  color: FloterTheme.of(context).primary,
                                  size: 20.0,
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 18.0)),
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.lookaroundBottomNavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: LookaroundBottomNavWidget(
                    activeTab: 'Chats',
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
