function New-ResourceLock {
    #Requires -Version 3.0

    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    Param (
        [Parameter(Mandatory)]
        [string]$ComputerName,
        [ValidateSet('Host', 'Generic', 'File')]
        [string]$Type = 'Generic',
        [string]$CallerName,
        [string]$Description,
        [string]$FolderPathTemplate = $ModuleWideLockFolderPathTemplate,
        [string]$FileNameTemplate = $ModuleWideLockFileNameTemplate,
        [string]$SessionID = ([guid]::NewGuid()).Guid
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)
        
        Write-Debug -Message ('$ComputerName = {0}' -f $ComputerName)
        Write-Debug -Message ('$Type = {0}' -f $Type)
        Write-Debug -Message ('$CallerName = {0}' -f $CallerName)
        Write-Debug -Message ('$FolderPathTemplate = {0}' -f $FolderPathTemplate)
        Write-Debug -Message ('$FileNameTemplate = {0}' -f $FileNameTemplate)
        Write-Debug -Message ('$SessionID = {0}' -f $SessionID)
    
        $FolderPath = ($FolderPathTemplate -f $ComputerName)
        Write-Debug -Message ('$FolderPath = {0}' -f $FolderPath)
        if ($Type -eq 'Host') {
            $FileName = $FileNameTemplate -f $Type
        }
        else {
            $FileName = $FileNameTemplate -f ('{0}-{1}' -f $Type, $SessionID)
        }
        Write-Debug -Message ('$FileName = {0}' -f $FileName)

        Write-Debug -Message ('$FolderPathContainerExistence = Test-Path -Path {0} -PathType Container' -f $FolderPath)
        $FolderPathContainerExistence = Test-Path -Path $FolderPath -PathType Container
        Write-Debug -Message ('$FolderPathContainerExistence = ''{0}''' -f $FolderPathContainerExistence)
        Write-Debug -Message ('if ({0})' -f $FolderPathContainerExistence)
        if ($FolderPathContainerExistence) {
            $FilePath = Join-Path -Path $FolderPath -ChildPath $FileName
            Write-Debug -Message ('$FilePath = {0}' -f $FilePath)

            Write-Debug -Message ('$FilePathExistence = Test-Path -Path ''{0}''' -f $FilePath)
            $FilePathExistence = Test-Path -Path $FilePath
            Write-Debug -Message ('$FilePathExistence = ''{0}''' -f $FilePathExistence)
            Write-Debug -Message ('if (-not ({0}))' -f $FilePathExistence)
            if (-not ($FilePathExistence)) {
                Write-Debug -Message ('$File = New-Item -Path ''{0}'' -Value ''{1}'' -ItemType File' -f $FilePath, $CallerName)
                Write-Verbose -Message ('Creating a lock file {0} with a caller name {1}' -f $FilePath, $CallerName)
                $File = New-Item -Path $FilePath -Value $CallerName -ItemType File
                Write-Debug -Message ('Set-ResourceLockContent -Path ''{0}'' -CallerName ''{1}'' -Description ''{2}''' -f $File, $CallerName, $Description)
                Set-ResourceLockContent -Path $File -CallerName $CallerName -Description $Description
                Write-Debug -Message ('$File: {0}' -f $File)
                Write-Debug -Message '$File'
                $File
            }
            else {
                Write-Debug -Message ('$FilePathLeafExistence = Test-Path -Path ''{0}'' -PathType Leaf' -f $FilePath)
                $FilePathLeafExistence = Test-Path -Path $FilePath -PathType Leaf
                Write-Debug -Message ('$FilePathLeafExistence = ''{0}''' -f $FilePathLeafExistence)
                Write-Debug -Message ('if ({0})' -f $FilePathLeafExistence)
                if ($FilePathLeafExistence) {
                    $Message = '{0} already exists' -f $FilePath
                    $PSCmdlet.ThrowTerminatingError((New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList ((New-Object -TypeName 'System.IO.IOException' -ArgumentList $Message), 'IOException', [System.Management.Automation.ErrorCategory]::ResourceExists, $null)))
                }
                else {
                    $Message = '{0} already exists and is a directory' -f $FilePath
                    $PSCmdlet.ThrowTerminatingError((New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList ((New-Object -TypeName 'System.IO.IOException' -ArgumentList $Message), 'IOException', [System.Management.Automation.ErrorCategory]::InvalidType, $null)))
                }
            }
        }
        else {
            Write-Debug -Message ('$FolderPathExistence = Test-Path -Path ''{0}''' -f $FolderPath)
            $FolderPathExistence = Test-Path -Path $FolderPath
            Write-Debug -Message ('$FolderPathExistence = ''{0}''' -f $FolderPathExistence)
            if ($FolderPathExistence) {
                $Message = '{0} is not a directory' -f $FolderPath
                $PSCmdlet.ThrowTerminatingError((New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList ((New-Object -TypeName 'System.IO.IOException' -ArgumentList $Message), 'IOException', [System.Management.Automation.ErrorCategory]::InvalidType, $null)))
            }
            else {
                $Message = '{0} does not exist' -f $FolderPath
                $PSCmdlet.ThrowTerminatingError((New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList ((New-Object -TypeName 'System.IO.DirectoryNotFoundException' -ArgumentList $Message), 'DirectoryNotFoundException', [System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)))
            }
        }

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