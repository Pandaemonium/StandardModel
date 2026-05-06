@echo off
setlocal

set "REPO_ROOT=%~dp0.."
set "PRE_COMMIT_HOME=%REPO_ROOT%\.cache\pre-commit-store"

if not exist "%PRE_COMMIT_HOME%" mkdir "%PRE_COMMIT_HOME%"

if "%~1"=="" (
  pre-commit run --all-files
) else (
  pre-commit %*
)

exit /b %ERRORLEVEL%
