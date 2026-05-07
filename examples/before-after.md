# Before / After Examples

These examples show how `plan-first-implementation` changes the workflow before code edits start.

## Example 1: UI Flow Change

Before:

```text
결과 페이지 흐름을 고쳐줘.
기존 URL은 깨지면 안 되고, 먼저 계획부터 잡고 구현해줘.
```

After:

```md
## Plan First

### Goal
- Improve the result page flow while preserving existing result URLs.

### Codebase Evidence
- `Confirmed`: route entry owns direct URL behavior.
- `Confirmed`: result page component owns rendering.
- `Inferred`: resolver logic is the safest place to branch behavior.

### System Visualization
- route entry -> result page -> content resolver -> result data

### Change Map
- likely files to edit: route entry, resolver
- behavior to preserve: existing `/result/:type` links
- validation: direct URL smoke test, build

### Execution Plan
1. verify route and resolver ownership
2. patch resolver behavior
3. test existing and new result URLs
```

## Example 2: Refactor With Preserved Behavior

Before:

```text
이 모듈 정리해줘. 근데 기존 동작은 절대 바뀌면 안 돼.
```

After:

```md
## Plan First

### Goal
- Simplify module structure without changing external behavior.

### Current Behavior
- public function signatures stay stable
- existing callers should not change
- output shape must remain identical

### Risk
- hidden callers may depend on current file boundaries
- tests may not cover every branch

### Execution Plan
1. map current exports and callers
2. split internal helpers only
3. keep public exports stable
4. run unit tests and one caller smoke test
```

## Example 3: Planning Only

Before:

```text
이 기능 어떻게 고칠지 계획만 먼저 만들어줘.
아직 구현은 하지 마.
```

After:

```md
## Plan First

### Mode
- Planning only. No code edits.

### Deliverable
- implementation-ready plan document
- related files and current behavior
- change map and validation plan
- open risks and unresolved questions

### Stop Condition
- Stop after the plan until the user explicitly asks for implementation.
```
