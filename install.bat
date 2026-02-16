@echo off
echo.
echo ========================================
echo  TFG n8n Setup - Windows Installation
echo ========================================
echo.

:: Check if Docker is installed
echo Checking Docker installation...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

:: Check if git is installed
echo Checking Git installation...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git from: https://git-scm.com/downloads
    pause
    exit /b 1
)

:: Create necessary directories
echo Creating directories...
if not exist workflows mkdir workflows
if not exist data mkdir data
if not exist backup mkdir backup

:: Copy .env file if it doesn't exist
if not exist .env (
    echo Creating .env file...
    copy .env.example .env
    echo.
    echo .env file created. Please edit it with your configuration.
    echo Set N8N_PASSWORD to a secure password
    echo.
    pause
)

:: Check if container is already running
docker ps | findstr "tfg-n8n" >nul
if %errorlevel% equ 0 (
    echo.
    echo Container is already running.
    echo Access n8n at: http://localhost:5678
    pause
    exit /b 0
)

:: Pull the latest image
echo Pulling latest n8n image...
docker-compose pull

:: Start the container
echo Starting n8n container...
docker-compose up -d

:: Wait for container to be healthy
echo Waiting for n8n to be ready...
timeout /t 10 /nobreak

:: Check if container is running
docker ps | findstr "tfg-n8n" >nul
if %errorlevel% equ 0 (
    echo.
    echo ✅ n8n is running!
    echo Access n8n at: http://localhost:5678
    echo Default username: admin
    for /f "tokens=2 delims==" %%a in ('findstr "N8N_PASSWORD" .env') do (
        echo Password: %%a
    )
    echo.
    echo Important: Change the default password in the n8n web interface.
    pause
) else (
    echo.
    echo ❌ Failed to start n8n container.
    echo Check the logs with: docker-compose logs -f
    pause
    exit /b 1
)
