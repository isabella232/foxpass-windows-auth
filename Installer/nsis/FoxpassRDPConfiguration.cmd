reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server" /v UserAuthentication /t REG_DWORD /d 0 /f

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v SecurityLayer /t REG_DWORD /d 0 /f

net localgroup "Remote Desktop Users" "Everyone" /add

echo "Foxpass RDP Configuration Done.... "