import 'package:flutter/material.dart';
import '../widgets/floating_timer.dart';
import '../screens/malfunction_technician_screen.dart';
import '../screens/commercial_scenario_screen.dart';
import '../main.dart'; // Import pour accéder à navigatorKey

class GlobalTimerService extends ChangeNotifier {
  static final GlobalTimerService _instance = GlobalTimerService._internal();
  factory GlobalTimerService() => _instance;
  GlobalTimerService._internal();

  FloatingTimer? _currentTimer;
  OverlayEntry? _overlayEntry;
  BuildContext? _context;
  
  // État actuel du timer
  Duration _currentRemainingTime = const Duration(minutes: 30);
  bool _currentTimerRunning = false;
  bool _currentTimerPaused = false;
  
  // Association timer-fiche
  String? _associatedItemId;
  String? _associatedItemType; // 'malfunction', 'scenario', etc.
  String? _associatedScreenRoute; // Route pour naviguer vers l'écran
  String? _currentPageItemId; // ID de l'item actuellement affiché sur la page
  String? _currentPageItemType; // Type de l'item actuellement affiché
  
  // Sauvegarde de l'état du timer pour la persistance
  Duration? _savedDuration;
  bool _savedAutoStart = false;
  bool _savedReadyMode = false;
  bool _hasBeenClicked = false; // Pour persister l'état du texte

  bool get isTimerActive => _overlayEntry != null;
  bool get isTimerRunning => _currentTimerRunning && _overlayEntry != null;
  String? get associatedItemId => _associatedItemId;
  String? get associatedItemType => _associatedItemType;
  String? get associatedScreenRoute => _associatedScreenRoute;
  bool get hasBeenClicked => _hasBeenClicked;
  Duration get currentRemainingTime => _currentRemainingTime; // Getter pour le temps restant
  
  void setHasBeenClicked(bool value) {
    _hasBeenClicked = value;
  }

  void initialize(BuildContext context) {
    _context = context;
    // Restaurer le timer s'il y en avait un
    _restoreTimerIfNeeded();
  }

  // Méthode pour mettre à jour le contexte de manière sécurisée
  void updateContext(BuildContext context) {
    _context = context;
  }

  // Méthodes pour être notifié des changements d'état du timer
  void updateTimerState(Duration remainingTime, bool isRunning, bool isPaused) {
    _currentRemainingTime = remainingTime;
    _currentTimerRunning = isRunning;
    _currentTimerPaused = isPaused;
  }

  // Sauvegarder l'état du timer
  void _saveTimerState() {
    // Sauvegarder l'état actuel du timer au lieu de l'état initial
    _savedDuration = _currentRemainingTime;
    _savedAutoStart = _currentTimerRunning;
    _savedReadyMode = !_currentTimerRunning && !_currentTimerPaused;
  }

  // Restaurer le timer si nécessaire
  void _restoreTimerIfNeeded() {
    if (_associatedItemId != null && _associatedItemType != null && _overlayEntry == null && _context != null) {
      // Il y avait un timer associé mais il n'est plus affiché, le restaurer
      startReadyTimer(
        duration: _savedDuration ?? const Duration(minutes: 30),
        associatedItemId: _associatedItemId,
        associatedItemType: _associatedItemType,
        associatedScreenRoute: _associatedScreenRoute,
      );
    }
  }

  // Notifier le service de l'item actuellement affiché sur la page
  void setCurrentPageItem(String? itemId, String? itemType) {
    _currentPageItemId = itemId;
    _currentPageItemType = itemType;
  }

  // Vérifier si on est déjà sur la page associée au timer
  bool _isOnAssociatedPage() {
    if (_associatedItemType == null || _associatedItemId == null) {
      return false;
    }

    // Vérifier si l'item actuellement affiché correspond à l'item associé au timer
    return _currentPageItemType == _associatedItemType && _currentPageItemId == _associatedItemId;
  }

  void startFloatingTimer({
    Duration duration = const Duration(minutes: 30),
    VoidCallback? onFinish,
  }) {
    if (_overlayEntry != null) {
      stopFloatingTimer();
    }

    if (_context == null) return;

    // Déterminer si les interactions doivent être activées
    bool enableInteractions = !_isOnAssociatedPage();

    _currentTimer = FloatingTimer(
      initialDuration: duration,
      autoStart: true,
      interactionsEnabled: enableInteractions,
      onFinish: () {
        onFinish?.call();
        _showTimeUpDialog();
      },
      onClose: stopFloatingTimer,
      onTimerTap: () {
        // Simple clic : afficher les informations seulement si on n'est pas sur la page associée
        if (!_isOnAssociatedPage()) {
          _showAssociatedItemInfo();
        }
      },
      onTimerDoubleTap: () {
        // Double clic : naviguer seulement si on n'est pas déjà sur la page associée
        if (!_isOnAssociatedPage()) {
          _saveTimerState(); // Sauvegarder avant navigation
          _navigateToAssociatedItem();
        }
      },
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
    String? associatedItemId,
    String? associatedItemType,
    String? associatedScreenRoute,
  }) {
    if (_overlayEntry != null) {
      stopFloatingTimer();
    }

    if (_context == null) return;

    // Stocker les associations
    _associatedItemId = associatedItemId;
    _associatedItemType = associatedItemType;
    _associatedScreenRoute = associatedScreenRoute;

    // Utiliser la durée sauvegardée si elle existe et correspond à l'item associé
    Duration timerDuration = duration;
    bool shouldAutoStart = false;
    bool isReadyMode = true;
    
    if (_savedDuration != null && _associatedItemId == associatedItemId && _associatedItemType == associatedItemType) {
      // Restaurer l'état sauvegardé
      timerDuration = _savedDuration!;
      shouldAutoStart = _savedAutoStart;
      isReadyMode = _savedReadyMode;
    } else {
      // Nouvelle session, sauvegarder les valeurs par défaut
      _savedDuration = duration;
      _savedAutoStart = false;
      _savedReadyMode = true;
    }

    // Déterminer si les interactions doivent être activées
    bool enableInteractions = !_isOnAssociatedPage();

    _currentTimer = FloatingTimer(
      initialDuration: timerDuration,
      autoStart: shouldAutoStart,
      readyMode: isReadyMode,
      interactionsEnabled: enableInteractions,
      onFinish: () {
        onFinish?.call();
        _showTimeUpDialog();
      },
      onClose: () {
        // Ne pas fermer le timer, juste le réinitialiser
        // Le timer reste visible pour permettre la navigation
      },
      onTimerTap: () {
        // Simple clic : afficher les informations seulement si on n'est pas sur la page associée
        if (!_isOnAssociatedPage()) {
          _showAssociatedItemInfo();
        }
      },
      onTimerDoubleTap: () {
        // Double clic : naviguer seulement si on n'est pas déjà sur la page associée
        if (!_isOnAssociatedPage()) {
          _saveTimerState(); // Sauvegarder avant navigation
          _navigateToAssociatedItem();
        }
      },
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

  void _showAssociatedItemInfo() {
    if (_associatedItemType == null || _associatedItemId == null) {
      print('Timer info: ${_associatedItemType == 'malfunction' ? 'Panne' : 'Scénario'} #$_associatedItemId');
      return;
    }

    // Obtenir un contexte valide depuis la clé de navigation globale
    final navigatorState = _getNavigatorState();
    if (navigatorState?.context != null) {
      try {
        // Afficher la belle SnackBar bleue comme avant
        ScaffoldMessenger.of(navigatorState!.context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.assignment, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Timer: ${_associatedItemType == 'malfunction' ? 'Panne' : 'Scénario'} #$_associatedItemId - Double-clic pour y retourner',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1A237E), // Bleu comme avant
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating, // Flottante pour un meilleur effet
          ),
        );
      } catch (e) {
        // Fallback en cas d'erreur avec la SnackBar
        print('Timer info: ${_associatedItemType == 'malfunction' ? 'Panne' : 'Scénario'} #$_associatedItemId - Double-clic pour y retourner');
        print('Erreur SnackBar (non critique): $e');
      }
    } else {
      // Fallback : juste le log console
      print('Timer info: ${_associatedItemType == 'malfunction' ? 'Panne' : 'Scénario'} #$_associatedItemId - Double-clic pour y retourner');
    }
  }

  void _navigateToAssociatedItem() {
    if (_associatedItemType == null || _associatedItemId == null) {
      print('Navigation impossible - Type: $_associatedItemType, ID: $_associatedItemId');
      return;
    }

    // Essayer la navigation
    try {
      // Vérifications supplémentaires pour éviter les valeurs null
      print('Tentative de navigation - Type: $_associatedItemType, ID: $_associatedItemId');
      
      // Pas de SnackBar pour éviter les problèmes de contexte - juste un log
      print('Navigation vers ${_associatedItemType == 'malfunction' ? 'la panne' : 'le scénario'} #$_associatedItemId...');

      // Obtenir le contexte depuis l'overlay actuel
      if (_overlayEntry?.mounted == true) {
        // Utiliser le contexte global de navigation si disponible
        final navigatorState = _getNavigatorState();
        if (navigatorState != null) {
          // Navigation vers l'écran associé avec le NavigatorState
          if (_associatedItemType == 'malfunction' && _associatedItemId != null) {
            print('Navigation vers malfunction avec ID: $_associatedItemId');
            navigatorState.push(
              MaterialPageRoute(
                builder: (context) => MalfunctionTechnicianScreen(malfunctionId: _associatedItemId!),
              ),
            );
          } else if (_associatedItemType == 'scenario' && _associatedItemId != null) {
            print('Navigation vers scenario avec ID: $_associatedItemId');
            navigatorState.push(
              MaterialPageRoute(
                builder: (context) => CommercialScenarioScreen(scenarioId: _associatedItemId!),
              ),
            );
          } else {
            print('Type ou ID invalide - Type: $_associatedItemType, ID: $_associatedItemId');
          }
        } else {
          print('NavigatorState non disponible');
        }
      } else {
        print('Overlay non monté ou contexte invalide');
      }
    } catch (e) {
      // En cas d'erreur complète, afficher un message dans la console
      print('Erreur de navigation du timer: $e');
      print('Stack trace: ${e.toString()}');
      print('Tentative de navigation vers ${_associatedItemType == 'malfunction' ? 'panne' : 'scénario'} #$_associatedItemId');
    }
  }

  // Méthode helper pour obtenir le NavigatorState
  NavigatorState? _getNavigatorState() {
    try {
      // Utiliser la clé de navigation globale en priorité
      if (navigatorKey.currentState != null) {
        return navigatorKey.currentState!;
      }
      
      // Fallback : essayer d'obtenir le NavigatorState depuis le contexte sauvegardé
      if (_context != null && _context!.mounted) {
        return Navigator.of(_context!);
      }
      return null;
    } catch (e) {
      print('Erreur lors de l\'obtention du NavigatorState: $e');
      return null;
    }
  }

  void stopFloatingTimer() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _currentTimer = null;
    // Nettoyer les associations
    _associatedItemId = null;
    _associatedItemType = null;
    _associatedScreenRoute = null;
    notifyListeners();
  }

  // Masquer temporairement le timer (pour le mode plein écran)
  void hideTimer() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      // Ne pas set _overlayEntry à null pour pouvoir le restaurer
    }
  }

  // Restaurer le timer masqué
  void showTimer() {
    if (_overlayEntry != null && _context != null) {
      Overlay.of(_context!).insert(_overlayEntry!);
    }
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

  // Méthode pour arrêter complètement le timer (pour completion d'exercice)
  void stopAndResetTimer() {
    stopFloatingTimer();
    _currentRemainingTime = Duration.zero;
    _currentTimerRunning = false;
    _currentTimerPaused = false;
    _associatedItemId = null;
    _associatedItemType = null;
    _associatedScreenRoute = null;
    // NE PAS effacer _context pour permettre la création d'un nouveau timer
    // _context = null; // Commenté pour permettre les nouveaux tirages
    _hasBeenClicked = false;
    
    // Effacer les données sauvegardées
    _savedDuration = null;
    _savedAutoStart = false;
    _savedReadyMode = false;
  }

  // Méthode pour afficher un popup de confirmation avant d'arrêter le timer pour un nouveau tirage
  Future<bool> showTimerStopConfirmation(BuildContext context, String actionType) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Timer en cours',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Un timer est actuellement actif.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'En continuant avec ce $actionType, l\'épreuve actuelle sera considérée comme terminée et le timer sera arrêté.',
                        style: TextStyle(fontSize: 14, color: Colors.orange.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Annuler',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Continuer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  // Méthode pour gérer l'arrêt du timer lors d'un nouveau tirage au sort
  Future<bool> handleNewDrawRequest(BuildContext context, String actionType) async {
    if (isTimerRunning) {
      bool shouldContinue = await showTimerStopConfirmation(context, actionType);
      if (shouldContinue) {
        stopAndResetTimer();
        return true;
      }
      return false;
    }
    return true; // Pas de timer en cours, on peut continuer
  }

  @override
  void dispose() {
    stopFloatingTimer();
    super.dispose();
  }
}