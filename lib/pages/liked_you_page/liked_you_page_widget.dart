import '/components/nearsy_bottom_nav_widget.dart';
import '/components/match_celebration_overlay.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'liked_you_page_model.dart';
export 'liked_you_page_model.dart';

class LikedYouPageWidget extends StatefulWidget {
  const LikedYouPageWidget({super.key});

  static String routeName = 'LikedYouPage';
  static String routePath = '/liked-you';

  @override
  State<LikedYouPageWidget> createState() => _LikedYouPageWidgetState();
}

class _LikedYouPageWidgetState extends State<LikedYouPageWidget> {
  late LikedYouPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LikedYouPageModel());
    _model.onStateChanged = () => safeSetState(() {});
    _model.onMatchFound = (userId, name, photoUrl) {
      final myProfile = SupaFlow.client.auth.currentUser;
      final myPhoto = myProfile?.userMetadata?['avatar_url']?.toString() ?? '';
      showMatchCelebration(
        context,
        myPhotoUrl: myPhoto,
        theirPhotoUrl: photoUrl,
        theirName: name,
        onSayHello: () {
          context.pushNamed(MatchesPageWidget.routeName);
        },
      );
    };
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _model.loadLikes(append: true);
    }
  }

  Widget _buildFilterChip(String filter, String label) {
    final isActive = _model.activeFilter == filter;
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? FloterTheme.of(context).primary
            : FloterTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isActive
              ? FloterTheme.of(context).primary
              : FloterTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.0),
          onTap: () => _model.setFilter(filter),
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(14.0, 8.0, 14.0, 8.0),
            child: Text(
              label,
              maxLines: 1,
              style: FloterTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FloterTheme.of(context).bodySmall.fontWeight,
                      fontStyle:
                          FloterTheme.of(context).bodySmall.fontStyle,
                    ),
                    color: isActive
                        ? FloterTheme.of(context).primaryBackground
                        : FloterTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FloterTheme.of(context).bodySmall.fontWeight,
                    fontStyle: FloterTheme.of(context).bodySmall.fontStyle,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  String _cardLabel(InboundLikeProfile profile) {
    final name = profile.displayName.trim().isNotEmpty
        ? profile.displayName.trim()
        : '';
    final age = profile.age;
    if (name.isEmpty && age == null) return '';
    if (age == null) return name;
    return '$name, $age';
  }

  Widget _buildCard(InboundLikeProfile profile) {
    final photoUrl = profile.avatarUrl ?? '';
    final hasPhoto = photoUrl.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            alignment: AlignmentDirectional(0.0, 0.0),
            children: [
              if (hasPhoto)
                CachedNetworkImage(
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  imageUrl: photoUrl,
                  width: double.infinity,
                  height: 230.0,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  width: double.infinity,
                  height: 230.0,
                  color: FloterTheme.of(context).secondaryBackground,
                  child: Icon(
                    Icons.person,
                    size: 64.0,
                    color: FloterTheme.of(context).alternate,
                  ),
                ),
              Positioned(
                left: 8.0,
                bottom: 8.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _model.passUser(profile.userId),
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(200),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: FloterTheme.of(context).error,
                          size: 28.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () => _model.likeUser(profile.userId),
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(200),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: FloterTheme.of(context).primary,
                          size: 28.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_cardLabel(profile).isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 6.0),
            child: Text(
              _cardLabel(profile),
              maxLines: 1,
              style: FloterTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FloterTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FloterTheme.of(context).bodyMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FloterTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FloterTheme.of(context).bodyMedium.fontStyle,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      23.0, 36.0, 23.0, 24.0),
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
                                  'liked_you.title',
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
                            ].divide(const SizedBox(width: 4.0)),
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
                            onPressed: () async {
                              context.pushNamed(
                                  SearchPreferencesPageWidget.routeName);
                            },
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildFilterChip(
                                'all', '${AppLabels.of(context).get('liked_you.all_filter')} ${_model.allCount}'),
                            _buildFilterChip(
                                'matches', '${AppLabels.of(context).get('liked_you.matches_filter')} ${_model.matchesCount}'),
                            _buildFilterChip(
                                'outside', '${AppLabels.of(context).get('liked_you.outside_filter')} ${_model.outsideCount}'),
                          ].divide(const SizedBox(width: 8.0)),
                        ),
                      ),
                      Expanded(
                        child: _buildContent(),
                      ),
                    ].divide(const SizedBox(height: 12.0)),
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.nearsyBottomNavModel,
                updateCallback: () => safeSetState(() {}),
                child: const NearsyBottomNavWidget(
                  activeTab: 'Liked You',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_model.isLoading && _model.profiles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_model.loadError.isNotEmpty && _model.profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _model.loadError,
              style: FloterTheme.of(context).bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () => _model.loadLikes(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_model.profiles.isEmpty) {
      return Center(
        child: Text(
          AppLabels.of(context).get('liked_you.empty'),
          style: FloterTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FloterTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
                ),
                color: FloterTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _model.loadLikes();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _model.profiles.length + (_model.isLoading ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= _model.profiles.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildCard(_model.profiles[index]);
        },
      ),
    );
  }
}
