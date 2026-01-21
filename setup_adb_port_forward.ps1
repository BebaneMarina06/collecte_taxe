# Script pour configurer le port forwarding USB avec adb
# Assure-toi d'avoir autorisé le débogage USB sur ton téléphone

$adbPath = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

if (-not (Test-Path $adbPath)) {
    Write-Host "❌ ADB non trouvé à: $adbPath" -ForegroundColor Red
    Write-Host "Vérifie que Android Studio est bien installé." -ForegroundColor Yellow
    exit 1
}

Write-Host "Vérification des appareils connectés..." -ForegroundColor Yellow
& $adbPath devices

Write-Host "`nConfiguration du port forwarding (8000 -> 8000)..." -ForegroundColor Yellow
& $adbPath reverse tcp:8000 tcp:8000

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Port forwarding configuré avec succès !" -ForegroundColor Green
    Write-Host "`nDans ton app mobile, utilise maintenant:" -ForegroundColor Cyan
    Write-Host "   http://localhost:8000/api" -ForegroundColor White
    Write-Host "   ou" -ForegroundColor Cyan
    Write-Host "   http://127.0.0.1:8000/api" -ForegroundColor White
} else {
    Write-Host "❌ Erreur lors de la configuration du port forwarding" -ForegroundColor Red
    Write-Host "Assure-toi que:" -ForegroundColor Yellow
    Write-Host "  1. Le téléphone est connecté en USB" -ForegroundColor Yellow
    Write-Host "  2. Le débogage USB est autorisé sur le téléphone" -ForegroundColor Yellow
}

