@{
    RootModule        = 'ResourceLocker.psm1'
    ModuleVersion     = '1.1.0'
    GUID              = 'd8b0a333-adf5-4969-a084-bdca923a56b9'
    Author            = 'Kirill Nikolaev'
    CompanyName       = 'Fozzy Inc.'
    Copyright         = '(c) 2018 Fozzy Inc. All rights reserved.'
    PowerShellVersion = '3.0'
    Description = 'A network host synchronization framework that helps to prevent unexpected downtime during maintenance.'
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
    PrivateData       = @{
        PSData = @{
            Tags         = @()
            LicenseUri   = 'https://github.com/FozzyHosting/ResourceLocker/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/FozzyHosting/ResourceLocker/'
            ReleaseNotes = ''    
        }  
    }
}