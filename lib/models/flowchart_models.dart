import 'package:flutter/material.dart';
import '../models/malfunction.dart';

// Catégories d'organigrammes (correspond aux catégories de pannes)
enum FlowchartCategory {
  hardware,
  software,
  biosUefi,
  network,
  printer,
  peripheral,
}

// Type de résultat à la fin d'un parcours
enum ResultType { 
  success,  // Problème résolu
  failure,  // Composant HS, nécessite remplacement
  info      // Information / prochaine étape suggérée
}

// Information générale sur un organigramme
class FlowchartInfo {
  final String id;
  final FlowchartCategory category;
  final String title;
  final Color color;
  final List<String> keywords; // Pour la détection automatique
  final Map<String, FlowchartStep> steps; // Les étapes de l'organigramme
  final String? imagePath; // Chemin vers l'image du logigramme
  
  const FlowchartInfo({
    required this.id,
    required this.category,
    required this.title,
    required this.color,
    required this.keywords,
    required this.steps,
    this.imagePath,
  });
  
  // Convertir MalfunctionCategory vers FlowchartCategory
  static FlowchartCategory fromMalfunctionCategory(MalfunctionCategory category) {
    switch (category) {
      case MalfunctionCategory.hardware:
        return FlowchartCategory.hardware;
      case MalfunctionCategory.software:
        return FlowchartCategory.software;
      case MalfunctionCategory.setup:
        return FlowchartCategory.biosUefi;
      case MalfunctionCategory.network:
        return FlowchartCategory.network;
      case MalfunctionCategory.printer:
        return FlowchartCategory.printer;
      case MalfunctionCategory.peripheral:
        return FlowchartCategory.peripheral;
    }
  }
}

// Une étape dans l'organigramme
class FlowchartStep {
  final String id;
  final String question;
  final String? description;
  final IconData? icon;
  final List<FlowchartOption> options;
  
  const FlowchartStep({
    required this.id,
    required this.question,
    this.description,
    this.icon,
    required this.options,
  });
}

// Une option de réponse à une étape
class FlowchartOption {
  final String label;
  final String? subtitle; // Texte explicatif sous le label principal
  final String? nextStepId; // null = fin du parcours
  final String? resultMessage; // Message si c'est une conclusion
  final ResultType? resultType; // Type de résultat
  
  const FlowchartOption({
    required this.label,
    this.subtitle,
    this.nextStepId,
    this.resultMessage,
    this.resultType,
  });
  
  bool get isConclusion => nextStepId == null;
}