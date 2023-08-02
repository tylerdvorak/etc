#Setup Script for Tonberry Desktop

#Define Variables and Reboot Workflow
workflow Setup-Computer
{
 #Rename Computer
  Rename-Computer -NewName Tonberry -Force -Passthru

  #Map Network Drives
  New-PSDrive -Name "A" -PSProvider "FileSystem" -Root "\\192.168.1.200\Ark" -Persist
  New-PSDrive -Name "S" -PSProvider "FileSystem" -Root "\\192.168.1.200\Susanoo" -Persist

  #Run Windows Updates
  Install-Module PSWindowsUpdate 
  Add-WUServiceManager -MicrosoftUpdate
  Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Force
  Rename-And-Reboot PowerShellWorkflows

  #Download and Install Cursors
  New-Item -ItemType  Directory -Path C:\temp
  Invoke-WebRequest -Uri "http://www.michieldb.nl/other/cursors/Posy's%20Cursor%20Black.zip" -OutFile C:\temp\posycursorblack.zip
  Expand-Archive C:\temp\posycursorblack.zip -DestinationPath C:\temp\posycursorblack\
  Get-ChildItem "C:\temp\posycursorblack" -Recurse -Filter "*inf" | ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install }
  Invoke-Command {reg import .\test.reg *>&1 | Out-Null}

  #Run Winget to install packages
  winget import winget.json
  Restart-Computer -Wait

  #Set GlazeWM on Startup
  InlineScript
  {    
    $shell = New-Object -comObject WScript.Shell
    $shortcut = $shell.CreateShortcut("%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\GlazeWM.lnk")
    $shortcut.TargetPath = "C:\Users\$Env:UserName\AppData\Local\Microsoft\WinGet\Packages\lars-berger.GlazeWM_Microsoft.Winget.Source_8wekyb3d8bbwe\GlazeWM_x64_1.11.1.exe"
    $shortcut.Save()
  }
  
  #Move dotfiles to where they belong
  Copy-Item .\.glaze-wm C:\Users\$Env:UserName\
  Copy-Item .\.config C:\Users\$Env:UserName\
  Copy-Item .\terminal\settings.json %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

  #Run Chris Titus Tool for Additional Setup, Credit to Chris Titus (https://christitus.com/windows-tool/)
  iwr -useb https://christitus.com/win | iex
}


