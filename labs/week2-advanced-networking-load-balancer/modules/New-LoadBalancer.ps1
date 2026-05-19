function New-LoadBalancer {
    param($Config)

    if (Get-AzLoadBalancer -Name $Config.LoadBalancerName -ResourceGroupName $Config.ResourceGroup -ErrorAction SilentlyContinue) {
        return
    }

    $pip = New-AzPublicIpAddress -ResourceGroupName $Config.ResourceGroup -Location $Config.Location -Name $Config.PublicIpName -AllocationMethod Static -Sku Standard
    $frontend = New-AzLoadBalancerFrontendIpConfig -Name $Config.FrontendName -PublicIpAddress $pip
    $backend = New-AzLoadBalancerBackendAddressPoolConfig -Name $Config.BackendPoolName
    $probe = New-AzLoadBalancerProbeConfig -Name $Config.ProbeName -Protocol Tcp -Port 80 -IntervalInSeconds 15 -ProbeCount 2
    $rule = New-AzLoadBalancerRuleConfig -Name $Config.RuleName -FrontendIpConfiguration $frontend -BackendAddressPool $backend -Probe $probe -Protocol Tcp -FrontendPort 80 -BackendPort 80

    New-AzLoadBalancer `
        -ResourceGroupName $Config.ResourceGroup `
        -Location $Config.Location `
        -Name $Config.LoadBalancerName `
        -Sku Standard `
        -FrontendIpConfiguration $frontend `
        -BackendAddressPool $backend `
        -Probe $probe `
        -LoadBalancingRule $rule | Out-Null
}
