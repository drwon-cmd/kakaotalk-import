# 시작 프로그램에 감시 스크립트 등록

$startupFolder = [Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupFolder "KakaoTalk-Watcher.lnk"
$targetPath = "C:\wvb-ai-workspace\kakaotalk-import\scripts\start-watcher.bat"

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = "C:\wvb-ai-workspace\kakaotalk-import\scripts"
$shortcut.WindowStyle = 7  # 최소화 상태로 시작
$shortcut.Description = "카카오톡 대화 파일 자동 정리"
$shortcut.Save()

Write-Host "자동 시작 등록 완료!"
Write-Host "위치: $shortcutPath"
