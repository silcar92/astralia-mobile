import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../common/widgets/astralia_background.dart';
import '../../../common/widgets/glass_card.dart';
import '../../../common/widgets/gold_button.dart';
import '../../../common/widgets/star_mark.dart';
import '../../../routes/app_routes.dart';
import '../../../services/session_service.dart';

/// Marcador: el onboarding completo (datos de nacimiento, intereses, test) llega en la siguiente fase de la app.
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: AstraliaBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const StarMark(size: 64),
                    const SizedBox(height: 14),
                    Text(
                      l10n.onboardingTitle,
                      style: AstraliaType.serif(size: 30),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GlassCard(
                      child: Column(
                        children: [
                          Text(
                            l10n.onboardingBody,
                            textAlign: TextAlign.center,
                            style: AstraliaType.sans(
                              size: 13,
                              color: AstraliaColors.lilacSoft,
                            ),
                          ),
                          const SizedBox(height: 18),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
