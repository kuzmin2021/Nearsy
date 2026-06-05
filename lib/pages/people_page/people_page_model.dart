import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import 'people_page_widget.dart' show PeoplePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class PeoplePageModel extends FloterModel<PeoplePageWidget> {
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
