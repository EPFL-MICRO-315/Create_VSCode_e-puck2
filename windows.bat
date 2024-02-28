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

:BackupPSPolicy
echo Backup actual PowerShell policy ...
echo Backup actual PowerShell policy ... >> %EPuck2_LogFile%
reg query hklm\Software\Policies\Microsoft\Windows\PowerShell_Backup  >nul 2>&1
if errorlevel 1 (
  reg copy hklm\Software\Policies\Microsoft\Windows\PowerShell hklm\Software\Policies\Microsoft\Windows\PowerShell_Backup /f >nul 2>&1
  if errorlevel 1 (
    reg add hklm\Software\Policies\Microsoft\Windows\PowerShell_Backup /v Info /d "PowerShell policy was not configured before install of VSCode_e-puck2" /f >nul 2>&1
    echo:    ... PowerShell policy was not configured
    echo:    ... PowerShell policy was not configured >> %EPuck2_LogFile%
  ) else (
    reg add hklm\Software\Policies\Microsoft\Windows\PowerShell_Backup /v Info /d "Backup of PowerShell policy before install of VSCode_e-puck2" /f >nul 2>&1
    echo:    ... done
    echo:    ... done >> %EPuck2_LogFile%
  )
) else (
  echo:    ... already done
  echo:    ... already done >> %EPuck2_LogFile%
)
echo:

:ModifyPSPolicy
echo Modify PowerShell policy in order to run scripts ...
echo Modify PowerShell policy in order to run scripts ...  >> %EPuck2_LogFile%
reg add hklm\Software\Policies\Microsoft\Windows\PowerShell /v EnableScripts /t REG_DWORD /d 00000001 /f >nul 2>>%EPuck2_LogFile%
reg add hklm\Software\Policies\Microsoft\Windows\PowerShell /v ExecutionPolicy /t REG_sZ /d Unrestricted /f >nul 2>>%EPuck2_LogFile%
echo:    ... done
echo:    ... done >> %EPuck2_LogFile%
echo:
)

powershell Unblock-File %EPuck2_InstallerPath%/DoNotLaunchDirectly.ps1
powershell -ExecutionPolicy ByPass %EPuck2_InstallerPath%/DoNotLaunchDirectly.ps1

:RestorePSPolicy
echo Restore previously saved PowerShell policy ...
echo Restore previously saved PowerShell policy ... >>%EPuck2_LogFile%
reg delete hklm\Software\Policies\Microsoft\Windows\PowerShell /f > nul 2>>%EPuck2_LogFile%
powershell -Command "if (((Get-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\PowerShell_Backup).Info) -match 'PowerShell.*VSCode_e-puck2') { exit 1 }"
if errorlevel 1 (
  powershell -Command "if ((Get-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\PowerShell_Backup).Info -match 'Backup of PowerShell policy before install of VSCode_e-puck2') { exit 1 }"
  if errorlevel 1 (
    reg copy hklm\Software\Policies\Microsoft\Windows\PowerShell_Backup hklm\Software\Policies\Microsoft\Windows\PowerShell /f >nul 2>&1
    reg delete hklm\Software\Policies\Microsoft\Windows\PowerShell /v Info /f >nul 2>&1
  )
  reg delete hklm\Software\Policies\Microsoft\Windows\PowerShell_Backup /f >nul 2>&1
  echo:    ... done
  echo:    ... done >> %EPuck2_LogFile%
) else (
  echo:    ... Error : This situation should not happen - Ask Daniel Burnier, please!!
  echo:    ... Error : This situation should not happen - Ask Daniel Burnier, please!! >> %EPuck2_LogFile%
)

:end
echo:
echo End of the batch. Press any key in order to exit it
pause > nul

:finalEnd