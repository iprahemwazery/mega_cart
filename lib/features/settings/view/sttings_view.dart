import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/settings/widget/settings_controller.dart';
import 'package:mega_cart/core/l10n/app_localizations.dart';
import 'package:mega_cart/features/settings/widget/account_section.dart';
import 'package:mega_cart/features/settings/widget/appearance_section.dart';

class SttingsView extends StatelessWidget {
  const SttingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    return Obx(() {
      final bool isDarkMode = controller.isDarkMode.value;

      final targetTheme = isDarkMode
          ? ThemeData.dark(useMaterial3: true).copyWith(
              scaffoldBackgroundColor: Colors.black,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
                surface: Colors.black,
              ),
            )
          : ThemeData.light(useMaterial3: true);

      final l10n = AppLocalizations.of(context)!;

      return AnimatedTheme(
        data: targetTheme,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return SafeArea(
              child: Scaffold(
                backgroundColor: theme.colorScheme.surface,
                appBar: AppBar(title: const Text(''), elevation: 0),
                body: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  children: [
                    _buildWelcomeHeader(
                      theme,
                      l10n,
                    ), // هذا الـ Widget خاص بالـ View نفسه ولا يحتاج لملف منفصل
                    const SizedBox(height: 20),
                    AppearanceSection(controller: controller, l10n: l10n),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    _LanguageSection(controller: controller, l10n: l10n),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    AccountSection(l10n: l10n),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildWelcomeHeader(ThemeData theme, AppLocalizations l10n) {
    return Text(
      l10n.welcomeUser('Wazery'),
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;
  const _SettingsSectionTitle({required this.title});

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

// ignore: unused_element
class _AppearanceSection extends StatelessWidget {
  final SettingsController controller;
  final AppLocalizations l10n;

  const _AppearanceSection({required this.controller, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsSectionTitle(title: l10n.appearance),
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
            leading: _IconContainer(
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

class _LanguageSection extends StatelessWidget {
  final SettingsController controller;
  final AppLocalizations l10n;

  const _LanguageSection({required this.controller, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsSectionTitle(title: l10n.language),
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
            leading: const _IconContainer(icon: Icons.language),
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

class _AccountSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _AccountSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsSectionTitle(title: l10n.account),
        const SizedBox(height: 12),
        _AccountTile(
          title: l10n.privacyPolicy,
          icon: Icons.privacy_tip_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _AccountTile(
          title: l10n.termsOfService,
          icon: Icons.description_outlined,
          onTap: () {},
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _AccountTile({
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
        leading: _IconContainer(icon: icon),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  final IconData icon;
  const _IconContainer({required this.icon});

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
