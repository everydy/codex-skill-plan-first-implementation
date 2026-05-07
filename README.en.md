# Codex Skill: Plan First Implementation

A Codex skill that makes Codex write an evidence-based plan before editing code.

Korean version: [README.md](README.md)

## Why I Built This

AI coding agents can patch code quickly.

But when they start editing too early, the work can become hard to trust:

```text
Which files were changed?
Why was this approach chosen?
What behavior must stay unchanged?
How should this be verified?
```

`plan-first-implementation` changes the order.

Codex reads the codebase first, writes a grounded plan, names the risks and validation surface, and only then moves into implementation.

## What It Does

This is not a "write a long plan and stop" skill.

The core behavior is:

- find likely related files first
- explain current behavior with evidence
- define scope, risks, and preserved behavior
- add a system visualization when the work spans multiple boundaries
- define validation before editing
- start implementation only when the plan is concrete enough

## When To Use It

Use it when:

- the change is large enough that scope must be locked first
- file ownership and risk need to be understood before patching
- refactoring must preserve existing behavior
- UI, routing, state, data flow, or integrations are connected
- another Codex session should be able to implement from the plan

Skip it when:

- the edit is tiny and obvious
- the task is a simple typo fix
- the user explicitly wants a small direct edit
- an implementation-ready plan already exists

## How It Works

When Codex reads this skill, it should:

1. decide whether the user wants planning only or plan then execute
2. update an existing plan doc or create a new one
3. inspect related code and docs
4. document scope, evidence, risks, validation, and execution order
5. add a Mermaid or ASCII system map when useful
6. implement only after the plan is concrete enough

## Quick Example

User request:

```text
Fix the result page flow, but do not break existing result URLs. Plan first, then implement.
```

The plan should lock down:

```md
## Goal
- Improve the result page flow while preserving existing result URLs.

## Codebase Evidence
- `Confirmed`: `src/routes/result/$type.tsx` is the result-page route entry.
- `Confirmed`: `src/features/results/ResultPage.tsx` owns rendering.
- `Inferred`: URL compatibility should be verified at route-param handling.

## Change Map
- likely files to edit: route entry, result resolver
- behavior to preserve: existing `/result/:type` links
- validation: direct URL smoke test, build
```

See [examples/before-after.md](examples/before-after.md) for more examples.

## Included Helpers

This repository includes helper assets for planning work:

- `assets/plan-document-template.md`: default plan template
- `assets/sample-plan-output.md`: sample implementation-ready plan
- `scripts/collect_related_files.sh`: read-only related-file search helper
- `scripts/seed_plan_update.py`: helper for finding thin sections in an existing plan
- `references/`: evidence, visualization, review, and workflow guidance

## Installation

Copy the skill folder into your Codex skills directory.

```bash
mkdir -p ~/.codex/skills
cp -R plan-first-implementation ~/.codex/skills/plan-first-implementation
```

Or keep it linked to this repository:

```bash
mkdir -p ~/.codex/skills
ln -s /path/to/codex-skill-plan-first-implementation/plan-first-implementation ~/.codex/skills/plan-first-implementation
```

Restart Codex if the skill does not appear immediately.

## Usage

Call it explicitly:

```text
$plan-first-implementation
```

Or say:

```text
Use plan-first-implementation for this task.
Read the codebase first, write a grounded plan, then implement from that plan.
```

## Customization

This repository includes a launcher-style guide for adapting the skill with Codex:

- [CUSTOMIZE_WITH_CODEX.md](CUSTOMIZE_WITH_CODEX.md)
- [AGENTS.md](AGENTS.md)

Start with:

```text
Read CUSTOMIZE_WITH_CODEX.md and help me adapt plan-first-implementation for my own workflow.
```

## Public Safety

Do not publish:

- API keys
- tokens
- passwords
- private local paths
- internal company or client data
- private project-specific instructions

## License

MIT
