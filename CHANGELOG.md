XR TECH TOOLS - HISTORIQUE DES VERSIONS
========================================

INFORMATIONS GÉNÉRALES
----------------------
- Nom du projet : XR Tech Tools
- Technologie : Flutter / Dart
- Version actuelle : v1.3.011025
- Développeurs : XR (Xavier Redondo - humain) & Claude (IA Anthropic)
- Objectif : Boîte à outils professionnelle et pédagogique pour techniciens informatique et apprenants
- Contact : WolwX@hotmail.com
- Dépôt GitHub : https://github.com/WolwX/xr-tech-tools

DOUBLE OBJECTIF
---------------
Pour les Apprenants (IDI, ADRN, TIP) :
- S'entraîner sur des cas pratiques réels
- Développer leurs compétences techniques avec des organigrammes guidés
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

4. Organigrammes Interactifs [NOUVEAU v1.3.011025]
   
   Système de diagnostic guidé :
   - Navigation étape par étape avec choix multiples
   - Détection automatique de l'organigramme pertinent
   - Barre de progression et historique
   - Retour arrière possible à tout moment
   - Résultats contextuels avec codes couleur :
     * Succès (vert) : Solution trouvée
     * Échec (rouge) : Composant défectueux
     * Info (bleu) : Prochaines étapes suggérées
   - Options visuellement distinctes (✓ vert / ✗ rouge)
   
   Organigramme disponible :
   - "L'ordinateur ne s'allume pas" (Hardware - Bleu)
     * 5 étapes de diagnostic guidées
     * Vérifications : électrique, carte mère, CMOS, périphériques
     * Diagnostic composants HS
   
   Architecture :
   - Service centralisé : FlowchartService
   - Détection intelligente par mots-clés
   - Extensible : 13+ organigrammes prévus
   - Intégration dans Mode Dépanneur (bouton visible si disponible)
   
   Organigrammes prévus :
   - Hardware : Freeze/Shutdown (Violet), Pas d'affichage (Orange), Ne boot pas (Vert)
   - Software, BIOS/UEFI, Network, Printer, Peripheral (à définir)

THÈME & DESIGN
--------------
Couleur principale : Bleu (#00B0FF)
Palette organigrammes :
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

HISTORIQUE DES VERSIONS
========================

v1.3.011025 (01 Octobre 2025)
------------------------------
✨ Nouveautés majeures :
- 🗺️ SYSTÈME D'ORGANIGRAMMES INTERACTIFS
  * Navigation guidée étape par étape pour diagnostic pannes
  * Détection automatique de l'organigramme pertinent
  * Interface interactive avec choix multiples
  * Barre de progression et historique de navigation
  * Retour arrière possible à tout moment
  * Résultats contextuels (Succès/Échec/Info) avec codes couleur
  * Options visuellement distinctes (✓ vert / ✗ rouge)

- 📊 Premier organigramme : "L'ordinateur ne s'allume pas"
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
- Architecture extensible pour 13+ organigrammes futurs

🎨 Intégration UX :
- Bouton "Organigramme HARDWARE" dans Mode Dépanneur
- Visible uniquement si organigramme disponible pour la catégorie
- Suggestion automatique de l'organigramme le plus adapté
- Sélection manuelle si plusieurs organigrammes disponibles
- Message informatif si non disponible

📁 Fichiers ajoutés :
- lib/models/flowchart_models.dart
- lib/services/flowchart_service.dart
- lib/services/flowchart_data.dart
- lib/screens/interactive_flowchart_screen.dart

📝 Fichiers modifiés :
- lib/screens/malfunction_technician_screen.dart (intégration organigrammes)

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

Organigrammes - Bonnes pratiques :
- Un organigramme = un parcours de diagnostic complet
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
- Développer les 13+ organigrammes restants
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
"Voici le CHANGELOG. Je veux développer l'organigramme 
'Pas d'affichage' pour les pannes hardware."

"Voici le CHANGELOG. Je veux créer des organigrammes 
pour la catégorie Software (pannes logicielles)."

==============================================
FIN DU DOCUMENT - Version 1.3.011025
==============================================