# Visualization Rules

Every implementation-ready plan must include an in-document visualization when the task spans more than one meaningful boundary.

Examples of meaningful boundaries:

- route or entry point
- page or component owner
- hook, store, reducer, or controller
- service, client, worker, or background job
- content, config, schema, or data source
- integration, side effect, cache, or persistence layer
- validation or test surface that constrains the change

## Goal

Help the next execution step understand the change surface at a glance without reopening the entire repo.

The visualization is not decoration. It should reduce rediscovery by showing:

- what is in scope
- how the in-scope elements connect
- which boundaries are expected to change
- which boundaries must stay stable
- where uncertainty still exists

## Preferred Format

Use Mermaid by default inside the plan document.

Recommended diagram types:

- `flowchart LR`: ownership, dependency, render, or data-flow maps
- `sequenceDiagram`: request/response or async flow across boundaries
- `stateDiagram-v2`: UI or workflow state transitions

If Mermaid is unavailable or the document target rejects it, use a compact ASCII diagram instead.

## Minimum Completeness

The diagram should include every material element inside the requested scope, not every file in the repository.

Usually include:

- the user or system entry point
- the current owner of the behavior
- state/data/config sources touched by the change
- downstream consumers or side effects
- validation surfaces if they affect patch shape or risk

If an element is important enough to mention in `Current Behavior`, `Change Map`, or `Validation`, it is usually important enough to appear in the visualization.

## Traceability Rules

- Every major node should map to a concrete file, module, route, or document owner in the plan.
- Prefer labels like ``ResultPage (`src/features/results/ResultPage.tsx`)`` over generic labels like `UI`.
- Mark uncertain nodes or edges in surrounding text using the evidence labels from `references/evidence-rules.md`.
- If the planned change preserves a boundary, note that in `diagram notes`, `Planned Changes`, or both.

## Keep It Useful

- Optimize for scope clarity, not exhaustiveness theater.
- Avoid giant diagrams that restate the whole repo.
- Avoid decorative styling unless it helps explain changed vs preserved nodes.
- Update the diagram when later evidence changes the assumed ownership or flow.
