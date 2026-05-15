$ErrorActionPreference = "Stop"

if (-not (Test-Path "./logs")) {
    New-Item -ItemType Directory -Path "./logs" | Out-Null
}

Start-Transcript -Path "./logs/deploy-$(Get-Date -Format yyyyMMdd-HHmmss).log"

try {
    . ./config/variables.ps1
    . ./scripts/01-resource-group.ps1
    . ./scripts/02-networking.ps1
    . ./scripts/03-security.ps1
    . ./scripts/04-vm-web.ps1
    . ./scripts/05-vm-app.ps1

    Write-Host "Deployment completed successfully."
}
catch {
    Write-Error $_
}
finally {
    Stop-Transcript
}
