# Script PowerShell pour autoriser le port 8000 dans le pare-feu Windows
# À exécuter en tant qu'administrateur

Write-Host "Ajout d'une règle de pare-feu pour le port 8000..." -ForegroundColor Yellow

# Ajouter une règle pour autoriser le port 8000 (TCP) en entrée
netsh advfirewall firewall add rule name="Docker Backend Port 8000" dir=in action=allow protocol=TCP localport=8000

Write-Host "✅ Règle de pare-feu ajoutée avec succès !" -ForegroundColor Green
Write-Host "Le port 8000 est maintenant accessible depuis votre réseau local." -ForegroundColor Green

