import 'package:flutter/material.dart';

class _GlowingGoldButton extends StatefulWidget {
  final Widget child;
  const _GlowingGoldButton({required this.child});

  @override
  State<_GlowingGoldButton> createState() => _GlowingGoldButtonState();
}

class _GlowingGoldButtonState extends State<_GlowingGoldButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
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
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color.lerp(const Color(0xFFFFD700), const Color(0xFFFFF8DC), _glowAnim.value)!, // Or vers doré clair
              width: 4.0,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: widget.child,
        );
      },
    );
  }
}
