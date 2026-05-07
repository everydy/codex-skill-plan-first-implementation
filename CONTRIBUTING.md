# Contributing

Contributions are welcome if they keep the skill small, public-safe, and useful.

## Good Changes

- clearer planning examples
- better plan template sections
- better evidence and validation guidance
- safer planning-to-implementation guardrails
- helper script fixes
- typo fixes
- English documentation improvements

## Changes To Avoid

- adding private workflow details
- adding private paths or secrets
- turning the skill into a broad project management framework
- removing validation from the plan template
- making plans decorative instead of implementation-ready

## Before Opening A Pull Request

Run:

```bash
bash scripts/security-scan.sh
```

Then manually check:

- `plan-first-implementation/SKILL.md` still requires planning before implementation
- `plan-first-implementation/assets/plan-document-template.md` still includes evidence and validation
- `README.md` install commands match the repo layout
- examples do not include private paths, secrets, or private project names

No real private paths or secrets should remain.
