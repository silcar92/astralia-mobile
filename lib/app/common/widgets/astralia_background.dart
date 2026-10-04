import 'package:flutter/material.dart';

import '../theme/astralia_colors.dart';

/// Fondo de todas las pantallas: el degradado radial nocturno de la marca.
class AstraliaBackground extends StatelessWidget {
  const AstraliaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -1.1),
          radius: 1.4,
          colors: [
            AstraliaColors.navyStart,
            AstraliaColors.navyMid,
            AstraliaColors.navyEnd,
          ],
          stops: [0, 0.45, 1],
        ),
      ),
      child: child,
    );
  }
}
