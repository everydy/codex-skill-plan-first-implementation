# User Flows

Use these patterns to decide how the interaction should proceed.

## Planning Only

Flow:

1. User asks for review, planning, or a plan document first.
2. Inspect the repo and produce the grounded plan.
3. Stop after the plan unless the user later asks for execution.

## Plan Then Execute

Flow:

1. User asks for a plan first and implementation after.
2. Produce the plan.
3. Check the handoff checklist.
4. Execute against the plan.
5. Update the plan if execution changes assumptions.

## Ambiguous Request

Flow:

1. User request is underspecified or could branch multiple ways.
2. Produce a plan with assumptions, options, and unresolved points.
3. Avoid implementation until the ambiguity is reduced enough for safe execution.

## Iterative Follow-Up

Flow:

1. User returns to an existing task.
2. Read the existing plan first.
3. Preserve completed findings.
4. Add only the new evidence, scope changes, or remaining work.
