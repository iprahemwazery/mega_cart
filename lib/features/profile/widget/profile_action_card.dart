import 'package:flutter/material.dart';

class ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}
