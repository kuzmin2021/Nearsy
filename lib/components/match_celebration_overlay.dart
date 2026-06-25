import '/floter/floter_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/supabase/supabase.dart';
import '/services/i18n/app_labels.dart';

class MatchCelebrationOverlay extends StatefulWidget {
  const MatchCelebrationOverlay({
    super.key,
    required this.myPhotoUrl,
    required this.theirPhotoUrl,
    required this.theirName,
    required this.onSayHello,
    required this.onDismiss,
  });

  final String myPhotoUrl;
  final String theirPhotoUrl;
  final String theirName;
  final VoidCallback onSayHello;
  final VoidCallback onDismiss;

  @override
  State<MatchCelebrationOverlay> createState() =>
      _MatchCelebrationOverlayState();
}

class _MatchCelebrationOverlayState extends State<MatchCelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Widget _buildMatchContent() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPhotoCircle(widget.myPhotoUrl, offset: 8.0),
              _buildPhotoCircle(widget.theirPhotoUrl, offset: -8.0),
            ],
          ),
          const SizedBox(height: 24.0),
          Text(
            AppLabels.of(context).get('match_celebration.title'),
            style: GoogleFonts.interTight(
              fontSize: 36.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '${AppLabels.of(context).get('match_celebration.you_and')} ${widget.theirName} ${AppLabels.of(context).get('match_celebration.liked_each_other')}',
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCircle(String url, {double offset = 0}) {
    const size = 120.0;
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12.0,
              offset: const Offset(0, 4.0),
            ),
          ],
        ),
        child: ClipOval(
          child: _safeNetworkImage(url),
        ),
      ),
    );
  }

  Widget _safeNetworkImage(String url) {
    if (url.isEmpty) {
      return Container(
        color: Colors.white.withValues(alpha: 0.3),
        child: const Icon(Icons.person, size: 48.0, color: Colors.white54),
      );
    }
    return SupaPhoto(
      imageSource: url,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 300),
      errorWidget: Container(
        color: Colors.white.withValues(alpha: 0.3),
        child: const Icon(Icons.person, size: 48.0, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primary.withValues(alpha: 0.9),
            theme.primary.withValues(alpha: 0.6),
            theme.secondaryBackground,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            _buildMatchContent(),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: widget.onSayHello,
                child: Text(
                  AppLabels.of(context).get('match_celebration.say_hello'),
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

void showMatchCelebration(
  BuildContext context, {
  required String myPhotoUrl,
  required String theirPhotoUrl,
  required String theirName,
  required VoidCallback onSayHello,
}) {
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => MatchCelebrationOverlay(
      myPhotoUrl: myPhotoUrl,
      theirPhotoUrl: theirPhotoUrl,
      theirName: theirName,
      onSayHello: () {
        entry.remove();
        onSayHello();
      },
      onDismiss: () {
        entry.remove();
      },
    ),
  );
  final overlay = Overlay.of(context);
  overlay.insert(entry);
}
