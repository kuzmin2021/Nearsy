import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchCelebrationWidget extends StatefulWidget {
  const MatchCelebrationWidget({
    super.key,
    required this.matchName,
    required this.matchPhotoUrl,
    required this.myPhotoUrl,
    required this.onChat,
    required this.onDismiss,
  });

  final String matchName;
  final String matchPhotoUrl;
  final String myPhotoUrl;
  final VoidCallback onChat;
  final VoidCallback onDismiss;

  @override
  State<MatchCelebrationWidget> createState() => _MatchCelebrationWidgetState();
}

class _MatchCelebrationWidgetState extends State<MatchCelebrationWidget>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _slideController;
  late final AnimationController _photoController;
  late final Animation<double> _photoScale;
  late final Animation<double> _photoFade;
  int _currentSlide = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _photoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _photoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _photoController, curve: Curves.easeOutBack),
    );
    _photoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _photoController, curve: Curves.easeIn),
    );

    _photoController.forward();

    Future.delayed(const Duration(seconds: 2), _autoAdvance);
  }

  void _autoAdvance() {
    if (!mounted) return;
    if (_currentSlide < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() => _currentSlide++);
      Future.delayed(const Duration(seconds: 2), _autoAdvance);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  Widget _buildUserPhotos() {
    return ScaleTransition(
      scale: _photoScale,
      child: FadeTransition(
        opacity: _photoFade,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: _buildPhoto(widget.myPhotoUrl, 120.0),
            ),
            Transform.translate(
              offset: const Offset(-12.0, 0.0),
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3.0),
                    shape: BoxShape.circle,
                  ),
                  child: _buildPhoto(widget.matchPhotoUrl, 120.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(String url, double size) {
    if (url.isEmpty) {
      return Container(
        width: size,
        height: size,
        color: Colors.grey.shade300,
        child: const Icon(Icons.person, size: 64, color: Colors.grey),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
    );
  }

  Widget _buildSlideContent(int index) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF3B1F8F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            if (index == 0) ...[
              _buildUserPhotos(),
              const SizedBox(height: 24.0),
              Text(
                'MATCH!',
                style: GoogleFonts.interTight(
                  fontSize: 42.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'You and ${widget.matchName} liked each other',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
            if (index == 1)
              _buildSlideImage('assets/images/match_celebration_1.png'),
            if (index == 2)
              _buildSlideImage('assets/images/match_celebration_2.png'),
            if (index == 3) ...[
              _buildSlideImage('assets/images/match_celebration_3.png'),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: widget.onChat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 14.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Say hello',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const Spacer(flex: 1),
            GestureDetector(
              onTap: widget.onDismiss,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideImage(String assetPath) {
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      height: 300.0,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentSlide = index),
        children: [
          _buildSlideContent(0),
          _buildSlideContent(1),
          _buildSlideContent(2),
          _buildSlideContent(3),
        ],
      ),
    );
  }
}
