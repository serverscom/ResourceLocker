---
external help file: ResourceLocker-help.xml
Module Name: ResourceLocker
online version: https://github.com/FozzyHosting/ResourceLocker/blob/master/docs/Get-ResourceLockId.md
schema: 2.0.0
---

# Get-ResourceLockId

## SYNOPSIS
Returns the lock ID from a lock object.

## SYNTAX

```
Get-ResourceLockId [-LockObject] <FileInfo[]> [<CommonParameters>]
```

## DESCRIPTION
Extracts the lock ID from a lock object and returns it as a string. The function basically has a meaning for debugging purposes only.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ResourceLockId -LockObject $Lock
```

Gets the ID from a lock object.

## PARAMETERS

### -LockObject
Specifies the lock object to examine.

```yaml
Type: FileInfo[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.IO.FileInfo[]

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS