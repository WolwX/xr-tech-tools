XR TECH TOOLS - HISTORIQUE DES VERSIONS
========================================

INFORMATIONS GÉNÉRALES
----------------------
- Nom du projet : XR Tech Tools
- Technologie : Flutter / Dart
- Version actuelle : v1.2.0
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
│   ├── scenarios.dart
│   └── tool.dart
├── data/
│   ├── commercial_scenarios_data.dart (100 scénarios - COMPLET)
│   ├── scenarios_data.dart
│   └── tool_data.dart
├── services/
│   ├── commercial_scenario_service.dart
│   └── scenarios_service.dart
├── screens/
│   ├── introduction_screen.dart
│   ├── dashboard_screen.dart
│   ├── commercial_scenario_screen.dart
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
   - 10 outils listés (1 fonctionnel, 9 en développement)
   - Design compact avec ToolTile personnalisé

3. Scénarios Commerciaux (COMPLET v1.2.0) - OUTIL PÉDAGOGIQUE
   
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
   - Affichage scénario avec profil client, budget, consignes
   - Correction détaillée (questions clés, solutions, pièges, compétences RNCP)
   - Liens directs vers produits
   - Auto-évaluation (Réussi/À revoir)
   - Statistiques persistantes (SharedPreferences)
   - Bouton de signalement d'anomalie

THÈME & DESIGN
--------------
Couleur principale : Bleu (#00B0FF)
Palette complète : 10 nuances de bleu (50 à 900)

Particularités :
- SharedPreferences pour persistance des statistiques
- Design compact et responsive
- Footer présent sur tous les écrans

OUTILS À DÉVELOPPER (9 restants)
---------------------------------

OUTILS PROFESSIONNELS (Usage quotidien techniciens) :
1. ✅ Scénarios Commerciaux - COMPLET (pédagogique)
2. Conversion Unités XR - Métriques XR (FOV, PPD, etc.)
3. Calculateur Espace Disque - Conversions Mo/Go/To
4. Touches BIOS et BOOT - Référence fabricants
5. Fiches Hardware - Spécifications techniques
6. Liens Utiles - Ressources externes

OUTILS PÉDAGOGIQUES (Formation IDI, ADRN, TIP) :
7. Procédures Techniques - Guides pas-à-pas
8. QCM - Tests de connaissances par module
9. Diagnostic Pannes - Guide interactif
10. (À définir)

Note : Certains outils (2-6) servent DOUBLE USAGE :
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
✓ Compatible Web, Mobile, Desktop
✓ Design responsive

HISTORIQUE DES VERSIONS
========================

v1.2.0 (Janvier 2025)
---------------------
✨ Nouvelles fonctionnalités :
- 100 scénarios commerciaux complets (50 nouveaux)
- ✅ Fonctionnalité "Scénarios Commercial" terminée
- Scénarios orientés conseil/vente en magasin
- Conformité référentiels RNCP (IDI, ADRN, TIP)

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

Outils futurs - Double usage :
- Convertisseurs : formation + usage pro
- Références techniques : apprentissage + consultation rapide
- Procédures : entraînement + guide terrain
- QCM : évaluation formation

Améliorations suggérées :
- Développer les 9 outils restants
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

"Voici le CHANGELOG. Je veux ajouter 20 scénarios niveau moyen 
axés sur les compétences ADRN (reconditionnement)."

==============================================
FIN DU DOCUMENT - Version 1.2.0
==============================================