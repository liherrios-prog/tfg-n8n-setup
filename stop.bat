@echo off
echo Stopping n8n container...
docker-compose down

docker ps | findstr "tfg-n8n" >nul
if %errorlevel% neq 0 (
    echo ✅ n8n container stopped.
) else (
    echo ❌ Failed to stop n8n container.
)
pause
