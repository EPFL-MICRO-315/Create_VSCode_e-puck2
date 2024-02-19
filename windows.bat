@echo off
set EPuck2_Debug=OFF
if %EPuck2_Debug% EQU ON (
  echo Recover path of batch
)
set EPuck2_InstallerPath=%~dp0
set EPuck2_InstallerPath=%EPuck2_InstallerPath:~0,-1%
if %EPuck2_Debug% EQU ON (
  echo:   ... Installer path = %EPuck2_InstallerPath%
  echo:
)
cd %EPuck2_InstallerPath%
set EPuck2_LogFile=%EPuck2_InstallerPath%\Install.log
echo Installer path = %EPuck2_InstallerPath% >> %EPuck2_LogFile%
echo:

if %EPuck2_Debug% EQU ON (
  echo Administrative permissions required. Test that batch is well started as Administrator ...    
)
net session >nul 2>>%EPuck2_LogFile%
if /I %errorLevel% == 0 (
  if %EPuck2_Debug% EQU ON (
    echo:  ... Success: Administrative permissions confirmed.
  )
) else (
  if %EPuck2_Debug% EQU ON (
    echo:  ... Failure: Current permissions inadequate.
  )
  echo ERROR: This %~nx0 batch MUST be run as Administrator
  echo:
  pause
  goto finalEnd
)

echo:

:SavePSPolicy
type %EPuck2_LogFile% 2>nul | findstr SavePSPolicy >nul
if errorlevel 1 (
  echo Save actual PowerShell policy ...
  IF Exist %EPuck2_InstallerPath%\PowerShellPoliciesBackup.reg (
    if %EPuck2_Debug% EQU ON (
      echo:    ... a backup already exist.
    )
    echo:    A backup of PowerShell policy already exist. >> %EPuck2_LogFile%
    echo Certainly the batch %~nx0 has already been executed but aborted.
    echo The previous backup will be use for restoration.
    pause
  ) else (
    reg export hklm\Software\Policies\Microsoft\Windows\PowerShell %EPuck2_InstallerPath%\PowerShellPoliciesBackup.reg /y >nul 2>>%EPuck2_LogFile%
    if errorlevel 1 (
      if %EPuck2_Debug% EQU ON (
        echo:    ... PowerShell policy was not configured
      ) else (
      echo:    PowerShell policy was not configured. >> %EPuck2_LogFile%
      )
      REM create an empty reg file to manage batch abortion
      echo Windows Registry Editor Version 5.00 > %EPuck2_InstallerPath%\PowerShellPoliciesBackup.reg
    ) else (
      if %EPuck2_Debug% EQU ON (
        echo:    ... PowerShell Policy saved in file
      ) else (
      echo:    PowerShell policy saved in file. >> %EPuck2_LogFile%
      )
    )
    echo:  ... done
  )
  echo SavePSPolicy >> %EPuck2_LogFile%
)
echo:

:ModifyPSPolicy
type %EPuck2_LogFile% 2>nul | findstr ModifyPSPolicy >nul
if errorlevel 1 (
  echo Modify PowerShell policy in order to run scripts ...
  reg add hklm\Software\Policies\Microsoft\Windows\PowerShell /v EnableScripts /t REG_DWORD /d 00000001 /f >nul 2>>%EPuck2_LogFile%
  reg add hklm\Software\Policies\Microsoft\Windows\PowerShell /v ExecutionPolicy /t REG_sZ /d Unrestricted /f >nul 2>>%EPuck2_LogFile%
  echo:  ... done
  echo ModifyPSPolicy >> %EPuck2_LogFile%
  echo:
)

powershell -ExecutionPolicy ByPass %EPuck2_InstallerPath%/DoNotLaunchDirectly.ps1

:RestorePSPolicy
@echo off
type %EPuck2_LogFile% 2>nul | findstr RestorePSPolicy >nul
if errorlevel 1 (
  echo Restore previously saved PowerShell policy ...
  reg delete hklm\Software\Policies\Microsoft\Windows\PowerShell /f > nul 2>>%EPuck2_LogFile%
  reg import %EPuck2_InstallerPath%\PowerShellPoliciesBackup.reg > nul 2>>%EPuck2_LogFile%
  del %EPuck2_InstallerPath%\PowerShellPoliciesBackup.reg > nul 2>>%EPuck2_LogFile%
  echo:  ... done
  echo RestorePSPolicy >> %EPuck2_LogFile%
)

:end
echo:
echo End of the batch. Press any key in order to exit it
pause > nul

:finalEnd