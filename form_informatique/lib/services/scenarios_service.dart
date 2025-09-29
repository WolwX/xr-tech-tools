import 'dart:math';
// Assurez-vous que le fichier est bien nommé 'scenarios_data.dart'
import '../data/scenarios_data.dart'; 
// Assurez-vous que le fichier est bien nommé 'scenarios.dart'
import '../models/scenarios.dart'; 

/// Service responsable de la logique de tirage au sort des scénarios.
class ScenarioService {
  // Instance de Random pour générer des nombres aléatoires
  static final Random _random = Random(); 

  /// Tire un scénario aléatoire parmi la liste disponible.
  // NOTE : La méthode est statique pour un appel direct depuis l'écran.
  static Scenario drawScenario() {
    // Le ScenariosData.scenariosList est la liste complète des scénarios
    final list = ScenariosData.scenariosList; 
    
    // Si la liste est vide, on retourne un scénario d'erreur
    if (list.isEmpty) {
      return Scenario(
        titre: "Erreur : Liste de scénarios vide",
        contexte: "Veuillez vérifier le fichier scenarios_data.dart.",
        objectif: "Impossible de générer un objectif.",
        contraintes: "Aucune contrainte disponible.",
        budget: "N/A",
      );
    }
    
    // Génère un index aléatoire
    final index = _random.nextInt(list.length);
    
    // Retourne le scénario correspondant à l'index aléatoire
    return list[index];
  }
}
