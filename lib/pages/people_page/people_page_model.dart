import '/components/lookaround_bottom_nav_widget.dart';
import '/flutter_flow/flutter_flow_swipeable_stack.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'people_page_widget.dart' show PeoplePageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PeoplePageModel extends FlutterFlowModel<PeoplePageWidget> {
  ///  Local state fields for this page.

  String? targetUserId = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for CandidateSwipeableStack widget.
  late CardSwiperController candidateSwipeableStackController;
  // Model for LookaroundBottomNav.
  late LookaroundBottomNavModel lookaroundBottomNavModel;

  @override
  void initState(BuildContext context) {
    candidateSwipeableStackController = CardSwiperController();
    lookaroundBottomNavModel =
        createModel(context, () => LookaroundBottomNavModel());
  }

  @override
  void dispose() {
    lookaroundBottomNavModel.dispose();
  }
}
