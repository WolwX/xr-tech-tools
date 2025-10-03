import 'package:flutter/material.dart';
import '../widgets/floating_timer.dart';

class GlobalTimerService extends ChangeNotifier {
  static final GlobalTimerService _instance = GlobalTimerService._internal();
  factory GlobalTimerService() => _instance;
  GlobalTimerService._internal();

  FloatingTimer? _currentTimer;
  OverlayEntry? _overlayEntry;
  BuildContext? _context;

  bool get isTimerActive => _overlayEntry != null;

  void initialize(BuildContext context) {
    _context = context;
  }

  void startFloatingTimer({
    Duration duration = const Duration(minutes: 30),
    VoidCallback? onFinish,
  }) {
    if (_overlayEntry != null) {
      stopFloatingTimer();
    }

    if (_context == null) return;

    _currentTimer = FloatingTimer(
      initialDuration: duration,
      autoStart: true,
      onFinish: () {
        onFinish?.call();
        _showTimeUpDialog();
      },
      onClose: stopFloatingTimer,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => _currentTimer!,
    );

    Overlay.of(_context!).insert(_overlayEntry!);
    notifyListeners();
  }

  void startReadyTimer({
    Duration duration = const Duration(minutes: 30),
    VoidCallback? onFinish,
  }) {
    if (_overlayEntry != null) {
      stopFloatingTimer();
    }

    if (_context == null) return;

    _currentTimer = FloatingTimer(
      initialDuration: duration,
      autoStart: false, // Ne pas démarrer automatiquement
      readyMode: true,
      onFinish: () {
        onFinish?.call();
        _showTimeUpDialog();
      },
      onClose: resetTimer,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => _currentTimer!,
    );

    Overlay.of(_context!).insert(_overlayEntry!);
    notifyListeners();
  }

  void resetTimer() {
    // Réinitialise le timer sans le fermer
    notifyListeners();
  }

  void stopFloatingTimer() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _currentTimer = null;
    notifyListeners();
  }

  void _showTimeUpDialog() {
    if (_context == null) return;

    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.alarm, color: Colors.red, size: 32),
            SizedBox(width: 12),
            Text('Temps écoulé !'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Le temps imparti pour cet exercice est terminé.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Vous pouvez continuer ou recommencer l\'exercice.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              stopFloatingTimer();
            },
            child: const Text('Continuer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              stopFloatingTimer();
              // Ici on pourrait ajouter une logique pour recommencer
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
            ),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    stopFloatingTimer();
    super.dispose();
  }
}