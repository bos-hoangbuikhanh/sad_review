---
artifact: SAD Review Checklist
source: Confluence
exported_at: "2026-10-07"
status: "unknown"
---

# SAD Review Checklist

> Use with the related Review Minutes after SAD Architecture Analysis is completed. The checklist verifies that required architecture and analysis evidence is present; it does not replace the Architecture Analysis activity itself.

**Result:** `Pass / Fail / N/A`  
Record a note only for `Fail` or `N/A`. Create a Jira issue when corrective action is required.

| ID | Review question | Result | Note / Jira |
|---|---|---|---|
| SAD-01 | Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined? | `<Pass / Fail / N/A>` | `<Exception, affected element, or Jira key>` |
| SAD-02 | Are component and external interfaces defined with their data/control flow, direction, and relevant constraints? | `<Pass / Fail / N/A>` | `<Exception, affected interface, or Jira key>` |
| SAD-03 | Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency? | `<Pass / Fail / N/A>` | `<Exception, affected scenario, referenced design, or Jira key>` |
| SAD-04 | Are the software requirements appropriately allocated to components with bidirectional traceability? | `<Pass / Fail / N/A>` | `<Exception, affected requirement/component, or Jira key>` |
| SAD-05 | Is the architecture semantically consistent with the software requirements and internally consistent across its views? | `<Pass / Fail / N/A>` | `<Exception, affected requirement/view, or Jira key>` |
| SAD-06 | Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage? | `<Pass / Fail / N/A>` | `<Exception, affected characteristic/constraint, or Jira key>` |
| SAD-07 | Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable? | `<Pass / Fail / N/A>` | `<Exception, affected decision, or Jira key>` |
| SAD-08 | Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded? | `<Pass / Fail / N/A>` | `<Component/alternative, rationale, or N/A>` |
| SAD-09 | Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable? | `<Pass / Fail / N/A>` | `<Planning impact, WBS/project action, or N/A>` |

**Checklist result:** `<Pass / Fail>`

> `Pass` means all checklist items passed or any justified `N/A` was accepted. Any unresolved item shall be recorded in the Review Minutes and tracked in Jira when action is required.
>
> For `SAD-03`, an architecture-level dynamic view may be maintained in the SUD or another controlled artifact only when the SAD clearly references it and it is included in the SAD review scope. Unit-level internal behavior alone is not sufficient.
