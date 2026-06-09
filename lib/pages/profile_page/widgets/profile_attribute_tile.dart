import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';

class ProfileAttributeTile extends StatelessWidget {
  const ProfileAttributeTile({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
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
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.alternate,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(9, 11, 9, 11),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  label,
                  maxLines: 2,
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
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Align(
                      alignment: const AlignmentDirectional(1, 0),
                      child: Text(
                        value,
                        maxLines: 2,
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
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.secondaryText,
                    size: 24,
                  ),
                ].divide(const SizedBox(width: 6)),
              ),
            ].divide(const SizedBox(width: 12)),
          ),
        ),
      ),
    );
  }
}
