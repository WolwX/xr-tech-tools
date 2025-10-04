import 'package:flutter/material.dart';
import 'dart:async';
import '../services/global_timer_service.dart';

class FloatingTimer extends StatefulWidget {
  final Duration initialDuration;
  final VoidCallback? onFinish;
  final VoidCallback? onClose;
  final VoidCallback? onTimerTap; // Simple clic (notification)
  final VoidCallback? onTimerDoubleTap; // Double clic (navigation)
  final bool autoStart;
  final bool readyMode;
  final bool interactionsEnabled; // Nouvelle propriété pour contrôler les interactions
  
  const FloatingTimer({
    super.key,
    this.initialDuration = const Duration(minutes: 30),
    this.onFinish,
    this.onClose,
    this.onTimerTap,
    this.onTimerDoubleTap,
    this.autoStart = true,
    this.readyMode = false,
    this.interactionsEnabled = true, // Par défaut, les interactions sont activées
  });

  @override
  State<FloatingTimer> createState() => _FloatingTimerState();
}

class _FloatingTimerState extends State<FloatingTimer> 
    with TickerProviderStateMixin {
  Timer? _timer;
  Duration _remainingTime = const Duration(minutes: 30);
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  late AnimationController _sandglassController;
  late AnimationController _hoverController;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialDuration;
    _sandglassController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Notifier le service global de l'état initial
    GlobalTimerService().updateTimerState(_remainingTime, _isTimerRunning, _isTimerPaused);
    
    if (widget.autoStart && !widget.readyMode) {
      _startTimer();
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _sandglassController.dispose();
    _hoverController.dispose();
    super.dispose();
  }
  
  void _startTimer() {
    if (_isTimerPaused) {
      _resumeTimer();
      return;
    }
    
    setState(() {
      _isTimerRunning = true;
      _isTimerPaused = false;
    });
    
    // Notifier le service global de l'état du timer
    GlobalTimerService().updateTimerState(_remainingTime, _isTimerRunning, _isTimerPaused);
    
    _sandglassController.repeat();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
          // Notifier le service global du temps restant
          GlobalTimerService().updateTimerState(_remainingTime, _isTimerRunning, _isTimerPaused);
        } else {
          _finishTimer();
        }
      });
    });
  }
  
  void _pauseTimer() {
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = true;
    });
    _timer?.cancel();
    _sandglassController.stop();
    
    // Notifier le service global de l'état pausé
    GlobalTimerService().updateTimerState(_remainingTime, _isTimerRunning, _isTimerPaused);
  }
  
  void _resumeTimer() {
    setState(() {
      _isTimerRunning = true;
      _isTimerPaused = false;
    });
    _sandglassController.repeat();
    _startTimer();
    
    // Notifier le service global de la reprise
    GlobalTimerService().updateTimerState(_remainingTime, _isTimerRunning, _isTimerPaused);
  }
  
  void _finishTimer() {
    _timer?.cancel();
    _sandglassController.stop();
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
    });
    
    // Notifier le service global de la fin du timer
    GlobalTimerService().updateTimerState(_remainingTime, _isTimerRunning, _isTimerPaused);
    
    widget.onFinish?.call();
  }
  
  @override
  Widget build(BuildContext context) {
    final minutes = _remainingTime.inMinutes;
    final seconds = _remainingTime.inSeconds % 60;
    final isLowTime = _remainingTime.inMinutes < 5;
    
    return Positioned(
      bottom: 50, // Position remontée de 10 pixels
      right: 16,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
          _hoverController.forward();
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
          _hoverController.reverse();
        },
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            final scale = 1.0 + (_hoverController.value * 0.15); // 15% d'agrandissement
            return Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: widget.interactionsEnabled ? () {
                  setState(() {
                    GlobalTimerService().setHasBeenClicked(true);
                  });
                  widget.onTimerTap?.call();
                } : null,
                onDoubleTap: widget.interactionsEnabled ? widget.onTimerDoubleTap : null,
                child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLowTime 
              ? [Colors.red.shade700, Colors.red.shade500]
              : [const Color(0xFF1A237E), const Color(0xFF00B0FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            // Ombre principale très renforcée
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 18,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
            // Ombre secondaire pour l'effet de profondeur ultra renforcé
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 6,
              offset: const Offset(0, 12),
            ),
            // Ombre de relief pour l'effet 3D accentué
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Réduit de 12 à 8
        child: widget.readyMode && !_isTimerRunning && !_isTimerPaused
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _isTimerRunning = true;
                });
                _startTimer();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer,
                    size: 22,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center, // Centré au lieu de start
                    children: [
                      const Text(
                        'Démarrer le',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        'dépannage ${widget.initialDuration.inMinutes} min',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isTimerRunning
              ? AnimatedBuilder(
                  animation: _sandglassController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _sandglassController.value * 3.14159,
                      child: const Icon(
                        Icons.hourglass_empty,
                        size: 22,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              : const Icon(
                  Icons.hourglass_empty,
                  size: 22,
                  color: Colors.white,
                ),
            const SizedBox(width: 8),
            
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!GlobalTimerService().hasBeenClicked && !_isTimerRunning && widget.interactionsEnabled) ...[
                  Text(
                    'Dépannage',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      decoration: TextDecoration.none, // Enlever le soulignement
                    ),
                  ),
                ],
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none, // Enlever le soulignement
                  ),
                ),
              ],
            ),
            
            if ((_isTimerRunning || _isTimerPaused) && _remainingTime.inSeconds > 0) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _isTimerRunning ? _pauseTimer : _resumeTimer,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isTimerRunning ? Icons.pause : Icons.play_arrow,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ] else if (_remainingTime.inSeconds > 0 && !widget.readyMode) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _startTimer,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}