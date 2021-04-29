@echo off

if exist AssemblySourceEnginePlugin.obj del AssemblySourceEnginePlugin.obj
if exist AssemblySourceEnginePlugin.ext.dll del AssemblySourceEnginePlugin.ext.dll

"\masm32\bin\ml.exe" /c /coff AssemblySourceEnginePlugin.asm
"\masm32\bin\link.exe" /ALIGN:16 /DLL /DRIVER:UPONLY /ENTRY:DllEntryPoint /OPT:REF /RELEASE /SUBSYSTEM:WINDOWS /OUT:AssemblySourceEnginePlugin.dll AssemblySourceEnginePlugin.obj

dir AssemblySourceEnginePlugin.*

pause


