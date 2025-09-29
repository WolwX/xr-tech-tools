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
    
    // Animation controller pour les particules - Plus rapide et fluide
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Génération des étoiles
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
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fonction de navigation vers le Dashboard
  void _navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        // FOND : Dégradé de deux Bleus (Foncé vers Clair)
        decoration: const BoxDecoration( 
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A237E), // Bleu indigo très foncé (haut)
              Color(0xFF00B0FF), // Bleu azur/vibrant (bas)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        
        child: Stack(
          children: [
            // Particules étoilées animées
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: StarsPainter(_stars, _animationController.value),
                  size: Size.infinite,
                );
              },
            ),

            // Contenu principal
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
                          
                          // Icône principale (blanche)
                          Icon(
                            Icons.construction,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 30),
                          
                          // Titre principal (texte blanc)
                          Text(
                            "XR Tech Tools",
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 180),
                          
                          // Nouveau bouton Power On compact avec icône
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

            // Pied de page fixe
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

// Widget pour le bouton Power On personnalisé
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
                  Icon(
                    Icons.power_settings_new,
                    color: const Color(0xFF00B0FF),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Power On',
                    style: TextStyle(
                      color: const Color(0xFF00B0FF),
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

// Classe pour représenter une particule étoile
class StarParticle {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speed;
  final double phase;
  final double twinkleSpeed;

  StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.phase,
    required this.twinkleSpeed,
  });
}

// Painter pour dessiner les étoiles animées
class StarsPainter extends CustomPainter {
  final List<StarParticle> stars;
  final double animationValue;

  StarsPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var star in stars) {
      // Calcul de l'opacité avec animation de scintillement plus fluide
      final time = animationValue * 2 * math.pi;
      final twinkle = math.sin(time * star.twinkleSpeed + star.phase);
      final pulse = math.cos(time * star.speed * 0.7 + star.phase * 1.5);
      
      // Combinaison de deux ondes pour un effet plus complexe
      final combinedTwinkle = (twinkle * 0.6 + pulse * 0.4);
      final currentOpacity = (star.opacity + combinedTwinkle * 0.4).clamp(0.1, 1.0);
      
      paint.color = Colors.white.withOpacity(currentOpacity);

      final x = star.x * size.width;
      final y = star.y * size.height;

      // Taille variable avec l'animation
      final currentSize = star.size + (twinkle * 0.3);

      // Dessiner l'étoile comme un petit cercle
      canvas.drawCircle(
        Offset(x, y),
        currentSize,
        paint,
      );

      // Ajouter un effet de croix pour certaines étoiles plus brillantes
      if (star.size > 1.5 && currentOpacity > 0.7) {
        paint.color = Colors.white.withOpacity(currentOpacity * 0.6);
        paint.strokeWidth = 0.8;
        
        final crossSize = currentSize * 2;
        // Ligne horizontale
        canvas.drawLine(
          Offset(x - crossSize, y),
          Offset(x + crossSize, y),
          paint,
        );
        // Ligne verticale
        canvas.drawLine(
          Offset(x, y - crossSize),
          Offset(x, y + crossSize),
          paint,
        );
      }

      // Ajouter un halo pour les plus grandes étoiles
      if (star.size > 1.8 && currentOpacity > 0.8) {
        final haloPaint = Paint()
          ..color = Colors.white.withOpacity(currentOpacity * 0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        
        canvas.drawCircle(
          Offset(x, y),
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