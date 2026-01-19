# convert-to-pdf.ps1
# 카카오톡 요약 md 파일을 PDF로 변환
# 사용법: .\convert-to-pdf.ps1 [-Path <md파일경로>] [-All]

param(
    [string]$Path,
    [switch]$All,
    [switch]$Latest
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$summariesRoot = "C:\wvb-ai-workspace\kakaotalk-import\summaries"

function Convert-MdToPdf {
    param([string]$MdPath)

    if (-not (Test-Path $MdPath)) {
        Write-Host "[ERROR] 파일을 찾을 수 없습니다: $MdPath" -ForegroundColor Red
        return $false
    }

    $pdfPath = $MdPath -replace '\.md$', '.pdf'

    Write-Host "[INFO] 변환 중: $MdPath" -ForegroundColor Cyan

    try {
        $result = & npx md-to-pdf $MdPath --dest $pdfPath 2>&1

        if (Test-Path $pdfPath) {
            Write-Host "[SUCCESS] PDF 생성 완료: $pdfPath" -ForegroundColor Green
            return $true
        } else {
            Write-Host "[ERROR] PDF 생성 실패" -ForegroundColor Red
            Write-Host $result -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "[ERROR] 변환 오류: $_" -ForegroundColor Red
        return $false
    }
}

$successCount = 0
$failCount = 0

if ($Path) {
    if (Convert-MdToPdf -MdPath $Path) { $successCount++ } else { $failCount++ }
}
elseif ($Latest) {
    $latestFolder = Get-ChildItem -Path $summariesRoot -Directory |
                    Sort-Object Name -Descending |
                    Select-Object -First 1

    if ($latestFolder) {
        $mdFiles = Get-ChildItem -Path $latestFolder.FullName -Filter "*.md"
        foreach ($md in $mdFiles) {
            if (Convert-MdToPdf -MdPath $md.FullName) { $successCount++ } else { $failCount++ }
        }
    } else {
        Write-Host "[WARN] summaries 폴더에 하위 폴더가 없습니다." -ForegroundColor Yellow
    }
}
elseif ($All) {
    $mdFiles = Get-ChildItem -Path $summariesRoot -Recurse -Filter "*.md"

    foreach ($md in $mdFiles) {
        $pdfPath = $md.FullName -replace '\.md$', '.pdf'

        if ((Test-Path $pdfPath) -and ((Get-Item $pdfPath).LastWriteTime -ge $md.LastWriteTime)) {
            Write-Host "[SKIP] PDF 이미 최신: $($md.Name)" -ForegroundColor Gray
            continue
        }

        if (Convert-MdToPdf -MdPath $md.FullName) { $successCount++ } else { $failCount++ }
    }
}
else {
    Write-Host @"
카카오톡 요약 MD -> PDF 변환 스크립트

사용법:
  .\convert-to-pdf.ps1 -Path <파일경로>   # 특정 파일 변환
  .\convert-to-pdf.ps1 -Latest            # 최근 폴더의 파일 변환
  .\convert-to-pdf.ps1 -All               # 모든 파일 변환 (증분)

예시:
  .\convert-to-pdf.ps1 -Path "C:\...\summaries\2026-01-18-001\요약.md"
  .\convert-to-pdf.ps1 -Latest
  .\convert-to-pdf.ps1 -All
"@
    exit 0
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "변환 완료: 성공 $successCount, 실패 $failCount" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Yellow" })
Write-Host "========================================" -ForegroundColor Cyan
