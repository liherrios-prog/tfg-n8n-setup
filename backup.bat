@echo off
echo.
echo ========================================
echo  Creating n8n Backup
echo ========================================
echo.

:: Create backup directory with timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "backup_dir=backup\%YY%%MM%%DD%_%HH%M%S%"

echo Creating backup directory: %backup_dir%
mkdir "%backup_dir%"

:: Backup workflows
echo Backing up workflows...
if exist workflows\*.json (
    xcopy /E /I workflows "%backup_dir%\workflows\"
) else (
    echo No workflows to backup
)

:: Backup database
echo Backing up database...
docker cp tfg-n8n:/home/node/.n8n/n8n.sqlite "%backup_dir%\n8n_%YY%%MM%%DD%_%HH%M%S%.sqlite"

:: Create backup info
echo Creating backup info...
echo Backup created on %date% %time% > "%backup_dir%\backup_info.txt"
docker exec tfg-n8n n8n --version 2>nul && (
    echo n8n version: %errorlevel% >> "%backup_dir%\backup_info.txt"
) || (
    echo n8n version: Unknown >> "%backup_dir%\backup_info.txt"
)

echo.
echo ✅ Backup completed!
echo Backup saved to: %backup_dir%
pause
