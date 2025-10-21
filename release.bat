@echo off
setlocal enabledelayedexpansion

REM Script de publication automatique pour XR Tech Tools (Windows)
REM Usage: release.bat [VERSION] [DESCRIPTION]
REM Exemple: release.bat 1.3.1 "Correction bugs + nouvelle fonctionnalite"

echo.
echo ========================================
echo   XR Tech Tools - Release Creator
echo ========================================
echo.

REM Verification des arguments
if "%~1"=="" (
    echo [ERREUR] Version manquante !
    echo.
    echo Usage: release.bat [VERSION] [DESCRIPTION]
    echo.
    echo Exemples:
    echo   release.bat 1.3.1 "Correction bugs"
    echo   release.bat 1.4.0 "Nouveau module QCM"
    echo   release.bat 2.0.0 "Refonte complete"
    echo.
    pause
    exit /b 1
)

set VERSION=%~1
set DESCRIPTION=%~2
if "%DESCRIPTION%"=="" set DESCRIPTION=Release v%VERSION%
set TAG=v%VERSION%

echo [INFO] Configuration de la release
echo    Version : %VERSION%
echo    Tag     : %TAG%
echo    Message : %DESCRIPTION%
echo.

REM Verification que Git est installe
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Git n'est pas installe ou pas dans le PATH
    echo Installez Git: https://git-scm.com
    pause
    exit /b 1
)

REM Verification de l'etat Git
echo [1/6] Verification de l'etat Git...
git status --porcelain > temp_status.txt
set /p GIT_STATUS=<temp_status.txt
del temp_status.txt

if not "%GIT_STATUS%"=="" (
    echo [ATTENTION] Modifications non commitees detectees
    echo.
    git status --short
    echo.
    set /p REPLY="Voulez-vous commiter automatiquement ? (o/n) "
    if /i "!REPLY!"=="o" (
        echo [INFO] Commit automatique des modifications...
        git add .
        git commit -m "chore: preparation release v%VERSION%"
        echo [OK] Modifications commitees
    ) else (
        echo [ERREUR] Veuillez commiter vos modifications avant de continuer
        pause
        exit /b 1
    )
) else (
    echo [OK] Depot Git propre
)
echo.

REM Verification que le tag n'existe pas
echo [2/6] Verification du tag...
git rev-parse %TAG% >nul 2>&1
if %errorlevel% equ 0 (
    echo [ATTENTION] Le tag %TAG% existe deja !
    echo.
    set /p REPLY="Voulez-vous le supprimer et recreer ? (o/n) "
    if /i "!REPLY!"=="o" (
        echo [INFO] Suppression du tag existant...
        git tag -d %TAG%
        git push origin :refs/tags/%TAG% 2>nul
        echo [OK] Tag supprime
    ) else (
        exit /b 1
    )
) else (
    echo [OK] Tag disponible
)
echo.

REM Verification connexion GitHub
echo [3/6] Verification de la connexion GitHub...
git remote -v | findstr /C:"github.com" >nul
if %errorlevel% neq 0 (
    echo [ERREUR] Aucun remote GitHub trouve
    pause
    exit /b 1
)
echo [OK] Connecte a GitHub
echo.

REM Push vers main
echo [4/6] Push vers origin/main...
for /f "tokens=*" %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i
if not "%CURRENT_BRANCH%"=="main" if not "%CURRENT_BRANCH%"=="master" (
    echo [ATTENTION] Vous n'etes pas sur la branche main/master
    echo Branche actuelle: %CURRENT_BRANCH%
    set /p REPLY="Continuer quand meme ? (o/n) "
    if /i not "!REPLY!"=="o" exit /b 1
)

git push origin %CURRENT_BRANCH%
if %errorlevel% neq 0 (
    echo [ERREUR] Echec du push vers GitHub
    pause
    exit /b 1
)
echo [OK] Code pousse vers GitHub
echo.

REM Creation du tag
echo [5/6] Creation du tag %TAG%...
git tag -a %TAG% -m "%DESCRIPTION%"
if %errorlevel% neq 0 (
    echo [ERREUR] Echec de la creation du tag
    pause
    exit /b 1
)
echo [OK] Tag cree localement
echo.

REM Push du tag
echo [6/6] Push du tag vers GitHub...
git push origin %TAG%
if %errorlevel% neq 0 (
    echo [ERREUR] Echec du push du tag
    pause
    exit /b 1
)
echo [OK] Tag pousse vers GitHub
echo.

REM Resume final
echo ========================================
echo      RELEASE LANCEE AVEC SUCCES !
echo ========================================
echo.
echo Version : %VERSION%
echo Tag     : %TAG%
echo Message : %DESCRIPTION%
echo.
echo GitHub Actions en cours d'execution...
echo.
echo Le workflow va :
echo   1. Mettre a jour pubspec.yaml
echo   2. Builder Windows (MSIX + ZIP)
echo   3. Builder Android (APK)
echo   4. Generer les checksums
echo   5. Creer la release GitHub
echo.
echo Duree estimee : 10-15 minutes
echo.
echo Liens utiles :
echo   - Workflow : https://github.com/WolwX/xr-tech-tools/actions
echo   - Releases : https://github.com/WolwX/xr-tech-tools/releases/tag/%TAG%
echo.
echo Tout est pret ! Surveillez le build sur GitHub Actions
echo.

REM Proposer d'ouvrir le navigateur
set /p OPEN_BROWSER="Ouvrir GitHub Actions dans le navigateur ? (o/n) "
if /i "%OPEN_BROWSER%"=="o" (
    start https://github.com/WolwX/xr-tech-tools/actions
)

pause