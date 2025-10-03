// Fichier: lib/screens/commercial_scenario_screen.dart
// PARTIE 1/4 : Imports, classe, variables d'état et méthodes principales

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/commercial_scenario.dart';
import '../services/commercial_scenario_service.dart';
import '../services/global_timer_service.dart';
import '../data/commercial_scenarios_data.dart';
import '../widgets/app_footer.dart';

class CommercialScenarioScreen extends StatefulWidget {
  const CommercialScenarioScreen({super.key});

  @override
  State<CommercialScenarioScreen> createState() => _CommercialScenarioScreenState();
}

class _CommercialScenarioScreenState extends State<CommercialScenarioScreen> {
  CommercialScenario? _currentScenario;
  TimerState _timerState = const TimerState(
    totalDuration: Duration(minutes: 30),
    remainingTime: Duration(minutes: 30),
    isRunning: false,
    isPaused: false,
    isFinished: false,
  );
  Timer? _timer;
  bool _showCorrection = false;
  ChifousiGame? _chifousiGame;
  bool _showChifoumi = false;
  bool _hasEvaluated = false;
  
  int _chifousiWins = 0;
  int _chifousiDraws = 0;
  int _chifousiLosses = 0;

  final Map<DifficultyLevel, int> _successByDifficulty = {
    DifficultyLevel.easy: 0,
    DifficultyLevel.medium: 0,
    DifficultyLevel.hard: 0,
  };

  final Map<DifficultyLevel, int> _attemptsByDifficulty = {
    DifficultyLevel.easy: 0,
    DifficultyLevel.medium: 0,
    DifficultyLevel.hard: 0,
  };

  final TextEditingController _scenarioNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scenarioNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _chifousiWins = prefs.getInt('chifousi_wins') ?? 0;
      _chifousiDraws = prefs.getInt('chifousi_draws') ?? 0;
      _chifousiLosses = prefs.getInt('chifousi_losses') ?? 0;
      
      _successByDifficulty[DifficultyLevel.easy] = prefs.getInt('success_easy') ?? 0;
      _successByDifficulty[DifficultyLevel.medium] = prefs.getInt('success_medium') ?? 0;
      _successByDifficulty[DifficultyLevel.hard] = prefs.getInt('success_hard') ?? 0;
      
      _attemptsByDifficulty[DifficultyLevel.easy] = prefs.getInt('attempts_easy') ?? 0;
      _attemptsByDifficulty[DifficultyLevel.medium] = prefs.getInt('attempts_medium') ?? 0;
      _attemptsByDifficulty[DifficultyLevel.hard] = prefs.getInt('attempts_hard') ?? 0;
    });
  }

  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt('chifousi_wins', _chifousiWins);
    await prefs.setInt('chifousi_draws', _chifousiDraws);
    await prefs.setInt('chifousi_losses', _chifousiLosses);
    
    await prefs.setInt('success_easy', _successByDifficulty[DifficultyLevel.easy] ?? 0);
    await prefs.setInt('success_medium', _successByDifficulty[DifficultyLevel.medium] ?? 0);
    await prefs.setInt('success_hard', _successByDifficulty[DifficultyLevel.hard] ?? 0);
    
    await prefs.setInt('attempts_easy', _attemptsByDifficulty[DifficultyLevel.easy] ?? 0);
    await prefs.setInt('attempts_medium', _attemptsByDifficulty[DifficultyLevel.medium] ?? 0);
    await prefs.setInt('attempts_hard', _attemptsByDifficulty[DifficultyLevel.hard] ?? 0);
  }

  int _getSuccessByDifficulty(DifficultyLevel difficulty) {
    return _successByDifficulty[difficulty] ?? 0;
  }

  int _getAttemptsByDifficulty(DifficultyLevel difficulty) {
    return _attemptsByDifficulty[difficulty] ?? 0;
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Colors.green;
      case DifficultyLevel.medium:
        return Colors.orange;
      case DifficultyLevel.hard:
        return Colors.red;
    }
  }

  void _startRandomScenario() {
    final scenario = CommercialScenarioService.drawRandomScenario();
    setState(() {
      _currentScenario = scenario;
      _showCorrection = false;
      _showChifoumi = false;
      _chifousiGame = null;
      _hasEvaluated = false;
    });
    _resetTimer();
  }

  void _showChifousiInterface() {
    setState(() {
      _showChifoumi = true;
      _showCorrection = false;
      _currentScenario = null;
      _chifousiGame = null;
    });
    _resetTimer();
  }

  void _playChifoumi(ChifousiChoice playerChoice) {
    final game = CommercialScenarioService.playChifoumi(playerChoice);
    setState(() {
      _chifousiGame = game;
      // ✅ CORRECTION : Ne PAS incrémenter les stats ici
    });
  }

  void _launchScenarioFromChifoumi() {
    if (_chifousiGame == null) return;
    
    final scenario = CommercialScenarioService.drawChallengeScenario(_chifousiGame!.result);
    setState(() {
      _currentScenario = scenario;    
      // ✅ CORRECTION : Incrémenter les stats chifoumi ICI
      switch (_chifousiGame!.result) {
        case ChifousiResult.win:
          _chifousiWins++;
          break;
        case ChifousiResult.draw:
          _chifousiDraws++;
          break;
        case ChifousiResult.lose:
          _chifousiLosses++;
          break;
      }
      
      _showChifoumi = false;
      _showCorrection = false;
      _chifousiGame = null;
      _hasEvaluated = false;
    });
    
    _saveStatistics();
    _resetTimer();
  }

  void _selectScenarioById(String idString) {
    final id = int.tryParse(idString);
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un numéro valide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final allScenarios = CommercialScenariosDatabase.getAllScenarios();
    final scenario = allScenarios.firstWhere(
      (s) => s.id == id,
      orElse: () => allScenarios[0],
    );
    
    if (scenario.id != id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scénario #$id introuvable'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _currentScenario = scenario;
      _showCorrection = false;
      _showChifoumi = false;
      _chifousiGame = null;
      _hasEvaluated = false;
    });
    _resetTimer();
    _scenarioNumberController.clear();
  }

  void _selectScenarioByDifficulty(DifficultyLevel difficulty) {
    final scenarios = CommercialScenariosDatabase.getScenariosByDifficulty(difficulty);
    
    if (scenarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun scénario disponible pour ce niveau'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final random = (scenarios.toList()..shuffle()).first;
    
    setState(() {
      _currentScenario = random;
      _showCorrection = false;
      _showChifoumi = false;
      _chifousiGame = null;
      _hasEvaluated = false;
    });
    _resetTimer();
  }

// PARTIE 2/4 : Méthodes de gestion du timer et dialogues

  void _startTimer() {
    _resetTimer();
    setState(() {
      _timerState = _timerState.copyWith(
        remainingTime: _timerState.totalDuration,
        isRunning: true,
        isPaused: false,
        isFinished: false,
      );
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerState.remainingTime.inSeconds <= 0) {
        _finishTimer();
        return;
      }

      setState(() {
        _timerState = _timerState.copyWith(
          remainingTime: Duration(
            seconds: _timerState.remainingTime.inSeconds - 1,
          ),
        );
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _timerState = _timerState.copyWith(
        isRunning: false,
        isPaused: true,
      );
    });
  }

  void _resumeTimer() {
    setState(() {
      _timerState = _timerState.copyWith(
        isRunning: true,
        isPaused: false,
      );
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerState.remainingTime.inSeconds <= 0) {
        _finishTimer();
        return;
      }

      setState(() {
        _timerState = _timerState.copyWith(
          remainingTime: Duration(
            seconds: _timerState.remainingTime.inSeconds - 1,
          ),
        );
      });
    });
  }

Future<bool> _checkEvaluationBeforeLeaving() async {
  if (_currentScenario == null || _hasEvaluated || !_showCorrection) {
    return true;
  }

  final shouldLeave = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Expanded(child: Text('Auto-évaluation non effectuée')),
          ],
        ),
        content: const Text(
          'Vous n\'avez pas encore fait votre auto-évaluation pour ce scénario.\n\n'
          'Souhaitez-vous vraiment quitter sans évaluer votre travail ?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Rester et évaluer', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Quitter sans évaluer', style: TextStyle(fontSize: 16)),
          ),
        ],
      );
    },
  );

  return shouldLeave ?? false;
}

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timerState = _timerState.copyWith(
        remainingTime: _timerState.totalDuration,
        isRunning: false,
        isPaused: false,
        isFinished: false,
      );
    });
  }

  void _finishTimer() {
    _timer?.cancel();
    setState(() {
      _timerState = _timerState.copyWith(
        isRunning: false,
        isPaused: false,
        isFinished: true,
        remainingTime: Duration.zero,
      );
      _showCorrection = true;
    });
  }

  void _showCorrectionManually() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text('Afficher la correction ?'),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir voir la correction maintenant ?\n\n'
            'Le timer sera mis en pause et vous pourrez analyser les solutions proposées.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _showCorrection = true;
                });
                _pauseTimer();
              },
              child: const Text('Voir la correction', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
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
                  'Scénario #${_currentScenario?.id ?? "N/A"}',
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
                    hintText: 'Exemple : Le produit proposé ne correspond pas au budget...',
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
    if (_currentScenario == null) return;

    final emailBody = '''
=== COMMENTAIRE UTILISATEUR ===
${userComment.isNotEmpty ? userComment : '[Aucun commentaire]'}

=====================================

SCÉNARIO #${_currentScenario!.id} - ${_currentScenario!.difficultyLabel}

Client : ${_currentScenario!.clientProfile}
Demande : ${_currentScenario!.clientRequest}
Budget : ${_currentScenario!.budgetInfo}
Attitude : ${_currentScenario!.clientAttitude.isEmpty ? 'Non renseigné' : _currentScenario!.clientAttitude}

QUESTIONS CLÉS :
${_currentScenario!.keyQuestions.map((q) => '• $q').join('\n')}

SOLUTIONS :
${_currentScenario!.solutions.map((s) => '''
${s.productName} - ${s.price}
Avantages : ${s.advantages.join(', ')}
Inconvénients : ${s.disadvantages.join(', ')}
URL : ${s.productUrl ?? 'N/A'}
''').join('\n---\n')}

PIÈGES : ${_currentScenario!.commonTraps.join(', ')}
COMPÉTENCES : ${_currentScenario!.skillsWorked.join(', ')}
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'xavier.redondo@groupeleparc.fr',
      query: Uri.encodeFull(
        'subject=XR Tech Tools : scénario ${_currentScenario!.id} signalement'
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

// PARTIE 3/4 : Build principal et widgets de sélection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              tooltip: 'Dashboard',
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {  // ← AJOUTER async
                if (_currentScenario != null || _showChifoumi) {
                  final canLeave = await _checkEvaluationBeforeLeaving();  // ← AJOUTER
                  if (canLeave) {  // ← AJOUTER
                    setState(() {
                      _currentScenario = null;
                      _showChifoumi = false;
                      _showCorrection = false;
                      _chifousiGame = null;
                      _hasEvaluated = false;  // ← AJOUTER
                    });
                    _resetTimer();
                  }  // ← AJOUTER
                } else {
                  Navigator.of(context).pop();
                }
              },
              tooltip: 'Retour',
            ),
          ],
        ),
        leadingWidth: 100,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business_center),
            SizedBox(width: 8),
            Text('Scénarios Commerciaux'),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0x4DFFFFFF),
                  ),
                ),
                child: const Text(
                  'v1.3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                      if (_currentScenario == null && !_showChifoumi)
                        _buildModeSelection(),

                      if (_showChifoumi)
                        _buildChifousiInterface(),

                      if (_currentScenario != null)
                        _buildTimerWidget(),

                      if (_currentScenario != null && !_showCorrection)
                        _buildTimerButton(),

                      if (_currentScenario != null && !_showCorrection)
                        _buildScenarioDisplay(),

                      if (_showCorrection && _currentScenario != null)
                        _buildCorrectionSheet(),

                      if (_currentScenario == null && !_showChifoumi)
                        _buildWelcomeMessage(),

                      const SizedBox(height: 32),
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

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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

// REMPLACER la méthode _buildModeSelection() dans la partie 3/4 par celle-ci :

Widget _buildModeSelection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Introduction (inchangée)
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00B0FF).withOpacity(0.1),
              const Color(0xFF1A237E).withOpacity(0.05),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.contact_support,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Conseil Commercial & Vente',
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
              'Entraînez-vous au conseil client avec des situations réalistes de magasin informatique. '
              'Développez vos compétences en vente, analyse des besoins et proposition de solutions adaptées.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('IDI', Colors.blue.shade700),
                const SizedBox(width: 8),
                _buildInfoChip('TIP', Colors.orange.shade700),
              ],
            ),
          ],
        ),
      ),
      
      const SizedBox(height: 40),
      
      // FORMAT COMPACT : Choix du mode dans une seule Card
      Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Choisissez votre mode de tirage',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Tirage Classique
              ElevatedButton.icon(
                icon: const Icon(Icons.casino, size: 24),
                label: const Text(
                  'Tirage Classique',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: _startRandomScenario,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Mode Défi
              ElevatedButton.icon(
                icon: const Icon(Icons.fitness_center, size: 24),
                label: const Text(
                  'Mode Défi (Chifoumi)',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: _showChifousiInterface,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      
      const SizedBox(height: 24),
      
      // Sélection par numéro
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
                    controller: _scenarioNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Entrez le numéro (1-100)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: (value) => _selectScenarioById(value),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    _selectScenarioById(_scenarioNumberController.text);
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
      
      // Sélection par difficulté (format original avec gros boutons)
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
                  child: _buildDifficultySelectionButton(
                    'Facile',
                    DifficultyLevel.easy,
                    Colors.green,
                    Icons.star,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDifficultySelectionButton(
                    'Moyen',
                    DifficultyLevel.medium,
                    Colors.orange,
                    Icons.star_half,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDifficultySelectionButton(
                    'Difficile',
                    DifficultyLevel.hard,
                    Colors.red,
                    Icons.star_border,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
  Widget _buildDifficultySelectionButton(String label, DifficultyLevel difficulty, Color color, IconData icon) {
    final count = CommercialScenariosDatabase.getCountByDifficulty(difficulty);
    return ElevatedButton(
      onPressed: () => _selectScenarioByDifficulty(difficulty),
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
            '$count scénario${count > 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

// PARTIE 4/4 : Widgets Chifoumi, Timer, Scénario, Correction et Welcome

  Widget _buildChifousiInterface() {
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
                  _buildCounterBadge('Victoires', _chifousiWins, Colors.green),
                  _buildCounterBadge('Égalités', _chifousiDraws, Colors.orange),
                  _buildCounterBadge('Défaites', _chifousiLosses, Colors.red),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (_chifousiGame == null) ...[
              const Text(
                'Faites votre choix :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChifousiButton(
                    choice: ChifousiChoice.rock,
                    icon: '🪨',
                    label: 'Pierre',
                  ),
                  _buildChifousiButton(
                    choice: ChifousiChoice.paper,
                    icon: '📄',
                    label: 'Feuille',
                  ),
                  _buildChifousiButton(
                    choice: ChifousiChoice.scissors,
                    icon: '✂️',
                    label: 'Ciseaux',
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mode Défi : Pierre-Feuille-Ciseaux',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Victoire = Facile  •  Égalité = Moyen  •  Défaite = Difficile',
                            style: TextStyle(
                              color: Colors.orange.shade700,
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
              _buildChifousiResult(),
            ],
          ],
        ),
      ),
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

  Widget _buildChifousiButton({
    required ChifousiChoice choice,
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

  Widget _buildChifousiResult() {
    if (_chifousiGame == null) return const SizedBox();
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  CommercialScenarioService.getChifousiChoiceIcon(_chifousiGame!.playerChoice),
                  style: const TextStyle(fontSize: 50),
                ),
                const Text('Vous', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Text('VS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Column(
              children: [
                Text(
                  CommercialScenarioService.getChifousiChoiceIcon(_chifousiGame!.aiChoice),
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
            color: _getResultColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getResultColor().withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                _chifousiGame!.resultLabel,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getResultColor(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                CommercialScenarioService.getChifousiResultExplanation(_chifousiGame!),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _getResultColor().withOpacity(0.8),
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
                  _chifousiGame = null;
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
              onPressed: _launchScenarioFromChifoumi,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Lancer le scénario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getResultColor(),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getResultColor() {
    if (_chifousiGame == null) return Colors.grey;
    switch (_chifousiGame!.result) {
      case ChifousiResult.win:
        return Colors.green;
      case ChifousiResult.draw:
        return Colors.orange;
      case ChifousiResult.lose:
        return Colors.red;
    }
  }

  Widget _buildTimerWidget() {
    final minutes = _timerState.remainingTime.inMinutes;
    final seconds = _timerState.remainingTime.inSeconds % 60;
    final isLowTime = _timerState.remainingTime.inMinutes < 5;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLowTime 
            ? [Colors.red.shade700, Colors.red.shade500]
            : [const Color(0xFF1A237E), const Color(0xFF00B0FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          const Icon(Icons.timer, size: 24, color: Colors.white),
          const SizedBox(width: 12),
          
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: !_timerState.isRunning && !_timerState.isFinished
              ? ElevatedButton.icon(
                  onPressed: _timerState.isPaused ? _resumeTimer : _startTimer,
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: Text(_timerState.isPaused ? 'Reprendre' : 'Démarrer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF00B0FF),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                )
              : _timerState.isRunning
                ? ElevatedButton.icon(
                    onPressed: _pauseTimer,
                    icon: const Icon(Icons.pause, size: 18),
                    label: const Text('Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF00B0FF),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          
          const SizedBox(width: 12),
          
          IconButton(
            onPressed: _showCorrectionManually,
            icon: const Icon(Icons.help_outline, size: 24),
            tooltip: 'Voir la correction',
            color: Colors.white,
          ),
        ],
      ),
    );
  }

Widget _buildTimerButton() {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF1E3A8A).withOpacity(0.8),
          const Color(0xFF3B82F6).withOpacity(0.9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.timer,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Conseil temporisé',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gérez ce scénario en moins de 30 minutes',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            GlobalTimerService().startFloatingTimer(
              duration: const Duration(minutes: 30),
              onFinish: () {
                // Actions quand le timer se termine
              },
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Timer de conseil démarré !'),
                  ],
                ),
                backgroundColor: Color(0xFF1A237E),
                duration: Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.play_arrow, size: 20),
          label: const Text(
            'Démarrer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E3A8A),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
        ),
      ],
    ),
  );
}

Widget _buildScenarioDisplay() {
  if (_currentScenario == null) return const SizedBox();
  
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: _getDifficultyColor(_currentScenario!.difficulty),
        width: 4,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getDifficultyColor(_currentScenario!.difficulty).withOpacity(0.3),
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
            // En-tête avec badge difficulté
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scénario Commercial',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(_currentScenario!.difficulty),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          int filledStars = _currentScenario!.difficulty == DifficultyLevel.easy ? 1 
                              : _currentScenario!.difficulty == DifficultyLevel.medium ? 2 
                              : 3;
                          return Icon(
                            index < filledStars ? Icons.star : Icons.star_border,
                            color: Colors.white,
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentScenario!.difficultyLabel,
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
            const Divider(height: 30, thickness: 2),
            
            // Section DEMANDE CLIENT
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
                            'DEMANDE CLIENT #${_currentScenario!.id}',
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
                        '${_currentScenario!.clientProfile} qui ${_currentScenario!.clientRequest}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Section BUDGET
            Stack(
              children: [
                Positioned(
                  right: 10,
                  top: 10,
                  child: Icon(
                    Icons.euro,
                    size: 60,
                    color: Colors.green.shade100.withOpacity(0.3),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet, size: 24, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'BUDGET',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _currentScenario!.budgetInfo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Section CONSIGNES
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
                        'Analysez la demande, posez les bonnes questions et proposez une solution adaptée. '
                        'Vous pouvez faire des recherches en ligne.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Section AUTRES INFORMATIONS (AJOUTÉE)
            if (_currentScenario!.clientAttitude.isNotEmpty)
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
                          _currentScenario!.clientAttitude,
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
  );
}
// PARTIE 4BIS/4 : Méthodes _buildCorrectionSheet et _buildWelcomeMessage

  Widget _buildCorrectionSheet() {
    if (_currentScenario == null) return const SizedBox();
    
    return Card(
      color: Colors.green.shade50,
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
                      'Fiche de Correction #${_currentScenario!.id}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
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
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            
            _buildCorrectionSection(
              'SCÉNARIO',
              [_currentScenario!.fullDescription],
              Icons.assignment,
            ),
            
            _buildCorrectionSection(
              'QUESTIONS CLÉS À POSER',
              _currentScenario!.keyQuestions,
              Icons.help_outline,
            ),
            
            _buildCorrectionSectionSolutions(
              'SOLUTIONS POSSIBLES',
              _currentScenario!.solutions,
              Icons.lightbulb,
            ),
            
            if (_currentScenario!.commonTraps.isNotEmpty)
              _buildCorrectionSection(
                'PIÈGES À ÉVITER',
                _currentScenario!.commonTraps,
                Icons.warning,
              ),
            
            _buildCorrectionSection(
              'COMPÉTENCES TRAVAILLÉES',
              _currentScenario!.skillsWorked,
              Icons.school,
            ),
            
const SizedBox(height: 20),

if (!_hasEvaluated)  // ← AJOUTER CE IF
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
          'Avez-vous réussi ce scénario ?',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (_currentScenario != null) {
                    // ← AJOUTER l'incrémentation de tentative
                    _attemptsByDifficulty[_currentScenario!.difficulty] = 
                      (_attemptsByDifficulty[_currentScenario!.difficulty] ?? 0) + 1;
                    _successByDifficulty[_currentScenario!.difficulty] = 
                      (_successByDifficulty[_currentScenario!.difficulty] ?? 0) + 1;
                    _hasEvaluated = true;  // ← AJOUTER
                  }
                });
                _saveStatistics();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Scénario validé comme réussi !'),
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
                  if (_currentScenario != null) {
                    // ← AJOUTER l'incrémentation de tentative
                    _attemptsByDifficulty[_currentScenario!.difficulty] = 
                      (_attemptsByDifficulty[_currentScenario!.difficulty] ?? 0) + 1;
                    _hasEvaluated = true;  // ← AJOUTER
                  }
                });
                _saveStatistics();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✗ Scénario marqué comme à retravailler'),
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
else  // ← AJOUTER CE ELSE
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
      label: const Text('Nouveau Scénario'),
      onPressed: () async {  // ← AJOUTER async
        final canLeave = await _checkEvaluationBeforeLeaving();  // ← AJOUTER
        if (canLeave) {  // ← AJOUTER
          setState(() {
            _currentScenario = null;
            _showCorrection = false;
            _showChifoumi = false;
            _hasEvaluated = false;  // ← AJOUTER
          });
          _resetTimer();
        }  // ← AJOUTER
      },
    ),
    ElevatedButton.icon(
      icon: const Icon(Icons.fitness_center),
      label: const Text('Mode Défi'),
      onPressed: () async {  // ← AJOUTER async
        final canLeave = await _checkEvaluationBeforeLeaving();  // ← AJOUTER
        if (canLeave) {  // ← AJOUTER
          setState(() {
            _currentScenario = null;
            _showCorrection = false;
            _showChifoumi = true;
            _hasEvaluated = false;  // ← AJOUTER
          });
          _resetTimer();
        }  // ← AJOUTER
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
    );
  }

  Widget _buildCorrectionSection(String title, List<String> items, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.green.shade700),
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
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Text(
              '• $item',
              style: const TextStyle(fontSize: 14),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCorrectionSectionSolutions(
    String title,
    List<ScenarioSolution> solutions,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.green.shade700),
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
          ...solutions.map((solution) => Container(
            margin: const EdgeInsets.only(left: 16, bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        solution.productName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        solution.price,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '✓ ${solution.advantages.join('\n✓ ')}',
                  style: TextStyle(fontSize: 13, color: Colors.green.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  '✗ ${solution.disadvantages.join('\n✗ ')}',
                  style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                ),
                if (solution.productUrl != null) ...[
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(solution.productUrl!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Impossible d\'ouvrir le lien : ${solution.productUrl}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Voir le produit'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    final stats = CommercialScenarioService.getScenarioStats();
    
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  '${stats['total']} scénarios disponibles', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue.shade700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${stats['facile']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.green, size: 14),
                            Icon(Icons.star_border, color: Colors.green, size: 14),
                            Icon(Icons.star_border, color: Colors.green, size: 14),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Faciles', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${stats['moyen']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            Icon(Icons.star_border, color: Colors.orange, size: 14),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Moyens', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${stats['difficile']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.red, size: 14),
                            Icon(Icons.star, color: Colors.red, size: 14),
                            Icon(Icons.star, color: Colors.red, size: 14),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Difficiles', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(thickness: 2, color: Colors.blue.shade200),
                ),
                
                Text(
                  'Statistiques de réussite',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${_getSuccessByDifficulty(DifficultyLevel.easy)} / ${_getAttemptsByDifficulty(DifficultyLevel.easy)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.green, size: 14),
                            Icon(Icons.star_border, color: Colors.green, size: 14),
                            Icon(Icons.star_border, color: Colors.green, size: 14),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Faciles',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${_getSuccessByDifficulty(DifficultyLevel.medium)} / ${_getAttemptsByDifficulty(DifficultyLevel.medium)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            Icon(Icons.star_border, color: Colors.orange, size: 14),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Moyens',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${_getSuccessByDifficulty(DifficultyLevel.hard)} / ${_getAttemptsByDifficulty(DifficultyLevel.hard)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.red, size: 14),
                            Icon(Icons.star, color: Colors.red, size: 14),
                            Icon(Icons.star, color: Colors.red, size: 14),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Difficiles',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
} // FIN DE LA CLASSE _CommercialScenarioScreenState