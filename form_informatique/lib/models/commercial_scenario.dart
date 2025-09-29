// Fichier: lib/models/commercial_scenario.dart

enum DifficultyLevel {
  easy,
  medium,
  hard,
}

enum ChifousiChoice {
  rock,
  paper,
  scissors,
}

enum ChifousiResult {
  win,
  draw,
  lose,
}

class CommercialScenario {
  final int id;
  final String clientProfile;
  final String clientRequest;
  final String budgetInfo;
  final String clientAttitude;
  final DifficultyLevel difficulty;
  final List<String> keyQuestions;
  final List<ScenarioSolution> solutions;
  final List<String> commonTraps;
  final List<String> skillsWorked;

  const CommercialScenario({
    required this.id,
    required this.clientProfile,
    required this.clientRequest,
    required this.budgetInfo,
    this.clientAttitude = '',
    required this.difficulty,
    required this.keyQuestions,
    required this.solutions,
    required this.commonTraps,
    required this.skillsWorked,
  });

  String get fullDescription => '$clientProfile qui $clientRequest - $budgetInfo';
  
  String get difficultyLabel {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Facile';
      case DifficultyLevel.medium:
        return 'Moyen';
      case DifficultyLevel.hard:
        return 'Difficile';
    }
  }
}

class ScenarioSolution {
  final String productName;
  final String price;
  final List<String> advantages;
  final List<String> disadvantages;
  final String? productUrl; // Lien vers le produit

  const ScenarioSolution({
    required this.productName,
    required this.price,
    required this.advantages,
    required this.disadvantages,
    this.productUrl,
  });
}

class TimerState {
  final Duration totalDuration;
  final Duration remainingTime;
  final bool isRunning;
  final bool isPaused;
  final bool isFinished;

  const TimerState({
    required this.totalDuration,
    required this.remainingTime,
    required this.isRunning,
    required this.isPaused,
    required this.isFinished,
  });

  TimerState copyWith({
    Duration? totalDuration,
    Duration? remainingTime,
    bool? isRunning,
    bool? isPaused,
    bool? isFinished,
  }) {
    return TimerState(
      totalDuration: totalDuration ?? this.totalDuration,
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class ChifousiGame {
  final ChifousiChoice playerChoice;
  final ChifousiChoice aiChoice;
  final ChifousiResult result;

  const ChifousiGame({
    required this.playerChoice,
    required this.aiChoice,
    required this.result,
  });

  String get resultLabel {
    switch (result) {
      case ChifousiResult.win:
        return 'Victoire !';
      case ChifousiResult.draw:
        return 'Égalité';
      case ChifousiResult.lose:
        return 'Défaite';
    }
  }

  DifficultyLevel get difficultyFromResult {
    switch (result) {
      case ChifousiResult.win:
        return DifficultyLevel.easy;
      case ChifousiResult.draw:
        return DifficultyLevel.medium;
      case ChifousiResult.lose:
        return DifficultyLevel.hard;
    }
  }
}