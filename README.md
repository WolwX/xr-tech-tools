# XR Tech Tools

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Version](https://img.shields.io/badge/version-1.3.300925-blue)](https://github.com/WolwX/xr-tech-tools)
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

### ✅ Scénarios Commerciaux (Complet - v1.3)
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
- **Numérotation** : Chaque scénario identifié par "#numéro" dans la demande client
- Signalement d'anomalies par email

### ✅ Pannes Informatiques (v0.1 - Mode Créateur fonctionnel)
- **14 pannes** réparties sur 3 niveaux (4 faciles, 6 moyennes, 4 difficiles)
- **6 catégories** : Matériel, Logiciel, BIOS/UEFI, Réseau, Impression, Périphérique

#### Mode Créateur ✅
- Tirage aléatoire de pannes
- **Sélection avancée** :
  - Par numéro de panne
  - Par difficulté (3 boutons)
- Instructions détaillées de création
- Procédure de création étape par étape
- Conseils de simulation
- **Statistiques décentralisées** :
  - Total de pannes tirées
  - Compteur par difficulté
  - Persistance avec SharedPreferences
  - Affichage en bas de l'écran

#### Mode Dépanneur 🚧
- En cours de développement

## 🚧 Outils en Développement

### 🔧 Outils Professionnels (Utilisation quotidienne)
3. **Conversion Unités XR** - Métriques spécifiques à la réalité étendue (FOV, PPD, etc.)
4. **Calculateur Espace Disque** - Estimation et conversion (Mo, Go, To) pour stockage données XR
5. **Touches BIOS/BOOT** - Référence rapide par fabricant
6. **Fiches Hardware XR** - Spécifications techniques détaillées
7. **Liens Utiles** - Ressources externes sélectionnées

### 📚 Outils Pédagogiques (Formation & Entraînement)
8. **Procédures Techniques** - Guides pas-à-pas illustrés
9. **QCM** - Tests de connaissances par module
10. **Outil à définir**

> **Note** : Certains outils servent à la fois pour la formation et l'usage professionnel (ex: calculateurs, convertisseurs, références techniques)

## 🛠️ Technologies

- **Framework** : Flutter / Dart
- **Plateformes** : Android, iOS, Windows, macOS, Linux, Web
- **Gestion d'état** : StatefulWidget / setState
- **Architecture statistiques** : Décentralisée (chaque écran gère ses stats)
- **Persistance** : SharedPreferences
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
```

## 📊 Architecture des Statistiques

L'application utilise une **architecture décentralisée** pour la gestion des statistiques :
- Chaque écran gère ses propres statistiques avec SharedPreferences
- Pas de prop drilling ni state management global
- Autonomie et maintenabilité de chaque fonctionnalité

## 🐛 Configuration pour Debug

### Chrome DevTools - Samsung Galaxy S23 Ultra
```
Dimensions : 480 × 1080 pixels (portrait)
Device pixel ratio : 3.0
User agent : Mobile (Android)
Mode paysage : 1080 × 480 pixels
```

## 📝 Versions Récentes

- **v1.3.300925** (30/09/2025) : Sélection avancée scénarios + statistiques décentralisées pannes
- **v1.2.0** : Ajout Mode Créateur de pannes + 100 scénarios commerciaux
- **v1.1.0** : Statistiques persistantes + Mode Défi Chifoumi
- **v1.0.0** : Version initiale avec dashboard

Voir [CHANGELOG.md](CHANGELOG.md) pour l'historique complet.

## 👥 Auteurs

Développé par XR (Xavier Redondo) avec l'assistance de Claude (Anthropic)

## 📧 Contact

Email : WolwX@hotmail.com  
GitHub : https://github.com/WolwX/xr-tech-tools

## 📄 Licence

[À définir]