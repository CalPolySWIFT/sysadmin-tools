@echo off
echo Disabling netBIOS

wmic nicconfig get caption,index,TcpipNetbiosOptions
:disablenetbios
echo Enter "index" of the NIC you want to disable NETBIOS on...
set /p index=

wmic nicconfig where index=%index% call SetTcpipNetbios 2

echo [OK]

echo Do you want to disable another NIC? (y/n)

set /p netbios=

if %netbios% == y goto disablenetbios
if %netbios% == n echo OK
pause