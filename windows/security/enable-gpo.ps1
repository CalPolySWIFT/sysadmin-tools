regedit /E c:\all.reg
echo backup complete
pause

REG add "HKCU\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}" /v Restrict_Run /t REG_DWORD /d 0 /f
echo GPO's enabled
pause