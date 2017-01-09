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