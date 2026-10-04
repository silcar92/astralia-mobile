import 'package:flutter/material.dart';

import '../theme/astralia_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AstraliaColors.glass,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AstraliaColors.glassStroke),
      ),
      child: child,
    );
  }
}
