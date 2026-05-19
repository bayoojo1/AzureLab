function New-VirtualMachines {
    param($Config, [pscredential]$Credential)

    $allVms = $Config.WebVms + $Config.AppVm

    foreach ($vmName in $allVms) {
        if (Get-AzVM -ResourceGroupName $Config.ResourceGroup -Name $vmName -ErrorAction SilentlyContinue) {
            continue
        }

        $subnet = if ($Config.WebVms -contains $vmName) { $Config.WebSubnetName } else { $Config.AppSubnetName }
        $nsg = if ($Config.WebVms -contains $vmName) { $Config.WebNsgName } else { $null }

        $params = @{
            ResourceGroupName = $Config.ResourceGroup
            Location          = $Config.Location
            Name              = $vmName
            VirtualNetworkName= $Config.VnetName
            SubnetName        = $subnet
            Credential        = $Credential
            Size              = $Config.VmSize
            Image             = $Config.Image
            OpenPorts         = @()
        }

        if ($nsg) { $params.SecurityGroupName = $nsg }

        New-AzVM @params | Out-Null
    }

    # Remove public IP from app VM
    $appNic = Get-AzNetworkInterface -ResourceGroupName $Config.ResourceGroup |
        Where-Object { $_.VirtualMachine.Id -match "/$($Config.AppVm)$" }

    if ($appNic -and $appNic.IpConfigurations[0].PublicIpAddress) {
 [OOA       $appNic.IpConfigurations[0].PublicIpAddress = $null
        $appNic | Set-AzNetworkInterface | Out-Null
    }
}
