import '../models/malfunction.dart';
import '../models/flowchart_models.dart';
import 'flowchart_data.dart';

class FlowchartService {
  // Récupérer tous les organigrammes disponibles
  static List<FlowchartInfo> getAllFlowcharts() {
    return FlowchartData.allFlowcharts;
  }

  // Obtenir tous les organigrammes d'une catégorie
  static List<FlowchartInfo> getFlowchartsByCategory(MalfunctionCategory category) {
    final flowchartCategory = FlowchartInfo.fromMalfunctionCategory(category);
    return FlowchartData.allFlowcharts
        .where((f) => f.category == flowchartCategory)
        .toList();
  }

  // Détection automatique de l'organigramme le plus pertinent pour une panne
  static FlowchartInfo? detectBestFlowchart(Malfunction malfunction) {
    final availableFlowcharts = getFlowchartsByCategory(malfunction.category);
    
    if (availableFlowcharts.isEmpty) return null;
    
    // Analyser le texte de la panne
    String desc = malfunction.description.toLowerCase();
    List<String> symptoms = malfunction.symptoms.map((s) => s.toLowerCase()).toList();
    String allText = '$desc ${symptoms.join(' ')}';
    
    // Trouver le meilleur match par score de mots-clés
    FlowchartInfo? bestMatch;
    int bestScore = 0;
    
    for (var flowchart in availableFlowcharts) {
      int score = 0;
      for (var keyword in flowchart.keywords) {
        if (allText.contains(keyword.toLowerCase())) {
          score++;
        }
      }
      
      if (score > bestScore) {
        bestScore = score;
        bestMatch = flowchart;
      }
    }
    
    // Retourner le meilleur match ou le premier si aucun mot-clé ne matche
    return bestMatch ?? availableFlowcharts.first;
  }

  // Vérifier si une catégorie a des organigrammes disponibles
  static bool hasCategoryFlowcharts(MalfunctionCategory category) {
    return getFlowchartsByCategory(category).isNotEmpty;
  }

  // Obtenir un organigramme par son ID
  static FlowchartInfo? getFlowchartById(String id) {
    try {
      return FlowchartData.allFlowcharts.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtenir les statistiques sur les organigrammes
  static Map<String, dynamic> getStats() {
    final total = FlowchartData.allFlowcharts.length;
    final byCategory = <String, int>{};
    
    for (var category in FlowchartCategory.values) {
      final count = FlowchartData.allFlowcharts
          .where((f) => f.category == category)
          .length;
      byCategory[category.toString().split('.').last] = count;
    }
    
    return {
      'total': total,
      'byCategory': byCategory,
    };
  }
}