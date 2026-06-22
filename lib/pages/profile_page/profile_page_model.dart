import '/backend/supabase/supabase.dart';
import '/components/nearsy_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:flutter/material.dart';

class ProfilePageModel extends FloterModel<ProfilePageWidget> {
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

  List<String> profileGridSlots = [
    '__add_photo__',
    '__empty_photo__',
    '__empty_photo__',
    '__empty_photo__',
    '__empty_photo__',
    '__empty_photo__'
  ];
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
  // Model for NearsyBottomNav.
  late NearsyBottomNavModel nearsyBottomNavModel;

  @override
  void initState(BuildContext context) {
    nearsyBottomNavModel =
        createModel(context, () => NearsyBottomNavModel());
  }

  @override
  void dispose() {
    profileDisplayNameFieldFocusNode?.dispose();
    profileDisplayNameFieldTextController?.dispose();

    profileCatchphraseFieldFocusNode?.dispose();
    profileCatchphraseFieldTextController?.dispose();

    nearsyBottomNavModel.dispose();
  }
}
