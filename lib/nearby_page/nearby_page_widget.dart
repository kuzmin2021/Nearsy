import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nearby_page_model.dart';
export 'nearby_page_model.dart';

/// Shows nearby visibility status and entry points for discovery preferences.
class NearbyPageWidget extends StatefulWidget {
  const NearbyPageWidget({super.key});

  static String routeName = 'NearbyPage';
  static String routePath = '/nearby';

  @override
  State<NearbyPageWidget> createState() => _NearbyPageWidgetState();
}

class _NearbyPageWidgetState extends State<NearbyPageWidget> {
  late NearbyPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NearbyPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FloterTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(23.0, 36.0, 23.0, 24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLabels.of(context).get(
                                      'nearby.title' /* Nearby */,
                                    ),
                                    style: FloterTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FloterTheme.of(context)
                                                .titleLarge
                                                .fontWeight,
                                            fontStyle: FloterTheme.of(context)
                                                .titleLarge
                                                .fontStyle,
                                          ),
                                          color:
                                              FloterTheme.of(context).primary,
                                          letterSpacing: 0.0,
                                          fontWeight: FloterTheme.of(context)
                                              .titleLarge
                                              .fontWeight,
                                          fontStyle: FloterTheme.of(context)
                                              .titleLarge
                                              .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 4.0)),
                              ),
                              FloterIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                fillColor:
                                    FloterTheme.of(context).primaryBackground,
                                icon: Icon(
                                  Icons.tune,
                                  color: FloterTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                                onPressed: () {
                                  print('NearbyFilterButton pressed ...');
                                },
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  FloterTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLabels.of(context).get(
                                      'nearby.visible_near_guboshlyopsk' /* Visible near Guboshlyopsk */,
                                    ),
                                    style: FloterTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FloterTheme.of(context)
                                                .titleSmall
                                                .fontWeight,
                                            fontStyle: FloterTheme.of(context)
                                                .titleSmall
                                                .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FloterTheme.of(context)
                                              .titleSmall
                                              .fontWeight,
                                          fontStyle: FloterTheme.of(context)
                                              .titleSmall
                                              .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    AppLabels.of(context).get(
                                      'nearby.label_1' /* Your profile is discoverable b... */,
                                    ),
                                    maxLines: 3,
                                    style: FloterTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FloterTheme.of(context)
                                                .bodyMedium
                                                .fontWeight,
                                            fontStyle: FloterTheme.of(context)
                                                .bodyMedium
                                                .fontStyle,
                                          ),
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FloterTheme.of(context)
                                              .bodyMedium
                                              .fontWeight,
                                          fontStyle: FloterTheme.of(context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: FTButtonWidget(
                                          onPressed: () async {
                                            context.pushNamed(
                                                SearchPreferencesPageWidget
                                                    .routeName);
                                          },
                                          text: AppLabels.of(context).get(
                                            'nearby.filters' /* Filters */,
                                          ),
                                          options: FTButtonOptions(
                                            width: double.infinity,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Colors.transparent,
                                            textStyle: TextStyle(
                                              color: FloterTheme.of(context)
                                                  .primary,
                                            ),
                                            borderSide: BorderSide(
                                              color: FloterTheme.of(context)
                                                  .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: FTButtonWidget(
                                          onPressed: () async {
                                            context.pushNamed(
                                                NearbySearchPreferencesPageWidget
                                                    .routeName);
                                          },
                                          text: AppLabels.of(context).get(
                                            'nearby.visibility' /* Visibility */,
                                          ),
                                          options: FTButtonOptions(
                                            width: double.infinity,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color:
                                                FloterTheme.of(context).primary,
                                            textStyle: TextStyle(
                                              color: FloterTheme.of(context)
                                                  .primaryBackground,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 10.0)),
                                  ),
                                ].divide(SizedBox(height: 10.0)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'https://www.figma.com/api/mcp/asset/d5452250-bd00-4450-b5eb-b084de000801',
                                          width: double.infinity,
                                          height: 230.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        AppLabels.of(context).get(
                                          'skip' /* Alex, 37 */,
                                        ),
                                        maxLines: 1,
                                        style: FloterTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle: FloterTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 6.0)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'https://www.figma.com/api/mcp/asset/abe7c9f2-da8a-491b-9a2c-40a4a9569dea',
                                          width: double.infinity,
                                          height: 230.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        AppLabels.of(context).get(
                                          'skip' /* Mikhail, 42 */,
                                        ),
                                        maxLines: 1,
                                        style: FloterTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle: FloterTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 6.0)),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 20.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'https://www.figma.com/api/mcp/asset/fe773ad3-348a-49a7-947f-b79a5d8c4f82',
                                          width: double.infinity,
                                          height: 230.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        AppLabels.of(context).get(
                                          'skip' /* Roman, 34 */,
                                        ),
                                        maxLines: 1,
                                        style: FloterTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle: FloterTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 6.0)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              Duration(milliseconds: 0),
                                          fadeOutDuration:
                                              Duration(milliseconds: 0),
                                          imageUrl:
                                              'https://www.figma.com/api/mcp/asset/01b4e54c-459a-4795-93a0-eaa3c7d03d76',
                                          width: double.infinity,
                                          height: 230.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        AppLabels.of(context).get(
                                          'skip' /* Denis, 39 */,
                                        ),
                                        maxLines: 1,
                                        style: FloterTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle: FloterTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 6.0)),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 20.0)),
                          ),
                        ].divide(SizedBox(height: 18.0)),
                      ),
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.lookaroundBottomNavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: LookaroundBottomNavWidget(
                    activeTab: 'Nearby',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
