@echo off
echo Starting n8n container...
docker-compose up -d

docker ps | findstr "tfg-n8n" >nul
if %errorlevel% equ 0 (
    echo ✅ n8n is running!
    echo Access n8n at: http://localhost:5678
) else (
    echo ❌ Failed to start n8n container.
    echo Check the logs with: docker-compose logs -f
)
pause
