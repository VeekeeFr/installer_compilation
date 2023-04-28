# Installer compilation
NSIS based installer compilation

# Add new app
1. Create a new subfolder in apps

2. Add a "config.ini" file, with the following structure :

Name=Application name
Description=Package description
File=archive.zip
UAC=no
CommandLine=setup.exe
Arguments=-Dargument1=value1 -Dargument2=value2


Note: Enabling UAC will ignore all setup arguments

3. Recompile