# Codex Skill: Plan First Implementation

코드를 바로 고치기 전에, 먼저 근거 있는 계획 문서를 만들고 그 문서를 기준으로 구현하게 하는 Codex skill입니다.

English version: [README.en.md](README.en.md)

## 왜 만들었나요?

AI coding agent는 빠르게 코드를 고칠 수 있습니다.

하지만 빠르다는 이유로 바로 구현부터 들어가면 이런 문제가 생깁니다.

```text
어떤 파일을 고친 거지?
왜 이 방식이 맞다고 판단한 거지?
무엇은 바뀌면 안 되는 거지?
검증은 어디까지 해야 하지?
```

`plan-first-implementation`은 이 순서를 바꿉니다.

먼저 코드베이스를 읽고, 현재 동작과 변경 범위, 리스크, 검증 방법을 계획 문서에 잠급니다. 그 다음에야 구현으로 넘어갑니다.

## 이 스킬은 무엇인가요?

`plan-first-implementation`은 “계획만 길게 쓰는 스킬”이 아닙니다.

핵심은 아래 흐름입니다.

- 관련 파일을 먼저 찾습니다.
- 현재 동작과 변경 지점을 근거와 함께 정리합니다.
- 범위, 리스크, 유지해야 할 동작을 명시합니다.
- 필요한 경우 시스템 그림을 넣어 작업 표면을 시각화합니다.
- 검증 방법을 먼저 정합니다.
- 계획이 구현 직전 수준일 때만 코드 수정을 시작합니다.

## 어떤 상황에서 쓰나요?

이런 요청에 잘 맞습니다.

- 큰 수정이라 먼저 범위를 잠가야 할 때
- 구현 전에 파일 관계와 리스크를 파악해야 할 때
- 기존 동작을 깨면 안 되는 리팩터링
- UI, 라우팅, 상태 관리, 데이터 흐름처럼 연결된 표면이 많은 작업
- 다른 Codex 세션이나 에이전트가 계획을 보고 바로 이어서 구현해야 할 때

굳이 쓰지 않아도 되는 경우도 있습니다.

- 한 줄짜리 명확한 수정
- 단순 오타 수정
- 사용자가 “계획 말고 바로 고쳐”라고 명확히 말한 작은 작업
- 이미 충분히 구체적인 실행 계획이 있는 경우

## 어떻게 작동하나요?

Codex가 이 skill을 읽으면 대략 이렇게 움직입니다.

1. 이번 요청이 `계획만`인지 `계획 후 구현`인지 정합니다.
2. 기존 계획 문서가 있으면 이어 쓰고, 없으면 새 계획 문서를 만듭니다.
3. 관련 코드와 문서를 읽어 현재 동작과 변경 지점을 찾습니다.
4. 계획 문서에 범위, 근거, 리스크, 검증, 구현 순서를 적습니다.
5. 다중 경계 작업이면 Mermaid나 ASCII로 시스템 그림을 넣습니다.
6. 계획이 충분히 구체적일 때만 코드 수정을 시작합니다.

## 빠른 예시

사용자 요청:

```text
결과 페이지 흐름을 고쳐줘.
근데 기존 결과 URL은 깨지면 안 되고, 먼저 계획부터 잡고 구현해줘.
```

`plan-first-implementation`이 먼저 만드는 계획의 핵심:

```md
## Goal
- 결과 페이지 흐름을 개선하되 기존 결과 URL 동작은 유지한다.

## Codebase Evidence
- `Confirmed`: `src/routes/result/$type.tsx`가 결과 페이지 진입점이다.
- `Confirmed`: `src/features/results/ResultPage.tsx`가 화면 렌더링을 담당한다.
- `Inferred`: URL 호환성은 route param 처리에서 검증해야 한다.

## Change Map
- likely files to edit: route entry, result resolver
- behavior to preserve: existing `/result/:type` links
- validation: direct URL smoke test, build
```

더 자세한 예시는 [examples/before-after.md](examples/before-after.md)를 보세요.

## 포함된 도구

이 repo에는 계획 문서를 만들고 점검하는 보조 파일도 포함되어 있습니다.

- `assets/plan-document-template.md`: 계획 문서 기본 템플릿
- `assets/sample-plan-output.md`: 예시 계획 문서
- `scripts/collect_related_files.sh`: 관련 파일 후보를 찾는 읽기 전용 검색 도구
- `scripts/seed_plan_update.py`: 기존 계획 문서의 빈약한 섹션을 찾는 보조 도구
- `references/`: 근거 표기, 시각화, 검토 체크리스트, 작업 유형별 계획 가이드

## 설치 방법

이 저장소를 받은 뒤 `plan-first-implementation/` 폴더를 Codex skills 폴더로 복사합니다.

```bash
mkdir -p ~/.codex/skills
cp -R plan-first-implementation ~/.codex/skills/plan-first-implementation
```

Git으로 계속 관리하고 싶다면 symlink로 연결할 수도 있습니다.

```bash
mkdir -p ~/.codex/skills
ln -s /path/to/codex-skill-plan-first-implementation/plan-first-implementation ~/.codex/skills/plan-first-implementation
```

Codex에 바로 보이지 않으면 Codex를 다시 시작해 보세요.

## 사용 방법

Codex에서 명시적으로 호출합니다.

```text
$plan-first-implementation
```

또는 이렇게 말해도 됩니다.

```text
이 작업은 plan-first-implementation으로 진행해줘.
먼저 코드베이스를 읽고 계획 문서를 만든 다음, 그 계획을 기준으로 구현해줘.
```

한국어로는 이렇게 요청해도 됩니다.

```text
계획 먼저 잡고 구현해줘.
근거, 리스크, 검증 방법까지 문서에 남긴 다음에 코드 수정으로 넘어가줘.
```

## 내 방식에 맞게 커스터마이징하기

이 repo에는 Codex가 읽을 수 있는 커스터마이징 가이드가 들어 있습니다.

- [CUSTOMIZE_WITH_CODEX.md](CUSTOMIZE_WITH_CODEX.md)
- [AGENTS.md](AGENTS.md)

이 repo를 Codex에서 열고 이렇게 말해 보세요.

```text
Read CUSTOMIZE_WITH_CODEX.md and help me adapt plan-first-implementation for my own workflow.
```

한국어로는 이렇게 요청해도 됩니다.

```text
CUSTOMIZE_WITH_CODEX.md를 읽고, 내 작업 방식에 맞게 plan-first-implementation을 커스터마이징해줘.
수정 전에 어떤 계획 섹션과 검증 기준을 바꿀지 먼저 보여줘.
```

## 파일 구조

```text
plan-first-implementation/
  SKILL.md
  agents/openai.yaml
  assets/
  references/
  scripts/
examples/
  before-after.md
CUSTOMIZE_WITH_CODEX.md
AGENTS.md
CONTRIBUTING.md
PUBLIC_RELEASE_HANDOFF.md
scripts/security-scan.sh
```

## 먼저 바꿔볼 만한 곳

내 workflow에 맞게 바꾸고 싶다면 아래 파일부터 보면 됩니다.

- `plan-first-implementation/SKILL.md`
- `plan-first-implementation/assets/plan-document-template.md`
- `plan-first-implementation/references/workflow.md`
- `plan-first-implementation/references/review-checklist.md`

## 공개 안전성

이 repo에는 아래 항목을 넣지 않는 것을 원칙으로 합니다.

- API key
- token
- 비밀번호
- 개인 로컬 경로
- 사내/고객 정보
- 특정 개인 프로젝트에만 맞는 비공개 지시

## 라이선스

MIT
