Write-Host "Deploying app VM..."

$existingVm = Get-AzVM `
    -ResourceGroupName $ResourceGroup `
    -Name $AppVmName `
    -ErrorAction SilentlyContinue

if (-not $existingVm) {
    $cred = Get-Credential -UserName $AdminUsername -Message "Enter password for Azure VM administrator"

    New-AzVM `
        -ResourceGroupName $ResourceGroup `
        -Location $Location `
        -Name $AppVmName `
        -VirtualNetworkName $VnetName `
        -SubnetName $AppSubnetName `
        -SecurityGroupName $AppNsgName `
        -PublicIpAddressName $AppPublicIpName `
        -Credential $cred `
        -Size $VmSize `
        -Image "Win2022Datacenter"
}
else {
    Write-Host "Web VM already exists."
}
