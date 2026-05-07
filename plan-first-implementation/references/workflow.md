# Workflow

## Mode Selection

Choose one mode before doing any substantive work.

### Planning Only

Use this when the user wants a plan document, wants review before execution, or the task is too ambiguous to patch safely.

Output:

- a grounded plan document
- a concrete change map that leaves little broad exploration for later
- explicit risks, assumptions, and validation steps
- no code edits

### Plan Then Execute

Use this when the user wants the plan written first and implementation to follow in the same task.

Output:

- the plan document first
- implementation only after the handoff checklist is satisfied
- the plan updated if execution changes scope or assumptions

## Implementation-Ready Standard

The default target is not just "a reasonable plan." The target is an implementation-ready plan.

That means the planning phase should usually answer:

- which files most likely need edits
- which component, hook, store, route, service, or data boundary owns the behavior
- which material elements are in scope and how they connect
- what should change in each likely edit location
- what must stay unchanged
- which unknowns are still open, and whether they are narrow enough to defer
- what the in-document visualization reveals about patch sequencing or risk

If the next agent would still need to spend substantial time rediscovering ownership, structure, or patch shape, the plan is still too early.

## Plan-Doc Location Heuristic

Choose the plan-doc destination in this order:

1. Update an existing plan doc if one already tracks the same task.
2. Reuse the repository's existing planning folder or docs convention.
3. If the repo has a clear docs area but no planning pattern, place the plan in the most relevant docs subtree.
4. If no docs convention exists, use `docs/plans/` and a task-specific filename.

Do not create a new top-level folder when an existing docs pattern already exists.

## Planning Workflow

1. Restate the requested outcome in one or two concrete sentences.
2. Find the code, content, or config files most likely to control the behavior.
3. Read enough files to explain current behavior, expected change points, state/data flow, ownership boundaries, and likely risks.
4. Identify the material elements in scope and how they connect.
5. Narrow the likely edit surface so execution does not start with broad rediscovery.
6. Draft or update the plan using the plan template.
7. Add the in-document visualization using `references/visualization-rules.md`.
8. Label claims with the evidence rules.
9. Add validation steps before any execution begins.

## Stop Conditions

Do not move to execution if any of these remain unresolved:

- the key files have not been inspected
- current behavior cannot be explained
- likely edit locations are still unknown
- the intended scope is still vague
- the in-scope relationships are not visualized inside the plan
- preserved behavior is not listed
- validation is missing
- the plan depends on too many unverified assumptions
- the plan still relies on broad "inspect later" placeholders

## Handoff Checklist

Before switching from planning to execution, confirm the plan contains:

- related files
- current behavior summary
- in-document visualization of material elements and their connections
- likely edit locations and change points
- planned changes
- preserved constraints
- risks and unknowns
- remaining unknowns narrowed enough that execution is mostly patching
- validation steps
- traceability from major visual nodes to concrete code ownership
- evidence labels on important claims

If the checklist is incomplete, stay in planning mode.
