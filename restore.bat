@echo off
if "%~1" == "" (
    echo Usage: restore.bat <backup_directory>
    echo Available backups:
    dir /b backup\
    pause
    exit /b 1
)

set "backup_dir=backup\%~1"

if not exist "%backup_dir%" (
    echo Backup directory not found: %backup_dir%
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Restoring n8n from Backup
echo ========================================
echo.

:: Stop the container
echo Stopping n8n container...
docker-compose down

:: Restore workflows
echo Restoring workflows...
if exist "%backup_dir%\workflows\*.json" (
    xcopy /E /I "%backup_dir%\workflows" workflows\
) else (
    echo No workflows to restore
)

:: Restore database
echo Restoring database...
if exist "%backup_dir%\*.sqlite" (
    docker cp "%backup_dir%\*.sqlite" tfg-n8n:/home/node/.n8n/n8n.sqlite
) else (
    echo No database backup found
)

:: Start the container
echo Starting n8n container...
docker-compose up -d

:: Verify it's running
docker ps | findstr "tfg-n8n" >nul
if %errorlevel% equ 0 (
    echo.
    echo ✅ Restore completed!
    echo n8n is running at: http://localhost:5678
) else (
    echo.
    echo ❌ Failed to start n8n container after restore.
)
pause
