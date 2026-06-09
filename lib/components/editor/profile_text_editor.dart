import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/floter/floter_theme.dart';

class ProfileTextEditor extends StatelessWidget {
  const ProfileTextEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    this.maxLength = 300,
    this.height = 210,
    this.hintText = '',
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLength;
  final double height;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

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
            Container(
              height: height,
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onChanged,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: hintText,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    filled: true,
                  ),
                  style: const TextStyle(),
                  maxLines: null,
                  maxLength: maxLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: validator,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
