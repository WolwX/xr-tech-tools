import 'dart:math';
import '../models/malfunction.dart';
import '../data/malfunctions_data.dart';

class MalfunctionService {
  static final Random _random = Random();

  /// Tirage aléatoire d'une panne parmi toutes les pannes disponibles
  static Malfunction drawRandomMalfunction() {
    return allMalfunctions[_random.nextInt(allMalfunctions.length)];
  }

  /// Obtenir toutes les pannes d'un niveau de difficulté donné
  static List<Malfunction> getMalfunctionsByDifficulty(MalfunctionDifficulty difficulty) {
    return allMalfunctions.where((m) => m.difficulty == difficulty).toList();
  }

  /// Obtenir toutes les pannes d'une catégorie donnée
  static List<Malfunction> getMalfunctionsByCategory(MalfunctionCategory category) {
    return allMalfunctions.where((m) => m.category == category).toList();
  }

  /// Obtenir une panne spécifique par son ID
  static Malfunction? getMalfunctionById(int id) {
    try {
      return allMalfunctions.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtenir le nombre total de pannes
  static int getTotalCount() {
    return allMalfunctions.length;
  }

  /// Obtenir le nombre de pannes par difficulté
  static int getCountByDifficulty(MalfunctionDifficulty difficulty) {
    return getMalfunctionsByDifficulty(difficulty).length;
  }

  /// Obtenir le nombre de pannes par catégorie
  static int getCountByCategory(MalfunctionCategory category) {
    return getMalfunctionsByCategory(category).length;
  }

  /// Obtenir toutes les catégories disponibles avec leur nombre de pannes
  static Map<MalfunctionCategory, int> getCategoriesStats() {
    return {
      MalfunctionCategory.hardware: getCountByCategory(MalfunctionCategory.hardware),
      MalfunctionCategory.software: getCountByCategory(MalfunctionCategory.software),
      MalfunctionCategory.setup: getCountByCategory(MalfunctionCategory.setup),
      MalfunctionCategory.network: getCountByCategory(MalfunctionCategory.network),
      MalfunctionCategory.printer: getCountByCategory(MalfunctionCategory.printer),
      MalfunctionCategory.peripheral: getCountByCategory(MalfunctionCategory.peripheral),
    };
  }

  /// Obtenir des statistiques complètes
  static Map<String, dynamic> getCompleteStats() {
    return {
      'total': getTotalCount(),
      'byDifficulty': {
        'easy': getCountByDifficulty(MalfunctionDifficulty.easy),
        'medium': getCountByDifficulty(MalfunctionDifficulty.medium),
        'hard': getCountByDifficulty(MalfunctionDifficulty.hard),
      },
      'byCategory': {
        'hardware': getCountByCategory(MalfunctionCategory.hardware),
        'software': getCountByCategory(MalfunctionCategory.software),
        'setup': getCountByCategory(MalfunctionCategory.setup),
        'network': getCountByCategory(MalfunctionCategory.network),
        'printer': getCountByCategory(MalfunctionCategory.printer),
        'peripheral': getCountByCategory(MalfunctionCategory.peripheral),
      },
    };
  }

  /// Tirer une panne aléatoire selon difficulté ET catégorie
  static Malfunction? drawMalfunctionByFilters({
    MalfunctionDifficulty? difficulty,
    MalfunctionCategory? category,
  }) {
    var filtered = allMalfunctions;

    if (difficulty != null) {
      filtered = filtered.where((m) => m.difficulty == difficulty).toList();
    }

    if (category != null) {
      filtered = filtered.where((m) => m.category == category).toList();
    }

    if (filtered.isEmpty) {
      return null;
    }

    return filtered[_random.nextInt(filtered.length)];
  }
}