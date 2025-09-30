import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';
import 'malfunction_creator_screen.dart';

class MalfunctionHomeScreen extends StatefulWidget {
  const MalfunctionHomeScreen({Key? key}) : super(key: key);

  @override
  State<MalfunctionHomeScreen> createState() => _MalfunctionHomeScreenState();
}

class _MalfunctionHomeScreenState extends State<MalfunctionHomeScreen> {
  // Statistiques Mode Dépanneur
  int _technicianEasySuccess = 0;
  int _technicianEasyTotal = 0;
  int _technicianMediumSuccess = 0;
  int _technicianMediumTotal = 0;
  int _technicianHardSuccess = 0;
  int _technicianHardTotal = 0;

  // Statistiques Mode Créateur
  int _creatorPannesCreated = 0;
  int _creatorPannesSolved = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
// Dans la méthode où vous validez une panne résolue (à créer plus tard)
setState(() {
  _technicianEasySuccess++;
  _technicianEasyTotal++;
});
_saveStatistics();  // ✅ AJOUTER
  }

  Future<void> _saveStatistics() async {
    // TODO: Implémenter la sauvegarde avec SharedPreferences
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
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Retour',
      ),
    ],
  ),
  leadingWidth: 100,
  title: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.bug_report, size: 24),
      SizedBox(width: 12),
      Text(
        'Pannes Informatiques',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                // SECTION 1 : Introduction
                _buildIntroSection(),
                
                const SizedBox(height: 40),

                // SECTION 2 : Choix du Mode
                _buildModeSelectionSection(),
                
                const SizedBox(height: 40),

                // SECTION 3 : Statistiques
                _buildStatisticsSection(),
                
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

  // SECTION 1 : Introduction
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

  // SECTION 2 : Choix du Mode
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
                  // TODO: Navigation vers mode dépanneur
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mode Dépanneur - En développement'),
                      backgroundColor: Color(0xFF00B0FF),
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
                    // Navigation vers mode créateur
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          hoverColor: color.withOpacity(0.05),
          child: Container(
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
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
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
      ),
    );
  }

  // SECTION 3 : Statistiques
  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 20),
        
        // Stats Mode Dépanneur
        _buildStatCard(
          title: '🔧 Mode Dépanneur',
          color: const Color(0xFF00B0FF),
          children: [
            _buildStatRow('Facile', _technicianEasySuccess, _technicianEasyTotal, Colors.green),
            const SizedBox(height: 8),
            _buildStatRow('Moyen', _technicianMediumSuccess, _technicianMediumTotal, Colors.orange),
            const SizedBox(height: 8),
            _buildStatRow('Difficile', _technicianHardSuccess, _technicianHardTotal, Colors.red),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Stats Mode Créateur
        _buildStatCard(
          title: '💡 Mode Créateur',
          color: const Color(0xFFFF6B35),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pannes créées',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  '$_creatorPannesCreated',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pannes résolues par d\'autres',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  '$_creatorPannesSolved',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int success, int total, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        Text(
          '$success / $total',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}