import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/l10n/app_localizations.dart';
import 'package:mega_cart/features/settings/widget/icon_container.dart';
import 'package:mega_cart/features/settings/widget/settings_controller.dart';
import 'package:mega_cart/features/settings/widget/settings_section_title.dart';

class LanguageSection extends StatelessWidget {
  final SettingsController controller;
  final AppLocalizations l10n;

  const LanguageSection({
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
        SettingsSectionTitle(title: l10n.language),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          child: ListTile(
            title: Text(
              l10n.changeLanguage,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              l10n.selectLanguageDescription,
              style: const TextStyle(fontSize: 12),
            ),
            leading: const IconContainer(icon: Icons.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguagePicker(context),
          ),
        ),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Obx(() {
        final currentLang = controller.currentLocale.value.languageCode;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.selectLanguageDescription,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _languageTile(context, l10n.english, 'en', currentLang),
              _languageTile(context, l10n.arabic, 'ar', currentLang),
              const SizedBox(height: 10),
            ],
          ),
        );
      }),
    );
  }

  Widget _languageTile(
    BuildContext context,
    String title,
    String code,
    String current,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(title),
      trailing: current == code
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: () {
        controller.changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}
