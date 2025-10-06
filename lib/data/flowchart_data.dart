import 'package:flutter/material.dart';
import '../models/flowchart_models.dart';

class FlowchartData {
  // LOGIGRAMME 1 : L'ordinateur ne s'allume pas (BLEU)
  static final Map<String, FlowchartStep> noStartupSteps = {
    'start': FlowchartStep(
      id: 'start',
      question: '1 > Vérifier les branchements électriques',
      description: 'Procéder aux vérifications pour progresser dans les étapes de diagnostic.\nCliquer, ci dessous, sur l\'option qui correspond le mieux à vos vérifications.',
      icon: Icons.power,
      options: [
        FlowchartOption(
          label: '✓ Tous les branchements sont OK',
          nextStepId: 'check_motherboard',
        ),
        FlowchartOption(
          label: '✗ Multiprise éteinte ou défectueuse',
          resultMessage: 'Solution : Allumez la multiprise ou testez avec une autre multiprise.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Switch alimentation PC sur "O"',
          resultMessage: 'Solution : Basculez le switch de l\'alimentation sur la position "I".',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Câble d\'alimentation défectueux',
          resultMessage: 'Solution : Remplacez le câble d\'alimentation par un câble fonctionnel.',
          resultType: ResultType.success,
        ),
      ],
    ),
    
    'check_motherboard': FlowchartStep(
      id: 'check_motherboard',
      question: '2 > Vérifier l\'alimentation de la carte mère',
      description: 'Présence LED sur CM + Branchement alimentation CM (24 broches + 4/8 broches CPU)',
      icon: Icons.lightbulb_outline,
      options: [
        FlowchartOption(
          label: '✓ LED présente et branchements corrects',
          nextStepId: 'check_cmos',
        ),
        FlowchartOption(
          label: '✗ Pas de LED sur la carte mère',
          resultMessage: 'Problème d\'alimentation détecté. Vérifiez les branchements 24 broches et 4/8 broches CPU. Si les branchements sont corrects, testez avec une autre alimentation.',
          resultType: ResultType.failure,
        ),
        FlowchartOption(
          label: '✗ Branchements mal connectés',
          resultMessage: 'Solution : Reconnectez correctement les câbles d\'alimentation (24 broches principal + 4/8 broches CPU).',
          resultType: ResultType.success,
        ),
      ],
    ),
    
    'check_cmos': FlowchartStep(
      id: 'check_cmos',
      question: '3 > Vérification CMOS',
      description: 'Pile CMOS au dessus de 3V + Position cavalier reset CMOS + Réglages BIOS corrects',
      icon: Icons.battery_charging_full,
      options: [
        FlowchartOption(
          label: '✓ CMOS OK (pile > 3V, pas de reset actif)',
          nextStepId: 'check_peripherals',
        ),
        FlowchartOption(
          label: '✗ Pile CMOS faible (< 3V)',
          resultMessage: 'Solution : Remplacez la pile CMOS (pile bouton CR2032 généralement). Attendez quelques minutes après installation.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Cavalier reset CMOS mal positionné',
          resultMessage: 'Solution : Vérifiez que le cavalier (jumper) est sur la position normale et non sur la position "Clear CMOS".',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Réglages BIOS incorrects',
          resultMessage: 'Solution : Réinitialisez le BIOS en retirant la pile pendant 5 minutes ou en utilisant le bouton "Clear CMOS" si disponible.',
          resultType: ResultType.success,
        ),
      ],
    ),
    
    'check_peripherals': FlowchartStep(
      id: 'check_peripherals',
      question: '4 > Autres vérifications',
      description: 'Périphériques débranchés + Bouton Power On fonctionnel + Frontpanel bien connecté',
      icon: Icons.devices,
      options: [
        FlowchartOption(
          label: '✓ Tout vérifié, toujours pas d\'allumage',
          nextStepId: 'hardware_failure',
        ),
        FlowchartOption(
          label: '✗ Problème avec un périphérique (HDD, lecteur, etc)',
          resultMessage: 'Solution : Un périphérique défectueux empêche le démarrage. Débranchez-les un par un pour identifier le coupable.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Bouton Power On ou frontpanel défectueux',
          resultMessage: 'Solution : Testez en court-circuitant directement les pins Power sur la carte mère. Si ça démarre, le bouton ou le câble du frontpanel est défectueux.',
          resultType: ResultType.success,
        ),
      ],
    ),
    
    'hardware_failure': FlowchartStep(
      id: 'hardware_failure',
      question: '5 > Composant(s) possiblement HS',
      description: 'Test approfondi nécessaire avec matériel de test',
      icon: Icons.build_circle,
      options: [
        FlowchartOption(
          label: 'Tester l\'alimentation',
          resultMessage: 'Testez l\'alimentation avec un testeur d\'alimentation ou remplacez-la temporairement par une alimentation fonctionnelle connue.',
          resultType: ResultType.info,
        ),
        FlowchartOption(
          label: 'Tester la carte mère',
          resultMessage: 'La carte mère est probablement défectueuse. Effectuez un test croisé avec d\'autres composants (CPU, RAM) pour confirmer. Remplacement de la CM nécessaire.',
          resultType: ResultType.failure,
        ),
      ],
    ),
  };

  // LOGIGRAMME 2 : Pas d'affichage (ORANGE)
  static final Map<String, FlowchartStep> noDisplaySteps = {
    'start': FlowchartStep(
      id: 'start',
      question: '1 > Vérifier les branchements vidéo',
      description: 'Procéder aux vérifications pour progresser dans les étapes de diagnostic.\nCliquer, ci dessous, sur l\'option qui correspond le mieux à vos vérifications.',
      icon: Icons.monitor,
      options: [
        FlowchartOption(
          label: '✓ Câbles et connexions OK',
          nextStepId: 'check_monitor',
        ),
        FlowchartOption(
          label: '✗ Câble vidéo débranché ou défectueux',
          resultMessage: 'Solution : Rebranchez fermement le câble vidéo ou remplacez-le par un câble fonctionnel.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Mauvaise sortie vidéo utilisée',
          resultMessage: 'Solution : Connectez l\'écran sur la sortie vidéo de la carte graphique dédiée si présente, sinon sur la carte mère.',
          resultType: ResultType.success,
        ),
      ],
    ),
    'check_monitor': FlowchartStep(
      id: 'check_monitor',
      question: '2 > Tester le moniteur',
      description: 'Vérifier le fonctionnement du moniteur avec un autre équipement',
      icon: Icons.desktop_windows,
      options: [
        FlowchartOption(
          label: '✓ Moniteur fonctionne avec autre PC',
          nextStepId: 'check_graphics',
        ),
        FlowchartOption(
          label: '✗ Moniteur ne fonctionne pas',
          resultMessage: 'Le moniteur est défectueux. Remplacez-le ou faites-le réparer.',
          resultType: ResultType.failure,
        ),
      ],
    ),
    'check_graphics': FlowchartStep(
      id: 'check_graphics',
      question: '3 > Vérifier la carte graphique',
      description: 'Contrôler la carte graphique et ses connexions',
      icon: Icons.videogame_asset,
      options: [
        FlowchartOption(
          label: '✓ Carte graphique bien installée',
          nextStepId: 'check_ram_display',
        ),
        FlowchartOption(
          label: '✗ Carte graphique mal installée',
          resultMessage: 'Solution : Réinstallez la carte graphique dans son slot PCIe et vérifiez les connexions d\'alimentation.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Pas de carte graphique dédiée',
          nextStepId: 'check_integrated_graphics',
        ),
      ],
    ),
    'check_integrated_graphics': FlowchartStep(
      id: 'check_integrated_graphics',
      question: '4 > Vérifier graphiques intégrés',
      description: 'Tester les graphiques intégrés du processeur',
      icon: Icons.memory,
      options: [
        FlowchartOption(
          label: '✓ CPU avec graphiques intégrés',
          nextStepId: 'check_ram_display',
        ),
        FlowchartOption(
          label: '✗ CPU sans graphiques intégrés',
          resultMessage: 'Une carte graphique dédiée est nécessaire. Installez une carte graphique compatible.',
          resultType: ResultType.info,
        ),
      ],
    ),
    'check_ram_display': FlowchartStep(
      id: 'check_ram_display',
      question: '5 > Tester la mémoire RAM',
      description: 'Vérifier si la RAM cause le problème d\'affichage',
      icon: Icons.storage,
      options: [
        FlowchartOption(
          label: '✓ Affichage OK avec RAM minimum',
          resultMessage: 'Une barrette de RAM était défectueuse. Identifiez et remplacez la barrette défaillante.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Toujours pas d\'affichage',
          nextStepId: 'hardware_failure_display',
        ),
      ],
    ),
    'hardware_failure_display': FlowchartStep(
      id: 'hardware_failure_display',
      question: '6 > Composant défaillant identifié',
      description: 'Test final pour déterminer le composant en cause',
      icon: Icons.build_circle,
      options: [
        FlowchartOption(
          label: 'Tester avec autre carte graphique',
          resultMessage: 'Testez avec une carte graphique fonctionnelle. Si l\'affichage revient, la carte graphique originale est défectueuse.',
          resultType: ResultType.info,
        ),
        FlowchartOption(
          label: 'Problème carte mère/CPU',
          resultMessage: 'La carte mère ou le CPU est probablement défectueux. Test croisé nécessaire pour identifier le composant exact.',
          resultType: ResultType.failure,
        ),
      ],
    ),
  };

  // LOGIGRAMME 3 : Ne boot pas (VERT)
  static final Map<String, FlowchartStep> noBootSteps = {
    'start': FlowchartStep(
      id: 'start',
      question: '1 > Vérifier l\'ordre de boot',
      description: 'Procéder aux vérifications pour progresser dans les étapes de diagnostic.\nCliquer, ci dessous, sur l\'option qui correspond le mieux à vos vérifications.',
      icon: Icons.settings,
      options: [
        FlowchartOption(
          label: '✓ Ordre de boot correct',
          nextStepId: 'check_storage',
        ),
        FlowchartOption(
          label: '✗ Mauvais ordre de boot',
          resultMessage: 'Solution : Modifiez l\'ordre de boot dans le BIOS/UEFI pour démarrer sur le bon disque.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Périphérique USB en premier',
          resultMessage: 'Solution : Retirez les périphériques USB ou modifiez l\'ordre de boot pour prioriser le disque dur.',
          resultType: ResultType.success,
        ),
      ],
    ),
    'check_storage': FlowchartStep(
      id: 'check_storage',
      question: '2 > Vérifier le stockage',
      description: 'Contrôler l\'état du disque dur ou SSD',
      icon: Icons.storage,
      options: [
        FlowchartOption(
          label: '✓ Disque détecté dans le BIOS',
          nextStepId: 'check_boot_sector',
        ),
        FlowchartOption(
          label: '✗ Disque non détecté',
          nextStepId: 'check_storage_connection',
        ),
      ],
    ),
    'check_storage_connection': FlowchartStep(
      id: 'check_storage_connection',
      question: '3 > Vérifier connexions du stockage',
      description: 'Contrôler les câbles SATA et l\'alimentation',
      icon: Icons.cable,
      options: [
        FlowchartOption(
          label: '✓ Connexions refaites, disque détecté',
          nextStepId: 'check_boot_sector',
        ),
        FlowchartOption(
          label: '✗ Disque toujours non détecté',
          resultMessage: 'Le disque dur/SSD est probablement défectueux. Testez avec un autre disque ou remplacez-le.',
          resultType: ResultType.failure,
        ),
      ],
    ),
    'check_boot_sector': FlowchartStep(
      id: 'check_boot_sector',
      question: '4 > Analyser le secteur de boot',
      description: 'Vérifier l\'intégrité du secteur de démarrage',
      icon: Icons.track_changes,
      options: [
        FlowchartOption(
          label: '✓ Boot sector OK, OS démarre',
          resultMessage: 'Le problème était temporaire ou lié à l\'ordre de boot. Système opérationnel.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Erreur "Boot device not found"',
          nextStepId: 'repair_boot',
        ),
        FlowchartOption(
          label: '✗ Erreur "Operating system not found"',
          nextStepId: 'repair_boot',
        ),
      ],
    ),
    'repair_boot': FlowchartStep(
      id: 'repair_boot',
      question: '5 > Réparation du boot',
      description: 'Options de réparation du système de démarrage',
      icon: Icons.build,
      options: [
        FlowchartOption(
          label: 'Réparation automatique Windows',
          resultMessage: 'Utilisez un disque de récupération Windows ou l\'option "Réparer l\'ordinateur" pour restaurer le secteur de boot.',
          resultType: ResultType.info,
        ),
        FlowchartOption(
          label: 'Reconstruction MBR/GPT',
          resultMessage: 'Utilisez les commandes bootrec /fixmbr, /fixboot, /rebuildbcd ou des outils comme GParted pour réparer la table de partition.',
          resultType: ResultType.info,
        ),
        FlowchartOption(
          label: 'Réinstallation OS nécessaire',
          resultMessage: 'Si les réparations échouent, une réinstallation complète du système d\'exploitation est nécessaire.',
          resultType: ResultType.failure,
        ),
      ],
    ),
  };

  // LOGIGRAMME 4 : S'éteint ou freeze (VIOLET)
  static final Map<String, FlowchartStep> shutdownFreezeSteps = {
    'start': FlowchartStep(
      id: 'start',
      question: '1 > Identifier le moment du problème',
      description: 'Procéder aux vérifications pour progresser dans les étapes de diagnostic.\nCliquer, ci dessous, sur l\'option qui correspond le mieux à vos vérifications.',
      icon: Icons.timer,
      options: [
        FlowchartOption(
          label: '✓ Problème à l\'usage intense',
          nextStepId: 'check_temperature',
        ),
        FlowchartOption(
          label: '✓ Problème dès le démarrage',
          nextStepId: 'check_power_supply',
        ),
        FlowchartOption(
          label: '✓ Problème aléatoire',
          nextStepId: 'check_ram_stability',
        ),
      ],
    ),
    'check_temperature': FlowchartStep(
      id: 'check_temperature',
      question: '2 > Vérifier les températures',
      description: 'Contrôler la température des composants',
      icon: Icons.thermostat,
      options: [
        FlowchartOption(
          label: '✓ Températures normales (<70°C)',
          nextStepId: 'check_power_under_load',
        ),
        FlowchartOption(
          label: '✗ CPU trop chaud (>80°C)',
          nextStepId: 'fix_cpu_cooling',
        ),
        FlowchartOption(
          label: '✗ GPU trop chaud (>85°C)',
          nextStepId: 'fix_gpu_cooling',
        ),
      ],
    ),
    'fix_cpu_cooling': FlowchartStep(
      id: 'fix_cpu_cooling',
      question: '3 > Résoudre surchauffe CPU',
      description: 'Actions pour réduire la température du processeur',
      icon: Icons.ac_unit,
      options: [
        FlowchartOption(
          label: 'Nettoyer le ventirad',
          resultMessage: 'Nettoyez le ventirad CPU avec de l\'air comprimé et vérifiez que le ventilateur fonctionne correctement.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: 'Changer la pâte thermique',
          resultMessage: 'Remplacez la pâte thermique entre le CPU et le ventirad. Utilisez une pâte de qualité et appliquez une fine couche.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: 'Ventirad défaillant',
          resultMessage: 'Le système de refroidissement CPU est insuffisant ou défaillant. Remplacez par un ventirad plus performant.',
          resultType: ResultType.failure,
        ),
      ],
    ),
    'fix_gpu_cooling': FlowchartStep(
      id: 'fix_gpu_cooling',
      question: '3 > Résoudre surchauffe GPU',
      description: 'Actions pour réduire la température de la carte graphique',
      icon: Icons.videogame_asset,
      options: [
        FlowchartOption(
          label: 'Nettoyer la carte graphique',
          resultMessage: 'Nettoyez les ventilateurs et le radiateur de la carte graphique avec de l\'air comprimé.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: 'Améliorer ventilation boîtier',
          resultMessage: 'Ajoutez des ventilateurs d\'extraction ou améliorez le flux d\'air dans le boîtier.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: 'Carte graphique défaillante',
          resultMessage: 'Le système de refroidissement de la carte graphique est défaillant. Remplacement nécessaire.',
          resultType: ResultType.failure,
        ),
      ],
    ),
    'check_power_supply': FlowchartStep(
      id: 'check_power_supply',
      question: '2 > Tester l\'alimentation',
      description: 'Vérifier la stabilité de l\'alimentation électrique',
      icon: Icons.power,
      options: [
        FlowchartOption(
          label: '✓ Alimentation stable',
          nextStepId: 'check_ram_stability',
        ),
        FlowchartOption(
          label: '✗ Alimentation insuffisante',
          resultMessage: 'L\'alimentation n\'a pas assez de puissance pour les composants. Remplacez par une alimentation de wattage supérieur.',
          resultType: ResultType.failure,
        ),
        FlowchartOption(
          label: '✗ Alimentation instable',
          resultMessage: 'L\'alimentation délivre des tensions instables. Remplacez l\'alimentation défectueuse.',
          resultType: ResultType.failure,
        ),
      ],
    ),
    'check_power_under_load': FlowchartStep(
      id: 'check_power_under_load',
      question: '3 > Tester sous charge',
      description: 'Vérifier la stabilité sous forte sollicitation',
      icon: Icons.speed,
      options: [
        FlowchartOption(
          label: '✓ Stable sous charge légère',
          nextStepId: 'check_power_supply',
        ),
        FlowchartOption(
          label: '✗ Instable sous charge',
          nextStepId: 'check_power_supply',
        ),
      ],
    ),
    'check_ram_stability': FlowchartStep(
      id: 'check_ram_stability',
      question: '2 > Tester la stabilité RAM',
      description: 'Vérifier l\'intégrité de la mémoire vive',
      icon: Icons.storage,
      options: [
        FlowchartOption(
          label: '✓ RAM OK (test MemTest86)',
          nextStepId: 'check_software_conflicts',
        ),
        FlowchartOption(
          label: '✗ Erreurs RAM détectées',
          resultMessage: 'La mémoire RAM est défectueuse. Identifiez et remplacez la(les) barrette(s) défaillante(s).',
          resultType: ResultType.failure,
        ),
      ],
    ),
    'check_software_conflicts': FlowchartStep(
      id: 'check_software_conflicts',
      question: '3 > Vérifier conflits logiciels',
      description: 'Identifier les problèmes logiciels causant l\'instabilité',
      icon: Icons.bug_report,
      options: [
        FlowchartOption(
          label: '✓ Stable en mode sans échec',
          resultMessage: 'Le problème est logiciel. Désinstallez les programmes récents, mettez à jour les pilotes ou restaurez le système.',
          resultType: ResultType.success,
        ),
        FlowchartOption(
          label: '✗ Instable même en mode sans échec',
          nextStepId: 'hardware_diagnosis',
        ),
      ],
    ),
    'hardware_diagnosis': FlowchartStep(
      id: 'hardware_diagnosis',
      question: '4 > Diagnostic matériel approfondi',
      description: 'Tests finaux pour identifier le composant défaillant',
      icon: Icons.build_circle,
      options: [
        FlowchartOption(
          label: 'Tester composants un par un',
          resultMessage: 'Effectuez des tests croisés en remplaçant temporairement chaque composant (RAM, GPU, CPU) pour identifier le défaillant.',
          resultType: ResultType.info,
        ),
        FlowchartOption(
          label: 'Problème carte mère',
          resultMessage: 'Si tous les autres composants sont OK, la carte mère est probablement défectueuse. Remplacement nécessaire.',
          resultType: ResultType.failure,
        ),
      ],
    ),
  };

  // Liste de tous les logigrammes disponibles
  static final List<FlowchartInfo> allFlowcharts = [
    // HARDWARE - L'ordinateur ne s'allume pas
    FlowchartInfo(
      id: 'hw_no_startup',
      category: FlowchartCategory.hardware,
      title: 'L\'ordinateur ne s\'allume pas',
      color: const Color(0xFF64B5F6), // Bleu
      keywords: [
        'ne s\'allume pas',
        'pas de led',
        'pas d\'alimentation',
        'multiprise',
        'cmos',
        'pile',
        'power',
        'démarrage',
      ],
      steps: noStartupSteps,
    ),
    
    // LOGIGRAMME 2 : Pas d'affichage (ORANGE)
    FlowchartInfo(
      id: 'no_display',
      title: 'Pas d\'affichage',
      color: Colors.orange,
      category: FlowchartCategory.hardware,
      imagePath: 'assets/images/logigrammes/logigramme-depannage-hardware-p2-pas-daffichage.jpg',
      keywords: [
        'affichage',
        'écran noir',
        'moniteur',
        'carte graphique',
        'câble vidéo',
        'ram',
        'signal',
      ],
      steps: noDisplaySteps,
    ),
    
    // LOGIGRAMME 3 : Ne boot pas (VERT)
    FlowchartInfo(
      id: 'no_boot',
      title: 'Ne boot pas',
      color: Colors.green,
      category: FlowchartCategory.hardware,
      imagePath: 'assets/images/logigrammes/logigramme-depannage-hardware-p3-ne-boot-pas.jpg',
      keywords: [
        'boot',
        'démarrage',
        'bios',
        'disque dur',
        'système',
        'mbr',
        'os',
      ],
      steps: noBootSteps,
    ),
    
    // LOGIGRAMME 4 : S'éteint ou freeze (VIOLET)
    FlowchartInfo(
      id: 'shutdown_freeze',
      title: 'S\'éteint ou freeze',
      color: Colors.purple,
      category: FlowchartCategory.hardware,
      imagePath: 'assets/images/logigrammes/logigramme-depannage-hardware-p4-seteint-ou-freeze.jpg',
      keywords: [
        'extinction',
        'freeze',
        'surchauffe',
        'alimentation',
        'ventilateur',
        'température',
        'instabilité',
      ],
      steps: shutdownFreezeSteps,
    ),
    
    // TODO: Ajouter les logigrammes des autres catégories plus tard
  ];
}