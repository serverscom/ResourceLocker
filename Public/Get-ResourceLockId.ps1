function Get-ResourceLockId {
    #Requires -Version 3.0

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo[]]$LockObject
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('LockObject: {0}' -f [string]$LockObject)
        
        Write-Debug -Message ('$LockObject -is [System.Array]')
        if ($LockObject -is [System.Array]) {
            #Even if there are several lock objects passed to the function, they all should have the same name
            Write-Debug -Message ('$LockObjectName = $LockObject[0].Name')
            $LockObjectName = $LockObject[0].Name
            Write-Debug -Message ('$LockObjectName = {0}' -f $LockObjectName)
        }
        else {
            Write-Debug -Message ('$LockObjectName = $LockObject.Name')
            $LockObjectName = $LockObject.Name
            Write-Debug -Message ('$LockObjectName = {0}' -f $LockObjectName)
        }
    
        Write-Debug -Message ('$null = ''{0}'' -match ''(.+)\.(.+)''' -f $LockObjectName)
        $null = $LockObjectName -match '(.+)\.(.+)'
        Write-Debug -Message ('$Matches: {0}' -f $Matches)
        Write-Debug -Message ('$Matches[1]: {0}' -f $Matches[1])
        Write-Debug -Message ('$Matches[1]')
        $Matches[1]

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