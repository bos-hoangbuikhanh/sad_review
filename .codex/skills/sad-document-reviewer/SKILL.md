---
name: sad-document-reviewer
description: Review the approved target SAD as a document against the approved SAD Review Checklist and SAD Writing Guideline. Use after review scope has been explicitly approved to inspect architecture completeness, component boundaries, interfaces, dynamic behavior, consistency, analysis evidence, decisions, and reuse without treating implementation code as architecture truth.
---

# SAD Document Reviewer

Review only the approved document scope.

## Required Inputs

Read:

- `AGENTS.md`
- `review/scope.md`
- approved target SAD
- approved SAD Review Checklist
- approved SAD Writing Guideline
- any other controlled document explicitly listed in the approved scope

Do not inspect implementation code during this phase unless the approved scope explicitly requires a narrow document-to-code question and the orchestrator assigns that evidence to the code-evidence phase.

## Review Method

For each applicable checklist item `SAD-01` through `SAD-09`:

1. Identify the exact checklist question.
2. Locate the applicable guideline section or rule when available.
3. Inspect the complete relevant SAD section, including Mermaid, PlantUML, tables, and referenced preserved images.
4. Record direct document evidence.
5. Separate missing document evidence from engineering preference.
6. Do not assign final `Pass / Fail / N/A`; the final reviewer owns the checklist decision.

## Specific Checks

### SAD-01
Check component identification, responsibilities, boundaries, relationships, external/reused elements, and whether UMD/KMD scope is unambiguous.

### SAD-02
Check provided/required interfaces, operation names, inputs/outputs, data/control direction, constraints, and interface consistency across text and diagrams.

### SAD-03
Check architecture-level interactions, startup/shutdown where applicable, normal flows, error/recovery flows, modes, and concurrency evidence. Do not accept unit-internal behavior as a substitute for architecture behavior unless the controlled rule permits it.

### SAD-04
Check requirement allocation and bidirectional traceability only from controlled evidence actually supplied in scope. If SRS/traceability evidence is absent, record the limitation; do not invent mappings.

### SAD-05
Check semantic consistency with supplied requirements and internal consistency across Overview, Static View, Interface Description, and Dynamic View.

### SAD-06
Check architecture-analysis evidence for applicable quality characteristics, timing/performance, and resource constraints.

### SAD-07
Check material architecture decisions, feasibility, rationale, assumptions, risks, and negative impacts where applicable.

### SAD-08
Check reuse and meaningful alternative/reference architecture rationale where applicable.

### SAD-09
Check recorded architecture impact on estimates/planning and PM communication where applicable.

## Output

Write `review/evidence/document-evidence.md`.

Use one evidence section per checklist ID with:

- controlled criterion;
- SAD location;
- direct evidence;
- document gap or conflict;
- evidence status: `Supported`, `Gap`, `Missing evidence`, or `N/A candidate`;
- open question, if any.

Do not write final findings in this phase.
