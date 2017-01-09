@echo off
color a
echo Backing up the firewall...
echo Location at C:\firewallbackup.wfw
netsh advfirewall export C:\firewallbackup.wfw


echo Turning on the firewall...
netsh advfirewall set allprofiles state on


echo Enabling logging...
echo Dropped
netsh advfirewall set allprofiles logging droppedconnections enable
echo Allowed
netsh advfirewall set allprofiles logging allowedconnections enable

echo Reseting firewall....
netsh advfirewall reset

echo Setting firewall defaults for traffic...
echo Do you want to:
echo 1. block inbound, block outbound
echo 2. block inbound, allow outbound
echo 3. allow inbound, block outbound
echo 4. allow inbound, allow outbound

set /p firewallchoice=

if %firewallchoice% == 1 goto 1
if %firewallchoice% == 2 goto 2
if %firewallchoice% == 3 goto 3
if %firewallchoice% == 4 goto 4

:1
echo Blocking all Traffic...

netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound
goto :endoffirewall

:2
echo Blocking inbound and allowing outbound...
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound
goto :endoffirewall

:3
echo Allowing inbound and Blocking outbound...
netsh advfirewall set allprofiles firewallpolicy allowinbound,blockoutbound
goto :endoffirewall

:4
echo Allowing all traffic...
netsh advfirewall set allprofiles firewallpolicy allowinbound,allowoutbound
goto endoffirewall

:endoffirewall

echo Do you want to delete all current firewall rules... (y/n)
set /p delete=
if %delete% == y netsh advfirewall firewall delete rule name=all
if %delete% == n echo [OK]

@echo off
echo Disabling netBIOS

wmic nicconfig get caption,index,TcpipNetbiosOptions
:disablenetbios
echo Enter "index" of the NIC you want to disable NETBIOS on...
set /p index=

wmic nicconfig where index=%index% call SetTcpipNetbios 2

echo [OK]

echo Do you want to disable netBios on another NIC? (y/n)

set /p netbios=

if %netbios% == y goto disablenetbios
if %netbios% == n echo OK

@echo off
setlocal enableDelayedExpansion

echo Creating Firewall rules...
set spy_apps=^
	"Windows\explorer.exe"^
	"Windows\System32\lsass.exe"^
	"Windows\System32\rundll32.exe"^
	"Windows\System32\wbem\WmiPrvSE.exe"^
  "Windows\System32\WindowsPowerShell\v1.0\powershell.exe"^
	"Windows\SysWOW64\rundll32.exe"^
	"Windows\SysWOW64\wbem\WmiPrvSE.exe"^
	"Windows\SysWOW64\WerFault.exe"^
	"Windows\SysWOW64\wermgr.exe"^
	"Windows\SysWOW64\WWAHost.exe"^
  "Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"

for %%i in (%spy_apps%) do (
	set item=%%i
	set file_path="%SystemDrive%\!item:~1!
	if exist !file_path! (
		echo !file_path! | find "SysWOW64" > nul
		if errorlevel 1 (
			set rule_name=%%~nxi_BLOCK
		) else (
			set rule_name=%%~nxi-SysWOW64_BLOCK
		)
		netsh advfirewall firewall show rule !rule_name! > nul
		if errorlevel 1 (
			echo | set /p=!rule_name!
			netsh advfirewall firewall add rule name=!rule_name! dir=out interface=any action=block program=!file_path! > nul
			set frw_rule_added=1
			echo [OK]
		)
	)
)

echo.
echo Finished.
pause