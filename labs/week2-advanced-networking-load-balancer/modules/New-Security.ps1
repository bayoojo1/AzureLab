function New-Security {
    param($Config)

    $nsg = Get-AzNetworkSecurityGroup -Name $Config.WebNsgName -ResourceGroupName $Config.ResourceGroup -ErrorAction SilentlyContinue

    if (-not $nsg) {
        $nsg = New-AzNetworkSecurityGroup `
            -ResourceGroupName $Config.ResourceGroup `
            -Location $Config.Location `
            -Name $Config.WebNsgName

        $nsg = Add-AzNetworkSecurityRuleConfig -Name 'Allow-HTTP' -NetworkSecurityGroup $nsg -Direction Inbound -Priority 100 -Access Allow -Protocol Tcp -SourceAddressPrefix '*' -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange 80
        $nsg = Add-AzNetworkSecurityRuleConfig -Name 'Allow-SSH'  -NetworkSecurityGroup $nsg -Direction Inbound -Priority 110 -Access Allow -Protocol Tcp -SourceAddressPrefix '*' -SourcePortRange '*' -DestinationAddressPrefix '*' -DestinationPortRange 22

        $nsg | Set-AzNetworkSecurityGroup | Out-Null
    }
}
