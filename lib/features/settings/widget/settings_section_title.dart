import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String title;
  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
