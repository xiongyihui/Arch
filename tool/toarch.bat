@echo off
Rem Will copy the file passed as argument 1 to the root of the disk named "CRP DISABLD" if found
Rem To be used with Keil µVision 4

If "%1%0" EQU "0" Goto MissingArgument
set BINARYFILE=%1
If Not Exist "%BINARYFILE%" Goto NotFound

set TMPFILE=%TMP%\arch.tmp

wmic logicaldisk get caption,volumename | findstr /I "CRP DISABLD" > %TMPFILE%

set ARCHDRIVE=
for /F "tokens=1 delims= " %%i in (%TMPFILE%) do set ARCHDRIVE=%%i
del /F /Q %TMPFILE%

if "%ARCHDRIVE%0" EQU "0" Goto DiskNotFound

del /F /Q %ARCHDRIVE%\*.bin
copy /Y %BINARYFILE% %ARCHDRIVE%\
Echo Done dowloading, quick press the button to run
goto End

:DiskNotFound
Echo Disk not found. Please connect your Arch board to PC and long press the button of the board.
Goto ErrorEnd

:MissingArgument
Echo Please provide the path and filename to copy
Goto ErrorEnd

:NotFound
Echo File '%BINARYFILE%' could not be found!
Goto ErrorEnd

:ErrorEnd
Goto End

:End
