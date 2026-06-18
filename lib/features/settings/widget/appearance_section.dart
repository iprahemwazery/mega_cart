import 'package:flutter/material.dart';
import 'package:mega_cart/core/l10n/app_localizations.dart';
import 'package:mega_cart/features/settings/widget/icon_container.dart';
import 'package:mega_cart/features/settings/widget/settings_controller.dart';
import 'package:mega_cart/features/settings/widget/settings_section_title.dart';

class AppearanceSection extends StatelessWidget {
  final SettingsController controller;
  final AppLocalizations l10n;

  const AppearanceSection({
    super.key,
    required this.controller,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: l10n.appearance),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          child: ListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              controller.isDarkMode.value ? l10n.enabled : l10n.disabled,
              style: const TextStyle(fontSize: 12),
            ),
            leading: IconContainer(
              icon: controller.isDarkMode.value
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            trailing: Switch(
              value: controller.isDarkMode.value,
              onChanged: (value) => controller.toggleTheme(value),
              activeColor: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
