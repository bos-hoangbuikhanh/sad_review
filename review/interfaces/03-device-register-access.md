# Device Register Access — Independent SAD Interface Review

Scope version 2, approved 2026-10-07; [approved scope](../scope.md), [verified scope lock](../scope.lock). UMD: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`; KMD: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`. SAD revision 0.1 (2026-09-15); checklist/guideline snapshots 2026-10-07. Their exact hashes are locked.

Citation keys: **SAD** = `review-input/sad/umd-kmd-sad.md`; **CL** = `review-input/checklist/sad-review-checklist.md`; **GL** = `review-input/guideline/sad-writing-guideline.md`. Source citations are workspace-relative, with one-based line spans. Evidence classes are explicit: `CONTROLLED RULE`, `DOCUMENT FACT`, `IMPLEMENTATION EVIDENCE`, `ASSUMPTION`, `REVIEW OBSERVATION`, `OPEN ISSUE`. No assumption supplies intended architecture or a formal finding.

This is an independent interface assessment. Shared finding IDs SAD-F-001–003 denote the same cross-cutting issue, applied explicitly here and counted once in the overall index. Interface-specific findings use the 100/200/300/400/500 series; IDs are version-2 records, not the earlier aggregate register. Shared evidence was generated after all five interface files were complete.

## Interface scope

write_to_device_reg() and read_from_device_reg(), their target/address/length/buffer contract, register transfer flow and UMD/KMD responsibilities. Ordinary device memory and multicast are assessed independently.

## SAD contract

| Contract element | DOCUMENT FACT and location |
|---|---|
| Identity/purpose | SAD:104–105 names write_to_device_reg()/read_from_device_reg() and specifies registers on a target core/register address. |
| Write inputs | SAD:110–113: CoreCoord core, const void* src, uint64_t address, size_t size >0 bytes. The write address says “Destination device memory address” / “Valid memory region”. |
| Read inputs/output | SAD:119–121: core, register address, size; size description says data to write. SAD:134 supplies void* dest as a host register-value buffer without a passing/ownership contract. |
| Output labels | SAD:123 and 130 name write_to_device()/read_from_device(), although the section defines register operations. |
| Constraint | SAD:136: “The target register address shall be valid and accessible for the selected core.” No alignment, completion or possible failure contract is defined. |
| Dynamic flow | SAD:230–236 shows register API → KMD mmap() → success → return. |

## Component model and consistency across views

Overview memory/register capability (SAD:26–27), static Register Read/Write edge (43), and dynamic register API names (230) correspond at category level. The detailed register output labels instead name the memory APIs, and the write address uses a memory-region domain. These are direct target inconsistencies, independently of missing requirements or source code.

UMD and KMD are visibly separate participants, but the only software-component overview is UMD. KMD's setup service and UMD's transfer responsibility are not separately contracted. A static KMD dependency does not imply that every register operation must execute a kernel call.

## UMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked UMD commit; not intended requirements.

| ID | File / symbol | Observed behavior and limit |
|---|---|---|
| UMD-EV-005 | source/bos-umd/device/blackholeplus/cluster.h:300–316; source/bos-umd/device/blackholeplus/cluster.cpp:581–605 | Public register methods take chip_id_t, CoreCoord, uint64_t address and uint32_t size. Read takes a caller-supplied output buffer; both methods return void. |
| UMD-EV-007 | source/bos-umd/device/blackholeplus/local_chip.cpp:266–310 | Requires size divisible by four and address four-byte aligned, then dispatches DRAM or Tensix register access; invalid targets throw. These observed restrictions are not promoted into design requirements. |
| UMD-EV-007 | source/bos-umd/device/blackholeplus/blackhole_tt_device.cpp:843–959 | Tensix register range/static mapping is checked, a BAR2 register-region address is derived, then write_block/read_block accesses it. |
| UMD-EV-007 | source/bos-umd/device/blackholeplus/blackhole_tt_device.cpp:313–446,962–1018 | DRAM-core register addresses are translated and passed to BAR4 AP packet helpers. The shown helpers place/return one uint32_t value; word_len does not drive a multiword loop in these bodies. Timeout/error exits exist. Bulk-operation intent remains an owner question. |
| UMD-EV-004 | source/bos-umd/device/blackholeplus/pci_device.cpp:193–324 | BAR mappings exist from PCI-device construction and are later unmapped at destruction. These register methods do not make a new mmap call. |

## KMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked KMD commit; direct participation is distinguished from supporting facilities.

| ID | File / symbol | Observed behavior and boundary role |
|---|---|---|
| KMD-EV-004 / 005 | source/bos-kmd/memory.c:372–449,1186–1237; source/bos-kmd/chardev.c:403–408 | KMD returns mapping descriptors and creates BAR VMAs. This is supporting setup for the inspected register paths, not a register-payload API. |
| KMD-EV-003 | source/bos-kmd/ioctl.h:12–83; paired source/bos-umd/device/ioctl.h:18–83 | Device-info and mapping-query fields/IDs agree statically. This does not verify register semantics, cache policy or runtime compatibility. |
| KMD-EV-010 | source/bos-kmd/chardev.c:431–499 | File-owned state and cleanup exist separately from register reads/writes. No end-to-end reset, concurrent access or stale-mapping behavior is established. |
| KMD-EV-006 / 013 | source/bos-kmd/ioctl.h:268–295; source/bos-kmd/blackhole.c:152–175; source/bos-kmd/enumerate.c:119–127 | Retained KMD TLB configuration writes device registers, but is not shown to be the implementation of the two public UMD register functions. Its presence cannot replace the missing SAD contract or prove optional support in BLACKHOLEPLUS. |

## Traceability

Requirement / VC: **Not supplied**. Requirement → interface/flow → code and reverse interface → justifying requirement are both **Blocked**. The following table is supporting SAD-to-code alignment, not requirement compliance.

| SAD element | UMD evidence | KMD evidence | Alignment status | Gap / limitation |
|---|---|---|---|---|
| Public register operations | UMD-EV-005/007 | KMD supplies mappings, not this public declaration | Partial | Names correspond; chip selector, width, destination parameter and alignment contract are not aligned/defined. |
| Register mmap sequence | UMD-EV-004/007 | KMD-EV-005 | Conflicting | Mapped BAR2 or BAR4/AP transfers occur after setup; no per-operation mmap in the inspected paths. |
| Register value domain and outputs | Direct SAD:104–136 | Not needed for internal contradiction | Conflicting | Outputs name memory APIs; write address describes a memory region. |
| Requirement justification | Not supplied | Not supplied | Blocked | Register atomicity, side effects, ordering and multiword semantics cannot be invented. |

Reverse mapping: Tensix direct mapped register accesses and DRAM-core AP packets correspond to the broad register API but lack explicit architecture-level routing/ownership in the SAD. KMD TLB programming is a separate exposed mechanism. The length-bearing public API versus single-word AP helper requires a domain decision, not an inferred bulk-transfer requirement.

## Complete SAD-01 through SAD-09 checklist

`CONTROLLED RULE` — questions below reproduce the approved checklist. Results assess this interface, including explicitly applicable shared architecture evidence. SAD-04 uses the user-required `Blocked` exception. SAD-09 uses the approved scope/applicability rule. A missing-evidence result does not create a formal finding. Requirements-semantic coverage is separately limited even when an internal-consistency check is supported.

| ID | Controlled review question | Result | Note / basis |
|---|---|---|---|
| SAD-01 | Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined? | Fail | SAD-F-001: register setup/transfer ownership is not specified as separate UMD/KMD SWC contracts. |
| SAD-02 | Are component and external interfaces defined with their data/control flow, direction, and relevant constraints? | Fail | SAD-F-301: exact device selection, buffer/size/completion and possible failure contract are incomplete (GL:155,217–224). |
| SAD-03 | Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency? | Fail | SAD-F-302: mmap success does not describe the stated register processing/observable completion. No specific bulk/atomicity behavior is assumed. |
| SAD-04 | Are the software requirements appropriately allocated to components with bidirectional traceability? | Blocked | Controlled SRS unavailable; no requirement-based register semantics or bidirectional allocation can be established. |
| SAD-05 | Is the architecture semantically consistent with the software requirements and internally consistent across its views? | Fail | SAD-F-303: register outputs name memory APIs and the write address uses a memory-region description; these are direct inconsistencies. Requirements semantics remain unassessed. |
| SAD-06 | Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage? | Fail | SAD-F-002: required shared quality/constraint analysis is absent; code alignment/timeouts do not prove controlled quality compliance. |
| SAD-07 | Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable? | Fail | SAD-F-003: no shared feasibility result/rationale applicable to register access. |
| SAD-08 | Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded? | Fail | Missing applicability/suitability evidence, not a formal comparison violation. No reused component or meaningful alternative is established for this contract. |
| SAD-09 | Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable? | N/A | External planning/PM process assessment lies outside supplied controlled inputs. No interface-specific significant planning decision is established; REG-PLAN keeps the impact/applicability question open. |

## Findings

Formal findings below satisfy the criterion/applicability/direct-evidence gate. Shared IDs are repeated here with interface-specific applicability so this file is independently reviewable; the overall index counts them once. Drift and observations do not select code as the intended architecture.

### SAD-F-001 — Component responsibilities and design scopes are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-01

**Guideline / controlled criterion:** CL:17; GL §2.2:135,146–151 and §3:174–198. Identify component responsibilities/design scopes; black-box omission is conditional on an identified scope.

**Location:** SAD:20–48 and complete SAD:1–269

**Evidence:** DOCUMENT FACT — UMD and KMD are distinct static nodes and named participants, but only `SWC UMD` has an overview; its ID is blank. There is no KMD component definition or Design Scope/black-box designation. The sequence sends mmap to KMD but provides neither its contract nor who performs the register transaction after mapping.

**Issue:** Applicability to this interface: Kernel resource setup must be distinguished from register payload access and any AP-mediated processing. Distinct diagram nodes do not establish separately specified software components, and a black-box exemption cannot be assumed.

**Impact:** Responsibility and integration-test allocation can differ between implementers.

**Suggested correction:** State intended component identities, responsibilities and Design Scope; provide applicable internal detail or a justified black-box external contract. Do not derive intended decomposition solely from source files.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Device Register Access:102–137 and Device Register Write/Read:222–238. Implementation evidence: UMD-EV-004/005/007/010; KMD-EV-004/005/010.

### SAD-F-002 — Required quality and constraint analysis is absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-06

**Guideline / controlled criterion:** CL:22; GL §4:294 explicitly requires a quality/constraint analysis result and rationale, with explained N/A where appropriate; GL §§4.1–4.2:307–346 covers applicable timing/resource analysis.

**Location:** Complete SAD:1–269; SAD Device Register Access:102–137 and Device Register Write/Read:222–238

**Evidence:** DOCUMENT FACT — The complete SAD ends at the TLB sequence and contains no quality/constraint analysis result, timing/resource evaluation, or reasoned N/A. The interface has validity and positive-size conditions but no applicable register-access timing/resource/quality analysis.

**Issue:** The interface depends on the document-wide analysis that GL:294 expressly requires. One shared analysis may cover all interfaces; a separate numerical budget/report per API is not demanded.

**Impact:** The review lacks an evidence basis for architecture suitability against applicable constraints; no measured limit violation is claimed.

**Suggested correction:** Provide the author-owned shared analysis and identify its applicability to this interface, or justify inapplicable aspects. No reviewer-invented threshold or runtime test is prescribed.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Device Register Access:102–137 and Device Register Write/Read:222–238. Implementation evidence: Source mechanisms in UMD-EV-004/005/007/010; KMD-EV-004/005/010 do not replace controlled analysis.

### SAD-F-003 — Required feasibility result and rationale are absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-07

**Guideline / controlled criterion:** CL:23; GL §4:294 explicitly requires a technical-feasibility result and rationale; GL §4.3:381 applies to significant decisions without prescribing artificial alternatives.

**Location:** Complete SAD:1–269; SAD Device Register Access:102–137 and Device Register Write/Read:222–238

**Evidence:** DOCUMENT FACT — No technical-feasibility conclusion or supporting architecture rationale is present. The register-over-UMD/KMD arrangement is named and depicted without a feasibility conclusion or reasoning.

**Issue:** The explicit minimum feasibility evidence does not exist for the architecture on which this interface relies; significance of further decisions and applicable risks is not invented.

**Impact:** Reviewers cannot identify the basis and conditions under which the architecture is considered feasible.

**Suggested correction:** Record the shared feasibility result and basis, then the interface-relevant significant choices, assumptions and risks where applicable. Code existence is not feasibility proof.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Device Register Access:102–137 and Device Register Write/Read:222–238. Implementation evidence: UMD-EV-004/005/007/010; KMD-EV-004/005/010.

### SAD-F-301 — Register operation contract does not define key caller semantics

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:155,217–224 requires parameters, conditions and possible results sufficient for callers and testing.

**Location:** SAD:102–137

**Evidence:** DOCUMENT FACT — The table has no explicit device selector or full declaration, places dest only in an output table, supplies generic valid regions, and gives no failure or observable completion definition.

**Issue:** Buffer passing, selected device/address meaning and completion/failure behavior are not precise. No particular alignment, atomicity or multiword policy is inferred as intended.

**Impact:** Callers/tests can interpret the same register transaction differently.

**Suggested correction:** Define the intended argument, buffer, target, completion and failure contract; have the owner decide any relevant alignment/width/ordering constraints.

**Traceability:** Requirement / VC: Not supplied. SAD element: Register interface tables. Implementation evidence: UMD-EV-005/007; KMD-EV-004/005.

### SAD-F-302 — Register transaction behavior is absent from the sequence

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-03

**Guideline / controlled criterion:** CL:19,31; GL:238,240,255 requires major processing and observable results for meaningful runtime behavior.

**Location:** SAD:105,222–238

**Evidence:** DOCUMENT FACT — The sequence has the register API, KMD mmap(), success and return, but no register-transfer processing or completion condition. No controlled alternate dynamic view is referenced.

**Issue:** Mapping success alone does not describe the document's promised register behavior. The issue exists without imposing the implementation's Tensix/AP routing.

**Impact:** Architecture-level tests cannot identify the intended register operation and completion boundary.

**Suggested correction:** Describe the intended transaction steps, component responsibilities, conditions and completion at the necessary architectural level.

**Traceability:** Requirement / VC: Not supplied. SAD element: Device Register Write/Read. Implementation evidence: UMD-EV-007; KMD-EV-005 (supporting comparison).

### SAD-F-303 — Register table uses memory-operation labels and address terminology

**Classification:** Process / guideline finding

**Severity:** Minor

**Checklist:** SAD-05

**Guideline / controlled criterion:** CL:21; GL:93,221,224 requires consistent API names and parameter meanings.

**Location:** SAD:104–136

**Evidence:** DOCUMENT FACT — Operations are write_to_device_reg()/read_from_device_reg(), but outputs are labeled write_to_device()/read_from_device(). The write address says “Destination device memory address” / “Valid memory region”; the section's constraint specifies register addresses.

**Issue:** The table does not consistently identify its own operation/result and address domain.

**Impact:** Localized ambiguity can be copied into integration specifications; it is not a demonstrated runtime access error.

**Suggested correction:** Confirm and consistently name the register operations, outputs and intended register-address domain.

**Traceability:** Requirement / VC: Not supplied. SAD element: Register output labels and write address row. Implementation evidence: Not needed for direct internal contradiction.

### SAD-F-304 — Register signatures and alignment differ from the SAD tables

**Classification:** Implementation drift

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:217–224 provides comparison context; no source-derived requirement is asserted.

**Location:** SAD:110–136; source/bos-umd/device/blackholeplus/cluster.h:300–316; source/bos-umd/device/blackholeplus/local_chip.cpp:266–310

**Evidence:** DOCUMENT FACT — size_t size >0 and no explicit chip argument are listed. IMPLEMENTATION EVIDENCE — public functions use uint32_t plus chip_id_t; read fills a supplied buffer; LocalChip requires address and size multiples of four.

**Issue:** The declared domains and concrete signature do not map directly. Whether the SAD is intended as a conceptual interface or exact API is unresolved.

**Impact:** A caller/test based on one artifact can use a different target or validation rule than the other.

**Suggested correction:** Owner to select intended contract/variant and reconcile both sides; do not automatically copy current code limits.

**Traceability:** Requirement / VC: Not supplied. SAD element: Register parameter/constraint tables. Implementation evidence: UMD-EV-005/007.

### SAD-F-305 — Register access reuses established mappings in the inspected source

**Classification:** Implementation drift

**Checklist:** SAD-03

**Guideline / controlled criterion:** CL:19; GL:238–257 provides dynamic-alignment context only.

**Location:** SAD:230–236; source/bos-umd/device/blackholeplus/pci_device.cpp:193–324; source/bos-umd/device/blackholeplus/blackhole_tt_device.cpp:843–1018

**Evidence:** DOCUMENT FACT — the sequence places mmap after each register call. IMPLEMENTATION EVIDENCE — constructor-time BAR mappings support subsequent Tensix BAR2 or DRAM-core BAR4/AP register operations; KMD mmap establishes the VMA.

**Issue:** The described order/lifetime differs from the inspected default path. Neither the source nor the simplified diagram establishes the intended architecture by itself.

**Impact:** Integration can confuse mapping setup with execution/completion of register operations.

**Suggested correction:** Reconcile the intended setup/access lifecycle and routing with architecture-owner confirmation.

**Traceability:** Requirement / VC: Not supplied. SAD element: Register dynamic view. Implementation evidence: UMD-EV-004/007; KMD-EV-005.

## Decisions required and open issues

| ID | Classification | Decision / missing evidence |
|---|---|---|
| REG-REQ | Missing evidence | Controlled requirements are not supplied. SAD-04 is Blocked, not Fail; forward allocation and reverse justification cannot be established. Requirements-semantic consistency also remains unassessed. New requirements require renewed scope approval. |
| REG-REUSE | Missing evidence | The target does not establish whether this interface embodies a reused component or meaningful alternative selection. SAD-08 cannot be accepted on current applicability evidence; no substantive reuse/comparison violation or artificial alternative is invented. |
| REG-PLAN | Decision required | SAD-09 is N/A to external project/PM process assessment within these supplied inputs. This scope-qualified result does not mean no planning impact. The document has no evaluation/no-impact statement, but the review does not infer an interface-specific significant planning decision or an external failure from that absence. An owner must settle applicability and point to the appropriate controlled record if review is requested. |
| REG-VARIANT | Decision required | Identify the intended architecture/build variant and supported interface contract. Source defaults and nearby API analogues do not establish that intent. |
| REG-WIDTH | Decision required | Resolve supported size/width semantics. The AP helpers transfer one uint32_t in the inspected bodies despite a length-bearing public API; this is not a proved bulk-register defect without intended semantics. |
| REG-ORDER | Missing evidence | Atomicity, side effects, completion/ordering, concurrent AP use and recovery assumptions are not established by this SAD or a controlled SRS. |
| REG-ROUTE | Decision required | Determine intended register target domains and whether Tensix direct mapping versus AP-mediated access belongs in the architecture contract. |

## Coverage limitations

Read-only static inspection; no build, hardware, runtime, concurrency, fault-injection, throughput or deployed ABI test. UMD evidence follows the checked-in default `EAGLE_AS_TT=ON` BOS chain (`source/bos-umd/CMakeLists.txt:58–62`, `source/bos-umd/device/CMakeLists.txt:64–92`); generic branches were inspected only for selection/correspondence and are not exhaustively verified. KMD defaults to `BLACKHOLEPLUS` (`source/bos-kmd/Makefile:13–14`). Neither default establishes intended/deployed configuration. No firmware, hardware specification, external wrapper or additional controlled reference is assumed. All relevant preserved SAD Mermaid text was inspected; absent guideline example images were not reconstructed. Checklist status is `unknown`, as approved. No external tickets, PM messages or stakeholder approvals are created or implied.

Register-specific alignment was inspected, but no hardware side effects, atomicity, ordering, multiword transfer, fault handling or AP response was tested. Comments and disabled assertions are not treated as active checks or architectural requirements.

## Final interface result

**Assessed interface result: Fail. Requirements coverage: Blocked. SAD-09: N/A within the stated assessment scope.**

The register interface fails assessed documentary criteria independently of missing SRS/PM evidence. Direct table inconsistencies and qualified signature/mapping differences are separated. Single-word AP behavior remains a decision rather than an invented implementation requirement.

The scoped review is complete; this is not full requirements acceptance, a runtime validation result, or stakeholder approval. No controlled input/source was changed. Scope-lock verification preceded analysis; final verification is recorded in the overall report.

