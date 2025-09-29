// Fichier: lib/data/commercial_scenarios_data.dart

import '../models/commercial_scenario.dart';

class CommercialScenariosDatabase {
  static const List<CommercialScenario> scenarios = [
    // SCÉNARIOS FACILES (budget clair et réaliste)
    CommercialScenario(
      id: 1,
      clientProfile: "Étudiant en première année",
      clientRequest: "cherche un ordinateur portable pour suivre ses cours et faire ses devoirs",
      budgetInfo: "Budget 700€",
      clientAttitude: "Timide, parle doucement, hésite beaucoup",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Quelles matières étudiez-vous ?",
        "Avez-vous des logiciels spécifiques à utiliser ?",
        "Combien d'heures par jour l'utiliserez-vous ?",
        "Avez-vous besoin de le transporter souvent ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Laptop Acer Aspire 5",
          price: "650€",
          advantages: ["Processeur récent", "SSD rapide", "Autonomie 8h"],
          disadvantages: ["Écran basique", "Pas pour gaming"],
          productUrl: "https://www.ldlc.com/informatique/ordinateur-portable/pc-portable/c4265/+ftxt-acer+aspire+5.html",
        ),
        ScenarioSolution(
          productName: "Lenovo IdeaPad 3",
          price: "680€",
          advantages: ["Bon écran", "Clavier confortable", "16GB RAM"],
          disadvantages: ["Plus lourd", "Autonomie moyenne"],
          productUrl: "https://www.ldlc.com/informatique/ordinateur-portable/pc-portable/c4265/+ftxt-lenovo+ideapad+3.html",
        ),
      ],
      commonTraps: [
        "Ne pas proposer du gaming inutile",
        "Vérifier les ports USB nécessaires"
      ],
      skillsWorked: [
        "Identification des besoins réels",
        "Argumentation prix/performance"
      ]
    ),

    // ... [Scénarios 2-10 existants que vous avez déjà] ...

    // Ensuite viennent les scénarios 11-33 que je viens de générer

    CommercialScenario(
      id: 2,
      clientProfile: "Chef d'entreprise de 5 employés",
      clientRequest: "a besoin d'une imprimante pour imprimer beaucoup de documents",
      budgetInfo: "Budget 600€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Combien de pages par mois environ ?",
        "Impression couleur nécessaire ?",
        "Besoin de fonctions scan/fax ?",
        "Connexion réseau importante ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Brother MFC-L3770CDW",
          price: "580€",
          advantages: ["Multifonction", "WiFi", "Coût par page faible"],
          disadvantages: ["Encombrante", "Consommation élevée"],
          productUrl: "https://www.ldlc.com/fiche/PB00266890.html",
        ),
      ],
      commonTraps: [
        "Calculer le coût des consommables",
        "Vérifier la compatibilité réseau"
      ],
      skillsWorked: [
        "Calcul TCO (Total Cost of Ownership)",
        "Conseil professionnel"
      ]
    ),

    // SCÉNARIOS MOYENS (budget limite ou contrainte)
    CommercialScenario(
      id: 3,
      clientProfile: "Artisan maladroit",
      clientRequest: "cherche un smartphone résistant pour utiliser deux numéros de téléphone",
      budgetInfo: "Budget 400€ maximum",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Dans quel environnement travaillez-vous ?",
        "Pourquoi deux numéros ? Pro et perso ?",
        "À quelle fréquence le faites-vous tomber ?",
        "Autonomie importante sur chantier ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Samsung Galaxy XCover 6 Pro",
          price: "380€",
          advantages: ["IP68", "Double SIM", "Batterie amovible"],
          disadvantages: ["Performances limitées", "Appareil photo moyen"],
          productUrl: "https://www.samsung.com/fr/smartphones/galaxy-xcover/",
        ),
      ],
      commonTraps: [
        "Expliquer la technologie dual SIM",
        "Ne pas négliger la robustesse"
      ],
      skillsWorked: [
        "Découverte de besoins cachés",
        "Argumentation technique adaptée"
      ]
    ),

    CommercialScenario(
      id: 4,
      clientProfile: "Retraité de 70 ans",
      clientRequest: "veut un ordinateur simple pour ses mails et regarder des photos",
      budgetInfo: "Budget 500€ mais préfère pas trop cher",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Utilisez-vous déjà un ordinateur ?",
        "Avez-vous des problèmes de vue ?",
        "Internet déjà installé chez vous ?",
        "Qui pourra vous aider en cas de souci ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "PC tout-en-un HP 22",
          price: "450€",
          advantages: ["Écran grand", "Peu de câbles", "Clavier/souris inclus"],
          disadvantages: ["Difficile à réparer", "Peu évolutif"],
          productUrl: "https://www.ldlc.com/informatique/ordinateur-de-bureau/pc-de-bureau/c4266/+fb-C000028423+ftxt-hp+22.html",
        ),
      ],
      commonTraps: [
        "Adapter le vocabulaire technique",
        "Prévoir formation/accompagnement"
      ],
      skillsWorked: [
        "Communication adaptée senior",
        "Conseil simplicité vs prix"
      ]
    ),

    // SCÉNARIOS DIFFICILES (budget flou, contraintes multiples)
    CommercialScenario(
      id: 5,
      clientProfile: "Passionné de jeux vidéos",
      clientRequest: "veut jouer aux derniers jeux en très haute qualité visuelle",
      budgetInfo: "Budget non précisé",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "Quel est votre budget réel ?",
        "Quels jeux voulez-vous jouer ?",
        "En quelle résolution ? 1080p, 1440p, 4K ?",
        "Avez-vous déjà un écran adapté ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "PC Gaming RTX 4070",
          price: "1500€",
          advantages: ["4K possible", "Ray tracing", "Évolutif"],
          disadvantages: ["Prix élevé", "Consommation importante"],
          productUrl: "https://www.ldlc.com/informatique/ordinateur-de-bureau/pc-de-bureau/c4266/+fb-C000040844+fv1026-19673.html",
        ),
        ScenarioSolution(
          productName: "PC Gaming RTX 4060",
          price: "1000€",
          advantages: ["Bon rapport qualité-prix", "1440p fluide"],
          disadvantages: ["4K limitée", "Moins futur-proof"],
          productUrl: "https://www.ldlc.com/informatique/ordinateur-de-bureau/pc-de-bureau/c4266/+fb-C000040844+fv1026-19672.html",
        ),
      ],
      commonTraps: [
        "Faire préciser le budget avant tout",
        "Éviter le surdimensionnement inutile"
      ],
      skillsWorked: [
        "Gestion budget non défini",
        "Hiérarchisation des priorités"
      ]
    ),

    CommercialScenario(
      id: 6,
      clientProfile: "Mamie qui se dit geek",
      clientRequest: "joue beaucoup sur Facebook et veut un ordinateur facile avec de grosses touches",
      budgetInfo: "Budget confortable",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "C'est quoi 'confortable' pour vous en euros ?",
        "À quels jeux jouez-vous exactement ?",
        "Avez-vous des problèmes de vue ou d'arthrite ?",
        "Qui vous aide actuellement avec l'informatique ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "PC basique + clavier grands caractères",
          price: "600€",
          advantages: ["Interface simple", "Touches visibles", "Support familial"],
          disadvantages: ["Performances limitées", "Formation nécessaire"],
          productUrl: "https://www.ldlc.com/informatique/ordinateur-de-bureau/pc-de-bureau/c4266/+fv121-16342.html",
        ),
      ],
      commonTraps: [
        "Budget 'confortable' peut être 300€ ou 1500€",
        "Besoins réels vs perception du client"
      ],
      skillsWorked: [
        "Définition budget évasif",
        "Adaptation besoins réels/perçus"
      ]
    ),

    CommercialScenario(
      id: 7,
      clientProfile: "Lycéen passionné",
      clientRequest: "veut upgrader son PC pour le futur jeu GTA 6 avec une nouvelle carte graphique",
      budgetInfo: "Budget 500€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Quelle est votre configuration actuelle complète ?",
        "Combien de RAM avez-vous ?",
        "Quelle est votre alimentation actuelle ?",
        "À quelle résolution voulez-vous jouer ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "RTX 4060 + 8GB RAM supplémentaires",
          price: "480€",
          advantages: ["Équilibre du système", "Bon pour 1080p"],
          disadvantages: ["Pas optimal pour 1440p+", "Compromis nécessaire"],
          productUrl: "https://www.ldlc.com/informatique/pieces-informatique/carte-graphique-interne/c4684/+fv1026-19672.html",
        ),
      ],
      commonTraps: [
        "Identifier le goulot d'étranglement RAM",
        "Équilibrer les composants"
      ],
      skillsWorked: [
        "Analyse configuration système",
        "Conseil upgrade intelligent"
      ]
    ),

    CommercialScenario(
      id: 8,
      clientProfile: "Influenceuse débutante",
      clientRequest: "a besoin d'équipement mobile pour créer du contenu photo et vidéo",
      budgetInfo: "Budget 800€ avec accessoires",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Quel type de contenu ? Photo, vidéo, live ?",
        "Pour quelles plateformes ? Instagram, TikTok ?",
        "Tournage en intérieur ou extérieur ?",
        "Niveau de post-production souhaité ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "iPad Air + accessoires",
          price: "780€",
          advantages: ["Portable", "Création simple", "Qualité correcte"],
          disadvantages: ["Stockage limité", "Apps payantes"],
          productUrl: "https://www.apple.com/fr/ipad-air/",
        ),
      ],
      commonTraps: [
        "Budget serré pour matériel complet",
        "Sous-estimer les accessoires nécessaires"
      ],
      skillsWorked: [
        "Priorisation dans budget limité",
        "Conseil création de contenu"
      ]
    ),

    CommercialScenario(
      id: 9,
      clientProfile: "Couple de jeunes retraités",
      clientRequest: "veulent imprimer leurs photos de famille depuis leur smartphone",
      budgetInfo: "Budget 300€ et simplicité maximale",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Combien de photos par mois ?",
        "Quels formats ? 10x15, A4 ?",
        "Quel smartphone utilisez-vous ?",
        "Êtes-vous à l'aise avec les applications ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Canon Selphy CP1500",
          price: "180€",
          advantages: ["Spécialisée photo", "WiFi simple", "Format 10x15"],
          disadvantages: ["Un seul format", "Coût par photo élevé"],
          productUrl: "https://www.canon.fr/printers/selphy-cp1500/",
        ),
        ScenarioSolution(
          productName: "HP Envy 6020e",
          price: "120€",
          advantages: ["Multifonction", "HP Smart app", "Abonnement encre"],
          disadvantages: ["Moins spécialisée photo", "Plus complexe"],
          productUrl: "https://www.hp.com/fr-fr/shop/product.aspx?id=223N4B",
        ),
      ],
      commonTraps: [
        "Complexité des applications",
        "Coût réel par impression"
      ],
      skillsWorked: [
        "Conseil senior technologie",
        "Comparaison solutions spécialisées vs polyvalentes"
      ]
    ),

    CommercialScenario(
      id: 10,
      clientProfile: "Développeuse en reconversion",
      clientRequest: "a besoin d'un ou deux écrans pour remplacer son 20 pouces et faire du multitâche",
      budgetInfo: "Budget 1000€ uniquement pour les écrans",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Quels ports avez-vous sur votre ordinateur ?",
        "Préférez-vous deux écrans identiques ou complémentaires ?",
        "Quelle résolution minimum souhaitez-vous ?",
        "Avez-vous de la place pour des bras articulés ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "2x Dell S2722DC 27\" 1440p",
          price: "900€",
          advantages: ["USB-C", "Qualité IPS", "Ergonomiques"],
          disadvantages: ["Pas de 4K", "Luminosité moyenne"],
          productUrl: "https://www.dell.com/fr-fr/shop/ecran-dell-27-usb-c-s2722dc/apd/210-bazl/moniteurs-et-accessoires-de-moniteur",
        ),
        ScenarioSolution(
          productName: "LG 34WN80C Ultrawide + 24\" vertical",
          price: "950€",
          advantages: ["Large workspace", "USB-C hub", "Setup original"],
          disadvantages: ["Moins standard", "Gaming moyen"],
          productUrl: "https://www.lg.com/fr/moniteurs/lg-34wn80c-b",
        ),
      ],
      commonTraps: [
        "Vérifier compatibilité ports",
        "Prévoir support/bras dans budget"
      ],
      skillsWorked: [
        "Conseil setup professionnel",
        "Optimisation espace de travail"
      ]
    ),

    // À ajouter dans lib/data/commercial_scenarios_data.dart après le scénario 10

    // SCÉNARIO 11
    CommercialScenario(
      id: 11,
      clientProfile: "Graphiste freelance",
      clientRequest: "cherche un écran pour retoucher des photos avec précision des couleurs",
      budgetInfo: "Budget 400€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Type de travaux graphiques principaux ?",
        "Calibration colorimétrique importante ?",
        "Taille d'écran souhaitée ?",
        "Connexion à un Mac ou PC ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "BenQ SW240",
          price: "380€",
          advantages: ["Calibré usine", "IPS 99% sRGB", "Pivot possible"],
          disadvantages: ["24 pouces seulement", "Pas USB-C"],
          productUrl: "https://www.benq.eu/fr-fr/monitor/photographer/sw240.html",
        ),
      ],
      commonTraps: [
        "Ne pas confondre gaming et graphisme",
        "Importance de la dalle IPS"
      ],
      skillsWorked: [
        "Conseil professionnel spécialisé",
        "Compréhension besoins techniques"
      ]
    ),

    // SCÉNARIO 12
    CommercialScenario(
      id: 12,
      clientProfile: "Parent soucieux",
      clientRequest: "veut une souris ergonomique pour son enfant qui passe du temps sur ordinateur",
      budgetInfo: "Budget 50€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Âge de l'enfant ?",
        "Taille de main ?",
        "Usage principal : école ou jeux ?",
        "Câblé ou sans-fil préféré ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Logitech M330",
          price: "25€",
          advantages: ["Ergonomique", "Sans-fil", "Silencieuse"],
          disadvantages: ["Pas gaming", "Pile AA nécessaire"],
          productUrl: "https://www.logitech.fr/fr-fr/products/mice/m330-silent-plus.html",
        ),
      ],
      commonTraps: [
        "Ergonomie selon taille main",
        "Usage scolaire vs gaming"
      ],
      skillsWorked: [
        "Conseil famille",
        "Prévention santé enfant"
      ]
    ),

    // SCÉNARIO 13
    CommercialScenario(
      id: 13,
      clientProfile: "Lycéen",
      clientRequest: "cherche une clé USB rapide pour transférer de gros fichiers de montage vidéo",
      budgetInfo: "Budget 40€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Taille de fichiers habituels ?",
        "Capacité nécessaire ?",
        "USB 3.0 ou 3.1 sur ordinateur ?",
        "Pertes fréquentes de clés ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "SanDisk Extreme Go USB 3.2 128GB",
          price: "35€",
          advantages: ["Très rapide 200MB/s", "Compacte", "Fiable"],
          disadvantages: ["Chauffe un peu", "Petite = facile à perdre"],
          productUrl: "https://www.westerndigital.com/fr-fr/products/usb-flash-drives/sandisk-extreme-go-usb-3-2",
        ),
      ],
      commonTraps: [
        "Vitesse lecture vs écriture",
        "USB 2.0 vs 3.0 important"
      ],
      skillsWorked: [
        "Conseil stockage mobile",
        "Vitesse transfert"
      ]
    ),

    // SCÉNARIO 14
    CommercialScenario(
      id: 14,
      clientProfile: "Télétravailleur",
      clientRequest: "a besoin d'un support pour surélever son ordinateur portable",
      budgetInfo: "Budget 60€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Problèmes de dos ou nuque ?",
        "Taille de l'ordinateur portable ?",
        "Fixe ou ajustable préféré ?",
        "Clavier/souris externes déjà possédés ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Support Laptop Rain Design mStand",
          price: "55€",
          advantages: ["Ergonomique", "Aluminium stable", "Ventilation"],
          disadvantages: ["Hauteur fixe", "Encombrant"],
          productUrl: "https://www.raindesigninc.com/mstand.html",
        ),
      ],
      commonTraps: [
        "Ergonomie posture importante",
        "Clavier externe nécessaire"
      ],
      skillsWorked: [
        "Conseil ergonomie télétravail",
        "Prévention TMS"
      ]
    ),

    // SCÉNARIO 15
    CommercialScenario(
      id: 15,
      clientProfile: "Gamer occasionnel",
      clientRequest: "veut améliorer son setup avec un tapis de souris gaming",
      budgetInfo: "Budget 30€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Taille bureau disponible ?",
        "Jeux joués principalement ?",
        "Sensibilité souris haute ou basse ?",
        "RGB important ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "SteelSeries QcK Heavy XXL",
          price: "40€",
          advantages: ["Très grande surface", "Bords cousus", "Antidérapant"],
          disadvantages: ["Dépasse budget", "Noir basique"],
          productUrl: "https://fr.steelseries.com/gaming-mousepads/qck-heavy-series",
        ),
      ],
      commonTraps: [
        "Taille selon sensibilité",
        "RGB = gadget cher"
      ],
      skillsWorked: [
        "Accessoires gaming",
        "Optimisation setup"
      ]
    ),

    // SCÉNARIO 16
    CommercialScenario(
      id: 16,
      clientProfile: "Enseignante maternelle",
      clientRequest: "cherche une tablette éducative pour ses élèves",
      budgetInfo: "Budget 200€, besoin de 2",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Âge des enfants ?",
        "Applications éducatives précises ?",
        "Robustesse importante ?",
        "Gestion classe / contrôle ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Amazon Fire HD 10 Kids x2",
          price: "180€ x2 = 360€",
          advantages: ["Coque protection", "Contrôle parental", "Contenu Kids+"],
          disadvantages: ["Dépasse budget total", "Écosystème Amazon"],
          productUrl: "https://www.amazon.fr/Fire-HD-10-Kids",
        ),
      ],
      commonTraps: [
        "Budget x2 tablettes",
        "Robustesse enfants critique"
      ],
      skillsWorked: [
        "Matériel éducatif",
        "Calcul budget collectif"
      ]
    ),

    // SCÉNARIO 17
    CommercialScenario(
      id: 17,
      clientProfile: "Photographe amateur",
      clientRequest: "veut une carte mémoire rapide pour son appareil photo",
      budgetInfo: "Budget 80€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Quel appareil photo ?",
        "Photo ou vidéo principalement ?",
        "Résolution vidéo si applicable ?",
        "Capacité souhaitée ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "SanDisk Extreme Pro SDXC 128GB",
          price: "70€",
          advantages: ["Vitesse 170MB/s", "V30 pour 4K", "Fiable"],
          disadvantages: ["Pas la plus rapide", "Chère au Go"],
          productUrl: "https://www.westerndigital.com/fr-fr/products/memory-cards/sandisk-extreme-pro-uhs-i-sd",
        ),
      ],
      commonTraps: [
        "Vitesse selon usage photo/vidéo",
        "Classe UHS importante"
      ],
      skillsWorked: [
        "Cartes mémoire techniques",
        "Spécifications photo"
      ]
    ),

    // SCÉNARIO 18
    CommercialScenario(
      id: 18,
      clientProfile: "Étudiant en droit",
      clientRequest: "a besoin d'une solution pour imprimer de gros volumes de documents",
      budgetInfo: "Budget 250€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Volume mensuel estimé ?",
        "Noir et blanc uniquement ?",
        "À domicile ou accès imprimerie ?",
        "Recto-verso automatique important ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Brother HL-L2375DW",
          price: "180€",
          advantages: ["Laser N&B", "Rapide", "Duplex auto", "WiFi"],
          disadvantages: ["Pas de scanner", "Toner en sus"],
          productUrl: "https://www.brother.fr/imprimantes/hl-l2375dw",
        ),
      ],
      commonTraps: [
        "Laser vs jet d'encre pour volume",
        "Coût par page crucial"
      ],
      skillsWorked: [
        "Impression gros volumes",
        "TCO étudiant"
      ]
    ),

    // SCÉNARIO 19
    CommercialScenario(
      id: 19,
      clientProfile: "Papa bricoleur",
      clientRequest: "veut une lampe LED pour éclairer son établi dans le garage",
      budgetInfo: "Budget 50€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Taille de l'établi ?",
        "Travaux de précision ?",
        "Prise électrique disponible ?",
        "Température de couleur préférée ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Lampe LED d'atelier 40W",
          price: "45€",
          advantages: ["Puissante", "Bras articulé", "Longue durée"],
          disadvantages: ["Encombrante", "Température fixe"],
          productUrl: "https://www.ldlc.com/",
        ),
      ],
      commonTraps: [
        "Lumens suffisants important",
        "Température couleur travaux"
      ],
      skillsWorked: [
        "Éclairage technique",
        "Besoins atelier"
      ]
    ),

    // SCÉNARIO 20
    CommercialScenario(
      id: 20,
      clientProfile: "Retraité passionné de généalogie",
      clientRequest: "cherche un scanner pour numériser de vieilles photos de famille",
      budgetInfo: "Budget pas très élevé",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "Budget maximum exact ?",
        "Nombre de photos approximatif ?",
        "Taille des photos ?",
        "Qualité de numérisation souhaitée ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Epson Perfection V19",
          price: "80€",
          advantages: ["Compact", "Bonne qualité", "Facile d'usage"],
          disadvantages: ["Lent", "Format A4 maximum"],
          productUrl: "https://www.epson.fr/products/scanners/perfection-v19",
        ),
      ],
      commonTraps: [
        "'Pas très élevé' à définir",
        "DPI selon taille originale"
      ],
      skillsWorked: [
        "Numérisation photos anciennes",
        "Budget senior flou"
      ]
    ),

    // SCÉNARIO 21
    CommercialScenario(
      id: 21,
      clientProfile: "Jeune chef d'entreprise",
      clientRequest: "a besoin d'un routeur WiFi performant pour son open space",
      budgetInfo: "Budget 150€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Surface du local ?",
        "Nombre d'employés ?",
        "Murs épais ou cloisons ?",
        "Vitesse connexion internet ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "TP-Link Archer AX55",
          price: "120€",
          advantages: ["WiFi 6", "Bonne portée", "4 antennes"],
          disadvantages: ["Configuration initiale", "Pas mesh"],
          productUrl: "https://www.tp-link.com/fr/home-networking/wifi-router/archer-ax55/",
        ),
      ],
      commonTraps: [
        "Surface vs puissance routeur",
        "WiFi 5 vs 6"
      ],
      skillsWorked: [
        "Réseau petit bureau",
        "Couverture WiFi"
      ]
    ),

    // SCÉNARIO 22
    CommercialScenario(
      id: 22,
      clientProfile: "Maman de trois enfants",
      clientRequest: "cherche une solution pour que ses enfants écoutent de la musique sans déranger",
      budgetInfo: "Budget 100€ pour 3 casques",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Âges des enfants ?",
        "Filaire ou sans-fil ?",
        "Limitation volume importante ?",
        "Utilisation nomade ou fixe ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "JBL JR310BT x3",
          price: "35€ x3 = 105€",
          advantages: ["Bluetooth", "Limité 85dB", "Légers"],
          disadvantages: ["Léger dépassement", "Qualité moyenne"],
          productUrl: "https://fr.jbl.com/casques-pour-enfants/JR310BT.html",
        ),
      ],
      commonTraps: [
        "Protection auditive enfants",
        "Budget x3 casques"
      ],
      skillsWorked: [
        "Audio enfants sécuritaire",
        "Achat multiple famille"
      ]
    ),

    // SCÉNARIO 23
    CommercialScenario(
      id: 23,
      clientProfile: "Étudiant en informatique",
      clientRequest: "veut un clavier mécanique pour programmer confortablement",
      budgetInfo: "Budget 120€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Taille clavier préférée ?",
        "Switches préférés ?",
        "RGB important ?",
        "Frappe bruyante acceptable ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Keychron K8",
          price: "100€",
          advantages: ["Mécanique", "Sans-fil", "Mac/PC compatible"],
          disadvantages: ["Switches à choisir", "Lourd"],
          productUrl: "https://www.keychron.com/products/keychron-k8-wireless-mechanical-keyboard",
        ),
      ],
      commonTraps: [
        "Switches selon préférence",
        "Taille clavier important"
      ],
      skillsWorked: [
        "Claviers mécaniques",
        "Confort programmation"
      ]
    ),

    // SCÉNARIO 24
    CommercialScenario(
      id: 24,
      clientProfile: "Propriétaire de gîte rural",
      clientRequest: "cherche une solution WiFi pour couvrir plusieurs bâtiments",
      budgetInfo: "Budget 300€",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "Distance entre bâtiments ?",
        "Nombre de chambres/gîtes ?",
        "Installation par professionnel ou soi-même ?",
        "Connexion internet actuelle ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Système mesh TP-Link Deco M5 (3 unités)",
          price: "150€",
          advantages: ["Mesh évolutif", "Facile installation", "Gestion app"],
          disadvantages: ["Portée limitée extérieur", "Pas WiFi 6"],
          productUrl: "https://www.tp-link.com/fr/home-networking/deco/deco-m5/",
        ),
      ],
      commonTraps: [
        "Distance extérieure difficile",
        "Peut nécessiter plus d'unités"
      ],
      skillsWorked: [
        "Réseau multi-bâtiments",
        "Solution mesh"
      ]
    ),

    // SCÉNARIO 25
    CommercialScenario(
      id: 25,
      clientProfile: "Adolescente passionnée de dessin",
      clientRequest: "veut une tablette graphique pour dessiner sur ordinateur",
      budgetInfo: "Budget 150€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Niveau de dessin ?",
        "Avec ou sans écran ?",
        "Taille active souhaitée ?",
        "Logiciel de dessin déjà choisi ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Wacom Intuos M",
          price: "180€",
          advantages: ["Marque référence", "Stylet sans pile", "Logiciels inclus"],
          disadvantages: ["Dépasse budget", "Sans écran"],
          productUrl: "https://www.wacom.com/fr-fr/products/pen-tablets/wacom-intuos",
        ),
      ],
      commonTraps: [
        "Avec/sans écran = prix x3",
        "Taille selon usage"
      ],
      skillsWorked: [
        "Tablettes graphiques",
        "Dessin numérique débutant"
      ]
    ),

    // SCÉNARIO 26
    CommercialScenario(
      id: 26,
      clientProfile: "Personne à mobilité réduite",
      clientRequest: "a besoin d'une souris adaptée facile à utiliser",
      budgetInfo: "Budget 100€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Type de limitation précise ?",
        "Préhension difficile ?",
        "Trackball envisagé ?",
        "Usage intensif ou occasionnel ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Logitech Ergo M575",
          price: "50€",
          advantages: ["Trackball", "Ergonomique", "Pas de mouvement main"],
          disadvantages: ["Apprentissage", "Main droite uniquement"],
          productUrl: "https://www.logitech.fr/fr-fr/products/mice/m575-ergo-wireless-trackball.html",
        ),
      ],
      commonTraps: [
        "Besoin spécifique handicap",
        "Accompagnement important"
      ],
      skillsWorked: [
        "Accessibilité handicap moteur",
        "Solutions adaptées"
      ]
    ),

    // SCÉNARIO 27
    CommercialScenario(
      id: 27,
      clientProfile: "Vidéaste YouTube débutant",
      clientRequest: "cherche un éclairage pour améliorer ses vidéos",
      budgetInfo: "Budget 80€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Type de vidéos ?",
        "Espace de tournage ?",
        "Lumière naturelle disponible ?",
        "Température couleur importante ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Ring light 12 pouces + trépied",
          price: "60€",
          advantages: ["Polyvalent", "Réglable", "Trépied inclus"],
          disadvantages: ["Basique", "Taille moyenne"],
          productUrl: "https://www.amazon.fr/ring-light",
        ),
      ],
      commonTraps: [
        "Éclairage crucial qualité vidéo",
        "Température couleur 5500K idéal"
      ],
      skillsWorked: [
        "Éclairage vidéo",
        "YouTube débutant"
      ]
    ),

    // SCÉNARIO 28
    CommercialScenario(
      id: 28,
      clientProfile: "Comptable à domicile",
      clientRequest: "veut un onduleur pour protéger son ordinateur des coupures",
      budgetInfo: "Budget 150€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Puissance ordinateur ?",
        "Coupures fréquentes ?",
        "Besoin autonomie longue ?",
        "Autres appareils à protéger ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "APC Back-UPS 700VA",
          price: "130€",
          advantages: ["Fiable", "Protection surtension", "Autonomie 10min"],
          disadvantages: ["Autonomie courte", "Bruyant en alarme"],
          productUrl: "https://www.apc.com/fr/fr/product/BX700U-FR/",
        ),
      ],
      commonTraps: [
        "VA vs Watts différent",
        "Autonomie selon usage"
      ],
      skillsWorked: [
        "Protection électrique",
        "Onduleurs"
      ]
    ),

    // SCÉNARIO 29
    CommercialScenario(
      id: 29,
      clientProfile: "Famille nombreuse",
      clientRequest: "cherche un forfait internet fibre avec débit suffisant pour tous",
      budgetInfo: "Budget 30€ par mois maximum",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Nombre de personnes au foyer ?",
        "Usages simultanés ?",
        "Éligibilité fibre vérifiée ?",
        "TV par internet nécessaire ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Offre Fibre 1Gb/s opérateur local",
          price: "25€/mois",
          advantages: ["Dans budget", "Débit élevé", "Sans engagement"],
          disadvantages: ["Selon éligibilité", "Service client variable"],
          productUrl: "https://www.comparateur-offres.fr",
        ),
      ],
      commonTraps: [
        "Débit théorique vs réel",
        "Engagement ou non"
      ],
      skillsWorked: [
        "Forfaits internet",
        "Besoins famille"
      ]
    ),

    // SCÉNARIO 30
    CommercialScenario(
      id: 30,
      clientProfile: "Collectionneur de jeux rétro",
      clientRequest: "veut capturer et enregistrer ses sessions de jeux anciennes consoles",
      budgetInfo: "Budget 200€",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "Quelles consoles ?",
        "Qualité enregistrement souhaitée ?",
        "Streaming ou juste enregistrement ?",
        "PC déjà suffisamment puissant ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Elgato HD60 S",
          price: "180€",
          advantages: ["1080p 60fps", "Faible latence", "Logiciel inclus"],
          disadvantages: ["Pas 4K", "Anciennes consoles = adaptateurs"],
          productUrl: "https://www.elgato.com/fr/fr/p/game-capture-hd60-s",
        ),
      ],
      commonTraps: [
        "Connectiques anciennes consoles",
        "Adaptateurs nécessaires en sus"
      ],
      skillsWorked: [
        "Capture vidéo gaming",
        "Consoles rétro"
      ]
    ),

    // SCÉNARIO 31
    CommercialScenario(
      id: 31,
      clientProfile: "Personne âgée isolée",
      clientRequest: "cherche une solution simple pour faire des visioconférences avec sa famille",
      budgetInfo: "Budget 300€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Équipement actuel ?",
        "Connexion internet disponible ?",
        "Niveau de confort technologie ?",
        "Famille utilise quoi ? WhatsApp, Skype ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Tablette iPad 9 10.2 pouces",
          price: "400€",
          advantages: ["Simple usage", "FaceTime intégré", "Grand écran"],
          disadvantages: ["Dépasse budget", "Écosystème Apple"],
          productUrl: "https://www.apple.com/fr/ipad-10.2/",
        ),
      ],
      commonTraps: [
        "Simplicité cruciale seniors",
        "Formation famille importante"
      ],
      skillsWorked: [
        "Visio seniors",
        "Inclusion numérique"
      ]
    ),

    // SCÉNARIO 32
    CommercialScenario(
      id: 32,
      clientProfile: "Étudiant vivant en résidence",
      clientRequest: "veut une enceinte Bluetooth portable pour écouter de la musique",
      budgetInfo: "Budget 70€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Usage intérieur ou extérieur ?",
        "Autonomie souhaitée ?",
        "Taille/poids important ?",
        "Résistance eau nécessaire ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "JBL Flip 6",
          price: "130€",
          advantages: ["Excellent son", "Étanche IP67", "Autonomie 12h"],
          disadvantages: ["Dépasse largement", "Lourde 550g"],
          productUrl: "https://fr.jbl.com/enceintes-bluetooth/FLIP6.html",
        ),
      ],
      commonTraps: [
        "Budget limité étudiant",
        "Alternatives moins chères"
      ],
      skillsWorked: [
        "Audio portable",
        "Compromis budget/qualité"
      ]
    ),

    // SCÉNARIO 33
    CommercialScenario(
      id: 33,
      clientProfile: "Jeune maman en congé parental",
      clientRequest: "cherche un ordinateur portable pour travailler pendant les siestes de bébé",
      budgetInfo: "Budget limité, à voir ensemble",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "Budget réel maximum ?",
        "Type de travail effectué ?",
        "Logiciels spécifiques ?",
        "Mobilité dans la maison importante ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Chromebook Acer 314",
          price: "350€",
          advantages: ["Léger", "Silencieux", "Autonomie excellente", "Démarrage rapide"],
          disadvantages: ["ChromeOS limité", "Stockage cloud"],
          productUrl: "https://www.acer.com/fr-fr/chromebooks",
        ),
      ],
      commonTraps: [
        "Budget 'limité' très variable",
        "ChromeOS vs Windows selon usage"
      ],
      skillsWorked: [
        "Budget contraint parent",
        "Besoins travail maison"
      ]
    ),


// À ajouter dans lib/data/commercial_scenarios_data.dart après le scénario 33

    // SCÉNARIO 34
    CommercialScenario(
      id: 34,
      clientProfile: "Kinésithérapeute libéral",
      clientRequest: "a besoin d'un logiciel de facturation simple pour son cabinet",
      budgetInfo: "Budget 50€ par mois maximum",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Nombre de patients par mois ?",
        "Gestion rendez-vous nécessaire ?",
        "Télétransmission CPAM importante ?",
        "Stockage données sur combien d'années ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Logiciel Doctolib Pro",
          price: "129€/mois",
          advantages: ["Complet", "Télétransmission", "Prise RDV en ligne"],
          disadvantages: ["Dépasse largement budget", "Engagement"],
          productUrl: "https://pro.doctolib.fr",
        ),
      ],
      commonTraps: [
        "Budget mensuel trop optimiste",
        "Besoins réglementaires métier"
      ],
      skillsWorked: [
        "Logiciels métiers santé",
        "Coût récurrent vs initial"
      ]
    ),

    // SCÉNARIO 35
    CommercialScenario(
      id: 35,
      clientProfile: "Passionné de drone",
      clientRequest: "cherche une carte SD rapide pour filmer en 4K avec son drone",
      budgetInfo: "Budget 60€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Quel modèle de drone ?",
        "Bitrate vidéo 4K ?",
        "Capacité souhaitée ?",
        "Backup des vidéos où ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "SanDisk Extreme Pro microSD 128GB V30",
          price: "50€",
          advantages: ["Vitesse 170MB/s", "V30 certifiée", "Fiable"],
          disadvantages: ["MicroSD = facile à perdre", "Adaptateur nécessaire"],
          productUrl: "https://www.westerndigital.com/fr-fr/products/memory-cards/sandisk-extreme-pro-uhs-i-microsd",
        ),
      ],
      commonTraps: [
        "Classe vitesse selon bitrate",
        "Taille selon autonomie drone"
      ],
      skillsWorked: [
        "Cartes mémoire vidéo 4K",
        "Spécifications drones"
      ]
    ),

    // SCÉNARIO 36
    CommercialScenario(
      id: 36,
      clientProfile: "Propriétaire de food truck",
      clientRequest: "veut une caisse enregistreuse tactile mobile",
      budgetInfo: "Budget 800€ tout compris",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Lecteur carte bancaire inclus ?",
        "Connexion 4G disponible ?",
        "Nombre de produits au catalogue ?",
        "Système de tickets nécessaire ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "iPad + Square Reader + Logiciel",
          price: "400€ + 59€ + abonnement",
          advantages: ["Mobile", "Complet", "Évolutif"],
          disadvantages: ["Abonnement récurrent", "Dépendance réseau"],
          productUrl: "https://squareup.com/fr/fr",
        ),
      ],
      commonTraps: [
        "Coûts cachés abonnements",
        "Commission par transaction"
      ],
      skillsWorked: [
        "Encaissement mobile",
        "Solutions restauration"
      ]
    ),

    // SCÉNARIO 37
    CommercialScenario(
      id: 37,
      clientProfile: "Étudiant en musique",
      clientRequest: "a besoin d'un ordinateur pour composer de la musique électronique",
      budgetInfo: "Budget 900€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Logiciel de MAO prévu ?",
        "Utilisation plugins gourmands ?",
        "Enregistrement audio en parallèle ?",
        "Portable ou fixe préféré ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "PC portable HP Pavilion 15 i7 16GB",
          price: "850€",
          advantages: ["Puissant", "RAM suffisante", "Portable"],
          disadvantages: ["Carte son basique", "Chauffe un peu"],
          productUrl: "https://www.hp.com/fr-fr/shop/list/laptops/pavilion",
        ),
      ],
      commonTraps: [
        "Interface audio souvent en sus",
        "RAM et CPU critiques"
      ],
      skillsWorked: [
        "Informatique musicale",
        "Besoins MAO"
      ]
    ),

    // SCÉNARIO 38
    CommercialScenario(
      id: 38,
      clientProfile: "Couple de globe-trotters",
      clientRequest: "cherche un appareil pour sauvegarder leurs photos de voyage sans ordinateur",
      budgetInfo: "Budget 300€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Volume de photos par voyage ?",
        "Visionnage sur appareil important ?",
        "Sauvegarde carte SD directe ?",
        "Alimentation comment en voyage ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "WD My Passport Wireless Pro 2TB",
          price: "200€",
          advantages: ["Sans PC", "Lecteur SD intégré", "Batterie"],
          disadvantages: ["Vieux modèle", "Lent"],
          productUrl: "https://www.westerndigital.com/fr-fr/products/portable-drives/wd-my-passport-wireless-pro-portable-hard-drive",
        ),
      ],
      commonTraps: [
        "Solutions rares et chères",
        "Alternative cloud selon pays"
      ],
      skillsWorked: [
        "Backup nomade",
        "Solutions voyage"
      ]
    ),

    // SCÉNARIO 39
    CommercialScenario(
      id: 39,
      clientProfile: "Petit restaurant",
      clientRequest: "veut afficher le menu sur un écran à l'entrée",
      budgetInfo: "Budget 500€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Taille d'écran souhaitée ?",
        "Luminosité extérieure ou intérieure ?",
        "Contenu statique ou vidéo ?",
        "Qui mettra à jour le menu ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "TV Samsung 43\" + Raspberry Pi",
          price: "400€ + 60€",
          advantages: ["Grand écran", "Modifiable facilement", "Peu cher"],
          disadvantages: ["Configuration initiale", "Pas robuste pro"],
          productUrl: "https://www.samsung.com/fr/tvs/",
        ),
      ],
      commonTraps: [
        "Luminosité selon emplacement",
        "Mise à jour contenu"
      ],
      skillsWorked: [
        "Affichage dynamique",
        "Solutions restauration"
      ]
    ),

    // SCÉNARIO 40
    CommercialScenario(
      id: 40,
      clientProfile: "Adolescent fan de simulation automobile",
      clientRequest: "veut un volant et des pédales pour jouer sur PC",
      budgetInfo: "Budget 200€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Jeux joués principalement ?",
        "Espace pour installation ?",
        "Support pour fixer le volant ?",
        "Force feedback importante ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Logitech G29",
          price: "250€",
          advantages: ["Force feedback", "Pédales incluses", "Qualité"],
          disadvantages: ["Dépasse budget", "Bruyant"],
          productUrl: "https://www.logitechg.com/fr-fr/products/driving/driving-force-racing-wheel.html",
        ),
      ],
      commonTraps: [
        "Support stable crucial",
        "Compatibilité jeux"
      ],
      skillsWorked: [
        "Périphériques simulation",
        "Gaming spécialisé"
      ]
    ),

    // SCÉNARIO 41
    CommercialScenario(
      id: 41,
      clientProfile: "Traductrice freelance",
      clientRequest: "cherche un second écran portable pour travailler en déplacement",
      budgetInfo: "Budget 250€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Taille ordinateur portable actuel ?",
        "USB-C avec DisplayPort ?",
        "Poids important ?",
        "Protection transport nécessaire ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "ASUS ZenScreen MB16AC 15.6\"",
          price: "220€",
          advantages: ["Léger 800g", "USB-C", "Auto-alimenté"],
          disadvantages: ["Fragile", "1080p seulement"],
          productUrl: "https://www.asus.com/fr/displays-desktops/monitors/zenscreen/zenscreen-mb16ac/",
        ),
      ],
      commonTraps: [
        "Compatibilité USB-C",
        "Fragilité transport"
      ],
      skillsWorked: [
        "Écrans portables",
        "Productivité nomade"
      ]
    ),

    // SCÉNARIO 42
    CommercialScenario(
      id: 42,
      clientProfile: "Agriculteur moderne",
      clientRequest: "a besoin d'une tablette robuste pour gérer son exploitation",
      budgetInfo: "Budget 600€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Usage en extérieur fréquent ?",
        "Logiciels agricoles spécifiques ?",
        "Résistance poussière/eau critique ?",
        "4G intégrée importante ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Samsung Galaxy Tab Active 4 Pro",
          price: "650€",
          advantages: ["IP68", "Stylet inclus", "Batterie amovible"],
          disadvantages: ["Léger dépassement", "Performances moyennes"],
          productUrl: "https://www.samsung.com/fr/tablets/galaxy-tab-active/",
        ),
      ],
      commonTraps: [
        "Robustesse vraiment nécessaire",
        "Compatibilité logiciels métier"
      ],
      skillsWorked: [
        "Matériel durci professionnel",
        "Solutions agriculture"
      ]
    ),

    // SCÉNARIO 43
    CommercialScenario(
      id: 43,
      clientProfile: "Étudiant en architecture d'intérieur",
      clientRequest: "veut une tablette graphique avec écran pour dessiner",
      budgetInfo: "Budget 500€",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "Niveau de dessin ?",
        "Taille écran souhaitée ?",
        "Logiciels déjà possédés ?",
        "Budget flexible si vraiment nécessaire ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "XP-Pen Artist 13.3 Pro",
          price: "300€",
          advantages: ["Écran intégré", "8192 niveaux pression", "Bon rapport qualité-prix"],
          disadvantages: ["Petite taille", "Couleurs moyennes"],
          productUrl: "https://www.xp-pen.fr/product/artist-13-3-pro.html",
        ),
      ],
      commonTraps: [
        "Avec écran vs sans = x5 prix",
        "Taille selon usage pro"
      ],
      skillsWorked: [
        "Tablettes graphiques professionnelles",
        "Dessin numérique avancé"
      ]
    ),

    // SCÉNARIO 44
    CommercialScenario(
      id: 44,
      clientProfile: "Passionné de podcast",
      clientRequest: "cherche un enregistreur portable pour interviews en extérieur",
      budgetInfo: "Budget 300€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Nombre de micros simultanés ?",
        "Autonomie nécessaire ?",
        "Qualité audio souhaitée ?",
        "Montage sur quel logiciel ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Zoom H5",
          price: "280€",
          advantages: ["4 pistes", "Qualité pro", "Autonomie batterie"],
          disadvantages: ["Micros en sus", "Interface petite"],
          productUrl: "https://zoomcorp.com/fr/fr/handheld-recorders/handheld-recorders/h5/",
        ),
      ],
      commonTraps: [
        "Micros externes souvent nécessaires",
        "Format fichiers important"
      ],
      skillsWorked: [
        "Enregistrement audio mobile",
        "Équipement podcast"
      ]
    ),

    // SCÉNARIO 45
    CommercialScenario(
      id: 45,
      clientProfile: "Couple avec bébé",
      clientRequest: "veut un babyphone vidéo connecté pour surveiller la chambre",
      budgetInfo: "Budget 150€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Vision nocturne importante ?",
        "Application smartphone suffisante ?",
        "Portée nécessaire ?",
        "Fonction parler au bébé utile ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Philips Avent SCD843",
          price: "180€",
          advantages: ["Écran parent inclus", "Vision nocturne", "Portée 300m"],
          disadvantages: ["Dépasse légèrement", "Pas WiFi"],
          productUrl: "https://www.philips.fr/c-p/SCD843_26/avent-babyphone-video",
        ),
      ],
      commonTraps: [
        "WiFi vs radio selon préférence",
        "Sécurité connexion importante"
      ],
      skillsWorked: [
        "Surveillance bébé",
        "Conseil jeunes parents"
      ]
    ),

    // SCÉNARIO 46
    CommercialScenario(
      id: 46,
      clientProfile: "Auto-entrepreneur coach",
      clientRequest: "a besoin d'un site web simple pour présenter ses services",
      budgetInfo: "Budget création site pas cher",
      difficulty: DifficultyLevel.hard,
      keyQuestions: [
        "Budget exact ?",
        "Paiement en ligne nécessaire ?",
        "Combien de pages ?",
        "Mise à jour par vous-même ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Abonnement Wix Premium",
          price: "13€/mois",
          advantages: ["Facile", "Sans code", "Templates pros"],
          disadvantages: ["Abonnement à vie", "Limites personnalisation"],
          productUrl: "https://fr.wix.com",
        ),
      ],
      commonTraps: [
        "'Pas cher' très variable",
        "Coût récurrent vs one-shot"
      ],
      skillsWorked: [
        "Présence web entrepreneurs",
        "Solutions no-code"
      ]
    ),

    // SCÉNARIO 47
    CommercialScenario(
      id: 47,
      clientProfile: "Collégien",
      clientRequest: "veut une manette de jeu pour son smartphone",
      budgetInfo: "Budget 50€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Quel smartphone exactement ?",
        "Jeux joués principalement ?",
        "Taille smartphone ?",
        "Bluetooth du téléphone fonctionnel ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Razer Kishi Mobile",
          price: "100€",
          advantages: ["Latence zéro", "Ergonomique", "Compatible cloud gaming"],
          disadvantages: ["Double le budget", "Modèle par téléphone"],
          productUrl: "https://www.razer.com/fr-fr/mobile-controllers/razer-kishi",
        ),
      ],
      commonTraps: [
        "Compatibilité cruciale",
        "Budget serré collégien"
      ],
      skillsWorked: [
        "Gaming mobile",
        "Accessoires smartphone"
      ]
    ),

    // SCÉNARIO 48
    CommercialScenario(
      id: 48,
      clientProfile: "Architecte",
      clientRequest: "cherche une station d'accueil pour connecter plusieurs écrans à son laptop",
      budgetInfo: "Budget 200€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Modèle exact du laptop ?",
        "Combien d'écrans à connecter ?",
        "Résolution des écrans ?",
        "Autres périphériques à brancher ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Dell WD19 Thunderbolt Dock",
          price: "250€",
          advantages: ["90W charge", "Plusieurs écrans", "Nombreux ports"],
          disadvantages: ["Dépasse budget", "Thunderbolt requis"],
          productUrl: "https://www.dell.com/fr-fr/shop/station-d-accueil-dell-wd19-180-w/apd/210-azbm/",
        ),
      ],
      commonTraps: [
        "Compatibilité Thunderbolt/USB-C",
        "Puissance charge laptop"
      ],
      skillsWorked: [
        "Stations accueil",
        "Setup multi-écrans pro"
      ]
    ),

    // SCÉNARIO 49
    CommercialScenario(
      id: 49,
      clientProfile: "Famille connectée",
      clientRequest: "veut un assistant vocal pour contrôler la maison",
      budgetInfo: "Budget 100€",
      difficulty: DifficultyLevel.easy,
      keyQuestions: [
        "Objets connectés déjà installés ?",
        "Écosystème préféré ? Google, Amazon ?",
        "Confidentialité importante ?",
        "Qualité audio pour musique ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Google Nest Audio",
          price: "100€",
          advantages: ["Bon son", "Google Assistant", "Compatible objets connectés"],
          disadvantages: ["Nécessite compte Google", "Données cloud"],
          productUrl: "https://store.google.com/fr/product/nest_audio",
        ),
      ],
      commonTraps: [
        "Écosystème à choisir",
        "Confidentialité à expliquer"
      ],
      skillsWorked: [
        "Domotique débutant",
        "Assistants vocaux"
      ]
    ),

    // SCÉNARIO 50
    CommercialScenario(
      id: 50,
      clientProfile: "Randonneur passionné",
      clientRequest: "cherche une montre GPS robuste pour ses treks en montagne",
      budgetInfo: "Budget 400€",
      difficulty: DifficultyLevel.medium,
      keyQuestions: [
        "Durée des randonnées ?",
        "Cartographie nécessaire ?",
        "Altimètre/boussole importants ?",
        "Autonomie minimale souhaitée ?"
      ],
      solutions: [
        ScenarioSolution(
          productName: "Garmin Instinct 2",
          price: "350€",
          advantages: ["Robuste MIL-STD", "Autonomie 28j", "GPS multi-GNSS"],
          disadvantages: ["Écran monochrome", "Interface basique"],
          productUrl: "https://www.garmin.com/fr-FR/p/760778",
        ),
      ],
      commonTraps: [
        "Autonomie critique montagne",
        "Robustesse vs smartwatch"
      ],
      skillsWorked: [
        "Montres outdoor",
        "GPS randonnée"
      ]
    ),

];

  static List<CommercialScenario> getScenariosByDifficulty(DifficultyLevel difficulty) {
    return scenarios.where((scenario) => scenario.difficulty == difficulty).toList();
  }

  static CommercialScenario? getScenarioById(int id) {
    try {
      return scenarios.firstWhere((scenario) => scenario.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<CommercialScenario> getAllScenarios() {
    return List.from(scenarios);
  }

  static int get totalCount => scenarios.length;
  
  static int getCountByDifficulty(DifficultyLevel difficulty) {
    return scenarios.where((scenario) => scenario.difficulty == difficulty).length;
  }
}
