import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'chat_preferences_page_model.dart';

export 'chat_preferences_page_model.dart';

class ChatPreferencesPageWidget extends StatefulWidget {
  const ChatPreferencesPageWidget({super.key});

  static String routeName = 'ChatPreferencesPage';
  static String routePath = '/chat-preferences';

  @override
  State<ChatPreferencesPageWidget> createState() =>
      _ChatPreferencesPageWidgetState();
}

class _ChatPreferencesPageWidgetState extends State<ChatPreferencesPageWidget> {
  late ChatPreferencesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const _inactiveRingColor = Color(0xFFBDBDBD);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatPreferencesPageModel());
    _model.onStateChanged = () => safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildModeOption(
    String mode,
    String iconAsset,
    Color ringColor,
    String label,
    BuildContext context,
  ) {
    final isSelected = _model.selectedMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _model.saveChatMode(mode);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ringColor : _inactiveRingColor,
                  width: 4,
                ),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                iconAsset,
                width: 44,
                height: 44,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: _model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloterIconButton(
                        borderRadius: 8,
                        buttonSize: 48,
                        fillColor: theme.primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.primaryText,
                          size: 24,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        AppLabels.of(context).get('chat_preferences.title'),
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLabels.of(context).get(
                      'chat_preferences.choose_who_can_message_you_you_can_change_this_anytime',
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLabels.of(context).get(
                      'chat_preferences.availability_modes',
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModeOption(
                        'unavailable',
                        'assets/images/icon_chat_read.png',
                        const Color(0xFFF4442E),
                        AppLabels.of(context).get('chat_preferences.unavailable'),
                        context,
                      ),
                      _buildModeOption(
                        'matched',
                        'assets/images/icon_chat_unread.png',
                        const Color(0xFFC9B0FF),
                        AppLabels.of(context).get('chat_preferences.matched_users_only'),
                        context,
                      ),
                      _buildModeOption(
                        'available',
                        'assets/images/icon_chat_read.png',
                        const Color(0xFF34C759),
                        AppLabels.of(context).get('chat_preferences.available'),
                        context,
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
}
