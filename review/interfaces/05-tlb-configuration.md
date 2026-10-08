# TLB Configuration — Independent SAD Interface Review

Scope version 2, approved 2026-10-07; [approved scope](../scope.md), [verified scope lock](../scope.lock). UMD: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`; KMD: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`. SAD revision 0.1 (2026-09-15); checklist/guideline snapshots 2026-10-07. Their exact hashes are locked.

Citation keys: **SAD** = `review-input/sad/umd-kmd-sad.md`; **CL** = `review-input/checklist/sad-review-checklist.md`; **GL** = `review-input/guideline/sad-writing-guideline.md`. Source citations are workspace-relative, with one-based line spans. Evidence classes are explicit: `CONTROLLED RULE`, `DOCUMENT FACT`, `IMPLEMENTATION EVIDENCE`, `ASSUMPTION`, `REVIEW OBSERVATION`, `OPEN ISSUE`. No assumption supplies intended architecture or a formal finding.

This is an independent interface assessment. Shared finding IDs SAD-F-001–003 denote the same cross-cutting issue, applied explicitly here and counted once in the overall index. Interface-specific findings use the 100/200/300/400/500 series; IDs are version-2 records, not the earlier aggregate register. Shared evidence was generated after all five interface files were complete.

## Interface scope

The documented get_static_tlb_window() retrieval contract, target/window representation, existing-mapping precondition, mapping ownership and UMD/KMD supporting boundary. KMD allocation/configuration and UMD writer APIs are examined for correspondence, not assumed to implement this getter.

## SAD contract

| Contract element | DOCUMENT FACT and location |
|---|---|
| Identity | SAD:162–164 titles the interface TLB Configuration and names get_static_tlb_window(). |
| Purpose | SAD:165: “Retrieves the static TLB window associated with the specified device address or TLB configuration. The returned window is used for PCIe BAR-based device access.” |
| Input | SAD:170: Device Address/ TLB Identifier target; the prose permits either a target address or static TLB entry, without precise encoding or selection rules. |
| Output | SAD:172 incorrectly labels Output as write_to_device(); SAD:177 describes TLB Window window / valid mapped window, without concrete type or ownership/lifetime. |
| Precondition | SAD:179: “A valid static TLB mapping shall exist for the requested device address or TLB index.” |
| Dynamic flow | SAD:265–267: tt-metal → UMD: get_static_tlb_window(), UMD → tt-metal: return window. KMD is not a participant. |

## Component model and consistency across views

The static TLB Configuration edge (SAD:45) and detailed/dynamic operation names (164,265) correspond. The title suggests configuration while the description expressly says retrieval of an existing mapping; that is an unresolved abstraction/terminology question, not proof the getter must configure hardware. The Output label write_to_device() is a direct contradiction with the operation association.

UMD and KMD are separate nodes in the overall graph but only UMD has a component overview. **The absence of KMD from this getter's sequence is not itself a defect:** an existing userspace mapping may support retrieval. The intended mapping owner/lifetime and prerequisite-establishment relationship remain unspecified; current code cannot decide them.

## UMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked UMD commit; not intended requirements.

| ID | File / symbol | Observed behavior and limit |
|---|---|---|
| UMD-EV-009 | Whole tracked source/bos-umd C/C++ name search | No occurrence of get_static_tlb_window in tracked *.cpp, *.cc, *.c, *.h or *.hpp files; git grep returned exit 1. This is a bounded exact-name search, not proof about outside wrappers or deployed artifacts. |
| UMD-EV-009 | source/bos-umd/device/blackholeplus/cluster.h:389–399; source/bos-umd/device/blackholeplus/cluster.cpp:376–377 | Nearby API is tt::Writer get_static_tlb_writer(chip_id_t chip, CoreCoord target). Its header requires an existing mapping, unchanged mapping during writer lifetime and Cluster outliving the writer. These are source contract comments, not controlled SAD requirements. |
| UMD-EV-009 | source/bos-umd/device/blackholeplus/local_chip.cpp:75–94; source/bos-umd/device/blackholeplus/tlb_manager.cpp:22–42,60–111 | Local initialization populates memory/register core maps. TLBManager's getter checks a mapped core/BAR2, derives address/size and constructs a Writer. This source path does not invoke KMD CONFIGURE_TLB for the retrieval. |
| UMD-EV-009 | source/bos-umd/device/blackholeplus/cluster.cpp:400–411; source/bos-umd/device/blackholeplus/tlb_manager.cpp:44–49 | Public configure_tlb and dynamic configuration setters throw in the inspected BOS path. Their presence does not establish supported dynamic reconfiguration. |
| UMD-EV-004 | source/bos-umd/device/blackholeplus/pci_device.cpp:193–324 | The supporting BAR2 mapping is established in device construction and unmapped during destruction. |

## KMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked KMD commit; direct participation is distinguished from supporting facilities.

| ID | File / symbol | Observed behavior and boundary role |
|---|---|---|
| KMD-EV-004 / 005 | source/bos-kmd/memory.c:372–449,1186–1237 | Mapping descriptors and BAR VMAs support later userspace access. This broad dependency does not require a syscall on every getter call. |
| KMD-EV-006 | source/bos-kmd/ioctl.h:238–295; source/bos-kmd/memory.c:906–1004 | Separate ALLOCATE_TLB/CONFIGURE_TLB/FREE_TLB operations return IDs/offsets, check per-file ownership and reject freeing mapped windows with -EBUSY. These are different operations from the SAD's existing-window getter. |
| KMD-EV-006 | source/bos-kmd/memory.c:1065–1114,1221–1227 | Allocated TLB-window VMAs have reference callbacks and reject splitting. This file-owned kernel path is not shown to be used by the BOS static writer chain. |
| KMD-EV-013 | source/bos-kmd/Makefile:13–14; source/bos-kmd/enumerate.c:119–127; source/bos-kmd/blackhole.c:804–838,992–1014 | Selected probe initialization skips kernel mapping/TLB setup while callback definitions remain. Optional callback support is unresolved, not a reproduced fault. |

## Traceability

Requirement / VC: **Not supplied**. Requirement → interface/flow → code and reverse interface → justifying requirement are both **Blocked**. The following table is supporting SAD-to-code alignment, not requirement compliance.

| SAD element | UMD evidence | KMD evidence | Alignment status | Gap / limitation |
|---|---|---|---|---|
| get_static_tlb_window identity/type | UMD-EV-009: exact name absent; Writer analogue differs | KMD-EV-006 is separate allocation/configuration | Missing | Do not replace getter with writer or ioctl without an explicit mapping. |
| Existing static mapping precondition | UMD-EV-004/009 | KMD-EV-004/005 provides supporting BAR mappings | Partial | Broad support exists; target identity, window lifetime and intended owner remain undefined. |
| UMD-only retrieval sequence | Nearby getter uses existing BAR2 mapping | No per-getter KMD call demonstrated/required | Partial | No contradiction is inferred merely because KMD is absent from this sequence. |
| Requirement justification | Not supplied | Not supplied | Blocked | No allocation, lifetime or performance requirement is invented. |

Reverse mapping: The returned Writer, core/chip inputs and caller lifetime rules have no exact mapping to the SAD's address/TLB identifier and TLB Window. Kernel allocated-TLB ownership is a separate exposed facility. Source preconditions cannot be promoted into intended requirements, and kernel capability presence does not prescribe a new getter interaction.

## Complete SAD-01 through SAD-09 checklist

`CONTROLLED RULE` — questions below reproduce the approved checklist. Results assess this interface, including explicitly applicable shared architecture evidence. SAD-04 uses the user-required `Blocked` exception. SAD-09 uses the approved scope/applicability rule. A missing-evidence result does not create a formal finding. Requirements-semantic coverage is separately limited even when an internal-consistency check is supported.

| ID | Controlled review question | Result | Note / basis |
|---|---|---|---|
| SAD-01 | Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined? | Fail | SAD-F-001: mapping ownership and component design scope remain unspecified. Separate graph nodes exist; no extra KMD getter message is demanded. |
| SAD-02 | Are component and external interfaces defined with their data/control flow, direction, and relevant constraints? | Fail | SAD-F-501: target address versus identifier, window type/ownership/lifetime and possible results are incomplete (GL:217–224). |
| SAD-03 | Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency? | Fail | Missing evidence rather than a formal dynamic-view finding: the simple synchronous success sequence exists, but mapping-state/lifetime dependencies and applicable verification coverage are unestablished. TLB-DYNAMIC records this limitation; no Activity Diagram or per-call KMD interaction is prescribed. |
| SAD-04 | Are the software requirements appropriately allocated to components with bidirectional traceability? | Blocked | No controlled SRS; bidirectional requirement allocation and justification cannot be established. |
| SAD-05 | Is the architecture semantically consistent with the software requirements and internally consistent across its views? | Fail | SAD-F-503: Output is labeled write_to_device() despite get_static_tlb_window()/TLB Window. Title-versus-getter terminology is separately an unresolved observation, not another proved contradiction. |
| SAD-06 | Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage? | Fail | SAD-F-002: required shared quality/constraint analysis is absent; source TLB sizes are not controlled resource budgets. |
| SAD-07 | Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable? | Fail | SAD-F-003: no shared feasibility result/rationale applicable to the static-window architecture. |
| SAD-08 | Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded? | Fail | Missing evidence only: neither actual reuse/meaningful alternative applicability nor a reasoned N/A is established. Nearby source facilities do not prove an intended architecture selection. |
| SAD-09 | Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable? | N/A | External planning/PM process assessment is outside the supplied inputs and no interface-specific significant planning decision is established. TLB-PLAN records unresolved applicability without an automatic failure. |

## Findings

Formal findings below satisfy the criterion/applicability/direct-evidence gate. Shared IDs are repeated here with interface-specific applicability so this file is independently reviewable; the overall index counts them once. Drift and observations do not select code as the intended architecture.

### SAD-F-001 — Component responsibilities and design scopes are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-01

**Guideline / controlled criterion:** CL:17; GL §2.2:135,146–151 and §3:174–198. Identify component responsibilities/design scopes; black-box omission is conditional on an identified scope.

**Location:** SAD:20–48 and complete SAD:1–269

**Evidence:** DOCUMENT FACT — UMD and KMD are distinct static nodes and named participants, but only `SWC UMD` has an overview; its ID is blank. There is no KMD component definition or Design Scope/black-box designation. The overall graph names KMD, but neither a component definition nor ownership of this getter's required existing mapping is specified.

**Issue:** Applicability to this interface: A userspace retrieval depends on resources whose creation and ownership cross a kernel boundary even if retrieval makes no kernel call. Distinct diagram nodes do not establish separately specified software components, and a black-box exemption cannot be assumed.

**Impact:** Responsibility and integration-test allocation can differ between implementers.

**Suggested correction:** State intended component identities, responsibilities and Design Scope; provide applicable internal detail or a justified black-box external contract. Do not derive intended decomposition solely from source files.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD TLB Configuration:162–180 and dynamic sequence:258–269. Implementation evidence: UMD-EV-004/009; KMD-EV-004/005/006/013.

### SAD-F-002 — Required quality and constraint analysis is absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-06

**Guideline / controlled criterion:** CL:22; GL §4:294 explicitly requires a quality/constraint analysis result and rationale, with explained N/A where appropriate; GL §§4.1–4.2:307–346 covers applicable timing/resource analysis.

**Location:** Complete SAD:1–269; SAD TLB Configuration:162–180 and dynamic sequence:258–269

**Evidence:** DOCUMENT FACT — The complete SAD ends at the TLB sequence and contains no quality/constraint analysis result, timing/resource evaluation, or reasoned N/A. The existing-mapping precondition and BAR-use statement (SAD:165,179) provide no quality/resource evaluation or justified applicability conclusion.

**Issue:** The interface depends on the document-wide analysis that GL:294 expressly requires. One shared analysis may cover all interfaces; a separate numerical budget/report per API is not demanded.

**Impact:** The review lacks an evidence basis for architecture suitability against applicable constraints; no measured limit violation is claimed.

**Suggested correction:** Provide the author-owned shared analysis and identify its applicability to this interface, or justify inapplicable aspects. No reviewer-invented threshold or runtime test is prescribed.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD TLB Configuration:162–180 and dynamic sequence:258–269. Implementation evidence: Source mechanisms in UMD-EV-004/009; KMD-EV-004/005/006/013 do not replace controlled analysis.

### SAD-F-003 — Required feasibility result and rationale are absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-07

**Guideline / controlled criterion:** CL:23; GL §4:294 explicitly requires a technical-feasibility result and rationale; GL §4.3:381 applies to significant decisions without prescribing artificial alternatives.

**Location:** Complete SAD:1–269; SAD TLB Configuration:162–180 and dynamic sequence:258–269

**Evidence:** DOCUMENT FACT — No technical-feasibility conclusion or supporting architecture rationale is present. The architecture's static-window access arrangement has no shared feasibility result or supporting rationale.

**Issue:** The explicit minimum feasibility evidence does not exist for the architecture on which this interface relies; significance of further decisions and applicable risks is not invented.

**Impact:** Reviewers cannot identify the basis and conditions under which the architecture is considered feasible.

**Suggested correction:** Record the shared feasibility result and basis, then the interface-relevant significant choices, assumptions and risks where applicable. Code existence is not feasibility proof.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD TLB Configuration:162–180 and dynamic sequence:258–269. Implementation evidence: UMD-EV-004/009; KMD-EV-004/005/006/013.

### SAD-F-501 — Static-window target and result contract are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:217–224 requires exact parameters, types, conditions and possible results sufficient for integration/testing.

**Location:** SAD:162–180

**Evidence:** DOCUMENT FACT — target is typed “Device Address/ TLB Identifier”; output is “TLB Window”; no address-versus-index selection rule, concrete result representation, ownership/lifetime or failure outcome is defined.

**Issue:** The existing-mapping precondition does not settle the callable contract or how the returned information remains valid. Whether it is a copied descriptor or a live access handle is not established.

**Impact:** Callers can interpret target selection and result use differently.

**Suggested correction:** Owner to define intended API/variant, input and output representation, relevant validity/lifetime and possible outcomes; do not assume the source Writer is the intended result.

**Traceability:** Requirement / VC: Not supplied. SAD element: TLB interface contract. Implementation evidence: UMD-EV-009; KMD-EV-006 (comparison, not intended truth).

### SAD-F-503 — TLB result is associated with a memory-write operation

**Classification:** Process / guideline finding

**Severity:** Minor

**Checklist:** SAD-05

**Guideline / controlled criterion:** CL:21; GL:93,224 requires consistent interface names and descriptions.

**Location:** SAD:164,172,177

**Evidence:** DOCUMENT FACT — the section declares get_static_tlb_window() and output type TLB Window, but its Output label is write_to_device().

**Issue:** The output contract is attributed to an operation different from the one being specified.

**Impact:** Localized result-association ambiguity can propagate into interface references.

**Suggested correction:** Associate the output with the confirmed intended getter operation.

**Traceability:** Requirement / VC: Not supplied. SAD element: TLB output table. Implementation evidence: Not required for direct document contradiction.

### SAD-F-504 — Named static-window getter has no exact source counterpart

**Classification:** Implementation drift

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:217,224 provides exact-API comparison context; intended API identity is unresolved.

**Location:** SAD:164–179,265–267; source/bos-umd/device/blackholeplus/cluster.h:389–399; bounded tracked C/C++ search

**Evidence:** DOCUMENT FACT — get_static_tlb_window() takes a device address/TLB identifier and returns TLB Window. IMPLEMENTATION EVIDENCE — the exact name is absent from the searched files; nearby get_static_tlb_writer takes chip/core and returns tt::Writer.

**Issue:** The available implementations do not establish equivalence. Generic source TLB objects and KMD allocation/configuration are not substitutes for an exact API mapping.

**Impact:** Caller code cannot bind the documented getter to a verified entry point/result contract.

**Suggested correction:** Domain owner decision required: identify intended API and result/lifetime semantics, then reconcile the artifacts without assuming which should change.

**Traceability:** Requirement / VC: Not supplied. SAD element: TLB contract and getter sequence. Implementation evidence: UMD-EV-009; KMD-EV-006.

## Decisions required and open issues

| ID | Classification | Decision / missing evidence |
|---|---|---|
| TLB-REQ | Missing evidence | Controlled requirements are not supplied. SAD-04 is Blocked, not Fail; forward allocation and reverse justification cannot be established. Requirements-semantic consistency also remains unassessed. New requirements require renewed scope approval. |
| TLB-REUSE | Missing evidence | The target does not establish whether this interface embodies a reused component or meaningful alternative selection. SAD-08 cannot be accepted on current applicability evidence; no substantive reuse/comparison violation or artificial alternative is invented. |
| TLB-PLAN | Decision required | SAD-09 is N/A to external project/PM process assessment within these supplied inputs. This scope-qualified result does not mean no planning impact. The document has no evaluation/no-impact statement, but the review does not infer an interface-specific significant planning decision or an external failure from that absence. An owner must settle applicability and point to the appropriate controlled record if review is requested. |
| TLB-VARIANT | Decision required | Identify the intended architecture/build variant and supported interface contract. Source defaults and nearby API analogues do not establish that intent. |
| TLB-DYNAMIC | Missing evidence | The normal request/return flow is documented. Applicable mapping state, invalidation, lifetime and failure interactions are not sufficiently established to close SAD-03; no extra kernel call or complex algorithm is invented. This explains an evidence-acceptance Fail without a formal violation. |
| TLB-BINDING | Decision required | Resolve address-versus-ID target, metadata-versus-live-handle result, and whether the named API is intended or needs an explicit correspondence to another operation. |
| TLB-OWNER | Decision required | Identify who establishes and owns the mapping, its valid lifetime, and supported static versus dynamic facilities. Do not equate BOS userspace core maps with KMD allocated TLB objects. |
| TLB-TERM | Review observation | TLB Configuration title versus retrieval description is a terminology/scope question; the description does not itself claim that this call reconfigures hardware. |

## Coverage limitations

Read-only static inspection; no build, hardware, runtime, concurrency, fault-injection, throughput or deployed ABI test. UMD evidence follows the checked-in default `EAGLE_AS_TT=ON` BOS chain (`source/bos-umd/CMakeLists.txt:58–62`, `source/bos-umd/device/CMakeLists.txt:64–92`); generic branches were inspected only for selection/correspondence and are not exhaustively verified. KMD defaults to `BLACKHOLEPLUS` (`source/bos-kmd/Makefile:13–14`). Neither default establishes intended/deployed configuration. No firmware, hardware specification, external wrapper or additional controlled reference is assumed. All relevant preserved SAD Mermaid text was inspected; absent guideline example images were not reconstructed. Checklist status is `unknown`, as approved. No external tickets, PM messages or stakeholder approvals are created or implied.

This review establishes no supported TLB allocation limits, hardware translation correctness, configuration safety or deployed callback support. Exact-name search is bounded to the recorded tracked C/C++ patterns. Runtime getter behavior and mapping invalidation were not tested.

## Final interface result

**Assessed interface result: Fail. Requirements coverage: Blocked. SAD-09: N/A within the stated assessment scope.**

The assessed result is Fail from component/contract, direct output-label and shared-analysis findings, independent of missing requirements. SAD-03 and SAD-08 additionally retain explicit missing-evidence limitations without invented formal violations. KMD absence from the getter sequence is not treated as a defect.

The scoped review is complete; this is not full requirements acceptance, a runtime validation result, or stakeholder approval. No controlled input/source was changed. Scope-lock verification preceded analysis; final verification is recorded in the overall report.

