# XR Tech Tools

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Version](https://img.shields.io/badge/version-1.2.0-blue)](https://github.com/WolwX/xr-tech-tools)
[![Licence](https://img.shields.io/badge/licence-MIT-green)](LICENSE)

**Boîte à outils professionnelle et pédagogique pour techniciens informatique et apprenants**

XR Tech Tools est une application mobile et desktop développée en Flutter, conçue pour accompagner aussi bien les **apprenants en formation** que les **techniciens en exercice** dans leurs activités quotidiennes. L'application propose des outils pratiques, des scénarios d'entraînement et des ressources techniques adaptées aux référentiels RNCP.

---

## 🎯 Double Objectif

### Pour les Apprenants
- S'entraîner sur des cas pratiques réels
- Développer leurs compétences techniques
- Se préparer aux certifications professionnelles
- Réviser les concepts clés

### Pour les Professionnels
- Accéder rapidement à des outils de conversion et calcul
- Consulter des références techniques (BIOS, hardware)
- Utiliser des guides de diagnostic et procédures
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

## 🚧 Outils en Développement

### 🔧 Outils Professionnels (Utilisation quotidienne)
1. **Conversion Unités XR** - Métriques spécifiques à la réalité étendue (FOV, PPD, etc.)
2. **Calculateur Espace Disque** - Estimation et conversion (Mo, Go, To) pour stockage données XR
3. **Touches BIOS/BOOT** - Référence rapide par fabricant
4. **Fiches Hardware XR** - Spécifications techniques détaillées
5. **Liens Utiles** - Ressources externes sélectionnées

### 📚 Outils Pédagogiques (Formation & Entraînement)
6. **Diagnostic Pannes** - Guide interactif de résolution de problèmes
7. **Procédures Techniques** - Guides pas-à-pas illustrés (prochainement)
8. **QCM** - Tests de connaissances par module

> **Note** : Certains outils servent à la fois pour la formation et l'usage professionnel (ex: calculateurs, convertisseurs, références techniques)

## 🛠️ Technologies

- **Framework** : Flutter / Dart
- **Plateformes** : Android, iOS, Windows, macOS, Linux, Web
- **Gestion d'état** : StatefulWidget / setState
- **Navigation** : Navigator 2.0
- **Packages** : url_launcher, shared_preferences

## 📱 Installation

### Prérequis
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)

### Commandes
```bash
# Cloner le dépôt
git clone https://github.com/WolwX/xr-tech-tools.git

# Accéder au dossier
cd XRTechTools

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run