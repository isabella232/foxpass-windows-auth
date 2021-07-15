# foxpass-windows-auth

A windows login client backed by Foxpass LDAP server.

# Development setup

1. Prerequisites Software.
    - Visual Studio 2019 - C#.net package
        - Open \pGina\src\pGina-3.x-vs2010.sln in it
    - NSIS installer Might need to copy DotNetChecker.dll to  C:\Program Files (x86)\NSIS\Plugins\x86-ansi after installing NSIS
    - Download NSIS: Nullsoft Scriptable Install System from SourceForge.net
    
2. Code Build and deploy
	- Run make.cmd located at <Path>\Installer\ that will build the full code

3. Creating the installer
	- Start the NSIS installer. Click on Compile NSI scripts - In a new window File => Load Script and select the "<Path>\Installer\nsis\pGinaInstaller.nsi" after running that new installer will create here /Installer/nsis/Foxpass Windows Auth-1.0.0.1-setup.exe

# Build and Debug
	- Solution \pGina\src\pGina-3.x-vs2010.sln is main solution and 
	- Plugin solutions "\Plugins\LdapPlugin\LdapPlugin.sln", "Plugins\LocalMachine\LocalMachine.sln"
