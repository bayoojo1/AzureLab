Write-Host "Deploying web VM..."

$existingVm = Get-AzVM `
    -ResourceGroupName $ResourceGroup `
    -Name $WebVmName `
    -ErrorAction SilentlyContinue

if (-not $existingVm) {
    $cred = Get-Credential -UserName $AdminUsername -Message "Enter password for Azure VM administrator"

    New-AzVM `
        -ResourceGroupName $ResourceGroup `
        -Location $Location `
        -Name $WebVmName `
        -VirtualNetworkName $VnetName `
        -SubnetName $WebSubnetName `
        -SecurityGroupName $WebNsgName `
        -PublicIpAddressName $WebPublicIpName `
        -Credential $cred `
        -Size $VmSize `
        -Image "Win2022Datacenter"
}
else {
    Write-Host "Web VM already exists."
}
