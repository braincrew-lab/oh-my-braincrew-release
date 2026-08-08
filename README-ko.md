# oh-my-braincrew (omb)

[![Release](https://img.shields.io/github/v/release/braincrew-lab/oh-my-braincrew-release?style=flat-square)](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-blue?style=flat-square)](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest)
[![Python](https://img.shields.io/badge/python-%3E%3D3.12-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-harness-cc785c?style=flat-square&logo=anthropic&logoColor=white)](https://docs.anthropic.com/en/docs/claude-code)
[![License](https://img.shields.io/badge/license-Braincrew%20Internal%20Use%20Only-red?style=flat-square)](#라이선스)

**[English](README.md)** | **[한국어](README-ko.md)**

[Claude Code](https://docs.anthropic.com/en/docs/claude-code)를 위한 멀티 에이전트 오케스트레이션 하네스.

> 위임하고, 조율하고, 검증하라 — 직접 구현하지 마라.

이 저장소는 **공개 배포 채널**입니다. 미리 빌드된 바이너리, 하네스 tarball, 설치 스크립트를
제공합니다. 소스는 비공개 저장소 `braincrew-lab/oh-my-braincrew`에 있습니다.

## oh-my-braincrew란

기본 Claude Code는 에이전트 하나가 하나의 컨텍스트에서 모든 일을 처리합니다. `omb`는 여기에
팀과 절차를 붙입니다. 무엇을 원하는지만 말하면, 하네스가 어떤 전문 에이전트를 부를지 정하고,
병렬로 일을 시키고, 서로의 결과를 검토하게 하고, 타입 체커·린터·테스트가 실제로 통과하기
전까지는 완료로 인정하지 않습니다.

프로젝트에 설치되는 것:

- **전문 에이전트 59개** — API, DB, UI, AI/ML, Electron, 인프라, 보안, 하네스, 문서, 위키
  도메인에 걸친 설계·구현·검증·탐색·리뷰 에이전트
- **스킬 67개** — 아래의 `/omb:*` 워크플로우와, 필요할 때만 로드되는 내부 루브릭·참조 가이드
- **규칙 파일 117개** — 점진적으로 로드되므로, FastAPI 라우트를 고치는 에이전트에게는 FastAPI
  규칙만 들어가고 나머지는 들어가지 않습니다
- **라이프사이클 훅** — 세션 시작, 도구 사용 전후, 서브에이전트 종료 시점에 실행되는 Python 훅
  패키지. 시크릿 유출, 범위 밖 파일 쓰기, pytest 타임아웃 누락, raw SQL, 서브에이전트 출력
  계약 위반을 차단합니다.
- **워크트리 격리** — SQLite로 상태를 추적하는 별도 git 워크트리에서 기능 브랜치를 병렬로
  진행하므로, 두 작업이 같은 트리를 두고 충돌하지 않습니다

## 설치

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/braincrew-lab/oh-my-braincrew-release/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/braincrew-lab/oh-my-braincrew-release/main/install.ps1 | iex
```

### 수동 다운로드

| 플랫폼 | 아키텍처 | 바이너리 |
|--------|----------|----------|
| macOS | Apple Silicon (arm64) | [`oh-my-braincrew-vX.Y.Z-darwin-arm64`](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest) |
| Linux | x86_64 | [`oh-my-braincrew-vX.Y.Z-linux-amd64`](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest) |
| Windows | x86_64 | [`oh-my-braincrew-vX.Y.Z-windows-amd64.exe`](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest) |

각 릴리스에는 `omb init`이 설치하는 하네스 tarball(`harness-vX.Y.Z.tar.gz`)과 대응하는
`.sha256` 파일, `checksums-sha256.txt`도 함께 올라갑니다.

### CLI 명령

| 명령 | 설명 |
|------|------|
| `omb init [path]` | 최신 릴리스에서 하네스 파일(`.claude/`, `.omb/`) 설치 |
| `omb update [path]` | 바이너리 업데이트 및 하네스 파일 갱신 |
| `omb uninstall` | 설치된 바이너리와 하네스 파일 제거 |
| `omb update-gitignore` | 하네스 `.gitignore` 블록 재적용 |
| `omb version` | 설치된 버전 출력 |
| `omb env <sub>` | 하네스 환경 설정 조회 (스킬 preflight가 사용) |
| `omb hook-stats` | 훅 실행 시간·실패 통계 |
| `omb wiki-runtime <sub>` | 위키 검색 / frontmatter / 요약 런타임 조회 |

## 초기 설정

```bash
cd /path/to/your/project
omb init
```

이후 Claude Code 안에서:

```
> /omb:setup
```

`omb init`은 하네스를 설치하고 `.omb/` 작업 디렉토리를 만듭니다. 갱신 대상은 하네스 소유
경로(`.claude/skills/omb-*`, `.claude/agents/omb/`, `.claude/hooks/omb/`,
`.claude/commands/omb/`, `.claude/rules/**`)뿐이며, 사용자가 만든 에이전트·스킬·커맨드와
`CLAUDE.md`, `.claude/settings.json`, `.claude/rules/custom/`은 건드리지 않습니다. 설치된
하네스 파일은 `.gitignore`에 자동으로 추가됩니다.

`/omb:setup`은 코드베이스를 스캔해 그에 맞는 `CLAUDE.md`를 생성하고, `settings.json`의 훅과
권한, 환경 변수를 구성합니다.

## 권장 워크플로우

전체 사이클을 순서대로 돌려도 되고, 각 단계를 따로 불러도 됩니다.

```
> /omb:interview      # 1. 요구사항 수집
> /omb:plan           # 2. 구현 계획 작성
> /omb:plan-review    # 3. 계획 리뷰 및 채점
> /omb:run            # 4. TDD 에이전트로 실행
> /omb:verify         # 5. 구현 검증
> /omb:doc            # 6. 문서 갱신
> /omb:pr             # 7. PR 생성
> /omb:release        # 8. 릴리스
```

| # | 명령 | 하는 일 |
|---|------|---------|
| 1 | `/omb:interview` | 구조화된 요구사항 인터뷰 → `.omb/interviews/` |
| 2 | `/omb:plan` | 코드 위치 기반 계획 + 평가-개선 루프 → `.omb/plans/` |
| 3 | `/omb:plan-review` | 병렬 멀티 에이전트 리뷰, P0-P3 채점 |
| 4 | `/omb:run` | 도메인 에이전트로 계획 실행 → `.omb/todo/` |
| 5 | `/omb:verify` | 병렬 검증 에이전트 + 합의 판정 |
| 6 | `/omb:doc` | `docs/` 생성·갱신 |
| 7 | `/omb:pr` | 린트 게이트 → 커밋 → 푸시 → GitHub PR |
| 8 | `/omb:release` | 버전 범프, 체인지로그, 태그, GitHub Release |

## 명령어

### 계획과 실행

#### `/omb:interview` — 요구사항 인터뷰

기술 스택, 구현 선택지, 설계 취향을 최대 15개 질문으로 확인합니다. 먼저 프로젝트 문서를
찾아보기 때문에, 저장소에 이미 답이 있는 것은 묻지 않습니다.

#### `/omb:plan` — 구현 계획

코드베이스를 탐색해 실제 파일 경로와 라인 범위에 근거한 계획을 쓰고, 품질 기준을 넘길 때까지
평가 → 개선을 반복합니다. 앞단의 필요성 게이트가 요청 규모에 맞춰 전체 경로와 경량 경로를
가르므로, 파일 하나 고치는 일에 리뷰어 열두 명이 붙지 않습니다.

```
> /omb:plan OAuth 로그인 추가
# 결과: .omb/plans/2026-08-08-oauth-login.md
```

#### `/omb:plan-review` — 계획 리뷰

도메인 리뷰어 3~12명을 병렬로 돌린 뒤, 발견 사항을 P0-P3 우선순위가 붙은 하나의 합의 목록으로
합칩니다. 여러 리뷰어가 독립적으로 같은 문제를 지적하면, 한 명만 본 지적보다 위로 올라갑니다.

#### `/omb:run` — 계획 실행

계획의 작업 목록을 읽어 각 작업을 해당 도메인 에이전트에 위임하고, RED-GREEN-IMPROVE 사이클을
강제합니다. 진행 상황은 `.omb/todo/`에 기록됩니다.

#### `/omb:verify` — 구현 검증

`tsc`, `ruff`, `pytest`, `eslint`를 실제로 돌리고, 도메인 에이전트가 diff를 검토한 뒤 하나의
판정을 냅니다. 주장은 명령 출력으로 뒷받침되며, 선언만으로는 통과하지 않습니다.

#### `/omb:fix` — 버그 수정 계획

git 히스토리 추적, 재현 절차, 증상이 아니라 원인을 없애는 최소 패치. 여기에 재발을 막는 규칙
또는 위키 항목까지 함께 계획합니다.

#### `/omb:refactoring` — 리팩터링 계획

목표를 먼저 다듬고, 잠재 버그·모듈화·디자인 패턴·SoT 드리프트를 병렬로 분석한 뒤, 동작을
보존하는 TDD 계획으로 마무리합니다.

#### `/omb:resolve-issue` — GitHub 이슈 해결

이슈를 끝까지 처리합니다. 유효성 판단 → 계획 → 구현 → 검증 → 자동 close 링크가 붙은 PR.

#### `/omb:issue` — 이슈 스캐너

병렬 탐색 에이전트로 코드베이스를 훑고, 발견 사항을 투표로 거른 뒤 살아남은 것만 GitHub 이슈로
등록합니다.

### 문서와 지식

#### `/omb:doc` — 서비스 문서

프로젝트의 카테고리 구조, 네이밍 규칙, 템플릿을 따라 `docs/` 문서를 만들고 갱신합니다.

#### `/omb:wiki` — 프로젝트 블루프린트 위키

`docs/wiki/` 노트를 읽고, 검증하고, 스테이징하고, 리뷰하고, 트랜잭션으로 발행합니다. 교훈과
제약, 결정을 담는 프로젝트의 장기 기억입니다.

#### `/omb:explain` — 설명 컨트랙트

코드를 직접 쓰지 않은 사람을 기준으로 다시 설명합니다. 명사구 섹션, 실제로 말하는 문체, 주장마다
붙는 근거. `--page`를 주면 설명을 HTML로 렌더합니다.

#### `/omb:mermaid` — 다이어그램

22종의 Mermaid 다이어그램을 생성합니다. LangGraph 상태 그래프 시각화도 포함됩니다.

### 품질과 프롬프트

#### `/omb:lint-check` — 린트 게이트

변경된 파일에서 스택을 감지해 맞는 린터를 실행합니다. PR 전 필수입니다.

#### `/omb:prompt-guide` — 프롬프트 엔지니어링 레퍼런스

시스템 프롬프트, 에이전트 지시문, `CLAUDE.md` 작성을 위한 15개 카테고리 72개 규칙 가이드를
로드합니다.

#### `/omb:prompt-review` — 프롬프트 리뷰

루브릭으로 프롬프트를 채점하고, P0/P1 항목을 고친 뒤, 통과할 때까지 다시 채점합니다.

#### `/omb:brainstorming` — 아이디어 탐색

한 번에 하나씩 질문해서, 설계를 확정하기 전에 의도와 제약을 뾰족하게 만듭니다.

### 프로젝트와 저장소 관리

#### `/omb:setup` — 프로젝트 설정

디렉토리 구조를 만들고, `CLAUDE.md`를 생성하고, `settings.json`의 훅과 환경 변수를 구성합니다.

#### `/omb:harness` — 하네스 설정

에이전트, 스킬, 훅, 규칙, `settings.json`을 생성·검증·수정·설계합니다.

```
> /omb:harness --verify    # 설정 상태 점검
> /omb:harness --fix       # 발견된 문제 자동 수정
```

#### `/omb:worktree` — 워크트리 관리

SQLite로 상태가 유지되는 격리된 git 워크트리를 다룹니다.

```
> /omb:worktree create feat/add-auth
> /omb:worktree status
> /omb:worktree resume feat/add-auth
```

#### `/omb:clean` — 정리

끝난 워크트리를 제거하고 DB에 DONE으로 표시하며, 병합 증거가 확인된 브랜치만 삭제합니다.

#### `/omb:pr` — 풀 리퀘스트

브랜치 이름을 검증하고, 린트 게이트를 돌리고, 커밋·푸시한 뒤 구조화된 템플릿으로 PR을 엽니다.

#### `/omb:release` — 릴리스

버전 범프, 체인지로그와 README 동기화, 커밋, 푸시, 태그, 빌드 산출물이 붙은 GitHub Release까지
처리합니다. 이 저장소 전용이 아니라 어떤 저장소에서든 쓸 수 있습니다.

```
> /omb:release patch
> /omb:release minor
> /omb:release 2.0.0
> /omb:release --dry-run     # 미리보기만, 아무것도 쓰지 않음
```

#### `/omb:cron` — 예약 작업

시스템 crontab을 통해 반복 실행되는 Claude Code 작업을 등록·조회·중지합니다.

### Codex 연동

다른 모델의 의견을 받기 위한 [OpenAI Codex CLI](https://github.com/openai/codex) 선택 연동입니다.

| 명령 | 하는 일 |
|------|---------|
| `/omb:codex` | 디스패처 — 아래 서브커맨드로 라우팅 |
| `/omb:codex-review` | 로컬 git 상태 코드 리뷰 |
| `/omb:codex-adv-review` | 가정·실패 모드·엣지 케이스를 파고드는 적대적 리뷰 |
| `/omb:codex-run <task>` | Codex CLI에 작업 위임 |

## 업데이트 / 제거

```bash
omb update      # 바이너리 업데이트 및 하네스 파일 갱신
omb init        # 하네스 파일만 재설치
omb uninstall   # 바이너리와 하네스 파일 제거
```

## 요구 사항

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Python 3.12+
- macOS, Linux, Windows
- `git`, 그리고 PR·이슈·릴리스 워크플로우를 쓰려면 `gh`

## 체인지로그

릴리스 이력은 [CHANGELOG.md](./CHANGELOG.md)를 참고하세요.

## 라이선스

Braincrew Internal Use Only.
