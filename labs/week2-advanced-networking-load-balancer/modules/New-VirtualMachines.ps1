function New-VirtualMachines {
    param(
        [hashtable]$Config,
        [pscredential]$Credential
    )

    $allVms = @()
    $allVms += $Config.WebVms
    $allVms += $Config.AppVm

    foreach ($vmName in $allVms) {

        # Skip if VM already exists
        if (Get-AzVM -ResourceGroupName $Config.ResourceGroup `
                     -Name $vmName `
                     -ErrorAction SilentlyContinue) {
            Write-Host "$vmName already exists. Skipping..."
            continue
        }

        # Determine subnet
        if ($Config.WebVms -contains $vmName) {
            $subnetName = $Config.WebSubnetName
        }
        else {
            $subnetName = $Config.AppSubnetName
        }

        Write-Host "Creating VM: $vmName"

        New-AzVM `
            -ResourceGroupName $Config.ResourceGroup `
            -Location $Config.Location `
            -Name $vmName `
            -VirtualNetworkName $Config.VnetName `
            -SubnetName $subnetName `
            -Credential $Credential `
            -Image $Config.Image `
            -Size $Config.VmSize `
            -OpenPorts @() `
            | Out-Null
    }

    # Remove public IP from app VM if one was created automatically
    Write-Host "Ensuring app VM has no public IP..."

    $appNic = Get-AzNetworkInterface -ResourceGroupName $Config.ResourceGroup |
        Where-Object {
            $_.VirtualMachine -and
            $_.VirtualMachine.Id -match "/$($Config.AppVm)$"
        }

    if ($appNic -and $appNic.IpConfigurations[0].PublicIpAddress) {
        $appNic.IpConfigurations[0].PublicIpAddress = $null
        $appNic | Set-AzNetworkInterface | Out-Null
        Write-Host "Removed public IP from $($Config.AppVm)"
    }
}
