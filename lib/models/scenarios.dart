
// La classe reste au singulier
class Scenario {
  final String titre;
  final String contexte;
  final String objectif;
  final String contraintes; // <--- Ce paramètre doit être présent
  final String budget;

  Scenario({
    required this.titre,
    required this.contexte,
    required this.objectif,
    required this.contraintes,
    required this.budget,
  });
}
