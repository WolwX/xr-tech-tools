import 'dart:math';
import '../models/malfunction.dart';
import '../data/malfunctions_data.dart';

class MalfunctionService {
  static final Random _random = Random();

  static Malfunction drawRandomMalfunction() {
    return allMalfunctions[_random.nextInt(allMalfunctions.length)];
  }

  static List<Malfunction> getMalfunctionsByDifficulty(MalfunctionDifficulty difficulty) {
    return allMalfunctions.where((m) => m.difficulty == difficulty).toList();
  }

  static List<Malfunction> getMalfunctionsByCategory(MalfunctionCategory category) {
    return allMalfunctions.where((m) => m.category == category).toList();
  }
}