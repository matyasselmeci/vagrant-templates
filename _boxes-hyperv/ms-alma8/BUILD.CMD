:; @() {true;}
@ goto startbatch
echo "This is a Windows CMD.EXE command and should not be run with sh."
exit 1

:startbatch
vagrant box update
vagrant up
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
vagrant package --output ..\ms-alma8.box
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
vagrant destroy --force
vagrant box add --force ms-alma8 ..\ms-alma8.box
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
del ..\ms-alma8.box
