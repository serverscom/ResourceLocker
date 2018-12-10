---
external help file: ResourceLocker-help.xml
Module Name: ResourceLocker
online version: https://github.com/FozzyHosting/ResourceLocker/blob/master/docs/Test-HostResourceLock.md
schema: 2.0.0
---

# Test-HostResourceLock

## SYNOPSIS
Tests if a computer has a lock of some kind in place.

## SYNTAX

```
Test-HostResourceLock [-ComputerName] <String> [[-Type] <String[]>] [[-FolderPathTemplate] <String>]
 [[-FileNameTemplate] <String>] [<CommonParameters>]
```

## DESCRIPTION
The function tests if a computer has a lock of some type on it. You can use the `-Type` parameter to specify in which type exactly you are interested.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-HostResourceLock -ComputerName SRV01 -Type Host
```

Tests if SRV01 has a lock of the "Host" type on it.

### Example 2
```powershell
PS C:\> Test-HostResourceLock -ComputerName SRV01
```

Tests if SRV01 has any lock on it.

## PARAMETERS

### -ComputerName
Specifies the name of a computer to test.

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
Specifies for which types of locks to look.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Host, Generic, File, Any

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderPathTemplate
Specifies the template which is used to get a folder where to search for lock files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $ModuleWideLockFolderPathTemplate
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
Position: 3
Default value: $ModuleWideLockFileNameTemplate
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean

## NOTES

## RELATED LINKS