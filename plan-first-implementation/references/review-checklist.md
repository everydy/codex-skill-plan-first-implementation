# Review Checklist

Use this checklist before declaring a plan ready.

## General

- Is the requested outcome stated concretely?
- Did you inspect the actual files likely to control the behavior?
- Did you note where current behavior comes from?
- Does the plan include an in-document visualization for the material elements in scope?
- Did you separate confirmed facts from assumptions?
- Did you include validation steps?
- Could another agent start patching from this plan without broad rediscovery?

## Visualization and Traceability

- Does the visualization show the entry point, ownership boundaries, and downstream dependencies that matter?
- Are all material in-scope elements represented, not just the main happy path?
- Can each major node be traced to a concrete file, module, route, or doc owner?
- Does the plan make it obvious which nodes are expected to change and which must stay stable?
- Are uncertain edges or nodes called out in the written evidence instead of silently assumed?

## State and Data Flow

- What state controls the behavior?
- Where is the state created, read, and updated?
- Are there persisted or derived values that could be affected?
- Are there side effects or initialization rules that matter?
- Does the plan say exactly where those flows are likely touched?
- Is that flow reflected in the visualization instead of only implied in prose?

## UI and Routing

- Which route or entry point exposes the change?
- Which components render the affected UI?
- Are there conditional branches, empty states, or loading states?
- Could layout, responsive behavior, or shared styles be impacted?
- Are the likely edit locations named instead of left as generic "UI layer" notes?
- If routing or entry points matter, are they shown explicitly in the visualization?

## Content and Configuration

- Is behavior driven by content files, constants, or metadata?
- Is there versioned or archived content that may need comparison?
- Could a text change affect routing, branching, analytics, or display logic?
- Does the plan identify the content or config owner precisely enough to patch next?
- Are config or content dependencies visible in the change map and visualization?

## Refactoring

- What external behavior must remain unchanged?
- What boundaries should not move in this iteration?
- Can the work be split into smaller safe steps?
- Is the patch order concrete enough to avoid rethinking the entire refactor during execution?
- Does the visualization help explain the preserved vs changed boundaries?

## Pre-Execution Check

Do not execute yet if any core section is still empty or hand-wavy.
Do not execute yet if the next agent would still need to spend most of the time searching for ownership or patch points.
Do not execute yet if the visual map is missing, untraceable, or obviously incomplete for the scoped change.
