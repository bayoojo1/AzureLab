function New-Networking {
    param([hashtable]$Config)
    
    Write-Host "Creating virtual network and subnets..." -ForegroundColor Cyan
    
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $Config.ResourceGroup -Name $Config.VnetName -ErrorAction SilentlyContinue
    
    if (-not $vnet) {
        $webSubnet = New-AzVirtualNetworkSubnetConfig -Name $Config.WebSubnetName -AddressPrefix $Config.WebSubnetPrefix
        $appSubnet = New-AzVirtualNetworkSubnetConfig -Name $Config.AppSubnetName -AddressPrefix $Config.AppSubnetPrefix
        
        $vnet = New-AzVirtualNetwork -ResourceGroupName $Config.ResourceGroup `
            -Location $Config.Location -Name $Config.VnetName `
            -AddressPrefix $Config.AddressSpace -Subnet $webSubnet, $appSubnet
        
        Write-Host "Virtual network created successfully." -ForegroundColor Green
    } else {
        Write-Host "Virtual network already exists." -ForegroundColor Yellow
    }
}