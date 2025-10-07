import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/malfunction.dart';
import '../services/malfunction_service.dart';
import '../services/flowchart_service.dart';
import '../services/global_timer_service.dart';
import '../models/flowchart_models.dart';
import '../screens/interactive_flowchart_screen.dart';
import '../widgets/app_footer.dart';
import '../widgets/custom_app_bar.dart';
import '../data/tool_data.dart';

// Énumération pour le Chifoumi
enum ChifoumiChoice { rock, paper, scissors }
enum ChifoumiResult { win, draw, lose }

class ChifoumiGame {
  final ChifoumiChoice playerChoice;
  final ChifoumiChoice aiChoice;
  final ChifoumiResult result;
  final MalfunctionDifficulty difficulty;

  ChifoumiGame({
    required this.playerChoice,
    required this.aiChoice,
    required this.result,
    required this.difficulty,
  });

  String get resultLabel {
    switch (result) {
      case ChifoumiResult.win:
        return 'Victoire !';
      case ChifoumiResult.draw:
        return 'Égalité !';
      case ChifoumiResult.lose:
        return 'Défaite !';
    }
  }
}

class MalfunctionTechnicianScreen extends StatefulWidget {
  final String? malfunctionId;
  
  const MalfunctionTechnicianScreen({super.key, this.malfunctionId});

  @override
  State<MalfunctionTechnicianScreen> createState() => _MalfunctionTechnicianScreenState();
}

class _MalfunctionTechnicianScreenState extends State<MalfunctionTechnicianScreen> with TickerProviderStateMixin {
  Malfunction? _currentMalfunction;
  final TextEditingController _numberController = TextEditingController();
  bool _showSolution = false;
  bool _hasEvaluated = false;
  ChifoumiGame? _chifoumiGame;
  bool _showChifoumi = false;
  
  // Timer
  Timer? _timer;
  Duration _remainingTime = const Duration(minutes: 30);
  Duration? _timeElapsed; // Temps écoulé depuis le début du timer
  
  // Animation sablier
  late AnimationController _sandglassController;

  // Statistiques Mode Dépanneur (format "réussis / tentatives")
  int _easySuccess = 0;
  int _easyTotal = 0;
  int _mediumSuccess = 0;
  int _mediumTotal = 0;
  int _hardSuccess = 0;
  int _hardTotal = 0;

  // Statistiques d'abandon par difficulté
  int _easyAbandoned = 0;
  int _mediumAbandoned = 0;
  int _hardAbandoned = 0;

  // Statistiques Chifoumi
  int _chifoumiWins = 0;
  int _chifoumiDraws = 0;
  int _chifoumiLosses = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
    _sandglassController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    // Initialiser le service de timer global
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalTimerService().updateContext(context);
      
      // Charger automatiquement la panne si un ID est fourni (navigation depuis le timer)
      if (widget.malfunctionId != null) {
        _selectMalfunctionById(widget.malfunctionId!, isFromTimerNavigation: true);
      }
    });
    
    // Écouter les changements du timer global
    GlobalTimerService().addListener(_onTimerStatusChanged);
  }
  
  void _onTimerStatusChanged() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            // Forcer la reconstruction pour masquer/afficher le bouton
          });
          // Mettre à jour l'item courant pour le service de timer
          GlobalTimerService().setCurrentPageItem(
            _currentMalfunction?.id.toString(),
            _currentMalfunction != null ? 'malfunction' : null,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    // Supprimer le listener en premier
    GlobalTimerService().removeListener(_onTimerStatusChanged);
    _numberController.dispose();
    _timer?.cancel();
    _sandglassController.dispose();
    // NE PAS arrêter le timer flottant - il doit persister !
    // GlobalTimerService().stopFloatingTimer(); // Commenté pour préserver le timer
    // Notifier qu'on quitte la page
    GlobalTimerService().setCurrentPageItem(null, null);
    super.dispose();
  }

  // ========== PARTIE 2/5 : Méthodes de gestion des données et statistiques ==========

  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _easySuccess = prefs.getInt('malfunction_tech_easy_success') ?? 0;
      _easyTotal = prefs.getInt('malfunction_tech_easy_total') ?? 0;
      _mediumSuccess = prefs.getInt('malfunction_tech_medium_success') ?? 0;
      _mediumTotal = prefs.getInt('malfunction_tech_medium_total') ?? 0;
      _hardSuccess = prefs.getInt('malfunction_tech_hard_success') ?? 0;
      _hardTotal = prefs.getInt('malfunction_tech_hard_total') ?? 0;
      
      _easyAbandoned = prefs.getInt('malfunction_tech_easy_abandoned') ?? 0;
      _mediumAbandoned = prefs.getInt('malfunction_tech_medium_abandoned') ?? 0;
      _hardAbandoned = prefs.getInt('malfunction_tech_hard_abandoned') ?? 0;
      
      _chifoumiWins = prefs.getInt('malfunction_chifoumi_wins') ?? 0;
      _chifoumiDraws = prefs.getInt('malfunction_chifoumi_draws') ?? 0;
      _chifoumiLosses = prefs.getInt('malfunction_chifoumi_losses') ?? 0;
    });
  }

  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('malfunction_tech_easy_success', _easySuccess);
    await prefs.setInt('malfunction_tech_easy_total', _easyTotal);
    await prefs.setInt('malfunction_tech_medium_success', _mediumSuccess);
    await prefs.setInt('malfunction_tech_medium_total', _mediumTotal);
    await prefs.setInt('malfunction_tech_hard_success', _hardSuccess);
    await prefs.setInt('malfunction_tech_hard_total', _hardTotal);
    
    await prefs.setInt('malfunction_tech_easy_abandoned', _easyAbandoned);
    await prefs.setInt('malfunction_tech_medium_abandoned', _mediumAbandoned);
    await prefs.setInt('malfunction_tech_hard_abandoned', _hardAbandoned);
    
    await prefs.setInt('malfunction_chifoumi_wins', _chifoumiWins);
    await prefs.setInt('malfunction_chifoumi_draws', _chifoumiDraws);
    await prefs.setInt('malfunction_chifoumi_losses', _chifoumiLosses);
  }

  int _getSuccessByDifficulty(MalfunctionDifficulty difficulty) {
    switch (difficulty) {
      case MalfunctionDifficulty.easy:
        return _easySuccess;
      case MalfunctionDifficulty.medium:
        return _mediumSuccess;
      case MalfunctionDifficulty.hard:
        return _hardSuccess;
    }
  }

  int _getTotalByDifficulty(MalfunctionDifficulty difficulty) {
    switch (difficulty) {
      case MalfunctionDifficulty.easy:
        return _easyTotal;
      case MalfunctionDifficulty.medium:
        return _mediumTotal;
      case MalfunctionDifficulty.hard:
        return _hardTotal;
    }
  }

  Color _getDifficultyColor(MalfunctionDifficulty difficulty) {
    switch (difficulty) {
      case MalfunctionDifficulty.easy:
        return Colors.green;
      case MalfunctionDifficulty.medium:
        return Colors.orange;
      case MalfunctionDifficulty.hard:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(MalfunctionCategory category) {
    switch (category) {
      case MalfunctionCategory.hardware:
        return Icons.memory;
      case MalfunctionCategory.software:
        return Icons.apps;
      case MalfunctionCategory.setup:
        return Icons.settings_applications;
      case MalfunctionCategory.network:
        return Icons.wifi;
      case MalfunctionCategory.printer:
        return Icons.print;
      case MalfunctionCategory.peripheral:
        return Icons.devices;
    }
  }

  Widget _buildSkillBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

// ========== Méthodes de navigation et tirage des pannes ==========

  Future<void> _drawRandomMalfunction() async {
    // Vérifier s'il faut arrêter le timer en cours
    bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "tirage au sort aléatoire");
    if (!canContinue || !mounted) return;
    
    setState(() {
      _currentMalfunction = MalfunctionService.drawRandomMalfunction();
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
      _timeElapsed = null; // Réinitialiser le temps écoulé pour le nouveau défi
    });
    _resetTimer();
    
    // S'assurer que le service de timer est prêt pour un nouveau timer
    GlobalTimerService().updateContext(context);
    
    // Lancer le timer flottant en mode "pas encore démarré"
    _showReadyTimer();
  }
  
  void _showReadyTimer({Duration duration = const Duration(minutes: 30)}) {
    // Message pour confirmer la création d'un nouveau timer après arrêt
    if (!GlobalTimerService().isTimerActive) {
      print('Création d\'un nouveau timer pour la panne #${_currentMalfunction?.id}');
    }
    
    GlobalTimerService().startReadyTimer(
      duration: duration,
      onFinish: () {
        _finishTimer();
      },
      associatedItemId: _currentMalfunction?.id.toString(),
      associatedItemType: 'malfunction',
      associatedScreenRoute: '/malfunction-technician', // Route vers cet écran
    );
    
    // Notifier le service de la panne actuellement affichée
    GlobalTimerService().setCurrentPageItem(
      _currentMalfunction?.id.toString(),
      'malfunction',
    );
  }

  Future<void> _showChifoumiInterface() async {
    // Vérifier s'il faut arrêter le timer en cours
    bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "mode défi Chifoumi");
    if (!canContinue || !mounted) return;
    
    setState(() {
      _showChifoumi = true;
      _showSolution = false;
      _currentMalfunction = null;
      _chifoumiGame = null;
      _hasEvaluated = false;
    });
  }

  void _playChifoumi(ChifoumiChoice playerChoice) {
    final aiChoice = ChifoumiChoice.values[
      DateTime.now().millisecondsSinceEpoch % 3
    ];
    
    ChifoumiResult result;
    if (playerChoice == aiChoice) {
      result = ChifoumiResult.draw;
    } else if (
      (playerChoice == ChifoumiChoice.rock && aiChoice == ChifoumiChoice.scissors) ||
      (playerChoice == ChifoumiChoice.paper && aiChoice == ChifoumiChoice.rock) ||
      (playerChoice == ChifoumiChoice.scissors && aiChoice == ChifoumiChoice.paper)
    ) {
      result = ChifoumiResult.win;
    } else {
      result = ChifoumiResult.lose;
    }
    
    MalfunctionDifficulty difficulty;
    switch (result) {
      case ChifoumiResult.win:
        difficulty = MalfunctionDifficulty.easy;
        break;
      case ChifoumiResult.draw:
        difficulty = MalfunctionDifficulty.medium;
        break;
      case ChifoumiResult.lose:
        difficulty = MalfunctionDifficulty.hard;
        break;
    }
    
    setState(() {
      _chifoumiGame = ChifoumiGame(
        playerChoice: playerChoice,
        aiChoice: aiChoice,
        result: result,
        difficulty: difficulty,
      );
    });
  }

  void _launchMalfunctionFromChifoumi() {
    if (_chifoumiGame == null) return;
    
    final malfunctions = MalfunctionService.getMalfunctionsByDifficulty(_chifoumiGame!.difficulty);
    if (malfunctions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune panne disponible pour ce niveau'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final malfunction = (malfunctions.toList()..shuffle()).first;
    
    setState(() {
      _currentMalfunction = malfunction;
      
      switch (_chifoumiGame!.result) {
        case ChifoumiResult.win:
          _chifoumiWins++;
          break;
        case ChifoumiResult.draw:
          _chifoumiDraws++;
          break;
        case ChifoumiResult.lose:
          _chifoumiLosses++;
          break;
      }
      
      _showChifoumi = false;
      _showSolution = false;
      _chifoumiGame = null;
      _hasEvaluated = false;
      _timeElapsed = null; // Réinitialiser le temps écoulé pour le nouveau défi
    });
    
    _saveStatistics();
    _resetTimer();
    
    // S'assurer que le service de timer est prêt pour un nouveau timer
    GlobalTimerService().updateContext(context);
    
    // Lancer le timer flottant en mode "pas encore démarré"
    _showReadyTimer();
  }

  Future<void> _selectMalfunctionById(String idString, {bool isFromTimerNavigation = false}) async {
    // Vérifier s'il faut arrêter le timer en cours (SAUF si c'est une navigation depuis le timer)
    if (!isFromTimerNavigation) {
      bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "sélection par numéro");
      if (!canContinue || !mounted) return;
    }
    
    final id = int.tryParse(idString);
    if (id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez entrer un numéro valide'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    final allMalfunctions = MalfunctionService.getMalfunctionsByDifficulty(MalfunctionDifficulty.easy) +
                           MalfunctionService.getMalfunctionsByDifficulty(MalfunctionDifficulty.medium) +
                           MalfunctionService.getMalfunctionsByDifficulty(MalfunctionDifficulty.hard);
    
    final malfunction = allMalfunctions.firstWhere(
      (m) => m.id == id,
      orElse: () => allMalfunctions[0],
    );
    
    if (malfunction.id != id) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Panne #$id introuvable'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    setState(() {
      _currentMalfunction = malfunction;
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
      _timeElapsed = null; // Réinitialiser le temps écoulé pour le nouveau défi
    });
    _numberController.clear();
    
    // Si c'est une navigation depuis le timer, ne pas réinitialiser le timer
    if (!isFromTimerNavigation) {
      _resetTimer();
      
      // S'assurer que le service de timer est prêt pour un nouveau timer
      GlobalTimerService().updateContext(context);
      
      // Lancer le timer flottant en mode "pas encore démarré"
      _showReadyTimer();
    } else {
      // Juste mettre à jour l'item courant pour le service de timer
      GlobalTimerService().setCurrentPageItem(
        _currentMalfunction?.id.toString(),
        'malfunction',
      );
    }
  }
  
  Future<void> _selectMalfunctionByDifficulty(MalfunctionDifficulty difficulty) async {
    // Vérifier s'il faut arrêter le timer en cours
    String difficultyName = difficulty == MalfunctionDifficulty.easy ? "facile" : 
                           difficulty == MalfunctionDifficulty.medium ? "moyen" : "difficile";
    bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "tirage au sort $difficultyName");
    if (!canContinue || !mounted) return;
    
    final malfunctions = MalfunctionService.getMalfunctionsByDifficulty(difficulty);
    
    if (malfunctions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucune panne disponible pour ce niveau'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    final random = (malfunctions.toList()..shuffle()).first;
    
    setState(() {
      _currentMalfunction = random;
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
      _timeElapsed = null; // Réinitialiser le temps écoulé pour le nouveau défi
    });
    
    // S'assurer que le service de timer est prêt pour un nouveau timer
    GlobalTimerService().updateContext(context);
    
    _showReadyTimer();
  }

  Future<void> _selectMalfunctionByCategory(MalfunctionCategory category) async {
    // Vérifier s'il faut arrêter le timer en cours
    String categoryName = category.toString().split('.').last;
    bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "tirage au sort par catégorie $categoryName");
    if (!canContinue || !mounted) return;
    
    final malfunctions = MalfunctionService.getMalfunctionsByCategory(category);
    
    if (malfunctions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucune panne disponible pour cette catégorie'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    final random = (malfunctions.toList()..shuffle()).first;
    
    setState(() {
      _currentMalfunction = random;
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
      _timeElapsed = null; // Réinitialiser le temps écoulé pour le nouveau défi
    });
    
    // S'assurer que le service de timer est prêt pour un nouveau timer
    GlobalTimerService().updateContext(context);
    
    _showReadyTimer();
  }

  // ========== PARTIE 3/5 : Méthodes Timer, Chifoumi et Logigrammes ==========

  String _getChifoumiIcon(ChifoumiChoice choice) {
    switch (choice) {
      case ChifoumiChoice.rock:
        return '🪨';
      case ChifoumiChoice.paper:
        return '📄';
      case ChifoumiChoice.scissors:
        return '✂️';
    }
  }

  Color _getChifoumiResultColor() {
    if (_chifoumiGame == null) return Colors.grey;
    switch (_chifoumiGame!.result) {
      case ChifoumiResult.win:
        return Colors.green;
      case ChifoumiResult.draw:
        return Colors.orange;
      case ChifoumiResult.lose:
        return Colors.red;
    }
  }

// ========== Méthodes Timer ==========

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = const Duration(minutes: 30);
    });
  }

  void _finishTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = Duration.zero;
      _showSolution = true;
    });
  }

  // Arrêter le timer et enregistrer le temps écoulé (pour correction/abandon)
  void _stopTimerAndRecordTime() {
    final timerService = GlobalTimerService();
    if (timerService.isTimerActive) {
      // Calculer le temps écoulé (temps initial - temps restant)
      Duration initialDuration = const Duration(minutes: 30); // Durée initiale standard
      Duration remaining = timerService.currentRemainingTime;
      _timeElapsed = initialDuration - remaining;
      
      // Arrêter complètement le timer
      timerService.stopAndResetTimer();
      
      print('Timer arrêté - Temps écoulé: ${_timeElapsed?.inMinutes ?? 0}:${((_timeElapsed?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}');
    }
  }

// ========== Méthodes Logigrammes ==========

  void _showFlowchartInBottomSheet(FlowchartInfo flowchart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InteractiveFlowchartScreen(
        flowchartInfo: flowchart,
      ),
    );
  }

  void _showFlowchartHelp() {
    if (!FlowchartService.hasCategoryFlowcharts(_currentMalfunction!.category)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Text('Logigramme non disponible'),
            ],
          ),
          content: Text(
            'Les logigrammes pour la catégorie "${_currentMalfunction!.categoryLabel}" '
            'seront bientôt disponibles.\n\n'
            'Utilisez les procédures de diagnostic classiques en attendant.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    
    final suggestedFlowchart = FlowchartService.detectBestFlowchart(_currentMalfunction!);
    final allFlowcharts = FlowchartService.getFlowchartsByCategory(_currentMalfunction!.category);
    
    if (suggestedFlowchart == null) {
      _showFlowchartSelection(allFlowcharts, null);
    } else if (allFlowcharts.length == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InteractiveFlowchartScreen(
            flowchartInfo: suggestedFlowchart,
          ),
        ),
      );
    } else {
      _showFlowchartSuggestion(suggestedFlowchart, allFlowcharts);
    }
  }

  void _showFlowchartSuggestion(FlowchartInfo suggested, List<FlowchartInfo> allFlowcharts) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('Logigramme suggéré'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basé sur les symptômes de la panne, nous vous suggérons :',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: suggested.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: suggested.color),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_tree, color: suggested.color, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          suggested.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: suggested.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (allFlowcharts.length > 1) ...[
              const SizedBox(height: 16),
              Text(
                '${allFlowcharts.length - 1} autre(s) logigramme(s) disponible(s)',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
        actions: [
          if (allFlowcharts.length > 1)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showFlowchartSelection(allFlowcharts, suggested);
              },
              child: const Text('Voir tous'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InteractiveFlowchartScreen(
                    flowchartInfo: suggested,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: suggested.color,
              foregroundColor: Colors.white,
            ),
            child: const Text('Afficher'),
          ),
        ],
      ),
    );
  }

  void _showFlowchartSelection(List<FlowchartInfo> flowcharts, FlowchartInfo? suggested) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir un logigramme'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: flowcharts.length,
            itemBuilder: (context, index) {
              final flowchart = flowcharts[index];
              final isSuggested = flowchart == suggested;
              
              return Card(
                color: isSuggested ? flowchart.color.withOpacity(0.1) : null,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    isSuggested ? Icons.star : Icons.account_tree,
                    color: flowchart.color,
                  ),
                  title: Text(flowchart.title),
                  subtitle: isSuggested ? const Text('Suggéré') : null,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InteractiveFlowchartScreen(
                          flowchartInfo: flowchart,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showReclamationDialog() {
    final TextEditingController commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.flag, color: Colors.red.shade700),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Signaler une anomalie',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panne #${_currentMalfunction?.id ?? "N/A"}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Décrivez le problème constaté :',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Exemple : La solution proposée ne fonctionne pas...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _sendReclamationEmail(commentController.text);
              },
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Envoyer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendReclamationEmail(String userComment) async {
    if (_currentMalfunction == null) return;

    final emailBody = '''
=== COMMENTAIRE UTILISATEUR ===
${userComment.isNotEmpty ? userComment : '[Aucun commentaire]'}

=====================================

PANNE #${_currentMalfunction!.id} - ${_currentMalfunction!.difficulty.name.toUpperCase()}

Nom : ${_currentMalfunction!.name}
Description : ${_currentMalfunction!.description}
Catégorie : ${_currentMalfunction!.categoryLabel}
Symptômes : ${_currentMalfunction!.symptoms.join(', ')}
Attitude client : ${_currentMalfunction!.clientAttitude}

ÉTAPES DE CRÉATION :
${_currentMalfunction!.creationSteps.map((step) => '• $step').join('\n')}

ÉTAPES DE DIAGNOSTIC :
${_currentMalfunction!.diagnosisSteps.map((step) => '• $step').join('\n')}

ÉTAPES DE SOLUTION :
${_currentMalfunction!.solutionSteps.map((step) => '• $step').join('\n')}

COMPÉTENCES TRAVAILLÉES : ${_currentMalfunction!.skillsWorked.join(', ')}
TEMPS ESTIMÉ : ${_currentMalfunction!.estimatedTime}
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'xavier.redondo@groupeleparc.fr',
      query: Uri.encodeFull(
        'subject=XR Tech Tools : panne ${_currentMalfunction!.id} signalement'
        '&body=$emailBody'
      ).replaceAll('+', '%20'),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email ouvert. Merci de votre signalement !'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ========== PARTIE 4/5 : Build method et widgets principaux ==========

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Mode Dépanneur',
        titleIcon: Icons.handyman_outlined,
        version: ToolVersions.malfunctionTools,
        onBackPressed: () {
          if (_currentMalfunction != null || _showChifoumi) {
            setState(() {
              _currentMalfunction = null;
              _showSolution = false;
              _hasEvaluated = false;
              _showChifoumi = false;
              _chifoumiGame = null;
            });
            // Notifier qu'on n'a plus de panne affichée
            GlobalTimerService().setCurrentPageItem(null, null);
          } else {
            // Quand on retourne à l'accueil, ne pas arrêter le timer s'il est actif
            // Le timer doit persister pour permettre le retour via double-clic
            Navigator.of(context).pop();
          }
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_currentMalfunction == null && !_showChifoumi)
                        _buildWelcomeSection(),
                      
                      if (_showChifoumi)
                        _buildChifoumiInterface(),

                      // Timer retiré d'ici car maintenant en position fixe

                      if (_currentMalfunction != null && !_showSolution)
                        _buildMalfunctionSymptoms(),

                      if (_showSolution && _currentMalfunction != null)
                        _buildSolutionSheet(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const AppFooter(),
          ),
        ],
      ),
    );
  }

// ========== Widgets de construction ==========

  Widget _buildWelcomeSection() {
    final stats = MalfunctionService.getCompleteStats();
    final totalPannes = stats['total'] as int;
    final byDifficulty = stats['byDifficulty'] as Map<String, dynamic>;

    return Column(
      children: [
        // Introduction
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00B0FF).withOpacity(0.1),
                const Color(0xFF00B0FF).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00B0FF).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.build_circle,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Diagnostiquer et Réparer',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Tirez une panne au sort et diagnostiquez-la ! '
                'Vous verrez uniquement les symptômes décrits par le client. À vous de trouver la cause et la solution !',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // TIRAGE ALÉATOIRE
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.casino,
                size: 64,
                color: Color(0xFF00B0FF),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tirez une panne au sort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Vous recevrez les symptômes à diagnostiquer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _drawRandomMalfunction,
                icon: const Icon(Icons.shuffle, size: 24),
                label: const Text(
                  'TIRER UNE PANNE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B0FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
              
              const SizedBox(height: 16),
              
              ElevatedButton.icon(
                onPressed: _showChifoumiInterface,
                icon: const Icon(Icons.fitness_center, size: 24),
                label: const Text(
                  'MODE DÉFI (Chifoumi)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // SÉLECTION PAR NUMÉRO
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.tag, color: Colors.blue.shade700, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Sélectionner par numéro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Entrez le numéro (1-$totalPannes)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (value) async => await _selectMalfunctionById(value, isFromTimerNavigation: false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      await _selectMalfunctionById(_numberController.text, isFromTimerNavigation: false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // SÉLECTION PAR DIFFICULTÉ + STATISTIQUES
        // (suite dans partie 5...)

// ========== PARTIE 5/5 : Suite widgets et fin du fichier ==========

        // SÉLECTION PAR DIFFICULTÉ
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.purple.shade700, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Sélectionner par difficulté',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDifficultyButton(
                      'Facile',
                      MalfunctionDifficulty.easy,
                      Colors.green,
                      Icons.star,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDifficultyButton(
                      'Moyen',
                      MalfunctionDifficulty.medium,
                      Colors.orange,
                      Icons.star_half,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDifficultyButton(
                      'Difficile',
                      MalfunctionDifficulty.hard,
                      Colors.red,
                      Icons.star_border,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // SÉLECTION PAR CATÉGORIE
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.category, color: Colors.teal.shade700, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Sélectionner par catégorie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCategoryButton('Matériel', MalfunctionCategory.hardware, Colors.blue, Icons.memory),
                    _buildCategoryButton('Logiciel', MalfunctionCategory.software, Colors.green, Icons.apps),
                    _buildCategoryButton('Configuration', MalfunctionCategory.setup, Colors.orange, Icons.settings),
                    _buildCategoryButton('Réseau', MalfunctionCategory.network, Colors.purple, Icons.wifi),
                    _buildCategoryButton('Imprimante', MalfunctionCategory.printer, Colors.red, Icons.print),
                    _buildCategoryButton('Périphérique', MalfunctionCategory.peripheral, Colors.indigo, Icons.devices),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // STATISTIQUES
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF00B0FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00B0FF).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart, color: Color(0xFF00B0FF), size: 24),
                  const SizedBox(width: 12),
                  Text(
                    '$totalPannes pannes disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    byDifficulty['easy'] as int,
                    'Faciles',
                    Colors.green,
                    1,
                  ),
                  _buildStatColumn(
                    byDifficulty['medium'] as int,
                    'Moyens',
                    Colors.orange,
                    2,
                  ),
                  _buildStatColumn(
                    byDifficulty['hard'] as int,
                    'Difficiles',
                    Colors.red,
                    3,
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(thickness: 2, color: Colors.blue.shade200),
              ),
              
              const SizedBox(height: 16),
              
              Center(
                child: Text(
                  'Statistiques de réussite',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUserStatColumn(
                    MalfunctionDifficulty.easy,
                    'Faciles',
                    Colors.green,
                    1,
                  ),
                  _buildUserStatColumn(
                    MalfunctionDifficulty.medium,
                    'Moyens',
                    Colors.orange,
                    2,
                  ),
                  _buildUserStatColumn(
                    MalfunctionDifficulty.hard,
                    'Difficiles',
                    Colors.red,
                    3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyButton(String label, MalfunctionDifficulty difficulty, Color color, IconData icon) {
    final count = MalfunctionService.getMalfunctionsByDifficulty(difficulty).length;
    return ElevatedButton(
      onPressed: () async => await _selectMalfunctionByDifficulty(difficulty),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count panne${count > 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, MalfunctionCategory category, Color color, IconData icon) {
    final count = MalfunctionService.getMalfunctionsByCategory(category).length;
    return ElevatedButton(
      onPressed: () async => await _selectMalfunctionByCategory(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$count panne${count > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(int count, String label, Color color, int stars) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Icon(
              index < stars ? Icons.star : Icons.star_border,
              color: color,
              size: 18,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterBadge(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildUserStatColumn(MalfunctionDifficulty difficulty, String label, Color color, int stars) {
    final success = _getSuccessByDifficulty(difficulty);
    final total = _getTotalByDifficulty(difficulty);
    
    return Column(
      children: [
        Text(
          '$success / $total',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Icon(
              index < stars ? Icons.star : Icons.star_border,
              color: color,
              size: 14,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }



  // Les widgets _buildChifoumiInterface, _buildMalfunctionSymptoms et _buildSolutionSheet 
  // restent identiques à votre code actuel, sauf pour l'ajout du bouton logigramme
  // dans _buildMalfunctionSymptoms() après la section CONSIGNES :
  
  // Ajouter dans _buildMalfunctionSymptoms(), après le Container des CONSIGNES :
  /*
  if (FlowchartService.hasCategoryFlowcharts(_currentMalfunction!.category))
    Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _showFlowchartHelp,
          icon: const Icon(Icons.account_tree, size: 20),
          label: Text('Logigramme ${_currentMalfunction!.categoryLabel}'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    ),
  */

// Note : Les méthodes _buildChifoumiInterface(), _buildMalfunctionSymptoms(), 
// _buildSolutionSheet() et _buildSolutionSection() restent identiques à votre code existant
// Il faut juste ajouter le bouton logigramme mentionné ci-dessus dans _buildMalfunctionSymptoms()

// ========== PARTIE 1/2 : Widgets Chifoumi ==========

  Widget _buildChifoumiInterface() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              '"Chifoumi"',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pierre - Feuille - Ciseaux',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCounterBadge('Victoires', _chifoumiWins, Colors.green),
                  _buildCounterBadge('Égalités', _chifoumiDraws, Colors.orange),
                  _buildCounterBadge('Défaites', _chifoumiLosses, Colors.red),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (_chifoumiGame == null) ...[
              const Text(
                'Faites votre choix :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChifoumiButton(
                    choice: ChifoumiChoice.rock,
                    icon: '🪨',
                    label: 'Pierre',
                  ),
                  _buildChifoumiButton(
                    choice: ChifoumiChoice.paper,
                    icon: '📄',
                    label: 'Feuille',
                  ),
                  _buildChifoumiButton(
                    choice: ChifoumiChoice.scissors,
                    icon: '✂️',
                    label: 'Ciseaux',
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mode Défi : Pierre-Feuille-Ciseaux',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Victoire = Facile  •  Égalité = Moyen  •  Défaite = Difficile',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              _buildChifoumiResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChifoumiButton({
    required ChifoumiChoice choice,
    required String icon,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: () => _playChifoumi(choice),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildChifoumiResult() {
    if (_chifoumiGame == null) return const SizedBox();
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  _getChifoumiIcon(_chifoumiGame!.playerChoice),
                  style: const TextStyle(fontSize: 50),
                ),
                const Text('Vous', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Text('VS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Column(
              children: [
                Text(
                  _getChifoumiIcon(_chifoumiGame!.aiChoice),
                  style: const TextStyle(fontSize: 50),
                ),
                const Text('IA', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getChifoumiResultColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getChifoumiResultColor().withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                _chifoumiGame!.resultLabel,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getChifoumiResultColor(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Difficulté : ${_chifoumiGame!.difficulty == MalfunctionDifficulty.easy ? "Facile" : _chifoumiGame!.difficulty == MalfunctionDifficulty.medium ? "Moyen" : "Difficile"}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _getChifoumiResultColor().withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _chifoumiGame = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Rejouer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _launchMalfunctionFromChifoumi,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Lancer la panne'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getChifoumiResultColor(),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSolutionSection(String title, IconData icon, List<String> steps) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.withOpacity(0.4), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
// ========== PARTIE 2/2 : Widgets MalfunctionSymptoms et SolutionSheet ==========

  Widget _buildMalfunctionSymptoms() {
    if (_currentMalfunction == null) return const SizedBox();
    
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _getDifficultyColor(_currentMalfunction!.difficulty),
              width: 4,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _getDifficultyColor(_currentMalfunction!.difficulty).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ligne titre + difficulté
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '#${_currentMalfunction!.id} - Panne à Diagnostiquer',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(_currentMalfunction!.difficulty),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                int filledStars = _currentMalfunction!.difficulty == MalfunctionDifficulty.easy ? 1
                                    : _currentMalfunction!.difficulty == MalfunctionDifficulty.medium ? 2 : 3;
                                return Icon(
                                  index < filledStars ? Icons.star : Icons.star_border,
                                  color: Colors.white,
                                  size: 16,
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentMalfunction!.difficultyLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Ligne de badges + bouton diagonal
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges à gauche
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B0FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF00B0FF).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getCategoryIcon(_currentMalfunction!.category),
                                    size: 16,
                                    color: const Color(0xFF00B0FF),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _currentMalfunction!.categoryLabel,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00B0FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            ...() {
                              List<Widget> badges = [];
                              
                              bool hasIDI = _currentMalfunction!.skillsWorked.any(
                                (s) => s.toUpperCase().contains('IDI')
                              );
                              bool hasTIP = _currentMalfunction!.skillsWorked.any(
                                (s) => s.toUpperCase().contains('TIP')
                              );
                              
                              if (hasIDI) {
                                badges.add(_buildSkillBadge('IDI', Colors.blue.shade700));
                                badges.add(_buildSkillBadge('ADRN', Colors.green.shade700));
                              }
                              
                              if (hasTIP) {
                                badges.add(_buildSkillBadge('TIP', Colors.orange.shade700));
                              }
                              
                              return badges;
                            }(),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Bouton diagonal à droite
                      _buildDiagonalSolutionButton(),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Description client
                  Stack(
                    children: [
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.blue.shade100.withOpacity(0.3),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, size: 24, color: Colors.blue.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'DESCRIPTION CLIENT',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _currentMalfunction!.description,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Symptômes observés :',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ..._currentMalfunction!.symptoms.map((symptom) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.circle, size: 8, color: Colors.blue.shade700),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      symptom,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            // Nouvelle section de logigrammes
                            if (FlowchartService.hasCategoryFlowcharts(_currentMalfunction!.category)) ...[
                              const SizedBox(height: 16),
                              const Divider(height: 1, color: Colors.blue),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    _currentMalfunction!.categoryIcon,
                                    size: 24,
                                    color: Colors.blue.shade700,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 8, // Espacement horizontal entre les boutons
                                      runSpacing: 8, // Espacement vertical entre les lignes
                                      children: FlowchartService.getFlowchartsByCategory(_currentMalfunction!.category)
                                        .map((flowchart) => ActionChip(
                                          avatar: const Icon(Icons.account_tree, size: 18),
                                          label: Text(flowchart.title),
                                          onPressed: () => _showFlowchartInBottomSheet(flowchart),
                                          backgroundColor: flowchart.color.withOpacity(0.1),
                                          side: BorderSide(color: flowchart.color),
                                          labelStyle: TextStyle(color: flowchart.color),
                                        )).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Consignes
                  Stack(
                    children: [
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Icon(
                          Icons.lightbulb_outline,
                          size: 60,
                          color: Colors.amber.shade100.withOpacity(0.3),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade300, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lightbulb, size: 24, color: Colors.amber.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'CONSIGNES',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Analysez les symptômes, identifiez la cause de la panne et trouvez la solution. '
                              'Vous pouvez faire des recherches en ligne.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Attitude client
                  if (_currentMalfunction!.clientAttitude.isNotEmpty)
                    Stack(
                      children: [
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Icon(
                            Icons.psychology_outlined,
                            size: 60,
                            color: Colors.purple.shade100.withOpacity(0.3),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple.shade200, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.psychology, size: 24, color: Colors.purple.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AUTRES INFORMATIONS',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _currentMalfunction!.clientAttitude,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSolutionSheet() {
    if (_currentMalfunction == null) return const SizedBox();
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.green,
          width: 4,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Solution de la Panne #${_currentMalfunction!.id}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
                // Affichage du temps écoulé si disponible
                if (_timeElapsed != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, color: Colors.blue.shade700, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '${_timeElapsed!.inMinutes}:${(_timeElapsed!.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Bouton signaler une anomalie
                const SizedBox(width: 12),
                Tooltip(
                  message: 'Signaler une anomalie',
                  waitDuration: const Duration(milliseconds: 300),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showReclamationDialog,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            
            Container(
              width: double.infinity, // Prend toute la largeur
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panne identifiée :',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentMalfunction!.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(_currentMalfunction!.category),
                          color: Colors.blue.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentMalfunction!.categoryLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildSolutionSection(
              'Procédure de résolution',
              Icons.build,
              _currentMalfunction!.creationSteps,
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 12),
                  const Text(
                    'Compétences : ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: () {
                        List<Widget> badges = [];
                        
                        bool hasIDI = _currentMalfunction!.skillsWorked.any(
                          (s) => s.toUpperCase().contains('IDI')
                        );
                        bool hasTIP = _currentMalfunction!.skillsWorked.any(
                          (s) => s.toUpperCase().contains('TIP')
                        );
                        
                        if (hasIDI) {
                          badges.add(_buildSkillBadge('IDI', Colors.blue.shade700));
                          badges.add(_buildSkillBadge('ADRN', Colors.green.shade700));
                        }
                        
                        if (hasTIP) {
                          badges.add(_buildSkillBadge('TIP', Colors.orange.shade700));
                        }
                        
                        return badges;
                      }(),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (!_hasEvaluated)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.assessment, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'AUTO-ÉVALUATION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Avez-vous réussi ce diagnostic ?',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              switch (_currentMalfunction!.difficulty) {
                                case MalfunctionDifficulty.easy:
                                  _easyTotal++;
                                  _easySuccess++;
                                  break;
                                case MalfunctionDifficulty.medium:
                                  _mediumTotal++;
                                  _mediumSuccess++;
                                  break;
                                case MalfunctionDifficulty.hard:
                                  _hardTotal++;
                                  _hardSuccess++;
                                  break;
                              }
                              _hasEvaluated = true;
                            });
                            _saveStatistics();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✓ Panne validée comme réussie !'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_circle, size: 20),
                          label: const Text('Réussi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              switch (_currentMalfunction!.difficulty) {
                                case MalfunctionDifficulty.easy:
                                  _easyTotal++;
                                  break;
                                case MalfunctionDifficulty.medium:
                                  _mediumTotal++;
                                  break;
                                case MalfunctionDifficulty.hard:
                                  _hardTotal++;
                                  break;
                              }
                              _hasEvaluated = true;
                            });
                            _saveStatistics();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✗ Panne marquée comme à retravailler'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.cancel, size: 20),
                          label: const Text('À revoir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Auto-évaluation effectuée',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nouvelle Panne'),
                  onPressed: () {
                    setState(() {
                      _currentMalfunction = null;
                      _showSolution = false;
                      _showChifoumi = false;
                      _hasEvaluated = false;
                      _chifoumiGame = null;
                    });
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Mode Défi'),
                  onPressed: () {
                    setState(() {
                      _currentMalfunction = null;
                      _showSolution = false;
                      _showChifoumi = true;
                      _hasEvaluated = false;
                      _chifoumiGame = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }


  Widget _buildDiagonalSolutionButton() {
    return Container(
      height: 36, // Hauteur alignée avec les badges
      width: 140, // Largeur réduite
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Ombre principale pour l'effet 3D
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          // Ombre secondaire pour plus de profondeur
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          // Highlight subtil en haut
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Zone gauche - Correction (vert)
            Expanded(
              child: _buildButtonSide(
                text: 'Correction',
                color: Colors.green.shade600,
                icon: Icons.lightbulb_outline,
                isLeft: true,
                onTap: () {
                  setState(() {
                    // Arrêter le timer et enregistrer le temps
                    _stopTimerAndRecordTime();
                    _showSolution = true;
                  });
                },
              ),
            ),
            // Séparateur vertical avec effet 3D
            Container(
              width: 2,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Zone droite - Abandon (rouge)
            Expanded(
              child: _buildButtonSide(
                text: 'Abandon',
                color: Colors.red.shade600,
                icon: Icons.close,
                isLeft: false,
                onTap: () {
                  // Arrêter le timer et enregistrer le temps avant abandon
                  _stopTimerAndRecordTime();
                  _showAbandonConfirmation();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSide({
    required String text,
    required Color color,
    required IconData icon,
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: isLeft ? const Radius.circular(12) : Radius.zero,
          bottomLeft: isLeft ? const Radius.circular(12) : Radius.zero,
          topRight: !isLeft ? const Radius.circular(12) : Radius.zero,
          bottomRight: !isLeft ? const Radius.circular(12) : Radius.zero,
        ),
        splashColor: Colors.white.withOpacity(0.4),
        highlightColor: Colors.white.withOpacity(0.2),
        onHover: (isHovering) {
          // L'état hover sera géré par MouseRegion dans le widget ci-dessous
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Builder(
            builder: (context) {
              bool isHovering = false;
              return StatefulBuilder(
                builder: (context, setState) {
                  return MouseRegion(
                    onEnter: (_) => setState(() => isHovering = true),
                    onExit: (_) => setState(() => isHovering = false),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(isHovering ? 0.7 : 0.9),
                            color.withOpacity(isHovering ? 0.8 : 1.0),
                            color.withOpacity(isHovering ? 0.6 : 0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: isLeft ? const Radius.circular(12) : Radius.zero,
                          bottomLeft: isLeft ? const Radius.circular(12) : Radius.zero,
                          topRight: !isLeft ? const Radius.circular(12) : Radius.zero,
                          bottomRight: !isLeft ? const Radius.circular(12) : Radius.zero,
                        ),
                        border: Border(
                          top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                          left: isLeft ? BorderSide(color: Colors.white.withOpacity(0.3), width: 1) : BorderSide.none,
                          right: !isLeft ? BorderSide(color: Colors.white.withOpacity(0.3), width: 1) : BorderSide.none,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Icône en arrière-plan - toujours visible mais plus ou moins opaque
                          Positioned.fill(
                            child: Center(
                              child: Icon(
                                icon,
                                size: 28,
                                color: Colors.white.withOpacity(isHovering ? 0.3 : 0.6),
                              ),
                            ),
                          ),
                          // Texte au premier plan - visible seulement au survol
                          if (isHovering)
                            Center(
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(0, 1),
                                      blurRadius: 3,
                                    ),
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 2),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAbandonConfirmation() {
    if (_currentMalfunction == null) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Abandonner la panne',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, // Prend toute la largeur
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(_currentMalfunction!.category),
                          color: Colors.red.shade800,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Panne #${_currentMalfunction!.id} - ${_currentMalfunction!.categoryLabel}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Difficulté : ${_currentMalfunction!.difficultyLabel}',
                      style: TextStyle(
                        color: Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Êtes-vous sûr de vouloir abandonner cette panne ?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '• Cette action sera comptabilisée dans vos statistiques\n'
                '• Vous pourrez reprendre cette panne plus tard\n'
                '• Le timer sera arrêté',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Continuer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _abandonMalfunction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Abandonner',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _abandonMalfunction() {
    if (_currentMalfunction == null) return;

    // Enregistrer l'abandon dans les statistiques
    switch (_currentMalfunction!.difficulty) {
      case MalfunctionDifficulty.easy:
        _easyAbandoned++;
        break;
      case MalfunctionDifficulty.medium:
        _mediumAbandoned++;
        break;
      case MalfunctionDifficulty.hard:
        _hardAbandoned++;
        break;
    }

    // Sauvegarder les statistiques
    _saveStatistics();

    // Arrêter le timer global
    GlobalTimerService().stopFloatingTimer();

    // Retour à l'écran d'accueil
    setState(() {
      _currentMalfunction = null;
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
    });

    // Notifier qu'on n'a plus de panne affichée
    GlobalTimerService().setCurrentPageItem(null, null);

    // Message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Panne abandonnée et enregistrée dans les statistiques',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

} // Fin de la classe _MalfunctionTechnicianScreenState