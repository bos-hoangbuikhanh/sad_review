# BOS SAD Review Workspace

This workspace is used for independent Software Architecture Design (SAD) review.

## Workspace Layout

- `review-input/` contains controlled review inputs exported from Confluence or other approved sources.
- `source/` contains implementation repositories used only as implementation evidence.
- `review/` contains scope, evidence, findings, and final reports produced by the review workflow.
- `.codex/skills/` contains reusable SAD review workflows.

## Protected Inputs

Treat the following as read-only unless the user explicitly requests an edit:

- `review-input/**`
- `source/bos-umd/**`
- `source/bos-kmd/**`

Do not silently fix the SAD, guideline, checklist, or source code while reviewing them.

## Default Review Inputs

- Target SAD: `review-input/sad/umd-kmd-sad.md`
- SAD Review Checklist: `review-input/checklist/sad-review-checklist.md`
- SAD Writing Guideline: `review-input/guideline/sad-writing-guideline.md`
- UMD implementation: `source/bos-umd/`
- KMD implementation: `source/bos-kmd/`

If the user supplies another controlled artifact, add it to the proposed scope before using it.

## Source Authority

Within an approved review scope, use evidence in this order:

1. User-approved review scope.
2. Current controlled SAD Review Checklist.
3. Current controlled SAD Writing Guideline.
4. Software requirements or other controlled requirements supplied in scope.
5. Target SAD and referenced controlled architecture artifacts.
6. Current implementation evidence from `bos-umd` and `bos-kmd` at the recorded baseline.
7. Reviewer engineering knowledge, clearly labeled as a review observation only.

When sources conflict, report the conflict. Do not silently choose one source.

## Evidence Classes

Classify evidence internally as:

- `CONTROLLED RULE`
- `DOCUMENT FACT`
- `IMPLEMENTATION EVIDENCE`
- `ASSUMPTION`
- `REVIEW OBSERVATION`
- `OPEN ISSUE`

Never present an assumption or engineering preference as a controlled rule.

## Scope Gate

Never begin the actual SAD review before the effective scope is shown to the user and explicitly approved.

The proposed scope must identify, when available:

- target SAD and revision;
- checklist and guideline;
- UMD repository baseline;
- KMD repository baseline;
- optional SRS or other controlled references;
- review criteria and exclusions;
- expected outputs.

A change to the SAD, checklist, guideline, repository baseline, controlled references, review criteria, or exclusions changes the scope and requires renewed approval.

Before approval, only inspect enough metadata to prepare the scope. Do not produce preliminary findings.

## Review Boundary

Review; do not author.

Do:

- evaluate the supplied SAD against the approved checklist and guideline;
- compare documented architecture with implementation evidence;
- identify precise gaps, inconsistencies, drift, missing evidence, and decisions required;
- keep UMD and KMD evidence distinguishable;
- review the UMD/KMD architectural boundary explicitly;
- preserve exact technical wording when citing the target artifact.

Do not:

- invent missing architecture;
- infer stakeholder intent from existing code;
- treat implementation as proof that the documented design is correct;
- turn implementation details into requirements without a controlled source;
- rewrite the SAD by default;
- modify source repositories during review.

## Formal Finding Gate

Create a formal checklist/guideline finding only when all are true:

1. a specific applicable checklist or guideline criterion is identified;
2. the criterion applies to the reviewed location or evidence;
3. target evidence is available;
4. the evidence directly demonstrates the gap or contradiction;
5. the conclusion does not depend on an invented requirement.

If any condition fails, classify the concern as one of:

- `Review observation`
- `Implementation drift`
- `Missing evidence`
- `Decision required`

## Diagram Rules

Treat Mermaid, PlantUML, and preserved diagram images in the review inputs as architecture evidence.

Do not infer details that are not visible in the diagram or surrounding text.

## Review Output Rules

Write generated review artifacts only under `review/` unless the user explicitly requests another location.

Use these canonical outputs:

- `review/scope.md`
- `review/evidence/document-evidence.md`
- `review/evidence/umd-code-evidence.md`
- `review/evidence/kmd-code-evidence.md`
- `review/evidence/traceability.md`
- `review/findings/findings.md`
- `review/reports/sad-review-report.md`

## Completion Rule

A review is complete only when:

- scope was explicitly approved;
- controlled checklist/guideline evidence was applied;
- document evidence was collected;
- implementation evidence was collected for the approved code scope;
- traceability was checked to the extent evidence allows;
- UMD/KMD boundary consistency was checked;
- every formal finding is evidence-backed;
- missing technical truth is reported rather than invented;
- the final report clearly states coverage limitations.
