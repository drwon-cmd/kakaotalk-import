# 바탕화면에 단축키 생성

$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopPath "카톡 폴더 생성.lnk"
$targetPath = "C:\wvb-ai-workspace\kakaotalk-import\scripts\new-kakao-folder.bat"

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = "C:\wvb-ai-workspace\kakaotalk-import\scripts"
$shortcut.Description = "카카오톡 대화 저장용 폴더 생성"
$shortcut.Save()

Write-Host "바탕화면 단축키 생성 완료!"
Write-Host "위치: $shortcutPath"
