import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nearby_search_preferences_page_model.dart';
export 'nearby_search_preferences_page_model.dart';

class NearbySearchPreferencesPageWidget extends StatefulWidget {
  const NearbySearchPreferencesPageWidget({super.key});

  static String routeName = 'NearbySearchPreferencesPage';
  static String routePath = '/nearby-search-preferences';

  @override
  State<NearbySearchPreferencesPageWidget> createState() =>
      _NearbySearchPreferencesPageWidgetState();
}

class _NearbySearchPreferencesPageWidgetState
    extends State<NearbySearchPreferencesPageWidget> {
  late NearbySearchPreferencesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NearbySearchPreferencesPageModel());
    _model.onStateChanged = () => safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    final labels = AppLabels.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(24.0, 44.0, 24.0, 28.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloterIconButton(
                        borderRadius: 8.0,
                        buttonSize: 64.0,
                        fillColor: theme.primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.primaryText,
                          size: 48.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        labels.get('nearby_search_preferences.title'),
                        style: theme.titleLarge.override(
                          font: GoogleFonts.interTight(
                            fontWeight: theme.titleLarge.fontWeight,
                            fontStyle: theme.titleLarge.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: theme.titleLarge.fontWeight,
                          fontStyle: theme.titleLarge.fontStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    labels.get(
                      'nearby_search_preferences.choose_how_visible_your_location_is_you_can_change_this_anytime',
                    ),
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: theme.bodyMedium.fontWeight,
                        fontStyle: theme.bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: theme.bodyMedium.fontWeight,
                      fontStyle: theme.bodyMedium.fontStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    labels.get(
                      'nearby_search_preferences.visibility_modes',
                    ),
                    style: theme.titleSmall.override(
                      font: GoogleFonts.interTight(
                        fontWeight: theme.titleSmall.fontWeight,
                        fontStyle: theme.titleSmall.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: theme.titleSmall.fontWeight,
                      fontStyle: theme.titleSmall.fontStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildIconButton(
                        context,
                        activeAsset: 'assets/images/point_hidden_icon.png',
                        inactiveAsset:
                            'assets/images/point_hidden_icon_inactive.png',
                        selectedRingColor: Colors.red,
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.invisibleValue,
                        onTap: () {
                          setState(() {
                            _model.selectedMode =
                                NearbySearchPreferencesPageModel.invisibleValue;
                          });
                        },
                      ),
                      _buildIconButton(
                        context,
                        activeAsset:
                            'assets/images/point_shown_while_phone_on_icon.png',
                        inactiveAsset:
                            'assets/images/point_shown_while_phone_on_icon_inactive.png',
                        selectedRingColor: theme.primary,
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.visibleValue,
                        onTap: () {
                          setState(() {
                            _model.selectedMode =
                                NearbySearchPreferencesPageModel.visibleValue;
                          });
                        },
                      ),
                      _buildIconButton(
                        context,
                        activeAsset:
                            'assets/images/point_shown_always_icon.png',
                        inactiveAsset:
                            'assets/images/point_shown_always_icon_inactive.png',
                        selectedRingColor: Colors.green,
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.frozenValue,
                        onTap: () {
                          setState(() {
                            _model.selectedMode =
                                NearbySearchPreferencesPageModel.frozenValue;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(
                        context,
                        labels.get('nearby_search_preferences.invisible'),
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.invisibleValue,
                      ),
                      _buildLabel(
                        context,
                        labels.get(
                          'nearby_search_preferences.visible_while_using_the_app',
                        ),
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.visibleValue,
                      ),
                      _buildLabel(
                        context,
                        labels.get(
                          'nearby_search_preferences.your_last_location',
                        ),
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.frozenValue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required String activeAsset,
    required String inactiveAsset,
    required Color selectedRingColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const iconSize = 72.0;
    const selectedRingInset = 11.0;

    final icon = Image.asset(
      isSelected ? activeAsset : inactiveAsset,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
    );

    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Center(
            child: isSelected
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      icon,
                      Positioned.fill(
                        left: selectedRingInset,
                        top: selectedRingInset,
                        right: selectedRingInset,
                        bottom: selectedRingInset,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedRingColor,
                              width: 5.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : icon,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text,
      {bool isSelected = false}) {
    final theme = FloterTheme.of(context);

    return Expanded(
      flex: 1,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 3,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          color: theme.primaryText,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
