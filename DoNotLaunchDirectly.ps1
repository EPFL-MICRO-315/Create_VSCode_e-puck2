param (
    [Switch] $EPuck2_Debug = $False
)

Function Exit-Error() {
    $Temp = "

    !!!!   " + $Message + "   !!!!
"
    Add-Content -Path $EPuck2_LogFile -Value $Temp
    Write-Host $Temp
    EXIT 1
}

Function Display-Starting() {
    $Temp = "

    "+ $Message + "  >>>>>>" +"
"
    Add-Content -Path $EPuck2_LogFile -Value $Temp
    Write-Host $Temp
}

Function Display-End() {
    $Temp = "

    >>>>>>  " + $Message + "
"
    Add-Content -Path $EPuck2_LogFile -Value $Temp
    Write-Host $Temp
}

$Epuck2_InstallerPath = $PSScriptRoot
#Ensure to be in the installer folder like that every downloads will be there to facilitate the cleaning
Set-Location -Path $Epuck2_InstallerPath

#Create a log file about script work
$EPuck2_LogFile = $EPuck2_InstallerPath + "/Install.log"

$Message = "Installer started in " + $EPuck2_InstallerPath
Display-Starting

################################################
# Section: Install or update checking of PyEnv #
################################################
$Section = "Install or update PyEnv"
if (-not ((Get-Content -Path $EPuck2_LogFile) -ccontains $Criteria)) {
    $Message = $Section + ": starting"
    Display-Starting

    # Download anyway Pyenv installer because it will check and install the last version if necessary
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile $EPuck2_InstallerPath"/install-pyenv-win.ps1" >$null 2>>$EPuck2_LogFile
    IF ($?) {
        Add-Content -Path $EPuck2_LogFile -Value "        ... PyEnv installer downloaded anyway in order to check if update is necessary"
    }
    ELSE {
        $Message = "Download problem of PyEnv installer: Check " + $EPuck2_LogFile + " and ask support!"
        Exit-Error
    }

    # Equivalent to "Reload session" in order to take in account the possible previous Pyenv install
    # Only these variables could be changed by Pyenv install
    Add-Content -Path $EPuck2_LogFile -Value "   ... Environment variables that can be modified by Pyenv have been reloaded"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + [System.Environment]::GetEnvironmentVariable("Path","Machine") 
    $env:PYENV = [Environment]::GetEnvironmentVariable('PYENV', 'User')
    $env:PYENV_HOME = [Environment]::GetEnvironmentVariable('PYENV_HOME', 'User')
    $env:PYENV_ROOT = [Environment]::GetEnvironmentVariable('PYENV_ROOT', 'User')

    # Let the script test if PyEnv is already installed and update/install if necessary
    & .\install-pyenv-win.ps1 *>>$EPuck2_LogFile

    # Equivalent to "Reload session" in order to take in account the possible Pyenv install
    # Only these variables could be changed by Pyenv install
    Add-Content -Path $EPuck2_LogFile -Value "   ... Environment variables that can be modified by Pyenv have been reloaded"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + [System.Environment]::GetEnvironmentVariable("Path","Machine") 
    $env:PYENV = [Environment]::GetEnvironmentVariable('PYENV', 'User')
    $env:PYENV_HOME = [Environment]::GetEnvironmentVariable('PYENV_HOME', 'User')
    $env:PYENV_ROOT = [Environment]::GetEnvironmentVariable('PYENV_ROOT', 'User')

    $Message = "        ... PyEnv " + (Get-Content -Path ($env:PYENV + "../.version")) + " will be used."
    IF ($?) {
        Write-Host $Message
        Add-Content -Path $EPuck2_LogFile -Value $Message
    }

    $Message = $Section + ": done"
    Display-End
}

##################################
# Section: Install Python 3.11.2 #
##################################
$Section = "Install Python 3.11.2"
if (-not ((Get-Content -Path $EPuck2_LogFile) -ccontains $Criteria)) {
    $Message = $Section + ": starting"
    Display-Starting

    # Install Python with PyEnv
    pyenv install 3.11.2 2>>$EPuck2_LogFile
    IF (-not $?) {
        $Message = $Section + " problem: Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }

    $Message = $Section + ": done"
    Display-End
}

#################################
# Section: Rename Python 3.11.2 #
#################################
$Section = "Rename Python 3.11.2"
if (-not ((Get-Content -Path $EPuck2_LogFile) -ccontains $Criteria)) {
    $Message = $Section + ": starting"
    Display-Starting

    # Under Windows PyEnv doesn't have virtualenv fucntionality
    # Then rename folder 3.11.2 in e-puck2, simulating an specific environment
    $Temp = $env:PYENV + "versions"
    ren $Temp/3.11.2 $Temp/e-puck2 *>>$EPuck2_LogFile
    IF (-not $?) {
        $Message = $Section + " problem (Rename): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }
    $Temp = pyenv versions
    if (-not ($Temp -match "e-puck2")) {
        $Message = $Section + " problem (PyEnv): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }
    $Message = $Section + ": done"
    Display-End
}

#######################################
# Section: Set local PyEnv on e-puck2 #
#######################################
$Section = "Set local PyEnv on e-puck2"
$Criteria = $Section + ": done"
if (-not ((Get-Content -Path $EPuck2_LogFile) -ccontains $Criteria)) {
    $Message = $Section + ": starting"
    Display-Starting

    # Do that in the Installer folder in order to avoid to have this e-puck2 environment anywhere
    cd $EPuck2_InstallerPath
    pyenv rehash
    pyenv local e-puck2 | Tee-Object -Append $EPuck2_LogFile
    # Check the result
    $Temp = pyenv local | Tee-Object -Append $EPuck2_LogFile
    IF (-not $?) {
        $Message = $Section + " problem (PyEnv local): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }
    IF (-not ($Temp -match "e-puck2")) {
        $Message = $Section + " problem (Not e-puck2): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }
    # Check Python version
    $Temp = python --version | Tee-Object -Append $EPuck2_LogFile
    IF (-not $?) {
        $Message = $Section + " problem (Python  --version): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }
    IF (-not ($Temp -match "Python 3.11.2")) {
        $Message = $Section + " problem (Not right Python version): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }
    $Message = $Section + ": done"
    Display-End
}

#############################################
# Section: Install required Python Packages #
#############################################
$Section = "Install required Python packages"
$Criteria = $Section + ": done"
if (-not ((Get-Content -Path $EPuck2_LogFile) -ccontains $Criteria)) {
    $Message = $Section + ": starting"
    Display-Starting

    # Do that in the Installer folder in order to avoid to have this e-puck2 environment anywhere
    cd $EPuck2_InstallerPath

    python -m ensurepip --upgrade | Tee-Object -Append $EPuck2_LogFile
    IF (-not $?) {
        $Message = $Section + " problem (ensurepip): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }

    python -m pip install --upgrade pip | Tee-Object -Append $EPuck2_LogFile
    IF (-not $?) {
        $Message = $Section + " problem (upgrade pip): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }

    python -m pip install PyQT5 termcolor requests | Tee-Object -Append $EPuck2_LogFile
    IF (-not $?) {
        $Message = $Section + " problem (pip install): Check " + $EPuck2_LogFile + " and ask support"
        Exit-Error
    }

    $Message = $Section + ": done"
    Display-End
}

Write-Host "Finally launch python installer"

python Universal/main.py install

$Message = "Installer done"
Display-End