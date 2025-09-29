// Fichier: lib/screens/commercial_scenario_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import '../models/commercial_scenario.dart';
import '../services/commercial_scenario_service.dart';
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
  
  int _chifousiWins = 0;
  int _chifousiDraws = 0;
  int _chifousiLosses = 0;
  
  int _scenariosSuccess = 0;
  int _scenariosFailed = 0;

  // Compteurs de réussites par difficulté
  final Map<DifficultyLevel, int> _successByDifficulty = {
    DifficultyLevel.easy: 0,
    DifficultyLevel.medium: 0,
    DifficultyLevel.hard: 0,
  };

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _getSuccessByDifficulty(DifficultyLevel difficulty) {
    return _successByDifficulty[difficulty] ?? 0;
  }

  void _startRandomScenario() {
    setState(() {
      _currentScenario = CommercialScenarioService.drawRandomScenario();
      _showCorrection = false;
      _showChifoumi = false;
      _chifousiGame = null;
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
      
      switch (game.result) {
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
    });
  }

  void _launchScenarioFromChifoumi() {
    if (_chifousiGame == null) return;
    
    final scenario = CommercialScenarioService.drawChallengeScenario(_chifousiGame!.result);
    setState(() {
      _currentScenario = scenario;
      _showChifoumi = false;
      _showCorrection = false;
      _chifousiGame = null;
    });
    _resetTimer();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.business_center),
            SizedBox(width: 8),
            Text('Scénarios Commerciaux'),
          ],
        ),
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
                        _buildScenarioDisplay(),

                      if (_showCorrection && _currentScenario != null)
                        _buildCorrectionSheet(),

                      if (_currentScenario == null && !_showChifoumi)
                        _buildWelcomeMessage(),

                      const SizedBox(height: 16),
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

  Widget _buildModeSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Choisissez votre mode de tirage',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
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
            
            const SizedBox(height: 12),
            
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
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Mode Défi : Pierre-Feuille-Ciseaux',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Victoire = Facile  •  Égalité = Moyen  •  Défaite = Difficile',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChifousiInterface() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Pierre - Feuille - Ciseaux',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
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
            
            const SizedBox(height: 20),
            
            if (_chifousiGame == null) ...[
              const Text(
                'Faites votre choix :',
                style: TextStyle(fontSize: 16),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, size: 24, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _showCorrectionManually,
                icon: const Icon(Icons.help_outline, size: 24),
                tooltip: 'Voir la correction',
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!_timerState.isRunning && !_timerState.isFinished) ...[
            ElevatedButton.icon(
              onPressed: _timerState.isPaused ? _resumeTimer : _startTimer,
              icon: const Icon(Icons.play_arrow, size: 20),
              label: Text(_timerState.isPaused ? 'Reprendre' : 'Démarrer le chrono'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF00B0FF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ] else if (_timerState.isRunning) ...[
            ElevatedButton.icon(
              onPressed: _pauseTimer,
              icon: const Icon(Icons.pause, size: 20),
              label: const Text('Mettre en pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF00B0FF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScenarioDisplay() {
    if (_currentScenario == null) return const SizedBox();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(_currentScenario!.difficulty),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _currentScenario!.difficultyLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 2),
            
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
                            'DEMANDE CLIENT',
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
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.grey.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'DÉTAILS IMPORTANTS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Attitude client : ${_currentScenario!.clientAttitude.isEmpty ? "Non renseigné" : _currentScenario!.clientAttitude}\n'
                    '• Mots-clés : "${_currentScenario!.clientProfile}", "${_currentScenario!.clientRequest.split(' ').take(3).join(' ')}..."\n'
                    '• Compétences : ${_currentScenario!.skillsWorked.first}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    'Fiche de Correction',
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
                            _scenariosSuccess++;
                            if (_currentScenario != null) {
                              _successByDifficulty[_currentScenario!.difficulty] = 
                                (_successByDifficulty[_currentScenario!.difficulty] ?? 0) + 1;
                            }
                          });
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
                            _scenariosFailed++;
                          });
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
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nouveau Scénario'),
                  onPressed: _startRandomScenario,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Mode Défi'),
                  onPressed: () {
                    setState(() {
                      _currentScenario = null;
                      _showCorrection = false;
                      _showChifoumi = true;
                    });
                    _resetTimer();
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
                        if (context.mounted) {
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
    final totalAttempts = _scenariosSuccess + _scenariosFailed;
    final successRate = totalAttempts > 0 
        ? ((_scenariosSuccess / totalAttempts) * 100).toStringAsFixed(0) 
        : '0';
    
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Icon(Icons.business_center, size: 50, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Générateur de Scénarios Commerciaux',
            style: TextStyle(
              fontSize: 24, 
              color: Colors.grey.shade600, 
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Entraînez-vous au conseil client avec des situations réalistes',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
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
                    _buildStatItem('Faciles', stats['facile']!, Colors.green),
                    _buildStatItem('Moyens', stats['moyen']!, Colors.orange),
                    _buildStatItem('Difficiles', stats['difficile']!, Colors.red),
                  ],
                ),
                
                if (totalAttempts > 0) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(thickness: 2, color: Colors.blue.shade200),
                  ),
                  
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'VOS RÉUSSITES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_getSuccessByDifficulty(DifficultyLevel.easy)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              'Faciles',
                              style: TextStyle(fontSize: 11, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_getSuccessByDifficulty(DifficultyLevel.medium)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const Text(
                              'Moyens',
                              style: TextStyle(fontSize: 11, color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_getSuccessByDifficulty(DifficultyLevel.hard)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const Text(
                              'Difficiles',
                              style: TextStyle(fontSize: 11, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Taux de réussite global : ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        Text(
                          '$successRate%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        Text(
                          ' ($totalAttempts scénarios)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count', 
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: color
          )
        ),
        Text(
          label, 
          style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)
        ),
      ],
    );
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
}