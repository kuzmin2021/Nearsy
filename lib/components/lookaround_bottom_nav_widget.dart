import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'lookaround_bottom_nav_model.dart';
export 'lookaround_bottom_nav_model.dart';

/// Reusable bottom navigation for the main Lookaround tabs.
class LookaroundBottomNavWidget extends StatefulWidget {
  const LookaroundBottomNavWidget({
    super.key,
    String? activeTab,
  }) : this.activeTab = activeTab ?? 'Profile';

  /// Currently selected main tab label.
  final String activeTab;

  @override
  State<LookaroundBottomNavWidget> createState() =>
      _LookaroundBottomNavWidgetState();
}

class _LookaroundBottomNavWidgetState extends State<LookaroundBottomNavWidget> {
  late LookaroundBottomNavModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LookaroundBottomNavModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FTAppState>();

    return Container(
      width: double.infinity,
      height: 72.0,
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        width: double.infinity,
        height: 72.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 72.0,
                alignment: AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(ProfilePageWidget.routeName);
                  },
                  child: Container(
                    width: 64.0,
                    height: 72.0,
                    child: Container(
                      width: 64.0,
                      height: 72.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          Container(
                            width: 64.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: 48.0,
                              height: 48.0,
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  Container(
                                    width: 48.0,
                                    height: 48.0,
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.person,
                                      color: FloterTheme.of(context)
                                          .secondaryText,
                                      size: 34.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 64.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Text(
                              FTLocalizations.of(context).getText(
                                'z78wpbqh' /* Profile */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FloterTheme.of(context)
                                        .primaryText,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 72.0,
                alignment: AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (FTAppState().profileIsOnboarded) {
                      context.pushNamed(PeoplePageWidget.routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Complete your name first.',
                            style: TextStyle(),
                          ),
                          duration: Duration(milliseconds: 4000),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 72.0,
                    height: 72.0,
                    child: Container(
                      width: 72.0,
                      height: 72.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          Container(
                            width: 72.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: 72.0,
                              height: 58.0,
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  if (!(widget!.activeTab == 'People'))
                                    Container(
                                      width: 72.0,
                                      height: 58.0,
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Icon(
                                        Icons.groups,
                                        color: FloterTheme.of(context)
                                            .secondaryText,
                                        size: 40.0,
                                      ),
                                    ),
                                  if (widget!.activeTab == 'People')
                                    Container(
                                      width: 72.0,
                                      height: 58.0,
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Icon(
                                        Icons.groups,
                                        color: FloterTheme.of(context)
                                            .primary,
                                        size: 40.0,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 72.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Text(
                              FTLocalizations.of(context).getText(
                                'eecxwhyi' /* People */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FloterTheme.of(context)
                                        .primaryText,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 72.0,
                alignment: AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (FTAppState().profileIsOnboarded) {
                      context.pushNamed(NearbyPageWidget.routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Complete your name first.',
                            style: TextStyle(),
                          ),
                          duration: Duration(milliseconds: 4000),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 64.0,
                    height: 72.0,
                    child: Container(
                      width: 64.0,
                      height: 72.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          Container(
                            width: 64.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: 52.0,
                              height: 52.0,
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  Container(
                                    width: 52.0,
                                    height: 52.0,
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.near_me,
                                      color: FloterTheme.of(context)
                                          .secondaryText,
                                      size: 36.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 64.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Text(
                              FTLocalizations.of(context).getText(
                                'd57j2g66' /* Nearby */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FloterTheme.of(context)
                                        .primaryText,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 72.0,
                alignment: AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (FTAppState().profileIsOnboarded) {
                      context.pushNamed(LikedYouPageWidget.routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Complete your name first.',
                            style: TextStyle(),
                          ),
                          duration: Duration(milliseconds: 4000),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 72.0,
                    height: 72.0,
                    child: Container(
                      width: 72.0,
                      height: 72.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          Container(
                            width: 72.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: 72.0,
                              height: 58.0,
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  Container(
                                    width: 72.0,
                                    height: 58.0,
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.favorite,
                                      color: FloterTheme.of(context)
                                          .secondaryText,
                                      size: 38.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 72.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Text(
                              FTLocalizations.of(context).getText(
                                '2e6burd6' /* Liked You */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FloterTheme.of(context)
                                        .primaryText,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 72.0,
                alignment: AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (FTAppState().profileIsOnboarded) {
                      context.pushNamed(MatchesPageWidget.routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Complete your name first.',
                            style: TextStyle(),
                          ),
                          duration: Duration(milliseconds: 4000),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 72.0,
                    height: 72.0,
                    child: Container(
                      width: 72.0,
                      height: 72.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          Container(
                            width: 72.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: 72.0,
                              height: 58.0,
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  Container(
                                    width: 72.0,
                                    height: 58.0,
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.chat_bubble,
                                      color: FloterTheme.of(context)
                                          .secondaryText,
                                      size: 36.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 72.0,
                            height: 72.0,
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Text(
                              FTLocalizations.of(context).getText(
                                'js52vjp7' /* Chats */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FloterTheme.of(context)
                                        .primaryText,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
