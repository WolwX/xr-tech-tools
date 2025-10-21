import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';
import '../services/global_timer_service.dart';
import 'dashboard_screen.dart';
import 'dart:math' as math;

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<StarParticle> _stars;
  late String _backgroundImage;

  @override
  void initState() {
    super.initState();

    // Choix aléatoire du background parmi tous les fichiers qui commencent par 'xrtechtools-bg'
    final imageAssets = [
      'assets/images/xrtechtools-bg1.png',
      'assets/images/xrtechtools-bg2.png',
      'assets/images/xrtechtools-bg3.png',
      'assets/images/xrtechtools-bg4.png',
      // Si d'autres fichiers sont ajoutés dans le pubspec.yaml, ils seront pris en compte ici
    ];
    final bgList = imageAssets.where((path) => path.contains('xrtechtools-bg')).toList();
    _backgroundImage = (bgList..shuffle()).first;

    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _generateStars();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialiser le GlobalTimerService pour qu'il puisse afficher le timer
    GlobalTimerService().initialize(context);
    // Indiquer qu'on n'affiche aucun item spécifique (page d'introduction)
    GlobalTimerService().setCurrentPageItem(null, null);
  }

  void _generateStars() {
    final random = math.Random();
    _stars = List.generate(60, (index) {
      return StarParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 0.5,
        opacity: random.nextDouble() * 0.8 + 0.2,
        speed: random.nextDouble() * 2 + 0.5,
        phase: random.nextDouble() * math.pi * 2,
        twinkleSpeed: random.nextDouble() * 2 + 0.5,
        velocityX: (random.nextDouble() - 0.5) * 0.0002,
        velocityY: (random.nextDouble() - 0.5) * 0.0002,
        driftAmplitudeX: random.nextDouble() * 0.02,
        driftAmplitudeY: random.nextDouble() * 0.02,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Overlay sombre sur le background
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
            // Effet étoiles
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: StarsPainter(_stars, _animationController.value, starSizeMultiplier: 1.5),
                  size: Size.infinite,
                );
              },
            ),
            // Bouton avec halo vermeil
            Positioned.fill(
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 200),
                      AnimatedGoldBorderButton(
                        onTap: () => _navigateToDashboard(context),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            // Footer sur fond sombre
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.5), // 50% d'opacité
                padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                child: const AppFooter(
                  forceWhite: true,
                  // On force tout en blanc (texte et icônes)
                ),
              ),
            ),

// Widget pour bordure dorée animée et glow subtil autour du bouton

          ],
        ),
      ),
    );
  }
}

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
                // Suppression des boxShadow pour un fit parfait de la bordure
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.power_settings_new,
                    color: Color(0xFF00B0FF),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Power On',
                    style: TextStyle(
                      color: Color(0xFF00B0FF), // bleu
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

class StarParticle {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speed;
  final double phase;
  final double twinkleSpeed;
  final double velocityX;
  final double velocityY;
  final double driftAmplitudeX;
  final double driftAmplitudeY;

  StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.phase,
    required this.twinkleSpeed,
    required this.velocityX,
    required this.velocityY,
    required this.driftAmplitudeX,
    required this.driftAmplitudeY,
  });
}

class StarsPainter extends CustomPainter {
  final List<StarParticle> stars;
  final double animationValue;
  final double starSizeMultiplier;

  StarsPainter(this.stars, this.animationValue, {this.starSizeMultiplier = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var star in stars) {
      final time = animationValue * 2 * math.pi;
      final twinkle = math.sin(time * star.twinkleSpeed + star.phase);
      final pulse = math.cos(time * star.speed * 0.7 + star.phase * 1.5);
      
      final combinedTwinkle = (twinkle * 0.6 + pulse * 0.4);
      final currentOpacity = (star.opacity + combinedTwinkle * 0.4).clamp(0.1, 1.0);
      
      paint.color = Colors.white.withOpacity(currentOpacity);

      // NOUVEAU : Calcul de la position avec mouvement
      final driftX = star.velocityX * animationValue * 1000;
      final driftY = star.velocityY * animationValue * 1000;
      
      final oscillationX = math.sin(time * star.speed * 0.3 + star.phase) * star.driftAmplitudeX;
      final oscillationY = math.cos(time * star.speed * 0.4 + star.phase * 1.3) * star.driftAmplitudeY;
      
      double finalX = ((star.x + driftX + oscillationX) % 1.0) * size.width;
      double finalY = ((star.y + driftY + oscillationY) % 1.0) * size.height;
      
      if (finalX < 0) finalX += size.width;
      if (finalY < 0) finalY += size.height;

  final currentSize = (star.size + (twinkle * 0.3)) * starSizeMultiplier;

      canvas.drawCircle(
        Offset(finalX, finalY),
        currentSize,
        paint,
      );

      if (star.size > 1.5 && currentOpacity > 0.7) {
        paint.color = Colors.white.withOpacity(currentOpacity * 0.6);
        paint.strokeWidth = 0.8;
        
        final crossSize = currentSize * 2;
        canvas.drawLine(
          Offset(finalX - crossSize, finalY),
          Offset(finalX + crossSize, finalY),
          paint,
        );
        canvas.drawLine(
          Offset(finalX, finalY - crossSize),
          Offset(finalX, finalY + crossSize),
          paint,
        );
      }

      if (star.size > 1.8 && currentOpacity > 0.8) {
        final haloPaint = Paint()
          ..color = Colors.white.withOpacity(currentOpacity * 0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        
        canvas.drawCircle(
          Offset(finalX, finalY),
          currentSize * 3,
          haloPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}


// Nouveau bouton Power On avec bordure dorée animée (sweep gradient rotatif)
class AnimatedGoldBorderButton extends StatefulWidget {
  final VoidCallback onTap;
  const AnimatedGoldBorderButton({required this.onTap});

  @override
  State<AnimatedGoldBorderButton> createState() => _AnimatedGoldBorderButtonState();
}

class _AnimatedGoldBorderButtonState extends State<AnimatedGoldBorderButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: CustomPaint(
        painter: _GoldBorderPainter(
          progress: _controller.value,
          highlight: _hovering,
        ),
        child: PowerOnButton(
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

class _GoldBorderPainter extends CustomPainter {
  final double progress;
  final bool highlight;
  _GoldBorderPainter({required this.progress, required this.highlight});

  @override
  void paint(Canvas canvas, Size size) {
    // (rect et paint inutiles)

    // Sweep gradient doré animé
    // Bordure principale discrète
    final borderRect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final borderPath = Path()
      ..addRRect(RRect.fromRectAndRadius(borderRect, const Radius.circular(48)));
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = const Color(0x2200B0FF); // bleu très léger
    canvas.drawPath(borderPath, basePaint);

    // Effet d'éclat lumineux qui tourne (sweep gradient)
    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * 3.141592653589793,
        colors: [
          Colors.transparent,
          const Color(0xFF00B0FF).withOpacity(0.7),
          Colors.transparent,
        ],
        stops: const [0.0, 0.08, 1.0],
        transform: GradientRotation(progress * 2 * 3.141592653589793),
      ).createShader(borderRect);
    canvas.drawPath(borderPath, sweepPaint);

    // (point lumineux désactivé)

  // (fin du paint)
  }

  @override
  bool shouldRepaint(covariant _GoldBorderPainter oldDelegate) {
    return progress != oldDelegate.progress || highlight != oldDelegate.highlight;
  }
}