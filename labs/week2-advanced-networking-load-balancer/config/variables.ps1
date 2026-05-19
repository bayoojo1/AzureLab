$Config = @{
    ResourceGroup = 'rg-week2-lab'
    Location      = 'ukwest'

    VnetName      = 'vnet-week2'
    AddressSpace  = '10.0.0.0/16'

    WebSubnetName   = 'web-subnet'
    WebSubnetPrefix = '10.0.1.0/24'

    AppSubnetName   = 'app-subnet'
    AppSubnetPrefix = '10.0.2.0/24'

    WebNsgName = 'nsg-web'

    WebVms = @('vm-web-01', 'vm-web-02')
    AppVm  = 'vm-app-01'

    AdminUsername = 'azureadmin'
    VmSize        = 'Standard_B1s'
    Image         = 'Canonical:ubuntu-24_04-lts:server:latest'

    LoadBalancerName = 'lb-web'
    PublicIpName     = 'pip-lb'
    FrontendName     = 'fe-lb'
    BackendPoolName  = 'be-web'
    ProbeName        = 'http-probe'
    RuleName         = 'http-rule'
}
