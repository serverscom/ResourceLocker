function Unlock-Resource {
    #Requires -Version 3.0

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.IO.FileInfo[]]$LockObject,
        [string]$HistoryFolderName = $ModuleWideLockHistoryFolderName,
        [string]$FileNameTemplate = $ModuleWideLockFileNameTemplate
    )

    BEGIN {
        $ErrorActionPreference = 'Stop'
        Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('$LockObject: {0}' -f [string]$LockObject)
        Write-Debug -Message ('$HistoryFolderName = ''{0}''' -f $HistoryFolderName)
    }
    PROCESS {
        try {
            Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)

            foreach ($File in $LockObject) {
                Write-Debug -Message ('$File: ''{0}''' -f [string]$File)
                Write-Debug -Message ('$FileFolderPath = {0}' -f $File.DirectoryName)
                $FileFolderPath = $File.DirectoryName
                Write-Debug -Message ('$FileFolderPath = {0}' -f $FileFolderPath)
                Write-Debug -Message ('$HistoryFolderPath = Join-Path -Path {0} -ChildPath {1}' -f $FileFolderPath, $HistoryFolderName)
                $HistoryFolderPath = Join-Path -Path $FileFolderPath -ChildPath $HistoryFolderName
                Write-Debug -Message ('$HistoryFolderPath = {0}' -f $HistoryFolderPath)
                Write-Debug -Message ('$HistoryFolderContainerExistence = Test-Path -Path {0} -PathType Container' -f $HistoryFolderPath)
                $HistoryFolderContainerExistence = Test-Path -Path $HistoryFolderPath -PathType Container
                Write-Debug -Message ('$HistoryFolderContainerExistence = {0}' -f $HistoryFolderContainerExistence)
                Write-Debug -Message ('if (-not {0})' -f $HistoryFolderContainerExistence)
                if (-not $HistoryFolderContainerExistence) {
                    Write-Debug -Message ('$HistoryFolderExistence = Test-Path -Path {0}' -f $HistoryFolderPath)
                    $HistoryFolderExistence = Test-Path -Path $HistoryFolderPath
                    Write-Debug -Message ('$HistoryFolderExistence = {0}' -f $HistoryFolderExistence)
                    Write-Debug -Message ('if ({0})' -f $HistoryFolderExistence)
                    if ($HistoryFolderExistence) {
                        $Message = '{0} already exists and is not a directory' -f $HistoryFolderPath
                        $PSCmdlet.ThrowTerminatingError((New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList ((New-Object -TypeName 'System.IO.IOException' -ArgumentList $Message), 'IOException', [System.Management.Automation.ErrorCategory]::InvalidType, $null)))
                    }
                    else {
                        Write-Debug -Message ('$null = New-Item -Path {0} -ItemType Directory' -f $HistoryFolderPath)
                        $null = New-Item -Path $HistoryFolderPath -ItemType Directory
                    }
                }

                Write-Debug -Message ('Set-ResourceLockContent -Path {0} -Unlock' -f [string]$File)
                Set-ResourceLockContent -Path $File -Unlock

                Write-Debug -Message ('if ({0} -eq ({1} -f ''Host''))' -f $File.Name, $FileNameTemplate)
                if ($File.Name -eq ($FileNameTemplate -f 'Host')) {
                    $NewFileNameGuid = ([guid]::NewGuid()).Guid
                    Write-Debug -Message ('$NewFileName = ''{{0}}-{{1}}'' -f {0}, {1}' -f $File.Name, $NewFileNameGuid)
                    $NewFileName = '{0}-{1}' -f $File.Name, $NewFileNameGuid
                    Write-Debug -Message ('$NewFileName = {0}' -f $NewFileName)
                    Write-Debug -Message ('$null = Rename-Item -Path {0} -NewName {1}' -f [string]$File, $NewFileName)
                    $null = Rename-Item -Path $File -NewName $NewFileName
                    Write-Debug -Message ('$File = Get-Item -Path (Join-Path -Path {0} -ChildPath {1})' -f $FileFolderPath, $NewFileName)
                    $File = Get-Item -Path (Join-Path -Path $FileFolderPath -ChildPath $NewFileName)
                    Write-Debug -Message ('$File: {0}' -f [string]$File)
                }

                Write-Debug -Message ('$null = Move-Item -Path {0} -Destination {1}' -f [string]$File, $HistoryFolderPath)
                $null = Move-Item -Path $File -Destination $HistoryFolderPath
            }

            Write-Debug -Message ('EXIT TRY {0}' -f $MyInvocation.MyCommand.Name)
        }
        catch {
            Write-Debug -Message ('ENTER CATCH {0}' -f $MyInvocation.MyCommand.Name)
    
            Write-Debug -Message ('{0}: $PSCmdlet.ThrowTerminatingError($_)' -f $MyInvocation.MyCommand.Name)
            $PSCmdlet.ThrowTerminatingError($_)
    
            Write-Debug -Message ('EXIT CATCH {0}' -f $MyInvocation.MyCommand.Name)
        }
    }
    END {
        Write-Debug -Message ('EXIT {0}' -f $MyInvocation.MyCommand.Name)
    }
}