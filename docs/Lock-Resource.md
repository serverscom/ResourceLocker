---
external help file: ResourceLocker-help.xml
Module Name: ResourceLocker
online version: https://github.com/FozzyHosting/ResourceLocker/blob/master/docs/Lock-Resource.md
schema: 2.0.0
---

# Lock-Resource

## SYNOPSIS
Locks a host with some type of a lock plus it allows you to set some advanced options which the other two functions don't.

## SYNTAX

```
Lock-Resource [-ComputerName] <String> [[-CallerName] <String>] [[-Type] <String>] [[-Description] <String>]
 [[-Timeout] <Int32>] [[-Retry] <Int32>] [-NoDependencies] [[-SessionID] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function allows you more flexibility than `Lock-FileResource` and `Lock-HostResource`, but should not really be used except for testing and edge cases.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Lock = Lock-Resource -ComputerName SRV01 -NoDependencies
```

Locks SRV01 host w/o resolving its dependencies - the lock will be set on that host only.

## PARAMETERS

### -ComputerName
Specifies the name of a computer to lock.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies which type of lock to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Host, Generic, File

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CallerName
Specifies an arbitrary description of an entity which set the lock. We recommend to pass the name of a caller function here.

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

### -Description
Specifies an arbitrary description of a lock. Currently is used by the Lock-FileResource function to store filename's here.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoDependencies
Prevents the function from resolving dependencies - it will lock only the host against which it was called.

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

### -Retry
Specifies the number of retries to set a lock, before raising an exception.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $ModuleWideLockRetries
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Specifies the timeout for each retry to set a lock.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $ModuleWideLockTimeout
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionID
Specifies session ID which is used to identify all locks in this invocation. Use this parameter if you don't want to use auto-generated GUIDs as session IDs.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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