XR TECH TOOLS - HISTORIQUE DES VERSIONS
========================================

## Version 1.3.2 (21/10/2025) - UI/UX, icônes et dashboard

### ✨ Changements principaux
- Améliorations UI/UX : refinement du Splash et du Dashboard
- Icônes multi-plateformes : favicon/web icons et app icon harmonisées
- Bordures 3D pour AppBar et Footer ; suppression des ombres image
- Synchronisation du background entre Intro et Dashboard

### 🔧 Divers
- Nettoyage des assets et mise à jour des configurations


## Version 1.3.1 (21/10/2025) - Distribution & Build Automatisé

### 📦 Nouveautés Distribution
- **Format ZIP portable** : Version Windows sans installation
  - Extraction simple dans un dossier au choix
  - Lancement direct de l'exécutable
  - Aucune dépendance système requise
  - Documentation d'installation simplifiée

- **Package MSIX** : Format Windows moderne (optionnel)
  - Installation système propre
  - Désinstallation facile via Paramètres Windows
  - Format natif Windows 10/11
  - Alternative pour utilisateurs avancés

- **Build GitHub Actions** : Automatisation complète
  - Compilation automatique Windows (ZIP + MSIX)
  - Compilation automatique Android (APK)
  - Génération de checksums SHA256 pour vérification
  - Publication automatique des releases

### 🔢 Système de Versioning avec Date
- **Double versioning intelligent** :
  - Version applicative : `1.3.1+20251021` (avec date complète AAAAMMJJ)
  - Version technique MSIX : `1.3.1.1021` (format court MMJJ compatible)
  - Affichage date de build dans l'interface utilisateur

- **Scripts d'automatisation** :
  - `set_version.bat` : Mise à jour automatique des versions avec date du jour
  - `build_msix.bat` : Build Windows automatisé
  - `release.bat` : Publication GitHub automatique

### 📚 Documentation Améliorée
- **Guide installation utilisateur** : Instructions claires pour ZIP et Windows Defender
- **README_BUILD.md** : Documentation build pour développeurs
- **GUIDE_RELEASE.md** : Procédure de publication des releases
- **VERSIONING_GUIDE.md** : Explication du système de versioning

### 🛡️ Gestion Windows Defender
- **Documentation exception Windows Defender** :
  - Instructions ajout d'exception de dossier
  - Alternative "Exécuter quand même" pour test rapide
  - Explication des fausses alertes
  - FAQ intégrée au README

### 🔧 Améliorations Techniques
- Configuration MSIX complète dans `pubspec.yaml`
- Workflow GitHub Actions optimisé (`.github/workflows/release.yml`)
- Format de version compatible contraintes MSIX (segments < 65535)
- Widget `VersionDisplay` pour affichage date de build dans l'app
- Gestion automatique version via `package_info_plus`

### 📦 Fichiers Générés par Release
Chaque release GitHub contient maintenant :
- `XRTechTools-Windows-Portable-v1.3.1.zip` (version recommandée)
- `XRTechTools-Windows-v1.3.1.msix` (installation système)
- `XRTechTools-Android-v1.3.1.apk`
- `checksums.txt` (hashes SHA256 pour vérification intégrité)

---

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

## Version 1.3.061025 (06/10/2025) - 4 Logigrammes Hardware Complets

### 🗺️ EXPANSION MASSIVE LOGIGRAMMES

#### 📚 Nouveau Contenu
- **4 logigrammes Hardware complets et opérationnels** :
  1. "L'ordinateur ne s'allume pas" - Diagnostic alimentation/carte mère
  2. "Pas d'affichage à l'écran" - Résolution problèmes vidéo/moniteur
  3. "L'ordinateur ne démarre pas" - Diagnostic boot/démarrage système
  4. "Arrêts/redémarrages inattendus" - Analyse stabilité/température
- Plus de **50 étapes de diagnostic** cumulées avec logique conditionnelle complète

#### 🎨 Interface Perfectionnée
- **Système de sous-titres explicatifs** sous chaque option de choix
- **Bouton "Étape précédente"** transformé en ElevatedButton avec style visuel renforcé
  - Couleur de fond colorée, bordure épaisse, ombre et coins arrondis
  - Espacement de sécurité augmenté (20px) entre bouton et timer
- **Icônes d'étape** et indicateurs visuels améliorés dans l'AppBar

#### 🔧 Optimisations Techniques
- Layout **Wrap** implémenté dans `malfunction_technician_screen.dart` pour affichage multi-ligne
- Model `FlowchartOption` étendu avec champ `subtitle` optionnel
- **Système de visualisation d'images** intégré avec `flowchart_image_viewer.dart`
- Mode plein écran pour les images de diagnostic avec gestes de navigation
- Corrections de texte descriptif standardisé pour cohérence utilisateur

#### 🎯 Ergonomie Avancée
- Boutons logigrammes organisés sur plusieurs lignes avec Wrap (spacing: 8, runSpacing: 8)
- Texte descriptif harmonisé : "Vérifiez la température du processeur et les ventilateurs"
- Interface AppBar optimisée avec icône jaune et espacement perfectionné
- Navigation fluide entre étapes avec historique complet et retour arrière ergonomique

---

## Version 1.3.041025 (04/10/2025) - Système de Confirmation Timer

### 🛡️ Protection Contre Tirages Accidentels
- **Popup de confirmation automatique** pour tous les nouveaux tirages
- Message contextuel : "Vous allez commencer un [type de tirage]"
- Arrêt automatique du timer en cours après confirmation utilisateur
- Choix "Continuer" ou "Arrêter le timer" avec interface orange distinctive
- Protection complète : tirage aléatoire, sélection numéro, difficulté, catégorie, mode Chifoumi

### 🧠 Navigation Intelligente
- **Double-clic sur timer flottant** pour retour direct à la fiche associée
- Distinction automatique : Navigation timer vs. Nouveau tirage
- Paramètre `isFromTimerNavigation` pour bypass intelligent des confirmations
- Navigation fluide sans interruption depuis le timer
- Préservation complète de l'expérience utilisateur

### 🔧 Améliorations Techniques
- Service **GlobalTimerService** enrichi :
  - Nouvelle méthode `showTimerStopConfirmation()` : Dialog de confirmation stylisé
  - Nouvelle méthode `handleNewDrawRequest()` : Coordination intelligente des demandes
  - Gestion contextuelle des confirmations avec messages personnalisés
  - Protection robuste contre les interruptions accidentelles

- Écrans **MalfunctionTechnicianScreen** et **CommercialScenarioScreen** :
  - Signature modifiée `_selectMalfunctionById()` et `_selectScenarioById()`
  - Paramètre `isFromTimerNavigation` pour discrimination source navigation
  - Logique conditionnelle : Confirmation pour utilisateur, bypass pour timer
  - Cohérence système sur tous les types d'écrans

### 🗺️ Corrections Système Logigrammes
- Interface de sélection des logigrammes optimisée
- Suggestions intelligentes basées sur les symptômes améliorées
- Corrections de bugs d'affichage dans les barres de recherche
- Stabilisation de l'intégration avec le système de diagnostic
- Meilleure ergonomie des interfaces d'aide au diagnostic

### 🔧 Améliorations Additionnelles
- Widget **AppFooter automatisé** : Version récupérée dynamiquement depuis `pubspec.yaml`
- Ajout dépendance `package_info_plus: ^8.0.0` pour gestion automatique version
- Élimination du hardcoding de version dans le footer
- Système de fallback en cas d'erreur de lecture version

---

## Version 1.3.031025 (03/10/2025) - Timer Flottant Automatique

### ⏱️ Système de Timer Flottant
- **Apparition automatique** lors de la sélection de fiches de dépannage
- **Texte dynamique intelligent** : "Démarrer le dépannage X min" → Compte à rebours
- **Interface épurée** : Suppression des doublons de timer
- **Temps configurable** pour différentes durées d'épreuves futures
- **Bouton reset** : Réinitialise sans fermer le timer (icône 🔄)
- **Intégration complète** : Fonctionne dans tous les contextes

### 🔧 Corrections Techniques
- Suppression du timer local dans `InteractiveFlowchartScreen`
- Élimination des widgets redondants (`_buildCompactTimerWidget`)
- Optimisation de l'espace réservé aux timers (80px → 24px)
- Correction des problèmes de lifecycle des listeners
- Interface unifiée pour une expérience utilisateur cohérente

### 🎯 Déclencheurs Automatiques
- Tirage aléatoire de fiche (`_drawRandomMalfunction`)
- Sélection par ID (`_selectMalfunctionById`)
- Sélection par difficulté (`_selectMalfunctionByDifficulty`)
- Sélection par catégorie (`_selectMalfunctionByCategory`)
- Résultats de chifoumi (victoire/défaite/égalité)

---

## Version 1.3.011025 (01/10/2025) - Logigrammes Interactifs

### 🗺️ Système de Logigrammes
- **Navigation guidée** étape par étape pour diagnostic pannes
- **Détection automatique** du logigramme pertinent
- **Interface interactive** avec choix multiples
- **Barre de progression** et historique de navigation
- **Retour arrière** possible à tout moment
- **Résultats contextuels** (Succès/Échec/Info) avec codes couleur
- **Options visuellement distinctes** (✔ vert / ✗ rouge)

### 📊 Premier Logigramme
**"L'ordinateur ne s'allume pas"**
- 5 étapes de diagnostic guidées
- Vérification branchements électriques
- Contrôle alimentation carte mère
- Vérification CMOS
- Tests périphériques
- Diagnostic composants HS

### 🔧 Architecture Technique
- Nouveaux modèles : `FlowchartInfo`, `FlowchartStep`, `FlowchartOption`
- Service centralisé : `FlowchartService`
- Données structurées : `FlowchartData`
- Interface dédiée : `InteractiveFlowchartScreen`
- Détection intelligente par mots-clés et catégorie
- Architecture extensible pour 13+ logigrammes futurs

### 🎨 Intégration UX
- Bouton **"Logigramme HARDWARE"** dans Mode Dépanneur
- Visible uniquement si logigramme disponible
- Suggestion automatique du logigramme le plus adapté
- Sélection manuelle si plusieurs logigrammes disponibles
- Message informatif si non disponible

---

## Version 1.3.300925 (30/09/2025) - Sélection Avancée

### ✨ Mode Créateur de Pannes
- Sélection avancée par numéro de panne
- Sélection par difficulté (3 boutons dédiés)
- **Statistiques décentralisées** :
  - Total de pannes tirées
  - Compteurs par difficulté
  - Persistance avec SharedPreferences
  - Affichage permanent en bas de l'écran

### ✨ Scénarios Commerciaux
- Sélection avancée par numéro (1-100)
- Sélection par difficulté (3 boutons compacts)
- Interface plus intuitive
- Validation avec messages d'erreur clairs

---

## Version 1.2.0 (Janvier 2025) - 100 Scénarios

### ✨ Nouvelles Fonctionnalités
- **100 scénarios commerciaux complets** (50 nouveaux)
- ✅ Fonctionnalité "Scénarios Commercial" terminée
- Conformité référentiels RNCP (IDI, ADRN, TIP)

### 🎨 Améliorations UX/UI
- Page d'accueil aérée
- Page Chifoumi réorganisée
- Meilleure hiérarchie visuelle

### 🛠️ Corrections
- Cohérence avec les trois référentiels RNCP
- Focus sur compétences transversales

---

## Version 1.1.0 (Janvier 2025) - Statistiques Persistantes

### ✨ Nouvelles Fonctionnalités
- Persistance statistiques (SharedPreferences)
- Sauvegarde scores Chifoumi
- Conservation réussites par difficulté

### 🎨 Améliorations UX/UI
- Affichage "X / Y" (réussites/essais)
- Code couleur par niveau
- Séparation stats globales/personnelles

---

## Version 1.0.0 (Septembre 2024) - Version Initiale

### 🎉 Fonctionnalités Initiales
- Application Flutter fonctionnelle
- 50 scénarios commerciaux
- Mode classique et mode défi
- Timer 30 minutes
- Correction détaillée
- Signalement anomalies

---

INFORMATIONS GÉNÉRALES
----------------------
- **Nom du projet** : XR Tech Tools
- **Technologie** : Flutter / Dart
- **Version actuelle** : v1.3.1
- **Développeurs** : XR (Xavier Redondo - humain) & Claude (IA Anthropic)
- **Objectif** : Boîte à outils professionnelle et pédagogique pour techniciens informatique et apprenants
- **Contact** : WolwX@hotmail.com
- **Dépôt GitHub** : https://github.com/WolwX/xr-tech-tools

---

DOUBLE OBJECTIF
---------------

### Pour les Apprenants (IDI, ADRN, TIP)
- S'entraîner sur des cas pratiques réels
- Développer leurs compétences techniques avec des logigrammes guidés
- Se préparer aux certifications professionnelles
- Réviser les concepts clés

### Pour les Professionnels
- Accéder rapidement à des outils de conversion et calcul
- Consulter des références techniques (BIOS, hardware)
- Utiliser des guides de diagnostic et procédures
- Optimiser leurs interventions quotidiennes

---

TITRES PROFESSIONNELS VISÉS
----------------------------
- **IDI** - Installateur Dépanneur en Informatique (RNCP34147)
- **ADRN** - Agent De Reconditionnement en appareil Numérique (RNCP38718)
- **TIP** - Technicien Informatique de Proximité (RNCP40799)

---

ARCHITECTURE DU PROJET
-----------------------
```
lib/
├── main.dart
├── models/
│   ├── malfunction.dart
│   ├── scenario.dart
│   └── flowchart_models.dart          [v1.3.011025]
├── services/
│   ├── malfunction_service.dart
│   ├── scenario_service.dart
│   ├── flowchart_service.dart         [v1.3.011025]
│   ├── flowchart_data.dart            [v1.3.011025]
│   └── global_timer_service.dart      [v1.3.031025]
├── screens/
│   ├── dashboard_screen.dart
│   ├── scenario_screen.dart
│   ├── malfunction_creator_screen.dart
│   ├── malfunction_technician_screen.dart
│   └── interactive_flowchart_screen.dart  [v1.3.011025]
└── widgets/
    ├── app_footer.dart
    ├── version_display.dart           [v1.3.1]
    └── flowchart_image_viewer.dart    [v1.3.061025]
```

---

FONCTIONNALITÉS IMPLÉMENTÉES
-----------------------------

### 1. Scénarios Commerciaux (COMPLET) - OUTIL PÉDAGOGIQUE
   
**Base de données** : 100 scénarios répartis en 3 niveaux
- Facile : 33 scénarios (⭐)
- Moyen : 45 scénarios (⭐⭐)
- Difficile : 22 scénarios (⭐⭐⭐)

**Modes de jeu** :
- Mode Classique : Tirage aléatoire tous niveaux
- Mode Défi : Chifoumi détermine la difficulté

**Fonctionnalités** :
- Sélection avancée par numéro (1-100) ou difficulté
- Timer 30 minutes (démarrage/pause/reprise)
- Correction détaillée (questions clés, solutions, pièges, compétences RNCP)
- Liens directs vers produits
- Auto-évaluation (Réussi/À revoir)
- Statistiques persistantes (SharedPreferences)

---

### 2. Mode Créateur de Pannes (COMPLET)
   
**Base de données** : 14 pannes réparties en 3 niveaux
- Facile : 4 pannes
- Moyen : 6 pannes
- Difficile : 4 pannes
   
**Catégories** : Hardware, Software, BIOS/UEFI, Network, Printer, Peripheral
   
**Fonctionnalités** :
- Tirage aléatoire ou sélection manuelle (par numéro/difficulté)
- Instructions détaillées de création de panne
- Procédures étape par étape
- Conseils de simulation
- Statistiques décentralisées (total + par difficulté)

---

### 3. Mode Dépanneur (COMPLET)
   
**Fonctionnalités** :
- Utilise les 14 pannes du Mode Créateur
- Affichage symptômes uniquement (vision technicien)
- Timer 30 minutes avec pause/reprise
- Sélection avancée (par numéro ou difficulté)
- Solution complète avec procédure de résolution
- Auto-évaluation (Réussi/À revoir)
- Statistiques persistantes par difficulté
- Mode Défi Chifoumi

---

### 4. Logigrammes Interactifs (4 DISPONIBLES)
   
**Système de diagnostic guidé** :
- Navigation étape par étape avec choix multiples
- Détection automatique du logigramme pertinent
- Barre de progression et historique
- Retour arrière possible à tout moment
- Résultats contextuels avec codes couleur :
  * Succès (vert) : Solution trouvée
  * Échec (rouge) : Composant défectueux
  * Info (bleu) : Prochaines étapes suggérées
- Options visuellement distinctes (✔ vert / ✗ rouge)
   
**Logigrammes disponibles** :
1. **"L'ordinateur ne s'allume pas"** (Hardware - Bleu)
   - 5 étapes de diagnostic guidées
   - Vérifications : électrique, carte mère, CMOS, périphériques
   - Diagnostic composants HS

2. **"Pas d'affichage à l'écran"** (Hardware - Orange)
   - Diagnostic problèmes vidéo/moniteur
   - Tests câbles et connexions
   - Vérification carte graphique

3. **"L'ordinateur ne démarre pas"** (Hardware - Vert)
   - Diagnostic boot/démarrage système
   - Tests disque dur/SSD
   - Vérification BIOS

4. **"Arrêts/redémarrages inattendus"** (Hardware - Violet)
   - Analyse stabilité/température système
   - Tests alimentation
   - Diagnostic surchauffe
   
**Architecture** :
- Service centralisé : FlowchartService
- Détection intelligente par mots-clés
- Extensible : 10+ logigrammes prévus (Software, BIOS/UEFI, Network, Printer, Peripheral)
- Intégration dans Mode Dépanneur (bouton visible si disponible)

---

THÈME & DESIGN
--------------
**Couleur principale** : Bleu (#00B0FF)

**Palette logigrammes** :
- Bleu (#64B5F6) : Ne s'allume pas
- Violet (#9575CD) : Freeze/Shutdown
- Orange (#FFB74D) : Pas d'affichage
- Vert (#81C784) : Ne boot pas

---

DÉPENDANCES
-----------
```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.2.1
  shared_preferences: ^2.2.2
  package_info_plus: ^8.0.0
  flutter_svg: ^2.0.10+1
  cupertino_icons: ^1.0.8

dev_dependencies:
  msix: ^3.16.12
  flutter_launcher_icons: ^0.13.1
  flutter_lints: ^5.0.0
```

---

DISTRIBUTION
------------

### Formats Disponibles
1. **ZIP Portable** (Recommandé)
   - Extraction simple
   - Aucune installation
   - Lancement direct

2. **MSIX** (Optionnel)
   - Installation système
   - Format Windows moderne
   - Nécessite mode développeur ou certificat

3. **APK Android**
   - Installation standard Android
   - Sources inconnues à activer

### Build Automatisé
- **GitHub Actions** compile automatiquement :
  - Windows (ZIP + MSIX)
  - Android (APK)
  - Checksums SHA256
- Publication automatique sur Releases GitHub

---

VERSIONING
----------

### Système de Double Versioning
- **Version applicative** : `MAJEURE.MINEURE.PATCH+AAAAMMJJ`
  - Exemple : `1.3.1+20251021`
  - Affichée dans l'application
  - Date complète du build

- **Version MSIX** : `MAJEURE.MINEURE.PATCH.MMJJ`
  - Exemple : `1.3.1.1021`
  - Format technique compatible Windows
  - Date courte (Mois + Jour)

### Scripts d'Automatisation
- `set_version.bat` : Mise à jour automatique avec date du jour
- `build_msix.bat` : Build Windows local
- `release.bat` : Publication GitHub automatique

---

NOTES DE DÉVELOPPEMENT
-----------------------

### Logigrammes - Bonnes Pratiques
- Un logigramme = un parcours de diagnostic complet
- Étapes logiques et progressives
- Options claires et distinctes visuellement
- Messages de résolution contextuels
- Facilement extensible (ajout dans `flowchart_data.dart`)

### Architecture Décentralisée
- Chaque écran gère ses propres statistiques
- Utilisation de SharedPreferences
- Pas de state management global
- Autonomie et maintenabilité

### Distribution Windows
- **Format ZIP** : Priorité pour simplicité utilisateur
- **Format MSIX** : Optionnel pour utilisateurs avancés
- **Documentation** : Instructions claires pour Windows Defender
- **Certificat Code Signing** : Optionnel (~200€/an pour éliminer warnings)
- **Microsoft Store** : Alternative viable (19€ une fois, signature auto)

---

AMÉLIORATIONS SUGGÉRÉES
------------------------
- [ ] Développer les 10+ logigrammes restants (Software, Network, etc.)
- [ ] Compléter la Boîte à Outils (9 outils restants)
- [ ] Historique des scénarios/pannes
- [ ] Mode révision ciblée
- [ ] Export/import statistiques
- [ ] Thème sombre
- [ ] Badges de progression
- [ ] Widget `VersionDisplay` dans tous les écrans
- [ ] Publication Microsoft Store (signature automatique gratuite)

---

CONTACT & SUPPORT
-----------------
- **Email** : WolwX@hotmail.com
- **GitHub** : https://github.com/WolwX/xr-tech-tools
- **Issues** : https://github.com/WolwX/xr-tech-tools/issues

---

COMMENT UTILISER CE DOCUMENT
==============================

### Pour Reprendre le Projet avec Claude
1. Partager ce fichier en début de conversation
2. Préciser la fonctionnalité à développer/corriger
3. Mentionner le(s) titre(s) RNCP concerné(s) si pertinent

### Exemples
```
"Voici le CHANGELOG. Je veux développer le logigramme 
'Pas d'affichage' pour les pannes hardware."

"Voici le CHANGELOG. Je veux créer des logigrammes 
pour la catégorie Software (pannes logicielles)."

"Voici le CHANGELOG. Je veux publier une nouvelle 
release avec les dernières modifications."
```

---

==============================================
FIN DU DOCUMENT - Version 1.3.1 (21/10/2025)
==============================================