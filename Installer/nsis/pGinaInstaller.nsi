# NSIS Installer config file for pGina
#
# Requires DotNetChecker plugin from: https://github.com/ProjectHuman/NsisDotNetChecker
#
!include LogicLib.nsh
!include WinVer.nsh
!include x64.nsh
!include DotNetChecker.nsh
!include MUI2.nsh

!define APPNAME "Foxpass Windows Auth"
!define VERSION "1.0.0.1"
#!define MyAppPublisher "Foxpass Inc"

RequestExecutionLevel admin  ; Require admin rights

Name "${APPNAME} - ${VERSION}"   ; Name in title bar
OutFile "${APPNAME}-${VERSION}-setup.exe" ; Output file
#Publisher "${MyAppPublisher}" ;

# UI configuration
!define MUI_ABORTWARNING
!define MUI_ICON "..\..\pGina\src\Configuration\Resources\pginaicon_redcircle.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "images\welcome-finish.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "images\welcome-finish.bmp"
!define MUI_COMPONENTSPAGE_SMALLDESC

# Installer pages
!define MUI_PAGE_HEADER_TEXT "Install Foxpass Windows Auth ${VERSION}"
!define MUI_WELCOMEPAGE_TITLE "Install Foxpass Windows Auth ${VERSION}"
!insertmacro MUI_PAGE_WELCOME 
!insertmacro MUI_PAGE_LICENSE ..\..\LICENSE
!insertmacro MUI_PAGE_DIRECTORY 
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Custom function callbacks
!define MUI_CUSTOMFUNCTION_GUIINIT GuiInit

# Language files
!insertmacro MUI_LANGUAGE "English"

VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${APPNAME} Setup"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Foxpass Windows Auth Team"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Foxpass Windows Auth installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copyright © 2021 Foxpass, Inc."
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" ${VERSION} 
VIProductVersion ${VERSION}

########################
# Functions            #
########################
Function GuiInit
  # Determine the installation directory.  If were 64 bit, use
  # PROGRAMFILES64, otherwise, use PROGRAMFILES. 
  ${If} ${RunningX64}
    StrCpy $INSTDIR "$PROGRAMFILES64\Foxpass"
    SetRegView 64
  ${Else}
    StrCpy $INSTDIR "$PROGRAMFILES\Foxpass"
  ${EndIf}
FunctionEnd

#############################################
# Sections                                  #
#############################################

Section -Prerequisites
  # Check for and install .NET 4
  !insertmacro CheckNetFramework 40Full
SectionEnd

Section "Foxpass Windows Auth" InstallpGina 
  SectionIn RO ; Make this option read-only

  SetOutPath $INSTDIR
  File "..\..\pGina\src\bin\*.exe"
  File "..\..\pGina\src\bin\*.dll"
 # File "..\..\pGina\src\bin\log4net.xml"
  File "..\..\pGina\src\bin\*.config"

  ${If} ${AtLeastWin7}
    SetOutPath $INSTDIR\Win32
    File "..\..\pGina\src\bin\Win32\FoxpassCredentialProvider.dll"
    SetOutPath $INSTDIR\x64
    File "..\..\pGina\src\bin\x64\FoxpassCredentialProvider.dll"
  ${Else}
    SetOutPath $INSTDIR\Win32
    File "..\..\pGina\src\bin\Win32\FoxpassAuth.dll"
    SetOutPath $INSTDIR\x64
    File "..\..\pGina\src\bin\x64\FoxpassAuth.dll"
  ${EndIf}

   WriteUninstaller "$INSTDIR\FoxpassWindowsAuth-Uninstall.exe"
SectionEnd

#Drupal
Section "Core plugins" InstallCorePlugins
  SetOutPath $INSTDIR\Plugins
  File "..\..\Plugins\bin\*.dll"
SectionEnd

#drupal
#Section "Contributed plugins" InstallContribPlugins
 # SetOutPath $INSTDIR\Plugins\Contrib
 # File "..\..\Plugins\Contrib\bin\*.dll"
#SectionEnd

Section /o "Visual C++ redistributable package" InstallVCRedist
  SetOutPath $INSTDIR 
  ${If} ${RunningX64}
     File "G:\Foxpass\pgina-3.9.9.12\pgina-3.9.9.12\Installer\vc_redist.x64.exe"
     ExecWait "$INSTDIR\vcredist_x64.exe"
     Delete $INSTDIR\vcredist_x64.exe
  ${Else}
     File "G:\Foxpass\pgina-3.9.9.12\pgina-3.9.9.12\Installer\vc_redist.x86.exe"
     ExecWait "$INSTDIR\vcredist_x86.exe"
     Delete $INSTDIR\vcredist_x86.exe
  ${EndIf}
SectionEnd

Section ; Run installer script
  SetOutPath $INSTDIR
  ExecWait '"$INSTDIR\Foxpass.InstallUtil.exe" post-install'
SectionEnd

Section  
CreateShortcut "$DESKTOP\Foxpass Windows Login.lnk" "$INSTDIR\Foxpass.Windows.Auth.exe"
SectionEnd

Section "un.FoxpassWindowsAuth" ; Uninstall pGina
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}

  SetOutPath $INSTDIR
  Delete $INSTDIR\Foxpass.Abstractions.dll
  ExecWait '"$INSTDIR\Foxpass.InstallUtil.exe" post-uninstall'
   ExecShell "print" "after"
   Delete $INSTDIR\Plugins\*.dll
  Delete $INSTDIR\*.exe
  Delete $INSTDIR\*.dll
  Delete $INSTDIR\log4net.xml
  Delete $INSTDIR\*.config
  Delete $INSTDIR\*.InstallLog
  RmDir $INSTDIR\Plugins

  ${If} ${AtLeastWin7}
    Delete "$INSTDIR\Win32\FoxpassCredentialProvider.dll"
    Delete "$INSTDIR\x64\FoxpassCredentialProvider.dll"
  ${Else}
    Delete "$INSTDIR\Win32\FoxpassAuth.dll"
    Delete "$INSTDIR\x64\FoxpassAuth.dll"
  ${EndIf}
  RmDir $INSTDIR\Win32
  RmDir $INSTDIR\x64
  
  ###test
  ExecShell "print" "end"
   Delete $INSTDIR\Plugins\*.dll
  Delete $INSTDIR\*.exe
  Delete $INSTDIR\*.dll
  Delete $INSTDIR\log4net.xml
  Delete $INSTDIR\*.config
  Delete $INSTDIR\*.InstallLog
  RmDir $INSTDIR\Plugins
  
SectionEnd

Section "un.Delete FoxpassWindowsAuth configuration"
  DeleteRegKey HKLM "SOFTWARE\FoxpassWindowsAuth"
SectionEnd

Section "un.Delete FoxpassWindowsAuth logs"
  Delete $INSTDIR\log\*.txt
  RmDir $INSTDIR\log
SectionEnd

Section "un."
  RmDir $INSTDIR
SectionEnd

#######################################
# Descriptions
#######################################
LangString DESC_InstallpGina ${LANG_ENGLISH} "Install Foxpass Windows Auth (required)."
LangString DESC_InstallCorePlugins ${LANG_ENGLISH} "Install Foxpass Windows Auth plugins."
##LangString DESC_InstallContribPlugins ${LANG_ENGLISH} "Install community contributed plugins."
LangString DESC_InstallVCRedist ${LANG_ENGLISH} "Visual C++ redistributable package is required. However, it may already be installed on your system."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${InstallpGina} $(DESC_InstallpGina)
  !insertmacro MUI_DESCRIPTION_TEXT ${InstallCorePlugins} $(DESC_InstallCorePlugins)
  !insertmacro MUI_DESCRIPTION_TEXT ${InstallContribPlugins} $(DESC_InstallContribPlugins)
  !insertmacro MUI_DESCRIPTION_TEXT ${InstallVCRedist} $(DESC_InstallVCRedist)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

