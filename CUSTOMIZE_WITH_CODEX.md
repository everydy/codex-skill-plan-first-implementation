# Customize Plan First Implementation With Codex

This file is a launcher-style guide for adapting `plan-first-implementation` to your own workflow.

Open this repository in Codex, then paste one of the prompts below.

## Quick Customization Prompt

```text
Read this repository and customize plan-first-implementation for my workflow.

Keep the skill focused on evidence-based planning before implementation.
Do not turn it into a broad project management framework.

Ask me only the questions that change behavior. Then update:
- plan-first-implementation/SKILL.md
- plan-first-implementation/agents/openai.yaml
- plan-first-implementation/assets/plan-document-template.md if the plan sections should change
- examples/before-after.md if the examples should match my workflow

Preserve the core purpose:
- inspect the codebase before patching
- write an implementation-ready plan
- include evidence, risks, change map, validation, and execution order
- implement only after the plan is concrete enough

Before editing, show me:
1. what you think my workflow needs
2. what sections you will change
3. what you will not change
```

## Questions Codex Should Ask You

If you want Codex to interview you first, use this prompt:

```text
Use plan-first-implementation's own rules to interview me before customizing this skill.

Ask up to 6 practical questions about:
- where plan documents should live
- what sections every plan must include
- when Codex should stop at planning only
- when Codex may continue into implementation
- which verification commands matter in my projects
- how detailed system visualizations should be

After I answer, propose a small patch plan before editing files.
```

## Common Customization Targets

Adjust these in `plan-first-implementation/SKILL.md`:

- `언제 쓸까`: make triggers match your language
- `핵심 흐름`: tune planning vs implementation flow
- `근거 수집용 CLI 우선 규칙`: align with your local tool preferences
- `꼭 남겨야 할 것`: define required plan content
- `가드레일`: decide when Codex must stop before patching

Adjust these helper files:

- `assets/plan-document-template.md`: change the default plan sections
- `references/workflow.md`: tune planning modes
- `references/review-checklist.md`: tune readiness checks
- `references/visualization-rules.md`: tune diagram expectations

## Safe Customization Rules

When adapting this skill:

- do not add private local paths
- do not add API keys or secrets
- do not include private project names unless you intend to publish them
- do not let the skill claim a plan is implementation-ready without evidence
- do not remove validation from the plan template

## Validation Prompt

After customization, ask Codex:

```text
Review this plan-first-implementation customization.

Check for:
- private paths or secrets
- plan sections that are too vague
- missing validation requirements
- unclear planning-only vs plan-then-execute behavior
- examples that do not match the skill

Then run a lightweight repo inspection and tell me whether it is ready to commit.
```
