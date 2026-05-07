# AGENTS.md

This repository contains one public Codex skill: `plan-first-implementation`.

When helping a user customize this repository, keep the package public-safe, focused, and grounded in implementation planning.

## Default Workflow

1. Read `CUSTOMIZE_WITH_CODEX.md`.
2. Inspect `plan-first-implementation/SKILL.md`.
3. Inspect `plan-first-implementation/assets/plan-document-template.md` if the user wants output format changes.
4. Ask only customization questions that affect behavior.
5. Propose a small patch plan before editing.
6. Keep examples aligned with the final skill behavior.
7. Check for private paths, secrets, and project-specific assumptions before finishing.

## Public Safety Rules

Do not add:

- API keys, tokens, passwords, or secrets
- absolute local machine paths
- private project names
- internal company or client data
- hidden personal workflow assumptions unless the user explicitly wants them published

## Scope Rules

This repo should stay focused on planning before code changes.

Do not turn this skill into:

- a broad project management system
- a final closeout format
- a code review framework
- a memory system
- a deployment gate

If the user wants those behaviors, suggest composing this skill with another dedicated skill.

## Files You Usually Edit

- `plan-first-implementation/SKILL.md`
- `plan-first-implementation/agents/openai.yaml`
- `plan-first-implementation/assets/plan-document-template.md`
- `plan-first-implementation/references/*.md`
- `examples/before-after.md`
- `README.md`
- `CUSTOMIZE_WITH_CODEX.md`

## Done Check

Before saying the repo is ready:

- run a text scan for private paths and obvious secrets
- verify the skill directory still contains `SKILL.md`
- verify the install instructions in `README.md` still match the repo layout
- confirm the plan template still includes evidence and validation
- summarize what changed in plain language
