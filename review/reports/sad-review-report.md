# SAD Review Report — Approved Scope Version 2

Completed: 2026-10-08 (Asia/Ho_Chi_Minh). **Overall assessed result: Fail. Controlled-requirements coverage: Blocked.** The five independent interface reviews and all requested shared artifacts are complete. This is completion of the approved review work, not SAD acceptance, runtime validation or stakeholder approval.

Sixteen evidence-backed formal findings establish component/contract/behavior/analysis gaps and local table inconsistencies. Six separate implementation-drift records require an owner decision about intended behavior. Missing SRS and out-of-scope PM records do not cause the assessed Fail result. Every interface has a complete SAD-01–SAD-09 checklist and its own scope, contract, UMD evidence, KMD evidence, traceability, findings, decisions and final result.

## Review scope and pinned baselines

The user approved scope version 2 on 2026-10-07: “Approved. Lock exactly this scope.” [scope.md](../scope.md) is unchanged and [scope.lock](../scope.lock) records its hash, the three controlled-input hashes, both repository baselines and the authorized outputs. The lock was created and verified before substantive review, verified after the five interfaces were completed, and rechecked on continuation. Completion verification is recorded below.

| Item | Effective baseline |
|---|---|
| Target SAD | `review-input/sad/umd-kmd-sad.md`, revision 0.1, September 15, 2026 |
| Controlled checklist | `review-input/checklist/sad-review-checklist.md`, exported 2026-10-07, supplied status `unknown` |
| Controlled guideline | `review-input/guideline/sad-writing-guideline.md`, approved 2026-10-07 snapshot |
| UMD implementation evidence | `source/bos-umd`, `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4` |
| KMD implementation evidence | `source/bos-kmd`, `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4` |
| Additional controlled references | None; no controlled SRS |
| Mode | Full SAD review plus SAD-to-implementation alignment, independently for the five named interfaces |

Both repository HEADs match their local develop references; no fetch or claim about remote/latest/deployed state is involved. Exact hashes are preserved in the lock rather than silently refreshed. The approved scope controls the SAD-04 Blocked exception, scoped SAD-09 treatment, output order and exclusion of external tickets/messages. No scope expansion occurred.

The SAD review skills under `.codex/skills/` were applied through orchestration, document evidence, code evidence, traceability and final judgment phases, subject to the explicit user overrides. Shared outputs were generated only after all five interface reviews were complete. Earlier aggregate working outcomes were reassessed; this report supersedes the version-1 report.

## Coverage and independent interface results

Overview, Static View, all five Interface Descriptions and all five Dynamic Views were checked, including all six preserved Mermaid diagrams. UMD/KMD component modeling, both sides of the boundary and each SAD-to-repository comparison were assessed explicitly. Detailed reviews remain in separate files:

| Interface | SAD contract / flow lines | Assessed result | Requirements coverage | Detailed review |
|---|---|---|---|---|
| Cluster | 52–63 / 186–202 | Fail | Blocked | [01-cluster.md](../interfaces/01-cluster.md) |
| Device Memory Access | 65–100 / 204–220 | Fail | Blocked | [02-device-memory-access.md](../interfaces/02-device-memory-access.md) |
| Device Register Access | 102–137 / 222–238 | Fail | Blocked | [03-device-register-access.md](../interfaces/03-device-register-access.md) |
| Multicast Write | 139–160 / 240–256 | Fail | Blocked | [04-multicast-write.md](../interfaces/04-multicast-write.md) |
| TLB Configuration | 162–180 / 258–269 | Fail | Blocked | [05-tlb-configuration.md](../interfaces/05-tlb-configuration.md) |

The code review follows the checked-in UMD `EAGLE_AS_TT=ON` BOS/Blackholeplus chain and KMD `BLACKHOLEPLUS` selection. Generic branches were inspected for selection/correspondence, not exhaustively validated. These defaults are evidence of the repository configuration, not intended/deployed architecture.

## Checklist results

Questions below reproduce the controlled checklist. All Fail/N/A/Blocked entries have explicit supporting notes in their independent reviews; the common bases and qualifications follow this table. An overall Fail is supported by demonstrated in-scope gaps, while unavailable requirements remain separately Blocked.

| ID | Controlled question | Cluster | Memory | Register | Multicast | TLB | Overall assessed coverage |
|---|---|---|---|---|---|---|---|
| SAD-01 | Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined? | Fail | Fail | Fail | Fail | Fail | Fail |
| SAD-02 | Are component and external interfaces defined with their data/control flow, direction, and relevant constraints? | Fail | Fail | Fail | Fail | Fail | Fail |
| SAD-03 | Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency? | Fail | Fail | Fail | Fail | Fail | Fail |
| SAD-04 | Are the software requirements appropriately allocated to components with bidirectional traceability? | Blocked | Blocked | Blocked | Blocked | Blocked | Blocked |
| SAD-05 | Is the architecture semantically consistent with the software requirements and internally consistent across its views? | Pass (internal-view portion only) | Fail | Fail | Fail | Fail | Fail |
| SAD-06 | Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage? | Fail | Fail | Fail | Fail | Fail | Fail |
| SAD-07 | Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable? | Fail | Fail | Fail | Fail | Fail | Fail |
| SAD-08 | Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded? | Fail | Fail | Fail | Fail | Fail | Fail |
| SAD-09 | Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable? | N/A | N/A | N/A | N/A | N/A | N/A (scope-qualified) |

| Checklist basis | Explanation and evidence |
|---|---|
| SAD-01 | SAD-F-001 / DOC-01: separate UMD/KMD nodes exist, but the component identities, design scopes and required/provided responsibilities are incomplete (SAD:20–48; GL:135,146–151). |
| SAD-02 | SAD-F-101/201/301/401/501 / DOC-02: each interface's caller/boundary contract lacks material semantics or possible outcomes required by GL:155,217–224. Code drift remains a separate class. |
| SAD-03 | SAD-F-102/202/302/402 / DOC-03: Cluster initialization and the three payload operations lack meaningful processing/completion evidence (GL:238,240,255). TLB is an evidence-acceptance Fail under TLB-DYNAMIC: its simple success flow exists, but mapping-state/lifetime and applicable verification coverage are unestablished. No formal TLB dynamic-view violation, extra KMD message or mandatory Activity Diagram is invented. |
| SAD-04 | No controlled SRS or allocation baseline exists in scope. Both directions of requirement traceability are Blocked under the explicit user instruction. This is not a formal requirement failure. |
| SAD-05 | SAD-F-203/303/403/503 / DOC-05: direct local table inconsistencies in memory, register, multicast and TLB. Cluster's Pass covers basic internal-view consistency only; requirements-semantic consistency is NOT passed and remains unassessed for all five interfaces. The compound controlled criterion is not reported as fully accepted for Cluster. |
| SAD-06 | SAD-F-002 / DOC-06: GL:294 explicitly requires a quality/constraint analysis result and rationale. The complete SAD contains none, including no explained N/A. No performance/resource threshold or measured violation is invented. |
| SAD-07 | SAD-F-003 / DOC-07: GL:294 explicitly requires a feasibility result and rationale; none is recorded. A common architecture analysis could cover all five interfaces. |
| SAD-08 | DOC-08 and the five REUSE issues: Fail to establish acceptance from the supplied evidence because applicability/suitability or reasoned N/A is unresolved. This is missing evidence, not a formal reuse/alternative-selection violation. No artificial alternative is required. |
| SAD-09 | DOC-09 and the five PLAN decisions: N/A is limited to external planning/PM process assessment under the approved inputs. No interface-specific significant planning decision is established; the document lacks evaluation/no-impact text, but that absence does not prove external evaluation/communication failed or that impact is zero. Applicability remains an owner decision. |

The 45 interface checklist entries comprise **34 Fail, 5 Blocked, 5 N/A and 1 bounded Pass**. These are checklist cells, not counts of independent defects. The single Pass must always retain its internal-view-only qualification. Evidence-acceptance Fail and formal violation are deliberately distinguished, particularly for SAD-08 and TLB SAD-03.

## Dynamic View review

The focused Dynamic View review confirms **four existing Major process/guideline findings, two existing sequence-alignment drift records, and one missing-evidence issue for TLB behavior**. These are a subset of the existing register, not additional findings. Detailed assessments remain in the five independent interface files.

**CONTROLLED RULE:** SAD-03 (CL:19,31) and [Guideline §3.2](../../review-input/guideline/sad-writing-guideline.md):238–259 require component processing and inter-component behavior sufficient for applicable verification. Activity Diagrams are recommended; their absence alone is not a failure. Sequence-diagram applicability depends on the significance of interactions and verification needs. No unreferenced or out-of-scope SUD is assumed to supply missing behavior.

| Interface / SAD location | DOCUMENT FACT — depicted sequence | Dynamic View assessment | Existing record |
|---|---|---|---|
| Cluster / SAD:186–202 | `cluster()` → KMD `open()` → success → Cluster object | Major initialization processing and the meaning of initialized completion are undefined. SAD-03: Fail. | [SAD-F-102 — Major](../interfaces/01-cluster.md) |
| Memory access / SAD:204–220 | Read/write call → KMD `mmap()` → success → return | Payload movement and its observable completion are not described. SAD-03: Fail. Mapping timing also differs from the inspected implementation. | [SAD-F-202 — Major; SAD-F-205 — Implementation drift](../interfaces/02-device-memory-access.md) |
| Register access / SAD:222–238 | Register call → KMD `mmap()` → success → return | Register transaction processing and completion are not described. SAD-03: Fail. Mapping timing also differs from the inspected implementation. | [SAD-F-302 — Major; SAD-F-305 — Implementation drift](../interfaces/03-device-register-access.md) |
| Multicast / SAD:240–256 | `noc_multicast_write()` → KMD `mmap()` → success → return | Destination/payload processing and completion are unspecified. SAD-03: Fail. No exact source binding is established, so a replacement implementation sequence is not asserted. | [SAD-F-402 — Major](../interfaces/04-multicast-write.md) |
| TLB retrieval / SAD:258–269 | `get_static_tlb_window()` → returned window, within userspace | The simple success sequence exists. Mapping-state/lifetime and applicable verification coverage remain unestablished. SAD-03 retains an evidence-acceptance Fail; no formal dynamic-view violation is established. KMD absence from this getter is not itself a defect. | [TLB-DYNAMIC — Missing evidence](../interfaces/05-tlb-configuration.md) |

**IMPLEMENTATION EVIDENCE — UMD:** The inspected BOS path creates persistent BAR mappings during PCIDevice construction (`source/bos-umd/device/blackholeplus/pci_device.cpp:193–308`). Ordinary memory and register operations reuse them for payload access (UMD-EV-004/006/007). This differs from the SAD sequences placing `mmap()` inside each access. Device ATU-window changes are distinct from host mapping creation. The observations establish drift, not which artifact should change.

**IMPLEMENTATION EVIDENCE — KMD:** `source/bos-kmd/memory.c:1186–1237` establishes the selected BAR/TLB/DMA mapping; it does not perform the application's read/write payload operation (KMD-EV-005). Setup participation is distinct from a kernel call on every UMD access. The source evidence does not supply intended completion, error, concurrency or lifetime contracts.

**OPEN ISSUES / decisions required:** Resolve when mapping setup occurs and who owns its lifetime; what successful construction or transfer completion guarantees; which state, error/recovery and concurrency scenarios apply; and the intended multicast/TLB API bindings. These decisions must precede any proposed replacement sequence. Source behavior is supporting evidence and cannot determine intended architecture by itself.

**Traceability and limits:** [Document evidence DOC-03](../evidence/document-evidence.md) and [traceability](../evidence/traceability.md) retain the rule-to-document and SAD-to-code mappings. Requirement-based scenario completeness remains Blocked without a controlled SRS. The focused review introduces no new architecture, thresholds, controlled inputs or runtime results; existing checklist outcomes and finding totals remain unchanged.

## Findings summary

The [findings index](../findings/findings.md) contains **22 unique records: 16 formal Process / guideline findings (12 Major, 4 Minor) and 6 Implementation drift records with severity unassigned**. No Critical finding was established. Three shared findings are applied independently to all interfaces and counted once, avoiding inflation from their repeated local records.

| Scope | Formal findings | Implementation drift | Main issue |
|---|---|---|---|
| Shared architecture | SAD-F-001–003: 3 Major | None | Component/design-scope definition; required quality/constraint analysis; required feasibility result/rationale |
| Cluster | SAD-F-101–102: 2 Major | None | Initialization completion/boundary contract and meaningful startup behavior |
| Memory | SAD-F-201–203: 2 Major, 1 Minor | SAD-F-204–205 | Caller/boundary contract, payload flow, read-size wording; source signatures and setup-time mapping |
| Register | SAD-F-301–303: 2 Major, 1 Minor | SAD-F-304–305 | Caller semantics, transaction flow, memory labels in register table; signatures/alignment and persistent mappings |
| Multicast | SAD-F-401–403: 2 Major, 1 Minor | SAD-F-404 | Destination/operation contract, payload behavior, table-domain errors; no exact API binding in bounded search |
| TLB | SAD-F-501/503: 1 Major, 1 Minor | SAD-F-504 | Target/result/lifetime contract and wrong output label; no exact getter binding in bounded search |

Formal findings rely on applicable checklist/guideline rules and direct document evidence. Implementation existence is not proof of architecture suitability; implementation drift does not select code as the intended design. Missing SRS, external planning evidence, variant/ABI questions and engineering observations are separately indexed as open issues. All findings remain open; this review performed no corrective edits.

## Detailed findings

Complete finding records, including rule, applicability, direct evidence, impact, suggested correction and traceability, remain in the five linked interface files. The [index](../findings/findings.md) links each record precisely and contains the three shared cross-cutting records. This report does not merge detailed interface reviews.

[Cluster](../interfaces/01-cluster.md) contains SAD-F-001–003 and 101–102. [Memory](../interfaces/02-device-memory-access.md) contains the shared records and 201–205. [Registers](../interfaces/03-device-register-access.md) contains the shared records and 301–305. [Multicast](../interfaces/04-multicast-write.md) contains the shared records and 401–404. [TLB](../interfaces/05-tlb-configuration.md) contains the shared records and 501/503/504; there is no invented SAD-F-502 dynamic-view finding.

## UMD/KMD boundary and implementation alignment

**UMD and KMD are modeled as distinct diagram nodes/participants, but are not separately specified software components with complete identities, design scopes and contracts.** Only SWC UMD has an Overview, its ID is blank, and KMD lacks a separate overview/design-scope designation (SAD:20–48). A conditional black-box exemption cannot be assumed. That finding does not require arbitrary internal unit names or a kernel call for every UMD operation.

Positive evidence is retained: Cluster() is callable through a defaulted options argument, and the inspected device-info/mapping-query commands, field order and mapping IDs agree statically between UMD and KMD. KMD supplies device nodes, identity, mapping setup and file/device resource lifetime. These facts support parts of the documented dependency (UMD-EV-002–004/013; KMD-EV-002–005/010), without proving a full compatibility policy or deployed behavior.

For memory and register access, source establishes mappings during PCIDevice construction and later reuses BAR resources. KMD mmap creates VMAs; UMD performs the inspected payload operations. The SAD access sequences instead place mmap within each read/write interaction (SAD:204–238; UMD-EV-004/006/007; KMD-EV-005). Host mapping setup and DRAM ATU-window changes are separate operations. The intended flow must be decided before selecting which artifact to change.

The exact names noc_multicast_write and get_static_tlb_window were absent from the bounded search of tracked UMD C/C++ sources. Nearby broadcast and Writer methods were inspected but are not proven equivalents (UMD-EV-008/009). KMD multicast-capable TLB configuration does not provide the missing public payload/getter contract. Conversely, the absence of KMD from an existing-mapping getter sequence is not itself a defect.

The retained optional KMD callbacks under BLACKHOLEPLUS's skipped initialization block are an unresolved support/readiness question (KMD-EV-013), not a reproduced runtime defect. API constant differences similarly do not prove incompatibility. Intended identity/address domains, readiness, resource ownership, error/completion and applicable concurrency remain unresolved boundary decisions; source cannot settle their intended semantics.

## Traceability gaps

[traceability.md](../evidence/traceability.md) maps each documented interface/flow to separate UMD/KMD evidence and records Covered, Partial, Missing, Conflicting or Blocked propositions. The broad access purposes have source counterparts, but exact signatures and mapping timing differ; multicast/TLB exact API bindings remain missing. No percentage of requirements coverage can be computed.

Requirement → component/interface/flow → implementation and architecture → justifying requirement are both Blocked. No controlled requirement IDs, verification conditions or thresholds are supplied. Reverse mapping also leaves discovery/device identity, start/close/readiness, payload routing, multicast destinations and TLB ownership without precise intended SAD allocation. Requirement-semantic consistency remains unassessed even where internal document views agree.

## Decisions required and suggested next actions

1. The architecture owner should define intended UMD/KMD component scopes and the supported build/API variant, then resolve precise caller/kernel contracts and ownership. Cluster readiness/version policy, memory serialization/address model, register width/ordering, multicast binding/destination model and TLB result/mapping lifetime have separate decision IDs in the interface files.
2. Reconcile the four direct table inconsistencies and describe intended initialization/payload behavior. Determine applicable lifecycle/error/concurrency cases; do not import current source behavior as requirements.
3. Supply the shared quality/constraint and feasibility analysis required by GL:294, with applicability and rationale. Resolve actual reuse/meaningful alternative applicability without inventing choices. No numeric budget or benchmark is imposed by this review.
4. Resolve each drift record by deciding the intended interface/flow, then selecting the appropriate subsequent SAD and/or implementation correction. No correction was made in this review.
5. If requirements acceptance or external planning-process assessment is wanted later, propose the controlled SRS/records as a scope change first. Current SAD-04 remains Blocked and SAD-09 remains scope-qualified N/A; no new review input or external contact is implicitly authorized.

## Coverage limitations

This is read-only static review. No source/input edit, build, runtime/hardware test, concurrency/fault test, deployed ABI validation, firmware/hardware-specification verification, benchmark or deployment occurred. Source-path selection is configuration-dependent; all alternatives, option combinations and remote topology are not exhaustively verified. The exact-name searches exclude outside wrappers and generated/deployed artifacts. The review does not establish hardware multicast fan-out, register side-effect/atomicity behavior or complete reset/removal safety.

No controlled SRS, additional SUD, Review Minutes or PM/planning records are supplied. Four referenced guideline example images are absent; their contents were not inferred. All preserved target Mermaid diagrams were inspected. Checklist status remains `unknown`; the user's snapshot approval is not substituted for publication/governance approval. No external links were added as evidence, and no ticket, message or stakeholder approval was created.

## Deliverables and completion verification

| Shared artifact | Purpose |
|---|---|
| [document-evidence.md](../evidence/document-evidence.md) | Controlled rule and direct document evidence for all nine criteria |
| [umd-code-evidence.md](../evidence/umd-code-evidence.md) | Pinned UMD implementation evidence and bounded drift candidates |
| [kmd-code-evidence.md](../evidence/kmd-code-evidence.md) | Pinned KMD services, lifetime and support limitations |
| [traceability.md](../evidence/traceability.md) | Both requirement directions and five independent SAD-to-code mappings |
| [findings.md](../findings/findings.md) | Unique finding index, shared records and separate open decisions |
| [sad-review-report.md](sad-review-report.md) | Overall outcomes, coverage and verification |

These support the five independent files linked above; scope.md and scope.lock remain the controlling records. Review artifacts are the only authorized writes.

**Completion verification: Passed on 2026-10-08 (Asia/Ho_Chi_Minh).** All 13 authorized outputs exist. Each interface has the nine exact controlled questions, permitted results with required notes, mandatory sections and a final result. The report matrix agrees with all 45 interface entries; the index contains the same 22 unique findings (34 local occurrences), with consistent classifications/severities. All 335 evidence-ID references resolve; 122 local links resolve, including precise finding locations. File existence and line bounds were checked for 102 fully qualified source citations and 49 code-ledger citations. These are artifact-integrity checks, not runtime tests.

The scope lock's own hash remains `b1896d4d27a21bf9834d22870e5d506f1d2b92d84af8bc0a056eb0f874d67583`. The approved scope and all three controlled-input hashes still match; both repository branches, HEADs and local develop references match the lock, and both worktrees remain clean including untracked files. Protected inputs/source and the approved scope were not modified. No scope expansion or external action occurred.
