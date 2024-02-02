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

REM powershell -ExecutionPolicy ByPass %EPuck2_InstallerPath%/windows.ps1
REM goto End

:InstallStarted
type %EPuck2_LogFile% 2>nul | findstr InstallStarted >nul
if errorlevel 1 (
  echo:   ******************************************************************************************************
  echo:   *                                                                                                    *
  echo:   *  For technical reason this batch must be executed many time until this message will be displayed:  *
  echo:   *                                                                                                    *
  echo:   *     "The installation must be complete. It is no longer necessary to run this script again !!"     *
  echo:   *                                                                                                    *
  echo:   *  Press any key to start...                                                                         *
  echo:   *                                                                                                    *
  echo:   ******************************************************************************************************
  pause > nul
  echo InstallStarted >> %EPuck2_LogFile%
  cls
)

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

:CheckPyEnv
type %EPuck2_LogFile% 2>nul | findstr CheckPyEnv >nul
if errorlevel 1 (
  echo Check if PyEnv-win is already installed ...
  if "%PYENV%" EQU "" (
    echo:    ... Not already installed then download ...
    cmd /Q /C Powershell.exe -ExecutionPolicy ByPass -Command "Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1' -OutFile '%EPuck2_InstallerPath%/install-pyenv-win.ps1'" >nul 2>>%EPuck2_LogFile%
    echo:    ... And install ...
    cmd /Q /C Powershell.exe -ExecutionPolicy ByPass -Command "%EPuck2_InstallerPath%/install-pyenv-win.ps1" >nul 2>>%EPuck2_LogFile%
    type %USERPROFILE%\.pyenv\.version >%EPuck2_InstallerPath%\pyenvVersion.txt
    setlocal EnableDelayedExpansion
    SET /P pyenvVersion=<%EPuck2_InstallerPath%\pyenvVersion.txt
    echo:  ... fresh install of PyEnv !pyenvVersion!
    ) else (
    type %PYENV%\..\.version >%EPuck2_InstallerPath%\pyenvVersion.txt
    setlocal EnableDelayedExpansion
    SET /P pyenvVersion=<%EPuck2_InstallerPath%\pyenvVersion.txt
    echo:  ... PyEnv !pyenvVersion! was already installed
  )
  setlocal DisableDelayedExpansion
  echo CheckPyEnv >> %EPuck2_LogFile%
  echo:
)

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
  echo:
  echo:   *************************************************************
  echo:   *                                                           *
  echo:   *  IMPORTANT                                                *
  echo:   *                                                           *
  echo:   *  Run again the script in order to take in account the     *
  echo:   *  Pyenv install and continue the rest of the installation  *
  echo:   *                                                           *
  echo:   *************************************************************
  echo:
  goto end
)

:InstallSoftwares
type %EPuck2_LogFile% 2>nul | findstr InstallSoftwares >nul
if errorlevel 1 (
  echo Installing python 3.11.2
  pyenv install 3.11.2 2>>%EPuck2_LogFile%
  echo: Rename this python 3.11.2 to e-puck2 ...
  rename %PYENV%\versions\3.11.2 e-puck2 >nul 2>>%EPuck2_LogFile%
  echo:   ... rename done
  cd %EPuck2_InstallerPath%
  pyenv local e-puck2
  echo: Installing packages required for installation
  python -m ensurepip --upgrade 2>>%EPuck2_LogFile%
  python -m pip install --upgrade pip 2>>%EPuck2_LogFile%
  python -m pip install PyQT5 termcolor requests 2>>%EPuck2_LogFile%

  echo InstallSoftwares >> %EPuck2_LogFile%
  echo:
  echo:   *****************************************************************
  echo:   *                                                               *
  echo:   *  IMPORTANT                                                    *
  echo:   *                                                               *
  echo:   *  Run again the script in order to take in account this        *
  echo:   *  Softwares install and continue the rest of the installation  *
  echo:   *                                                               *
  echo:   *****************************************************************
  echo:
  REM It seems that next goto doesn't work but I don't understand why
  REM That's why I add the same "end" code
  echo End of the batch. Press any key in order to exit it
  pause > nul
  goto end
)

echo "Launching the final installer"
pause
cd %EPuck2_InstallerPath%
echo ON
python Universal/main.py

:EverythingDone
echo:
echo The installation must be complete. It is no longer necessary to run this script again !!

:end
echo:
echo End of the batch. Press any key in order to exit it
pause > nul

:finalEnd