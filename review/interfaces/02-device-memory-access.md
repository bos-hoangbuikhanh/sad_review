# Device Memory Access — Independent SAD Interface Review

Scope version 2, approved 2026-10-07; [approved scope](../scope.md), [verified scope lock](../scope.lock). UMD: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`; KMD: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`. SAD revision 0.1 (2026-09-15); checklist/guideline snapshots 2026-10-07. Their exact hashes are locked.

Citation keys: **SAD** = `review-input/sad/umd-kmd-sad.md`; **CL** = `review-input/checklist/sad-review-checklist.md`; **GL** = `review-input/guideline/sad-writing-guideline.md`. Source citations are workspace-relative, with one-based line spans. Evidence classes are explicit: `CONTROLLED RULE`, `DOCUMENT FACT`, `IMPLEMENTATION EVIDENCE`, `ASSUMPTION`, `REVIEW OBSERVATION`, `OPEN ISSUE`. No assumption supplies intended architecture or a formal finding.

This is an independent interface assessment. Shared finding IDs SAD-F-001–003 denote the same cross-cutting issue, applied explicitly here and counted once in the overall index. Interface-specific findings use the 100/200/300/400/500 series; IDs are version-2 records, not the earlier aggregate register. Shared evidence was generated after all five interface files were complete.

## Interface scope

The write_to_device() and read_from_device() memory contract, selected device/core/address model, host buffers, transfer behavior, and the mapping dependency across UMD/KMD. Register access, multicast and TLB retrieval receive their own reviews.

## SAD contract

| Contract element | DOCUMENT FACT and location |
|---|---|
| Purpose | SAD:67–68 names write_to_device()/read_from_device() for memory on a specified target core/address. |
| Write inputs | SAD:73–76: CoreCoord core, const void* src, uint64_t address, size_t size; size >0 bytes. |
| Read inputs/output | SAD:82–84: core, address, size; SAD:97: void* dest, “Host buffer containing the data read from the device.” The table does not say whether dest is passed by the caller or returned. |
| Write result | SAD:91: void, “No return value”. No possible failure outcomes are defined. |
| Preconditions | SAD:99: “The target core and device address shall be valid and accessible for the selected device.” Selected-device representation and valid regions are not defined. |
| Dynamic flow | SAD:212–218: application call → UMD → KMD mmap() → success → return; no payload movement is shown. |

## Component model and consistency across views

The Overview explicitly includes memory access (SAD:26–27), the static graph labels Memory Read/Write (42), and the interface/sequence use the same operation names (67,212). UMD and KMD appear separately, but only UMD has a component overview; ownership of device selection and mapping resources is not specified.

A direct local wording inconsistency exists: the read_from_device size row says “Size of data to write” (SAD:84). This is a Minor clarity defect, not proof reads perform writes. The missing chip selector and size-width differences found in source are implementation alignment issues, not internal-document contradictions. Requirements semantics remain unassessed.

## UMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked UMD commit; not intended requirements.

| ID | File / symbol | Observed behavior and limit |
|---|---|---|
| UMD-EV-005 | source/bos-umd/device/blackholeplus/cluster.h:271–285; source/bos-umd/device/blackholeplus/cluster.cpp:576–600 | Write takes (const void* mem_ptr, uint32_t size_in_bytes, chip_id_t chip, CoreCoord core, uint64_t addr); read takes (void* mem_ptr, chip_id_t chip, CoreCoord core, uint64_t addr, uint32_t size). Both return void. Read fills a caller-supplied buffer. |
| UMD-EV-006 | source/bos-umd/device/blackholeplus/local_chip.cpp:177–205 | Selects DRAM or Tensix based on the translated core; other cores throw. This is observed routing, not a prescribed intended memory model. |
| UMD-EV-006 | source/bos-umd/device/blackholeplus/blackhole_tt_device.cpp:469–627,717–841; write/read_dram_memory and write/read_tensix_memory | Tensix checks ranges/static mapping and transfers through persistent BAR2. DRAM splits windows, requests ATU changes through BAR4 AP packets when needed, then transfers through existing BAR0. |
| UMD-EV-006 / 010 | source/bos-umd/device/blackholeplus/blackhole_tt_device.cpp:232–310; source/bos-umd/device/blackholeplus/tt_device.cpp:95–195 | AP update has response waits/error exits; block operations perform device copies, using volatile word access. No per-transfer mmap is in these inspected chains. Source timeout values are not controlled timing budgets. |
| UMD-EV-004 | source/bos-umd/device/blackholeplus/pci_device.cpp:193–324 | Mapping query and BAR mappings occur in device construction; addresses remain stored until destruction. This distinguishes host virtual mapping from device ATU-window changes. |

## KMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked KMD commit; direct participation is distinguished from supporting facilities.

| ID | File / symbol | Observed behavior and boundary role |
|---|---|---|
| KMD-EV-004 | source/bos-kmd/ioctl.h:30–83; source/bos-kmd/memory.c:372–449 | QUERY_MAPPINGS supplies IDs, character-device mmap offsets and BAR lengths. UMD/KMD query structures and mapping IDs agree statically (paired UMD device/ioctl.h:33–83). |
| KMD-EV-005 | source/bos-kmd/chardev.c:403–408; source/bos-kmd/memory.c:1186–1237 | mmap dispatch establishes BAR0/2/4 UC/WC, allocated TLB or DMA VMAs; an unmatched range/entity returns -EINVAL. This handler does not perform the application's memory payload copy. |
| KMD-EV-010 | source/bos-kmd/chardev.c:431–499; source/bos-kmd/enumerate.c:150–178 | File/device ownership and cleanup are distinct from a public read/write invocation. No intended hot-removal policy is inferred. |
| KMD-EV-003 | source/bos-kmd/chardev.c:36–42 | File operations register open/release/ioctl/mmap, not a file read/write payload API. This supports the inspected mapped-memory route, not a claim about every possible device path. |

## Traceability

Requirement / VC: **Not supplied**. Requirement → interface/flow → code and reverse interface → justifying requirement are both **Blocked**. The following table is supporting SAD-to-code alignment, not requirement compliance.

| SAD element | UMD evidence | KMD evidence | Alignment status | Gap / limitation |
|---|---|---|---|---|
| Named memory read/write | UMD-EV-005/006 | Supporting mappings, KMD-EV-004/005 | Partial | Names and broad purpose correspond; explicit chip argument and width differ; caller buffer semantics are unclear in SAD. |
| Per-access mmap diagram | UMD-EV-004/006 | KMD-EV-005 | Conflicting | Default BOS setup maps resources before transfers. ATU changes do not equal a fresh mmap call. |
| Selected device / valid memory | UMD-EV-003/005/006 | KMD-EV-002/004 | Partial | Logical chip, node identity and address/offset domains are not allocated in SAD. |
| Forward/reverse requirement justification | Not supplied | Not supplied | Blocked | No SRS; implementation ranges do not become requirements. |

Reverse mapping: Direct Tensix BAR2 and DRAM BAR0/AP-window operations map to broad memory access but have no intended flow allocation in the SAD. KMD mapping offsets are not device addresses. Source pinning/DMA capability is not evidence that these ordinary functions use DMA; the nearby BOS public DMA methods throw (cluster.cpp:586–596).

## Complete SAD-01 through SAD-09 checklist

`CONTROLLED RULE` — questions below reproduce the approved checklist. Results assess this interface, including explicitly applicable shared architecture evidence. SAD-04 uses the user-required `Blocked` exception. SAD-09 uses the approved scope/applicability rule. A missing-evidence result does not create a formal finding. Requirements-semantic coverage is separately limited even when an internal-consistency check is supported.

| ID | Controlled review question | Result | Note / basis |
|---|---|---|---|
| SAD-01 | Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined? | Fail | SAD-F-001: memory mapping/transfer ownership is not allocated to separately specified UMD/KMD components. |
| SAD-02 | Are component and external interfaces defined with their data/control flow, direction, and relevant constraints? | Fail | SAD-F-201: selected-device/address domain, read-buffer passing, exact parameter/result and failure contracts are incomplete (GL:155,217–224). |
| SAD-03 | Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency? | Fail | SAD-F-202: sequence shows mapping success but not meaningful read/write processing or data outcome (GL:238,240,255). Drift SAD-F-205 is separately supported by code. |
| SAD-04 | Are the software requirements appropriately allocated to components with bidirectional traceability? | Blocked | No controlled requirements baseline; forward and reverse allocation cannot be determined. |
| SAD-05 | Is the architecture semantically consistent with the software requirements and internally consistent across its views? | Fail | SAD-F-203: the read size is described as data to write (SAD:84). This is a direct local wording inconsistency; requirement-semantic consistency is separately unassessed. |
| SAD-06 | Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage? | Fail | SAD-F-002: required shared quality/constraint analysis is missing, not a measured performance/resource failure. |
| SAD-07 | Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable? | Fail | SAD-F-003: no shared feasibility result/rationale for the documented memory-access architecture. |
| SAD-08 | Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded? | Fail | Missing evidence only: applicability and rationale for reuse/meaningful alternatives are not established. No mandatory comparison or substitute design is invented. |
| SAD-09 | Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable? | N/A | External planning/PM process assessment is outside the supplied inputs; no interface-specific significant planning decision is established. MEM-PLAN retains the unknown applicability/impact rather than claiming a failure. |

## Findings

Formal findings below satisfy the criterion/applicability/direct-evidence gate. Shared IDs are repeated here with interface-specific applicability so this file is independently reviewable; the overall index counts them once. Drift and observations do not select code as the intended architecture.

### SAD-F-001 — Component responsibilities and design scopes are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-01

**Guideline / controlled criterion:** CL:17; GL §2.2:135,146–151 and §3:174–198. Identify component responsibilities/design scopes; black-box omission is conditional on an identified scope.

**Location:** SAD:20–48 and complete SAD:1–269

**Evidence:** DOCUMENT FACT — UMD and KMD are distinct static nodes and named participants, but only `SWC UMD` has an overview; its ID is blank. There is no KMD component definition or Design Scope/black-box designation. The memory sequence names KMD mmap but no separate KMD contract defines mapping setup, ownership or transfer responsibility.

**Issue:** Applicability to this interface: Memory transfer requires distinguishing userspace payload movement, kernel mapping setup and the selected device/address domain. Distinct diagram nodes do not establish separately specified software components, and a black-box exemption cannot be assumed.

**Impact:** Responsibility and integration-test allocation can differ between implementers.

**Suggested correction:** State intended component identities, responsibilities and Design Scope; provide applicable internal detail or a justified black-box external contract. Do not derive intended decomposition solely from source files.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Device Memory Access:65–100 and Device Memory Write/Read:204–220. Implementation evidence: UMD-EV-004/005/006/010; KMD-EV-004/005/010.

### SAD-F-002 — Required quality and constraint analysis is absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-06

**Guideline / controlled criterion:** CL:22; GL §4:294 explicitly requires a quality/constraint analysis result and rationale, with explained N/A where appropriate; GL §§4.1–4.2:307–346 covers applicable timing/resource analysis.

**Location:** Complete SAD:1–269; SAD Device Memory Access:65–100 and Device Memory Write/Read:204–220

**Evidence:** DOCUMENT FACT — The complete SAD ends at the TLB sequence and contains no quality/constraint analysis result, timing/resource evaluation, or reasoned N/A. The contract states positive size and valid addresses (SAD:76,99), but no applicable memory-path timing/resource analysis is supplied.

**Issue:** The interface depends on the document-wide analysis that GL:294 expressly requires. One shared analysis may cover all interfaces; a separate numerical budget/report per API is not demanded.

**Impact:** The review lacks an evidence basis for architecture suitability against applicable constraints; no measured limit violation is claimed.

**Suggested correction:** Provide the author-owned shared analysis and identify its applicability to this interface, or justify inapplicable aspects. No reviewer-invented threshold or runtime test is prescribed.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Device Memory Access:65–100 and Device Memory Write/Read:204–220. Implementation evidence: Source mechanisms in UMD-EV-004/005/006/010; KMD-EV-004/005/010 do not replace controlled analysis.

### SAD-F-003 — Required feasibility result and rationale are absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-07

**Guideline / controlled criterion:** CL:23; GL §4:294 explicitly requires a technical-feasibility result and rationale; GL §4.3:381 applies to significant decisions without prescribing artificial alternatives.

**Location:** Complete SAD:1–269; SAD Device Memory Access:65–100 and Device Memory Write/Read:204–220

**Evidence:** DOCUMENT FACT — No technical-feasibility conclusion or supporting architecture rationale is present. Memory access via the UMD/KMD/BAR arrangement is named in SAD:26 and depicted at 212–218 without a feasibility result.

**Issue:** The explicit minimum feasibility evidence does not exist for the architecture on which this interface relies; significance of further decisions and applicable risks is not invented.

**Impact:** Reviewers cannot identify the basis and conditions under which the architecture is considered feasible.

**Suggested correction:** Record the shared feasibility result and basis, then the interface-relevant significant choices, assumptions and risks where applicable. Code existence is not feasibility proof.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Device Memory Access:65–100 and Device Memory Write/Read:204–220. Implementation evidence: UMD-EV-004/005/006/010; KMD-EV-004/005/010.

### SAD-F-201 — Memory caller and boundary contracts are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:155,217–224 require parameter direction/meaning, relevant conditions and possible results.

**Location:** SAD:65–100,212–218

**Evidence:** DOCUMENT FACT — The constraint refers to the selected device without defining its representation; dest appears only in an output table; valid core/region is undefined; no failure outcomes or KMD mapping contract are given.

**Issue:** The caller cannot obtain a precise device selection, output-buffer, address validity or failure contract from the target. This is independent of whether code is intended to be authoritative.

**Impact:** Callers and tests can make incompatible buffer/address/lifetime assumptions.

**Suggested correction:** Define intended selection, argument/output direction and ownership, valid domains, failures and mapping dependency; resolve abstraction level before reconciling source.

**Traceability:** Requirement / VC: Not supplied. SAD element: Memory access tables and required KMD boundary. Implementation evidence: UMD-EV-005/006; KMD-EV-004/005.

### SAD-F-202 — Memory sequence does not describe the payload operation

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-03

**Guideline / controlled criterion:** CL:19,31; GL:238,240,255 require major component processing and observable results sufficient for verification.

**Location:** SAD:68,204–220

**Evidence:** DOCUMENT FACT — The promised read/write sequence contains the caller API, KMD mmap(), success and return, without data-transfer processing or its observable completion. No other controlled dynamic description is referenced.

**Issue:** A mapping-success exchange does not explain the promised memory behavior in this document. No particular algorithm or per-core code implementation is imposed.

**Impact:** Integration verification cannot distinguish access setup from fulfillment of the read/write request.

**Suggested correction:** Describe intended setup versus payload processing and completion; identify applicable conditions/error/lifecycle cases at architecture level.

**Traceability:** Requirement / VC: Not supplied. SAD element: Device Memory Write/Read. Implementation evidence: UMD-EV-004/006; KMD-EV-005 (alignment context).

### SAD-F-203 — Read size is described as a write size

**Classification:** Process / guideline finding

**Severity:** Minor

**Checklist:** SAD-05

**Guideline / controlled criterion:** CL:21; GL:93,221,224 require consistent interface naming/parameter meanings.

**Location:** SAD:78–84

**Evidence:** DOCUMENT FACT — Under read_from_device(), size is described exactly as “Size of data to write”.

**Issue:** The parameter description names a different direction than its containing operation.

**Impact:** Localized ambiguity can propagate into API documentation or tests; it does not demonstrate incorrect runtime behavior.

**Suggested correction:** Confirm and describe the read byte count consistently with the intended read operation.

**Traceability:** Requirement / VC: Not supplied. SAD element: read_from_device size row. Implementation evidence: Not needed; direct internal document evidence.

### SAD-F-204 — Memory signature correspondence differs at the recorded baseline

**Classification:** Implementation drift

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:217–224 is comparison context. Intended contract remains an owner decision.

**Location:** SAD:73–97; source/bos-umd/device/blackholeplus/cluster.h:271–285

**Evidence:** DOCUMENT FACT — SAD uses size_t and no explicit chip selector. IMPLEMENTATION EVIDENCE — the public methods use uint32_t sizes and chip_id_t chip; read takes a destination pointer and returns void.

**Issue:** Parameter types/selection differ. The SAD output pointer is ambiguous, not an explicit incompatible pointer return.

**Impact:** A caller cannot bind the table directly to this declaration without an interpretation step.

**Suggested correction:** Decide intended variant/API abstraction and reconcile the two artifacts; neither is presumed correct.

**Traceability:** Requirement / VC: Not supplied. SAD element: Memory input/output tables. Implementation evidence: UMD-EV-005.

### SAD-F-205 — Memory mapping occurs at setup in the inspected implementation

**Classification:** Implementation drift

**Checklist:** SAD-03

**Guideline / controlled criterion:** CL:19; GL:238–257 provides dynamic-alignment context, not code-derived requirements.

**Location:** SAD:212–218; source/bos-umd/device/blackholeplus/pci_device.cpp:193–324; source/bos-kmd/memory.c:1186–1237

**Evidence:** DOCUMENT FACT — mmap follows the public access call in the sequence. IMPLEMENTATION EVIDENCE — BARs are mapped in the PCI-device constructor, and the ordinary memory methods transfer through saved mappings; KMD mmap establishes VMAs.

**Issue:** The shown lifetime/order differs from the inspected default BOS path. ATU-window programming through BAR4 is not an mmap syscall.

**Impact:** The diagram can lead to an incorrect allocation of setup and transfer responsibilities.

**Suggested correction:** Domain owner decision required on intended mapping/access lifecycle, followed by reconciliation without assuming source is intended truth.

**Traceability:** Requirement / VC: Not supplied. SAD element: Memory dynamic view. Implementation evidence: UMD-EV-004/006; KMD-EV-004/005.

## Decisions required and open issues

| ID | Classification | Decision / missing evidence |
|---|---|---|
| MEM-REQ | Missing evidence | Controlled requirements are not supplied. SAD-04 is Blocked, not Fail; forward allocation and reverse justification cannot be established. Requirements-semantic consistency also remains unassessed. New requirements require renewed scope approval. |
| MEM-REUSE | Missing evidence | The target does not establish whether this interface embodies a reused component or meaningful alternative selection. SAD-08 cannot be accepted on current applicability evidence; no substantive reuse/comparison violation or artificial alternative is invented. |
| MEM-PLAN | Decision required | SAD-09 is N/A to external project/PM process assessment within these supplied inputs. This scope-qualified result does not mean no planning impact. The document has no evaluation/no-impact statement, but the review does not infer an interface-specific significant planning decision or an external failure from that absence. An owner must settle applicability and point to the appropriate controlled record if review is requested. |
| MEM-VARIANT | Decision required | Identify the intended architecture/build variant and supported interface contract. Source defaults and nearby API analogues do not establish that intent. |
| MEM-MODEL | Decision required | Define logical chip/device identity, address domains, buffer ownership, supported target cores and completion semantics without importing source limits as requirements. |
| MEM-SERIAL | Missing evidence | Caller serialization, map invalidation/removal and AP/ATU concurrency policy are not established. Observed locks or local absence of locks cannot prove end-to-end safety. |
| MEM-FLOW | Decision required | Reconcile persistent mapping, target-window changes and actual payload flow. No per-transfer kernel copy or DMA use is inferred. |

## Coverage limitations

Read-only static inspection; no build, hardware, runtime, concurrency, fault-injection, throughput or deployed ABI test. UMD evidence follows the checked-in default `EAGLE_AS_TT=ON` BOS chain (`source/bos-umd/CMakeLists.txt:58–62`, `source/bos-umd/device/CMakeLists.txt:64–92`); generic branches were inspected only for selection/correspondence and are not exhaustively verified. KMD defaults to `BLACKHOLEPLUS` (`source/bos-kmd/Makefile:13–14`). Neither default establishes intended/deployed configuration. No firmware, hardware specification, external wrapper or additional controlled reference is assumed. All relevant preserved SAD Mermaid text was inspected; absent guideline example images were not reconstructed. Checklist status is `unknown`, as approved. No external tickets, PM messages or stakeholder approvals are created or implied.

Tensix and DRAM follow different inspected paths. AP firmware behavior, hardware address validity, cache/ordering effects and transfer completion were not validated. No configured size or timeout is asserted to satisfy a controlled budget.

## Final interface result

**Assessed interface result: Fail. Requirements coverage: Blocked. SAD-09: N/A within the stated assessment scope.**

Document contract/behavior gaps, the localized read-size inconsistency and applicable shared-analysis gaps support Fail. Signature and mapping differences are recorded separately as drift. SAD-04 remains Blocked, and external planning evidence does not cause the result.

The scoped review is complete; this is not full requirements acceptance, a runtime validation result, or stakeholder approval. No controlled input/source was changed. Scope-lock verification preceded analysis; final verification is recorded in the overall report.

