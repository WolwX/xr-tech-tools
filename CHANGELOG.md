XR TECH TOOLS - HISTORIQUE DES VERSIONS
========================================

## Version 1.3.071025 (07/10/2025) - Harmonisation UI et Timer

### ✨ Nouvelles fonctionnalités
- **Harmonisation UI** : Design cohérent entre scénarios commerciaux et fiches de panne
- **Boutons Correction/Abandon** : Ajout sur les scénarios commerciaux (même design que les pannes)
- **Timer intelligent** : Arrêt automatique lors du clic sur "Correction"
- **Sections encadrées** : Ajout de bordures blanches pour améliorer la lisibilité
- **Footer automatique** : Version récupérée automatiquement du pubspec.yaml

### 🔧 Améliorations techniques
- Intégration complète avec GlobalTimerService
- Gestion cohérente des états de timer entre modules
- Amélioration de l'expérience utilisateur avec timer contextuel
- Correction des dépendances Flutter

### 🎨 Améliorations visuelles
- Design uniforme des boutons diagonaux Correction/Abandon
- Positionnement cohérent des éléments UI
- Affichage du temps écoulé dans les fiches de correction
- Sections visuellement délimitées avec bordures blanches

---

INFORMATIONS GÉNÉRALES
----------------------
- Nom du projet : XR Tech Tools
- Technologie : Flutter / Dart
- Version actuelle : v1.3.071025
- Développeurs : XR (Xavier Redondo - humain) & Claude (IA Anthropic)
- Objectif : Boîte à outils professionnelle et pédagogique pour techniciens informatique et apprenants
- Contact : WolwX@hotmail.com
- Dépôt GitHub : https://github.com/WolwX/xr-tech-tools

DOUBLE OBJECTIF
---------------
Pour les Apprenants (IDI, ADRN, TIP) :
- S'entraîner sur des cas pratiques réels
- Développer leurs compétences techniques avec des logigrammes guidés
- Se préparer aux certifications professionnelles
- Réviser les concepts clés

Pour les Professionnels :
- Accéder rapidement à des outils de conversion et calcul
- Consulter des références techniques (BIOS, hardware)
- Utiliser des guides de diagnostic et procédures
- Optimiser leurs interventions quotidiennes

TITRES PROFESSIONNELS VISÉS
----------------------------
- IDI - Installateur Dépanneur en Informatique (RNCP34147)
- ADRN - Agent De Reconditionnement en appareil Numérique (RNCP38718)
- TIP - Technicien Informatique de Proximité (RNCP40799)

ARCHITECTURE DU PROJET
-----------------------
lib/
├── main.dart
├── models/
│   ├── malfunction.dart
│   ├── scenario.dart
│   └── flowchart_models.dart          [NOUVEAU v1.3.011025]
├── services/
│   ├── malfunction_service.dart
│   ├── scenario_service.dart
│   ├── flowchart_service.dart         [NOUVEAU v1.3.011025]
│   └── flowchart_data.dart            [NOUVEAU v1.3.011025]
├── screens/
│   ├── dashboard_screen.dart
│   ├── scenario_screen.dart
│   ├── malfunction_creator_screen.dart
│   ├── malfunction_technician_screen.dart
│   └── interactive_flowchart_screen.dart  [NOUVEAU v1.3.011025]
└── widgets/
    └── app_footer.dart

FONCTIONNALITÉS IMPLÉMENTÉES
-----------------------------

1. Scénarios Commerciaux (COMPLET) - OUTIL PÉDAGOGIQUE
   
   Base de données : 100 scénarios répartis en 3 niveaux
   - Facile : 33 scénarios (⭐)
   - Moyen : 45 scénarios (⭐⭐)
   - Difficile : 22 scénarios (⭐⭐⭐)

   Modes de jeu :
   - Mode Classique : Tirage aléatoire tous niveaux
   - Mode Défi : Chifoumi détermine la difficulté

   Fonctionnalités :
   - Sélection avancée par numéro (1-100) ou difficulté
   - Timer 30 minutes (démarrage/pause/reprise)
   - Correction détaillée (questions clés, solutions, pièges, compétences RNCP)
   - Liens directs vers produits
   - Auto-évaluation (Réussi/À revoir)
   - Statistiques persistantes (SharedPreferences)

2. Mode Créateur de Pannes (COMPLET v1.3.300925)
   
   Base de données : 14 pannes réparties en 3 niveaux
   - Facile : 4 pannes
   - Moyen : 6 pannes
   - Difficile : 4 pannes
   
   Catégories : Hardware, Software, BIOS/UEFI, Network, Printer, Peripheral
   
   Fonctionnalités :
   - Tirage aléatoire ou sélection manuelle (par numéro/difficulté)
   - Instructions détaillées de création de panne
   - Procédures étape par étape
   - Conseils de simulation
   - Statistiques décentralisées (total + par difficulté)

3. Mode Dépanneur (v1.3.300925)
   
   Fonctionnalités :
   - Utilise les 14 pannes du Mode Créateur
   - Affichage symptômes uniquement (vision technicien)
   - Timer 30 minutes avec pause/reprise
   - Sélection avancée (par numéro ou difficulté)
   - Solution complète avec procédure de résolution
   - Auto-évaluation (Réussi/À revoir)
   - Statistiques persistantes par difficulté
   - Mode Défi Chifoumi

4. Logigrammes Interactifs [NOUVEAU v1.3.011025]
   
   Système de diagnostic guidé :
   - Navigation étape par étape avec choix multiples
   - Détection automatique du logigramme pertinent
   - Barre de progression et historique
   - Retour arrière possible à tout moment
   - Résultats contextuels avec codes couleur :
     * Succès (vert) : Solution trouvée
     * Échec (rouge) : Composant défectueux
     * Info (bleu) : Prochaines étapes suggérées
   - Options visuellement distinctes (✓ vert / ✗ rouge)
   
   Logigramme disponible :
   - "L'ordinateur ne s'allume pas" (Hardware - Bleu)
     * 5 étapes de diagnostic guidées
     * Vérifications : électrique, carte mère, CMOS, périphériques
     * Diagnostic composants HS
   
   Architecture :
   - Service centralisé : FlowchartService
   - Détection intelligente par mots-clés
   - Extensible : 13+ logigrammes prévus
   - Intégration dans Mode Dépanneur (bouton visible si disponible)
   
   Logigrammes prévus :
   - Hardware : Freeze/Shutdown (Violet), Pas d'affichage (Orange), Ne boot pas (Vert)
   - Software, BIOS/UEFI, Network, Printer, Peripheral (à définir)

THÈME & DESIGN
--------------
Couleur principale : Bleu (#00B0FF)
Palette logigrammes :
- Bleu (#64B5F6) : Ne s'allume pas
- Violet (#9575CD) : Freeze/Shutdown
- Orange (#FFB74D) : Pas d'affichage
- Vert (#81C784) : Ne boot pas

DÉPENDANCES
-----------
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.x.x
  shared_preferences: ^2.x.x
  package_info_plus: ^8.x.x        [NOUVEAU v1.3.041025]

HISTORIQUE DES VERSIONS
========================

v1.3.061025 (06 Octobre 2025)
------------------------------
🗺️ DÉVELOPPEMENT MASSIF LOGIGRAMMES - 4 Logigrammes Hardware Complets :

- 📚 EXPANSION CONTENU :
  * 4 logigrammes Hardware complets et opérationnels
  * "L'ordinateur ne s'allume pas" - Diagnostic alimentation/carte mère
  * "Pas d'affichage à l'écran" - Résolution problèmes vidéo/moniteur
  * "L'ordinateur ne démarre pas" - Diagnostic boot/démarrage système
  * "Arrêts/redémarrages inattendus" - Analyse stabilité/température
  * Plus de 50 étapes de diagnostic cumulées avec logique conditionnelle complète

- 🎨 INTERFACE PERFECTIONNÉE :
  * Système de sous-titres explicatifs sous chaque option de choix
  * Bouton "Étape précédente" transformé en ElevatedButton avec style visuel renforcé
  * Couleur de fond colorée, bordure épaisse, ombre et coins arrondis
  * Espacement de sécurité augmenté (20px) entre bouton et timer
  * Icônes d'étape et indicateurs visuels améliorés dans l'AppBar

- 🔧 OPTIMISATIONS TECHNIQUES :
  * Layout Wrap implementé dans malfunction_technician_screen.dart pour affichage multi-ligne des boutons logigrammes
  * FlowchartOption model étendu avec champ subtitle optionnel
  * Système de visualisation d'images intégré avec flowchart_image_viewer.dart
  * Mode plein écran pour les images de diagnostic avec gestes de navigation
  * Corrections de texte descriptif standardisé pour cohérence utilisateur

- 🎯 ERGONOMIE AVANCÉE :
  * Boutons logigrammes organisés sur plusieurs lignes avec Wrap (spacing: 8, runSpacing: 8)
  * Texte descriptif harmonisé : "Vérifiez la température du processeur et les ventilateurs"
  * Interface AppBar optimisée avec icône jaune et espacement perfectionné
  * Navigation fluide entre étapes avec historique complet et retour arrière ergonomique

v1.3.041025 (04 Octobre 2025)
------------------------------
✨ Améliorations majeures - Système de Confirmation Timer :
- 🛡️ PROTECTION CONTRE LES TIRAGES ACCIDENTELS
  * Popup de confirmation automatique pour tous les nouveaux tirages
  * Message contextuel : "Vous allez commencer un [type de tirage]"
  * Arrêt automatique du timer en cours après confirmation utilisateur
  * Choix "Continuer" ou "Arrêter le timer" avec interface orange distinctive
  * Protection complète : tirage aléatoire, sélection numéro, difficulté, catégorie, mode Chifoumi

- 🧠 NAVIGATION INTELLIGENTE DEPUIS LE TIMER
  * Double-clic sur timer flottant pour retour direct à la fiche associée
  * Distinction automatique : Navigation timer vs. Nouveau tirage
  * Paramètre `isFromTimerNavigation` pour bypass intelligent des confirmations
  * Navigation fluide sans interruption depuis le timer
  * Préservation complète de l'expérience utilisateur

🔧 Améliorations techniques :
- Service GlobalTimerService enrichi :
  * Nouvelle méthode `showTimerStopConfirmation()` : Dialog de confirmation stylé
  * Nouvelle méthode `handleNewDrawRequest()` : Coordination intelligente des demandes
  * Gestion contextuelle des confirmations avec messages personnalisés
  * Protection robuste contre les interruptions accidentelles

- Écrans MalfunctionTechnicianScreen et CommercialScenarioScreen :
  * Signature modifiée `_selectMalfunctionById()` et `_selectScenarioById()`
  * Paramètre `isFromTimerNavigation` pour discrimination source navigation
  * Logique conditionnelle : Confirmation pour utilisateur, bypass pour timer
  * Cohérence système sur tous les types d'écrans

🎯 Résolution de bugs critiques :
- Bug navigation timer : Élimination des popups inappropriées lors du double-clic timer
- Workflow optimisé : Confirmations uniquement pour les vrais nouveaux tirages
- Experience utilisateur : Navigation timer instantanée et fluide
- Protection intelligente : Sécurité contre les arrêts accidentels préservée

🗺️ Corrections système logigrammes :
- Interface de sélection des logigrammes optimisée
- Suggestions intelligentes basées sur les symptômes améliorées
- Corrections de bugs d'affichage dans les barres de recherche
- Stabilisation de l'intégration avec le système de diagnostic
- Meilleure ergonomie des interfaces d'aide au diagnostic

📱 Expérience utilisateur finale :
- Double niveau de protection et fluidité
- Confirmations pertinentes pour actions utilisateur
- Navigation directe et instantanée depuis timer
- Workflow préservé pour toutes les fonctionnalités
- Système intelligent qui respecte l'intention utilisateur

🔧 Améliorations techniques additionnelles :
- Widget AppFooter automatisé : Version récupérée dynamiquement depuis pubspec.yaml
- Ajout dépendance `package_info_plus: ^8.0.0` pour gestion automatique version
- Élimination du hardcoding de version dans le footer
- Système de fallback en cas d'erreur de lecture version

✅ Validation complète :
- Compilation : 0 erreur (135 warnings style uniquement)
- Tests fonctionnels : Navigation et confirmations opérationnelles
- Cohérence : Comportement uniforme sur tous les écrans
- Performance : Système optimisé et réactif

v1.3.031025 (03 Octobre 2025)
------------------------------
✨ Améliorations majeures :
- ⏱️ SYSTÈME DE TIMER FLOTTANT AUTOMATIQUE
  * Apparition automatique lors de la sélection de fiches de dépannage
  * Texte dynamique intelligent : "Démarrer le dépannage X min" → Compte à rebours
  * Interface épurée : Suppression des doublons de timer
  * Temps configurable pour différentes durées d'épreuves futures
  * Bouton reset : Réinitialise sans fermer le timer (icône 🔄)
  * Intégration complète : Fonctionne dans tous les contextes

🔧 Corrections techniques :
- Suppression du timer local dans InteractiveFlowchartScreen
- Élimination des widgets redondants (_buildCompactTimerWidget)
- Optimisation de l'espace réservé aux timers (80px → 24px)
- Correction des problèmes de lifecycle des listeners
- Interface unifiée pour une expérience utilisateur cohérente

🎯 Déclencheurs automatiques du timer :
- Tirage aléatoire de fiche (_drawRandomMalfunction)
- Sélection par ID (_selectMalfunctionById)
- Sélection par difficulté (_selectMalfunctionByDifficulty)  
- Sélection par catégorie (_selectMalfunctionByCategory)
- Résultats de chifoumi (victoire/défaite/égalité)

📱 Expérience utilisateur améliorée :
- Plus de confusion avec les doubles timers
- Navigation fluide entre fiches principales et organigrammes
- Timer global persistant et cohérent
- Performance optimisée (moins de widgets)

v1.3.011025 (01 Octobre 2025)
------------------------------
✨ Nouveautés majeures :
- 🗺️ SYSTÈME DE LOGIGRAMMES INTERACTIFS
  * Navigation guidée étape par étape pour diagnostic pannes
  * Détection automatique du logigramme pertinent
  * Interface interactive avec choix multiples
  * Barre de progression et historique de navigation
  * Retour arrière possible à tout moment
  * Résultats contextuels (Succès/Échec/Info) avec codes couleur
  * Options visuellement distinctes (✓ vert / ✗ rouge)

- 📊 Premier logigramme : "L'ordinateur ne s'allume pas"
  * 5 étapes de diagnostic guidées
  * Vérification branchements électriques
  * Contrôle alimentation carte mère
  * Vérification CMOS
  * Tests périphériques
  * Diagnostic composants HS

🔧 Technique :
- Nouveaux modèles : FlowchartInfo, FlowchartStep, FlowchartOption
- Service centralisé : FlowchartService
- Données structurées : FlowchartData
- Interface dédiée : InteractiveFlowchartScreen
- Détection intelligente par mots-clés et catégorie
- Architecture extensible pour 13+ logigrammes futurs

🎨 Intégration UX :
- Bouton "Logigramme HARDWARE" dans Mode Dépanneur
- Visible uniquement si logigramme disponible pour la catégorie
- Suggestion automatique du logigramme le plus adapté
- Sélection manuelle si plusieurs logigrammes disponibles
- Message informatif si non disponible

📁 Fichiers ajoutés :
- lib/models/flowchart_models.dart
- lib/services/flowchart_service.dart
- lib/services/flowchart_data.dart
- lib/screens/interactive_flowchart_screen.dart

📝 Fichiers modifiés :
- lib/screens/malfunction_technician_screen.dart (intégration logigrammes)

v1.3.300925 (30 Septembre 2025)
--------------------------------
✨ Améliorations Mode Créateur de Pannes :
- Sélection avancée par numéro de panne
- Sélection par difficulté (3 boutons dédiés)
- Statistiques décentralisées :
  * Total de pannes tirées
  * Compteurs par difficulté
  * Persistance avec SharedPreferences
  * Affichage permanent en bas de l'écran

✨ Améliorations Scénarios Commerciaux :
- Sélection avancée par numéro (1-100)
- Sélection par difficulté (3 boutons compacts)
- Interface plus intuitive
- Validation avec messages d'erreur clairs

🐛 Corrections :
- Gestion des erreurs améliorée
- Optimisation affichage statistiques

v1.2.0 (Janvier 2025)
---------------------
✨ Nouvelles fonctionnalités :
- 100 scénarios commerciaux complets (50 nouveaux)
- ✅ Fonctionnalité "Scénarios Commercial" terminée
- Conformité référentiels RNCP (IDI, ADRN, TIP)

🎨 Améliorations UX/UI :
- Page d'accueil aérée
- Page Chifoumi réorganisée
- Meilleure hiérarchie visuelle

🛠️ Corrections :
- Cohérence avec les trois référentiels RNCP
- Focus sur compétences transversales

v1.1.0 (Janvier 2025)
---------------------
✨ Nouvelles fonctionnalités :
- Persistance statistiques (SharedPreferences)
- Sauvegarde scores Chifoumi
- Conservation réussites par difficulté

🎨 Améliorations UX/UI :
- Affichage "X / Y" (réussites/essais)
- Code couleur par niveau
- Séparation stats globales/personnelles

v1.0.0 (Septembre 2025)
-----------------------
🎉 Version initiale :
- Application Flutter fonctionnelle
- 50 scénarios commerciaux
- Mode classique et mode défi
- Timer 30 minutes
- Correction détaillée
- Signalement anomalies

NOTES DE DÉVELOPPEMENT
-----------------------

Logigrammes - Bonnes pratiques :
- Un logigramme = un parcours de diagnostic complet
- Étapes logiques et progressives
- Options claires et distinctes visuellement
- Messages de résolution contextuels
- Facilement extensible (ajout dans flowchart_data.dart)

Architecture décentralisée :
- Chaque écran gère ses propres statistiques
- Utilisation de SharedPreferences
- Pas de state management global
- Autonomie et maintenabilité

Améliorations suggérées :
- Développer les 13+ logigrammes restants
- Compléter la Boîte à Outils (9 outils restants)
- Historique des scénarios/pannes
- Mode révision ciblée
- Export/import statistiques
- Thème sombre
- Badges de progression

CONTACT & SUPPORT
-----------------
Email : WolwX@hotmail.com
GitHub : https://github.com/WolwX/xr-tech-tools

==============================================
COMMENT UTILISER CE DOCUMENT
==============================================

Pour reprendre le projet avec Claude :
1. Partager ce fichier en début de conversation
2. Préciser la fonctionnalité à développer/corriger
3. Mentionner le(s) titre(s) RNCP concerné(s) si pertinent

Exemples :
"Voici le CHANGELOG. Je veux développer le logigramme 
'Pas d'affichage' pour les pannes hardware."

"Voici le CHANGELOG. Je veux créer des logigrammes 
pour la catégorie Software (pannes logicielles)."

==============================================
FIN DU DOCUMENT - Version 1.3.011025
==============================================