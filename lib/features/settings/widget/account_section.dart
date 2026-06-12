import 'package:flutter/material.dart';
import 'package:mega_cart/core/l10n/app_localizations.dart';
import 'package:mega_cart/features/settings/widget/account_tile.dart';
import 'package:mega_cart/features/settings/widget/settings_section_title.dart';

class AccountSection extends StatelessWidget {
  final AppLocalizations l10n;
  const AccountSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: l10n.account),
        const SizedBox(height: 12),
        AccountTile(
          title: l10n.privacyPolicy,
          icon: Icons.privacy_tip_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        AccountTile(
          title: l10n.termsOfService,
          icon: Icons.description_outlined,
          onTap: () {},
        ),
      ],
    );
  }
}
