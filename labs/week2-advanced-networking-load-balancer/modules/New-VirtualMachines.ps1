function New-VirtualMachines {
    param([hashtable]$Config, [pscredential]$Credential)
    
    $PreferredVmSizes = @('Standard_D2s_v3', 'Standard_D2s_v5', 'Standard_B1ms', 'Standard_B1s')
    
    if ($Config.ContainsKey('VmSize') -and $Config.VmSize) {
        $PreferredVmSizes = @($Config.VmSize) + ($PreferredVmSizes | Where-Object { $_ -ne $Config.VmSize })
    }
    
    $allVms = @() + $Config.WebVms
    if ($Config.AppVm) { $allVms += $Config.AppVm }
    
    foreach ($vmName in $allVms) {
        if (Get-AzVM -ResourceGroupName $Config.ResourceGroup -Name $vmName -ErrorAction SilentlyContinue) {
            Write-Host "$vmName already exists. Skipping..." -ForegroundColor Yellow
            continue
        }
        
        $subnetName = if ($Config.WebVms -contains $vmName) { $Config.WebSubnetName } else { $Config.AppSubnetName }
        $vmCreated = $false
        
        foreach ($vmSize in $PreferredVmSizes) {
            Write-Host "Attempting to deploy $vmName with size $vmSize..." -ForegroundColor Cyan
            try {
                New-AzVM -ResourceGroupName $Config.ResourceGroup `
                    -Location $Config.Location -Name $vmName `
                    -VirtualNetworkName $Config.VnetName -SubnetName $subnetName `
                    -Credential $Credential -Image $Config.Image -Size $vmSize `
                    -PublicIpAddressName "$vmName-pip" -OpenPorts @() | Out-Null
                
                Write-Host "$vmName deployed successfully using $vmSize." -ForegroundColor Green
                $vmCreated = $true
                break
            } catch {
                Write-Host "Failed with size ${vmSize}: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
        
        if (-not $vmCreated) {
            throw "Unable to deploy $vmName. All VM sizes failed."
        }
        
        # CRITICAL: Remove automatically created NSG from NIC
        $nic = Get-AzNetworkInterface -ResourceGroupName $Config.ResourceGroup | 
            Where-Object { $_.VirtualMachine.Id -match $vmName }
        
        if ($nic.NetworkSecurityGroup) {
            $nic.NetworkSecurityGroup = $null
            $nic | Set-AzNetworkInterface | Out-Null
            Write-Host "Removed direct NSG from $vmName" -ForegroundColor Yellow
        }
    }
}