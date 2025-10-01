XR TECH TOOLS - HISTORIQUE DES VERSIONS
========================================

INFORMATIONS GÉNÉRALES
----------------------
- Nom du projet : XR Tech Tools
- Technologie : Flutter / Dart
- Version actuelle : v1.3.300925
- Développeurs : XR (Xavier Redondo - humain) & Claude (IA Anthropic)
- Objectif : Boîte à outils professionnelle et pédagogique pour techniciens informatique et apprenants
- Contact : WolwX@hotmail.com
- Dépôt GitHub : https://github.com/WolwX/xr-tech-tools

DOUBLE OBJECTIF
---------------
Pour les Apprenants (IDI, ADRN, TIP) :
- S'entraîner sur des cas pratiques réels
- Développer leurs compétences techniques
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
│   ├── commercial_scenario.dart
│   ├── malfunction.dart
│   ├── scenarios.dart
│   └── tool.dart
├── data/
│   ├── commercial_scenarios_data.dart (100 scénarios - COMPLET)
│   ├── malfunctions_data.dart (14 pannes)
│   ├── scenarios_data.dart
│   └── tool_data.dart
├── services/
│   ├── commercial_scenario_service.dart
│   ├── malfunction_service.dart
│   └── scenarios_service.dart
├── screens/
│   ├── introduction_screen.dart
│   ├── dashboard_screen.dart
│   ├── commercial_scenario_screen.dart
│   ├── malfunction_home_screen.dart
│   ├── malfunction_creator_screen.dart
│   └── scenarios_picker_screen.dart
├── widgets/
│   ├── app_footer.dart
│   ├── animated_start_button.dart
│   └── tool_tile.dart

FONCTIONNALITÉS IMPLÉMENTÉES
-----------------------------

1. Écran d'Introduction
   - Fond dégradé bleu (Color(0xFF1A237E) → Color(0xFF00B0FF))
   - Animation de particules étoilées scintillantes
   - Bouton "Power On" animé avec feedback haptique
   - Footer avec signature XR & Claude

2. Dashboard
   - Grille adaptive (2-3 colonnes selon taille écran)
   - 10 outils listés (2 fonctionnels, 8 en développement)
   - Design compact avec ToolTile personnalisé

3. Scénarios Commerciaux (✅ COMPLET v1.3) - OUTIL PÉDAGOGIQUE
   
   Base de données : 100 scénarios répartis en 3 niveaux
   - Facile : 33 scénarios (⭐)
   - Moyen : 45 scénarios (⭐⭐)
   - Difficile : 22 scénarios (⭐⭐⭐)

   PÉRIMÈTRE :
   - Conseil et vente en magasin informatique
   - Matériel informatique fixe/mobile et périphériques
   - Formation aux compétences relationnelles et commerciales
   - Conforme aux référentiels RNCP (IDI, ADRN, TIP)

   Modes de jeu :
   - Mode Classique : Tirage aléatoire tous niveaux
   - Mode Défi : Chifoumi détermine la difficulté

   Fonctionnalités :
   - Timer 30 minutes (démarrage/pause/reprise)
   - Sélection par numéro (1-100)
   - Sélection par difficulté (3 boutons)
   - Affichage scénario avec profil client, budget, consignes
   - Numérotation "#X" dans "DEMANDE CLIENT"
   - Correction détaillée (questions clés, solutions, pièges, compétences RNCP)
   - Liens directs vers produits
   - Auto-évaluation (Réussi/À revoir)
   - Statistiques persistantes (SharedPreferences)
   - Bouton de signalement d'anomalie

4. Pannes Informatiques (v0.1) - OUTIL PÉDAGOGIQUE
   
   Base de données : 14 pannes réparties en 3 niveaux
   - Facile : 4 pannes
   - Moyen : 6 pannes
   - Difficile : 4 pannes
   
   6 catégories :
   - Matériel (hardware)
   - Logiciel (software)
   - BIOS/UEFI (setup)
   - Réseau/Internet (network)
   - Impression (printer)
   - Périphérique (peripheral)

   Mode Créateur (✅ COMPLET) :
   - Tirage aléatoire de pannes
   - Sélection par numéro
   - Sélection par difficulté
   - Instructions détaillées de création
   - Procédure étape par étape
   - Conseils de simulation
   - Numérotation "#X - Nom de la panne"
   - Statistiques décentralisées :
     * Total pannes tirées
     * Compteur par difficulté
     * Persistance SharedPreferences
     * Affichage en bas de l'écran

   Mode Dépanneur (🚧 EN DÉVELOPPEMENT) :
   - Non implémenté

THÈME & DESIGN
--------------
Couleur principale : Bleu (#00B0FF)
Palette complète : 10 nuances de bleu (50 à 900)

Particularités :
- Architecture statistiques décentralisée
- SharedPreferences pour persistance des statistiques
- Design compact et responsive
- Footer présent sur tous les écrans

OUTILS À DÉVELOPPER (8 restants)
---------------------------------

OUTILS PROFESSIONNELS (Usage quotidien techniciens) :
3. Conversion Unités XR - Métriques XR (FOV, PPD, etc.)
4. Calculateur Espace Disque - Conversions Mo/Go/To
5. Touches BIOS et BOOT - Référence fabricants
6. Fiches Hardware - Spécifications techniques
7. Liens Utiles - Ressources externes

OUTILS PÉDAGOGIQUES (Formation IDI, ADRN, TIP) :
1. ✅ Scénarios Commerciaux - COMPLET v1.3
2. ✅ Pannes Informatiques - Mode Créateur COMPLET v0.1
8. Procédures Techniques - Guides pas-à-pas
9. QCM - Tests de connaissances par module
10. (À définir)

Note : Certains outils (3-7) servent DOUBLE USAGE :
- Formation des apprenants aux trois titres RNCP
- Utilisation professionnelle quotidienne des techniciens

DÉPENDANCES
-----------
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.x.x
  shared_preferences: ^2.x.x

CONTRAINTES TECHNIQUES
----------------------
✓ SharedPreferences pour la persistance
✓ État géré en mémoire (setState)
✓ Architecture statistiques décentralisée
✓ Compatible Web, Mobile, Desktop
✓ Design responsive

HISTORIQUE DES VERSIONS
========================

v1.3.300925 (30 Septembre 2025)
--------------------------------
✨ Nouvelles fonctionnalités :
- Scénarios Commerciaux : Sélection par numéro (1-100)
- Scénarios Commerciaux : Sélection par difficulté (3 boutons compacts)
- Scénarios Commerciaux : Numérotation "#X" dans "DEMANDE CLIENT"
- Pannes Informatiques : Statistiques décentralisées dans Mode Créateur
  * Compteur total de pannes tirées
  * Compteur par difficulté (facile, moyen, difficile)
  * Persistance avec SharedPreferences
  * Affichage en bas de l'écran de sélection

🎨 Améliorations UX/UI :
- Scénarios Commerciaux : Interface de sélection redesignée (format compact)
- Scénarios Commerciaux : Augmentation taille de police "Choisissez votre mode de tirage" (18px → 20px)
- Pannes Informatiques : Architecture statistiques décentralisée
  * Mode Créateur gère ses propres stats (malfunction_creator_screen.dart)
  * Mode Dépanneur conserve ses stats (malfunction_home_screen.dart)

🛠 Corrections :
- Scénarios Commerciaux : Bug statistiques Chifoumi corrigé
  * Stats ne s'incrémentent plus lors du "Rejouer"
  * Stats s'incrémentent uniquement au "Lancer le scénario"
- Pannes Informatiques : Duplication statistiques Mode Créateur supprimée

📋 Documentation :
- Footer version mise à jour : 1.3.300925
- README.md mis à jour
- CHANGELOG.md mis à jour
- PROJECT_REFERENCE mis à jour

v1.2.0 (Janvier 2025)
---------------------
✨ Nouvelles fonctionnalités :
- 100 scénarios commerciaux complets (50 nouveaux)
- ✅ Fonctionnalité "Scénarios Commercial" terminée
- Scénarios orientés conseil/vente en magasin
- Conformité référentiels RNCP (IDI, ADRN, TIP)
- Pannes Informatiques : Nouvelle fonctionnalité (v0.1)
  * Mode Créateur complet avec 14 pannes
  * 6 catégories de pannes
  * 3 niveaux de difficulté

🎨 Améliorations UX/UI :
- Page d'accueil aérée (espacement optimisé)
- Page Chifoumi réorganisée avec titres clairs
- Encadré explicatif repositionné
- Meilleure hiérarchie visuelle

🛠 Corrections :
- Cohérence avec les trois référentiels RNCP
- Focus sur compétences transversales (conseil client)

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

🔧 Technique :
- _loadStatistics() et _saveStatistics()
- Sauvegarde automatique après validation
- Gestion robuste des valeurs nulles

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

Scénarios - Bonnes pratiques :
- Conseil commercial uniquement
- Matériel grand public
- Budgets réalistes (50€-1500€)
- Compétences transversales IDI/ADRN/TIP
- Situations de magasin/comptoir

Pannes - Bonnes pratiques :
- Pannes inspirées des examens de certification
- Catégorisation claire (6 catégories)
- Procédures détaillées de création
- Conseils de simulation réalistes
- Conformité référentiels RNCP

Architecture statistiques :
- Décentralisée : chaque écran gère ses stats
- SharedPreferences pour persistance
- Pas de state management global
- Autonomie et maintenabilité

Outils futurs - Double usage :
- Convertisseurs : formation + usage pro
- Références techniques : apprentissage + consultation rapide
- Procédures : entraînement + guide terrain
- QCM : évaluation formation

Améliorations suggérées :
- Développer le Mode Dépanneur (pannes)
- Enrichir base de pannes (30-40 pannes)
- Développer les 8 outils restants
- Historique des scénarios
- Mode révision ciblée
- Export/import statistiques
- Thème sombre
- Badges de progression
- Filtres par titre RNCP

STRUCTURE DES SCÉNARIOS
------------------------
Chaque scénario contient :
- id : numéro unique (1-100)
- clientProfile : type de client
- clientRequest : demande
- budgetInfo : contrainte budgétaire
- clientAttitude : comportement
- difficulty : easy/medium/hard
- keyQuestions : questions clés
- solutions : produits recommandés (prix, avantages, URL)
- commonTraps : pièges à éviter
- skillsWorked : compétences RNCP mobilisées

STRUCTURE DES PANNES
---------------------
Chaque panne contient :
- id : numéro unique
- name : nom de la panne
- description : description détaillée
- symptoms : symptômes observables
- category : catégorie (6 types)
- difficulty : easy/medium/hard
- estimatedTime : temps estimé de création
- creationSteps : procédure de création
- creationTips : conseils de simulation
- skillsWorked : compétences RNCP mobilisées

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
"Voici le CHANGELOG. Je veux développer l'outil Conversion Unités XR 
pour usage professionnel et formation IDI/TIP."

"Voici le CHANGELOG. Je veux développer le Mode Dépanneur des pannes
informatiques avec système de diagnostic guidé."

"Voici le CHANGELOG. Je veux ajouter 20 pannes niveau moyen 
axées sur les compétences ADRN (reconditionnement)."

==============================================
FIN DU DOCUMENT - Version 1.3.300925
==============================================