#Requires -Version 3.0

$ModulePath = $PSScriptRoot
$ModuleName = ($MyInvocation.MyCommand.Name).Substring(0, ($MyInvocation.MyCommand.Name).Length - 5)

[string]$ModuleWideResourceDependenciesFilePath = Join-Path -Path $ModulePath -Childpath ('{0}-Dependencies.json' -f $ModuleName)
[int]$ModuleWideLockTimeout = 10
[int]$ModuleWideLockRetries = 3
[string]$ModuleWideLockHistoryFolderName = 'History'
[string]$ModuleWideLockFileNameTemplate = '{0}.lock'
[string]$ModuleWideLockFolderPathTemplate = '\\{0}\ResourceLocks'

foreach ($FunctionType in @('Private', 'Public')) {
    $Path = Join-Path -Path $ModulePath -ChildPath ('{0}\*.ps1' -f $FunctionType)
    if (Test-Path -Path $Path) {
        Get-ChildItem -Path $Path -Recurse | ForEach-Object -Process {. $_.FullName}
    }
}

$Path = Join-Path -Path $ModulePath -ChildPath 'Config.ps1'
if (Test-Path -Path $Path -PathType Leaf) {
    . $Path
}