// Fichier: lib/data/malfunctions_data.dart

import '../models/malfunction.dart';

final List<Malfunction> allMalfunctions = [
  // ============ PANNES FACILES ============
  
  // PÉRIPHÉRIQUES
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
    clientAttitude: 'Client stressé car il a du travail urgent à terminer',
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
    description: 'La souris se déplace de façon erratique',
    category: MalfunctionCategory.peripheral,
    difficulty: MalfunctionDifficulty.easy,
    symptoms: [
      'Le curseur saute sur l\'écran',
      'Mouvements imprécis',
      'Double-clics non intentionnels',
    ],
    clientAttitude: 'Client agacé par ce problème récurrent',
    creationSteps: [
      'Coller un petit morceau de scotch transparent sur le capteur optique',
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
  
  // RÉSEAU
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
    clientAttitude: 'Client calme et patient',
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
  
  Malfunction(
    id: 4,
    name: 'Connexion WiFi désactivée',
    description: 'Impossible de se connecter au WiFi',
    category: MalfunctionCategory.network,
    difficulty: MalfunctionDifficulty.easy,
    symptoms: [
      'Pas de réseau WiFi disponible',
      'Icône WiFi barrée ou absente',
      'Message "WiFi désactivé"',
    ],
    clientAttitude: 'Client confus ne comprenant pas ce qui s\'est passé',
    creationSteps: [
      'Désactiver le WiFi via le bouton physique ou le raccourci clavier',
      'Ou désactiver dans les paramètres Windows (Mode avion)',
    ],
    creationTips: [
      'Utiliser le raccourci clavier si disponible (souvent Fn+F2 ou similaire)',
      'Documenter l\'état initial',
    ],
    diagnosisSteps: [
      'Vérifier si le mode avion est activé',
      'Chercher un bouton physique WiFi',
      'Vérifier dans les paramètres réseau',
    ],
    solutionSteps: [
      'Désactiver le mode avion',
      'Activer le WiFi via le bouton ou le raccourci',
      'Réactiver dans les paramètres réseau',
    ],
    skillsWorked: ['IDI', 'TIP'],
    estimatedTime: '3-5 minutes',
  ),
  
  // ============ PANNES MOYENNES ============
  
  // MATÉRIEL
  Malfunction(
    id: 5,
    name: 'RAM mal insérée',
    description: 'L\'ordinateur ne démarre pas ou émet des bips',
    category: MalfunctionCategory.hardware,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'L\'ordinateur émet des bips au démarrage',
      'Écran noir, pas d\'affichage',
      'Les ventilateurs tournent mais rien ne s\'affiche',
    ],
    clientAttitude: 'Client paniqué pensant que son ordinateur est cassé',
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
    id: 6,
    name: 'Nappe disque débranchée',
    description: 'Le disque dur n\'est pas détecté',
    category: MalfunctionCategory.hardware,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'Message "No boot device found"',
      'Le disque n\'apparaît pas dans le BIOS',
      'Impossible de démarrer Windows',
    ],
    clientAttitude: 'Client inquiet de perdre toutes ses données',
    creationSteps: [
      'Éteindre et débrancher l\'ordinateur',
      'Ouvrir le boîtier',
      'Débrancher la nappe SATA du disque dur',
      'Refermer et rebrancher',
    ],
    creationTips: [
      'Photographier les connexions avant',
      'Repérer quel port SATA était utilisé',
      'Ne pas toucher aux autres composants',
    ],
    diagnosisSteps: [
      'Vérifier les connexions physiques du disque',
      'Entrer dans le BIOS pour voir si le disque est détecté',
      'Vérifier la connexion SATA et alimentation',
    ],
    solutionSteps: [
      'Éteindre et débrancher le PC',
      'Rebrancher la nappe SATA fermement',
      'Vérifier aussi le câble d\'alimentation',
      'Redémarrer et vérifier dans le BIOS',
    ],
    skillsWorked: ['IDI', 'ADRN'],
    estimatedTime: '10-15 minutes',
  ),
  
  // RÉSEAU
  Malfunction(
    id: 7,
    name: 'Carte réseau désactivée sous Windows',
    description: 'Pas de connexion réseau disponible',
    category: MalfunctionCategory.network,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'Pas de réseau détecté',
      'Icône réseau absente ou barrée',
      'Message "Aucune connexion disponible"',
    ],
    clientAttitude: 'Client frustré car il travaille en télétravail',
    creationSteps: [
      'Ouvrir le Gestionnaire de périphériques',
      'Trouver la carte réseau Ethernet',
      'Clic droit > Désactiver le périphérique',
    ],
    creationTips: [
      'Prendre une capture d\'écran avant désactivation',
      'Noter le nom exact de la carte réseau',
    ],
    diagnosisSteps: [
      'Ouvrir le Gestionnaire de périphériques',
      'Vérifier l\'état de la carte réseau',
      'Chercher une flèche vers le bas sur l\'icône',
    ],
    solutionSteps: [
      'Ouvrir le Gestionnaire de périphériques',
      'Clic droit sur la carte réseau',
      'Sélectionner "Activer le périphérique"',
    ],
    skillsWorked: ['IDI', 'TIP'],
    estimatedTime: '5-10 minutes',
  ),
  
  Malfunction(
    id: 8,
    name: 'Service DHCP désactivé',
    description: 'Impossible d\'obtenir une adresse IP',
    category: MalfunctionCategory.network,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'Pas d\'accès internet',
      'Adresse IP en 169.254.x.x',
      'Message "Pas de connexion Internet"',
    ],
    clientAttitude: 'Client perplexe devant les messages techniques',
    creationSteps: [
      'Ouvrir Services.msc en administrateur',
      'Trouver "Client DHCP"',
      'Clic droit > Arrêter',
      'Clic droit > Propriétés > Type de démarrage: Désactivé',
    ],
    creationTips: [
      'Noter l\'état initial du service',
      'Penser à arrêter ET désactiver le service',
    ],
    diagnosisSteps: [
      'Utiliser ipconfig pour voir l\'adresse IP',
      'Ouvrir Services.msc',
      'Vérifier l\'état du service "Client DHCP"',
    ],
    solutionSteps: [
      'Ouvrir Services.msc en administrateur',
      'Trouver "Client DHCP"',
      'Type de démarrage: Automatique',
      'Démarrer le service',
      'Utiliser ipconfig /renew',
    ],
    skillsWorked: ['TIP'],
    estimatedTime: '10-15 minutes',
  ),
  
  // LOGICIEL
  Malfunction(
    id: 9,
    name: 'Extension PDF bloquée',
    description: 'Les fichiers PDF ne s\'ouvrent pas correctement',
    category: MalfunctionCategory.software,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'Double-clic sur PDF n\'ouvre rien',
      'Message d\'erreur "Aucune application associée"',
      'PDF s\'ouvre avec le mauvais programme',
    ],
    clientAttitude: 'Client impatient ayant des documents urgents à consulter',
    creationSteps: [
      'Clic droit sur un fichier PDF',
      'Ouvrir avec > Choisir une autre application',
      'Sélectionner le Bloc-notes',
      'Cocher "Toujours utiliser cette application"',
    ],
    creationTips: [
      'Noter l\'application par défaut avant modification',
      'Utiliser un vrai fichier PDF pour le test',
    ],
    diagnosisSteps: [
      'Tenter d\'ouvrir un fichier PDF',
      'Vérifier l\'application associée',
      'Vérifier si Adobe Reader ou autre lecteur est installé',
    ],
    solutionSteps: [
      'Clic droit sur un fichier PDF',
      'Ouvrir avec > Choisir une autre application',
      'Sélectionner le bon lecteur PDF',
      'Cocher "Toujours utiliser cette application"',
    ],
    skillsWorked: ['IDI', 'TIP'],
    estimatedTime: '5-10 minutes',
  ),
  
  Malfunction(
    id: 10,
    name: 'Lecteur multimédia manquant',
    description: 'Impossible de lire des fichiers vidéo',
    category: MalfunctionCategory.software,
    difficulty: MalfunctionDifficulty.medium,
    symptoms: [
      'Message "Aucun lecteur disponible"',
      'Les vidéos ne se lancent pas',
      'Formats vidéo non reconnus',
    ],
    clientAttitude: 'Client déçu ne pouvant pas regarder ses vidéos',
    creationSteps: [
      'Désinstaller VLC ou le lecteur Windows Media',
      'Ou déplacer l\'exécutable VLC dans un autre dossier',
    ],
    creationTips: [
      'Noter l\'emplacement d\'installation avant',
      'Faire une sauvegarde du dossier VLC si déplacé',
    ],
    diagnosisSteps: [
      'Tenter de lire un fichier vidéo',
      'Vérifier si VLC est installé',
      'Chercher dans la liste des programmes installés',
    ],
    solutionSteps: [
      'Télécharger et installer VLC',
      'Ou associer les vidéos à un lecteur disponible',
      'Tester la lecture d\'une vidéo',
    ],
    skillsWorked: ['IDI', 'TIP'],
    estimatedTime: '10-15 minutes',
  ),
  
  // ============ PANNES DIFFICILES ============
  
  // SETUP/BIOS
  Malfunction(
    id: 11,
    name: 'Boot order modifié',
    description: 'L\'ordinateur ne démarre plus sur le disque dur',
    category: MalfunctionCategory.setup,
    difficulty: MalfunctionDifficulty.hard,
    symptoms: [
      'Message "No bootable device found"',
      'Message "Operating system not found"',
      'L\'ordinateur tente de booter sur USB/CD',
    ],
    clientAttitude: 'Client désemparé après avoir manipulé le BIOS',
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
    ],
    skillsWorked: ['IDI', 'ADRN', 'TIP'],
    estimatedTime: '15-20 minutes',
  ),
  
  Malfunction(
    id: 12,
    name: 'Port SATA désactivé dans le BIOS',
    description: 'Le disque dur n\'est pas détecté',
    category: MalfunctionCategory.setup,
    difficulty: MalfunctionDifficulty.hard,
    symptoms: [
      'Le disque n\'apparaît pas au démarrage',
      'Message "No boot device"',
      'Impossible d\'accéder au système',
    ],
    clientAttitude: 'Client très inquiet après une mise à jour du BIOS',
    creationSteps: [
      'Entrer dans le BIOS',
      'Aller dans Advanced / Peripherals',
      'Trouver SATA Configuration',
      'Désactiver le port SATA utilisé par le disque système',
      'Sauvegarder et quitter',
    ],
    creationTips: [
      'Noter quel port SATA est utilisé (généralement SATA0 ou SATA1)',
      'Photographier la configuration initiale',
      'Ne désactiver qu\'UN seul port',
    ],
    diagnosisSteps: [
      'Entrer dans le BIOS',
      'Vérifier la liste des périphériques détectés',
      'Aller dans SATA Configuration',
      'Vérifier l\'état des ports SATA',
    ],
    solutionSteps: [
      'Entrer dans le BIOS',
      'Aller dans SATA Configuration',
      'Réactiver le port SATA concerné',
      'Sauvegarder et redémarrer',
    ],
    skillsWorked: ['IDI', 'ADRN', 'TIP'],
    estimatedTime: '15-25 minutes',
  ),
  
  // IMPRESSION
  Malfunction(
    id: 13,
    name: 'Imprimante en mode "Hors connexion"',
    description: 'L\'imprimante refuse d\'imprimer',
    category: MalfunctionCategory.printer,
    difficulty: MalfunctionDifficulty.hard,
    symptoms: [
      'Les documents restent en file d\'attente',
      'Statut "Hors connexion" dans Windows',
      'Impossible d\'imprimer quoi que ce soit',
    ],
    clientAttitude: 'Client pressé ayant des documents urgents à imprimer',
    creationSteps: [
      'Ouvrir Panneau de configuration > Périphériques et imprimantes',
      'Clic droit sur l\'imprimante',
      'Sélectionner "Utiliser l\'imprimante hors connexion"',
    ],
    creationTips: [
      'Vérifier que l\'imprimante est physiquement allumée et connectée',
      'Prendre une capture avant modification',
    ],
    diagnosisSteps: [
      'Ouvrir les paramètres d\'impression',
      'Vérifier le statut de l\'imprimante',
      'Regarder si "Hors connexion" est coché',
    ],
    solutionSteps: [
      'Ouvrir Périphériques et imprimantes',
      'Clic droit sur l\'imprimante',
      'Décocher "Utiliser l\'imprimante hors connexion"',
      'Relancer l\'impression',
    ],
    skillsWorked: ['IDI', 'TIP'],
    estimatedTime: '10-15 minutes',
  ),
  
  Malfunction(
    id: 14,
    name: 'Spooler d\'impression bloqué',
    description: 'Les documents s\'accumulent sans s\'imprimer',
    category: MalfunctionCategory.printer,
    difficulty: MalfunctionDifficulty.hard,
    symptoms: [
      'File d\'attente bloquée',
      'Impossible d\'annuler les documents',
      'Nouvelles impressions ne partent pas',
    ],
    clientAttitude: 'Client exaspéré car ce problème se répète souvent',
    creationSteps: [
      'Ouvrir Services.msc',
      'Trouver "Spouleur d\'impression"',
      'Clic droit > Arrêter',
      'Ne PAS redémarrer le service',
    ],
    creationTips: [
      'Laisser des documents en attente pour rendre le diagnostic visible',
      'Noter l\'état initial du service',
    ],
    diagnosisSteps: [
      'Tenter d\'imprimer un document de test',
      'Ouvrir Services.msc',
      'Vérifier l\'état du "Spouleur d\'impression"',
      'Vérifier la file d\'attente',
    ],
    solutionSteps: [
      'Ouvrir Services.msc en administrateur',
      'Arrêter le service "Spouleur d\'impression"',
      'Supprimer les fichiers dans C:\\Windows\\System32\\spool\\PRINTERS',
      'Redémarrer le service',
      'Relancer l\'impression',
    ],
    skillsWorked: ['TIP'],
    estimatedTime: '15-20 minutes',
  ),
];