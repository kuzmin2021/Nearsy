import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';

class ProfileOption {
  final String value;
  final String label;

  const ProfileOption({required this.value, required this.label});
}

class ProfileRadioSelector extends StatelessWidget {
  const ProfileRadioSelector({
    super.key,
    required this.options,
    required this.currentValue,
    required this.onChanged,
  });

  final List<ProfileOption> options;
  final String? currentValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    return Container(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: options
                  .map((option) {
                    final isSelected = currentValue == option.value;
                    return InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => onChanged(option.value),
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
                                        Icons.radio_button_checked,
                                        color: theme.primary,
                                        size: 28,
                                      ),
                                    ),
                                  if (!isSelected)
                                    Container(
                                      child: Icon(
                                        Icons.radio_button_unchecked,
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
                                option.label,
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
                  })
                  .toList()
                  .divide(const SizedBox(height: 0)),
            ),
          ],
        ),
      ),
    );
  }
}
