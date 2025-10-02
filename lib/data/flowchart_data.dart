import 'package:flutter/material.dart';
import '../models/flowchart_models.dart';

class FlowchartData {
  // ORGANIGRAMME 1 : L'ordinateur ne s'allume pas (BLEU)
  static final Map<String, FlowchartStep> noStartupSteps = {
    'start': FlowchartStep(
      id: 'start',
      question: '1 > Vérifier les branchements électriques',
      description: 'Multiprise sur "On" + Switch alimentation PC sur "I" + Câble d\'alimentation correctement branché',
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

  // Liste de tous les organigrammes disponibles
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
    
    // TODO: Ajouter les 3 autres organigrammes hardware
    // - Démarre mais s'éteint ou freeze (VIOLET)
    // - Pas d'affichage (ORANGE)  
    // - Ne boot pas (VERT)
    
    // TODO: Ajouter les organigrammes des autres catégories plus tard
  ];
}