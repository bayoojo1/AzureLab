function New-LoadBalancer {
    param($Config)
    
    if (Get-AzLoadBalancer -Name $Config.LoadBalancerName -ResourceGroupName $Config.ResourceGroup -ErrorAction SilentlyContinue) {
        Write-Host "Load balancer already exists." -ForegroundColor Yellow
        return
    }
    
    Write-Host "Creating Load Balancer..." -ForegroundColor Cyan
    
    $pip = New-AzPublicIpAddress -ResourceGroupName $Config.ResourceGroup `
        -Location $Config.Location -Name $Config.PublicIpName `
        -AllocationMethod Static -Sku Standard
    
    $lb = New-AzLoadBalancer -ResourceGroupName $Config.ResourceGroup `
        -Location $Config.Location -Name $Config.LoadBalancerName -Sku Standard
    
    $lb | Add-AzLoadBalancerFrontendIpConfig -Name $Config.FrontendName -PublicIpAddress $pip
    $lb | Add-AzLoadBalancerBackendAddressPoolConfig -Name $Config.BackendPoolName
    $lb | Add-AzLoadBalancerProbeConfig -Name $Config.ProbeName `
        -Protocol Http -Port 80 -RequestPath "/" -IntervalInSeconds 5 -ProbeCount 2
    
    $lb = $lb | Set-AzLoadBalancer
    
    $lb = Get-AzLoadBalancer -ResourceGroupName $Config.ResourceGroup -Name $Config.LoadBalancerName
    $frontend = Get-AzLoadBalancerFrontendIpConfig -LoadBalancer $lb -Name $Config.FrontendName
    $backendPool = Get-AzLoadBalancerBackendAddressPoolConfig -LoadBalancer $lb -Name $Config.BackendPoolName
    $probe = Get-AzLoadBalancerProbeConfig -LoadBalancer $lb -Name $Config.ProbeName
    
    $lb | Add-AzLoadBalancerRuleConfig -Name $Config.RuleName `
        -Protocol Tcp -FrontendPort 80 -BackendPort 80 `
        -FrontendIpConfiguration $frontend `
        -BackendAddressPool $backendPool `
        -Probe $probe
    
    $lb | Set-AzLoadBalancer | Out-Null
    
    Write-Host "Load balancer created successfully." -ForegroundColor Green
}