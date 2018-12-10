function Lock-Resource {
    #Requires -Version 3.0

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$ComputerName,
        [string]$CallerName,
        [ValidateSet('Host', 'Generic', 'File')]
        [string]$Type = 'Generic',
        [string]$Description,
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Timeout = $ModuleWideLockTimeout,
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Retry = $ModuleWideLockRetries,
        [switch]$NoDependencies,
        [string]$SessionID = ([guid]::NewGuid()).Guid
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('$ComputerName = ''{0}''' -f $ComputerName)
        Write-Debug -Message ('$CallerName = ''{0}''' -f $CallerName)
        Write-Debug -Message ('$Type = ''{0}''' -f $Type)
        Write-Debug -Message ('$Description = ''{0}''' -f $Description)
        Write-Debug -Message ('$Timeout = ''{0}''' -f $Timeout)
        Write-Debug -Message ('$Retry = ''{0}''' -f $Retry)
        Write-Debug -Message ('$SessionID = ''{0}''' -f $SessionID)

        Write-Debug -Message '$Counter = 0'
        $Counter = 0
        Write-Debug -Message ('$Counter = ''{0}''' -f $Counter)

        Write-Debug -Message ('if (-not {0})' -f $NoDependencies)
        if (-not $NoDependencies) {
            Write-Debug -Message ('$ResourcesToLock = Get-ResourceDependence -ResourceName ''{0}''' -f $ComputerName)
            $ResourcesToLock = Get-ResourceDependence -ResourceName $ComputerName
            Write-Debug -Message ('$ResourcesToLock = ''{0}''' -f [string]$ResourcesToLock)

            Write-Debug -Message ('if ({0})' -f [string]$ResourcesToLock)
            if ($ResourcesToLock) {
                foreach ($Resource in $ResourcesToLock) {
                    Write-Debug -Message ('$Resource = ''{0}''' -f $Resource)
                    Write-Debug -Message ('Lock-Resource -ComputerName ''{0}'' -CallerName ''{1}'' -Description ''{2}'' -Type ''{3}'' -SessionID ''{4}''' -f $Resource, $CallerName, $Description, $Type, $SessionID)
                    Lock-Resource -ComputerName $Resource -CallerName $CallerName -Description $Description -Type $Type -SessionID $SessionID -NoDependencies
                }
            }
        }

        do {
            Write-Debug -Message '$File = $null'
            $File = $null
            Write-Debug -Message '$Counter++'
            $Counter++
            Write-Debug -Message ('$Counter = {0}' -f $Counter)
            Write-Debug -Message ('$ComputerIsHostLocked = Test-HostResourceLock -ComputerName ''{0}''-Type ''Host''' -f $ComputerName)
            $ComputerIsHostLocked = Test-HostResourceLock -ComputerName $ComputerName -Type 'Host'
            Write-Debug -Message ('$ComputerIsHostLocked: ''{0}''' -f [string]$ComputerIsHostLocked)
            Write-Debug -Message ('if (-not {0})' -f [string]$ComputerIsHostLocked)
            if (-not $ComputerIsHostLocked) {
                try {
                    Write-Debug -Message ('$File = New-ResourceLock -ComputerName ''{0}'' -CallerName ''{1}'' -Description ''{2}'' -Type ''{3}'' -SessionID ''{4}''' -f $ComputerName, $CallerName, $Description, $Type, $SessionID)
                    $File = New-ResourceLock -ComputerName $ComputerName -CallerName $CallerName -Description $Description -Type $Type -SessionID $SessionID
                }
                catch {
                    Write-Debug -Message ('if ({0} -ge {1})' -f $Counter, $Retry)
                    if ($Counter -ge $Retry) {
                        $Message = 'Unable to set a new resource lock at the host {0} after {1} retries. An error happened: {2}' -f $ComputerName, $Counter, $_.Exception.Message
                        $PSCmdlet.ThrowTerminatingError((New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList ((New-Object -TypeName 'System.TimeoutException' -ArgumentList $Message, $_.Exception), 'TimeoutException', [System.Management.Automation.ErrorCategory]::OperationTimeout, $null)))
                    }
                    Write-Debug -Message ('Start-Sleep -Seconds {0}' -f $Timeout)
                    Start-Sleep -Seconds $Timeout
                }
            }
            else {
                Write-Debug -Message ('if ({0} -ge {1})' -f $Counter, $Retry)
                if ($Counter -ge $Retry) {
                    Write-Debug -Message ('$Message = ''Unable to set a new resource lock at the host {{0}} after {{1}} retries, because the host itself is locked'' -f ''{0}'', ''{1}''' -f $ComputerName, $Counter)
                    $Message = 'Unable to set a new resource lock at the host {0} after {1} retries, because the host itself is locked' -f $ComputerName, $Counter
                    Write-Debug -Message ('$Message = ''{0}''' -f $Message)
                    Write-Debug -Message '$PSCmdlet.ThrowTerminatingError((New-Object -TypeName ''System.Management.Automation.ErrorRecord'' -ArgumentList ((New-Object -TypeName ''System.TimeoutException'' -ArgumentList $Message), ''TimeoutException'', [System.Management.Automation.ErrorCategory]::OperationTimeout, $null)))'
                    $PSCmdlet.ThrowTerminatingError((New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList ((New-Object -TypeName 'System.TimeoutException' -ArgumentList $Message), 'TimeoutException', [System.Management.Automation.ErrorCategory]::OperationTimeout, $null)))
                }
                Write-Debug -Message ('Start-Sleep -Seconds {0}' -f $Timeout)
                Start-Sleep -Seconds $Timeout
            }

            Write-Debug -Message 'until ($File -and $File -is [System.IO.FileInfo])'
        }
        until ($File -and $File -is [System.IO.FileInfo])

        Write-Debug -Message ('$File: {0}' -f [string]$File)
        Write-Debug -Message '$File'
        $File

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