import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../common/widgets/glass_card.dart';
import '../../../common/widgets/star_mark.dart';

/// Marcador de las secciones que aún no están en la app. Cada una se reemplaza por su módulo real.
class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const StarMark(size: 48),
                const SizedBox(height: 12),
                Text(title, style: AstraliaType.serif(size: 26)),
                const SizedBox(height: 4),
                Text(
                  l10n.comingSoonTitle,
                  style: AstraliaType.sans(
                    size: 12,
                    color: AstraliaColors.gold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.comingSoonBody,
                  textAlign: TextAlign.center,
                  style: AstraliaType.sans(
                    size: 13,
                    color: AstraliaColors.lilacSoft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
