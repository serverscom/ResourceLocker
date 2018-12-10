---
external help file: ResourceLocker-help.xml
Module Name: ResourceLocker
online version: https://github.com/FozzyHosting/ResourceLocker/blob/master/docs/Get-ResourceDependence.md
schema: 2.0.0
---

# Get-ResourceDependence

## SYNOPSIS
Returns a dependency tree for a host.

## SYNTAX

### ByDefinition
```
Get-ResourceDependence -ResourceName <String> -ResourceDependencies <PSObject> [<CommonParameters>]
```

### ByFile
```
Get-ResourceDependence -ResourceName <String> [-FilePath <String>] [<CommonParameters>]
```

## DESCRIPTION
Use this function to determine which hosts will be locked along with a network host.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ResourceDependence -ResourceName SRV01
```

Retuns a dependency tree for SRV01.

## PARAMETERS

### -ResourceName
Specifies the name of a resource for which to build a dependency tree.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Specifies the path to a file, containing host dependencies description.

```yaml
Type: String
Parameter Sets: ByFile
Aliases:

Required: False
Position: Named
Default value: $ModuleWideResourceDependenciesFilePath
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceDependencies
Specifies a dependencies object instead of a file. This parameter is for internal purposes - you don't really need to use it.

```yaml
Type: PSObject
Parameter Sets: ByDefinition
Aliases:

Required: True
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

### System.String[]

## NOTES

## RELATED LINKS