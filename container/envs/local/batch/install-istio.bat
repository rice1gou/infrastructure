@(echo '> NUL
echo off)
chcp 65001

cd /d %~dp0

SET THIS_PATH=%~f0
SET PARAM_1=%~1

powershell.exe -Command "iex -Command ((gc \"%THIS_PATH:`=``%\") -join \"`n\")"

exit /b 0
') | sv -Name TempVar

cd "$PSScriptRoot"

