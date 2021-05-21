# ADB-logs-helper
Helps with logs gathering


> Require admin privileges to run
```powershell
.\logiadb.ps1
```
Optionaly you can specific app package, dest dir by
```powershell
.\logiadb.ps1 'com.app.something' 'Where/I/Want/to/put/logs'
```

You can also use `startCollectingADBLogs.ps1` to invoke powershell with admin privilege and run `logiadb.ps1`
