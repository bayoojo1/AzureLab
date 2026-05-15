Write-Host "Creating virtual network and subnets..."

$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup -ErrorAction SilentlyContinue

if (-not $vnet) {
    $vnet = New-AzVirtualNetwork `
        -ResourceGroupName $ResourceGroup `
        -Location $Location `
        -Name $VnetName `
        -AddressPrefix $AddressSpace

    $vnet = Add-AzVirtualNetworkSubnetConfig `
        -Name $WebSubnetName `
        -VirtualNetwork $vnet `
        -AddressPrefix $WebSubnetPrefix

    $vnet = Add-AzVirtualNetworkSubnetConfig `
        -Name $AppSubnetName `
        -VirtualNetwork $vnet `
        -AddressPrefix $AppSubnetPrefix

    $vnet | Set-AzVirtualNetwork
}
else {
    Write-Host "Virtual network already exists."
}
