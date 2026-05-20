# Main deployment script
. .\config\variables.ps1
Get-ChildItem -Path "modules" -Filter "*.ps1" | ForEach-Object { . $_.FullName }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Azure Load Balancer Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

New-ResourceGroup -Config $Config
New-Networking -Config $Config
New-Security -Config $Config
New-LoadBalancer -Config $Config

$password = Read-Host "Enter password for VMs" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential($Config.AdminUsername, $password)
New-VirtualMachines -Config $Config -Credential $credential

Add-BackendPoolMembers -Config $Config
Install-Nginx -Config $Config

$pip = (Get-AzPublicIpAddress -ResourceGroupName $Config.ResourceGroup -Name $Config.PublicIpName).IpAddress
Write-Host "`nLoad Balancer Public IP: $pip" -ForegroundColor Green
Write-Host "Test with: curl http://$pip" -ForegroundColor Yellow