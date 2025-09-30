import 'package:flutter/material.dart';

// Dépendances nécessaires au tirage au sort 
// Assurez-vous que le fichier est bien nommé 'scenarios.dart'
import '../models/scenarios.dart'; 
// Assurez-vous que le fichier est bien nommé 'scenarios_service.dart'
import '../services/scenarios_service.dart'; 
// Import du pied de page
import '../widgets/app_footer.dart'; 

class ScenarioPickerScreen extends StatefulWidget {
  const ScenarioPickerScreen({super.key});

  @override
  State<ScenarioPickerScreen> createState() => _ScenarioPickerScreenState();
}

class _ScenarioPickerScreenState extends State<ScenarioPickerScreen> {
  Scenario? _currentScenario;

  void _drawNewScenario() {
    setState(() {
      try {
        _currentScenario = ScenarioService.drawScenario();
      } catch (e) {
        // Scénario de test temporaire
        _currentScenario = Scenario(
          titre: "Test de Scénario", 
          contexte: "Contexte de test",
          budget: "Budget de test", 
          objectif: "Objectif de test",
          contraintes: "Contraintes de test"
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isScenarioDrawn = _currentScenario != null;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirage au Sort de Scénario'),
      ),
      
      // Structure Column au lieu de Stack pour éviter les conflits
      body: Column(
        children: [
          // Contenu principal extensible
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // --- Bouton de Tirage ---
                      ElevatedButton.icon(
                        icon: const Icon(Icons.casino, size: 28),
                        label: Text(
                          isScenarioDrawn
                              ? "Tirer un Nouveau Scénario"
                              : "Démarrer le Tirage",
                          style: const TextStyle(fontSize: 18),
                        ),
                        onPressed: _drawNewScenario,
                        style: ElevatedButton.styleFrom(
                           padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: isMobile ? 10 : 30),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // --- Affichage du Scénario ---
                      if (isScenarioDrawn)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scénario Tiré :',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const Divider(height: 20, thickness: 2),
                            // Carte du Scénario
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildInfoRow(
                                        Icons.category,
                                        "Titre :",
                                        _currentScenario!.titre, 
                                        Colors.orange),
                                    _buildInfoRow(Icons.person, "Contexte :",
                                        _currentScenario!.contexte, primaryColor),
                                    _buildInfoRow(Icons.access_time, "Budget :",
                                        _currentScenario!.budget, Colors.purple),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Objectif de la Demande :",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _currentScenario!.objectif, 
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    Text(
                                      "Contraintes :",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _currentScenario!.contraintes,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        // Message d'attente
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 80),
                          child: Column(
                            children: [
                              Icon(Icons.assignment,
                                  size: 80, color: Colors.grey.shade400),
                              const SizedBox(height: 20),
                              Text(
                                'Cliquez sur "Démarrer le Tirage" pour générer un scénario.',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Footer fixe en bas
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const AppFooter(),
          ),
        ],
      ),
    );
  }

  // Widget utilitaire pour afficher une ligne d'information
  Widget _buildInfoRow(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}