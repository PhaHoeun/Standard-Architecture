import 'package:flutter/material.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 1. Base Canvas
        Container(
          width: double.infinity,
          height: double.infinity,
          color: isDark ? const Color(0xFF090D16) : const Color(0xFFF4F6F9),
        ),

        // 2. Ambient Glowing Orb 1 (Top Right - Electric Cobalt)
        Positioned(
          top: -size.width * 0.25,
          right: -size.width * 0.2,
          child: Container(
            width: size.width * 0.9,
            height: size.width * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? [
                        const Color(0xFF2563EB).withValues(alpha: 0.35),
                        const Color(0xFF1D4ED8).withValues(alpha: 0.15),
                        Colors.transparent,
                      ]
                    : [
                        const Color(0xFF3B82F6).withValues(alpha: 0.22),
                        const Color(0xFF60A5FA).withValues(alpha: 0.10),
                        Colors.transparent,
                      ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // 3. Ambient Glowing Orb 2 (Middle Left - Royal Violet)
        Positioned(
          top: size.height * 0.28,
          left: -size.width * 0.3,
          child: Container(
            width: size.width * 0.85,
            height: size.width * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? [
                        const Color(0xFF7C3AED).withValues(alpha: 0.28),
                        const Color(0xFF6D28D9).withValues(alpha: 0.12),
                        Colors.transparent,
                      ]
                    : [
                        const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                        const Color(0xFFA78BFA).withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // 4. Ambient Glowing Orb 3 (Bottom Right - Warm Amber / Coral Accent)
        Positioned(
          bottom: -size.width * 0.2,
          right: -size.width * 0.15,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? [
                        const Color(0xFFD97706).withValues(alpha: 0.20),
                        const Color(0xFFB45309).withValues(alpha: 0.08),
                        Colors.transparent,
                      ]
                    : [
                        const Color(0xFFF59E0B).withValues(alpha: 0.14),
                        const Color(0xFFFBBF24).withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // 5. Classic Architectural Geometric Watermarks (Subtle Concentric Rings)
        Positioned(
          top: size.height * 0.12,
          right: size.width * 0.05,
          child: CustomPaint(
            size: const Size(220, 220),
            painter: _ArchitecturalRingsPainter(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
            ),
          ),
        ),

        // 6. Child Content (Flows above the glowing ambient canvas)
        child,
      ],
    );
  }
}

class _ArchitecturalRingsPainter extends CustomPainter {
  final Color color;

  _ArchitecturalRingsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, (size.width / 8) * i, paint);
    }

    // Subtle crosshairs
    canvas.drawLine(
      Offset(center.dx - size.width / 2, center.dy),
      Offset(center.dx + size.width / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size.height / 2),
      Offset(center.dx, center.dy + size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArchitecturalRingsPainter oldDelegate) =>
      oldDelegate.color != color;
}
