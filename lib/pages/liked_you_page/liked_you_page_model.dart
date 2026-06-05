import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'liked_you_page_widget.dart' show LikedYouPageWidget;
import 'package:flutter/material.dart';

class LikedYouPageModel extends FloterModel<LikedYouPageWidget> {
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
