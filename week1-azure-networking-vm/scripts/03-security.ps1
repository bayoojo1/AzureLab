Write-Host "Creating NSG and security rules..."

$nsg = Get-AzNetworkSecurityGroup `
    -Name $WebNsgName `
    -ResourceGroupName $ResourceGroup `
    -ErrorAction SilentlyContinue

if (-not $nsg) {
    $nsg = New-AzNetworkSecurityGroup `
        -ResourceGroupName $ResourceGroup `
        -Location $Location `
        -Name $WebNsgName

    $nsg = Add-AzNetworkSecurityRuleConfig `
        -Name "Allow-HTTP" `
        -NetworkSecurityGroup $nsg `
        -Description "Allow HTTP" `
        -Access Allow `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority 100 `
        -SourceAddressPrefix * `
        -SourcePortRange * `
        -DestinationAddressPrefix * `
        -DestinationPortRange 80

    $nsg = Add-AzNetworkSecurityRuleConfig `
        -Name "Allow-SSH" `
        -NetworkSecurityGroup $nsg `
        -Description "Allow SSH" `
        -Access Allow `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority 110 `
        -SourceAddressPrefix * `
        -SourcePortRange * `
        -DestinationAddressPrefix * `
        -DestinationPortRange 22

    $nsg | Set-AzNetworkSecurityGroup
}

# Associate NSG to web subnet
$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup
$nsg = Get-AzNetworkSecurityGroup -Name $WebNsgName -ResourceGroupName $ResourceGroup

Set-AzVirtualNetworkSubnetConfig `
    -VirtualNetwork $vnet `
    -Name $WebSubnetName `
    -AddressPrefix $WebSubnetPrefix `
    -NetworkSecurityGroup $nsg

$vnet | Set-AzVirtualNetwork
