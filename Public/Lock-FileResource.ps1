function Lock-FileResource {
    #Requires -Version 3.0

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$Path,
        [string]$CallerName
    )

    $ErrorActionPreference = 'Stop'

    Write-Debug -Message ('ENTER {0}' -f $MyInvocation.MyCommand.Name)

    try {
        Write-Debug -Message ('ENTER TRY {0}' -f $MyInvocation.MyCommand.Name)

        Write-Debug -Message ('$Path = ''{0}''' -f $Path)
        Write-Debug -Message ('$CallerName = ''{0}''' -f $CallerName)

        Write-Debug -Message ('if (''{0}'' -match ''\\\\([\w-\.]+)\\*.*'')' -f $Path)
        if ($Path -match '\\\\([\w-\.]+)\\*.*') {
            Write-Debug -Message ('$Matches[1] = ''{0}''' -f $Matches[1])
            $ComputerName = $Matches[1]
        }
        else {
            Write-Debug -Message '$ComputerName = $env:COMPUTERNAME'
            $ComputerName = $env:COMPUTERNAME
        }
        Write-Debug -Message ('$ComputerName = ''{0}''' -f $ComputerName)

        Write-Debug -Message ('Lock-Resource -ComputerName ''{0}'' -CallerName ''{1}'' -Description ''{2}'' -Type ''File''' -f $ComputerName, $CallerName, $Path)
        Lock-Resource -ComputerName $ComputerName -CallerName $CallerName -Description $Path -Type 'File'

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