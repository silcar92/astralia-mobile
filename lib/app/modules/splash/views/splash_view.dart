import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../common/widgets/astralia_background.dart';
import '../../../common/widgets/gold_button.dart';
import '../../../common/widgets/star_mark.dart';
import '../../../core/i18n/error_messages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: AstraliaBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Obx(() {
              final error = controller.error.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StarMark(size: 72),
                  const SizedBox(height: 16),
                  Text(l10n.appName, style: AstraliaType.serif(size: 34)),
                  const SizedBox(height: 28),
                  if (error == null)
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AstraliaColors.gold,
                      ),
                    )
                  else ...[
                    Text(
                      errorMessage(l10n, error),
                      textAlign: TextAlign.center,
                      style: AstraliaType.sans(color: AstraliaColors.lilac),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: GoldButton(
                        label: l10n.retry,
                        onPressed: controller.start,
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
