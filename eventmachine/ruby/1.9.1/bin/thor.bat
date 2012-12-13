@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"ruby.exe" "D:/Javier/My Dropbox/Mis Proyectos/ILP/codigo ruby/MiFirma/eventmachine/ruby/1.9.1/bin/thor" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"ruby.exe" "%~dpn0" %*
