import 'package:flutter/material.dart';

import '../theme/astralia_colors.dart';
import '../theme/astralia_theme.dart';

/// Botón principal (dorado). Con `loading` se bloquea y muestra el texto de espera.
class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.loadingLabel,
  });

  final String label;
  final String? loadingLabel;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AstraliaColors.gold, AstraliaColors.goldDeep],
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: enabled ? onPressed : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Center(
                child: Text(
                  loading ? (loadingLabel ?? label) : label,
                  style: AstraliaType.sans(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AstraliaColors.goldInk,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
