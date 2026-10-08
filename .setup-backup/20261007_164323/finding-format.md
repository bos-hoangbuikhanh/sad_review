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
