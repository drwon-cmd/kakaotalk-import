@echo off
chcp 65001 > nul
powershell -ExecutionPolicy Bypass -File "C:\wvb-ai-workspace\kakaotalk-import\scripts\create-folder.ps1" -OpenExplorer
pause
