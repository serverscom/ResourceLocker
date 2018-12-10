# ResourceLocker
The purpose of the module is to synchronize different functions/scripts which make one or more network hosts unavailable as a part of their process. It is achieved by introducing "locks" which each function or a script can put on a network host, therefore stating that that function is currently working with that host, which, in turn, is a signal to other functions that they better not make that host unavailable.
A good example would be a maintenance module, like AutomaticMaintenance, which reboots servers as it performs maintenance on them. We'd like to prevent it from rebooting a host which is currently in use by, say, an OS image release function.

## Locking

To *lock* a resource (a network host or file), use one of the following functions:
* `Lock-HostResource` - to put a lock on a network host. You can choose the type of a lock: `Generic` or `Host` (see below).
* `Lock-FileResource` - to put a lock on a fileserver where some file, with which you'd like to work, resides. No need to provide server's name separately - just pass a link to the file and let the function to do its job. Results in a lock of the `File` type.
* `Lock-Resource` - the other two functions use this one to actually put a lock in place. It provides additional advanced parameters which aren't really needed for day-to-day operations.

### Lock types
Currently there are three types of locks:
* **Host** - Only one lock of this type is allowed per host. Use it to lock a host exclusively - it will render any subsequent lock commands against the host to fail. Useful when you prepare a host for reboot.
* **Generic** - Multiple locks of this type per host allowed. Just shows that something works with the host right now.
* **File** - Behaves like a Generic lock, but is useful for network file operations, since it might contain the full path of a network file in the description.

### Under the hood
A lock is just a file with the `.lock` extension. By default lock files are located in a shared folder called `ResourceLocks` on a locked host.
There are several sections in a lock file:
* **Caller** - Arbitrary description of an entity which set the lock. We recommend to pass the name of a caller function here.
* **Description** - Arbitrary description why the host was locked. **Lock-FileResource** fills this section with a path to the file.
* **LockedAt** - Time, when the lock was set, in ticks.
* **UnlockedAt** - Time, when the lock was removed, in ticks.

When you create a lock, a unique session ID is generated. This ID then used for *all* locks in the dependency tree, which makes troubleshooting easier.

### Unlocking
To *unlock* a resource, use `Unlock-Resource` function. You must pass a lock object to it, which it will process and, as a result of this, the lock will be moved to *the archive*. Right now, the archive is a folder inside the `ResourceLocks` folder called `History`.

## Host dependencies
The module supports a dependencies map, which defines dependencies between network hosts. In a `ResourceLocker-Dependencies.json` file you can define for each host, which hosts depend on it. Then, when you lock the dependent, hosts, on which it depends, will be automatically locked as well.

You can see the full dependency tree for a host by using the **Get-ResourceDependence** function.

```yaml
{
    "hv01": [
        "dc01",
        "vmm01"
    ]
}
```
In this example, two hosts depend on HV01: DC01 and VMM01 - if any of them gets locked, HV01 will be locked too.

```powershell
Get-ResourceDependence -ResourceName dc01
hv01

Get-ResourceDependence -ResourceName vmm01
hv01
```

```yaml
{
    "hv01": [
        "dc01",
        "vmm01"
    ]
    "dc01": [
        "dc02"
    ],
    "dc02": [
        "dc01"
    ]
}
```
In this example we added a cross-dependency between DC01/DC02, which means if one of them gets locked, the other one becomes locked too - you don't want all your domain controllers to be down at once and such configuration helps to prevent just that.

```powershell
Get-ResourceDependence -ResourceName dc01
dc02
hv01

Get-ResourceDependence -ResourceName dc02
dc01
hv01
```

## Exported functions
* [Get-ResourceDependence](docs/Get-ResourceDependence.md)
* [Get-ResourceLockId](docs/Get-ResourceLockId.md)
* [Lock-FileResource](docs/Lock-FileResource.md)
* [Lock-HostResource](docs/Lock-HostResource.md)
* [Lock-Resource](docs/Lock-Resource.md)
* [Test-HostResourceLock](docs/Test-HostResourceLock.md)
* [Unlock-Resource](docs/Unlock-Resource.md)

## Module-wide variables
There are several variables defined in the .psm1-file, which are used by the module's functions as default values for parameters:

`[string]$ModuleWideResourceDependenciesFilePath` - default value for **Get-ResourceDependence**'s `-FilePath` parameter.

`[int]$ModuleWideLockTimeout` - default value for **Lock-Resource**'s `-Timeout` parameter.

`[int]$ModuleWideLockRetries` - default value for **Lock-Resource**'s `-Retry` parameter.

`[string]$ModuleWideLockHistoryFolderName` - default value for **Unlock-Resource**'s `-HistoryFolderName` parameter.

`[string]$ModuleWideLockFileNameTemplate` - default value for the `-FileNameTemplate` parameter of **New-ResourceLock**, **Test-HostResourceLock**, and **Unlock-Resource** functions.

`[string]$ModuleWideLockFolderPathTemplate` - default value for the `-FolderPathTemplate` parameter of **New-ResourceLock** and **Test-HostResourceLock** functions.

## Loading variables from an external source
All module-wide variables can be redefined with a `Config.ps1` file, located in the module's root folder. Just put variable definitions in there as you would do with any other PowerShell script. You may find an example of a config file `Config-Example.ps1` in the module's root folder.

## Limitations
* The module requires network hosts to be available through the SMB protocol.
* The module supports implicit authentication only.