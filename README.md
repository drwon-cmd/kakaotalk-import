# KakaoTalk Import

카카오톡 단체 채팅방 대화를 자동으로 요약하는 Claude Code 프로젝트

## 한 줄 요약

**카톡 대화 파일(.txt)만 폴더에 넣으면 → Claude가 알아서 요약 리포트(MD + PDF) 생성**

## 작동 방식

```
1. 카톡에서 대화 내보내기 (.txt)
2. raw/ 폴더에 저장
3. Claude Code에서 "/analyze-kakao" 실행
4. summaries/ 폴더에 요약 MD + PDF 자동 생성
```

## 요구 사항

- [Claude Code](https://claude.ai/claude-code) (Anthropic CLI)
- Node.js (md-to-pdf 변환용)
- Windows PowerShell

## 설치

```bash
# 저장소 클론
git clone https://github.com/your-username/kakaotalk-import.git

# md-to-pdf 설치 (PDF 변환용)
npm install -g md-to-pdf
```

## 사용법

### 1. 카카오톡에서 대화 내보내기

1. 카카오톡 PC/모바일에서 채팅방 열기
2. 메뉴 → **대화 내보내기** → **텍스트로 저장**
3. `.txt` 파일 다운로드

### 2. 파일 저장

```
kakaotalk-import/
└── raw/
    └── 2026-01-19-001/      ← 오늘 날짜 폴더 생성
        └── 채팅방대화.txt    ← 여기에 저장
```

**자동 폴더 생성:**
```powershell
# 바탕화면 단축키 생성 (최초 1회)
.\scripts\create-desktop-shortcut.ps1
```
→ 바탕화면의 "카톡 폴더 생성" 클릭하면 오늘 날짜 폴더 자동 생성

### 3. 요약 실행

```bash
# Claude Code에서 실행
claude

# 프롬프트에 입력
> /analyze-kakao
```

또는 직접 요청:
```
> kakaotalk-import 폴더의 최신 카톡 대화 요약해줘
```

### 4. 결과 확인

```
kakaotalk-import/
└── summaries/
    └── 2026-01-19-001/
        ├── 채팅방명_2026년1월_대화요약.md   ← 마크다운
        └── 채팅방명_2026년1월_대화요약.pdf  ← PDF
```

## 폴더 구조

```
kakaotalk-import/
├── raw/                    # 원본 카카오톡 txt 파일
│   └── YYYY-MM-DD-NNN/     # 날짜-일렬번호
├── summaries/              # 생성된 요약 파일 (MD + PDF)
│   └── YYYY-MM-DD-NNN/
├── scripts/                # 자동화 스크립트
│   ├── convert-to-pdf.ps1  # MD → PDF 변환
│   ├── create-folder.ps1   # 폴더 생성
│   └── ...
├── SUMMARY_GUIDELINES.md   # 요약 규칙 (Claude용)
└── README.md
```

## 요약 품질

Claude는 다음 규칙에 따라 요약합니다:

- **주제별 분류**: 대화를 맥락별로 그룹화
- **상세 기술**: 원본을 안 봐도 이해되는 수준
- **발언자 명시**: 중요 의견에 발언자 표기
- **액션 아이템**: 결정 사항, 할 일 명확히 구분
- **시간순 역배열**: 최신 내용 먼저

## PDF 수동 변환

```powershell
# 특정 파일
.\scripts\convert-to-pdf.ps1 -Path "summaries\2026-01-19-001\요약.md"

# 최근 폴더
.\scripts\convert-to-pdf.ps1 -Latest

# 전체 (증분)
.\scripts\convert-to-pdf.ps1 -All
```

## 다중 기기 지원

같은 채팅방을 여러 기기에서 내보낸 경우:

```
raw/2026-01-19-001/
├── 휴대폰_대화.txt
└── PC_대화.txt
```

→ 자동으로 통합 분석, 중복 제거

## 커스터마이징

`SUMMARY_GUIDELINES.md` 파일을 수정하면 요약 스타일을 변경할 수 있습니다.

## License

MIT
