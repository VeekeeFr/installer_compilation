;--------------------------------
;Include Modern UI

!include "MUI2.nsh"

;--------------------------------
;General

Name "Installer compilation"
OutFile "InstallerCompilation.exe"
Unicode True
ShowInstDetails show
;Request application privileges for Windows Vista
RequestExecutionLevel user

;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${__FILEDIR__}\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_NOAUTOCLOSE

!include "${__FILEDIR__}\common.nsh"

!system 'for /d /R %D in (apps/*) do echo !insertmacro IncludeApp "%~nxD" > "${INSTALLER_APPS}"'

!include "${INSTALLER_APPS}"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!include "${INSTALLER_ONINIT}"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onGUIEnd
	RMDir /r "${GLOBAL_TEMP_FOLDER}"
FunctionEnd