# Multicast Write — Independent SAD Interface Review

Scope version 2, approved 2026-10-07; [approved scope](../scope.md), [verified scope lock](../scope.lock). UMD: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`; KMD: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`. SAD revision 0.1 (2026-09-15); checklist/guideline snapshots 2026-10-07. Their exact hashes are locked.

Citation keys: **SAD** = `review-input/sad/umd-kmd-sad.md`; **CL** = `review-input/checklist/sad-review-checklist.md`; **GL** = `review-input/guideline/sad-writing-guideline.md`. Source citations are workspace-relative, with one-based line spans. Evidence classes are explicit: `CONTROLLED RULE`, `DOCUMENT FACT`, `IMPLEMENTATION EVIDENCE`, `ASSUMPTION`, `REVIEW OBSERVATION`, `OPEN ISSUE`. No assumption supplies intended architecture or a formal finding.

This is an independent interface assessment. Shared finding IDs SAD-F-001–003 denote the same cross-cutting issue, applied explicitly here and counted once in the overall index. Interface-specific findings use the 100/200/300/400/500 series; IDs are version-2 records, not the earlier aggregate register. Shared evidence was generated after all five interface files were complete.

## Interface scope

The SAD's noc_multicast_write() contract, destination-region representation, payload/address constraints, completion and the depicted UMD/KMD interaction. Nearby broadcast methods and KMD multicast-capable configuration are comparison evidence, not assumed replacements.

## SAD contract

| Contract element | DOCUMENT FACT and location |
|---|---|
| Identity/purpose | SAD:141–142: noc_multicast_write(), “Performs a NoC multicast write to multiple destination cores within the specified multicast region.” |
| Inputs | SAD:147–150: const void* src, destination set / range dest, uint64_t address, size_t size >0 bytes. The source buffer's Range says “Valid core”. |
| Destination | SAD:148 describes cores or a multicast region, but supplies no precise type, encoding, chip selection or inclusion/exclusion convention. |
| Result | SAD:152 labels Output as write_to_device(); SAD:157 gives void / No return value. No failure or completion meaning is defined. |
| Constraint | SAD:159 requires the destination region and address to be valid for the target architecture, without naming the variant or valid domain. |
| Interaction | SAD:248–254: noc_multicast_write() → KMD mmap() → success → return. |

## Component model and consistency across views

Static Multicast Write (SAD:44) and the detailed/dynamic multicast operation (141,248) correspond. The Overview's general API categories do not explicitly map to multicast; category omission alone is not a proved contradiction. Direct inconsistencies are the output label write_to_device() and the source-buffer range Valid core.

UMD and KMD are separate diagram nodes/participants but not separately specified SWCs with defined design scopes. No architecture fact in the target assigns multicast destination selection, hardware fan-out, mapping establishment and payload execution to distinct owners.

## UMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked UMD commit; not intended requirements.

| ID | File / symbol | Observed behavior and limit |
|---|---|---|
| UMD-EV-008 | Whole tracked source/bos-umd C/C++ name search | git grep -n -E 'noc_multicast_write\|get_static_tlb_window' over *.cpp, *.cc, *.c, *.h, *.hpp returned no exact occurrence (exit 1). Search used ERE alternation, not a literal pipe. No outside/generated wrapper was assumed. |
| UMD-EV-008 | source/bos-umd/device/blackholeplus/cluster.h:340–382; source/bos-umd/device/blackholeplus/cluster.cpp:471–553 | Nearby broadcast_write_to_cluster and register counterpart accept chip/row/column exclusion sets. The active BOS bodies check a row-grid condition and dispatch through get_tt_device(0); the commented-out per-chip loop is not behavior. |
| UMD-EV-008 | source/bos-umd/device/blackholeplus/blackhole_tt_device.cpp:631–715 | The nearby broadcast routines check address/buffer bounds and write an existing BAR2 broadcast region. This establishes behavior of those routines, not equivalence to the SAD's destination-set interface. |
| UMD-EV-004 | source/bos-umd/device/blackholeplus/pci_device.cpp:193–324 | The supporting BARs are mapped during construction. No per-broadcast mmap is in the inspected nearby chain, but the exact SAD API remains unbound. |

## KMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked KMD commit; direct participation is distinguished from supporting facilities.

| ID | File / symbol | Observed behavior and boundary role |
|---|---|---|
| KMD-EV-004 / 005 | source/bos-kmd/memory.c:372–449,1186–1237 | KMD mapping discovery and mmap provide access resources; mmap does not contain a multicast payload operation. Positive mapping-query correspondence does not prove multicast destination semantics. |
| KMD-EV-006 | source/bos-kmd/ioctl.h:268–295; source/bos-kmd/memory.c:990–1004; source/bos-kmd/blackhole.c:152–175 | TLB configuration includes start/end coordinates, NoC, mcast and ordering, and the retained callback writes those configuration fields. It is a configuration contract without a source payload buffer. |
| KMD-EV-013 | source/bos-kmd/Makefile:13–14; source/bos-kmd/enumerate.c:119–127; source/bos-kmd/blackhole.c:804–838,992–1014 | Default BLACKHOLEPLUS skips kernel initialization while related callbacks remain. Their source presence cannot establish the supported multicast mechanism or actual invocation by UMD. |

## Traceability

Requirement / VC: **Not supplied**. Requirement → interface/flow → code and reverse interface → justifying requirement are both **Blocked**. The following table is supporting SAD-to-code alignment, not requirement compliance.

| SAD element | UMD evidence | KMD evidence | Alignment status | Gap / limitation |
|---|---|---|---|---|
| noc_multicast_write identity | UMD-EV-008: exact name absent in bounded search | No public UMD API binding established | Missing | Nearby broadcast methods are not verified replacements. |
| Destination set/range semantics | Nearby exclusion-set/fixed-device path only | Multicast-capable TLB fields, KMD-EV-006 | Partial | Neither proves the intended target set, chip selection or hardware fan-out. |
| mmap-based sequence | Existing mappings used by nearby broadcast path | KMD-EV-005 establishes VMAs | Partial | The exact operation is unbound; do not assert a verified call-chain replacement. Depicted mapping alone omits payload behavior. |
| Requirement justification | Not supplied | Not supplied | Blocked | No required multicast coverage or ordering threshold can be invented. |

Reverse mapping: Source broadcast exclusions, fixed device 0 access and BAR2 broadcast window cannot be reverse-mapped as the intended noc_multicast_write contract. Likewise a KMD mcast configuration field is not a public multicast data-transfer API. Both correspondences require an explicit owner decision.

## Complete SAD-01 through SAD-09 checklist

`CONTROLLED RULE` — questions below reproduce the approved checklist. Results assess this interface, including explicitly applicable shared architecture evidence. SAD-04 uses the user-required `Blocked` exception. SAD-09 uses the approved scope/applicability rule. A missing-evidence result does not create a formal finding. Requirements-semantic coverage is separately limited even when an internal-consistency check is supported.

| ID | Controlled review question | Result | Note / basis |
|---|---|---|---|
| SAD-01 | Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined? | Fail | SAD-F-001: UMD/KMD responsibilities and design scopes do not allocate multicast selection/setup/execution. |
| SAD-02 | Are component and external interfaces defined with their data/control flow, direction, and relevant constraints? | Fail | SAD-F-401: destination representation, architecture validity, exact callable contract and possible outcomes are undefined (GL:217–224). |
| SAD-03 | Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency? | Fail | SAD-F-402: mmap success alone does not describe the promised multi-destination write; no target/payload processing or completion behavior is supplied. |
| SAD-04 | Are the software requirements appropriately allocated to components with bidirectional traceability? | Blocked | No controlled SRS establishes intended multicast requirements or bidirectional allocation. |
| SAD-05 | Is the architecture semantically consistent with the software requirements and internally consistent across its views? | Fail | SAD-F-403: output names write_to_device() and source-buffer range says Valid core, inconsistent with the declared multicast entry. |
| SAD-06 | Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage? | Fail | SAD-F-002: required shared quality/constraint analysis is absent; no multicast latency/coverage target is invented. |
| SAD-07 | Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable? | Fail | SAD-F-003: no shared feasibility result/rationale applicable to this multicast interface. |
| SAD-08 | Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded? | Fail | Missing evidence: reuse/meaningful alternative applicability is unknown, and no reasoned N/A is supplied. Current source origin or API similarity does not prove a selected architecture. |
| SAD-09 | Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable? | N/A | External project/PM process assessment is outside supplied inputs and no interface-specific planning significance is established. MC-PLAN preserves the unresolved applicability/impact question. |

## Findings

Formal findings below satisfy the criterion/applicability/direct-evidence gate. Shared IDs are repeated here with interface-specific applicability so this file is independently reviewable; the overall index counts them once. Drift and observations do not select code as the intended architecture.

### SAD-F-001 — Component responsibilities and design scopes are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-01

**Guideline / controlled criterion:** CL:17; GL §2.2:135,146–151 and §3:174–198. Identify component responsibilities/design scopes; black-box omission is conditional on an identified scope.

**Location:** SAD:20–48 and complete SAD:1–269

**Evidence:** DOCUMENT FACT — UMD and KMD are distinct static nodes and named participants, but only `SWC UMD` has an overview; its ID is blank. There is no KMD component definition or Design Scope/black-box designation. The multicast sequence's KMD mmap interaction carries no destination set or payload, and there is no separate KMD contract.

**Issue:** Applicability to this interface: Destination selection, multicast execution and setup ownership cannot be allocated from the component labels alone. Distinct diagram nodes do not establish separately specified software components, and a black-box exemption cannot be assumed.

**Impact:** Responsibility and integration-test allocation can differ between implementers.

**Suggested correction:** State intended component identities, responsibilities and Design Scope; provide applicable internal detail or a justified black-box external contract. Do not derive intended decomposition solely from source files.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Multicast Write:139–160 and dynamic sequence:240–256. Implementation evidence: UMD-EV-004/008; KMD-EV-004/005/006/013.

### SAD-F-002 — Required quality and constraint analysis is absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-06

**Guideline / controlled criterion:** CL:22; GL §4:294 explicitly requires a quality/constraint analysis result and rationale, with explained N/A where appropriate; GL §§4.1–4.2:307–346 covers applicable timing/resource analysis.

**Location:** Complete SAD:1–269; SAD Multicast Write:139–160 and dynamic sequence:240–256

**Evidence:** DOCUMENT FACT — The complete SAD ends at the TLB sequence and contains no quality/constraint analysis result, timing/resource evaluation, or reasoned N/A. The target states a positive size and valid architecture-specific destinations (SAD:147–159), without identifying applicable quality/latency/resource analysis.

**Issue:** The interface depends on the document-wide analysis that GL:294 expressly requires. One shared analysis may cover all interfaces; a separate numerical budget/report per API is not demanded.

**Impact:** The review lacks an evidence basis for architecture suitability against applicable constraints; no measured limit violation is claimed.

**Suggested correction:** Provide the author-owned shared analysis and identify its applicability to this interface, or justify inapplicable aspects. No reviewer-invented threshold or runtime test is prescribed.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Multicast Write:139–160 and dynamic sequence:240–256. Implementation evidence: Source mechanisms in UMD-EV-004/008; KMD-EV-004/005/006/013 do not replace controlled analysis.

### SAD-F-003 — Required feasibility result and rationale are absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-07

**Guideline / controlled criterion:** CL:23; GL §4:294 explicitly requires a technical-feasibility result and rationale; GL §4.3:381 applies to significant decisions without prescribing artificial alternatives.

**Location:** Complete SAD:1–269; SAD Multicast Write:139–160 and dynamic sequence:240–256

**Evidence:** DOCUMENT FACT — No technical-feasibility conclusion or supporting architecture rationale is present. No feasibility/rationale explains the specified multi-destination NoC interface or its relation to UMD/KMD access mechanisms.

**Issue:** The explicit minimum feasibility evidence does not exist for the architecture on which this interface relies; significance of further decisions and applicable risks is not invented.

**Impact:** Reviewers cannot identify the basis and conditions under which the architecture is considered feasible.

**Suggested correction:** Record the shared feasibility result and basis, then the interface-relevant significant choices, assumptions and risks where applicable. Code existence is not feasibility proof.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Multicast Write:139–160 and dynamic sequence:240–256. Implementation evidence: UMD-EV-004/008; KMD-EV-004/005/006/013.

### SAD-F-401 — Multicast destination and operation contract are imprecise

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:217–224 requires precise operation and parameter types/directions/meaning, conditions and outcomes.

**Location:** SAD:139–160

**Evidence:** DOCUMENT FACT — dest has type “destination set / range”; valid NoC targets and target architecture are not defined; there is no exact function declaration, selection model or failure/completion outcome.

**Issue:** An implementer or caller cannot derive a unique destination encoding and operation contract from this entry.

**Impact:** Different target sets and integration expectations can result from the same description.

**Suggested correction:** Owner to define intended API, destination representation, device/architecture scope and observable completion/failure; do not substitute a nearby broadcast API without justification.

**Traceability:** Requirement / VC: Not supplied. SAD element: Multicast interface table. Implementation evidence: UMD-EV-008; KMD-EV-006 are comparison evidence only.

### SAD-F-402 — Multicast behavior is not described beyond a mapping exchange

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-03

**Guideline / controlled criterion:** CL:19,31; GL:238,240,255 requires meaningful processing and observable results sufficient for verification.

**Location:** SAD:142,240–256

**Evidence:** DOCUMENT FACT — The multi-destination write description is followed by a sequence containing only API call, mmap, success and return; no destination/payload handling or completion behavior is described or referenced.

**Issue:** The dynamic view does not explain the interface's promised multicast behavior. No mandatory fan-out algorithm, KMD transaction or diagram format is inferred.

**Impact:** Integration cannot verify what set of operations fulfills the documented multicast request.

**Suggested correction:** Describe intended destination/payload processing and completion, with component responsibilities and applicable conditions.

**Traceability:** Requirement / VC: Not supplied. SAD element: Multicast dynamic view. Implementation evidence: UMD-EV-008; KMD-EV-005/006 (context).

### SAD-F-403 — Multicast table mixes operation and parameter domains

**Classification:** Process / guideline finding

**Severity:** Minor

**Checklist:** SAD-05

**Guideline / controlled criterion:** CL:21; GL:93,221,224 requires consistent names and parameter meanings.

**Location:** SAD:141,147,152

**Evidence:** DOCUMENT FACT — The declared operation is noc_multicast_write(), but Output names write_to_device(); const void* src is described as a source buffer while its range is “Valid core”.

**Issue:** The result association and source-buffer domain conflict with their containing table.

**Impact:** Localized ambiguity can propagate to callers/tests; no runtime multicast failure is established.

**Suggested correction:** Associate the result with the intended operation and describe the source-buffer domain accurately after confirming the contract.

**Traceability:** Requirement / VC: Not supplied. SAD element: Multicast output/source rows. Implementation evidence: Not needed; target-only inconsistencies.

### SAD-F-404 — Named multicast API has no exact counterpart in the searched baseline

**Classification:** Implementation drift

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:217,224 gives exact-API comparison context. Intended API/variant is unresolved.

**Location:** SAD:141–159,248; tracked UMD C/C++ search and source/bos-umd/device/blackholeplus/cluster.cpp:496–553

**Evidence:** DOCUMENT FACT — noc_multicast_write() accepts a destination set/range. IMPLEMENTATION EVIDENCE — the exact name is absent in the specified tracked search; nearby methods have exclusion arguments and an active fixed-device broadcast path.

**Issue:** No exact binding or equivalence is established. KMD multicast-capable configuration does not supply the missing public function.

**Impact:** The interface cannot be integrated against a confirmed implementation entry point.

**Suggested correction:** Domain owner decision required: identify the intended operation/variant or an explicit valid mapping, then reconcile both sides. Do not assume which artifact must change.

**Traceability:** Requirement / VC: Not supplied. SAD element: Multicast interface and sequence. Implementation evidence: UMD-EV-008; KMD-EV-006.

## Decisions required and open issues

| ID | Classification | Decision / missing evidence |
|---|---|---|
| MC-REQ | Missing evidence | Controlled requirements are not supplied. SAD-04 is Blocked, not Fail; forward allocation and reverse justification cannot be established. Requirements-semantic consistency also remains unassessed. New requirements require renewed scope approval. |
| MC-REUSE | Missing evidence | The target does not establish whether this interface embodies a reused component or meaningful alternative selection. SAD-08 cannot be accepted on current applicability evidence; no substantive reuse/comparison violation or artificial alternative is invented. |
| MC-PLAN | Decision required | SAD-09 is N/A to external project/PM process assessment within these supplied inputs. This scope-qualified result does not mean no planning impact. The document has no evaluation/no-impact statement, but the review does not infer an interface-specific significant planning decision or an external failure from that absence. An owner must settle applicability and point to the appropriate controlled record if review is requested. |
| MC-VARIANT | Decision required | Identify the intended architecture/build variant and supported interface contract. Source defaults and nearby API analogues do not establish that intent. |
| MC-BINDING | Decision required | Identify whether the named interface is intended, obsolete, conceptual or provided by a separately approved wrapper. Nearby broadcast APIs are not automatically replacements. |
| MC-DEST | Decision required | Define supported chips/cores/regions, destination encoding, completion and any ordering constraints. Neither fixed device 0 in code nor KMD mcast fields establish the intended policy. |
| MC-KMD | Missing evidence | Actual KMD participation beyond setup and supported multicast/TLB callbacks for the intended build are unestablished. |

## Coverage limitations

Read-only static inspection; no build, hardware, runtime, concurrency, fault-injection, throughput or deployed ABI test. UMD evidence follows the checked-in default `EAGLE_AS_TT=ON` BOS chain (`source/bos-umd/CMakeLists.txt:58–62`, `source/bos-umd/device/CMakeLists.txt:64–92`); generic branches were inspected only for selection/correspondence and are not exhaustively verified. KMD defaults to `BLACKHOLEPLUS` (`source/bos-kmd/Makefile:13–14`). Neither default establishes intended/deployed configuration. No firmware, hardware specification, external wrapper or additional controlled reference is assumed. All relevant preserved SAD Mermaid text was inspected; absent guideline example images were not reconstructed. Checklist status is `unknown`, as approved. No external tickets, PM messages or stakeholder approvals are created or implied.

The no-name result is limited to tracked *.cpp, *.cc, *.c, *.h and *.hpp files; it does not claim absence in external wrappers, generated/deployed binaries or firmware. Hardware multicast fan-out and the meaning of the broadcast region were not verified.

## Final interface result

**Assessed interface result: Fail. Requirements coverage: Blocked. SAD-09: N/A within the stated assessment scope.**

Contract, dynamic-content and table consistency findings justify Fail independently of the missing requirements. The exact-name/source difference is bounded drift. No equivalence with nearby broadcast routines or retained KMD configuration is asserted.

The scoped review is complete; this is not full requirements acceptance, a runtime validation result, or stakeholder approval. No controlled input/source was changed. Scope-lock verification preceded analysis; final verification is recorded in the overall report.

