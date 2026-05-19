. ./config/variables.ps1

$ip = (Get-AzPublicIpAddress -ResourceGroupName $Config.ResourceGroup -Name $Config.PublicIpName).IpAddress
Write-Host "Browse to: http://$ip"

Get-AzLoadBalancer -ResourceGroupName $Config.ResourceGroup -Name $Config.LoadBalancerName |
    Select-Object Name, ProvisioningState
