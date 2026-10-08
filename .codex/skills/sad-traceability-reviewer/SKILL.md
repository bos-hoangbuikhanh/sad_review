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
