# 카카오톡 대화 파일 감시 및 자동 정리 스크립트
# raw/ 폴더에 txt 파일이 들어오면 자동으로 날짜-일렬번호 폴더 생성 후 이동

$watchPath = "C:\wvb-ai-workspace\kakaotalk-import\raw"
$summariesPath = "C:\wvb-ai-workspace\kakaotalk-import\summaries"

Write-Host "=========================================="
Write-Host " 카카오톡 대화 파일 감시 시작"
Write-Host " 감시 폴더: $watchPath"
Write-Host " 종료하려면 Ctrl+C를 누르세요"
Write-Host "=========================================="

while ($true) {
    # raw/ 루트의 txt 파일 찾기
    $txtFiles = Get-ChildItem -Path $watchPath -Filter "*.txt" -File -ErrorAction SilentlyContinue

    foreach ($file in $txtFiles) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 파일 발견: $($file.Name)"

        # 파일이 쓰기 중인지 확인 (1초 대기)
        Start-Sleep -Seconds 1

        # 다음 폴더명 계산
        $today = Get-Date -Format "yyyy-MM-dd"
        $existingFolders = Get-ChildItem -Path $watchPath -Directory | Where-Object { $_.Name -like "$today-*" }

        if ($existingFolders.Count -eq 0) {
            $folderName = "$today-001"
        } else {
            $maxNum = 0
            foreach ($folder in $existingFolders) {
                if ($folder.Name -match "$today-(\d{3})$") {
                    $num = [int]$matches[1]
                    if ($num -gt $maxNum) { $maxNum = $num }
                }
            }
            $nextNum = $maxNum + 1
            $folderName = "$today-{0:D3}" -f $nextNum
        }

        $newFolder = Join-Path $watchPath $folderName
        $summaryFolder = Join-Path $summariesPath $folderName

        # 폴더 생성
        New-Item -ItemType Directory -Path $newFolder -Force | Out-Null
        New-Item -ItemType Directory -Path $summaryFolder -Force | Out-Null

        # 파일 이동
        Move-Item -Path $file.FullName -Destination $newFolder -Force

        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 정리 완료: $($file.Name) -> $folderName"
    }

    # 2초마다 확인
    Start-Sleep -Seconds 2
}
