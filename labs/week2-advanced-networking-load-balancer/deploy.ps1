$ErrorActionPreference = 'Stop'

. ./config/variables.ps1
Get-ChildItem ./modules/*.ps1 | ForEach-Object { . $_.FullName }

if (-not (Test-Path './logs')) {
    New-Item -ItemType Directory -Path './logs' | Out-Null
}

Start-Transcript -Path "./logs/deploy-$(Get-Date -Format yyyyMMdd-HHmmss).log"

try {
    $cred = Get-Credential -UserName $Config.AdminUsername -Message 'Enter VM administrator password'

    New-ResourceGroup -Config $Config
    New-Networking -Config $Config
    New-Security -Config $Config
    New-VirtualMachines -Config $Config -Credential $cred
    Install-Nginx -Config $Config
    New-LoadBalancer -Config $Config
    Add-BackendPoolMembers -Config $Config

    Write-Host 'Deployment completed successfully.' -ForegroundColor Green
}
finally {
    Stop-Transcript
}
