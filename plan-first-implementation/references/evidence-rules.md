# Evidence Rules

Use evidence labels so another agent can quickly distinguish facts from working assumptions.

## Labels

### `Confirmed`

Use for statements verified by reading the relevant file, code path, or config.

Example:

- `Confirmed`: `src/stores/useQuizStore.js` persists quiz progress in local storage.

### `Inferred`

Use for statements that are likely true from partial evidence, but still need confirmation.

Example:

- `Inferred`: result-route rendering likely depends on router params and result-type content files.

### `Unverified`

Use for statements that still require direct inspection or runtime checking.

Example:

- `Unverified`: the tutorial question may be excluded from final score aggregation.

## Minimum Standard

At minimum, label:

- current behavior claims
- file ownership claims
- risk-heavy assumptions
- anything that gates execution

## Citation Style

Keep evidence compact:

- name the file
- name the function, component, route, or state source when known
- summarize the relevant behavior in one line

Do not paste long code blocks into the plan unless a short snippet is required to explain a subtle risk.
