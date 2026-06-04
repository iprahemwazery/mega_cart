import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/settings/view/settings_controller.dart';
import 'package:mega_cart/l10n/app_localizations.dart';

class SttingsView extends StatelessWidget {
  const SttingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          Text(
            l10n.welcomeUser('Wazery'),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.appearance,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Obx(() {
            final currentTheme = Theme.of(context);
            return Card(
              elevation: 0,
              color: currentTheme.colorScheme.surfaceVariant.withOpacity(0.3),
              child: ListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  controller.isDarkMode.value ? l10n.enabled : l10n.disabled,
                  style: TextStyle(fontSize: 12),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentTheme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.isDarkMode.value
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: currentTheme.colorScheme.primary,
                  ),
                ),
                trailing: Switch(
                  value: controller.isDarkMode.value,
                  onChanged: (value) => controller.toggleTheme(value),
                  activeColor: currentTheme.colorScheme.primary,
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),

          Text(
            l10n.language,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            borderOnForeground: false,
            elevation: 0,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            child: ListTile(
              title: Text(
                l10n.changeLanguage,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                l10n.selectLanguageDescription,
                style: const TextStyle(fontSize: 12),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.language, color: theme.colorScheme.primary),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) {
                    return Obx(() {
                      final currentLang =
                          controller.currentLocale.value.languageCode;
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
                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(l10n.english),
                              trailing: currentLang == 'en'
                                  ? Icon(
                                      Icons.check_circle,
                                      color: theme.colorScheme.primary,
                                    )
                                  : null,
                              onTap: () {
                                controller.changeLanguage('en');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(l10n.arabic),
                              trailing: currentLang == 'ar'
                                  ? Icon(
                                      Icons.check_circle,
                                      color: theme.colorScheme.primary,
                                    )
                                  : null,
                              onTap: () {
                                controller.changeLanguage('ar');
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),

          Text(
            l10n.account,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            child: ListTile(
              title: Text(
                l10n.privacyPolicy,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            child: ListTile(
              title: Text(
                l10n.termsOfService,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to Terms of Service
              },
            ),
          ),
        ],
      ),
    );
  }
}
