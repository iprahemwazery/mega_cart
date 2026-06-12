import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final IconData icon;
  const IconContainer({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: theme.colorScheme.primary),
    );
  }
}
