@echo off
setlocal enabledelayedexpansion

REM Script de mise a jour automatique de la version avec date
REM Usage: set_version.bat [MAJEURE] [MINEURE] [PATCH]
REM Exemple: set_version.bat 1 3 2

echo ========================================
echo   XR Tech Tools - Version Setter
echo ========================================
echo.

REM Parametres de version
set MAJOR=%~1
set MINOR=%~2
set PATCH=%~3

REM Valeurs par defaut si non specifiees
if "%MAJOR%"=="" set MAJOR=1
if "%MINOR%"=="" set MINOR=3
if "%PATCH%"=="" set PATCH=1

REM Recupere la date au format YYYYMMDD
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set YEAR=%datetime:~0,4%
set MONTH=%datetime:~4,2%
set DAY=%datetime:~6,2%

REM Date complete pour Flutter (YYYYMMDD)
set FULL_DATE=%YEAR%%MONTH%%DAY%

REM Date courte pour MSIX (MMDD)
set SHORT_DATE=%MONTH%%DAY%

REM Construction des versions
set FLUTTER_VERSION=%MAJOR%.%MINOR%.%PATCH%+%FULL_DATE%
set MSIX_VERSION=%MAJOR%.%MINOR%.%PATCH%.%SHORT_DATE%

echo [INFO] Configuration de la version
echo    Date du jour    : %DAY%/%MONTH%/%YEAR%
echo    Version Flutter : %FLUTTER_VERSION%
echo    Version MSIX    : %MSIX_VERSION%
echo.

REM Verification que pubspec.yaml existe
if not exist pubspec.yaml (
    echo [ERREUR] pubspec.yaml introuvable
    echo Assurez-vous d'etre a la racine du projet
    pause
    exit /b 1
)

REM Backup du fichier
copy pubspec.yaml pubspec.yaml.backup >nul
echo [INFO] Backup cree : pubspec.yaml.backup

REM Mise a jour de la version Flutter
powershell -Command "(Get-Content pubspec.yaml) -replace '^version:.*', 'version: %FLUTTER_VERSION%' | Set-Content pubspec.yaml"

REM Mise a jour de la version MSIX
powershell -Command "(Get-Content pubspec.yaml) -replace 'msix_version:.*', 'msix_version: %MSIX_VERSION%' | Set-Content pubspec.yaml"

echo [OK] pubspec.yaml mis a jour
echo.
echo ========================================
echo   VERSION MISE A JOUR AVEC SUCCES !
echo ========================================
echo.
echo Version Flutter : %FLUTTER_VERSION%
echo    ^> Affichee dans l'application
echo    ^> Format : %MAJOR%.%MINOR%.%PATCH%+AAAAMMJJ
echo.
echo Version MSIX    : %MSIX_VERSION%
echo    ^> Utilisee pour le package Windows
echo    ^> Format : %MAJOR%.%MINOR%.%PATCH%.MMJJ
echo.
echo Prochaines etapes :
echo    1. flutter pub get
echo    2. flutter pub run msix:create
echo.

set /p CONTINUE="Voulez-vous builder le MSIX maintenant ? (o/n) "
if /i "%CONTINUE%"=="o" (
    echo.
    echo [INFO] Lancement du build...
    call build_msix.bat
)

pause