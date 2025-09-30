import '../models/scenarios.dart'; // Import corrigé au PLURIEL

/// Contient la liste statique de tous les scénarios disponibles pour le tirage.
class ScenariosData {
  static final List<Scenario> scenariosList = [
    Scenario(
      titre: "Cas Client : Nouvelle installation de poste", // Utilise TITRE
      contexte: "Un client, gérant de PME, vous appelle car il vient d'acheter un nouveau PC et a besoin d'aide pour l'intégrer à son réseau local et migrer ses données.",
      objectif: "Installer le poste, configurer l'accès réseau et les imprimantes, et transférer les données de l'ancien PC (si existant) sans interruption majeure de son activité.",
      contraintes: "Le client est pressé et n'est pas très à l'aise avec les termes techniques. Budget maximum pour l'intervention : 2 heures.",
      budget: "2 heures",
    ),
    Scenario(
      titre: "Cas SAV : Erreur 'Blue Screen'", // Utilise TITRE
      contexte: "Un particulier vous contacte car son ordinateur affiche un 'écran bleu de la mort' de manière aléatoire depuis ce matin, rendant le travail impossible.",
      objectif: "Diagnostiquer la cause de l'écran bleu (logiciel, pilote, ou matériel défectueux) et appliquer une solution permanente pour stabiliser le système.",
      contraintes: "Le PC est vital pour le client, et il refuse toute perte de données. L'accès à distance est possible, mais le problème peut nécessiter une intervention physique si c'est matériel.",
      budget: "1 heure",
    ),
    Scenario(
      titre: "Cas Client : Demande d'upgrade RAM", // Utilise TITRE
      contexte: "Un étudiant souhaite améliorer les performances de son laptop pour le gaming et vous demande conseil pour l'achat de barrettes de RAM.",
      objectif: "Déterminer le type de RAM compatible (DDR3/DDR4/DDR5, fréquence, format SO-DIMM) avec son modèle de PC et lui proposer la meilleure option dans son budget.",
      contraintes: "Budget très serré. Le PC est un modèle ancien, la RAM compatible peut être difficile à trouver. L'étudiant veut une justification claire de la fréquence choisie.",
      budget: "N/A (Conseil uniquement)",
    ),
    Scenario(
      titre: "Cas SAV : Connexion lente et instable", // Utilise TITRE
      contexte: "Une famille se plaint que sa connexion Internet est très lente, surtout le soir, et que le Wi-Fi se coupe souvent sur certains appareils.",
      objectif: "Vérifier la qualité du signal (câble/fibre), optimiser les paramètres du routeur (canaux Wi-Fi, DNS) et identifier tout appareil potentiellement consommateur de bande passante.",
      contraintes: "La famille utilise de nombreux appareils connectés. Vous devez expliquer les étapes en termes simples pour qu'ils puissent intervenir si le problème revient.",
      budget: "1,5 heure",
    ),
  ];
}
