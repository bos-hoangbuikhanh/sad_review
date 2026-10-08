---
name: sad-final-reviewer
description: Produce the final evidence-backed SAD review after approved scope, document evidence, UMD/KMD code evidence, and traceability analysis exist. Use to decide checklist outcomes, classify formal findings versus observations or implementation drift, document unresolved decisions, and generate the final SAD review report without rewriting the SAD.
---

# SAD Final Reviewer

Act as the only phase that makes final checklist decisions and formal findings.

## Required Inputs

Read:

- `AGENTS.md`
- `review/scope.md`
- approved checklist and guideline
- approved target SAD
- `review/evidence/document-evidence.md`
- `review/evidence/umd-code-evidence.md`
- `review/evidence/kmd-code-evidence.md`
- `review/evidence/traceability.md`
- approved controlled requirements/reference artifacts, if any
- `references/finding-format.md`

## Decision Rules

For each checklist item `SAD-01` through `SAD-09`:

1. Re-read the exact controlled checklist question.
2. Apply the directly relevant guideline rule/evidence.
3. Review the complete evidence package.
4. Use only the checklist result vocabulary `Pass`, `Fail`, or `N/A` in the final checklist table.
5. Justify every `Fail` and every `N/A`.
6. Do not use `N/A` merely because evidence is missing.
7. When the review cannot establish a required fact because an approved dependency is inaccessible or missing, state the coverage limitation clearly and create a missing-evidence/open-decision entry as appropriate.

## Finding Classification

Use one of:

- `Process / guideline finding`
- `Cross-artifact inconsistency`
- `Implementation drift`
- `Review observation`
- `Missing evidence`
- `Decision required`

A formal process/guideline finding must pass the Formal Finding Gate in `AGENTS.md`.

## Severity

Use severity only when impact is justified:

- `Critical` — mandatory behavior or architecture incompatibility with severe verification/safety/security impact.
- `Major` — material ambiguity, missing behavior, inconsistency, or traceability gap that can lead to different implementations/tests.
- `Minor` — localized clarity/consistency issue unlikely to change intended behavior.

Omit severity when impact cannot be established.

## Outputs

### Findings

Write `review/findings/findings.md` using `references/finding-format.md`.

### Final Report

Write `review/reports/sad-review-report.md` with:

1. Review scope and baselines
2. Coverage and limitations
3. Executive summary
4. Checklist result table for `SAD-01` through `SAD-09`
5. Findings summary
6. Detailed findings
7. Traceability gaps
8. UMD/KMD boundary assessment
9. Decisions required
10. Suggested next actions

Do not rewrite the SAD unless the user explicitly asks for a separate rewrite task after reviewing the findings.
