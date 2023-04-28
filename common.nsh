!insertmacro MUI_LANGUAGE "French"
!include LogicLib.nsh

!define GLOBAL_TEMP_FOLDER "$TEMP\installerCompilation"
!define INSTALLER_ONINIT "${__FILEDIR__}\dynamic_onInit.nsh"
!define INSTALLER_APPS "${__FILEDIR__}\dynamic_apps.nsh"

!delfile /nonfatal "${INSTALLER_ONINIT}"

!addplugindir "${__FILEDIR__}\plugins\nsunzip"
!addplugindir "${__FILEDIR__}\plugins\execcmd"

!macro AddAppSection app
	!include "${__FILEDIR__}\apps\${app}\install.nsh"
!macroend


!macro IncludeApp app

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

		File "${__FILEDIR__}\apps\${app}\${APP_FILE}"

  		DetailPrint "${GLOBAL_TEMP_FOLDER}\${app}\${APP_FILE}"

		nsUnzip::Extract "*.zip" /END

  		DetailPrint "Executing ${APP_CMDLINE} ${APP_ARGS}"
		${If} ${APP_MODE} == "yes"
		  ExecShell "runas" "${GLOBAL_TEMP_FOLDER}\${app}\${APP_CMDLINE}"
		${Else}
		  ExecWait '"${GLOBAL_TEMP_FOLDER}\${app}\${APP_CMDLINE}" ${APP_ARGS}'
		${EndIf}

	SectionEnd

!macroend

