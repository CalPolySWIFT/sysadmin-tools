@echo off
color a

pause
echo Backing Up security config

@echo off
secedit.exe /export /cfg C:\secconfig.cfg

echo Stoping lmhosts
sc stop lmhosts

echo Starting Password Policy Config
pause

net accounts /minpwlen:7
net accounts /maxpwage:30
net accounts /minpwage:1
net accounts /uniquepw:4
net accounts /lockoutthreshold:6
net accounts /lockoutwindow:30


echo Backing Up security config
pause
@echo off
secedit.exe /export /cfg C:\secconfigPost.cfg

pause