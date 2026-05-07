# Plan Template Guide

Use `assets/plan-document-template.md` as the actual template. This file explains what each section must accomplish.

## Goal

State the business or product outcome, not just the code action.

Good:

- "Add a dedicated onboarding route that preserves the existing quiz flow."

Weak:

- "Create a new component."

## Requested Outcome

Capture what the user explicitly asked for. Separate direct requests from your own implementation choices.

## Codebase Evidence

List the files, modules, and relevant behavior discovered during review. This is the factual base for the plan.

Include:

- related files
- relevant routes, stores, hooks, services, or content files
- short summaries of current behavior
- notes about which part likely owns the change
- evidence labels tied to concrete repo findings, not generic intuition

## System Visualization

Include an in-document visualization that shows the material elements in scope and how they connect.

Use Mermaid by default. Fall back to ASCII only when Mermaid is not practical for the target document.

Include:

- the user or system entry point
- the current owner of the behavior
- state, data, content, config, or integration boundaries involved
- validation or test surfaces if they shape the patch
- notes about changed nodes vs preserved nodes

Every major node should be traceable to a concrete file, module, route, or owner elsewhere in the plan.

## Change Map

Reduce future rediscovery.

Include:

- likely files to edit
- likely functions, components, hooks, stores, or routes to touch
- state, data, side effects, or content dependencies involved
- which nodes from the visualization are expected to change
- any likely new files
- any narrow unknowns that remain before patching

## Planned Changes

Describe expected edits before making them.

Include:

- new files, if any
- behavior that should change
- behavior that must stay unchanged
- execution order if patch sequencing matters

## Review Notes

Call out uncertainty early.

Include:

- risks
- assumptions
- unanswered questions
- follow-up checks

## Execution Plan

Use a short numbered sequence that another agent could follow without rethinking the task from scratch.

Good execution plans assume exploration is mostly done and focus on patch order plus verification.

## Validation

Define how the result will be checked.

Include:

- manual QA checks
- lint/build/test scope
- any scenario-specific verification
- any diagram node or edge that deserves an explicit regression check
