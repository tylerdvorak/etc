#Setup Script for Tonberry Desktop
Set-ExecutionPolicy RemoteSigned
#Define Variables

$psDriveParameters_S = @{
  Name       = "S"
  PSProvider = "FileSystem"
  Root       = "\\192.168.1.200\Susanoo"
  Persist    = $true
}

$psDriveParameters_S = @{
  Name       = "S"
  PSProvider = "FileSystem"
  Root       = "\\192.168.1.200\Susanoo"
  Persist    = $true
}

#Start WorkFlow
workflow Computer-Setup
{
 #Rename Computer
  Rename-Computer -NewName Tonberry -Force -Passthru

  #Map Network Drives
  New-Object -TypeName System.Management.Automation.PSDriveInfo -ArgumentList @(
    $psDriveParameters_A.Name,
    $psDriveParameters_A.PSProvider,
    $psDriveParameters_A.Root,
    $psDriveParameters_A.Description,
    $psDriveParameters_A.Credential,
    $psDriveParameters_A.DisplayRoot,
    $psDriveParameters_A.Persist,
    $psDriveParameters_A.CurrentLocation
)  
New-Object -TypeName System.Management.Automation.PSDriveInfo -ArgumentList @(
    $psDriveParameters_S.Name,
    $psDriveParameters_S.PSProvider,
    $psDriveParameters_S.Root,
    $psDriveParameters_S.Description,
    $psDriveParameters_S.Credential,
    $psDriveParameters_S.DisplayRoot,
    $psDriveParameters_S.Persist,
    $psDriveParameters_S.CurrentLocation
)

These New-Object statements create instances of the System.Management.Automation.PSDriveInfo class with the specified parameters, replicating the functionality of the New-PSDrive cmdlet.

  #Run Windows Updates
  Install-Module PSWindowsUpdate 
  Import-Module PSWindowsUpdate
  Add-WUServiceManager -MicrosoftUpdate
  Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Force
  Restart-Computer -Wait

  #Download and Install Cursors
  New-Item -ItemType  Directory -Path C:\temp
  Invoke-WebRequest -Uri "http://www.michieldb.nl/other/cursors/Posy's%20Cursor%20Black.zip" -OutFile C:\temp\posycursorblack.zip
  Expand-Archive C:\temp\posycursorblack.zip -DestinationPath C:\temp\posycursorblack\
  Get-ChildItem "C:\temp\posycursorblack" -Recurse -Filter "*inf" | ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install }
  Invoke-Command {reg import .\test.reg *>&1 | Out-Null}

  #Run Winget to install packages #Restart After Setting Term Fonts
  winget import winget.json

  #Download and Install Additional Fonts
  choco update chocolatey
  choco install nerd-fonts-iosevka
  choco install nerd-fonts-iosevkaterm
  Restart-Computer -Wait

  #Set GlazeWM on Startup

  $shell = New-Object -comObject WScript.Shell
  $shortcut = $shell.CreateShortcut("%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\GlazeWM.lnk")
  $shortcut.TargetPath = "C:\Users\$Env:UserName\AppData\Local\Microsoft\WinGet\Packages\lars-berger.GlazeWM_Microsoft.Winget.Source_8wekyb3d8bbwe\GlazeWM_x64_1.11.1.exe"
  $shortcut.Save()

  
  #Move dotfiles to where they belong
  Copy-Item .\.glaze-wm C:\Users\$Env:UserName\
  Copy-Item .\.config C:\Users\$Env:UserName\
  Copy-Item .\terminal\settings.json %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

  #Setup Taskbar? See https://github.com/Ccmexec/PowerShell/tree/c8d2b8b57d4bcd860a2cef9b0753b04280187203/Customize%20TaskBar%20and%20Start%20Windows%2011
  $CustomizeTaskbar = Invoke-WebRequest https://github.com/Ccmexec/PowerShell/blob/master/Customize%20TaskBar%20and%20Start%20Windows%2011/CustomizeTaskbar.ps1
  Invoke-Expression $($CustomizeTaskbar)
  
  #Run Chris Titus Tool for Additional Setup, Credit to Chris Titus (https://christitus.com/windows-tool/)
  iwr -useb https://christitus.com/win | iex
}

Computer-Setup

