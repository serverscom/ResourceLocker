function Lock-HostResource {
    #Requires -Version 3.0

    [CmdletBinding()]
    Param (
        [string]$ComputerName,
        [string]$CallerName,
        [switch]$Hard
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('$ComputerName = ''{0}''' -f $ComputerName)
        Write-Debug -Message ('$CallerName = ''{0}''' -f $CallerName)
        Write-Debug -Message ('$Hard: ''{0}''' -f [string]$Hard)

        Write-Debug -Message ('if (-not {0})' -f $ComputerName)
        if (-not $ComputerName) {
            $ComputerName = $env:COMPUTERNAME
        }
        Write-Debug -Message ('$ComputerName = ''{0}''' -f $ComputerName)

        Write-Debug -Message ('if ({0})' -f $Hard)
        if ($Hard) {
            Write-Debug -Message '$LockType = ''Host'''
            $LockType = 'Host'
        }
        else {
            Write-Debug -Message '$LockType = ''Generic'''
            $LockType = 'Generic'
        }
        Write-Debug -Message ('$LockType = ''{0}''' -f $LockType)
        Write-Debug -Message ('Lock-Resource -ComputerName ''{0}'' -CallerName ''{1}'' -Type ''{2}''' -f $ComputerName, $CallerName, $LockType)
        Lock-Resource -ComputerName $ComputerName -CallerName $CallerName -Type $LockType

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