import 'package:flutter/material.dart';

import '../theme/astralia_colors.dart';

/// La estrella de cinco puntas de Astralia (la misma de los íconos de la web), dibujada con un polígono.
class StarMark extends StatelessWidget {
  const StarMark({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _StarPainter());
}

class _StarPainter extends CustomPainter {
  static const _points = [
    Offset(0, -1),
    Offset(0.247, -0.34),
    Offset(0.951, -0.309),
    Offset(0.399, 0.13),
    Offset(0.588, 0.809),
    Offset(0, 0.42),
    Offset(-0.588, 0.809),
    Offset(-0.399, 0.13),
    Offset(-0.951, -0.309),
    Offset(-0.247, -0.34),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + size.height * 0.05);
    final radius = size.width / 2 * 0.92;
    final path = Path();
    for (var i = 0; i < _points.length; i++) {
      final point = center + _points[i] * radius;
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();

    canvas.drawCircle(
      center,
      radius * 1.3,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AstraliaColors.gold.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.3)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [AstraliaColors.goldSoft, AstraliaColors.goldDeep],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
