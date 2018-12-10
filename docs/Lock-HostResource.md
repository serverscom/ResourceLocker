---
external help file: ResourceLocker-help.xml
Module Name: ResourceLocker
online version: https://github.com/FozzyHosting/ResourceLocker/blob/master/docs/Lock-HostResource.md
schema: 2.0.0
---

# Lock-HostResource

## SYNOPSIS
Locks a host with a "Generic" or a "Host" lock.

## SYNTAX

```
Lock-HostResource [[-ComputerName] <String>] [[-CallerName] <String>] [-Hard] [<CommonParameters>]
```

## DESCRIPTION
Use this function to just lock a host. If you want to prevent sunsequent locks on the host, use the `-Hard` parameter.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Lock = Lock-HostResource -ComputerName SRV01 -CallerName $MyInvocation.MyCommand.Name -Hard
```

Locks a host called SRV01 with a lock of the "Host" type. The caller name in that lock will be the name of the function invoking the command.
Usually you'd want to save a lock object into a variable so later you could pass it to the `Unlock-Resource` function.

### Example 2
```powershell
PS C:\> Lock-HostResource -CallerName admin-joe
```

Locks a local host with a lock of the "Generic" type. The caller name inside of that lock will be "admin-joe". Useful, when you work on a host and need to reboot it manually.
In this example the user does not save the object into a variable, because it will be lost during the reboot anyway - they'll need to deal with that lock manually later.

## PARAMETERS

### -ComputerName
Specifies the name of a computer to lock.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CallerName
Arbitrary description of an entity which set the lock. We recommend to pass the name of a caller function here.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hard
Specifies that the host should be locked with a lock of the "Host" type.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.IO.FileInfo[]

## NOTES

## RELATED LINKS