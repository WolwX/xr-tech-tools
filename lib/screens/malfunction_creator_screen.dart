import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/malfunction.dart';
import '../services/malfunction_service.dart';
import '../widgets/app_footer.dart';
import '../main.dart'; 

class MalfunctionCreatorScreen extends StatefulWidget {
  const MalfunctionCreatorScreen({super.key});

  @override
  State<MalfunctionCreatorScreen> createState() => _MalfunctionCreatorScreenState();
}

class _MalfunctionCreatorScreenState extends State<MalfunctionCreatorScreen> {
  Malfunction? _currentMalfunction;
  final TextEditingController _numberController = TextEditingController();

  // Statistiques Mode Créateur (format "pannes tirées")
  int _totalMalfunctionsDrawn = 0;
  int _easyDrawn = 0;
  int _mediumDrawn = 0;
  int _hardDrawn = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalMalfunctionsDrawn = prefs.getInt('creator_total_drawn') ?? 0;
      _easyDrawn = prefs.getInt('creator_easy_drawn') ?? 0;
      _mediumDrawn = prefs.getInt('creator_medium_drawn') ?? 0;
      _hardDrawn = prefs.getInt('creator_hard_drawn') ?? 0;
    });
  }

  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('creator_total_drawn', _totalMalfunctionsDrawn);
    await prefs.setInt('creator_easy_drawn', _easyDrawn);
    await prefs.setInt('creator_medium_drawn', _mediumDrawn);
    await prefs.setInt('creator_hard_drawn', _hardDrawn);
  }

  void _incrementStats(MalfunctionDifficulty difficulty) {
    setState(() {
      _totalMalfunctionsDrawn++;
      switch (difficulty) {
        case MalfunctionDifficulty.easy:
          _easyDrawn++;
          break;
        case MalfunctionDifficulty.medium:
          _mediumDrawn++;
          break;
        case MalfunctionDifficulty.hard:
          _hardDrawn++;
          break;
      }
    });
    _saveStatistics();
  }

  void _drawRandomMalfunction() {
    setState(() {
      _currentMalfunction = MalfunctionService.drawRandomMalfunction();
    });
    _incrementStats(_currentMalfunction!.difficulty);
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
    });
    _incrementStats(malfunction.difficulty);
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
    });
    _incrementStats(random.difficulty);
  }

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
                if (_currentMalfunction != null) {
                  setState(() {
                    _currentMalfunction = null;
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
            Icon(Icons.psychology_outlined, size: 24),
            SizedBox(width: 12),
            Text(
              'Mode Créateur de Pannes',
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
        backgroundColor: primaryOrange,
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
                      if (_currentMalfunction == null)
                        _buildWelcomeSection(),
                      
                      if (_currentMalfunction != null)
                        _buildMalfunctionDisplay(),
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

  Widget _buildWelcomeSection() {
    // Calcul du total de pannes disponibles
    final stats = MalfunctionService.getCompleteStats();
    final totalPannes = stats['total'] as int;
    final byDifficulty = stats['byDifficulty'] as Map<String, dynamic>;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B35).withOpacity(0.1),
                const Color(0xFFFF6B35).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFF6B35).withOpacity(0.3),
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
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.engineering,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Créer une Panne de Formation',
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
                'Tirez une panne au sort et suivez les instructions pour la simuler. '
                'Idéal pour tester les compétences de diagnostic d\'un collègue ou pour vous entraîner !',
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
                color: Color(0xFFFF6B35),
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
                'Vous recevrez les instructions détaillées pour créer la panne',
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
                  backgroundColor: const Color(0xFFFF6B35),
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
        
        // STATISTIQUES (FORMAT IDENTIQUE AUX SCÉNARIOS COMMERCIAUX)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFF6B35).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart, color: Color(0xFFFF6B35), size: 24),
                  const SizedBox(width: 12),
                  Text(
                    '$totalPannes pannes disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Statistiques globales (affichage comme scénarios commerciaux)
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
                child: Divider(thickness: 2, color: Colors.orange.shade200),
              ),
              
              // Statistiques personnelles (tirages)
              Center(
                child: Text(
                  'Vos tirages',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUserStatColumn(
                    _easyDrawn,
                    totalPannes > 0 ? byDifficulty['easy'] as int : 0,
                    'Faciles',
                    Colors.green,
                    1,
                  ),
                  _buildUserStatColumn(
                    _mediumDrawn,
                    totalPannes > 0 ? byDifficulty['medium'] as int : 0,
                    'Moyens',
                    Colors.orange,
                    2,
                  ),
                  _buildUserStatColumn(
                    _hardDrawn,
                    totalPannes > 0 ? byDifficulty['hard'] as int : 0,
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

  // Widget pour les stats globales (total de pannes disponibles)
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

  // Widget pour les stats utilisateur (format "X / Y" comme scénarios commerciaux)
  Widget _buildUserStatColumn(int drawn, int total, String label, Color color, int stars) {
    return Column(
      children: [
        Text(
          '$drawn / $total',
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

  Widget _buildMalfunctionDisplay() {
    if (_currentMalfunction == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card principale avec bordure colorée
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
                  // En-tête avec titre et badge difficulté
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Panne à Créer',
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
                  const Divider(height: 30, thickness: 2),
                  
                  // Nom de la panne
                  Stack(
                    children: [
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Icon(
                          Icons.bug_report,
                          size: 60,
                          color: Colors.red.shade100.withOpacity(0.3),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.error_outline, size: 24, color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'PANNE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '#${_currentMalfunction!.id} - ${_currentMalfunction!.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentMalfunction!.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Catégorie et temps
                  Stack(
                    children: [
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Icon(
                          Icons.info_outline,
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
                                Icon(Icons.category, size: 24, color: Colors.blue.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'INFORMATIONS',
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
                              'Catégorie : ${_currentMalfunction!.categoryLabel}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Temps estimé : ${_currentMalfunction!.estimatedTime}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Compétences : ',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: () {
                                      // Déterminer les badges à afficher selon la logique
                                      List<Map<String, dynamic>> badges = [];
                                      
                                      bool hasIDI = _currentMalfunction!.skillsWorked.any(
                                        (s) => s.toUpperCase().contains('IDI')
                                      );
                                      bool hasTIP = _currentMalfunction!.skillsWorked.any(
                                        (s) => s.toUpperCase().contains('TIP')
                                      );
                                      
                                      // Si IDI, on ajoute IDI et ADRN
                                      if (hasIDI) {
                                        badges.add({
                                          'label': 'IDI',
                                          'color': Colors.blue.shade700,
                                        });
                                        badges.add({
                                          'label': 'ADRN',
                                          'color': Colors.green.shade700,
                                        });
                                      }
                                      
                                      // Si TIP, on l'ajoute
                                      if (hasTIP) {
                                        badges.add({
                                          'label': 'TIP',
                                          'color': Colors.orange.shade700,
                                        });
                                      }
                                      
                                      return badges.map((badge) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: (badge['color'] as Color).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: (badge['color'] as Color).withOpacity(0.3)
                                            ),
                                          ),
                                          child: Text(
                                            badge['label'] as String,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: badge['color'] as Color,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    }(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Procédure de création
                  _buildInstructionSection(
                    'Procédure de création',
                    Icons.build,
                    _currentMalfunction!.creationSteps,
                    primaryOrange,
                  ),

                  const SizedBox(height: 16),

                  // Conseils
                  _buildInstructionSection(
                    'Conseils de simulation',
                    Icons.lightbulb,
                    _currentMalfunction!.creationTips,
                    Colors.amber,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Bouton nouvelle panne
        Center(
          child: ElevatedButton.icon(
            onPressed: _drawRandomMalfunction,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              'Nouvelle Panne',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  // Widget pour les sections d'instructions
  Widget _buildInstructionSection(String title, IconData icon, List<String> items, MaterialColor color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color.shade700, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.4), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}