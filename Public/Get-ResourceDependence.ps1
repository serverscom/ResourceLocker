function Get-ResourceDependence {
    #Requires -Version 3.0

    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName = 'ByFile', Mandatory)]
        [Parameter(ParameterSetName = 'ByDefinition', Mandatory)]
        [string]$ResourceName,
        [Parameter(ParameterSetName = 'ByFile')]
        [string]$FilePath = $ModuleWideResourceDependenciesFilePath,
        [Parameter(ParameterSetName = 'ByDefinition', Mandatory)]
        [pscustomobject]$ResourceDependencies
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('$PsCmdlet.ParameterSetName: ''{0}''' -f $PsCmdlet.ParameterSetName)
        Write-Debug -Message ('$ResourceName = ''{0}''' -f $ResourceName)
        Write-Debug -Message ('$FilePath = ''{0}''' -f $FilePath)
        Write-Debug -Message ('$ResourceDependencies: ''{0}''' -f [string]$ResourceDependencies)

        Write-Debug -Message ('if (-not {0})' -f [string]$ResourceDependencies)
        if (-not $ResourceDependencies) {
            Write-Debug -Message ('$FilePathLeafExistence = Test-Path -Path ''{0}'' -PathType Leaf' -f $FilePath)
            $FilePathLeafExistence = Test-Path -Path $FilePath -PathType Leaf
            Write-Debug -Message ('if (-not {0})' -f $FilePathLeafExistence)
            if (-not $FilePathLeafExistence) {
                Write-Debug -Message '$ResourceDependencies = [PSCustomObject]@{}'
                $ResourceDependencies = [PSCustomObject]@{}
            }
            else {
                Write-Debug -Message ('$ResourceDependencies = (Get-Content -Path ''{0}'') -join "`n" | ConvertFrom-Json' -f $FilePath)
                $ResourceDependencies = (Get-Content -Path $FilePath) -join "`n" | ConvertFrom-Json
                Write-Debug -Message ('$ResourceDependencies: ''{0}''' -f [string]$ResourceDependencies)
            }
        }
        Write-Debug -Message ('$ResourceNames = (''{0}'' | Get-Member -MemberType NoteProperty).Name' -f [string]$ResourceDependencies)
        $ResourceNames = ($ResourceDependencies | Get-Member -MemberType NoteProperty).Name
        Write-Debug -Message ('$ResourceNames: ''{0}''' -f [string]$ResourceNames)

        Write-Debug -Message '$Result = @()'
        $Result = @()
        foreach ($Item in $ResourceNames) {
            Write-Debug -Message ('$Item = ''{0}''' -f $Item)
            Write-Debug -Message ('if (''{0}'' -in ''{1}'')' -f $ResourceName, $ResourceDependencies.$Item)
            if ($ResourceName -in $ResourceDependencies.$Item) {
                Write-Debug -Message ('$Result += ''{0}''' -f $Item)
                $Result += $Item
                Write-Debug -Message ('$Result: ''{0}''' -f [string]$Result)
            }
        }

        do {
            Write-Debug -Message '$Result2 = @()'
            $Result2 = @()
            foreach ($Item in $Result) {
                Write-Debug -Message ('$Item = ''{0}''' -f $Item)
                foreach ($Name in $ResourceNames) {
                    Write-Debug -Message ('$Name = ''{0}''' -f $Name)
                    Write-Debug -Message ('if (''{0}'' -in ''{1}'' -and ''{2}'' -notin ''{3}'' -and ''{2}'' -ne ''{4}'' -and ''{2}'' -notin ''{5}'')' -f $Item, [string]$ResourceDependencies.$Name, $Name, [string]$Result, $ResourceName, [string]$Result2)
                    if ($Item -in $ResourceDependencies.$Name -and $Name -notin $Result -and $Name -ne $ResourceName -and $Name -notin $Result2) {
                        Write-Debug -Message ('$Result2 += ''{0}''' -f $Name)
                        $Result2 += $Name
                        Write-Debug -Message ('$Result2: ''{0}''' -f [string]$Result2)
                    }
                }
            }
            Write-Debug -Message ('if ({0})' -f [string]$Result2)
            if ($Result2) {
                Write-Debug -Message ('$Result += ''{0}''' -f [string]$Result2)
                $Result += $Result2
            }

            Write-Debug -Message ('while ({0})' -f [string]$Result2)
        }
        while ($Result2)
    
        Write-Debug -Message ('$Result: ''{0}''' -f [string]$Result)
        Write-Debug -Message '$Result'
        $Result

        Write-Debug -Message ('EXIT TRY {0}' -f $MyInvocation.MyCommand.Name)
    }
    catch {
        Write-Debug -Message ('ENTER CATCH {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('{0}: $PSCmdlet.ThrowTerminatingError($_)' -f $MyInvocation.MyCommand.Name)
        $PSCmdlet.ThrowTerminatingError($_)

        Write-Debug -Message ('EXIT CATCH {0}' -f $MyInvocation.MyCommand.Name)
    }

    Write-Debug -Message ('EXIT {0}' -f $MyInvocation.MyCommand.Name)
}