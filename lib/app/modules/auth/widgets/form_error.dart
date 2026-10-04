import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../core/i18n/error_messages.dart';

/// Error de un formulario, traducido al idioma actual.
class FormError extends StatelessWidget {
  const FormError({
    super.key,
    required this.error,
    this.wrongCredentialsOn401 = false,
  });

  final Rxn<Object> error;
  final bool wrongCredentialsOn401;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final current = error.value;
      if (current == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text(
          errorMessage(
            l10n,
            current,
            wrongCredentialsOn401: wrongCredentialsOn401,
          ),
          key: const Key('form-error'),
          style: AstraliaType.sans(size: 12, color: AstraliaColors.alert),
        ),
      );
    });
  }
}
