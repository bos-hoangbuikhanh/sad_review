# UMD/KMD SAD — All Diagram Reviews

This package reviews **all six diagrams** in [umd-kmd-sad.md](../../review-input/sad/umd-kmd-sad.md): one Static View and five Dynamic Views. Each detailed review is a separate Markdown file and contains the exact original Mermaid block, applicable controlled criteria, document facts, separate UMD/KMD implementation evidence, findings or missing evidence, decisions, traceability limits and a final diagram assessment.

These are reviews of the supplied diagrams and their surrounding contracts. They do not author replacement architecture or merge the five detailed interface reviews.

## Diagram inventory and results

| No. | Diagram | Original Mermaid lines | Review file | Assessed result and basis |
|---|---|---|---|---|
| 00 | Static View | SAD:35–48 | [00-static-view.md](00-static-view.md) | Fail for component-definition coverage in the surrounding model; existing SAD-F-001. UMD and KMD are separate nodes, but separate component specifications/design scopes are incomplete. |
| 01 | Cluster Construction | SAD:188–202 | [01-cluster-construction.md](01-cluster-construction.md) | SAD-03 Fail; existing Major SAD-F-102. Open success does not define the promised initialization behavior/completion. |
| 02 | Device Memory Write/Read | SAD:206–220 | [02-device-memory-access.md](02-device-memory-access.md) | SAD-03 Fail; existing Major SAD-F-202. Payload behavior is missing; SAD-F-205 separately records setup-time mapping drift. |
| 03 | Device Register Write/Read | SAD:224–238 | [03-device-register-access.md](03-device-register-access.md) | SAD-03 Fail; existing Major SAD-F-302. Register transaction behavior is missing; SAD-F-305 separately records mapping drift. |
| 04 | Multicast Write | SAD:242–256 | [04-multicast-write.md](04-multicast-write.md) | SAD-03 Fail; existing Major SAD-F-402. Destination/payload processing and completion are unspecified; exact source API binding remains unresolved. |
| 05 | TLB Configuration | SAD:260–269 | [05-tlb-configuration.md](05-tlb-configuration.md) | SAD-03 retains Fail for insufficient evidence under TLB-DYNAMIC. No formal dynamic-view violation is established; a userspace-only getter is not inherently wrong. |

The four formal Dynamic View findings are SAD-F-102/202/302/402. Their two sequence-alignment drift records are SAD-F-205/305. The static review applies the existing shared SAD-F-001. API-binding differences, contract issues and observations are identified separately where relevant; they are not new diagram findings or additions to the canonical finding count. TLB-DYNAMIC remains Missing evidence, not a manufactured formal violation.

## Scope, output authorization and baseline

The review uses the existing [approved scope version 2](../scope.md) and [scope lock](../scope.lock). The user's subsequent instruction explicitly requests Markdown output for all diagrams under `/home/hoangb/BOS/sad-review/review/diagram`. That instruction authorizes this supplemental output location. The original lock's output list records the earlier deliverables; it has not been silently rewritten to claim these seven supplemental files were in that earlier list.

No target, controlled criterion, repository baseline, reference artifact, coverage requirement or exclusion has been changed. All six diagrams were already within the approved full SAD review. Only the requested output packaging is added here.

| Baseline item | Recorded value |
|---|---|
| SAD | `review-input/sad/umd-kmd-sad.md`, revision 0.1, September 15, 2026 |
| SAD SHA-256 | `87d325a8d5cefbfa58e84b369bd8cb4f79e7fe81663203ae6165c954f3afc6ec` |
| Checklist | `review-input/checklist/sad-review-checklist.md`, exported 2026-10-07, supplied status `unknown` |
| Checklist SHA-256 | `23ec05c042c527e201c0c40edefb473293f1aafd679ccaafe11405b8e45baa36` |
| Guideline | `review-input/guideline/sad-writing-guideline.md`, approved snapshot |
| Guideline SHA-256 | `9723cd4f102bb2c4fd6bf03ae581fa79b800ccd056486b1c82ae283550927620` |
| UMD | `source/bos-umd`, `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4` |
| KMD | `source/bos-kmd`, `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4` |
| Controlled SRS / additional references | Not supplied / none |

The UMD evidence follows the checked-in BOS/Blackholeplus selection; the KMD Makefile defines BLACKHOLEPLUS. Source defaults are not claims about intended or deployed architecture. Precise source locations and symbols are recorded in the individual reviews and shared ledgers.

## Controlled criteria and evidence interpretation

- **CONTROLLED RULE:** SAD-01 addresses component definitions and boundaries; SAD-02 addresses interface semantics; SAD-03 addresses applicable behavior; SAD-05 addresses cross-view consistency. The [guideline](../../review-input/guideline/sad-writing-guideline.md):122–155,174–198,217–259 supplies the applicable detail.
- **DOCUMENT FACT:** The copied Mermaid blocks, neighboring interface tables, Overview and other views are the target evidence. A dependency arrow does not itself define a payload protocol or a kernel call on every invocation.
- **IMPLEMENTATION EVIDENCE:** Pinned UMD and KMD observations are kept separate. Matching code is supporting alignment; differing code is not automatically the intended architecture.
- **REVIEW OBSERVATION:** Notation, abstraction or terminology questions are distinguished from formal violations. No extra hardware node, exact internal module layout or reverse arrow is mandated without a controlled basis.
- **OPEN ISSUE:** The owner must resolve intended readiness/completion, mapping lifetime/ownership, supported variants and exact multicast/TLB bindings. Applicable state/error/recovery/concurrency scenarios cannot be invented from current source.
- **ASSUMPTION:** No assumption is used to supply a requirement, missing architecture or formal finding.

Guideline §3.2 requires meaningful component processing and interactions sufficient for applicable verification. Activity Diagrams are recommended; their absence alone is not a failure. Sequence detail depends on the significance of the scenario. A static KMD dependency does not require KMD participation in a getter using an existing userspace mapping.

Memory and register alignment requires separating mapping setup from payload access. In the inspected implementation, PCIDevice construction establishes BAR mappings, ordinary access methods reuse them, and KMD mmap establishes VMAs. DRAM ATU-window changes are distinct from a new host mmap. These observations retain the existing drift classification and leave the intended lifecycle to the architecture owner.

## Relationship to the complete SAD review

The diagram files contain only directly relevant assessments and related context. They do not mechanically assign all nine criteria to each drawing. The full independent SAD-01 through SAD-09 checklists remain in:

- [Cluster interface review](../interfaces/01-cluster.md)
- [Device Memory Access interface review](../interfaces/02-device-memory-access.md)
- [Device Register Access interface review](../interfaces/03-device-register-access.md)
- [Multicast Write interface review](../interfaces/04-multicast-write.md)
- [TLB Configuration interface review](../interfaces/05-tlb-configuration.md)

Shared supporting artifacts remain [document evidence](../evidence/document-evidence.md), [UMD evidence](../evidence/umd-code-evidence.md), [KMD evidence](../evidence/kmd-code-evidence.md), [traceability](../evidence/traceability.md), [findings index](../findings/findings.md) and the [SAD review report](../reports/sad-review-report.md). Existing IDs, classifications, interface checklist outcomes and global finding counts are preserved.

SAD-04 remains **Blocked** because the controlled SRS is unavailable; both requirement allocation and reverse justification are unassessed. Requirements-semantic consistency is not passed by any diagram-level agreement. SAD-09 remains **N/A within the approved external PM/planning assessment scope**, without inferring no planning impact or failed communication. Document-level analysis, feasibility and reuse results cannot be determined from the mere presence or absence of a diagram.

## Verification and limitations

**Verification: Passed.** All six original Mermaid blocks are reproduced exactly, in six separate review files. All seven requested-package Markdown files exist; required review sections, pinned commits, existing finding IDs and evidence IDs were checked. All 153 local links, 74 finding-ID references and 105 implementation-evidence references resolve. File existence and line bounds were checked for 38 fully qualified source citations and the linked source locations. Controlled-document citation bounds and Markdown code-fence balance were also checked.

The original scope lock and its approved scope/input hashes still match. Both repositories remain on the pinned develop commits with clean worktrees, including untracked files. This package adds only the explicitly requested `review/diagram/` outputs; the original scope/lock, protected inputs/source and canonical interface findings/results remain unchanged. These checks establish package integrity, not runtime or Mermaid-renderer validation.

Read-only static review; no SAD, checklist, guideline or source edit, no build, hardware/runtime, timing, fault, concurrency or deployed-ABI test, and no external artifact, ticket or message. Original Mermaid text is preserved exactly; no renderer execution or hardware behavior is claimed. The package records review conclusions and open decisions, not stakeholder approval or corrected architecture.
