function Install-Nginx {
    param($Config)

    foreach ($vmName in $Config.WebVms) {
        Invoke-AzVMRunCommand `
            -ResourceGroupName $Config.ResourceGroup `
            -Name $vmName `
            -CommandId 'RunShellScript' `
            -ScriptString @(
                'sudo apt-get update',
                'sudo apt-get install -y nginx',
                "echo '<h1>Hello from $vmName</h1>' | sudo tee /var/www/html/index.html",
                'sudo systemctl enable nginx',
                'sudo systemctl restart nginx'
            ) | Out-Null
    }
}
