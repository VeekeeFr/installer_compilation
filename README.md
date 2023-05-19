# Installer compilation
NSIS based installer compilation

# Add new app
1. Create a new subfolder in apps

2a. For full control, add a "config.ini" file, with the following structure :

Name=Application name
Description=Package description
File=archive.zip
UAC=no
CommandLine=setup.exe
Arguments=-Dargument1=value1 -Dargument2=value2

Note: Enabling UAC will ignore all setup arguments

2b. For simple use, just add exe files.
Each exe files will be included and executed separately (using runas).

2c. Custom hooks can be included :
- pre_install.nsh : Script will be executed before any exe file execution (from the section)
- post_install.nsh : Script will be executed after all exe file execution (from the section)

Those scripts are using NSIS syntax (see example).

3. Recompile