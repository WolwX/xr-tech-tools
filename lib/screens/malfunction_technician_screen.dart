import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/malfunction.dart';
import '../services/malfunction_service.dart';
import '../services/flowchart_service.dart';  // ← AJOUTER
import '../models/flowchart_models.dart';      // ← AJOUTER
import '../screens/interactive_flowchart_screen.dart';  // ← AJOUTER
import '../widgets/app_footer.dart';

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
  const MalfunctionTechnicianScreen({super.key});

  @override
  State<MalfunctionTechnicianScreen> createState() => _MalfunctionTechnicianScreenState();
}

class _MalfunctionTechnicianScreenState extends State<MalfunctionTechnicianScreen> with SingleTickerProviderStateMixin {
  Malfunction? _currentMalfunction;
  final TextEditingController _numberController = TextEditingController();
  bool _showSolution = false;
  bool _hasEvaluated = false;
  ChifoumiGame? _chifoumiGame;
  bool _showChifoumi = false;
  
  // Timer
  Timer? _timer;
  Duration _remainingTime = const Duration(minutes: 30);
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  
  // Animation sablier
  late AnimationController _sandglassController;

  // Statistiques Mode Dépanneur (format "réussis / tentatives")
  int _easySuccess = 0;
  int _easyTotal = 0;
  int _mediumSuccess = 0;
  int _mediumTotal = 0;
  int _hardSuccess = 0;
  int _hardTotal = 0;

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
  }

  @override
  void dispose() {
    _numberController.dispose();
    _timer?.cancel();
    _sandglassController.dispose();
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

  void _drawRandomMalfunction() {
    setState(() {
      _currentMalfunction = MalfunctionService.drawRandomMalfunction();
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
    });
    _resetTimer();
  }

  void _showChifoumiInterface() {
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
    });
    
    _saveStatistics();
    _resetTimer();
  }

  void _selectMalfunctionById(String idString) {
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
    
    final allMalfunctions = MalfunctionService.getMalfunctionsByDifficulty(MalfunctionDifficulty.easy) +
                           MalfunctionService.getMalfunctionsByDifficulty(MalfunctionDifficulty.medium) +
                           MalfunctionService.getMalfunctionsByDifficulty(MalfunctionDifficulty.hard);
    
    final malfunction = allMalfunctions.firstWhere(
      (m) => m.id == id,
      orElse: () => allMalfunctions[0],
    );
    
    if (malfunction.id != id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Panne #$id introuvable'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _currentMalfunction = malfunction;
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
    });
    _numberController.clear();
    _resetTimer();
  }
  
  void _selectMalfunctionByDifficulty(MalfunctionDifficulty difficulty) {
    final malfunctions = MalfunctionService.getMalfunctionsByDifficulty(difficulty);
    
    if (malfunctions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune panne disponible pour ce niveau'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final random = (malfunctions.toList()..shuffle()).first;
    
    setState(() {
      _currentMalfunction = random;
      _showSolution = false;
      _hasEvaluated = false;
      _showChifoumi = false;
      _chifoumiGame = null;
    });
    _resetTimer();
  }

  // ========== PARTIE 3/5 : Méthodes Timer, Chifoumi et Organigrammes ==========

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

  void _startTimer() {
    _resetTimer();
    setState(() {
      _isTimerRunning = true;
      _isTimerPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 0) {
        _finishTimer();
        return;
      }

      setState(() {
        _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = true;
    });
  }

  void _resumeTimer() {
    setState(() {
      _isTimerRunning = true;
      _isTimerPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 0) {
        _finishTimer();
        return;
      }

      setState(() {
        _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = const Duration(minutes: 30);
      _isTimerRunning = false;
      _isTimerPaused = false;
    });
  }

  void _finishTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
      _remainingTime = Duration.zero;
      _showSolution = true;
    });
  }

// ========== Méthodes Organigrammes ==========

  void _showFlowchartHelp() {
    if (!FlowchartService.hasCategoryFlowcharts(_currentMalfunction!.category)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Text('Organigramme non disponible'),
            ],
          ),
          content: Text(
            'Les organigrammes pour la catégorie "${_currentMalfunction!.categoryLabel}" '
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
            Text('Organigramme suggéré'),
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
                '${allFlowcharts.length - 1} autre(s) organigramme(s) disponible(s)',
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
        title: const Text('Choisir un organigramme'),
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

  // ========== PARTIE 4/5 : Build method et widgets principaux ==========

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
              onPressed: () {
                if (_currentMalfunction != null || _showChifoumi) {
                  setState(() {
                    _currentMalfunction = null;
                    _showSolution = false;
                    _hasEvaluated = false;
                    _showChifoumi = false;
                    _chifoumiGame = null;
                  });
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
            Icon(Icons.handyman_outlined, size: 24),
            SizedBox(width: 12),
            Text(
              'Mode Dépanneur',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
                  'v0.1',
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
        backgroundColor: const Color(0xFF00B0FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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

                      if (_currentMalfunction != null)
                        _buildTimerWidget(),

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
                      onSubmitted: (value) => _selectMalfunctionById(value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      _selectMalfunctionById(_numberController.text);
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
      onPressed: () => _selectMalfunctionByDifficulty(difficulty),
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

  Widget _buildTimerWidget() {
    final minutes = _remainingTime.inMinutes;
    final seconds = _remainingTime.inSeconds % 60;
    final isLowTime = _remainingTime.inMinutes < 5;
    
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
          _isTimerRunning
            ? AnimatedBuilder(
                animation: _sandglassController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _sandglassController.value * 3.14159,
                    child: const Icon(
                      Icons.hourglass_empty,
                      size: 24,
                      color: Colors.white,
                    ),
                  );
                },
              )
            : const Icon(
                Icons.hourglass_empty,
                size: 24,
                color: Colors.white,
              ),
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
            child: (_isTimerRunning || _isTimerPaused) && _remainingTime.inSeconds > 0
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Container(
                        height: 42,
                        color: Colors.white,
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 42,
                        width: (MediaQuery.of(context).size.width - 32) * 
                               (1 - _remainingTime.inSeconds / (30 * 60)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _remainingTime.inMinutes < 5
                              ? [Colors.red.shade300, Colors.red.shade400]
                              : [const Color(0xFF00B0FF).withOpacity(0.3), 
                                 const Color(0xFF00B0FF).withOpacity(0.5)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isTimerRunning ? _pauseTimer : _resumeTimer,
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isTimerRunning ? Icons.pause : Icons.play_arrow,
                                  size: 18,
                                  color: const Color(0xFF00B0FF),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isTimerRunning ? 'Pause' : 'Reprendre',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00B0FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _remainingTime.inSeconds > 0
                ? SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: _startTimer,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Démarrer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF00B0FF),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // Les widgets _buildChifoumiInterface, _buildMalfunctionSymptoms et _buildSolutionSheet 
  // restent identiques à votre code actuel, sauf pour l'ajout du bouton organigramme
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
          label: Text('Organigramme ${_currentMalfunction!.categoryLabel}'),
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
// Il faut juste ajouter le bouton organigramme mentionné ci-dessus dans _buildMalfunctionSymptoms()

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
                  Text(
                    '#${_currentMalfunction!.id} - Panne à Diagnostiquer',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Ligne de badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      
                      const SizedBox(width: 12),
                      
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
                  
                  // BOUTON ORGANIGRAMME
                  if (FlowchartService.hasCategoryFlowcharts(_currentMalfunction!.category))
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: _showFlowchartHelp,
                          icon: const Icon(Icons.account_tree, size: 20),
                          label: Text('Organigramme ${_currentMalfunction!.categoryLabel}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ),
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

        const SizedBox(height: 24),

        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showSolution = true;
              });
            },
            icon: const Icon(Icons.help_outline, size: 20),
            label: const Text(
              'Voir la Solution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B0FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
                    'Solution de la Panne #${_currentMalfunction!.id}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            
            Container(
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
    );
  }


} // Fin de la classe _MalfunctionTechnicianScreenState