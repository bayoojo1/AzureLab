function New-Security {
    param([hashtable]$Config)
    
    Write-Host "Creating Network Security Group..." -ForegroundColor Cyan
    
    $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $Config.ResourceGroup -Name $Config.WebNsgName -ErrorAction SilentlyContinue
    
    if (-not $nsg) {
        $nsg = New-AzNetworkSecurityGroup -ResourceGroupName $Config.ResourceGroup `
            -Location $Config.Location -Name $Config.WebNsgName
        
        $nsg = Add-AzNetworkSecurityRuleConfig -Name "Allow-HTTP" `
            -NetworkSecurityGroup $nsg -Direction Inbound -Priority 100 `
            -Access Allow -Protocol Tcp -SourceAddressPrefix "*" `
            -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 80
        
        $nsg = Add-AzNetworkSecurityRuleConfig -Name "Allow-SSH" `
            -NetworkSecurityGroup $nsg -Direction Inbound -Priority 110 `
            -Access Allow -Protocol Tcp -SourceAddressPrefix "*" `
            -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 22
        
        $nsg = Add-AzNetworkSecurityRuleConfig -Name "Allow-Azure-LoadBalancer" `
            -NetworkSecurityGroup $nsg -Direction Inbound -Priority 120 `
            -Access Allow -Protocol Tcp -SourceAddressPrefix "AzureLoadBalancer" `
            -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 80
        
        $nsg | Set-AzNetworkSecurityGroup | Out-Null
        Write-Host "NSG created successfully." -ForegroundColor Green
    } else {
        Write-Host "NSG already exists." -ForegroundColor Yellow
    }
    
    Write-Host "Associating NSG with web subnet..." -ForegroundColor Cyan
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $Config.ResourceGroup -Name $Config.VnetName
    $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $Config.ResourceGroup -Name $Config.WebNsgName
    
    Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet `
        -Name $Config.WebSubnetName -AddressPrefix $Config.WebSubnetPrefix `
        -NetworkSecurityGroup $nsg | Out-Null
    
    $vnet | Set-AzVirtualNetwork | Out-Null
    Write-Host "NSG associated with web subnet." -ForegroundColor Green
}