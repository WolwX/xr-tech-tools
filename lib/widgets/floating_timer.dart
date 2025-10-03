import 'package:flutter/material.dart';
import 'dart:async';

class FloatingTimer extends StatefulWidget {
  final Duration initialDuration;
  final VoidCallback? onFinish;
  final VoidCallback? onClose;
  final bool autoStart;
  final bool readyMode;
  
  const FloatingTimer({
    super.key,
    this.initialDuration = const Duration(minutes: 30),
    this.onFinish,
    this.onClose,
    this.autoStart = true,
    this.readyMode = false,
  });

  @override
  State<FloatingTimer> createState() => _FloatingTimerState();
}

class _FloatingTimerState extends State<FloatingTimer> 
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Duration _remainingTime = const Duration(minutes: 30);
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  late AnimationController _sandglassController;
  
  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialDuration;
    _sandglassController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    if (widget.autoStart && !widget.readyMode) {
      _startTimer();
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _sandglassController.dispose();
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
    
    _sandglassController.repeat();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
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
  }
  
  void _resumeTimer() {
    setState(() {
      _isTimerRunning = true;
      _isTimerPaused = false;
    });
    _sandglassController.repeat();
    _startTimer();
  }
  
  void _finishTimer() {
    _timer?.cancel();
    _sandglassController.stop();
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
    });
    widget.onFinish?.call();
  }
  
  void _resetTimer() {
    _timer?.cancel();
    _sandglassController.stop();
    setState(() {
      _remainingTime = widget.initialDuration;
      _isTimerRunning = false;
      _isTimerPaused = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final minutes = _remainingTime.inMinutes;
    final seconds = _remainingTime.inSeconds % 60;
    final isLowTime = _remainingTime.inMinutes < 5;
    
    return Positioned(
      bottom: 30, // Position parfaite pour éviter le footer
      right: 16,
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
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Démarrer le dépannage ${widget.initialDuration.inMinutes} min',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
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
                        size: 16,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              : const Icon(
                  Icons.hourglass_empty,
                  size: 16,
                  color: Colors.white,
                ),
            const SizedBox(width: 6),
            
            Text(
              !_isTimerRunning && !_isTimerPaused && _remainingTime.inSeconds == widget.initialDuration.inSeconds
                  ? 'Démarrer le dépannage 30 min'
                  : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            if ((_isTimerRunning || _isTimerPaused) && _remainingTime.inSeconds > 0) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isTimerRunning ? _pauseTimer : _resumeTimer,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isTimerRunning ? Icons.pause : Icons.play_arrow,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ] else if (_remainingTime.inSeconds > 0) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _startTimer,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            
            // Bouton reset/fermer
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _resetTimer();
                widget.onClose?.call();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.refresh,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}