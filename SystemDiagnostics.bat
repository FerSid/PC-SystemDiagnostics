@echo off
setlocal EnableDelayedExpansion

set outputFile=system_info.txt

echo Collecting System Information... > %outputFile%
echo ================================================== >> %outputFile%


echo. >> %outputFile%
echo Machine Name: >> %outputFile%
for /f "tokens=*" %%i in ('hostname') do (
    echo %%i >> %outputFile%
)

echo. >> %outputFile%
echo User Name: >> %outputFile%
echo %USERNAME% >> %outputFile%

echo. >> %outputFile%
echo IP Address: >> %outputFile%
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /R "IPv4"') do (
    set ipAddress=%%a
    echo !ipAddress:~1! >> %outputFile%
)

echo. >> %outputFile%
echo File Location: >> %outputFile%
if exist "C:\Windows\Microsoft.NET\Framework\v4.0.30319\vbc.exe" (
    echo File exists at C:\Windows\Microsoft.NET\Framework\v4.0.30319\vbc.exe >> %outputFile%
) else (
    echo File not found at C:\Windows\Microsoft.NET\Framework\v4.0.30319\vbc.exe >> %outputFile%
)


echo. >> %outputFile%
echo HWID: >> %outputFile%
for /f "tokens=*" %%i in ('wmic csproduct get uuid ^| findstr /R /V "^$"') do (
    set hwid=%%i
    echo !hwid! >> %outputFile%
)

echo. >> %outputFile%
echo Current Language: >> %outputFile%
for /f "tokens=*" %%i in ('systeminfo ^| findstr /B /C:"System Locale"') do (
    set locale=%%i
    echo !locale! >> %outputFile%
)

echo. >> %outputFile%
echo Screen Size (in pixels): >> %outputFile%
for /f %%i in ('powershell -command "Get-WmiObject -Class Win32_VideoController | Select-Object -ExpandProperty CurrentHorizontalResolution"') do (
    set width=%%i
)
for /f %%i in ('powershell -command "Get-WmiObject -Class Win32_VideoController | Select-Object -ExpandProperty CurrentVerticalResolution"') do (
    set height=%%i
)
echo Width: !width! pixels, Height: !height! pixels >> %outputFile%

echo. >> %outputFile%
echo Time Zone: >> %outputFile%
for /f "tokens=*" %%i in ('tzutil /g') do (
    set timezone=%%i
    echo !timezone! >> %outputFile%
)

echo. >> %outputFile%
echo Operating System: >> %outputFile%
for /f "tokens=*" %%i in ('systeminfo ^| findstr /B /C:"OS Name" /C:"OS Version"') do (
    set osinfo=%%i
    echo !osinfo! >> %outputFile%
)

echo. >> %outputFile%
echo UAC Settings: >> %outputFile%
for /f "tokens=3" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA 2^>nul') do (
    set uac=%%i
    if !uac! == 0x1 (
        echo UAC is enabled >> %outputFile%
    ) else (
        echo UAC is disabled >> %outputFile%
    )
)

echo. >> %outputFile%
echo Process Elevation: >> %outputFile%
whoami /priv | findstr /C:"SeDebugPrivilege" >nul && (
    echo Process has SeDebugPrivilege >> %outputFile%
) || (
    echo Process does not have SeDebugPrivilege >> %outputFile%
)


echo. >> %outputFile%
echo CPU Information: >> %outputFile%
for /f "tokens=*" %%i in ('wmic cpu get name ^| findstr /R /V "^$"') do (
    set cpuinfo=%%i
    echo !cpuinfo! >> %outputFile%
)

echo. >> %outputFile%
echo GPU Information: >> %outputFile%
for /f "tokens=*" %%i in ('wmic path win32_videocontroller get adapterram^,caption ^| findstr /R /V "^$"') do (
    set gpuinfo=%%i
    echo !gpuinfo! >> %outputFile%
)

echo. >> %outputFile%
echo Total RAM: >> %outputFile%
for /f "tokens=*" %%i in ('systeminfo ^| findstr /C:"Total Physical Memory"') do (
    set raminfo=%%i
    echo !raminfo! >> %outputFile%
)

echo. >> %outputFile%
echo Diagnostic Date: >> %outputFile%
echo %DATE% %TIME% >> %outputFile%

echo ================================================== >> %outputFile%
echo Information collection complete. >> %outputFile%

endlocal
