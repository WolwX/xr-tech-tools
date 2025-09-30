import 'package:flutter/material.dart';
import '../models/tool.dart'; // Importe la classe Tool
// Utilisation du nom de fichier exact pour l'écran de tirage
import '../screens/commercial_scenario_screen.dart'; 
import '../screens/malfunction_home_screen.dart';

// --- Fonction utilitaire pour créer une page temporaire (Bientôt disponible) ---
Widget _comingSoonPage(String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.code_off, size: 60, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'Outil "$title" en cours de développement.',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
// --------------------------------------------------------

final List<Tool> availableTools = [
  // 1. SCÉNARIOS COMMERCIAUX (Ancien "Scénario Piqueur" renommé)
const Tool(
  name: 'Scénarios Commerciaux',
  description: 'Générateur de scénarios avec chifoumi et timer',
  icon: Icons.business_center,
  destination: CommercialScenarioScreen(),
  version: 'v1.2',  // NOUVEAU
),
  
  // L'ancien Scénarios Commerciaux (index 2) est supprimé.
  
  // 2. Conversion unités de valeur (Ancien index 3)
  Tool(
    name: 'Conversion unités de valeur',
    description: 'Outil de conversion pour les métriques spécifiques à la Réalité Étendue (FOV, PPD, etc.).',
    icon: Icons.swap_horiz,
    destination: _comingSoonPage('Conversion unités de valeur'),
  ),

  // 3. Calculateur espace disque (Ancien index 4)
  Tool(
    name: 'Calculateur espace disque',
    description: 'Estimer l\'espace disque nécessaire pour la capture, l\'enregistrement et le stockage de données XR.',
    icon: Icons.storage_outlined,
    destination: _comingSoonPage('Calculateur espace disque'),
  ),

  // 4. Pannes informatique (Ancien index 5)
  Tool(
    name: 'Pannes Informatiques',
    description: 'Générateur de pannes pour entrainement, ainsi qu\'outils de dépannage rapide.',
    icon: Icons.bug_report_outlined,
    destination: const MalfunctionHomeScreen(),
    version: 'v0.1',
  ),

  // 5. Procédures (Ancien index 6)
  Tool(
    name: 'Procédures',
    description: 'Base de données consultable pour les guides pas-à-pas et les listes de contrôle de déploiement.',
    icon: Icons.checklist_rtl_outlined,
    destination: _comingSoonPage('Procédures'),
  ),

  // 6. Touches de BIOS et BOOT (Ancien index 7)
  Tool(
    name: 'Touches de BIOS et BOOT',
    description: 'Référence rapide pour les raccourcis BIOS et les touches de menu de démarrage (BOOT) des principaux fabricants.',
    icon: Icons.keyboard_command_key_outlined,
    destination: _comingSoonPage('Touches de BIOS et BOOT'),
  ),
  
  // 7. Fiches Hardware (Ancien index 8)
  Tool(
    name: 'Fiches Hardware',
    description: 'Documentation technique concise des spécifications des appareils XR (processeurs, écrans, caméras, etc.).',
    icon: Icons.memory_outlined,
    destination: _comingSoonPage('Fiches Hardware'),
  ),
  
  // 8. QCM (Ancien index 9)
  Tool(
    name: 'QCM',
    description: 'Questionnaires à choix multiples pour tester les connaissances sur la réalité étendue et l\'informatique générale.',
    icon: Icons.quiz_outlined,
    destination: _comingSoonPage('QCM'),
  ),
  
  // 9. Liens utiles (Ancien index 10)
  Tool(
    name: 'Liens utiles',
    description: 'Collection organisée de ressources web et de documentation externe pertinente.',
    icon: Icons.link_outlined,
    destination: _comingSoonPage('Liens utiles'),
  ),
];
