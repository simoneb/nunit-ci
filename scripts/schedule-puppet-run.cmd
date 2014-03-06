@echo off
set manifest=c:\vagrant\manifests\default.pp
set modules=c:\vagrant\modules
set cmd=puppet apply --modulepath=%modules% %manifest% --debug --verbose

schtasks /create /f /sc once /tn puppet-run-once /st 00:00 /TR "%cmd%"
schtasks /run /tn puppet-run-once

:wait

echo Waiting for puppet to complete provisioning
timeout 10 1>nul

schtasks /query /tn puppet-run-once | findstr /C:"Ready" 1>nul

if %errorlevel% neq 0 goto wait

echo Puppet has completed provisioning, deleting task
schtasks /delete /f /tn puppet-run-once