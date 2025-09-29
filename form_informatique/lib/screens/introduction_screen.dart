import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';
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

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true); 

    _generateStars();
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
        decoration: const BoxDecoration( 
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A237E),
              Color(0xFF00B0FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: StarsPainter(_stars, _animationController.value),
                  size: Size.infinite,
                );
              },
            ),

            Positioned.fill(
              child: SafeArea( 
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 80.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 50), 
                          
                          const Icon(
                            Icons.construction,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 30),
                          
                          Text(
                            "XR Tech Tools",
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 180),
                          
                          PowerOnButton(
                            onTap: () => _navigateToDashboard(context),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: AppFooter(),
              ),
            ),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
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

  StarsPainter(this.stars, this.animationValue);

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

      final currentSize = star.size + (twinkle * 0.3);

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