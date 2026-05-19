$ErrorActionPreference = 'Stop'

# Load configuration
. "$PSScriptRoot\config\variables.ps1"

# Load modules explicitly
. "$PSScriptRoot\modules\New-ResourceGroup.ps1"
. "$PSScriptRoot\modules\New-Networking.ps1"
. "$PSScriptRoot\modules\New-Security.ps1"
. "$PSScriptRoot\modules\New-VirtualMachines.ps1"
. "$PSScriptRoot\modules\Install-Nginx.ps1"
. "$PSScriptRoot\modules\New-LoadBalancer.ps1"
. "$PSScriptRoot\modules\Add-BackendPoolMembers.ps1"

# Create logs folder
$LogFolder = Join-Path $PSScriptRoot "logs"
if (-not (Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

# Start transcript
$LogFile = Join-Path $LogFolder ("deploy-{0}.log" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
Start-Transcript -Path $LogFile

try {
    # Prompt for VM credentials
    $Credential = Get-Credential `
        -UserName $Config.AdminUsername `
        -Message "Enter the administrator password for the Ubuntu VMs"

    # Run deployment
    New-ResourceGroup -Config $Config
    New-Networking -Config $Config
    New-Security -Config $Config
    New-VirtualMachines -Config $Config -Credential $Credential
    Install-Nginx -Config $Config
    New-LoadBalancer -Config $Config
    Add-BackendPoolMembers -Config $Config

    Write-Host ""
    Write-Host "Deployment completed successfully." -ForegroundColor Green
    Write-Host "Run .\\validate.ps1 to test the environment." -ForegroundColor Cyan
}
catch {
    Write-Error $_
}
finally {
    Stop-Transcript
}
