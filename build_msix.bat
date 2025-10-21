@echo off
REM Script de build automatique pour XR Tech Tools (Windows)
REM Double-cliquez sur ce fichier pour lancer le build complet

echo ========================================
echo   XR Tech Tools - Build MSIX
echo ========================================
echo.

REM Vérification que Flutter est installé
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Flutter n'est pas installe ou pas dans le PATH
    echo Installez Flutter: https://flutter.dev
    pause
    exit /b 1
)

echo [1/4] Nettoyage des builds precedents...
flutter clean
echo.

echo [2/4] Installation des dependances...
flutter pub get
echo.

echo [3/4] Build Windows en mode Release...
flutter build windows --release
if %errorlevel% neq 0 (
    echo [ERREUR] Echec du build Windows
    pause
    exit /b 1
)
echo.

echo [4/4] Creation du package MSIX...
flutter pub run msix:create
if %errorlevel% neq 0 (
    echo [ERREUR] Echec de la creation MSIX
    pause
    exit /b 1
)
echo.

echo ========================================
echo   BUILD TERMINE AVEC SUCCES !
echo ========================================
echo.
echo Le fichier MSIX se trouve dans:
echo build\windows\x64\runner\Release\
echo.
echo Pour installer: Double-cliquez sur le fichier .msix
echo.

REM Ouvrir l'explorateur dans le dossier de sortie
explorer build\windows\x64\runner\Release\

pause