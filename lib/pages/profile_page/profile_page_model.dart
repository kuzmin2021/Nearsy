import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/lookaround_bottom_nav_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  Local state fields for this page.

  String? profileDisplayName = '';

  String? profileCatchphrase = '';

  bool? showProfileNameError = true;

  String? profileMainPhotoUrl = '';

  String? profileAbout = '';

  String? profileGender = '';

  String? profileBirthday = '';

  String? profileLocation = '';

  List<String> profileLanguages = [''];
  void addToProfileLanguages(String item) => profileLanguages.add(item);
  void removeFromProfileLanguages(String item) => profileLanguages.remove(item);
  void removeAtIndexFromProfileLanguages(int index) =>
      profileLanguages.removeAt(index);
  void insertAtIndexInProfileLanguages(int index, String item) =>
      profileLanguages.insert(index, item);
  void updateProfileLanguagesAtIndex(int index, Function(String) updateFn) =>
      profileLanguages[index] = updateFn(profileLanguages[index]);

  String? profileHeight = '';

  String? profileWork = '';

  String? profileEducation = '';

  String? profileKids = '';

  String? profileRelationshipType = '';

  String? profileBeliefs = '';

  String? profileBodyType = '';

  String? profileExercise = '';

  String? profileDrinking = '';

  String? profileSmoking = '';

  List<String> profileGridSlots = [];
  void addToProfileGridSlots(String item) => profileGridSlots.add(item);
  void removeFromProfileGridSlots(String item) => profileGridSlots.remove(item);
  void removeAtIndexFromProfileGridSlots(int index) =>
      profileGridSlots.removeAt(index);
  void insertAtIndexInProfileGridSlots(int index, String item) =>
      profileGridSlots.insert(index, item);
  void updateProfileGridSlotsAtIndex(int index, Function(String) updateFn) =>
      profileGridSlots[index] = updateFn(profileGridSlots[index]);

  String? profileSelectedGridPhotoUrl = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ProfileDisplayNameField widget.
  FocusNode? profileDisplayNameFieldFocusNode;
  TextEditingController? profileDisplayNameFieldTextController;
  String? Function(BuildContext, String?)?
      profileDisplayNameFieldTextControllerValidator;
  // Stores action output result for [Backend Call - Update Row(s)] action in ProfileDisplayNameField widget.
  List<ProfilesRow>? updatedProfileDisplayNameSubmit;
  // State field(s) for ProfileCatchphraseField widget.
  FocusNode? profileCatchphraseFieldFocusNode;
  TextEditingController? profileCatchphraseFieldTextController;
  String? Function(BuildContext, String?)?
      profileCatchphraseFieldTextControllerValidator;
  // Stores action output result for [Backend Call - Update Row(s)] action in ProfileCatchphraseField widget.
  List<ProfilesRow>? updatedProfileCatchphraseSubmit;
  // Model for LookaroundBottomNav.
  late LookaroundBottomNavModel lookaroundBottomNavModel;

  @override
  void initState(BuildContext context) {
    lookaroundBottomNavModel =
        createModel(context, () => LookaroundBottomNavModel());
  }

  @override
  void dispose() {
    profileDisplayNameFieldFocusNode?.dispose();
    profileDisplayNameFieldTextController?.dispose();

    profileCatchphraseFieldFocusNode?.dispose();
    profileCatchphraseFieldTextController?.dispose();

    lookaroundBottomNavModel.dispose();
  }
}
