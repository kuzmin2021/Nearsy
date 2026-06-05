import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'matches_page_widget.dart' show MatchesPageWidget;
import 'package:flutter/material.dart';

class MatchesPageModel extends FloterModel<MatchesPageWidget> {
  ///  Local state fields for this page.

  int? conversationId = 0;

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
