// Fichier: lib/services/commercial_scenario_service.dart

import 'dart:math';
import '../models/commercial_scenario.dart';
import '../data/commercial_scenarios_data.dart';

class CommercialScenarioService {
  static final Random _random = Random();

  /// Tirage classique aléatoire (tous niveaux confondus)
  static CommercialScenario drawRandomScenario() {
    final allScenarios = CommercialScenariosDatabase.getAllScenarios();
    final randomIndex = _random.nextInt(allScenarios.length);
    return allScenarios[randomIndex];
  }

  /// Jeu de chifoumi contre l'IA
  static ChifousiGame playChifoumi(ChifousiChoice playerChoice) {
    final aiChoice = _generateAIChoice();
    final result = _determineResult(playerChoice, aiChoice);
    
    return ChifousiGame(
      playerChoice: playerChoice,
      aiChoice: aiChoice,
      result: result,
    );
  }

  /// Tirage de scénario basé sur le résultat du chifoumi
  static CommercialScenario drawChallengeScenario(ChifousiResult chifousiResult) {
    final difficulty = _difficultyFromChifousiResult(chifousiResult);
    final scenariosOfDifficulty = CommercialScenariosDatabase.getScenariosByDifficulty(difficulty);
    
    if (scenariosOfDifficulty.isEmpty) {
      // Fallback sur tirage aléatoire si pas de scénarios de cette difficulté
      return drawRandomScenario();
    }
    
    final randomIndex = _random.nextInt(scenariosOfDifficulty.length);
    return scenariosOfDifficulty[randomIndex];
  }

  /// Génère le choix de l'IA pour le chifoumi
  static ChifousiChoice _generateAIChoice() {
    final choices = ChifousiChoice.values;
    final randomIndex = _random.nextInt(choices.length);
    return choices[randomIndex];
  }

  /// Détermine le résultat du chifoumi
  static ChifousiResult _determineResult(ChifousiChoice player, ChifousiChoice ai) {
    if (player == ai) {
      return ChifousiResult.draw;
    }

    switch (player) {
      case ChifousiChoice.rock:
        return ai == ChifousiChoice.scissors ? ChifousiResult.win : ChifousiResult.lose;
      case ChifousiChoice.paper:
        return ai == ChifousiChoice.rock ? ChifousiResult.win : ChifousiResult.lose;
      case ChifousiChoice.scissors:
        return ai == ChifousiChoice.paper ? ChifousiResult.win : ChifousiResult.lose;
    }
  }

  /// Convertit le résultat chifoumi en difficulté
  static DifficultyLevel _difficultyFromChifousiResult(ChifousiResult result) {
    switch (result) {
      case ChifousiResult.win:
        return DifficultyLevel.easy;
      case ChifousiResult.draw:
        return DifficultyLevel.medium;
      case ChifousiResult.lose:
        return DifficultyLevel.hard;
    }
  }

  /// Obtient le nom du choix chifoumi
  static String getChifousiChoiceName(ChifousiChoice choice) {
    switch (choice) {
      case ChifousiChoice.rock:
        return 'Pierre';
      case ChifousiChoice.paper:
        return 'Feuille';
      case ChifousiChoice.scissors:
        return 'Ciseaux';
    }
  }

  /// Obtient l'icône du choix chifoumi
  static String getChifousiChoiceIcon(ChifousiChoice choice) {
    switch (choice) {
      case ChifousiChoice.rock:
        return '🪨';
      case ChifousiChoice.paper:
        return '📄';
      case ChifousiChoice.scissors:
        return '✂️';
    }
  }

  /// Obtient l'explication du résultat chifoumi
  static String getChifousiResultExplanation(ChifousiGame game) {
    final playerName = getChifousiChoiceName(game.playerChoice);
    final aiName = getChifousiChoiceName(game.aiChoice);
    final playerIcon = getChifousiChoiceIcon(game.playerChoice);
    final aiIcon = getChifousiChoiceIcon(game.aiChoice);

    switch (game.result) {
      case ChifousiResult.win:
        return '$playerIcon $playerName bat $aiIcon $aiName\n→ Scénario FACILE';
      case ChifousiResult.draw:
        return '$playerIcon $playerName égale $aiIcon $aiName\n→ Scénario MOYEN';
      case ChifousiResult.lose:
        return '$playerIcon $playerName perd contre $aiIcon $aiName\n→ Scénario DIFFICILE';
    }
  }

  /// Statistiques des scénarios
  static Map<String, int> getScenarioStats() {
    return {
      'total': CommercialScenariosDatabase.totalCount,
      'facile': CommercialScenariosDatabase.getCountByDifficulty(DifficultyLevel.easy),
      'moyen': CommercialScenariosDatabase.getCountByDifficulty(DifficultyLevel.medium),
      'difficile': CommercialScenariosDatabase.getCountByDifficulty(DifficultyLevel.hard),
    };
  }
}