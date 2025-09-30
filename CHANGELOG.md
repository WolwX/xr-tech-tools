XR TECH TOOLS - DOCUMENT DE RÉFÉRENCE PROJET
==============================================

INFORMATIONS GÉNÉRALES
----------------------
- Nom du projet : XR Tech Tools
- Technologie : Flutter / Dart
- Version actuelle : v1.2.0
- Développeurs : XR (humain) & Claude (IA)
- Objectif : Plateforme de formation pour le titre professionnel "Installateur dépanneur en informatique" (Niveau 3)
- Contact : xavier.redondo@groupeleparc.fr
- Hébergement : GitHub Pages
- Plateforme : Educentre (https://educentre.fr)

RÉFÉRENTIEL PÉDAGOGIQUE
-----------------------
REAC TP-00304 - "Installateur dépanneur en informatique"
- Niveau : 3 (CAP/BEP)
- Date de validation : 27/02/2019
- Ministère du Travail

Activités types du REAC :
1. Mettre en service des équipements informatiques fixes et mobiles
   - Installer un système ou déployer une image
   - Configurer, paramétrer et personnaliser un équipement
   - Raccorder un équipement fixe ou mobile à un réseau
   - Informer et conseiller le client ou l'utilisateur ← CŒUR DES SCÉNARIOS COMMERCIAUX

2. Dépanner et reconditionner des équipements informatiques fixes et mobiles
   - Diagnostiquer et résoudre un dysfonctionnement
   - Vérifier, identifier, trier un équipement d'occasion
   - Revaloriser et intégrer un équipement fixe ou mobile

IMPORTANT : Les scénarios commerciaux couvrent UNIQUEMENT l'activité 1, aspect conseil/vente.
Le dépannage/SAV/reconditionnement ne fait PAS partie des scénarios commerciaux.

ARCHITECTURE DU PROJET
-----------------------
lib/
├── main.dart
├── models/
│   ├── commercial_scenario.dart
│   ├── scenarios.dart
│   └── tool.dart
├── data/
│   ├── commercial_scenarios_data.dart (100 scénarios - COMPLÉTÉ)
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
   - 10 outils listés (1 seul fonctionnel actuellement)
   - Design compact avec ToolTile personnalisé

3. Scénarios Commerciaux (COMPLET v1.2.0)
   
   Base de données : 100 scénarios répartis en 3 niveaux
   - Facile : 33 scénarios (⭐)
   - Moyen : 45 scénarios (⭐⭐)
   - Difficile : 22 scénarios (⭐⭐⭐)

   PÉRIMÈTRE STRICT :
   - Conseil et vente en magasin informatique UNIQUEMENT
   - Matériel informatique fixe/mobile et périphériques
   - Pas de dépannage, SAV ou reconditionnement
   - Situations conformes au REAC niveau 3
   - Épreuve de 30 minutes avec recherche internet

   Exemples de scénarios :
   - Étudiant cherche PC portable pour la fac
   - Parent veut tablette pour enfant
   - Auto-entrepreneur équipe son bureau
   - Gamer cherche écran 144Hz
   - Senior veut ordinateur simple
   - Famille avec budget limité

   Modes de jeu :
   - Mode Classique : Tirage aléatoire tous niveaux
   - Mode Défi : Chifoumi (Pierre-Feuille-Ciseaux) détermine la difficulté
     * Victoire → Facile
     * Égalité → Moyen
     * Défaite → Difficile

   Fonctionnalités :
   - Timer 30 minutes (démarrage/pause/reprise)
   - Affichage scénario avec profil client, budget, consignes
   - Correction détaillée (questions clés, solutions, pièges, compétences)
   - Liens directs vers produits (url_launcher)
   - Auto-évaluation (Réussi/À revoir)
   - Statistiques persistantes (SharedPreferences) :
     * Chifoumi : Victoires/Égalités/Défaites
     * Scénarios : Réussis / Essais par difficulté
     * Format affichage : "X / Y" (réussis sur total d'essais)
   - Bouton de signalement d'anomalie (email automatique)

   Améliorations UX v1.2.0 :
   - Page d'accueil aérée (espacement 40px au lieu de 24px)
   - Bloc statistiques séparé visuellement (32px)
   - Page Chifoumi avec titre "Chifoumi" + "Pierre-Feuille-Ciseaux"
   - Encadré explicatif orange déplacé en bas de la page chifoumi
   - Meilleure hiérarchie visuelle de l'information

THÈME & DESIGN
--------------
Couleur principale : Bleu (#00B0FF)
Palette complète : 10 nuances de bleu (50 à 900)

Particularités :
- Pas de localStorage/sessionStorage (restrictions Claude.ai)
- SharedPreferences pour persistance des statistiques
- Immersive mode activé (barre de statut visible)
- Design compact et responsive
- Footer présent sur tous les écrans

OUTILS À DÉVELOPPER (9 restants)
---------------------------------
1. ✅ Scénarios Commerciaux - COMPLET (100 scénarios)
2. ⏳ Procédures - Guides pas-à-pas (bientôt)
3. ⏳ QCM - Tests de connaissances
4. ⏳ Fiches Hardware - Spécifications techniques
5. ⏳ Conversion unités - Métriques XR (FOV, PPD, etc.)
6. ⏳ Calculateur espace disque - Stockage données XR
7. ⏳ Pannes informatique - Diagnostic interactif
8. ⏳ Touches BIOS et BOOT - Référence fabricants
9. ⏳ Liens utiles - Ressources externes
10. ⏳ (À définir)

DÉPENDANCES IMPORTANTES
------------------------
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.x.x
  shared_preferences: ^2.x.x (AJOUTÉ v1.1.0)

CONTRAINTES TECHNIQUES
----------------------
✗ Pas de localStorage/sessionStorage dans les artifacts
✓ SharedPreferences pour la persistance des données
✓ État géré en mémoire (setState, variables)
✓ Compatible Web, Mobile, Desktop
✓ Design responsive

HISTORIQUE DES VERSIONS
------------------------

v1.2.0 (Janvier 2025) :
✨ Nouvelles fonctionnalités :
- 100 scénarios commerciaux complets (50 nouveaux ajoutés) - Fonctionnalité Scénario Commercial OK
- Scénarios 51-100 strictement orientés conseil/vente
- Respect périmètre REAC niveau 3 (pas de dépannage/SAV)

🎨 Améliorations UX/UI :
- Page d'accueil scénarios aérée (espacement augmenté)
- Page Chifoumi réorganisée avec titre "Chifoumi"
- Encadré explicatif orange déplacé en bas de page chifoumi
- Meilleure séparation visuelle des statistiques

🐛 Corrections :
- Cohérence des scénarios avec référentiel REAC
- Suppression des scénarios hors périmètre

v1.1.0 (Janvier 2025) :
✨ Nouvelles fonctionnalités :
- Persistance des statistiques avec SharedPreferences
- Sauvegarde auto victoires/égalités/défaites chifoumi
- Conservation réussites et essais par difficulté

🎨 Améliorations UX/UI :
- Affichage "X / Y" (réussites / essais) par difficulté
- Séparation visuelle stats globales et personnelles
- Code couleur par niveau (vert/orange/rouge)

🔧 Technique :
- Implémentation _loadStatistics() et _saveStatistics()
- Sauvegarde après chaque chifoumi et validation
- Gestion robuste valeurs nulles avec ??

v1.0.0 (Janvier 2025) :
🎉 Version initiale :
- Application Flutter fonctionnelle
- 50 scénarios commerciaux de base
- Mode tirage classique et mode défi
- Timer 30 minutes avec pause/reprise
- Système de correction détaillée
- Signalement anomalies par email
- Footer avec liens réseaux sociaux

NOTES DE DÉVELOPPEMENT
-----------------------

Points d'attention :
- Les scénarios utilisent des URLs réelles (Logitech, Dell, HP, etc.)
- Le timer ne persiste pas entre sessions (en mémoire)
- Les statistiques PERSISTENT via SharedPreferences (depuis v1.1.0)
- Footer version suit format : MAJEURE.MINEURE.JJMMAA

Scénarios - Bonnes pratiques :
- Conseil commercial UNIQUEMENT (pas de dépannage)
- Matériel grand public (PC, tablettes, smartphones, périphériques)
- Budgets réalistes (50€ à 1500€ généralement)
- Situations de magasin/comptoir
- Client = particulier ou petite entreprise
- Niveau 3 du REAC (pas trop technique)

Améliorations futures suggérées :
- Historique des scénarios tirés
- Mode révision des scénarios échoués
- Filtres par type de client ou matériel
- Export/import des statistiques
- Thème sombre
- Badges de progression
- Développement des 9 outils restants

STRUCTURE DES SCÉNARIOS
------------------------
Chaque scénario contient :
- id : numéro unique (1-100)
- clientProfile : type de client
- clientRequest : demande formulée
- budgetInfo : contrainte budgétaire
- clientAttitude : comportement/état d'esprit
- difficulty : easy/medium/hard
- keyQuestions : questions à poser au client
- solutions : produits/services à proposer (avec prix, avantages, inconvénients, URL)
- commonTraps : pièges à éviter
- skillsWorked : compétences REAC travaillées

CONTACT & SUPPORT
-----------------
Email signalement : xavier.redondo@groupeleparc.fr
Plateforme : Educentre (https://educentre.fr)

==============================================
COMMENT UTILISER CE DOCUMENT
==============================================

Pour reprendre le projet avec Claude :

1. Partager ce fichier texte en début de conversation
2. Ajouter les fichiers de code concernés si modification spécifique
3. Préciser la fonctionnalité à développer/corriger

Exemple de prompt :
"Bonjour Claude, voici le document de référence du projet XR Tech Tools.
Je souhaiterais [développer l'outil X / corriger le bug Y / ajouter la fonctionnalité Z]."

Pour ajouter des scénarios :
"Voici le PROJECT_REFERENCE.txt. Je voudrais ajouter 10 nouveaux scénarios 
commerciaux de niveau [facile/moyen/difficile] sur le thème [X]."

Pour modifier l'UI :
"Voici le PROJECT_REFERENCE.txt et le fichier [nom_fichier.dart].
Je voudrais modifier [description de la modification UX]."

==============================================
FIN DU DOCUMENT - Version 1.2.0
==============================================