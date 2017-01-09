@echo off
color a
echo Backing up the firewall...
netsh advfirewall export C:\firewall.wfw

echo Turning on the firewall...
netsh advfirewall set allprofiles state on

echo Enabling logging...
netsh advfirewall set allprofiles logging droppedconnections enable
netsh advfirewall set allprofiles logging allowedconnections enable

echo Reseting firewall....
netsh advfirewall reset

echo Blocking all Traffic...
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

echo Deleting rules...
netsh advfirewall firewall delete rule name=all