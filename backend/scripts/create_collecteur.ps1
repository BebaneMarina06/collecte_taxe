# Script PowerShell pour créer un collecteur via l'API
# Usage: .\create_collecteur.ps1
# 
# ⚠️ IMPORTANT : Modifiez les informations ci-dessous avant d'exécuter le script

# ============================================
# CONFIGURATION - MODIFIEZ CES VALEURS
# ============================================

# Informations de connexion à l'API
$ApiUrl = "https://votre-app.onrender.com"  # Remplacez par l'URL de votre API Render
$AdminEmail = "admin@example.com"            # Email de l'administrateur
$AdminPassword = "votre_mot_de_passe"        # Mot de passe de l'administrateur

# Informations du collecteur à créer
$CollecteurNom = "MBOUMBA"
$CollecteurPrenom = "Jean"
$CollecteurEmail = "jean.mboumba@mairie-libreville.ga"
$CollecteurTelephone = "+241062345678"
$CollecteurMatricule = "COL-001"
$ZoneId = 1                                  # ID de la zone (1 par défaut, modifiez si nécessaire)
$Latitude = 0.3901                           # Latitude GPS (Libreville par défaut)
$Longitude = 9.4544                          # Longitude GPS (Libreville par défaut)
$HeureCloture = "18:00"                      # Heure de clôture (format HH:MM)

# ============================================
# SCRIPT - NE PAS MODIFIER CI-DESSOUS
# ============================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Création d'un Collecteur via l'API" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Étape 1 : Se connecter et obtenir un token
Write-Host "🔐 Connexion à l'API..." -ForegroundColor Cyan
Write-Host "   URL: $ApiUrl" -ForegroundColor Gray
Write-Host "   Email: $AdminEmail" -ForegroundColor Gray

$loginBody = @{
    username = $AdminEmail
    password = $AdminPassword
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$ApiUrl/api/auth/login" `
        -Method POST `
        -ContentType "application/x-www-form-urlencoded" `
        -Body $loginBody
    
    $token = $loginResponse.access_token
    Write-Host "✅ Connexion réussie !" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur de connexion : $_" -ForegroundColor Red
    exit 1
}

# Étape 2 : Créer le collecteur
Write-Host ""
Write-Host "👤 Création du collecteur..." -ForegroundColor Cyan
Write-Host "   Nom: $CollecteurNom $CollecteurPrenom" -ForegroundColor Gray
Write-Host "   Email: $CollecteurEmail" -ForegroundColor Gray
Write-Host "   Matricule: $CollecteurMatricule" -ForegroundColor Gray
Write-Host "   Zone ID: $ZoneId" -ForegroundColor Gray

$collecteurBody = @{
    nom = $CollecteurNom
    prenom = $CollecteurPrenom
    email = $CollecteurEmail
    telephone = $CollecteurTelephone
    matricule = $CollecteurMatricule
    zone_id = $ZoneId
}

# Ajouter les champs optionnels s'ils sont fournis
if ($Latitude) {
    $collecteurBody["latitude"] = $Latitude
}

if ($Longitude) {
    $collecteurBody["longitude"] = $Longitude
}

if ($HeureCloture) {
    $collecteurBody["heure_cloture"] = $HeureCloture
}

$collecteurBodyJson = $collecteurBody | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

try {
    $result = Invoke-RestMethod -Uri "$ApiUrl/api/collecteurs" `
        -Method POST `
        -Headers $headers `
        -Body $collecteurBodyJson
    
    Write-Host ""
    Write-Host "✅ Collecteur créé avec succès !" -ForegroundColor Green
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "📋 Détails du collecteur créé :" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "ID: $($result.id)" -ForegroundColor White
    Write-Host "Nom: $($result.nom) $($result.prenom)" -ForegroundColor White
    Write-Host "Email: $($result.email)" -ForegroundColor White
    Write-Host "Téléphone: $($result.telephone)" -ForegroundColor White
    Write-Host "Matricule: $($result.matricule)" -ForegroundColor White
    Write-Host "Statut: $($result.statut)" -ForegroundColor White
    Write-Host "État: $($result.etat)" -ForegroundColor White
    Write-Host "Zone ID: $($result.zone_id)" -ForegroundColor White
    if ($result.heure_cloture) {
        Write-Host "Heure de clôture: $($result.heure_cloture)" -ForegroundColor White
    }
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Le collecteur peut maintenant se connecter à l'application mobile avec:" -ForegroundColor Yellow
    Write-Host "   Email: $CollecteurEmail" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "❌ Erreur lors de la création : $_" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host ""
        Write-Host "Détails de l'erreur :" -ForegroundColor Yellow
        $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($errorDetails) {
            Write-Host "  Message: $($errorDetails.detail)" -ForegroundColor Yellow
        } else {
            Write-Host "  $($_.ErrorDetails.Message)" -ForegroundColor Yellow
        }
    }
    Write-Host ""
    Write-Host "💡 Vérifiez que:" -ForegroundColor Cyan
    Write-Host "   - L'URL de l'API est correcte" -ForegroundColor Gray
    Write-Host "   - Les identifiants admin sont corrects" -ForegroundColor Gray
    Write-Host "   - Le matricule et l'email sont uniques" -ForegroundColor Gray
    Write-Host "   - La zone ID existe dans la base de données" -ForegroundColor Gray
    exit 1
}

