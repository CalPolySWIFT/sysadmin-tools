@echo off
color 02

pause
echo Press any key to begin..

regedit /E c:\all.reg
echo Backing up Reg

echo Enabling GPO
reg add "HKCU\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}" /v Restrict_Run /t REG_DWORD /d 0 /f

echo Enabling UAC
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

echo Enabling Password Requirment for UAC
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 1 /f

@echo off
gpupdate /force
pause

echo Update Complete.