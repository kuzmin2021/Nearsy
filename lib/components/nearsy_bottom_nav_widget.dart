import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'nearsy_bottom_nav_model.dart';

export 'nearsy_bottom_nav_model.dart';

class NearsyBottomNavWidget extends StatefulWidget {
  const NearsyBottomNavWidget({
    super.key,
    String? activeTab,
  }) : this.activeTab = activeTab ?? 'Profile';

  final String activeTab;

  @override
  State<NearsyBottomNavWidget> createState() =>
      _NearsyBottomNavWidgetState();
}

class _NearsyBottomNavWidgetState extends State<NearsyBottomNavWidget> {
  late NearsyBottomNavModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NearsyBottomNavModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget _navIcon(String tab, String prefix, double size) {
    final isActive = widget.activeTab == tab;
    return Image.asset(
      isActive
          ? 'assets/images/${prefix}_active.png'
          : 'assets/images/${prefix}_inactive.png',
      width: size,
      height: size,
    );
  }

  Widget _navLabel(String i18nKey, {bool isActive = false}) {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: Container(
        width: 64.0,
        padding: const EdgeInsets.only(top: 2, bottom: 3),
        alignment: AlignmentDirectional(0.0, 1.0),
        child: Text(
          AppLabels.of(context).get(i18nKey),
          textAlign: TextAlign.center,
          maxLines: 1,
          style: FloterTheme.of(context).bodySmall.override(
                font: GoogleFonts.inter(
                  fontWeight: isActive ? FontWeight.w700 : (FloterTheme.of(context).bodySmall.fontWeight ?? FontWeight.w400),
                  fontStyle: FloterTheme.of(context).bodySmall.fontStyle,
                ),
                color: FloterTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: isActive ? FontWeight.w700 : (FloterTheme.of(context).bodySmall.fontWeight ?? FontWeight.w400),
                fontStyle: FloterTheme.of(context).bodySmall.fontStyle,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTab(String tab, String prefix, double iconSize, String routeName, String i18nKey, {double labelWidth = 64.0, double iconWidth = 72.0}) {
    return Expanded(
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
              context.pushNamed(routeName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Complete your name first.', style: TextStyle()),
                  duration: Duration(milliseconds: 4000),
                ),
              );
            }
          },
          child: Container(
            width: 72.0,
            height: 72.0,
            child: Stack(
              alignment: AlignmentDirectional(0.0, 0.0),
               children: [
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: _navIcon(tab, prefix, iconSize),
                ),
                _navLabel(i18nKey, isActive: widget.activeTab == tab),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72.0,
      color: FloterTheme.of(context).primaryBackground,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab('Profile', 'icon_nav_profile', 48.0, ProfilePageWidget.routeName, 'nearsy_bottom_nav.profile'),
          _buildTab('People', 'icon_nav_people', 48.0, PeoplePageWidget.routeName, 'nearsy_bottom_nav.people'),
          _buildTab('Nearby', 'icon_nav_nearby', 52.0, NearbyPageWidget.routeName, 'nearsy_bottom_nav.nearby'),
          _buildTab('Liked You', 'icon_nav_liked', 48.0, LikedYouPageWidget.routeName, 'nearsy_bottom_nav.liked_you'),
          _buildTab('Chats', 'icon_nav_chats', 48.0, MatchesPageWidget.routeName, 'nearsy_bottom_nav.chats'),
        ],
      ),
    );
  }
}