$ErrorActionPreference = 'Stop'

. ./config/variables.ps1

# Load all module functions
Get-ChildItem -Path "./modules/*.ps1" | ForEach-Object {
    . ($_.FullName)
}

# Create logs folder if it does not exist
if (-not (Test-Path './logs')) {
    New-Item -ItemType Directory -Path './logs' | Out-Null
}

# Start logging
Start-Transcript -Path "./logs/deploy-$(Get-Date -Format yyyyMMdd-HHmmss).log"

try {
    # Prompt once for VM credentials
    $cred = Get-Credential `
        -UserName $Config.AdminUsername `
        -Message 'Enter VM administrator password'

    # Deploy resources
    New-ResourceGroup -Config $Config
    New-Networking -Config $Config
    New-Security -Config $Config
    New-VirtualMachines -Config $Config -Credential $cred
    Install-Nginx -Config $Config
    New-LoadBalancer -Config $Config
    Add-BackendPoolMembers -Config $Config

    Write-Host "Deployment completed successfully." -ForegroundColor Green
}
catch {
    Write-Error $_
}
finally {
    Stop-Transcript
}
