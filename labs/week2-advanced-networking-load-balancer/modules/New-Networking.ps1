function New-Networking {
    param($Config)

    $vnet = Get-AzVirtualNetwork -Name $Config.VnetName -ResourceGroupName $Config.ResourceGroup -ErrorAction SilentlyContinue

    if (-not $vnet) {
        $vnet = New-AzVirtualNetwork `
            -ResourceGroupName $Config.ResourceGroup `
            -Location $Config.Location `
            -Name $Config.VnetName `
            -AddressPrefix $Config.AddressSpace

        $vnet = Add-AzVirtualNetworkSubnetConfig -Name $Config.WebSubnetName -VirtualNetwork $vnet -AddressPrefix $Config.WebSubnetPrefix
        $vnet = Add-AzVirtualNetworkSubnetConfig -Name $Config.AppSubnetName -VirtualNetwork $vnet -AddressPrefix $Config.AppSubnetPrefix

        $vnet | Set-AzVirtualNetwork | Out-Null
    }
}
