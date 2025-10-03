// Fichier: lib/models/malfunction.dart
import 'package:flutter/material.dart';

enum MalfunctionCategory {
  hardware,      // Pannes matériel (RAM, disque, connecteurs)
  software,      // Pannes logicielles (extensions, lecteurs multimédia)
  setup,         // Pannes BIOS/UEFI (boot order, ports désactivés)
  network,       // Pannes réseau/internet (DHCP, WiFi, carte réseau)
  printer,       // Pannes d'impression
  peripheral,    // Autres périphériques (clavier, souris, écran)
}

enum MalfunctionDifficulty {
  easy,
  medium,
  hard,
}

class Malfunction {
  final int id;
  final String name;
  final String description;
  final MalfunctionCategory category;
  final MalfunctionDifficulty difficulty;
  final List<String> symptoms;           // Ce que l'utilisateur VOIT
  final String clientAttitude; 
  final List<String> creationSteps;      // Comment CRÉER la panne
  final List<String> creationTips;       // Conseils pour bien simuler
  final List<String> diagnosisSteps;     // Comment DIAGNOSTIQUER
  final List<String> solutionSteps;      // Comment RÉSOUDRE
  final List<String> skillsWorked;       // Compétences RNCP
  final String estimatedTime;
  
  const Malfunction({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.symptoms,
    required this.clientAttitude,
    required this.creationSteps,
    required this.creationTips,
    required this.diagnosisSteps,
    required this.solutionSteps,
    required this.skillsWorked,
    required this.estimatedTime,
  });
  
  IconData get categoryIcon {
    switch (category) {
      case MalfunctionCategory.hardware:
        return Icons.memory;
      case MalfunctionCategory.software:
        return Icons.laptop_windows;
      case MalfunctionCategory.setup:
        return Icons.settings;
      case MalfunctionCategory.network:
        return Icons.wifi;
      case MalfunctionCategory.printer:
        return Icons.print;
      case MalfunctionCategory.peripheral:
        return Icons.keyboard;
    }
  }

  String get categoryLabel {
    switch (category) {
      case MalfunctionCategory.hardware:
        return 'Matériel';
      case MalfunctionCategory.software:
        return 'Logiciel';
      case MalfunctionCategory.setup:
        return 'BIOS/UEFI';
      case MalfunctionCategory.network:
        return 'Réseau/Internet';
      case MalfunctionCategory.printer:
        return 'Impression';
      case MalfunctionCategory.peripheral:
        return 'Périphérique';
    }
  }
  
  String get difficultyLabel {
    switch (difficulty) {
      case MalfunctionDifficulty.easy:
        return 'Facile';
      case MalfunctionDifficulty.medium:
        return 'Moyen';
      case MalfunctionDifficulty.hard:
        return 'Difficile';
    }
  }
}