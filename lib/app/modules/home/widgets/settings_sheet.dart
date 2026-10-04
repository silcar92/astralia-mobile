import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../common/widgets/gold_button.dart';
import '../../../common/widgets/language_switcher.dart';
import '../../../routes/app_routes.dart';
import '../../../services/session_service.dart';

Future<void> showSettingsSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AstraliaColors.navyMid,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.settings, style: AstraliaType.serif(size: 24)),
            const SizedBox(height: 16),
            const LanguageSwitcher(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: GoldButton(
                label: l10n.logout,
                onPressed: () async {
                  await Get.find<SessionService>().logout();
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
