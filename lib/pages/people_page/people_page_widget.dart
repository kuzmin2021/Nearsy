import 'dart:math' as math;

import '/components/nearsy_bottom_nav_widget.dart';
import '/components/match_celebration_overlay.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_swipeable_stack.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/custom_functions.dart' as functions;
import '/floter/hyphenation.dart';
import '/services/profile/profile_localization.dart';
import '/pages/matches_page/matches_page_widget.dart' show MatchesPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'people_page_model.dart';
export 'people_page_model.dart';

class PeoplePageWidget extends StatefulWidget {
  const PeoplePageWidget({super.key});

  static String routeName = 'PeoplePage';
  static String routePath = '/people';

  @override
  State<PeoplePageWidget> createState() => _PeoplePageWidgetState();
}

class _PeoplePageWidgetState extends State<PeoplePageWidget> {
  late PeoplePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PeoplePageModel());
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
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = _model.currentProfile;
    final showEmptyState = !_model.isLoadingProfiles &&
        _model.loadError.isEmpty &&
        profile == null;
    final nameText = () {
      final name = profile?.displayName;
      final age = profile?.age;
      final display =
          (name != null && name.trim().isNotEmpty) ? name.trim() : '[не указано]';
      return '$display${age != null ? ', $age' : ''}';
    }();
    final hasPhrase =
        profile?.catchphrase != null && profile!.catchphrase!.trim().isNotEmpty;
    return GestureDetector(
      excludeFromSemantics: true,
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
            children: [
              _topHeader(context),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, viewportConstraints) {
                    if (showEmptyState) {
                      return _buildEmptyState(context, viewportConstraints);
                    }
                    final viewportHeight = viewportConstraints.maxHeight;
                    final contentWidth = viewportConstraints.maxWidth - 48;
                    final naturalCardHeight = contentWidth / 0.57;
                    final maxCardHeight =
                        math.max(300.0, viewportHeight - 88.0);
                    final cardHeight =
                        math.min(naturalCardHeight, maxCardHeight);
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 14),
                            Text(
                              nameText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.interTight(
                                color: FloterTheme.of(context).primaryText,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                            if (hasPhrase) ...[
                              const SizedBox(height: 2),
                              Text(
                                profile.catchphrase!.trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.interTight(
                                  color: FloterTheme.of(context).primaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                            const SizedBox(height: 11),
                            SizedBox(
                              height: cardHeight,
                              child: _buildStack(context),
                            ),
                            if (profile != null) ...[
                              const SizedBox(height: 24),
                              _buildDetailRows(context, profile),
                              const SizedBox(height: 18),
                            ],
                            if (_model.loadError.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Text(
                                'Could not load nearby profiles.',
                                style: GoogleFonts.inter(
                                  color: FloterTheme.of(context).error,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              wrapWithModel(
                model: _model.nearsyBottomNavModel,
                updateCallback: () => safeSetState(() {}),
                child: const NearsyBottomNavWidget(activeTab: 'People'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(23, 36, 23, 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLabels.of(context).get('people.title'),
            style: GoogleFonts.inter(
              color: const Color(0xFF9400D3),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          FloterIconButton(
            borderRadius: 8,
            buttonSize: 40,
            fillColor: FloterTheme.of(context).primaryBackground,
            icon: Icon(
              Icons.tune,
              color: FloterTheme.of(context).primaryText,
              size: 22,
            ),
            onPressed: () async {
              await context.pushNamed('SearchPreferencesPage');
              _model.refreshProfiles();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, BoxConstraints viewportConstraints) {
    final theme = FloterTheme.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: math.max(viewportConstraints.maxHeight, 400),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 25, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Text(
                AppLabels.of(context).get('people.no_more_profiles'),
                style: GoogleFonts.interTight(
                  color: theme.primaryText,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hyphenate(AppLabels.of(context).get('people.empty_state')),
                textAlign: TextAlign.justify,
                style: GoogleFonts.inter(
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 44),
              GestureDetector(
                onTap: () async {
                  await context.pushNamed('SearchPreferencesPage');
                  _model.refreshProfiles();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB6B8BA),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLabels.of(context).get('nearby.filters'),
                        style: GoogleFonts.inter(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.none,
      child: FloterSwipeableStack(
        onSwipeFn: (candidateSwipeableStackIndex) {},
        onLeftSwipe: (candidateSwipeableStackIndex) {
          _model.swipeLeft();
        },
        onRightSwipe: (candidateSwipeableStackIndex) {
          _model.swipeRight();
        },
        onUpSwipe: (candidateSwipeableStackIndex) {},
        onDownSwipe: (candidateSwipeableStackIndex) {},
        itemBuilder: (context, index) {
          return _ProfileCard(
            key: ValueKey(index),
            profile: _model.profiles.isEmpty
                ? null
                : _model.profiles[index % _model.profiles.length],
            onTapPass: () =>
                _model.candidateSwipeableStackController.swipeLeft(),
            onTapLike: () =>
                _model.candidateSwipeableStackController.swipeRight(),
          );
        },
        itemCount: _model.profiles.isEmpty ? 3 : _model.profiles.length,
        controller: _model.candidateSwipeableStackController,
        loop: false,
        cardDisplayCount: 3,
        scale: 0.95,
        threshold: 0.35,
        maxAngle: 20,
        backCardOffset: const Offset(0, 12),
        allowedSwipeDirection:
            AllowedSwipeDirection.symmetric(horizontal: true),
        cardPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: FloterTheme.of(context).primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: FloterTheme.of(context).primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRows(BuildContext context, DiscoveryProfile profile) {
    final description = profile.description?.trim() ?? '';
    final catchphrase = profile.catchphrase?.trim() ?? '';
    final aboutText = description.isNotEmpty ? description : catchphrase;

    final rows = <Widget>[];

    void addRow(String label, String value) {
      if (value.trim().isEmpty) return;
      rows.add(_buildDetailRow(context, label: label, value: value));
    }

    addRow(
      AppLabels.of(context).get('profile.about_me'),
      aboutText,
    );

    addRow(
      AppLabels.of(context).get('profile.gender'),
      AppLabels.staticProfileLabel(
        'gender',
        canonicalProfileAttribute(profile.gender),
      ),
    );
    if (profile.age != null) {
      addRow(AppLabels.of(context).get('profile.age'), profile.age.toString());
    }
    addRow(
      AppLabels.of(context).get('people.location'),
      profile.locationLabel ?? '',
    );
    addRow(
      AppLabels.of(context).get('search_preferences.languages_they_know'),
      functions.profileLanguagesDisplay(
        (profile.languages ?? '')
            .split(RegExp(r'[,;|/]'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
      ) ?? '',
    );
    addRow(
      AppLabels.of(context).get('profile.height'),
      profile.height ?? '',
    );
    addRow(
      AppLabels.of(context).get('profile.work'),
      profile.work ?? '',
    );
    addRow(
      AppLabels.of(context).get('profile.education'),
      localizeProfileAttribute('education', profile.education),
    );
    addRow(
      AppLabels.of(context).get('profile.kids'),
      localizeProfileAttribute('kids', profile.kids),
    );
    addRow(
      AppLabels.of(context).get('profile.preferred_relationships'),
      localizeProfileAttribute('relationship_type', profile.relationshipType),
    );
    addRow(
      AppLabels.of(context).get('profile.beliefs'),
      localizeProfileAttribute('religion', profile.religion),
    );
    addRow(
      AppLabels.of(context).get('profile.body_type'),
      localizeProfileAttribute('body_type', profile.bodyType),
    );
    addRow(
      AppLabels.of(context).get('profile.drinking'),
      localizeProfileAttribute('drinking', profile.drinking),
    );
    addRow(
      AppLabels.of(context).get('profile.smoking'),
      localizeProfileAttribute('smoking', profile.smoking),
    );

    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    final attributeSection = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows.divide(
        Container(
          height: 0.5,
          color: FloterTheme.of(context).alternate,
        ),
      ),
    );

    return attributeSection;
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard({
    super.key,
    required this.profile,
    this.onTapPass,
    this.onTapLike,
  });

  final DiscoveryProfile? profile;
  final VoidCallback? onTapPass;
  final VoidCallback? onTapLike;

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  late final PageController _pageController;
  int _currentPhoto = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final theme = FloterTheme.of(context);

    final photos = profile?.photos ?? <String>[];
    final hasPhotos = photos.isNotEmpty;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasPhotos)
            GestureDetector(
              onTap: () {
                if (photos.length <= 1) return;
                if (_currentPhoto < photos.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPhoto = i),
                itemCount: photos.length,
                itemBuilder: (_, i) => SupaPhoto(
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeOutDuration: const Duration(milliseconds: 300),
                  imageSource: photos[i],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (!hasPhotos)
            Container(
              color: theme.secondaryBackground,
              alignment: const AlignmentDirectional(0, 0),
              child: Icon(
                Icons.person,
                size: 240,
                color: theme.alternate,
              ),
            ),
          if (hasPhotos && photos.length > 1)
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photos.length, (i) {
                  final isActive = i == _currentPhoto;
                  return Container(
                    width: isActive ? 24 : 8,
                    height: 4,
                    margin:
                        const EdgeInsetsDirectional.only(start: 3, end: 3),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
          if (widget.onTapPass != null)
            Positioned(
              left: 79,
              bottom: 7,
              child: _buildSwipeButton(
                'assets/images/swipe_left_icon.png',
                widget.onTapPass,
              ),
            ),
          if (widget.onTapLike != null)
            Positioned(
              right: 57,
              bottom: 7,
              child: _buildSwipeButton(
                'assets/images/swipe_right_icon.png',
                widget.onTapLike,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSwipeButton(String assetPath, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Image.asset(
          assetPath,
          width: 48,
          height: 48,
        ),
      ),
    );
  }
}
