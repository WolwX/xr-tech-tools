// Fichier: lib/data/malfunctions_data.dart

import '../models/malfunction.dart';

final List<Malfunction> allMalfunctions = [
  // ============ PANNES FACILES ============
  
  Malfunction(
    id: 1,
    name: 'Clavier USB déconnecté',
    description: 'Le clavier USB ne répond plus aux frappes',
    category: MalfunctionCategory.peripheral,
    difficulty: MalfunctionDifficulty.easy,
    symptoms: [
      'Les touches ne répondent pas',
      'Aucun voyant LED n\'est allumé',
      'Le système ne détecte pas le clavier',
    ],
    creationSteps: [
      'Débrancher le câble USB du clavier',
      'Ou désactiver le clavier dans le Gestionnaire de périphériques',
    ],
    creationTips: [
      'Simuler en retirant simplement le câble USB',
      'Si clavier sans fil, retirer les piles',
      'Documenter l\'état initial pour la vérification',
    ],
    diagnosisSteps: [
      'Vérifier la connexion physique du câble',
      'Tester le port USB avec un autre périphérique',
      'Vérifier dans le Gestionnaire de périphériques',
    ],
    solutionSteps: [
      'Rebrancher le câble USB fermement',
      'Essayer un autre port USB',
      'Redémarrer l\'ordinateur si nécessaire',
    ],
    skillsWorked: ['IDI', 'ADRN', 'TIP'],
    estimatedTime: '2-5 minutes',
  ),
  
  Malfunction(
    id: 2,
    name: 'Souris optique sale',
    description: 'La souris se déplace de façon erratique ou ne répond pas correctement',
    category: MalfunctionCategory.peripheral,
    difficulty: MalfunctionDifficulty.easy,
    symptoms: [
      'Le curseur saute sur l\'écran',
      'Mouvements imprécis',
      'Double-clics non intentionnels',
    ],
    creationSteps: [
      'Coller un petit morceau de scotch sur le capteur optique',
      'Ou utiliser la souris sur une surface inadaptée (verre, miroir)',
    ],
    creationTips: [
      'Utiliser du scotch transparent pour rendre le défaut moins visible',
      'Simuler l\'accumulation de poussière',
      'Prendre une photo avant pour comparaison',
    ],
    diagnosisSteps: [
      'Vérifier la propreté du capteur optique',
      'Tester sur une surface adaptée (tapis de souris)',
      'Vérifier l\'absence d\'obstruction du capteur',
    ],
    solutionSteps: [
      'Nettoyer le capteur avec un chiffon sec',
      'Utiliser une surface appropriée',
      'Si besoin, souffler pour retirer la poussière',
    ],
    skillsWorked: ['IDI', 'ADRN'],
    estimatedTime: '2-5 minutes',
  ),
  
  Malfunction(
    id: 3,
    name: 'Câble réseau débranché',
    description: 'Perte de connexion réseau filaire',
    category: MalfunctionCategory.network,
    difficulty: MalfunctionDifficulty.easy,
    symptoms: [
      'Icône réseau avec croix rouge',
      'Message "Câble réseau débranché"',
      'Impossible d\'accéder à internet',
    ],
    creationSteps: [
      'Débrancher le câble Ethernet du PC ou du switch',
      'Ou débrancher légèrement pour créer un faux contact',
    ],
    creationTips: [
      'Débrancher côté PC plutôt que côté routeur',
      'Documenter quel port était utilisé',
      'Vérifier que le WiFi est désactivé',
    ],
    diagnosisSteps: [
      'Vérifier le branchement physique du câble',
      'Vérifier les LED sur la carte réseau',
      'Tester le câble sur un autre équipement',
    ],
    solutionSteps: [
      'Rebrancher le câble Ethernet',
      'Vérifier le clic de verrouillage du connecteur RJ45',
      'Vérifier la connexion des deux côtés',
    ],
    skillsWorked: ['IDI', 'TIP'],
    estimatedTime: '2-5 minutes',
  ),
  
  // ============ PANNES MOYENNES ============
  
  Malfunction(
    id: 4,
    name: 'RAM mal insérée',
    description: 'L\'ordinateur ne démarre pas ou émet des bips',
    category: MalfunctionCategory.hardware,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'L\'ordinateur émet des bips au démarrage',
      'Écran noir, pas d\'affichage',
      'Les ventilateurs tournent mais rien ne s\'affiche',
    ],
    creationSteps: [
      'Éteindre l\'ordinateur et débrancher l\'alimentation',
      'Ouvrir le boîtier',
      'Retirer légèrement une barrette de RAM (ne pas enlever complètement)',
      'Refermer et rebrancher',
    ],
    creationTips: [
      'Porter un bracelet antistatique',
      'Photographier la position initiale',
      'Ne pas forcer sur les clips de maintien',
      'Simuler un mauvais contact, pas une absence de RAM',
    ],
    diagnosisSteps: [
      'Écouter les bips du BIOS (code erreur)',
      'Vérifier l\'insertion correcte de la RAM',
      'Tester en retirant/réinsérant les barrettes',
    ],
    solutionSteps: [
      'Éteindre et débrancher le PC',
      'Retirer complètement la barrette',
      'Réinsérer fermement jusqu\'au clic des clips',
      'Redémarrer et vérifier',
    ],
    skillsWorked: ['IDI', 'ADRN'],
    estimatedTime: '10-15 minutes',
  ),
  
  Malfunction(
    id: 5,
    name: 'Adresse IP en conflit',
    description: 'Message d\'erreur de conflit d\'adresse IP',
    category: MalfunctionCategory.network,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'Message "Conflit d\'adresse IP détecté"',
      'Connexion réseau instable',
      'Perte de connexion intermittente',
    ],
    creationSteps: [
      'Désactiver le DHCP sur l\'ordinateur',
      'Configurer manuellement une adresse IP déjà utilisée sur le réseau',
      'Exemple: si routeur = 192.168.1.1, mettre 192.168.1.1 au PC',
    ],
    creationTips: [
      'Noter la configuration IP initiale',
      'Utiliser ipconfig /all avant modification',
      'Créer une note avec la config à restaurer',
    ],
    diagnosisSteps: [
      'Ouvrir les propriétés de la carte réseau',
      'Vérifier si IP est en manuel ou automatique',
      'Utiliser ipconfig pour voir la configuration',
      'Vérifier les autres machines du réseau',
    ],
    solutionSteps: [
      'Accéder aux propriétés IPv4 de la carte réseau',
      'Sélectionner "Obtenir une adresse IP automatiquement"',
      'Libérer et renouveler l\'IP (ipconfig /release puis /renew)',
      'Vérifier la connexion',
    ],
    skillsWorked: ['IDI', 'TIP'],
    estimatedTime: '10-15 minutes',
  ),
  
  // ============ PANNES DIFFICILES ============
  
  Malfunction(
    id: 6,
    name: 'Boot order modifié',
    description: 'L\'ordinateur ne démarre plus sur le disque dur',
    category: MalfunctionCategory.startup,
    difficulty: MalfunctionDifficulty.hard,
    symptoms: [
      'Message "No bootable device found"',
      'Message "Operating system not found"',
      'L\'ordinateur tente de booter sur USB/CD',
    ],
    creationSteps: [
      'Redémarrer et entrer dans le BIOS (F2, DEL ou F10 selon fabricant)',
      'Aller dans Boot Menu / Boot Order',
      'Déplacer le disque dur en dernière position',
      'Mettre USB ou CD-ROM en premier',
      'Sauvegarder et quitter',
    ],
    creationTips: [
      'Photographier l\'ordre de boot initial',
      'Noter la touche exacte pour entrer dans le BIOS',
      'Ne pas modifier d\'autres paramètres BIOS',
      'Vérifier que Secure Boot est compatible',
    ],
    diagnosisSteps: [
      'Identifier la touche pour accéder au BIOS',
      'Entrer dans le BIOS au démarrage',
      'Vérifier l\'ordre de boot dans Boot Menu',
      'Vérifier que le disque dur est détecté',
    ],
    solutionSteps: [
      'Entrer dans le BIOS',
      'Accéder à Boot Order / Boot Priority',
      'Remettre le disque dur (HDD/SSD) en première position',
      'Sauvegarder et redémarrer',
      'Vérifier le démarrage normal',
    ],
    skillsWorked: ['IDI', 'ADRN', 'TIP'],
    estimatedTime: '15-20 minutes',
  ),
];