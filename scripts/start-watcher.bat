@echo off
chcp 65001 > nul
echo 카카오톡 대화 파일 감시를 시작합니다...
powershell -ExecutionPolicy Bypass -File "C:\wvb-ai-workspace\kakaotalk-import\scripts\watch-and-organize.ps1"
