# Public Release Handoff

This repository is the public package for `plan-first-implementation`.

The source skill may also exist in a private or local skill repository. When updating this public repository from a local source, keep the core skill behavior aligned while removing private material.

## Keep Aligned

The public `plan-first-implementation/SKILL.md` should preserve the same behavior contract:

- inspect the codebase before implementation
- write or update a grounded plan document first
- include scope, evidence, risks, validation, related files, and execution order
- add a system visualization when the task spans multiple meaningful boundaries
- implement only after the plan is concrete enough

The public `plan-first-implementation/agents/openai.yaml` should also stay aligned with the source skill unless there is a deliberate public packaging reason.

## Remove Before Publishing

Do not publish:

- absolute local machine paths
- private docs links
- API keys, tokens, passwords, or secrets
- private project names
- internal workflow details that only make sense in a private workspace
- personal knowledge-base paths

## Public-Only Additions

These files are allowed and expected in the public repository:

- `README.md`
- `README.en.md`
- `CUSTOMIZE_WITH_CODEX.md`
- `AGENTS.md`
- `CONTRIBUTING.md`
- `LICENSE`
- `examples/`
- `scripts/security-scan.sh`

These files should help users install, understand, and customize the skill. They should not change the core behavior contract.

## Allowed Drift

Small differences are acceptable when they are only about public safety or public packaging:

- removing private path references
- removing private docs references
- adding install instructions
- adding contribution instructions
- adding public customization guidance

Behavior differences are not acceptable unless intentionally documented.

## Sync Checklist

Before committing a public update:

1. Compare the source `SKILL.md` and public `plan-first-implementation/SKILL.md`.
2. Compare the source `agents/openai.yaml` and public `plan-first-implementation/agents/openai.yaml`.
3. Confirm any remaining differences are public-safety or packaging differences.
4. Run a private path and secret scan.
5. Confirm the skill directory still contains `SKILL.md`.
6. Confirm README install instructions still match the repository layout.
7. Confirm helper scripts do not write private paths or call external services.

## Codex Update Order

When Codex updates `plan-first-implementation` and prepares a public release, follow this order:

1. Update the source skill first.
2. Classify the change as core skill behavior, public documentation, helper asset, or private/internal note.
3. Copy core behavior and public helper changes into this public repository.
4. Remove local paths, private docs links, private project context, and secrets before publishing.
5. Add or improve public-facing README, examples, install instructions, and customization guidance when they help users.
6. Diff core files against the source skill and confirm any differences are intentional public-safety or packaging differences.
7. Run a private path and secret scan in this repository.
8. Commit the public repository.
9. Push only after confirming the repository is intended to be public.

Core rule: keep behavior aligned, remove private material, make public docs friendlier.

## Safety Scan

Before publishing, scan for absolute local paths, API key names, token-looking strings, private key blocks, and password or secret assignments.

No real secrets or private paths should remain.
