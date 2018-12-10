function Test-HostResourceLock {
    #Requires -Version 3.0

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        [Parameter(Mandatory)]
        [string]$ComputerName,
        [ValidateSet('Host', 'Generic', 'File', 'Any')]
        [string[]]$Type = @('Any'),
        [string]$FolderPathTemplate = $ModuleWideLockFolderPathTemplate,
        [string]$FileNameTemplate = $ModuleWideLockFileNameTemplate
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('$ComputerName = ''{0}''' -f $ComputerName)
        Write-Debug -Message ('$Type: ''{0}''' -f [string]$Type)
        Write-Debug -Message ('$FolderPathTemplate = ''{0}''' -f $FolderPathTemplate)
        Write-Debug -Message ('$FileNameTemplate = ''{0}''' -f $FileNameTemplate)

        Write-Debug -Message '$Result = $false'
        $Result = $false
        Write-Debug -Message ('$Result: ''{0}''' -f [string]$Result)

        $FolderPath = ($FolderPathTemplate -f $ComputerName)
        Write-Debug -Message ('$FolderPath = ''{0}''' -f $FolderPath)

        Write-Debug -Message ('if ({0} -contains ''Any'')' -f $Type)
        if ($Type -contains 'Any') {
            Write-Debug -Message ('$FileName = ''{0}'' -f ''*'')' -f $FileNameTemplate)
            $FileName = $FileNameTemplate -f '*'
            Write-Debug -Message ('$FileName = ''{0}''' -f $FileName)
        }
        else {
            Write-Debug -Message '$FileName = @()'
            $FileName = @()
            Write-Debug -Message ('switch ({0})' -f [string]$Type)
            switch ($Type) {
                'Host' {
                    Write-Debug -Message ('$FileName += ''{0}'' -f ''Host'')' -f $FileNameTemplate)
                    $FileName += $FileNameTemplate -f 'Host'
                }
                'Generic' {
                    Write-Debug -Message ('$FileName += ''{0}'' -f ''Generic-*'')' -f $FileNameTemplate)
                    $FileName += $FileNameTemplate -f 'Generic-*'
                }
                'File' {
                    Write-Debug -Message ('$FileName += ''{0}'' -f ''File-*'')' -f $FileNameTemplate)
                    $FileName += $FileNameTemplate -f 'File-*'
                }
            }
            Write-Debug -Message ('$FileName: ''{0}''' -f [string]$FileName)
        }

        foreach ($Name in $FileName) {
            Write-Debug ('$Name = ''{0}''' -f $Name)
            Write-Debug -Message ('$FilePath = Join-Path -Path ''{0}'' -ChildPath ''{1}''' -f $FolderPath, $Name)
            $FilePath = Join-Path -Path $FolderPath -ChildPath $Name
            Write-Debug -Message ('$FilePath = ''{0}''' -f $FilePath)

            Write-Debug -Message ('$FilePathExistence = Test-Path -Path ''{0}''' -f $FilePath)
            $FilePathExistence = Test-Path -Path $FilePath
            Write-Debug -Message ('$FilePathExistence: ''{0}''' -f [string]$FilePathExistence)
            if ($FilePathExistence) {
                Write-Debug -Message '$Result = $true'
                $Result = $true
                Write-Debug -Message ('$Result: ''{0}''' -f [string]$Result)
            }
        }
        
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