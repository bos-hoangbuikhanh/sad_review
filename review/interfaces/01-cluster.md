# Cluster — Independent SAD Interface Review

Scope version 2, approved 2026-10-07; [approved scope](../scope.md), [verified scope lock](../scope.lock). UMD: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`; KMD: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`. SAD revision 0.1 (2026-09-15); checklist/guideline snapshots 2026-10-07. Their exact hashes are locked.

Citation keys: **SAD** = `review-input/sad/umd-kmd-sad.md`; **CL** = `review-input/checklist/sad-review-checklist.md`; **GL** = `review-input/guideline/sad-writing-guideline.md`. Source citations are workspace-relative, with one-based line spans. Evidence classes are explicit: `CONTROLLED RULE`, `DOCUMENT FACT`, `IMPLEMENTATION EVIDENCE`, `ASSUMPTION`, `REVIEW OBSERVATION`, `OPEN ISSUE`. No assumption supplies intended architecture or a formal finding.

This is an independent interface assessment. Shared finding IDs SAD-F-001–003 denote the same cross-cutting issue, applied explicitly here and counted once in the overall index. Interface-specific findings use the 100/200/300/400/500 series; IDs are version-2 records, not the earlier aggregate register. Shared evidence was generated after all five interface files were complete.

## Interface scope

Cluster creation/initialization for host-detected accelerator devices, its application caller, discovery/identity dependencies, and the UMD/KMD startup boundary. Topology is examined only as the Overview's stated cluster responsibility; no new topology interface or requirement is introduced.

## SAD contract

| Contract element | DOCUMENT FACT and location |
|---|---|
| Identity/purpose | SAD:52–54 names Cluster() and says it provides “cluster creation and initialization for the accelerator devices detected on the host system.” |
| Inputs | SAD:55 says “None”. |
| Output | SAD:60 explicitly says “Constructors do not return a value. A Cluster instance is created as the result of construction.” This is object creation, not an asserted constructor return value. |
| Constraints/results | SAD:62 is “-”; no failure outcome, initialization-completion condition, or cleanup responsibility is defined. |
| Interaction | SAD:194–200 shows tt-metal → UMD: cluster(), UMD → KMD: open(), success, then Cluster object. |
| Context | SAD:26–28 gives UMD cluster/topology responsibilities and requires KMD; SAD:41 labels the caller edge Cluster Management. |

## Component model and consistency across views

UMD and KMD **are drawn as separate nodes and sequence participants** (SAD:38–39,191–192). They are **not separately specified as software components**: only SWC UMD has an overview, its ID is blank, and no KMD overview or Design Scope exists. Cluster is a label within UMD, not an independently defined SWC.

The Overview, Cluster Management edge, no-argument construction table and object-creation sequence have a consistent basic meaning. The sequence's lowercase cluster() differs from Cluster(); without a defined notation rule, treat this as a naming observation requiring clarification, not proof of a different operation. Advertised topology/architecture-description capabilities have no exact API mapping in the target; this is contract incompleteness, not proof that construction must implement a particular discovery algorithm. Requirements semantics remain unassessed.

## UMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked UMD commit; not intended requirements.

| ID | File / symbol | Observed behavior and limit |
|---|---|---|
| UMD-EV-001 | source/bos-umd/CMakeLists.txt:58–62; source/bos-umd/device/CMakeLists.txt:64–92 | EAGLE_AS_TT defaults ON and selects Blackholeplus/BOS source paths. This establishes the inspected default, not a deployed/intended configuration. |
| UMD-EV-003 | source/bos-umd/device/blackholeplus/cluster.h:29–59,82; cluster.cpp:265–334 in the same directory; ClusterOptions / Cluster::Cluster | The constructor accepts defaulted options, so Cluster() is callable with no arguments. It verifies option combinations, creates/uses a descriptor, chooses logical chip IDs and constructs local chips. Optional arguments alone do not contradict the SAD's no-input example. |
| UMD-EV-002 | source/bos-umd/device/blackholeplus/pci_device.cpp:105–165; PCIDevice::enumerate_devices / enumerate_devices_info | Scans numeric /dev/bos entries, queries identity, and skips failed per-node information opens/queries. The SAD does not state an enumeration-failure policy. |
| UMD-EV-003 | source/bos-umd/device/blackholeplus/cluster.cpp:738–794; create_cluster_descriptor | Enumerates PCI device numbers, creates local chips, assigns logical IDs, and records logical-to-PCI mappings. This is not proof of all advertised topology discovery behavior. |
| UMD-EV-004 | source/bos-umd/device/blackholeplus/pci_device.cpp:170–324; PCIDevice constructor/destructor | Opens the node, obtains device info and mapping descriptors, maps BAR0 WC/BAR2 UC/BAR4 UC, saves them, and later closes/unmaps. Construction is more than the diagram's one open call. |
| UMD-EV-011 | source/bos-umd/device/blackholeplus/local_chip.cpp:28–94; source/bos-umd/device/blackholeplus/blackhole_tt_device.cpp:19–24; source/bos-umd/device/blackholeplus/cluster.cpp:662–678 | Construction initializes local TLB/host-memory/mutex resources and requests MPU initialization. Separate start_device and close_device paths exist. Constructor completion and all possible readiness effects must not be equated without a controlled contract. |

## KMD implementation evidence

`IMPLEMENTATION EVIDENCE` — observed at the locked KMD commit; direct participation is distinguished from supporting facilities.

| ID | File / symbol | Observed behavior and boundary role |
|---|---|---|
| KMD-EV-002 | source/bos-kmd/enumerate.c:48–147; source/bos-kmd/chardev.c:81–104 | Probe allocates a per-PCI-device ordinal; character devices are named bos/N. KMD provides device instances, not a UMD Cluster object. |
| KMD-EV-010 | source/bos-kmd/chardev.c:431–499; tt_cdev_open / tt_cdev_release | Open allocates per-file state and holds a device reference; release cleans file-owned resources and TLB/lock ownership. This is a distinct lifetime from UMD cluster construction. |
| KMD-EV-003 / 004 | source/bos-kmd/ioctl.h:12–83; source/bos-kmd/chardev.c:111–142; source/bos-kmd/memory.c:372–449 | Device-info and mapping-query commands, field order and mapping IDs agree with source/bos-umd/device/ioctl.h:18–83. UMD requests eight mapping slots; KMD returns up to six valid records and clears extras. Positive static agreement is limited to these exchanges. |
| KMD-EV-013 | source/bos-kmd/Makefile:13–14; source/bos-kmd/enumerate.c:119–127; source/bos-kmd/blackhole.c:804–838,992–1014 | BLACKHOLEPLUS skips certain kernel initialization at probe while callbacks remain defined. Supported optional callbacks/readiness must be established by the owner; this is not a demonstrated runtime defect. |

## Traceability

Requirement / VC: **Not supplied**. Requirement → interface/flow → code and reverse interface → justifying requirement are both **Blocked**. The following table is supporting SAD-to-code alignment, not requirement compliance.

| SAD element | UMD evidence | KMD evidence | Alignment status | Gap / limitation |
|---|---|---|---|---|
| No-argument constructor | UMD-EV-003 | KMD does not construct a C++ Cluster | Covered | Defaulted options support the no-argument example; full initialization semantics remain partial. |
| Detected devices / identity | UMD-EV-002/003 | KMD-EV-002/003 | Partial | Logical chip ID, node ordinal and PCI BDF are distinct; SAD does not specify selection/mapping. |
| Open/init sequence | UMD-EV-004/011 | KMD-EV-003/004/010 | Partial | Open is supported; query/map/setup/start/release phases are not specified by the sequence. Omission alone does not prove the SAD denies them. |
| Requirement allocation and reverse justification | Not supplied | Not supplied | Blocked | No controlled SRS; no IDs or acceptance conditions invented. |

Reverse mapping: Descriptor/discovery work maps broadly to cluster/topology responsibilities; persistent PCI resources map to the named KMD dependency. Separate start/close and per-file cleanup have no explicit SAD lifecycle allocation. Code cannot resolve when a Cluster is intended to be ready or which component owns a rollback.

## Complete SAD-01 through SAD-09 checklist

`CONTROLLED RULE` — questions below reproduce the approved checklist. Results assess this interface, including explicitly applicable shared architecture evidence. SAD-04 uses the user-required `Blocked` exception. SAD-09 uses the approved scope/applicability rule. A missing-evidence result does not create a formal finding. Requirements-semantic coverage is separately limited even when an internal-consistency check is supported.

| ID | Controlled review question | Result | Note / basis |
|---|---|---|---|
| SAD-01 | Are the software components, their responsibilities, boundaries, relationships, and external/reused elements clearly defined? | Fail | SAD-F-001: distinct nodes exist, but SWC identity/design scope and cluster/open ownership are incomplete (CL:17; GL:135,146–151). |
| SAD-02 | Are component and external interfaces defined with their data/control flow, direction, and relevant constraints? | Fail | SAD-F-101: success/readiness, possible failure and required KMD contract are undefined. The no-argument constructor itself is supported (CL:18; GL:155,219–224). |
| SAD-03 | Are component-level behaviors and interactions defined for applicable modes, startup/shutdown, error/recovery flows, and concurrency? | Fail | SAD-F-102: the stated initialization behavior is reduced to successful open/object creation without major component processing or completion conditions (CL:19,31; GL:238–255). |
| SAD-04 | Are the software requirements appropriately allocated to components with bidirectional traceability? | Blocked | No controlled SRS or allocation evidence; apply the explicit scope override. Do not infer a failed requirement from source behavior. |
| SAD-05 | Is the architecture semantically consistent with the software requirements and internally consistent across its views? | Pass | Internal-view portion only: the Overview, static caller edge and creation contract/sequence agree on basic Cluster creation. Lowercase cluster() is an unresolved notation observation. Requirements-semantic consistency is NOT passed; it remains unassessed with SAD-04 Blocked. |
| SAD-06 | Does the Architecture Analysis address applicable quality characteristics and constraints, including timing/performance and resource usage? | Fail | SAD-F-002: the explicit minimum shared quality/constraint analysis is absent; no startup/resource threshold is invented. |
| SAD-07 | Have significant architecture decisions been evaluated for technical feasibility, with rationale, assumptions, risks, and potential negative impacts recorded where applicable? | Fail | SAD-F-003: no shared feasibility result/rationale applicable to this initialization architecture. |
| SAD-08 | Where reuse or a meaningful alternative/reference architecture exists, is suitability or selection rationale recorded? | Fail | Missing evidence, not a formal reuse violation: actual reuse/meaningful alternative applicability and a reasoned N/A are not established (CL:24; GL:294,383,418–445). |
| SAD-09 | Has the impact of significant architecture decisions on project estimate/planning been evaluated and communicated to PM when applicable? | N/A | Scope-qualified external planning/PM assessment: no project/PM records are supplied or included, and no interface-specific significant planning decision is established. Record CLU-PLAN; this does not assert no planning impact or failed PM communication. |

## Findings

Formal findings below satisfy the criterion/applicability/direct-evidence gate. Shared IDs are repeated here with interface-specific applicability so this file is independently reviewable; the overall index counts them once. Drift and observations do not select code as the intended architecture.

### SAD-F-001 — Component responsibilities and design scopes are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-01

**Guideline / controlled criterion:** CL:17; GL §2.2:135,146–151 and §3:174–198. Identify component responsibilities/design scopes; black-box omission is conditional on an identified scope.

**Location:** SAD:20–48 and complete SAD:1–269

**Evidence:** DOCUMENT FACT — UMD and KMD are distinct static nodes and named participants, but only `SWC UMD` has an overview; its ID is blank. There is no KMD component definition or Design Scope/black-box designation. The Cluster sequence delegates open to KMD but defines no KMD-provided identity/open/lifetime contract.

**Issue:** Applicability to this interface: Cluster construction crosses a per-device, per-file kernel boundary while returning a user-owned cluster object. Distinct diagram nodes do not establish separately specified software components, and a black-box exemption cannot be assumed.

**Impact:** Responsibility and integration-test allocation can differ between implementers.

**Suggested correction:** State intended component identities, responsibilities and Design Scope; provide applicable internal detail or a justified black-box external contract. Do not derive intended decomposition solely from source files.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Cluster():52–63 and Cluster Construction:186–202. Implementation evidence: UMD-EV-002/003/004/011/013; KMD-EV-002/003/004/010.

### SAD-F-002 — Required quality and constraint analysis is absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-06

**Guideline / controlled criterion:** CL:22; GL §4:294 explicitly requires a quality/constraint analysis result and rationale, with explained N/A where appropriate; GL §§4.1–4.2:307–346 covers applicable timing/resource analysis.

**Location:** Complete SAD:1–269; SAD Cluster():52–63 and Cluster Construction:186–202

**Evidence:** DOCUMENT FACT — The complete SAD ends at the TLB sequence and contains no quality/constraint analysis result, timing/resource evaluation, or reasoned N/A. SAD:54 promises initialization but supplies no applicable startup/time/resource analysis or applicability decision.

**Issue:** The interface depends on the document-wide analysis that GL:294 expressly requires. One shared analysis may cover all interfaces; a separate numerical budget/report per API is not demanded.

**Impact:** The review lacks an evidence basis for architecture suitability against applicable constraints; no measured limit violation is claimed.

**Suggested correction:** Provide the author-owned shared analysis and identify its applicability to this interface, or justify inapplicable aspects. No reviewer-invented threshold or runtime test is prescribed.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Cluster():52–63 and Cluster Construction:186–202. Implementation evidence: Source mechanisms in UMD-EV-002/003/004/011/013; KMD-EV-002/003/004/010 do not replace controlled analysis.

### SAD-F-003 — Required feasibility result and rationale are absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-07

**Guideline / controlled criterion:** CL:23; GL §4:294 explicitly requires a technical-feasibility result and rationale; GL §4.3:381 applies to significant decisions without prescribing artificial alternatives.

**Location:** Complete SAD:1–269; SAD Cluster():52–63 and Cluster Construction:186–202

**Evidence:** DOCUMENT FACT — No technical-feasibility conclusion or supporting architecture rationale is present. The document assigns cluster abstraction to UMD over KMD (SAD:26,194–200), without evaluating that arrangement.

**Issue:** The explicit minimum feasibility evidence does not exist for the architecture on which this interface relies; significance of further decisions and applicable risks is not invented.

**Impact:** Reviewers cannot identify the basis and conditions under which the architecture is considered feasible.

**Suggested correction:** Record the shared feasibility result and basis, then the interface-relevant significant choices, assumptions and risks where applicable. Code existence is not feasibility proof.

**Traceability:** Requirement / VC: Not supplied. SAD element: SAD Cluster():52–63 and Cluster Construction:186–202. Implementation evidence: UMD-EV-002/003/004/011/013; KMD-EV-002/003/004/010.

### SAD-F-101 — Cluster completion and boundary contract are underspecified

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-02

**Guideline / controlled criterion:** CL:18; GL:155,219–224 require conditions, interface inputs/outputs and possible results.

**Location:** SAD:26–28,52–63,194–200

**Evidence:** DOCUMENT FACT — The target promises creation and initialization, specifies Input None and object creation, gives constraints as '-', and depicts only open success. It supplies no KMD identity/open contract or definition of initialized completion.

**Issue:** Callers cannot tell what readiness the constructed object guarantees, how construction failure appears, or how kernel resources relate to the object. This gap exists in the document without requiring a particular code sequence.

**Impact:** Callers and integration tests can use different readiness and failure assumptions.

**Suggested correction:** Define intended construction completion/failure and the required KMD contract; decide initialization/start/cleanup ownership before reconciling code.

**Traceability:** Requirement / VC: Not supplied. SAD element: Cluster contract and construction sequence. Implementation evidence: UMD-EV-003/004/011; KMD-EV-003/004/010 (context only).

### SAD-F-102 — Initialization behavior is not described beyond open success

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-03

**Guideline / controlled criterion:** CL:19,31; GL:238,240,255 require meaningful component behavior sufficient for verification.

**Location:** SAD:54,186–202

**Evidence:** DOCUMENT FACT — Cluster creation and initialization is promised, but the entire sequence contains cluster(), open(), success and object creation; no major initialization processing/decisions/state is described elsewhere or referenced.

**Issue:** The source cannot substitute for the missing intended component behavior. This finding does not demand the implementation's exact discovery algorithm or an Activity Diagram.

**Impact:** Initialization scenarios and observable completion cannot be derived consistently.

**Suggested correction:** Document major initialization processing, decisions and completion at architecture level; determine applicable lifecycle/error scenarios without inventing a reset/threading model.

**Traceability:** Requirement / VC: Not supplied. SAD element: Cluster Construction. Implementation evidence: UMD-EV-002/003/004/011; KMD-EV-002/010.

## Decisions required and open issues

| ID | Classification | Decision / missing evidence |
|---|---|---|
| CLU-REQ | Missing evidence | Controlled requirements are not supplied. SAD-04 is Blocked, not Fail; forward allocation and reverse justification cannot be established. Requirements-semantic consistency also remains unassessed. New requirements require renewed scope approval. |
| CLU-REUSE | Missing evidence | The target does not establish whether this interface embodies a reused component or meaningful alternative selection. SAD-08 cannot be accepted on current applicability evidence; no substantive reuse/comparison violation or artificial alternative is invented. |
| CLU-PLAN | Decision required | SAD-09 is N/A to external project/PM process assessment within these supplied inputs. This scope-qualified result does not mean no planning impact. The document has no evaluation/no-impact statement, but the review does not infer an interface-specific significant planning decision or an external failure from that absence. An owner must settle applicability and point to the appropriate controlled record if review is requested. |
| CLU-VARIANT | Decision required | Identify the intended architecture/build variant and supported interface contract. Source defaults and nearby API analogues do not establish that intent. |
| CLU-READY | Decision required | Define constructed versus started readiness, device selection, partial discovery/failure behavior, and ownership of open mappings and shutdown. Code supplies examples, not the intended policy. |
| CLU-ABI | Decision required | Device-info/mapping layouts match statically, but UMD API constant 1 and KMD constant 2 do not establish a version policy. The inspected UMD constructor uses a sysfs semantic-version gate; no incompatibility is proved. |
| CLU-NAME | Review observation | Cluster() versus cluster() capitalization needs a notation decision; it is not counted as a formal contradiction without establishing that both labels denote exact API symbols. |

## Coverage limitations

Read-only static inspection; no build, hardware, runtime, concurrency, fault-injection, throughput or deployed ABI test. UMD evidence follows the checked-in default `EAGLE_AS_TT=ON` BOS chain (`source/bos-umd/CMakeLists.txt:58–62`, `source/bos-umd/device/CMakeLists.txt:64–92`); generic branches were inspected only for selection/correspondence and are not exhaustively verified. KMD defaults to `BLACKHOLEPLUS` (`source/bos-kmd/Makefile:13–14`). Neither default establishes intended/deployed configuration. No firmware, hardware specification, external wrapper or additional controlled reference is assumed. All relevant preserved SAD Mermaid text was inspected; absent guideline example images were not reconstructed. Checklist status is `unknown`, as approved. No external tickets, PM messages or stakeholder approvals are created or implied.

The inspected descriptor path supports local BOS silicon; this review does not establish complete Ethernet/remote topology behavior or option combinations. Separate construction/start/cleanup source was inspected statically, not executed.

## Final interface result

**Assessed interface result: Fail. Requirements coverage: Blocked. SAD-09: N/A within the stated assessment scope.**

Formal component, contract, dynamic-behavior and shared-analysis gaps justify Fail independently of missing requirements or external PM records. Positive support for default construction and device-info/mapping exchanges is preserved. The SAD-05 Pass is expressly limited to internal view consistency, not the unavailable requirements-semantic check.

The scoped review is complete; this is not full requirements acceptance, a runtime validation result, or stakeholder approval. No controlled input/source was changed. Scope-lock verification preceded analysis; final verification is recorded in the overall report.

