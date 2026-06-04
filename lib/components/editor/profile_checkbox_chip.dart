import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';

class ProfileCheckboxChip extends StatelessWidget {
  const ProfileCheckboxChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: const AlignmentDirectional(0, 0),
              child: Stack(
                alignment: const AlignmentDirectional(0, 0),
                children: [
                  if (isSelected)
                    Container(
                      child: Icon(
                        Icons.check_box,
                        color: theme.primary,
                        size: 28,
                      ),
                    ),
                  if (!isSelected)
                    Container(
                      child: Icon(
                        Icons.check_box_outline_blank,
                        color: theme.secondaryText,
                        size: 28,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                label,
                maxLines: 1,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: theme.bodyMedium.fontWeight,
                    fontStyle: theme.bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0,
                  fontWeight: theme.bodyMedium.fontWeight,
                  fontStyle: theme.bodyMedium.fontStyle,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ].divide(const SizedBox(width: 8)),
        ),
      ),
    );
  }
}
