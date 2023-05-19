!insertmacro MUI_LANGUAGE "French"
!include LogicLib.nsh

!define GLOBAL_TEMP_FOLDER "$TEMP\installerCompilation"
!define INSTALLER_ONINIT "${__FILEDIR__}\dynamic_onInit.nsh"
!define INSTALLER_APPS "${__FILEDIR__}\dynamic_apps.nsh"

!appendfile "${INSTALLER_ONINIT}" ""

!include "${__FILEDIR__}\plugins\StrContains.nsh"
!addplugindir "${__FILEDIR__}\plugins\nsunzip"
!addplugindir "${__FILEDIR__}\plugins\execcmd"

!macro AddAppSection app
	!include "${__FILEDIR__}\apps\${app}\install.nsh"
!macroend

!macro IncludeAppExe app exe
	!echo "${app}"
	!echo "${exe}"

	File "apps\${app}\${exe}"
	ExecShell "runas" "${GLOBAL_TEMP_FOLDER}\${app}\${exe}"
!macroend

!macro CleanTempScriptFile file
	!echo "${file}"
	!if /FileExists "${file}"
		!delfile "${file}"
	!endif
!macroend

!macro IncludeScriptFile script
	!echo "${script}"
	!if /FileExists "${script}"
		!include "${script}"
	!endif
!macroend

!macro IncludeApp app

	!if /FileExists "${__FILEDIR__}\apps\${app}\config.ini"
		!searchparse /file "${__FILEDIR__}\apps\${app}\config.ini" "Name=" APP_NAME
		!searchparse /file "${__FILEDIR__}\apps\${app}\config.ini" "Description=" APP_DESCRIPTION
		!searchparse /file "${__FILEDIR__}\apps\${app}\config.ini" "File=" APP_FILE
		!searchparse /file "${__FILEDIR__}\apps\${app}\config.ini" "CommandLine=" APP_CMDLINE
		!searchparse /file "${__FILEDIR__}\apps\${app}\config.ini" "Arguments=" APP_ARGS
		!searchparse /file "${__FILEDIR__}\apps\${app}\config.ini" "UAC=" APP_MODE

		!appendfile "${INSTALLER_ONINIT}" `!insertmacro MUI_DESCRIPTION_TEXT ${Sec${app}} "${APP_DESCRIPTION}"$\n`

		Section "${APP_NAME}" Sec${app}

			CreateDirectory "${GLOBAL_TEMP_FOLDER}\${app}"
			SetOutPath "${GLOBAL_TEMP_FOLDER}\${app}"

			!insertmacro IncludeScriptFile "${__FILEDIR__}\apps\${app}\pre_install.nsh"

			File "${__FILEDIR__}\apps\${app}\${APP_FILE}"

			${StrContains} $R0 ".zip" "${APP_FILE}"

			${If} $R0 = ".zip"
				nsUnzip::Extract "*.zip" /END
			${EndIf}

			DetailPrint "Executing ${APP_CMDLINE} ${APP_ARGS}"
			${If} ${APP_MODE} == "yes"
				ExecShell "runas" "${GLOBAL_TEMP_FOLDER}\${app}\${APP_CMDLINE}"
			${Else}
				ExecWait '"${GLOBAL_TEMP_FOLDER}\${app}\${APP_CMDLINE}" ${APP_ARGS}'
			${EndIf}

			!insertmacro IncludeScriptFile "${__FILEDIR__}\apps\${app}\post_install.nsh"
		SectionEnd
	!else
		Section "${app}" Sec${app}

			CreateDirectory "${GLOBAL_TEMP_FOLDER}\${app}"
			SetOutPath "${GLOBAL_TEMP_FOLDER}\${app}"

			!insertmacro IncludeScriptFile "${__FILEDIR__}\apps\${app}\pre_install.nsh"

			!insertmacro CleanTempScriptFile "${__FILEDIR__}\apps\${app}\dynamic_exe.nsh"
			!system 'for %D in (apps/${app}/*.exe) do echo !insertmacro IncludeAppExe "${app}" "%~nxD" >> "${__FILEDIR__}\apps\${app}\dynamic_exe.nsh"'
			!insertmacro IncludeScriptFile "${__FILEDIR__}\apps\${app}\dynamic_exe.nsh"
			!insertmacro CleanTempScriptFile "${__FILEDIR__}\apps\${app}\dynamic_exe.nsh"

			!insertmacro IncludeScriptFile "${__FILEDIR__}\apps\${app}\post_install.nsh"
		SectionEnd
	!endif

!macroend

