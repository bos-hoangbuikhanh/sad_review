#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-/home/hoangb/BOS/sad-review}"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$ROOT/.setup-backup/$STAMP"

log() { printf '[sad-review-setup] %s\n' "$*"; }
warn() { printf '[sad-review-setup][WARN] %s\n' "$*" >&2; }

if [[ ! -d "$ROOT" ]]; then
  echo "Project root does not exist: $ROOT" >&2
  exit 1
fi

mkdir -p \
  "$ROOT/.codex/skills/sad-review-orchestrator" \
  "$ROOT/.codex/skills/sad-document-reviewer" \
  "$ROOT/.codex/skills/sad-code-evidence" \
  "$ROOT/.codex/skills/sad-traceability-reviewer" \
  "$ROOT/.codex/skills/sad-final-reviewer/references" \
  "$ROOT/review/evidence" \
  "$ROOT/review/findings" \
  "$ROOT/review/reports"

backup_before_overwrite() {
  local path="$1"
  if [[ -f "$path" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -a "$path" "$BACKUP_DIR/$(basename "$path")"
  fi
}

create_if_missing() {
  local path="$1"
  if [[ -e "$path" ]]; then
    log "Keep existing output/template: ${path#$ROOT/}"
    return 1
  fi
  return 0
}

# -----------------------------------------------------------------------------
# Workspace policy
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/AGENTS.md"
cat > "$ROOT/AGENTS.md" <<'EOF'
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
EOF

# -----------------------------------------------------------------------------
# Project README
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/README.md"
cat > "$ROOT/README.md" <<'EOF'
# BOS SAD Review

Local Codex workspace for evidence-first review of the UMD/KMD Software Architecture Design.

## Inputs

```text
review-input/
├── sad/
│   └── umd-kmd-sad.md
├── checklist/
│   └── sad-review-checklist.md
└── guideline/
    ├── sad-writing-guideline.md
    └── assets/
```

## Implementation Evidence

```text
source/
├── bos-umd/
└── bos-kmd/
```

The source repositories are evidence only. They are not the authority for intended architecture.

## Review Workflow

```mermaid
flowchart TD
    U[User asks for SAD review] --> O[SAD Review Orchestrator]
    O --> S[Propose review scope]
    S --> A{User explicitly approves?}
    A -- No --> S
    A -- Yes --> D[SAD Document Reviewer]
    A -- Yes --> C[SAD Code Evidence]
    D --> T[SAD Traceability Reviewer]
    C --> T
    T --> F[SAD Final Reviewer]
    F --> R[Final SAD Review Report]
```

The workflow is intentionally gated. No actual review findings are produced before scope approval.

## Codex Skills

- `sad-review-orchestrator` — prepare and enforce the approved review scope, then coordinate the workflow.
- `sad-document-reviewer` — inspect SAD content against the checklist and writing guideline without using code as design truth.
- `sad-code-evidence` — collect UMD/KMD implementation evidence without making architecture compliance decisions.
- `sad-traceability-reviewer` — map requirements, SAD elements, interfaces, flows, and implementation evidence when available.
- `sad-final-reviewer` — apply the controlled criteria to the evidence package and produce findings plus the final report.

## Start a Review

Open the repository in VSCode/Codex and use a prompt such as:

```text
Review the UMD/KMD SAD in this workspace.
Follow AGENTS.md and use the sad-review-orchestrator workflow.
First propose the effective review scope and wait for my explicit approval.
Do not produce findings before I approve the scope.
```

After Codex proposes the scope, explicitly reply with approval if it is correct, for example:

```text
Approved. Use exactly this scope.
```

## Outputs

```text
review/
├── scope.md
├── evidence/
│   ├── document-evidence.md
│   ├── umd-code-evidence.md
│   ├── kmd-code-evidence.md
│   └── traceability.md
├── findings/
│   └── findings.md
└── reports/
    └── sad-review-report.md
```

## Adding SRS Later

Place controlled requirement exports under:

```text
review-input/srs/
├── umd-srs.md
└── kmd-srs.md
```

Then add those files to the proposed scope before approving the review. The traceability step can extend to:

```text
SRS / VC -> SAD element -> interface / flow -> implementation evidence
```
EOF

# -----------------------------------------------------------------------------
# Skill 1: Orchestrator
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/.codex/skills/sad-review-orchestrator/SKILL.md"
cat > "$ROOT/.codex/skills/sad-review-orchestrator/SKILL.md" <<'EOF'
---
name: sad-review-orchestrator
description: Coordinate an evidence-first SAD review in this workspace. Use when the user asks to review the UMD/KMD SAD, start or continue a SAD review, define review scope, or run the complete SAD review workflow. Always enforce explicit scope approval before document analysis, code evidence collection, traceability conclusions, or findings.
---

# SAD Review Orchestrator

Act as the control plane for the SAD review. Do not perform the final review yourself.

## Default Inputs

Use these only as candidate scope until the user approves them:

- `review-input/sad/umd-kmd-sad.md`
- `review-input/checklist/sad-review-checklist.md`
- `review-input/guideline/sad-writing-guideline.md`
- `source/bos-umd/`
- `source/bos-kmd/`

If `review-input/srs/` exists, do not add its contents automatically. Identify candidate controlled requirement files and include them in the proposed scope only when relevant.

## Workflow

1. Read `AGENTS.md`.
2. Inspect only enough target/input metadata and repository baseline information to define the scope.
3. Record the current branch and commit for each approved source repository when available.
4. Propose the effective review scope in chat.
5. Include target artifacts, baselines, criteria, exclusions, missing evidence, and expected outputs.
6. Ask for explicit approval.
7. Stop. Do not generate preliminary findings before approval.
8. After explicit approval, write the approved scope to `review/scope.md`.
9. Perform the document-review phase according to `sad-document-reviewer`.
10. Perform implementation-evidence collection according to `sad-code-evidence`.
11. Perform the traceability phase according to `sad-traceability-reviewer`.
12. Perform the final decision/report phase according to `sad-final-reviewer`.
13. If any scope element changes, stop and request renewed approval before using the changed evidence.

## Scope Proposal Format

Use this structure:

```markdown
# Proposed SAD Review Scope

## Target SAD
- File:
- Revision/status:

## Controlled Review Criteria
- Checklist:
- Guideline:
- Additional controlled references:

## Implementation Baseline
### UMD
- Path:
- Branch:
- Commit:

### KMD
- Path:
- Branch:
- Commit:

## Review Coverage
- SAD-01 ... SAD-09
- UMD/KMD architecture boundary
- SAD-to-implementation alignment
- traceability to requirements when supplied

## Exclusions
- ...

## Missing / Inaccessible Evidence
- ...

## Outputs
- review/scope.md
- review/evidence/...
- review/findings/findings.md
- review/reports/sad-review-report.md
```

End with a direct request for explicit approval.

## Approval Rule

Treat only an explicit statement such as `Approved`, `I approve this scope`, or an equivalent unambiguous confirmation as approval.

Selecting a mode, requesting an output format, or discussing the scope is not approval.
EOF

# -----------------------------------------------------------------------------
# Skill 2: Document reviewer
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/.codex/skills/sad-document-reviewer/SKILL.md"
cat > "$ROOT/.codex/skills/sad-document-reviewer/SKILL.md" <<'EOF'
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
EOF

# -----------------------------------------------------------------------------
# Skill 3: Code evidence
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/.codex/skills/sad-code-evidence/SKILL.md"
cat > "$ROOT/.codex/skills/sad-code-evidence/SKILL.md" <<'EOF'
---
name: sad-code-evidence
description: Collect read-only implementation evidence from the approved bos-umd and bos-kmd repository baselines for SAD review. Use after scope approval to verify current interfaces, call flows, device access, KMD/UMD boundaries, configuration, error handling, lifecycle behavior, and observability without converting implementation behavior into intended architecture or making final compliance judgments.
---

# SAD Code Evidence

Collect implementation evidence only from repository paths and baselines approved in `review/scope.md`.

## Rules

- Keep source repositories read-only.
- Do not modify code, config, tests, branches, or commits.
- Do not use implementation as proof of intended architecture.
- Do not create final checklist decisions or findings.
- Distinguish UMD evidence from KMD evidence.
- Record repository, branch/commit, file path, symbol, and observed behavior whenever available.

## Evidence Questions

Derive evidence questions from the approved SAD/document evidence, including when applicable:

- How are devices discovered and opened?
- How does UMD identify/select a KMD device node?
- Which operations use `open`, `ioctl`, `mmap`, BAR mapping, DMA, or equivalent mechanisms?
- How are cluster construction and topology discovery implemented?
- How are device-memory and device-register accesses implemented?
- How is multicast access implemented?
- How is static TLB/BAR-window configuration represented?
- What errors are returned or propagated?
- What startup/probe/remove/open/close lifecycle behavior exists?
- How are multiple accelerator devices represented?
- What logging or diagnostics support verification?

Search only as far as needed to answer approved evidence questions.

## UMD Output

Write `review/evidence/umd-code-evidence.md`.

For each item use:

```markdown
## UMD-EV-XXX

- Repository:
- Baseline:
- File:
- Symbol:
- Related SAD section/interface:
- Observed behavior:
- Evidence classification: Current implementation evidence
- Limitations / ambiguity:
```

## KMD Output

Write `review/evidence/kmd-code-evidence.md` using the same structure with IDs `KMD-EV-XXX`.

## Drift Candidate

When code and SAD appear different, record both facts as a `Drift candidate` without deciding which side is correct. Leave the decision to the final reviewer.
EOF

# -----------------------------------------------------------------------------
# Skill 4: Traceability reviewer
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/.codex/skills/sad-traceability-reviewer/SKILL.md"
cat > "$ROOT/.codex/skills/sad-traceability-reviewer/SKILL.md" <<'EOF'
---
name: sad-traceability-reviewer
description: Build bidirectional traceability for the approved SAD review from controlled requirements when supplied through SAD elements, interfaces, flows, and UMD/KMD implementation evidence. Use after document and code evidence collection to identify covered, partial, missing, conflicting, or blocked mappings without inventing requirements or treating code as the source of intended behavior.
---

# SAD Traceability Reviewer

Use only approved scope and already collected evidence.

## Inputs

Read:

- `review/scope.md`
- `review/evidence/document-evidence.md`
- `review/evidence/umd-code-evidence.md`
- `review/evidence/kmd-code-evidence.md`
- approved SRS/requirements when present

## Mapping Direction

When controlled requirements are available, build both directions:

```text
Requirement / VC
  -> SAD component / interface / flow / decision
  -> UMD or KMD implementation evidence
```

and:

```text
Material SAD design element / behavior
  -> justifying requirement or controlled constraint
```

Do not require one-to-one mappings when one requirement legitimately spans multiple design elements or vice versa.

## UMD/KMD Boundary

Always check the documented boundary between UMD and KMD:

- ownership of responsibilities;
- provided/required interface relationship;
- device-node or kernel/userspace boundary;
- operation/control direction;
- error semantics when documented;
- lifecycle assumptions;
- mapping between static and dynamic views.

## Missing Requirements

If SRS or controlled traceability evidence is not part of the approved scope:

- do not invent requirement IDs;
- state that full `SAD-04` bidirectional requirement traceability cannot be established from the available evidence;
- still map SAD elements to implementation evidence as supporting alignment information.

## Output

Write `review/evidence/traceability.md`.

Prefer this table:

| Source | SAD element | Implementation evidence | Status | Gap / conflict |
|---|---|---|---|---|
| Requirement/VC or `Not supplied` | ... | ... | Covered / Partial / Missing / Conflicting / Blocked | ... |

Finish with:

- reverse-traceability gaps;
- UMD/KMD boundary gaps;
- evidence limitations;
- open decisions.

Do not create final checklist results in this phase.
EOF

# -----------------------------------------------------------------------------
# Skill 5: Final reviewer
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/.codex/skills/sad-final-reviewer/SKILL.md"
cat > "$ROOT/.codex/skills/sad-final-reviewer/SKILL.md" <<'EOF'
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
EOF

# -----------------------------------------------------------------------------
# Shared finding format
# -----------------------------------------------------------------------------
backup_before_overwrite "$ROOT/.codex/skills/sad-final-reviewer/references/finding-format.md"
cat > "$ROOT/.codex/skills/sad-final-reviewer/references/finding-format.md" <<'EOF'
# SAD Finding Format

Use one finding for one independently understandable issue.

```markdown
## SAD-F-XXX — <short title>

**Classification:** Process / guideline finding | Cross-artifact inconsistency | Implementation drift | Review observation | Missing evidence | Decision required

**Severity:** Critical | Major | Minor

**Checklist:** SAD-XX or `N/A`

**Guideline / controlled criterion:** <exact applicable rule/section or `Not established`>

**Location:** <precise SAD section/table/diagram and, when applicable, code path/symbol>

### Evidence

<short factual evidence only>

### Issue

<what is wrong, missing, inconsistent, ambiguous, or unsupported>

### Impact

<why the issue matters to architecture, implementation, integration, verification, operation, safety, security, maintenance, or planning>

### Suggested correction

<smallest evidence-supported correction, or `Domain owner decision required`>

### Traceability

- Requirement / VC: <ID or `Not supplied`>
- SAD element: <section/interface/flow>
- Implementation evidence: <UMD-EV/KMD-EV IDs or `Not applicable`>
```

For a `Review observation`, explicitly state that it is not a formal controlled-rule violation.

For `Implementation drift`, state both documented behavior and observed implementation behavior without assuming which one should change.
EOF

# -----------------------------------------------------------------------------
# Review artifact templates - create only if they do not already exist
# -----------------------------------------------------------------------------
if create_if_missing "$ROOT/review/scope.md"; then
cat > "$ROOT/review/scope.md" <<'EOF'
# SAD Review Scope

**Status:** `PENDING APPROVAL`

> This file must not be treated as approved until the user explicitly approves the effective scope in chat and Codex records that approval here.

## Target SAD

- File: `review-input/sad/umd-kmd-sad.md`
- Revision/status: `<resolve before approval>`

## Controlled Review Criteria

- Checklist: `review-input/checklist/sad-review-checklist.md`
- Guideline: `review-input/guideline/sad-writing-guideline.md`
- Additional controlled references: `<none / list>`

## Implementation Baseline

### UMD

- Path: `source/bos-umd`
- Branch: `<resolve>`
- Commit: `<resolve>`

### KMD

- Path: `source/bos-kmd`
- Branch: `<resolve>`
- Commit: `<resolve>`

## Review Coverage

- SAD-01 Component definition and boundaries
- SAD-02 Interfaces and data/control flow
- SAD-03 Dynamic behavior and applicable error/recovery/concurrency flows
- SAD-04 Requirement allocation and bidirectional traceability
- SAD-05 Semantic/internal consistency
- SAD-06 Quality characteristics and constraints
- SAD-07 Architecture decisions and feasibility/risk evidence
- SAD-08 Reuse/alternative suitability rationale
- SAD-09 Planning/estimate impact
- UMD/KMD architecture boundary
- SAD-to-implementation alignment

## Exclusions

- `<to be proposed and approved>`

## Missing / Inaccessible Evidence

- `<to be recorded>`

## Expected Outputs

- `review/evidence/document-evidence.md`
- `review/evidence/umd-code-evidence.md`
- `review/evidence/kmd-code-evidence.md`
- `review/evidence/traceability.md`
- `review/findings/findings.md`
- `review/reports/sad-review-report.md`

## Approval

- Approved by: `<pending>`
- Approval statement: `<pending>`
- Approved scope version/date: `<pending>`
EOF
fi

if create_if_missing "$ROOT/review/evidence/document-evidence.md"; then
cat > "$ROOT/review/evidence/document-evidence.md" <<'EOF'
# SAD Document Evidence

> Generated only after scope approval by the `sad-document-reviewer` workflow.

| Checklist | SAD location | Controlled criterion | Direct evidence | Evidence status | Gap / open question |
|---|---|---|---|---|---|
| SAD-01 | | | | | |
| SAD-02 | | | | | |
| SAD-03 | | | | | |
| SAD-04 | | | | | |
| SAD-05 | | | | | |
| SAD-06 | | | | | |
| SAD-07 | | | | | |
| SAD-08 | | | | | |
| SAD-09 | | | | | |
EOF
fi

if create_if_missing "$ROOT/review/evidence/umd-code-evidence.md"; then
cat > "$ROOT/review/evidence/umd-code-evidence.md" <<'EOF'
# UMD Implementation Evidence

> Generated only after scope approval. Source code is implementation evidence, not intended architecture.

## Baseline

- Repository: `source/bos-umd`
- Branch: `<from approved scope>`
- Commit: `<from approved scope>`

## Evidence Items

<!-- Use UMD-EV-001, UMD-EV-002, ... -->
EOF
fi

if create_if_missing "$ROOT/review/evidence/kmd-code-evidence.md"; then
cat > "$ROOT/review/evidence/kmd-code-evidence.md" <<'EOF'
# KMD Implementation Evidence

> Generated only after scope approval. Source code is implementation evidence, not intended architecture.

## Baseline

- Repository: `source/bos-kmd`
- Branch: `<from approved scope>`
- Commit: `<from approved scope>`

## Evidence Items

<!-- Use KMD-EV-001, KMD-EV-002, ... -->
EOF
fi

if create_if_missing "$ROOT/review/evidence/traceability.md"; then
cat > "$ROOT/review/evidence/traceability.md" <<'EOF'
# SAD Traceability Evidence

> Generated only after scope approval and after document/code evidence phases.

| Source requirement / constraint | SAD element | Implementation evidence | Status | Gap / conflict |
|---|---|---|---|---|
| | | | | |

## Reverse Traceability Gaps

- `<to be generated>`

## UMD/KMD Boundary Gaps

- `<to be generated>`

## Evidence Limitations

- `<to be generated>`
EOF
fi

if create_if_missing "$ROOT/review/findings/findings.md"; then
cat > "$ROOT/review/findings/findings.md" <<'EOF'
# SAD Review Findings

> Generated only by the `sad-final-reviewer` after all approved evidence phases are complete.

No findings generated yet.
EOF
fi

if create_if_missing "$ROOT/review/reports/sad-review-report.md"; then
cat > "$ROOT/review/reports/sad-review-report.md" <<'EOF'
# SAD Review Report

**Status:** `NOT STARTED`

## 1. Review Scope and Baselines

`<generated after approved review>`

## 2. Coverage and Limitations

`<generated after approved review>`

## 3. Executive Summary

`<generated after approved review>`

## 4. Checklist Results

| ID | Review question | Result | Note / Jira |
|---|---|---|---|
| SAD-01 | Software components, responsibilities, boundaries, relationships, and external/reused elements | | |
| SAD-02 | Component/external interfaces, data/control flow, direction, and constraints | | |
| SAD-03 | Component behavior/interactions, modes, startup/shutdown, error/recovery, concurrency | | |
| SAD-04 | Requirement allocation and bidirectional traceability | | |
| SAD-05 | Semantic and cross-view consistency | | |
| SAD-06 | Quality characteristics, timing/performance, resource usage | | |
| SAD-07 | Architecture decisions, feasibility, rationale, assumptions, risks, negative impacts | | |
| SAD-08 | Reuse/alternative/reference architecture suitability rationale | | |
| SAD-09 | Planning/estimate impact and PM communication | | |

**Checklist result:** `<Pass / Fail>`

## 5. Findings Summary

`<generated after approved review>`

## 6. Detailed Findings

`<generated after approved review>`

## 7. Traceability Gaps

`<generated after approved review>`

## 8. UMD/KMD Boundary Assessment

`<generated after approved review>`

## 9. Decisions Required

`<generated after approved review>`

## 10. Suggested Next Actions

`<generated after approved review>`
EOF
fi

# -----------------------------------------------------------------------------
# Validate expected input/source layout without modifying it
# -----------------------------------------------------------------------------
required_paths=(
  "$ROOT/review-input/sad/umd-kmd-sad.md"
  "$ROOT/review-input/checklist/sad-review-checklist.md"
  "$ROOT/review-input/guideline/sad-writing-guideline.md"
  "$ROOT/source/bos-umd"
  "$ROOT/source/bos-kmd"
)

missing=0
for p in "${required_paths[@]}"; do
  if [[ -e "$p" ]]; then
    log "Found: ${p#$ROOT/}"
  else
    warn "Missing expected input/source: ${p#$ROOT/}"
    missing=1
  fi
done

log "Generated SAD review workflow under: $ROOT"
if [[ -d "$BACKUP_DIR" ]]; then
  log "Backups of overwritten control files: $BACKUP_DIR"
fi

printf '\nNext prompt for Codex:\n\n'
printf '%s\n' 'Review the UMD/KMD SAD in this workspace.'
printf '%s\n' 'Follow AGENTS.md and use the sad-review-orchestrator workflow.'
printf '%s\n' 'First propose the effective review scope and wait for my explicit approval.'
printf '%s\n' 'Do not produce findings before I approve the scope.'

if [[ "$missing" -ne 0 ]]; then
  printf '\nSetup completed with warnings. Add the missing inputs/sources before starting the review.\n'
fi
