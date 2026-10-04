import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../l10n/app_localizations.dart';
import '../../core/i18n/locale_service.dart';
import '../../services/session_service.dart';
import '../theme/astralia_colors.dart';
import '../theme/astralia_theme.dart';

/// Selector de idioma. Lista los idiomas de [LocaleService.supported]: al agregar uno aparece solo.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Get.find<LocaleService>();
    final session = Get.find<SessionService>();

    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.language,
            style: AstraliaType.sans(size: 11, color: AstraliaColors.lilac),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: locale.code,
            underline: const SizedBox.shrink(),
            dropdownColor: AstraliaColors.navyMid,
            style: AstraliaType.sans(size: 12),
            items: [
              for (final supported in LocaleService.supported)
                DropdownMenuItem(
                  value: supported.languageCode,
                  child: Text(
                    LocaleService.labels[supported.languageCode] ??
                        supported.languageCode,
                  ),
                ),
            ],
            onChanged: (code) =>
                code == null ? null : session.changeLanguage(code),
          ),
        ],
      ),
    );
  }
}
