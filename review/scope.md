# SAD Review Scope — Version 2

**Status:** `APPROVED`

- Prepared: 2026-10-07 (Asia/Ho_Chi_Minh).
- Review mode: Full SAD review plus SAD-to-implementation alignment, with independent interface reviews.
- Approval statement for version 2: “Approved. Lock exactly this scope.” Received from the user on 2026-10-07 (Asia/Ho_Chi_Minh).
- This approved scope implements the user's interface-review request. The earlier approval “Approved. Use exactly this scope.” applies only to version 1; version 2 has the separate approval recorded above.
- Before version 2 approval, only this scope record is updated. No new findings, checklist outcomes, or interface review files are generated.
- Preparatory reading of the complete SAD, checklist, and guideline was explicitly requested by the user. Repository preparation is limited to structure and baseline inspection; substantive implementation analysis for this revised review starts after approval.

## Target SAD

- File: `review-input/sad/umd-kmd-sad.md`.
- Revision: 0.1, September 15, 2026, Initial Version.
- Status metadata: the supplied SAD shows its associated writing ticket as In Progress; this is not independently verified publication/approval status.
- SHA-256: `87d325a8d5cefbfa58e84b369bd8cb4f79e7fe81663203ae6165c954f3afc6ec`.
- Coverage includes Overview, Static View, Interface Description, Dynamic View, and preserved architecture diagrams.

## Controlled Review Criteria

- Checklist: `review-input/checklist/sad-review-checklist.md`, exported 2026-10-07; supplied status `unknown`.
- Checklist SHA-256: `23ec05c042c527e201c0c40edefb473293f1aafd679ccaafe11405b8e45baa36`.
- Guideline: `review-input/guideline/sad-writing-guideline.md`, snapshot 2026-10-07.
- Guideline SHA-256: `9723cd4f102bb2c4fd6bf03ae581fa79b800ccd056486b1c82ae283550927620`.
- Apply `AGENTS.md` and the orchestrator, document-reviewer, code-evidence, traceability-reviewer, and final-reviewer skills under `.codex/skills/`, subject to the explicit user instructions below.
- Additional controlled references: none. External links in the supplied inputs are not automatically added to scope.
- Controlled SRS: not supplied or included.

## Implementation Baselines

| Repository | Current branch | Full HEAD commit | Worktree |
|---|---|---|---|
| `source/bos-umd/` | `develop` | `86e0ab17209d7af8f741ac34c158ebbf71612ea4` | Clean, including untracked files |
| `source/bos-kmd/` | `develop` | `12d235aeedb8aa55ede24927c9e09f88c8f278c4` | Clean, including untracked files |

Both HEADs match their local `refs/heads/develop`. No fetch was performed. These are pinned local baselines, not a claim about the latest remote state or deployed binaries. Relevant configuration-dependent paths will be distinguished; build defaults will not be treated as deployed or intended architecture.

## Independent Interface Coverage and Outputs

| Interface | SAD operations to review | Required standalone output |
|---|---|---|
| Cluster | `Cluster()` and its construction sequence | `review/interfaces/01-cluster.md` |
| Device Memory Access | `write_to_device()`, `read_from_device()` | `review/interfaces/02-device-memory-access.md` |
| Device Register Access | `write_to_device_reg()`, `read_from_device_reg()` | `review/interfaces/03-device-register-access.md` |
| Multicast Write | `noc_multicast_write()` | `review/interfaces/04-multicast-write.md` |
| TLB Configuration | `get_static_tlb_window()` | `review/interfaces/05-tlb-configuration.md` |

The names above identify the supplied SAD's interface scope; no source correspondence or compliance conclusion is implied.

Each interface file must contain:

1. Interface scope and pinned document/repository baselines.
2. SAD contract with precise references and preserved technical wording.
3. UMD implementation evidence with file, symbol, and line references.
4. KMD implementation evidence, explicitly distinguishing direct participation, supporting services, and unestablished correspondence.
5. Traceability and its limitations, including both directions where controlled evidence allows.
6. The complete SAD-01 through SAD-09 checklist, with an independently justified result per item and notes for Fail, N/A, or the user-required Blocked exception.
7. Findings with criterion, applicability, direct evidence, impact, and classification.
8. Decisions required and unresolved evidence.
9. Final interface result, with assessed compliance and blocked coverage separately visible.

Detailed interface reviews will remain in these five separate files. Shared evidence references may support each file but will not replace its contract, reasoning, full checklist, findings, or final result. A cross-cutting concern will be applied to an interface only when its applicability to that interface is demonstrated.

## Review Criteria and Questions

Every interface is reviewed against all nine checklist questions, including applicable component definition, interfaces, behavior, requirements allocation, semantic/internal consistency, quality/constraints, feasibility/decisions, reuse/alternatives, and planning impact.

The review explicitly checks:

- Whether UMD and KMD are actually modeled as separate software components, including identities, responsibilities, relationships, design scope, and any justified black-box treatment.
- The UMD/KMD boundary: provided/required contracts, device selection, operation and data direction, resource ownership, lifecycle, errors, and concurrency where applicable.
- Consistency across Overview, Static View, Interface Description, and Dynamic View, including preserved diagrams.
- SAD-to-bos-umd consistency and SAD-to-bos-kmd consistency as separate comparisons.
- Both supporting alignment and contradictions; code behavior cannot establish intended requirements or architecture.
- Interface-specific evidence and applicability rather than mechanically copying prior aggregate results into all interface checklists.

## Result Rules and Explicit User Overrides

- Normal checklist result vocabulary is `Pass / Fail / N/A`.
- **SAD-04 exception:** use `Blocked` when controlled SRS evidence is unavailable. This explicit user instruction overrides the checklist/final-reviewer skill's otherwise three-value vocabulary and the prior review's missing-evidence-to-Fail treatment. Include the dependency and coverage limitation; do not substitute invented requirements or a false N/A.
- **SAD-09:** do not automatically assign Fail because PM/planning records are outside the supplied scope. Assess applicability and any directly available SAD evidence separately from unreviewed external process evidence. Record missing external evidence and required decisions without asserting that evaluation or communication never occurred. Any Fail needs a specific applicable controlled obligation and direct in-scope evidence; N/A needs an explicit scope/applicability justification.
- For every item, distinguish unavailable evidence from a demonstrated contradiction or omission under an applicable rule. Do not infer universal applicability from code presence, examples, or engineering preferences.
- Use N/A only with a stated reason. Lack of evidence alone is not proof that a criterion does not apply.
- Final interface results must show any blocked requirements coverage separately. A blocked dependency does not become a formal finding or an automatic Fail; acceptance must not be reported as complete while required coverage remains blocked.
- No outcome is assigned in this scope. Final judgments are made only after approval and evidence collection.

## Evidence and Formal Finding Controls

Use the workspace source-authority order, with explicit user-approved scope first. Identify conflicts rather than silently selecting a source.

Keep these evidence classes distinguishable:

- `CONTROLLED RULE`
- `DOCUMENT FACT`
- `IMPLEMENTATION EVIDENCE`
- `ASSUMPTION`
- `REVIEW OBSERVATION`
- `OPEN ISSUE`

A formal finding requires a specific applicable checklist/guideline criterion, available target evidence, a directly demonstrated gap or contradiction, and no invented requirement. Otherwise classify the concern as Review observation, Implementation drift, Missing evidence, or Decision required, as appropriate. Do not invent missing requirements, architecture, behavior, interfaces, thresholds, alternatives, or rationale. Explain uncertainty and evidence limits.

## Missing / Unavailable Evidence and Coverage Limits

- No controlled SRS/requirements baseline is supplied. Apply the SAD-04 Blocked rule and retain the limitation on requirements-semantic consistency.
- PM/planning records and Review Minutes are not supplied as controlled review inputs; external process completion is not inferred.
- No additional SUD, architecture-reference, firmware, hardware-specification, deployment, or runtime-evidence artifact is approved.
- Checklist status metadata remains `unknown`; the approved scope selects the supplied snapshot without changing that status.
- Referenced artifacts or diagram images can only be assessed when preserved in the approved inputs. Absent assets are reported as unavailable; their contents are not invented.
- Prior reviewer-generated artifacts are working records, not controlled requirements or architecture. They may be reused only after checking their baselines and underlying evidence; prior outcomes are reassessed under version 2.

## Exclusions and Read-only Boundary

- No modification of `review-input/sad/umd-kmd-sad.md`, the checklist, the guideline, `source/bos-umd/**`, or `source/bos-kmd/**`.
- No architecture authoring, source fixes, branch/commit changes, builds, runtime/hardware testing, or deployment.
- No external publication, ticket creation, or messages to others.
- No unapproved controlled references or remote baseline changes.

Writing review artifacts under `review/` is the requested output activity and is permitted after the scope gate; it does not authorize modification of the reviewed inputs.

## Supporting Canonical Outputs

After approval, maintain these workflow artifacts consistently with the five independent interface reviews:

- `review/scope.md` — approved version 2 and approval provenance.
- `review/evidence/document-evidence.md`
- `review/evidence/umd-code-evidence.md`
- `review/evidence/kmd-code-evidence.md`
- `review/evidence/traceability.md`
- `review/findings/findings.md` — findings index and cross-cutting records, linking interface-specific detail.
- `review/reports/sad-review-report.md` — overall coverage/results summary linking the five interface files.

The findings index and overall report will not combine or replace the detailed interface reviews.

## Approval Gate and Prior Review Provenance

- Version 1 was approved on 2026-10-07 with “Approved. Use exactly this scope.” It used the same input hashes and repository commits, and produced the existing aggregate evidence/findings/report.
- Version 2 changes the output structure and result rules. Existing aggregate artifacts remain records of version 1 until reassessed and updated; their prior outcomes are not results of version 2.
- The scope proposal was shown before approval. The user subsequently approved version 2 and requested a scope lock before review.
- Execution order explicitly authorized by the user: create and verify `review/scope.lock`; complete the five independent interface reviews; then generate the six supporting evidence/findings/report files listed above.
- `review/scope.lock` records the approved scope hash, controlled-input hashes, repository branches/commits, and authorized output paths. Verify it before analysis and at completion; a mismatch requires stopping affected work without silently updating the lock.
- Any later change to controlled inputs, baselines, references, criteria, or exclusions requires renewed scope approval.
