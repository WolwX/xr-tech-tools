# Guide d'installation Flutter pour XR Tech Tools

## 📋 Prérequis

- Windows 10 ou supérieur
- Au moins 2 Go d'espace disque
- Git pour Windows (recommandé)

## 🚀 Installation de Flutter

### Méthode 1 : Installation avec Git (Recommandée)

1. **Installer Git** (si pas déjà fait)
   - Téléchargez depuis : https://git-scm.com/download/win
   - Installez avec les options par défaut

2. **Cloner Flutter**
   ```powershell
   cd C:\
   git clone https://github.com/flutter/flutter.git -b stable
   ```

3. **Ajouter Flutter au PATH**
   - Ouvrez les Paramètres Système → Variables d'environnement
   - Dans "Variables système", sélectionnez "Path" → Modifier
   - Cliquez "Nouveau" et ajoutez : `C:\flutter\bin`
   - Cliquez OK pour fermer toutes les fenêtres

4. **Vérifier l'installation** (dans un NOUVEAU terminal PowerShell)
   ```powershell
   flutter doctor
   ```

### Méthode 2 : Téléchargement manuel

1. **Télécharger Flutter SDK**
   - Allez sur : https://docs.flutter.dev/get-started/install/windows
   - Téléchargez le fichier ZIP

2. **Extraire l'archive**
   - Extrayez dans `C:\flutter` (ou un autre emplacement de votre choix)

3. **Ajouter au PATH** (comme dans la méthode 1, étape 3)

4. **Vérifier l'installation**
   ```powershell
   flutter doctor
   ```

## 🔧 Configuration de l'environnement

### Pour le développement Windows Desktop

1. **Installer Visual Studio 2022**
   - Téléchargez : https://visualstudio.microsoft.com/downloads/
   - Installez "Desktop development with C++"
   - Cochez les composants :
     - MSVC v143 - VS 2022 C++ x64/x86
     - Windows 10 SDK

2. **Activer le support Windows**
   ```powershell
   flutter config --enable-windows-desktop
   ```

### Pour le développement Android

1. **Installer Android Studio**
   - Téléchargez : https://developer.android.com/studio
   - Installez Android SDK et Android SDK Command-line Tools
   - Acceptez les licences Android :
     ```powershell
     flutter doctor --android-licenses
     ```

2. **Configurer un émulateur Android** (optionnel)
   - Ouvrez Android Studio
   - Tools → Device Manager
   - Create Device → Choisissez un appareil

### Pour le développement Web

```powershell
flutter config --enable-web
```

## 📦 Installation des dépendances du projet

Une fois Flutter installé, dans le dossier du projet :

```powershell
cd c:\APPs\xrtechtools
flutter pub get
```

## ▶️ Lancer l'application

### Sur Windows
```powershell
flutter run -d windows
```

### Sur Android (émulateur ou appareil connecté)
```powershell
flutter run
```

### Sur Chrome (Web)
```powershell
flutter run -d chrome
```

## 🔍 Vérification complète

Exécutez cette commande pour voir l'état de votre installation :

```powershell
flutter doctor -v
```

Résolvez tous les problèmes signalés avec un [✗] ou [!]

## 🏗️ Build de l'application

### Build Windows (exécutable)
```powershell
flutter build windows --release
```
L'exécutable sera dans : `build\windows\x64\runner\Release\`

### Build Android (APK)
```powershell
flutter build apk --release
```
L'APK sera dans : `build\app\outputs\flutter-apk\`

### Build Windows (MSIX - Store)
```powershell
flutter pub run msix:create
```
Le package sera dans : `build\windows\x64\runner\Release\`

## 📚 Ressources utiles

- Documentation Flutter : https://docs.flutter.dev
- API Dart : https://api.dart.dev
- Packages Pub.dev : https://pub.dev
- Flutter Desktop : https://docs.flutter.dev/platform-integration/windows/building

## ❓ Problèmes courants

### "flutter: command not found"
→ Redémarrez votre terminal après avoir modifié le PATH

### "Android licenses not accepted"
→ Exécutez `flutter doctor --android-licenses` et acceptez tout

### "Visual Studio not found"
→ Installez Visual Studio 2022 avec "Desktop development with C++"

### Erreur de certificat réseau
→ Si derrière un proxy, configurez :
```powershell
$env:http_proxy="http://proxy:port"
$env:https_proxy="http://proxy:port"
```

## 🎯 Prêt à développer !

Une fois tous les points de `flutter doctor` validés, vous pouvez :

1. Ouvrir le projet dans VS Code
2. Installer l'extension Flutter/Dart pour VS Code
3. Appuyer sur F5 pour lancer en mode debug
4. Commencer à coder ! 🚀

---

**XR Tech Tools** - Guide d'installation Flutter
