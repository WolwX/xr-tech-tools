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
import '../widgets/custom_app_bar.dart';
import '../data/tool_data.dart';

class CommercialScenarioScreen extends StatefulWidget {
  final String? scenarioId;
  
  const CommercialScenarioScreen({super.key, this.scenarioId});

  @override
  State<CommercialScenarioScreen> createState() => _CommercialScenarioScreenState();
}

class _CommercialScenarioScreenState extends State<CommercialScenarioScreen> {
  CommercialScenario? _currentScenario;
  bool _showCorrection = false;
  ChifousiGame? _chifousiGame;
  bool _showChifoumi = false;
  bool _hasEvaluated = false;
  
  int _chifousiWins = 0;
  int _chifousiDraws = 0;
  int _chifousiLosses = 0;
  
  // Variables pour gérer le temps écoulé
  DateTime? _timerStartTime;
  Duration? _elapsedTime;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialiser le GlobalTimerService pour qu'il puisse afficher le timer
    GlobalTimerService().initialize(context);
    
    // Charger automatiquement le scénario si un ID est fourni (navigation depuis le timer)
    if (widget.scenarioId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectScenarioById(widget.scenarioId!, isFromTimerNavigation: true);
      });
    }
  }

  @override
  void dispose() {
    _scenarioNumberController.dispose();
    // Notifier qu'on quitte la page
    GlobalTimerService().setCurrentPageItem(null, null);
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

  Future<void> _startRandomScenario() async {
    // Vérifier s'il faut arrêter le timer en cours
    bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "tirage au sort aléatoire de scénario");
    if (!canContinue || !mounted) return;
    
    final scenario = CommercialScenarioService.drawRandomScenario();
    setState(() {
      _currentScenario = scenario;
      _showCorrection = false;
      _showChifoumi = false;
      _chifousiGame = null;
      _hasEvaluated = false;
      // Réinitialiser le timer
      _timerStartTime = null;
      _elapsedTime = null;
    });
    
    // S'assurer que le service de timer est prêt pour un nouveau timer
    GlobalTimerService().updateContext(context);
    
    _showReadyTimer();
  }

  Future<void> _showChifousiInterface() async {
    // Vérifier s'il faut arrêter le timer en cours
    bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "mode défi Chifoumi de scénario");
    if (!canContinue || !mounted) return;
    
    setState(() {
      _showChifoumi = true;
      _showCorrection = false;
      _currentScenario = null;
      _chifousiGame = null;
    });
    // Pas de timer pour l'interface chifoumi
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
      // Réinitialiser le timer
      _timerStartTime = null;
      _elapsedTime = null;
    });
    
    _saveStatistics();
    _showReadyTimer();
  }

  Future<void> _selectScenarioById(String idString, {bool isFromTimerNavigation = false}) async {
    // Vérifier s'il faut arrêter le timer en cours (SAUF si c'est une navigation depuis le timer)
    if (!isFromTimerNavigation) {
      bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "sélection de scénario par numéro");
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
    
    final allScenarios = CommercialScenariosDatabase.getAllScenarios();
    final scenario = allScenarios.firstWhere(
      (s) => s.id == id,
      orElse: () => allScenarios[0],
    );
    
    if (scenario.id != id) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scénario #$id introuvable'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    setState(() {
      _currentScenario = scenario;
      _showCorrection = false;
      _showChifoumi = false;
      _chifousiGame = null;
      _hasEvaluated = false;
      // Réinitialiser le timer
      _timerStartTime = null;
      _elapsedTime = null;
    });
    
    // Si c'est une navigation depuis le timer, ne pas réinitialiser le timer
    if (!isFromTimerNavigation) {
      _showReadyTimer();
    } else {
      // Juste mettre à jour l'item courant pour le service de timer
      GlobalTimerService().setCurrentPageItem(
        _currentScenario?.id.toString(),
        'scenario',
      );
    }
    _scenarioNumberController.clear();
  }

  Future<void> _selectScenarioByDifficulty(DifficultyLevel difficulty) async {
    // Vérifier s'il faut arrêter le timer en cours
    String difficultyName = difficulty == DifficultyLevel.easy ? "facile" : 
                           difficulty == DifficultyLevel.medium ? "moyen" : "difficile";
    bool canContinue = await GlobalTimerService().handleNewDrawRequest(context, "tirage au sort de scénario $difficultyName");
    if (!canContinue || !mounted) return;
    
    final scenarios = CommercialScenariosDatabase.getScenariosByDifficulty(difficulty);
    
    if (scenarios.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucun scénario disponible pour ce niveau'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    final random = (scenarios.toList()..shuffle()).first;
    
    setState(() {
      _currentScenario = random;
      _showCorrection = false;
      _showChifoumi = false;
      _chifousiGame = null;
      _hasEvaluated = false;
      // Réinitialiser le timer
      _timerStartTime = null;
      _elapsedTime = null;
    });
    _showReadyTimer();
  }

// PARTIE 2/4 : Méthodes de gestion du timer flottant et dialogues

  void _showReadyTimer({Duration duration = const Duration(minutes: 30)}) {
    // Message pour confirmer la création d'un nouveau timer après arrêt
    if (!GlobalTimerService().isTimerActive) {
      print('Création d\'un nouveau timer pour le scénario #${_currentScenario?.id}');
    }
    
    // Enregistrer le temps de début
    _timerStartTime = DateTime.now();
    
    GlobalTimerService().startReadyTimer(
      duration: duration,
      onFinish: () {
        _finishTimer();
      },
      associatedItemId: _currentScenario?.id.toString(),
      associatedItemType: 'scenario',
      associatedScreenRoute: '/commercial-scenario',
    );
    
    // Notifier le service du scénario actuellement affiché
    GlobalTimerService().setCurrentPageItem(
      _currentScenario?.id.toString(),
      'scenario',
    );
  }

  void _finishTimer() {
    // Calculer le temps écoulé si on a un temps de début (cas du timer automatique)
    if (_timerStartTime != null && _elapsedTime == null) {
      _elapsedTime = DateTime.now().difference(_timerStartTime!);
    }
    
    setState(() {
      _showCorrection = true;
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
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Scénarios Commerciaux',
        titleIcon: Icons.business_center_outlined,
        version: ToolVersions.commercialScenarios,
        onBackPressed: () async {
          if (_currentScenario != null || _showChifoumi) {
            final canLeave = await _checkEvaluationBeforeLeaving();
            if (canLeave) {
              setState(() {
                _currentScenario = null;
                _showChifoumi = false;
                _showCorrection = false;
                _chifousiGame = null;
                _hasEvaluated = false;
              });
              // Notifier qu'on n'a plus de scénario affiché
              GlobalTimerService().setCurrentPageItem(null, null);
              // Pas de timer à relancer, on revient à l'accueil
            }
          } else {
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
                      if (_currentScenario == null && !_showChifoumi)
                        _buildModeSelection(),

                      if (_showChifoumi)
                        _buildChifousiInterface(),

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
                onPressed: () async => await _startRandomScenario(),
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
                onPressed: () async => await _showChifousiInterface(),
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
                    onSubmitted: (value) async => await _selectScenarioById(value, isFromTimerNavigation: false),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    await _selectScenarioById(_scenarioNumberController.text, isFromTimerNavigation: false);
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
      onPressed: () async => await _selectScenarioByDifficulty(difficulty),
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
            
            const SizedBox(height: 16),
            
            // Boutons Correction/Abandon
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildDiagonalSolutionButton(),
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
// PARTIE 4BIS/4 : Méthodes boutons Correction/Abandon, _buildCorrectionSheet et _buildWelcomeMessage

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
                  // Arrêter le timer et calculer le temps écoulé
                  if (_timerStartTime != null) {
                    _elapsedTime = DateTime.now().difference(_timerStartTime!);
                  }
                  
                  // Arrêter le timer flottant
                  GlobalTimerService().stopFloatingTimer();
                  
                  setState(() {
                    // Ouvrir directement la correction du scénario
                    _showCorrection = true;
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
                          // Padding pour maintenir la hauteur minimale
                          const SizedBox(
                            height: 36,
                            width: double.infinity,
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
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Abandonner le scénario ?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir abandonner ce scénario ?\n\n'
            'Cette action sera comptabilisée dans vos statistiques.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _abandonScenario();
              },
              icon: const Icon(Icons.flag, size: 18),
              label: const Text('Confirmer l\'abandon'),
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

  void _abandonScenario() {
    setState(() {
      // Incrémenter les statistiques d'abandon
      if (_currentScenario != null) {
        _attemptsByDifficulty[_currentScenario!.difficulty] = 
          (_attemptsByDifficulty[_currentScenario!.difficulty] ?? 0) + 1;
        // Note: On n'incrémente pas les succès pour un abandon
      }
      
      // Revenir à l'écran de sélection
      _currentScenario = null;
      _showCorrection = false;
      _showChifoumi = false;
      _hasEvaluated = false;
    });
    
    _saveStatistics();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Scénario abandonné'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCorrectionSheet() {
    if (_currentScenario == null) return const SizedBox();
    
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
                      'Fiche de Correction #${_currentScenario!.id}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                  // Affichage du temps écoulé (toujours visible si disponible)
                  if (_elapsedTime != null) ...[
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
                            '${_elapsedTime!.inMinutes}:${(_elapsedTime!.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
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
          // Pas de timer à relancer, on revient à l'accueil
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
          // Pas de timer pour le mode défi
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
    ),
  );
}

  Widget _buildCorrectionSection(String title, List<String> items, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
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
          ...items.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ],
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
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
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
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
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