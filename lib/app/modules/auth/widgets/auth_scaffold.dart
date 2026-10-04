import 'package:flutter/material.dart';

import '../../../common/widgets/astralia_background.dart';
import '../../../common/widgets/language_switcher.dart';
import '../../../common/widgets/star_mark.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';

/// Marco común de las pantallas de acceso: fondo, estrella, título y selector de idioma.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.showBack = false,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AstraliaBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                // en pantallas anchas (tablet) el formulario no se estira
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: const LanguageSwitcher(),
                    ),
                    const SizedBox(height: 8),
                    const StarMark(size: 64),
                    const SizedBox(height: 14),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AstraliaType.serif(size: 30),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: AstraliaType.sans(
                          size: 13,
                          color: AstraliaColors.lilac,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    child,
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
