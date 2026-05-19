function New-ResourceGroup {
    param($Config)

    if (-not (Get-AzResourceGroup -Name $Config.ResourceGroup -ErrorAction SilentlyContinue)) {
        New-AzResourceGroup -Name $Config.ResourceGroup -Location $Config.Location | Out-Null
    }
}
