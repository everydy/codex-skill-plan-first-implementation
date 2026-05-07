# Add Dedicated Tutorial Result Route

## Goal

Expose a direct tutorial-result route without changing the existing result flow for standard quiz types.
Keep the shared result page shell intact so the new route reuses the current presentation boundary.
Confine the likely change to the routing and content-resolution seam unless code review proves otherwise.

## Requested Outcome

Add a route that lets the app render a tutorial result directly.
Preserve the current `/result/:type` behavior for standard result types.
Prefer an approach that reduces duplication instead of creating a second result-page implementation.

## Codebase Evidence

- `Confirmed`: `src/routes/result/$type.tsx` is the direct-entry route for result pages.
- `Confirmed`: `src/features/results/ResultPage.tsx` owns the shared result render path.
- `Confirmed`: `src/features/results/resolveResultContent.ts` selects content based on the route param.
- `Inferred`: tutorial output should branch in the resolver layer instead of duplicating the entire page shell.
- `Unverified`: whether tutorial content already matches the standard result contract closely enough to avoid an adapter.

## System Visualization

```mermaid
flowchart LR
    Route["`src/routes/result/$type.tsx` route entry"] --> Page["`src/features/results/ResultPage.tsx` render owner"]
    Page --> Resolver["`src/features/results/resolveResultContent.ts` content resolver"]
    Resolver --> StandardData["`src/data/resultCatalog.ts` standard result content"]
    Resolver --> TutorialData["`src/data/tutorialResults.ts` tutorial result content"]
    Page --> Validation["route smoke test + direct URL manual check"]
```

- changed nodes: `src/routes/result/$type.tsx`, `src/features/results/resolveResultContent.ts`
- preserved nodes: `src/features/results/ResultPage.tsx` page shell and standard-result rendering path
- diagram notes: keep the page shell stable and add the tutorial-specific branch at the route/resolver seam

## Related Files

- `src/routes/result/$type.tsx`: route entry that parses the direct-access result type
- `src/features/results/ResultPage.tsx`: shared result render owner that should stay stable if possible
- `src/features/results/resolveResultContent.ts`: content selection seam most likely to absorb tutorial branching
- `src/data/resultCatalog.ts`: current source for standard result content
- `src/data/tutorialResults.ts`: likely source for tutorial-specific result content or adapter input

## Current Behavior

The app can open a result page directly for standard result types by routing through `src/routes/result/$type.tsx`.
That route renders `ResultPage` and resolves content from the route param through `resolveResultContent.ts`.
Tutorial behavior appears to bypass that standard resolver contract or rely on a separate data shape.

## Change Map

- likely files to edit: `src/routes/result/$type.tsx`, `src/features/results/resolveResultContent.ts`
- likely functions/components/hooks/stores/routes to touch: route-param parsing, content resolution, tutorial branch selection
- state/data/content dependencies: result type parsing, direct URL fallback behavior, tutorial result data shape
- side effects/integrations to preserve or adjust: direct URL behavior for standard results, existing analytics or route-based tracking
- likely new files: none expected in the first approach
- remaining narrow unknowns before patch: whether tutorial data already matches the standard result contract closely enough to avoid a separate adapter

## Planned Changes

- expected behavior changes: tutorial results become directly addressable by URL through the shared result page shell
- constraints to preserve: existing result URLs, shared page layout, and standard result rendering must remain unchanged
- execution order if sequencing matters: confirm route/resolver ownership, patch tutorial branching, then verify direct-access regressions before touching presentation

## Review Notes

- risks: tutorial data may not match the normal result contract; route-based analytics may assume the current standard result taxonomy
- assumptions: the shared result page shell can be preserved and only the route/resolver seam changes
- unanswered questions: whether tutorial analytics or progress state depends on the current route structure

## Execution Plan

1. confirm `src/routes/result/$type.tsx` and `resolveResultContent.ts` are the only routing/resolution owners
2. patch tutorial routing/resolution while keeping `ResultPage.tsx` stable
3. verify direct access for standard and tutorial result routes

## Validation

- manual checks: open standard result routes and the tutorial route directly; confirm the shared page shell still renders correctly
- lint/build/test scope: run the repo's standard validation commands if available
- scenario-to-surface checks: standard route -> shared page -> standard data, tutorial route -> shared page -> tutorial data
