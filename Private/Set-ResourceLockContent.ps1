function Set-ResourceLockContent {
    #Requires -Version 3.0

    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName = 'Lock', Mandatory)]
        [Parameter(ParameterSetName = 'Unlock', Mandatory)]
        [System.IO.FileInfo]$Path,
        [Parameter(ParameterSetName = 'Lock')]
        [string]$CallerName,
        [Parameter(ParameterSetName = 'Lock')]
        [string]$Description,
        [Parameter(ParameterSetName = 'Unlock', Mandatory)]
        [switch]$Unlock
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)
        
        Write-Debug -Message ('$Path = ''{0}''' -f $Path)
        Write-Debug -Message ('$CallerName = ''{0}''' -f $CallerName)
        Write-Debug -Message ('$Description = ''{0}''' -f $Description)
        Write-Debug -Message ('$Mode = ''{0}''' -f $Mode)
        Write-Debug -Message ('$PsCmdlet.ParameterSetName: ''{0}''' -f $PsCmdlet.ParameterSetName)

        Write-Debug -Message '$FileContent = @{}'
        $FileContent = @{}
        Write-Debug -Message '$Time = (Get-Date).Ticks'
        $Time = (Get-Date).Ticks
        Write-Debug -Message ('$Time = ' -f $Time)
        switch ($PsCmdlet.ParameterSetName) {
            'Lock' {
                Write-Debug -Message ('if ({0})' -f $Description)
                if ($CallerName) {
                    Write-Debug -Message ('$CallerName = ''{0}'' -replace (''\\'',''_'')' -f $CallerName)
                    $CallerName = $CallerName -replace ('\\', '_') # Fix for a PS < 5.0 bug
                    Write-Debug -Message ('$CallerName = ''{0}''' -f $CallerName)
                    Write-Debug -Message ('$FileContent.Add(''Caller'', ''{0}'')' -f $CallerName)
                    $null = $FileContent.Add('Caller', $CallerName)
                }
                Write-Debug -Message ('if ({0})' -f $Description)
                if ($Description) {
                    Write-Debug -Message ('$Description = ''{0}'' -replace (''\\'',''_'')' -f $Description)
                    $Description = $Description -replace ('\\', '_') # Fix for a PS < 5.0 bug
                    Write-Debug -Message ('$Description = ''{0}''' -f $Description)
                    Write-Debug -Message ('$FileContent.Add(''Description'', ''{0}'')' -f $Description)
                    $null = $FileContent.Add('Description', $Description)
                }
                Write-Debug -Message ('$FileContent.Add(''LockedAt'',''{0}'')' -f $Time)
                $FileContent.Add('LockedAt', $Time)
            }
            'Unlock' {
                Write-Debug -Message ('((Get-Content -Path {0}) -join "`n" | ConvertFrom-Json).PSObject.Properties | ForEach-Object -Process {{$FileContent[$_.Name] = $_.Value}}' -f $Path)
                ((Get-Content -Path $Path) -join "`n" | ConvertFrom-Json).PSObject.Properties | ForEach-Object -Process {$FileContent[$_.Name] = $_.Value}
                Write-Debug -Message ('$FileContent.Add(''UnlockedAt'',''{0}'')' -f $Time)
                $FileContent.Add('UnlockedAt', $Time)
            }
        }
        Write-Debug -Message ('if ({0} -gt 0)' -f $FileContent.Count)
        if ($FileContent.Count -gt 0) {
            Write-Debug -Message ('$FileContent: {0}' -f $FileContent)
            Write-Debug -Message '$FileContent = $FileContent | ConvertTo-Json'
            $FileContent = $FileContent | ConvertTo-Json
            Write-Debug -Message ('$FileContent: {0}' -f $FileContent)
        }

        Write-Debug -Message ('Set-Content -Path ''{0}'' -Value ''{1}''' -f $Path, [string]$FileContent)
        Set-Content -Path $Path -Value $FileContent

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