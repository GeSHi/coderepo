rem Just a test on how to implement something like Break;

@echo off
SET brake=0
FOR /L %%i IN (1,1,10) DO CALL :proc %%i
goto :eof

:proc
echo %brake%
if %brake%==1 exit /b
ECHO %1
IF %1==4 SET brake=1
ECHO %1 - 2