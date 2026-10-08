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
