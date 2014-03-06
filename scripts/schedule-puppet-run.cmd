@echo off

IF "%~1"=="" (
  echo "No manifest file was passed, cannot proceed"
  exit 1
)

set manifest=c:\vagrant\manifests\%~1
set modules=c:\vagrant\modules
set log=%temp%\puppet-apply-%~1.log
set cmd=puppet apply --modulepath=%modules% %manifest% -l %log% --debug --verbose

echo Scheduling puppet apply with command %cmd%

schtasks /create /f /sc once /tn puppet-run-once /st 00:00 /RL HIGHEST /NP /TR "%cmd%"
schtasks /run /tn puppet-run-once

:wait

echo Waiting for puppet to complete provisioning of manifest %~1
timeout 20 1>nul

schtasks /query /tn puppet-run-once | findstr /C:"Ready" 1>nul

if %errorlevel% neq 0 goto wait

echo Puppet has completed provisioning, deleting task
schtasks /delete /f /tn puppet-run-once