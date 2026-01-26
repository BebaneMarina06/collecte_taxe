# Script pour convertir les fichiers HTML de UTF-16 vers UTF-8

$files = @(
    "src/app/components/pages/dashboard/dashboard.component.html",
    "src/app/components/items/modals/create-collecte/create-collecte.component.html",
    "src/app/components/items/sidebar/sidebar.component.html"
)

Write-Host "Conversion des fichiers de UTF-16 vers UTF-8..." -ForegroundColor Yellow

foreach ($file in $files) {
    if (Test-Path $file) {
        try {
            # Lire le contenu en UTF-16
            $content = Get-Content $file -Encoding Unicode -Raw

            # Créer un fichier temporaire
            $tempFile = "$file.tmp"

            # Écrire en UTF-8
            [System.IO.File]::WriteAllText($tempFile, $content, [System.Text.UTF8Encoding]::new($false))

            # Remplacer l'ancien fichier
            Move-Item -Path $tempFile -Destination $file -Force

            Write-Host "✓ Converti: $file" -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Erreur lors de la conversion de $file : $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "✗ Fichier non trouvé: $file" -ForegroundColor Red
    }
}

Write-Host "`nConversion terminée!" -ForegroundColor Cyan
