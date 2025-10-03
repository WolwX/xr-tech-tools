# XR Tech Tools

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Version](https://img.shields.io/badge/version-1.3.031025-blue)](https://github.com/WolwX/xr-tech-tools)
[![Licence](https://img.shields.io/badge/licence-MIT-green)](LICENSE)

**Boîte à outils professionnelle et pédagogique pour techniciens informatique et apprenants**

XR Tech Tools est une application mobile et desktop développée en Flutter, conçue pour accompagner aussi bien les **apprenants en formation** que les **techniciens en exercice** dans leurs activités quotidiennes. L'application propose des outils pratiques, des scénarios d'entraînement, **des organigrammes de dépannage interactifs** et des ressources techniques adaptées aux référentiels RNCP.

---

## 🎯 Double Objectif

### Pour les Apprenants
- S'entraîner sur des cas pratiques réels
- **Développer leurs compétences techniques avec des organigrammes guidés**
- Se préparer aux certifications professionnelles
- Réviser les concepts clés

### Pour les Professionnels
- Accéder rapidement à des outils de conversion et calcul
- Consulter des références techniques (BIOS, hardware)
- **Utiliser des guides de diagnostic interactifs**
- Optimiser leurs interventions quotidiennes

## 🎓 Titres Professionnels Visés

Cette application s'adresse aux apprenants préparant les certifications suivantes :

- **IDI** - Installateur Dépanneur en Informatique (RNCP34147)
- **ADRN** - Agent De Reconditionnement en appareil Numérique (RNCP38718)
- **TIP** - Technicien Informatique de Proximité (RNCP40799)

## ✨ Fonctionnalités Actuelles

### ✅ Scénarios Commerciaux (Complet - v1.2.0)
- **100 scénarios** répartis en 3 niveaux de difficulté
  - Facile : 33 scénarios
  - Moyen : 45 scénarios
  - Difficile : 22 scénarios
- **Mode Classique** : Tirage aléatoire tous niveaux
- **Mode Défi** : Niveau déterminé par un mini-jeu Chifoumi
- **Sélection avancée** :
  - Par numéro de scénario (1-100)
  - Par difficulté (3 boutons compacts)
- Timer 30 minutes avec pause/reprise
- Correction détaillée avec :
  - Questions clés à poser au client
  - Solutions techniques recommandées
  - Pièges à éviter
  - Compétences mobilisées (référentiel RNCP)
- Liens directs vers les produits
- Auto-évaluation (Réussi/À revoir)
- **Statistiques persistantes** (sauvegardées entre les sessions)
  - Chifoumi : Victoires/Égalités/Défaites
  - Scénarios : Réussis/Essais par difficulté
  - Format "X / Y" (réussis sur total d'essais)
- Signalement d'anomalies par email

### ✅ Mode Créateur de Pannes (v1.3.300925)
- **14 pannes** réparties sur 3 niveaux (4 faciles, 6 moyennes, 4 difficiles)
- **6 catégories** : Matériel, Logiciel, BIOS/UEFI, Réseau, Impression, Périphérique
- **Tirage aléatoire** de pannes
- **Sélection avancée** :
  - Par numéro de panne
  - Par difficulté (3 boutons)
- **Instructions détaillées** de création
  - Procédure de création étape par étape
  - Conseils de simulation
- **Statistiques décentralisées** :
  - Total de pannes tirées
  - Compteur par difficulté
  - Persistance avec SharedPreferences

### ✅ Mode Dépanneur (v1.3.300925)
- Utilise les 14 pannes du Mode Créateur
- Affichage des symptômes uniquement (vision technicien)
- Timer 30 minutes avec pause/reprise
- Sélection avancée (par numéro ou difficulté)
- Solution complète avec procédure de résolution
- Auto-évaluation (Réussi/À revoir)
- Statistiques persistantes par difficulté
- Mode Défi Chifoumi

### 🗺️ Organigrammes Interactifs de Dépannage **[AMÉLIORÉ v1.3.031025]**
- **Navigation guidée étape par étape** pour diagnostiquer les pannes
- **Détection automatique** de l'organigramme le plus pertinent
- **Interface interactive** avec choix multiples
- **Barre de progression** et historique de navigation
- **Retour arrière** possible à tout moment
- **Timer flottant automatique** - Apparaît dès la sélection d'une fiche
- **Résultats contextuels** avec codes couleur :
  - 🟢 Succès : Solution trouvée
  - 🔴 Échec : Composant défectueux
  - 🔵 Info : Prochaines étapes suggérées
- **Options visuellement distinctes** (✓ vert / ✗ rouge)

**Premier organigramme disponible** : "L'ordinateur ne s'allume pas" (Hardware)
- 5 étapes de diagnostic guidées
- Vérifications : électriques, carte mère, CMOS, périphériques

### ⏱️ Système de Timer Flottant **[NOUVEAU v1.3.031025]**
- **Apparition automatique** lors de la sélection de fiches de dépannage
- **Texte dynamique** : "Démarrer le dépannage X min" → Compte à rebours
- **Interface épurée** : Un seul timer global cohérent
- **Temps configurable** : Prêt pour différentes durées d'épreuves
- **Bouton reset** : Réinitialise sans fermer le timer
- **Intégration complète** : Fonctionne dans tous les contextes (fiches, organigrammes)
- Diagnostic composants HS

**Architecture extensible** : Prêt pour 13+ organigrammes supplémentaires couvrant toutes les catégories de pannes (Hardware, Software, BIOS/UEFI, Network, Printer, Peripheral).

## 🚧 Outils en Développement

### 🔧 Outils Professionnels (Utilisation quotidienne)
1. **Conversion Unités XR** - Métriques spécifiques à la réalité étendue (FOV, PPD, etc.)
2. **Calculateur Espace Disque** - Estimation et conversion (Mo, Go, To) pour stockage données XR
3. **Touches BIOS/BOOT** - Référence rapide par fabricant
4. **Fiches Hardware XR** - Spécifications techniques détaillées
5. **Liens Utiles** - Ressources externes sélectionnées

### 📚 Outils Pédagogiques (Formation & Entraînement)
6. **Procédures Techniques** - Guides pas-à-pas illustrés
7. **QCM** - Tests de connaissances par module
8. **Outil à définir**

> **Note** : Certains outils servent à la fois pour la formation et l'usage professionnel (ex: calculateurs, convertisseurs, références techniques)

## 🛠️ Technologies

- **Framework** : Flutter / Dart
- **Plateformes** : Android, iOS, Windows, macOS, Linux, Web
- **Gestion d'état** : StatefulWidget / setState
- **Architecture statistiques** : Décentralisée (chaque écran gère ses stats)
- **Persistance** : SharedPreferences
- **Navigation** : Navigator 2.0
- **Packages** : 
  - `url_launcher` : Ouverture de liens externes
  - `shared_preferences` : Sauvegarde des données locales

## 📱 Installation

### Prérequis
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)

### Commandes
```bash
# Cloner le dépôt
git clone https://github.com/WolwX/xr-tech-tools.git

# Accéder au dossier
cd xr-tech-tools

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

## 📊 Gestion des Statistiques

L'application utilise une architecture **décentralisée** pour la gestion des statistiques :
- Chaque écran gère ses propres statistiques avec SharedPreferences
- Pas de prop drilling ni state management global
- Autonomie et maintenabilité de chaque fonctionnalité

## 📝 Versions

- **v1.3.031025** (03/10/2025) : Timer flottant automatique + Interface épurée organigrammes
- **v1.3.011025** (01/10/2025) : Ajout des organigrammes interactifs de dépannage
- **v1.3.300925** (30/09/2025) : Sélection avancée scénarios + statistiques décentralisées pannes
- **v1.2.0** : Ajout Mode Créateur de pannes + 100 scénarios commerciaux
- **v1.1.0** : Statistiques persistantes + Mode Défi Chifoumi
- **v1.0.0** : Version initiale avec dashboard

Voir [CHANGELOG.md](CHANGELOG.md) pour l'historique complet.

## 👨‍💻 Développement

**Développé par** : XR (Xavier Redondo)  
**Assistance IA** : Claude (Anthropic)

**Contact** : [WolwX@hotmail.com](mailto:WolwX@hotmail.com)  
**GitHub** : [https://github.com/WolwX/xr-tech-tools](https://github.com/WolwX/xr-tech-tools)

## 📄 Licence

[À définir]

---

**XR Tech Tools** - Votre compagnon de formation et d'intervention technique