@{
    RootModule        = 'ResourceLocker.psm1'
    ModuleVersion     = '1.1.0'
    GUID              = 'd8b0a333-adf5-4969-a084-bdca923a56b9'
    Author            = 'Kirill Nikolaev'
    CompanyName       = 'Fozzy Inc.'
    Copyright         = '(c) 2018 Fozzy Inc. All rights reserved.'
    PowerShellVersion = '3.0'
    FunctionsToExport = @(
        'Get-ResourceDependence'
        'Get-ResourceLockId'
        'Lock-FileResource'
        'Lock-HostResource'
        'Lock-Resource'
        'Test-HostResourceLock'
        'Unlock-Resource'
    )
    CmdletsToExport   = @()
    AliasesToExport   = @()
}