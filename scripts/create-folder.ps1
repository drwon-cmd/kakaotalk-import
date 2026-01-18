# 날짜-일렬번호 폴더 생성 스크립트
# /analyze-kakao 또는 단축키에서 호출

param(
    [switch]$OpenExplorer = $false
)

$rawPath = "C:\wvb-ai-workspace\kakaotalk-import\raw"
$summariesPath = "C:\wvb-ai-workspace\kakaotalk-import\summaries"

# 다음 일렬번호 찾기
$today = Get-Date -Format "yyyy-MM-dd"
$existingFolders = Get-ChildItem -Path $rawPath -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "$today-*" }

if ($existingFolders.Count -eq 0) {
    $folderName = "$today-001"
} else {
    $maxNum = $existingFolders | ForEach-Object {
        if ($_.Name -match "$today-(\d{3})$") {
            [int]$matches[1]
        }
    } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    
    $nextNum = $maxNum + 1
    $folderName = "$today-{0:D3}" -f $nextNum
}

# 폴더 생성
$newRawFolder = Join-Path $rawPath $folderName
$newSummaryFolder = Join-Path $summariesPath $folderName

New-Item -ItemType Directory -Path $newRawFolder -Force | Out-Null
New-Item -ItemType Directory -Path $newSummaryFolder -Force | Out-Null

Write-Host "폴더 생성 완료: $folderName"
Write-Host "  - raw: $newRawFolder"
Write-Host "  - summaries: $newSummaryFolder"

# 탐색기 열기 옵션
if ($OpenExplorer) {
    Start-Process explorer.exe -ArgumentList $newRawFolder
}

# 생성된 폴더명 반환
return $folderName
