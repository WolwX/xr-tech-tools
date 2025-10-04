import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_footer.dart';
import '../widgets/custom_app_bar.dart';
import '../data/tool_data.dart';
import '../services/malfunction_service.dart';
import '../services/global_timer_service.dart';
import 'malfunction_creator_screen.dart';
import 'malfunction_technician_screen.dart';

class MalfunctionHomeScreen extends StatefulWidget {
  const MalfunctionHomeScreen({super.key});

  @override
  State<MalfunctionHomeScreen> createState() => _MalfunctionHomeScreenState();
}

class _MalfunctionHomeScreenState extends State<MalfunctionHomeScreen> {
  // Statistiques Mode Dépanneur (conservées pour usage futur)
  int _technicianEasySuccess = 0;
  int _technicianEasyTotal = 0;
  int _technicianMediumSuccess = 0;
  int _technicianMediumTotal = 0;
  int _technicianHardSuccess = 0;
  int _technicianHardTotal = 0;

  

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
    // Indiquer qu'on n'affiche aucun item spécifique (page d'accueil informatique)
    GlobalTimerService().setCurrentPageItem(null, null);
  }

  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Mode Dépanneur uniquement
      _technicianEasySuccess = prefs.getInt('malfunction_tech_easy_success') ?? 0;
      _technicianEasyTotal = prefs.getInt('malfunction_tech_easy_total') ?? 0;
      _technicianMediumSuccess = prefs.getInt('malfunction_tech_medium_success') ?? 0;
      _technicianMediumTotal = prefs.getInt('malfunction_tech_medium_total') ?? 0;
      _technicianHardSuccess = prefs.getInt('malfunction_tech_hard_success') ?? 0;
      _technicianHardTotal = prefs.getInt('malfunction_tech_hard_total') ?? 0;
    });
  }

  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    // Mode Dépanneur uniquement
    await prefs.setInt('malfunction_tech_easy_success', _technicianEasySuccess);
    await prefs.setInt('malfunction_tech_easy_total', _technicianEasyTotal);
    await prefs.setInt('malfunction_tech_medium_success', _technicianMediumSuccess);
    await prefs.setInt('malfunction_tech_medium_total', _technicianMediumTotal);
    await prefs.setInt('malfunction_tech_hard_success', _technicianHardSuccess);
    await prefs.setInt('malfunction_tech_hard_total', _technicianHardTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Pannes Informatiques',
        titleIcon: Icons.bug_report,
        version: ToolVersions.malfunctionTools,
        onBackPressed: () => Navigator.of(context).pop(),
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
                      _buildIntroSection(),
                      const SizedBox(height: 24),
                      _buildModeSelectionSection(),
                      const SizedBox(height: 40),
                      _buildPannesStatsSection(),
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

  Widget _buildIntroSection() {
    return Container(
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
                  Icons.build_circle,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Diagnostic & Dépannage',
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
            'Entraînez-vous au diagnostic et à la résolution de pannes informatiques. '
            'Développez vos compétences en dépannage ou créez des scénarios pour tester vos collègues !',
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
              _buildInfoChip('ADRN', Colors.green.shade700),
              const SizedBox(width: 8),
              _buildInfoChip('TIP', Colors.orange.shade700),
            ],
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

  Widget _buildModeSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choisissez votre mode',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                icon: Icons.handyman_outlined,
                title: 'Mode Dépanneur',
                description: 'Diagnostiquez et résolvez des pannes',
                color: const Color(0xFF00B0FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MalfunctionTechnicianScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModeCard(
                icon: Icons.psychology_outlined,
                title: 'Mode Créateur',
                description: 'Créez des scénarios de pannes',
                color: const Color(0xFFFF6B35),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MalfunctionCreatorScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200, // Augmentation de la hauteur pour éviter l'overflow
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14), // Réduction du padding
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36, // Réduction de la taille de l'icône
                  color: color,
                ),
              ),
              const SizedBox(height: 12), // Réduction de l'espacement
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6), // Réduction de l'espacement
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPannesStatsSection() {
    final stats = MalfunctionService.getCompleteStats();
    final totalPannes = stats['total'] as int;
    final byDifficulty = stats['byDifficulty'] as Map<String, dynamic>;
    final byCategory = stats['byCategory'] as Map<String, dynamic>;

    return Container(
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
          Center(
            child: Text(
              '$totalPannes pannes disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDifficultyColumn(
                byDifficulty['easy'] as int,
                'Faciles',
                Colors.green,
                1,
              ),
              _buildDifficultyColumn(
                byDifficulty['medium'] as int,
                'Moyens',
                Colors.orange,
                2,
              ),
              _buildDifficultyColumn(
                byDifficulty['hard'] as int,
                'Difficiles',
                Colors.red,
                3,
              ),
            ],
          ),
          const Divider(height: 40, thickness: 1),
          Center(
            child: Text(
              'Statistiques par catégorie',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('Matériel', byCategory['hardware'] as int, Icons.memory),
              _buildCategoryChip('Logiciel', byCategory['software'] as int, Icons.apps),
              _buildCategoryChip('BIOS/UEFI', byCategory['setup'] as int, Icons.settings_applications),
              _buildCategoryChip('Réseau', byCategory['network'] as int, Icons.wifi),
              _buildCategoryChip('Impression', byCategory['printer'] as int, Icons.print),
              _buildCategoryChip('Périphérique', byCategory['peripheral'] as int, Icons.devices),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyColumn(int count, String label, Color color, int stars) {
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

  Widget _buildCategoryChip(String label, int count, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}