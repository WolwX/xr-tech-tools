import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';
import '../widgets/animated_border_button.dart'; // NOUVEAU IMPORT
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
        builder: (ctx) => DashboardScreen(backgroundImage: _backgroundImage),
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
            // Bouton avec bordure lumineuse animée
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
          ],
        ),
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