---
external help file: ResourceLocker-help.xml
Module Name: ResourceLocker
online version: https://github.com/FozzyHosting/ResourceLocker/blob/master/docs/Unlock-Resource.md
schema: 2.0.0
---

# Unlock-Resource

## SYNOPSIS
Unlocks a resource/host.

## SYNTAX

```
Unlock-Resource [-LockObject] <FileInfo[]> [[-HistoryFolderName] <String>] [[-FileNameTemplate] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
THe function allow you to gracefully unlock a network resource. The main purpose of such unlock is to maintain history of locks: it's implemented by utilizing a *history folder* on each host where disengaged lock files are moved.
When the function disengages a lock file, it writes the current time in it so you can keep track of locks on a host.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Lock | Unlock-Resource
```

Unlocks a resource based on a lock object passed through the pipeline.

### Example 2
```powershell
PS C:\> Unlock-Resource -LockObject $Lock

Unlocks a resource based on a lock object passed directly into the parameter.
```

## PARAMETERS

### -LockObject
The lock object you would like to disengage.

```yaml
Type: FileInfo[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -HistoryFolderName
Specifies the name of a folder where to put a disengaged lock.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $ModuleWideLockHistoryFolderName
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileNameTemplate
Specifies the template which is used to distinguish lock files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $ModuleWideLockFileNameTemplate
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.IO.FileInfo[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS