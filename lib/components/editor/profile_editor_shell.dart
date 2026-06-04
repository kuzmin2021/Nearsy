import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';

class ProfileEditorShell extends StatelessWidget {
  const ProfileEditorShell({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(43, 29, 18, 34),
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
                        borderRadius: 8,
                        buttonSize: 64,
                        fillColor: theme.primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.primaryText,
                          size: 48,
                        ),
                        onPressed:
                          onBack ?? () async => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          title,
                          maxLines: 2,
                          style: theme.titleLarge.override(
                            font: GoogleFonts.interTight(
                              fontWeight: theme.titleLarge.fontWeight,
                              fontStyle: theme.titleLarge.fontStyle,
                            ),
                            letterSpacing: 0,
                            fontWeight: theme.titleLarge.fontWeight,
                            fontStyle: theme.titleLarge.fontStyle,
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(width: 8)),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20, 0, 20, 0),
                      child: Text(
                        subtitle!,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: theme.bodyMedium.fontWeight,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                          color: theme.primaryText,
                          letterSpacing: 0,
                          fontWeight: theme.bodyMedium.fontWeight,
                          fontStyle: theme.bodyMedium.fontStyle,
                        ),
                      ),
                    ),
                  const SizedBox(height: 22),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
