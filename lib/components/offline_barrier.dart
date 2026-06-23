import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/services/connectivity_service.dart';
import '/services/i18n/app_labels.dart';

class OfflineBarrier extends StatelessWidget {
  const OfflineBarrier({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ConnectivityService>();
    if (!service.isOnline) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage(context));
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    return AbsorbPointer(
      absorbing: !service.isOnline,
      child: AnimatedOpacity(
        opacity: service.isOnline ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }

  void _showMessage(BuildContext context) {
    final labels = AppLabels.of(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                labels.get('connection.offline_message'),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(days: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
