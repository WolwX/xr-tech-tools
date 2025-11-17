# Script pour lancer XR Tech Tools sur Chrome avec Flutter

Write-Host "=== Lancement de XR Tech Tools sur Chrome ===" -ForegroundColor Cyan

# Ajouter Flutter au PATH pour cette session
$env:Path = "C:\flutter\bin;" + $env:Path

# Vérifier que Flutter est installé
if (-not (Test-Path "C:\flutter\bin\flutter.bat")) {
    Write-Host "ERREUR : Flutter n'est pas installé dans C:\flutter" -ForegroundColor Red
    Write-Host "Veuillez installer Flutter d'abord :" -ForegroundColor Yellow
    Write-Host "  1. Téléchargez : https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Yellow
    Write-Host "  2. Extrayez dans C:\flutter" -ForegroundColor Yellow
    Write-Host "  3. Relancez ce script" -ForegroundColor Yellow
    exit 1
}

Write-Host "Flutter trouvé ! Vérification de la version..." -ForegroundColor Green
flutter --version

Write-Host "`nActivation du support Web..." -ForegroundColor Green
flutter config --enable-web

Write-Host "`nInstallation des dépendances..." -ForegroundColor Green
flutter pub get

Write-Host "`nListe des appareils disponibles :" -ForegroundColor Green
flutter devices

Write-Host "`n=== Lancement sur Chrome ===" -ForegroundColor Cyan
Write-Host "L'application va s'ouvrir dans Chrome..." -ForegroundColor Green
Write-Host "Appuyez sur 'r' pour hot reload, 'R' pour hot restart, 'q' pour quitter" -ForegroundColor Yellow
Write-Host ""

flutter run -d chrome
