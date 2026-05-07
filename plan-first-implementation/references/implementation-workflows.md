# Implementation Workflows

Adjust the planning emphasis based on the work type.

## Bug Fix

Focus on cause before fix.

1. Record the symptom and reproduction conditions.
2. Identify the files that likely control the broken path.
3. List one or more root-cause hypotheses.
4. Attach evidence to each hypothesis.
5. Visualize the failing path from trigger to broken boundary.
6. Choose the smallest viable change.
7. Define how success will be verified.

## UI Addition

Focus on user entry points and state transitions.

1. Describe what the user should see and do.
2. Identify the route, entry point, and rendering components.
3. Identify which state or content drives the new UI.
4. Visualize the path from entry point to render owner to state/content sources.
5. Note styling, layout, and responsive risks.
6. Define file additions or edits.
7. Define manual checks for the happy path and edge states.

## Refactor

Focus on preserved behavior.

1. State why the current structure is a problem.
2. List the files or boundaries involved.
3. Visualize the current boundary map and the intended post-refactor map.
4. List the behavior that must not change.
5. Split the work into small safe steps.
6. Define regression checks for each step.

## Content or Data Change

Focus on downstream effects.

1. Identify the source files for the content or data.
2. Identify the screens, routes, or branches that consume it.
3. Visualize the source-to-consumer path.
4. Check whether text or metadata changes affect logic.
5. Compare against archived or prior versions when relevant.
6. Define verification at each display location.
