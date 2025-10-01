import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bouton de démarrage animé qui réagit au tap (mobile) ou au survol (desktop/web)
/// en effectuant un effet de zoom visible.
class AnimatedStartButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;

  const AnimatedStartButton({
    super.key,
    required this.onTap,
    this.label = 'Démarrer l\'aventure',
  });

  @override
  State<AnimatedStartButton> createState() => _AnimatedStartButtonState();
}

class _AnimatedStartButtonState extends State<AnimatedStartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    // L'animation va de 1.0 (taille normale) à 0.95 (légèrement compressé pour l'effet de pression)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Déclenche l'animation de compression (zoom arrière)
  void _onTapDown(_) {
    _controller.forward();
    // Feedback haptique
    HapticFeedback.lightImpact();
  }

  // Déclenche l'animation d'expansion (retour à la normale) et la navigation
  void _onTapUp(_) {
    _controller.reverse().then((_) {
      // Exécute l'action de navigation après le retour à la taille normale
      widget.onTap();
    });
  }
  
  // En cas d'annulation du toucher (doigt glissé)
  void _onTapCancel() {
    _controller.reverse();
  }

  // Fonction pour les plateformes Desktop/Web (Survol)
  void _onEnter(bool isHovering) {
    if (isHovering) {
      // Zoom légèrement à 1.03 au survol
      _controller.animateTo(0.5, duration: const Duration(milliseconds: 100)); 
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onHover: (event) => _onEnter(true),
      onExit: (event) => _onEnter(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        
        // ScaleTransition applique l'animation à son enfant
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.6),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}