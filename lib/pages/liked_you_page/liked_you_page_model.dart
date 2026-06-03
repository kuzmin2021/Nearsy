import '/components/lookaround_bottom_nav_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'liked_you_page_widget.dart' show LikedYouPageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LikedYouPageModel extends FlutterFlowModel<LikedYouPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for LookaroundBottomNav.
  late LookaroundBottomNavModel lookaroundBottomNavModel;

  @override
  void initState(BuildContext context) {
    lookaroundBottomNavModel =
        createModel(context, () => LookaroundBottomNavModel());
  }

  @override
  void dispose() {
    lookaroundBottomNavModel.dispose();
  }
}
