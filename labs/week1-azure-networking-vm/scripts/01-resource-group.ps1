Write-Host "Creating resource group..."

if (-not (Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $ResourceGroup -Location $Location
}
else {
    Write-Host "Resource group already exists."
}
