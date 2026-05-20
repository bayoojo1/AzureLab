function Install-Nginx {
    param([hashtable]$Config)
    
    foreach ($vmName in $Config.WebVms) {
        Write-Host "Installing NGINX on $vmName..." -ForegroundColor Cyan
        
        $script = @"
sudo apt-get update -y
sudo apt-get install -y nginx
echo '<h1>Hello from $vmName</h1>' | sudo tee /var/www/html/index.html
sudo systemctl enable nginx
sudo systemctl restart nginx
"@
        Invoke-AzVMRunCommand -ResourceGroupName $Config.ResourceGroup `
            -Name $vmName -CommandId 'RunShellScript' -ScriptString $script | Out-Null
        
        Write-Host "NGINX installed on $vmName." -ForegroundColor Green
    }
}