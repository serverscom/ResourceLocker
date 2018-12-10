# Rename this file to "Config.ps1" to load variables, defined here, into the module.

#Requires -Version 3.0

[string]$ModuleWideResourceDependenciesFilePath = Join-Path -Path $ModulePath -Childpath ('{0}-Dependencies.json' -f $ModuleName)
[int]$ModuleWideLockTimeout = 10
[int]$ModuleWideLockRetries = 3
[string]$ModuleWideLockHistoryFolderName = 'History'
[string]$ModuleWideLockFileNameTemplate = '{0}.lock'
[string]$ModuleWideLockFolderPathTemplate = '\\{0}\ResourceLocks'