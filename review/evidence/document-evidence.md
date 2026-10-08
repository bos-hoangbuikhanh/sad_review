# Document Evidence — Approved Scope Version 2

This ledger consolidates document evidence collected for the five completed independent interface reviews. It does not replace those reviews or assign their final checklist outcomes. [Scope](../scope.md) and [scope lock](../scope.lock) identify the approved snapshots and hashes; final verification is recorded in the [report](../reports/sad-review-report.md).

**SAD:** `review-input/sad/umd-kmd-sad.md`, revision 0.1, September 15, 2026, lines 1–269. **CL:** `review-input/checklist/sad-review-checklist.md`, exported 2026-10-07, status `unknown`. **GL:** `review-input/guideline/sad-writing-guideline.md`, approved 2026-10-07 snapshot. Citation line numbers are one-based. No external link or unapproved reference supplied additional evidence.

`CONTROLLED RULE` identifies checklist/guideline obligations; `DOCUMENT FACT` identifies target content. `OPEN ISSUE` identifies unresolved evidence or applicability. `REVIEW OBSERVATION` does not establish a formal violation. No `ASSUMPTION` is used to supply intended architecture. Implementation evidence is in the separate UMD/KMD ledgers.

## Document and diagram coverage

| Interface | Contract | Dynamic view | Independent review |
|---|---|---|---|
| Cluster | SAD:52–63 | SAD:186–202 | [Cluster](../interfaces/01-cluster.md) |
| Device Memory Access | SAD:65–100 | SAD:204–220 | [Memory](../interfaces/02-device-memory-access.md) |
| Device Register Access | SAD:102–137 | SAD:222–238 | [Registers](../interfaces/03-device-register-access.md) |
| Multicast Write | SAD:139–160 | SAD:240–256 | [Multicast](../interfaces/04-multicast-write.md) |
| TLB Configuration | SAD:162–180 | SAD:258–269 | [TLB](../interfaces/05-tlb-configuration.md) |

The complete target, including Overview (20–29), static Mermaid graph (35–48), all five interface tables and all five sequence diagrams, was inspected. All six preserved Mermaid diagrams are architecture evidence. No content is inferred beyond their text. Four example-image references in GL:127,205,267,275 have no preserved local assets; their unseen contents were not reconstructed. The target supplies no separately controlled SUD/dynamic artifact.

SAD:13 records a related ticket as In Progress, and SAD:15–16 has source/hash placeholders. Those are document facts, not verified publication status. The review uses the user-approved snapshot and pinned repositories without treating its selection as stakeholder approval.

## DOC-01 — SAD-01

**Controlled question:** Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined?

**CONTROLLED RULE:** CL:17; GL:135 requires component functionality/design scope; GL:146–151 makes black-box treatment conditional and retains external-interface obligations; GL:174–198 addresses applicable internal design.

**SAD location:** SAD:20–48; participants at 189–192,207–210,225–228,243–246,261–263.

**DOCUMENT FACT:** UMD and KMD are separate graph nodes and sequence participants. Only UMD has an SWC overview, its ID is empty, and no KMD overview or Design Scope is present. Cluster appears inside the UMD node. Overview lists required KMD, host PCIe and NPU interfaces and provided topology/architecture APIs.

**Document gap / conflict:** Distinct nodes establish separation in the drawings, but do not supply separate component identities, responsibilities, design scopes or complete provided/required contracts. Neither a white-box decomposition nor a black-box exemption can be assumed.

**Evidence status:** Gap.

**OPEN ISSUE:** Define intended SWCs and their design scope, especially ownership of discovery, mapping setup, payload transfer and mapping lifetime. No particular source-file decomposition is prescribed.

## DOC-02 — SAD-02

**Controlled question:** Are component and external interfaces defined with their data/control flow, direction, and relevant constraints?

**CONTROLLED RULE:** CL:18; GL:155 covers external I/O and method/direction; GL:217,219–224 requires exact interface identity, conditions, consumer, parameter type/direction/range/meaning and possible results.

**SAD location:** SAD:52–180 and the Character Device edge at 47.

**DOCUMENT FACT:** All five interfaces have names and purpose text. Cluster states no inputs and object creation, explicitly not a constructor return value. Memory/register tables contain core, address, size and buffers. Multicast uses a destination set/range. TLB target is “Device Address/ TLB Identifier” and result is “TLB Window”. Validity constraints exist; possible failure results are not specified.

**Document gap / conflict:** Selected device and address domains are unclear; read-buffer passing/ownership is not explicit. Multicast destination encoding and TLB target/result representation are unspecified. Cluster initialized completion and the named KMD-provided contract are absent. Code cannot fill these document contracts.

**Evidence status:** Gap.

**OPEN ISSUE:** Author to resolve precise callable contracts, relevant completion/failure behavior and UMD/KMD boundary services. Do not assume a caller-owned buffer, writer object or code signature is intended without that decision.

## DOC-03 — SAD-03

**Controlled question:** Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency?

**CONTROLLED RULE:** CL:19,31; GL:238 requires architecture behavior sufficient for verification; GL:240,245,253–255 addresses major processing and meaningful runtime behavior. GL:243 recommends Activity Diagrams; it does not mandate that format for every interface.

**SAD location:** SAD:186–269, compared with purposes at 54,68,105,142,165 and precondition at 179.

**DOCUMENT FACT:** Cluster shows call, open, success and object creation. Memory, register and multicast sequences show call, mmap, success and return. TLB shows a userspace getter and returned window; existing mapping is a stated precondition. There is no referenced controlled alternative dynamic description.

**Document gap / conflict:** Cluster initialization and the three transfer sequences lack major processing and observable completion for their promised behavior. The simple TLB success exchange exists; applicable mapping-state/lifetime coverage remains missing evidence rather than proof of a required complex flow. Shutdown, error, recovery, mode and concurrency applicability are not sufficiently established to invent flows.

**Evidence status:** Gap for Cluster/memory/register/multicast; Missing evidence for TLB applicability/coverage.

**OPEN ISSUE:** Determine relevant states, processing, outcomes and lifecycle/error/concurrency conditions. KMD absence from the TLB getter is not itself a defect; no per-getter syscall or Activity Diagram is required by this review.

## DOC-04 — SAD-04

**Controlled question:** Are the software requirements appropriately allocated to components with bidirectional traceability?

**CONTROLLED RULE:** CL:20 requires requirement allocation and bidirectional traceability. The approved scope expressly requires Blocked when controlled SRS evidence is unavailable.

**SAD location:** Complete SAD:1–269 and approved scope: controlled references = none.

**DOCUMENT FACT:** No controlled SRS, requirement IDs, verification conditions or requirement-allocation matrix is supplied.

**Document gap / conflict:** Both requirement → architecture → implementation allocation and architecture → justifying requirement cannot be evaluated. Source code is not a controlled requirement baseline.

**Evidence status:** Missing evidence.

**OPEN ISSUE:** Supply a controlled requirements baseline only through renewed scope approval if subsequent requirement review is requested. Current supporting SAD-to-code mapping remains separate from compliance.

## DOC-05 — SAD-05

**Controlled question:** Is the architecture semantically consistent with the software requirements and internally consistent across its views?

**CONTROLLED RULE:** CL:21; GL:93,217–224 requires consistency of terminology/interface descriptions. Requirement-semantic consistency also depends on controlled requirements.

**SAD location:** Overview:20–29; static graph:35–48; interface tables:52–180; dynamic views:186–269.

**DOCUMENT FACT:** Basic categories and caller direction agree across the Overview/static/dynamic views. Cluster describes creation consistently; lowercase cluster() at 194 is a notation question. Memory read size at 84 says “Size of data to write”. Register outputs at 123,130 name memory operations, write address at 112 says memory region, and read size at 121 says data to write. Multicast source range at 147 says “Valid core” and Output at 152 names write_to_device(). TLB Output at 172 names write_to_device() while the declared operation is get_static_tlb_window().

**Document gap / conflict:** The four non-Cluster tables have direct local inconsistencies. Cluster capitalization is not elevated to an exact-symbol contradiction without a notation rule. TLB Configuration versus retrieval wording is an abstraction question; retrieval need not configure hardware. Requirements-semantic consistency remains unavailable for all interfaces.

**Evidence status:** Supported for basic Cluster internal consistency; Gap for four other interface tables; Missing evidence for requirements semantics.

**OPEN ISSUE:** Confirm naming/parameter meanings and intended abstraction. Do not equate internal-document support with passage of the unavailable requirement-semantic check.

## DOC-06 — SAD-06

**Controlled question:** Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage?

**CONTROLLED RULE:** CL:22; GL:294 explicitly requires the quality/constraint analysis result and rationale, allowing explained N/A for inapplicable aspects; GL:307–318 and 336–346 cover applicable timing/resource analysis and permit appropriate estimates.

**SAD location:** Complete SAD:1–269; constraints at 62,99,136,159,179.

**DOCUMENT FACT:** The complete target ends at its TLB sequence. No Architecture Analysis result, quality/constraint rationale, timing/resource evaluation or explained N/A is present. Interface validity/size statements exist but do not provide that analysis.

**Document gap / conflict:** The explicit minimum analysis evidence is absent. The review does not infer a numerical latency, throughput, memory, safety or concurrency requirement, nor assert that any runtime limit is violated.

**Evidence status:** Gap.

**OPEN ISSUE:** Provide shared analysis and its applicability to each interface. A separate benchmark or numeric budget per API is not demanded.

## DOC-07 — SAD-07

**Controlled question:** Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable?

**CONTROLLED RULE:** CL:23; GL:294 explicitly requires technical-feasibility result/rationale; GL:381 calls for rationale for significant decisions. GL:383 makes alternatives conditional on a meaningful choice.

**SAD location:** Complete SAD:1–269; UMD/KMD/BAR context at 26–28.

**DOCUMENT FACT:** The architecture assigns host access to UMD over KMD and names access/mapping interfaces, but records no technical-feasibility result, basis, significant-decision evaluation, assumptions or related risks.

**Document gap / conflict:** Required minimum feasibility evidence is absent. Existence of source code cannot supply an author-owned feasibility conclusion. Specific additional significant decisions/risks are not invented.

**Evidence status:** Gap.

**OPEN ISSUE:** Record the feasibility basis and applicable significant decisions and risks; identify negative impacts where supported. Do not require artificial competing designs.

## DOC-08 — SAD-08

**Controlled question:** Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded?

**CONTROLLED RULE:** CL:24 is conditional on reuse or a meaningful alternative/reference architecture; GL:294 requests explained applicability, GL:383 and 418–445 apply alternatives/reuse suitability conditionally.

**SAD location:** Complete SAD:1–269, especially Overview dependencies at 26–28.

**DOCUMENT FACT:** The target names external dependencies but does not identify a reused component/selected alternative with a suitability rationale, or explain why the aspect is inapplicable.

**Document gap / conflict:** Reuse/alternative applicability is unestablished. Dependency naming or source origin alone is insufficient to prove a substantive reuse-selection violation. Missing applicability evidence is distinct from a formal finding.

**Evidence status:** Missing evidence.

**OPEN ISSUE:** Owner to identify actual reuse/meaningful choices or justify inapplicability. No alternative, comparison matrix or requirement is invented.

## DOC-09 — SAD-09

**Controlled question:** Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable?

**CONTROLLED RULE:** CL:25; GL:451–455 covers project-estimate/planning evaluation and PM communication when applicable, and permits a no-impact statement. Approved scope excludes external planning/PM assessment and forbids automatic failure from missing external records.

**SAD location:** Complete SAD:1–269 and scope exclusions.

**DOCUMENT FACT:** The target contains no planning-impact evaluation or no-impact statement; project estimates, PM records and Review Minutes are not supplied. The in-scope evidence does not establish an interface-specific significant planning decision.

**Document gap / conflict:** Document absence is recorded; it does not prove evaluation/communication never happened or that no planning impact exists. External process assessment is outside the approved inputs.

**Evidence status:** N/A candidate for scoped external-process assessment; Missing evidence for applicability/impact.

**OPEN ISSUE:** Owner to establish applicable significance and identify a controlled record if subsequent review is requested. No external contact or new artifact is authorized by this observation.

## Evidence authority and limits

The approved scope resolves workflow conflicts: SAD-04 uses Blocked; SAD-09 is assessed within supplied scope; no external Jira/PM action is taken despite the checklist's general tracking instruction (CL:13,29). This does not claim that broader organizational review or analysis is complete. The missing controlled SRS, external PM evidence and guideline images were not silently replaced by code, prior review outputs or engineering preferences.

Final judgments and the formal-finding gate are applied in the five independent review files and summarized in the [findings index](../findings/findings.md) and [final report](../reports/sad-review-report.md).
