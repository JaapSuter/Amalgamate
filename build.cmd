@echo off
rem cls

echo This batch file expects you to have Visual Studio in the path somehow...
echo.

if "%VCINSTALLDIR%" == "" (
    echo ...which you don't seem to have. Because it's your lucky day, I'm going to 
    echo try calling vcvarsx86_amd64.bat for you, in case you installed Visual Studio 
    echo in the default location. Then things might just work. Otherwise, please
    echo run this yourself so I can find cl.exe and link.exe
    echo.
    echo Cheers!
    echo.
    
    echo Calling "%VS140COMNTOOLS%/../../VC/bin/x86_amd64/vcvarsx86_amd64.bat"
    call         "%VS140COMNTOOLS%/../../VC/bin/x86_amd64/vcvarsx86_amd64.bat"
    
    set
)

if not exist "%~dp0obj" mkdir "%~dp0obj"
if not exist "%~dp0bin" mkdir "%~dp0bin"

pushd "%~dp0"

rem Windows Kits\8.1\include\um\shlobj.h(2228): warning C4091: 'typedef ': ignored on left of 'tagDTI_ADTIWUI' when no variable is declared
rem juce_core_amalgam.cpp(30938): warning C4312: 'type cast': conversion from 'unsigned int' to 'juce::Thread::ThreadID' of greater size
set DISABLED_WARNING_FLAGS=/wd4091 /wd4312

echo.
echo. Compiling and linking...
echo.

cl.exe ^
    Amalgamate.cpp ^
    juce_core_amalgam.cpp ^
    /nologo ^
    /EHsc ^
    /O2 ^
    %DISABLED_WARNING_FLAGS% ^
    /Fo"%~dp0obj/" ^
    /Fe%~dp0bin/amalgamate.exe"

if exist "%~dp0obj" rmdir /s/q "%~dp0obj"
popd
