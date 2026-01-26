$files = @(
    "src/app/components/pages/dashboard/dashboard.component.html",
    "src/app/components/items/modals/create-collecte/create-collecte.component.html",
    "src/app/components/items/sidebar/sidebar.component.html"
)

Write-Host "Converting files from UTF-16 to UTF-8..."

foreach ($file in $files) {
    if (Test-Path $file) {
        try {
            $content = Get-Content $file -Encoding Unicode -Raw
            $utf8 = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText((Resolve-Path $file), $content, $utf8)
            Write-Host "OK: $file"
        }
        catch {
            Write-Host "ERROR: $file - $_"
        }
    }
    else {
        Write-Host "NOT FOUND: $file"
    }
}

Write-Host "Done!"
