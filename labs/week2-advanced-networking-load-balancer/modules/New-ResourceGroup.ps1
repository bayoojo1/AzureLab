function New-ResourceGroup {
    param($Config)
    
    if (-not (Get-AzResourceGroup -Name $Config.ResourceGroup -ErrorAction SilentlyContinue)) {
        New-AzResourceGroup -Name $Config.ResourceGroup -Location $Config.Location | Out-Null
        Write-Host "Resource group created: $($Config.ResourceGroup)" -ForegroundColor Green
    } else {
        Write-Host "Resource group already exists: $($Config.ResourceGroup)" -ForegroundColor Yellow
    }
}