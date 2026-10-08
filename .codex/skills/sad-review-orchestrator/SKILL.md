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
