function Test-VMHealth {
    param([hashtable]$Config)
    
    Write-Host "`n=== VM Health Check ===" -ForegroundColor Cyan
    
    foreach ($vmName in $Config.WebVms) {
        Write-Host "`nChecking $vmName..." -ForegroundColor Yellow
        
        # Check if VM is running
        $vm = Get-AzVM -ResourceGroupName $Config.ResourceGroup -Name $vmName -Status
        Write-Host "  Status: $($vm.Statuses[1].Code)"
        
        # Check NGINX status
        $script = "systemctl is-active nginx"
        $result = Invoke-AzVMRunCommand -ResourceGroupName $Config.ResourceGroup `
            -Name $vmName -CommandId 'RunShellScript' -ScriptString $script
        
        Write-Host "  NGINX Status: $($result.Value[0].Message.Trim())"
        
        # Test local access
        $script = "curl -s -o /dev/null -w '%{http_code}' http://localhost"
        $result = Invoke-AzVMRunCommand -ResourceGroupName $Config.ResourceGroup `
            -Name $vmName -CommandId 'RunShellScript' -ScriptString $script
        
        Write-Host "  Local HTTP Response: $($result.Value[0].Message.Trim())"
        
        # Get private IP
        $nic = Get-AzNetworkInterface -ResourceGroupName $Config.ResourceGroup | 
            Where-Object { $_.VirtualMachine.Id -match $vmName }
        $privateIp = $nic.IpConfigurations[0].PrivateIpAddress
        Write-Host "  Private IP: $privateIp"
    }
    
    # Check Load Balancer
    Write-Host "`n=== Load Balancer Status ===" -ForegroundColor Yellow
    $lb = Get-AzLoadBalancer -Name $Config.LoadBalancerName -ResourceGroupName $Config.ResourceGroup
    
    # Check probe
    $probe = Get-AzLoadBalancerProbeConfig -LoadBalancer $lb -Name $Config.ProbeName
    Write-Host "  Probe: $($probe.Protocol) on port $($probe.Port)"
    
    # Check backend pool members
    $backendPool = Get-AzLoadBalancerBackendAddressPoolConfig -LoadBalancer $lb -Name $Config.BackendPoolName
    Write-Host "  Backend Pool Members: $($backendPool.BackendIpConfigurations.Count)"
    
    # Get LB public IP
    $pip = Get-AzPublicIpAddress -ResourceGroupName $Config.ResourceGroup -Name $Config.PublicIpName
    Write-Host "`n  Load Balancer Public IP: $($pip.IpAddress)"
    Write-Host "  Test with: curl http://$($pip.IpAddress)"
}