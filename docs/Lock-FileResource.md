---
external help file: ResourceLocker-help.xml
Module Name: ResourceLocker
online version: https://github.com/FozzyHosting/ResourceLocker/blob/master/docs/Lock-FileResource.md
schema: 2.0.0
---

# Lock-FileResource

## SYNOPSIS
Locks a host on which a network file resides.

## SYNTAX

```
Lock-FileResource [-Path] <String> [[-CallerName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Use this function when you work with a network share and want to lock a host which hosts the share. The function puts the name of the file into lock's description.
The function puts locks of the "File" type only.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Lock = Lock-FileResource -Path \\fs01\share1\example.iso -CallerName $MyInvocation.MyCommand.Name
```

Puts a file lock to FS01 host. The caller name in that lock will be the name of the function invoking the command.
Usually you'd want to save a lock object into a variable so later you could pass it to the `Unlock-Resource` function.

## PARAMETERS

### -Path
Specifies a path to the file with which you are about to work.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.IO.FileInfo[]

## NOTES

## RELATED LINKS