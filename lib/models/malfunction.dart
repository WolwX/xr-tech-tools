// Fichier: lib/models/malfunction.dart

enum MalfunctionCategory {
  hardware,
  software,
  network,
  peripheral,
  startup,
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
  final List<String> symptoms;
  final List<String> creationSteps;
  final List<String> creationTips;
  final List<String> diagnosisSteps;
  final List<String> solutionSteps;
  final List<String> skillsWorked;
  final String estimatedTime;
  
  const Malfunction({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.symptoms,
    required this.creationSteps,
    required this.creationTips,
    required this.diagnosisSteps,
    required this.solutionSteps,
    required this.skillsWorked,
    required this.estimatedTime,
  });
  
  String get categoryLabel {
    switch (category) {
      case MalfunctionCategory.hardware:
        return 'Matériel';
      case MalfunctionCategory.software:
        return 'Logiciel';
      case MalfunctionCategory.network:
        return 'Réseau';
      case MalfunctionCategory.peripheral:
        return 'Périphérique';
      case MalfunctionCategory.startup:
        return 'Démarrage';
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