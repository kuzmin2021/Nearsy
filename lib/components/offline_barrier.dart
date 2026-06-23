import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/floter/floter_theme.dart';
import '/services/connectivity_service.dart';
import '/services/i18n/app_labels.dart';

class OfflineBarrier extends StatelessWidget {
  const OfflineBarrier({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ConnectivityService>();
    final isOnline = service.isOnline;

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: !isOnline,
          child: AnimatedOpacity(
            opacity: isOnline ? 1.0 : 0.6,
            duration: const Duration(milliseconds: 300),
            child: child,
          ),
        ),
        if (!isOnline) _buildBanner(context),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    final labels = AppLabels.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.red.shade700,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    labels.get('connection.offline_message'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
