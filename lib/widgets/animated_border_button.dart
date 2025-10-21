// lib/widgets/animated_border_button.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

// Nouveau bouton Power On avec bordure lumineuse qui circule
class AnimatedGoldBorderButton extends StatefulWidget {
  final VoidCallback onTap;
  const AnimatedGoldBorderButton({super.key, required this.onTap});

  @override
  State<AnimatedGoldBorderButton> createState() => _AnimatedGoldBorderButtonState();
}

class _AnimatedGoldBorderButtonState extends State<AnimatedGoldBorderButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000), // Durée plus lente
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _CircularBorderPainter(
            progress: _controller.value,
            highlight: true, // Toujours actif
          ),
          child: PowerOnButton(
            onTap: widget.onTap,
          ),
        );
      },
    );
  }
}

class _CircularBorderPainter extends CustomPainter {
  final double progress;
  final bool highlight;
  
  _CircularBorderPainter({required this.progress, required this.highlight});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width - 4,
      height: size.height - 4,
    );
    
    final borderRadius = 48.0;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    
    // Bordure de base subtile
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0 // Plus épais
      ..color = const Color(0xFF2196F3).withOpacity(0.5); // Bleu plus visible
    canvas.drawRRect(rrect, basePaint);

    // Créer un chemin pour la bordure arrondie
    final path = Path()..addRRect(rrect);
    
    // Mesurer la longueur totale du chemin
    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;
    
    // Longueur du segment lumineux (environ 15% du périmètre)
    final glowLength = totalLength * 0.15;
    
    // Position actuelle basée sur le progress
    final currentPosition = totalLength * progress;
    
    // Dessiner le segment lumineux principal
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    // Créer un gradient le long du segment
    final startPos = (currentPosition - glowLength / 2) % totalLength;
    final endPos = (currentPosition + glowLength / 2) % totalLength;
    
    // Extraire le segment du chemin
    Path glowPath;
    if (startPos < endPos) {
      glowPath = pathMetrics.extractPath(startPos, endPos);
    } else {
      // Le segment traverse la jonction (fin -> début)
      final path1 = pathMetrics.extractPath(startPos, totalLength);
      final path2 = pathMetrics.extractPath(0, endPos);
      glowPath = Path()
        ..addPath(path1, Offset.zero)
        ..addPath(path2, Offset.zero);
    }
    
    // Appliquer la couleur principale
    glowPaint.color = const Color(0xFF00E5FF);
    canvas.drawPath(glowPath, glowPaint);
    
    // Halo lumineux plus large et flouté
    final haloPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF00E5FF).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(glowPath, haloPaint);
    
    // Point lumineux intense à la tête
    final headTangent = pathMetrics.getTangentForOffset(currentPosition);
    if (headTangent != null) {
      final pointPaint = Paint()
        ..color = const Color(0xFFFFFFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(headTangent.position, 4, pointPaint);
      
      // Halo autour du point
      final pointHaloPaint = Paint()
        ..color = const Color(0xFF00E5FF).withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(headTangent.position, 8, pointHaloPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularBorderPainter oldDelegate) {
    return progress != oldDelegate.progress || highlight != oldDelegate.highlight;
  }
}

// Widget PowerOnButton
class PowerOnButton extends StatefulWidget {
  final VoidCallback onTap;

  const PowerOnButton({super.key, required this.onTap});

  @override
  State<PowerOnButton> createState() => _PowerOnButtonState();
}

class _PowerOnButtonState extends State<PowerOnButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.power_settings_new,
                    color: Color(0xFF00B0FF),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Power On',
                    style: TextStyle(
                      color: Color(0xFF00B0FF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}