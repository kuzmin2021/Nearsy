import '/components/nearsy_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'nearby_page_widget.dart' show NearbyPageWidget;
import 'package:flutter/material.dart';

class NearbyPageModel extends FloterModel<NearbyPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for NearsyBottomNav.
  late NearsyBottomNavModel nearsyBottomNavModel;

  @override
  void initState(BuildContext context) {
    nearsyBottomNavModel =
        createModel(context, () => NearsyBottomNavModel());
  }

  @override
  void dispose() {
    nearsyBottomNavModel.dispose();
  }
}
