import 'package:flutter/material.dart';
import 'package:mega_cart/features/settings/widget/icon_container.dart';

class AccountTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AccountTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        leading: IconContainer(icon: icon),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
