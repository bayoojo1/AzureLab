function Add-BackendPoolMembers {
    param($Config)

    $lb = Get-AzLoadBalancer -Name $Config.LoadBalancerName -ResourceGroupName $Config.ResourceGroup
    $backendPool = $lb.BackendAddressPools[0]

    $nics = Get-AzNetworkInterface -ResourceGroupName $Config.ResourceGroup |
        Where-Object {
            $_.VirtualMachine -and
            ($Config.WebVms -contains ($_.VirtualMachine.Id.Split('/')[-1]))
        }

    foreach ($nic in $nics) {
        $nic.IpConfigurations[0].LoadBalancerBackendAddressPools = @($backendPool)
        $nic | Set-AzNetworkInterface | Out-Null
    }
}
