# SAD Findings Index — Approved Scope Version 2

Final finding register for the [approved scope](../scope.md), pinned by [scope.lock](../scope.lock). This version supersedes the earlier aggregate working register. IDs refer to version-2 findings; there is no implied one-to-one identity with version-1 numbering. The five interface reviews were completed before this shared index was generated.

**22 unique records: 16 formal Process / guideline findings (12 Major, 4 Minor) and 6 Implementation drift records.** Drift severity is unassigned because intended behavior and resulting runtime impact remain unresolved. There are no Critical findings. Shared SAD-F-001–003 appear with interface-specific applicability in all five reviews and are counted once each; there are 34 finding occurrences across the five files, not 34 independent issues.

Every formal finding identifies an applicable controlled criterion, available target evidence and a directly demonstrated gap without inventing a requirement. Severity describes the documented impact: Major gaps permit materially different implementations/integration tests; Minor findings concern localized naming/meaning. Drift records state the SAD and source observations without selecting which must change. Missing evidence, reviewer observations and owner decisions remain separate below and are not included in the 16 formal findings.

## Finding index and detailed interface records

The complete criterion, location, direct evidence, issue, impact, correction and traceability for each local record remain in its linked interface review. Detailed interface reviews are not combined here. Shared records are summarized separately below.

| ID | Classification | Severity | Checklist | Finding | Detailed record |
|---|---|---|---|---|---|
| SAD-F-001 | Process / guideline finding | Major | SAD-01 | Component responsibilities and design scopes are incomplete | [Cluster](/home/hoangb/BOS/sad-review/review/interfaces/01-cluster.md:87); [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:86); [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:86); [Multicast Write](/home/hoangb/BOS/sad-review/review/interfaces/04-multicast-write.md:84); [TLB Configuration](/home/hoangb/BOS/sad-review/review/interfaces/05-tlb-configuration.md:86) |
| SAD-F-002 | Process / guideline finding | Major | SAD-06 | Required quality and constraint analysis is absent | [Cluster](/home/hoangb/BOS/sad-review/review/interfaces/01-cluster.md:109); [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:108); [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:108); [Multicast Write](/home/hoangb/BOS/sad-review/review/interfaces/04-multicast-write.md:106); [TLB Configuration](/home/hoangb/BOS/sad-review/review/interfaces/05-tlb-configuration.md:108) |
| SAD-F-003 | Process / guideline finding | Major | SAD-07 | Required feasibility result and rationale are absent | [Cluster](/home/hoangb/BOS/sad-review/review/interfaces/01-cluster.md:131); [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:130); [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:130); [Multicast Write](/home/hoangb/BOS/sad-review/review/interfaces/04-multicast-write.md:128); [TLB Configuration](/home/hoangb/BOS/sad-review/review/interfaces/05-tlb-configuration.md:130) |
| SAD-F-101 | Process / guideline finding | Major | SAD-02 | Cluster completion and boundary contract are underspecified | [Cluster](/home/hoangb/BOS/sad-review/review/interfaces/01-cluster.md:153) |
| SAD-F-102 | Process / guideline finding | Major | SAD-03 | Initialization behavior is not described beyond open success | [Cluster](/home/hoangb/BOS/sad-review/review/interfaces/01-cluster.md:175) |
| SAD-F-201 | Process / guideline finding | Major | SAD-02 | Memory caller and boundary contracts are incomplete | [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:152) |
| SAD-F-202 | Process / guideline finding | Major | SAD-03 | Memory sequence does not describe the payload operation | [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:174) |
| SAD-F-203 | Process / guideline finding | Minor | SAD-05 | Read size is described as a write size | [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:196) |
| SAD-F-204 | Implementation drift | Unassigned | SAD-02 | Memory signature correspondence differs at the recorded baseline | [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:218) |
| SAD-F-205 | Implementation drift | Unassigned | SAD-03 | Memory mapping occurs at setup in the inspected implementation | [Device Memory Access](/home/hoangb/BOS/sad-review/review/interfaces/02-device-memory-access.md:238) |
| SAD-F-301 | Process / guideline finding | Major | SAD-02 | Register operation contract does not define key caller semantics | [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:152) |
| SAD-F-302 | Process / guideline finding | Major | SAD-03 | Register transaction behavior is absent from the sequence | [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:174) |
| SAD-F-303 | Process / guideline finding | Minor | SAD-05 | Register table uses memory-operation labels and address terminology | [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:196) |
| SAD-F-304 | Implementation drift | Unassigned | SAD-02 | Register signatures and alignment differ from the SAD tables | [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:218) |
| SAD-F-305 | Implementation drift | Unassigned | SAD-03 | Register access reuses established mappings in the inspected source | [Device Register Access](/home/hoangb/BOS/sad-review/review/interfaces/03-device-register-access.md:238) |
| SAD-F-401 | Process / guideline finding | Major | SAD-02 | Multicast destination and operation contract are imprecise | [Multicast Write](/home/hoangb/BOS/sad-review/review/interfaces/04-multicast-write.md:150) |
| SAD-F-402 | Process / guideline finding | Major | SAD-03 | Multicast behavior is not described beyond a mapping exchange | [Multicast Write](/home/hoangb/BOS/sad-review/review/interfaces/04-multicast-write.md:172) |
| SAD-F-403 | Process / guideline finding | Minor | SAD-05 | Multicast table mixes operation and parameter domains | [Multicast Write](/home/hoangb/BOS/sad-review/review/interfaces/04-multicast-write.md:194) |
| SAD-F-404 | Implementation drift | Unassigned | SAD-02 | Named multicast API has no exact counterpart in the searched baseline | [Multicast Write](/home/hoangb/BOS/sad-review/review/interfaces/04-multicast-write.md:216) |
| SAD-F-501 | Process / guideline finding | Major | SAD-02 | Static-window target and result contract are incomplete | [TLB Configuration](/home/hoangb/BOS/sad-review/review/interfaces/05-tlb-configuration.md:152) |
| SAD-F-503 | Process / guideline finding | Minor | SAD-05 | TLB result is associated with a memory-write operation | [TLB Configuration](/home/hoangb/BOS/sad-review/review/interfaces/05-tlb-configuration.md:174) |
| SAD-F-504 | Implementation drift | Unassigned | SAD-02 | Named static-window getter has no exact source counterpart | [TLB Configuration](/home/hoangb/BOS/sad-review/review/interfaces/05-tlb-configuration.md:196) |

## Cross-cutting records

The following three records concern shared architecture evidence. Their applicability is independently justified in each interface file; a shared analysis can close a shared gap without a separate analysis document per API.

## SAD-F-001 — Component responsibilities and design scopes are incomplete

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-01

**Guideline / controlled criterion:** CL:17; GL:135 requires functionality/design scope; GL:146–151 conditions black-box treatment; GL:174–198 addresses applicable internal design.

**Location:** SAD Overview and static graph, lines 20–48; complete target, lines 1–269.

### Evidence

`DOCUMENT FACT`: UMD and KMD are separate nodes and sequence participants. Only UMD has an SWC overview, its ID is blank, and no KMD overview or Design Scope/black-box designation is present. DOC-01 records the evidence; the linked interface records identify the particular required boundary contracts.

### Issue

Separate drawing participants do not provide separately specified software-component responsibilities/design scopes. Cluster has an open/identity/lifetime dependency; memory and register access depend on mapping/transfer ownership; multicast needs destination/setup/execution allocation; TLB retrieval depends on an existing mapping whose intended owner is unspecified. No arbitrary source-file decomposition or mandatory KMD getter call is prescribed.

### Impact

Responsibility and integration-test allocation can differ between implementers because the intended component boundary is incomplete.

### Suggested correction

State intended component identities, responsibilities and design scopes. Provide applicable internal detail or justify black-box treatment while retaining its required external contract. The architecture owner must decide the intended boundary.

### Traceability

- Requirement / VC: Not supplied; bidirectional requirement traceability is Blocked.
- SAD element: Shared Overview/static model, applied to all five named interfaces.
- Implementation evidence: UMD-EV-002–011/013 and KMD-EV-002–006/010/013 are context, not intended decomposition. See the explicit interface-specific subsets in the linked records.

## SAD-F-002 — Required quality and constraint analysis is absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-06

**Guideline / controlled criterion:** CL:22; GL:294 explicitly requires quality/constraint analysis result and rationale with explained N/A where appropriate; GL:307–318,336–346 covers applicable timing/resource analysis.

**Location:** Complete SAD, lines 1–269; constraints and flows for all five interfaces.

### Evidence

`DOCUMENT FACT`: The target ends with its TLB sequence and contains no Architecture Analysis result, quality/constraint rationale, timing/resource evaluation or explained N/A. The interface validity/size/pre-existing-map statements do not provide the required analysis (DOC-06).

### Issue

The shared architecture-analysis evidence explicitly required by GL:294 is missing. All five interfaces depend on that architecture; the finding does not demand a separate numeric budget or benchmark per API and does not invent applicable thresholds.

### Impact

There is no controlled analysis basis to assess architecture suitability against applicable constraints. No measured runtime-limit violation is claimed.

### Suggested correction

Provide the shared author-owned analysis with interface applicability, or explain inapplicable aspects, using estimates or other permitted evidence where appropriate.

### Traceability

- Requirement / VC: Not supplied; no performance/resource requirement inferred.
- SAD element: Shared architecture analysis, applicable to Cluster, memory, register, multicast and TLB.
- Implementation evidence: Mechanisms in the separate UMD/KMD ledgers identify comparison context but cannot replace controlled analysis.

## SAD-F-003 — Required feasibility result and rationale are absent

**Classification:** Process / guideline finding

**Severity:** Major

**Checklist:** SAD-07

**Guideline / controlled criterion:** CL:23; GL:294 explicitly requires technical-feasibility result/rationale; GL:381 addresses significant decisions and GL:383 limits alternative comparison to meaningful choices.

**Location:** Complete SAD, lines 1–269; UMD/KMD access arrangement at 26–28 and associated flows.

### Evidence

`DOCUMENT FACT`: The target records no technical-feasibility result or supporting architecture rationale for the component/access/mapping arrangement (DOC-07).

### Issue

The explicit minimum feasibility evidence is absent for the shared architecture on which all five interfaces rely. Particular further significant decisions, alternative designs and risks are not invented.

### Impact

Reviewers cannot establish the basis and conditions under which this architecture is considered feasible.

### Suggested correction

Record the shared feasibility result and basis, then interface-relevant significant decisions, assumptions, risks and negative impacts where applicable. Implementation existence is not feasibility proof.

### Traceability

- Requirement / VC: Not supplied.
- SAD element: Shared feasibility analysis across the five reviewed interfaces.
- Implementation evidence: UMD/KMD ledgers provide implementation context, not an author-owned feasibility conclusion.

## Open issues and decisions — separate from formal findings

Common suffixes apply to each of CLU, MEM, REG, MC and TLB; these are the exact IDs retained in the independent reviews. These records neither invent required behavior nor assign external work to a named person.

| Interface decision IDs | Classification | Required decision / unavailable evidence |
|---|---|---|
| CLU-REQ, MEM-REQ, REG-REQ, MC-REQ, TLB-REQ | Missing evidence | Controlled requirements are not supplied. SAD-04 is Blocked, not Fail; forward allocation and reverse justification cannot be established. Requirements-semantic consistency also remains unassessed. New requirements require renewed scope approval. |
| CLU-REUSE, MEM-REUSE, REG-REUSE, MC-REUSE, TLB-REUSE | Missing evidence | The target does not establish whether this interface embodies a reused component or meaningful alternative selection. SAD-08 cannot be accepted on current applicability evidence; no substantive reuse/comparison violation or artificial alternative is invented. |
| CLU-PLAN, MEM-PLAN, REG-PLAN, MC-PLAN, TLB-PLAN | Decision required | SAD-09 is N/A to external project/PM process assessment within these supplied inputs. This scope-qualified result does not mean no planning impact. The document has no evaluation/no-impact statement, but the review does not infer an interface-specific significant planning decision or an external failure from that absence. An owner must settle applicability and point to the appropriate controlled record if review is requested. |
| CLU-VARIANT, MEM-VARIANT, REG-VARIANT, MC-VARIANT, TLB-VARIANT | Decision required | Identify the intended architecture/build variant and supported interface contract. Source defaults and nearby API analogues do not establish that intent. |

Interface-specific open issues remain independently actionable:

| ID | Classification | Decision / observation | Detail |
|---|---|---|---|
| CLU-READY | Decision required | Define constructed versus started readiness, device selection, partial discovery/failure behavior, and ownership of open mappings and shutdown. Code supplies examples, not the intended policy. | [Cluster](../interfaces/01-cluster.md) |
| CLU-ABI | Decision required | Device-info/mapping layouts match statically, but UMD API constant 1 and KMD constant 2 do not establish a version policy. The inspected UMD constructor uses a sysfs semantic-version gate; no incompatibility is proved. | [Cluster](../interfaces/01-cluster.md) |
| CLU-NAME | Review observation | Cluster() versus cluster() capitalization needs a notation decision; it is not counted as a formal contradiction without establishing that both labels denote exact API symbols. | [Cluster](../interfaces/01-cluster.md) |
| MEM-MODEL | Decision required | Define logical chip/device identity, address domains, buffer ownership, supported target cores and completion semantics without importing source limits as requirements. | [Device Memory Access](../interfaces/02-device-memory-access.md) |
| MEM-SERIAL | Missing evidence | Caller serialization, map invalidation/removal and AP/ATU concurrency policy are not established. Observed locks or local absence of locks cannot prove end-to-end safety. | [Device Memory Access](../interfaces/02-device-memory-access.md) |
| MEM-FLOW | Decision required | Reconcile persistent mapping, target-window changes and actual payload flow. No per-transfer kernel copy or DMA use is inferred. | [Device Memory Access](../interfaces/02-device-memory-access.md) |
| REG-WIDTH | Decision required | Resolve supported size/width semantics. The AP helpers transfer one uint32_t in the inspected bodies despite a length-bearing public API; this is not a proved bulk-register defect without intended semantics. | [Device Register Access](../interfaces/03-device-register-access.md) |
| REG-ORDER | Missing evidence | Atomicity, side effects, completion/ordering, concurrent AP use and recovery assumptions are not established by this SAD or a controlled SRS. | [Device Register Access](../interfaces/03-device-register-access.md) |
| REG-ROUTE | Decision required | Determine intended register target domains and whether Tensix direct mapping versus AP-mediated access belongs in the architecture contract. | [Device Register Access](../interfaces/03-device-register-access.md) |
| MC-BINDING | Decision required | Identify whether the named interface is intended, obsolete, conceptual or provided by a separately approved wrapper. Nearby broadcast APIs are not automatically replacements. | [Multicast Write](../interfaces/04-multicast-write.md) |
| MC-DEST | Decision required | Define supported chips/cores/regions, destination encoding, completion and any ordering constraints. Neither fixed device 0 in code nor KMD mcast fields establish the intended policy. | [Multicast Write](../interfaces/04-multicast-write.md) |
| MC-KMD | Missing evidence | Actual KMD participation beyond setup and supported multicast/TLB callbacks for the intended build are unestablished. | [Multicast Write](../interfaces/04-multicast-write.md) |
| TLB-DYNAMIC | Missing evidence | The normal request/return flow is documented. Applicable mapping state, invalidation, lifetime and failure interactions are not sufficiently established to close SAD-03; no extra kernel call or complex algorithm is invented. This explains an evidence-acceptance Fail without a formal violation. | [TLB Configuration](../interfaces/05-tlb-configuration.md) |
| TLB-BINDING | Decision required | Resolve address-versus-ID target, metadata-versus-live-handle result, and whether the named API is intended or needs an explicit correspondence to another operation. | [TLB Configuration](../interfaces/05-tlb-configuration.md) |
| TLB-OWNER | Decision required | Identify who establishes and owns the mapping, its valid lifetime, and supported static versus dynamic facilities. Do not equate BOS userspace core maps with KMD allocated TLB objects. | [TLB Configuration](../interfaces/05-tlb-configuration.md) |
| TLB-TERM | Review observation | TLB Configuration title versus retrieval description is a terminology/scope question; the description does not itself claim that this call reconfigures hardware. | [TLB Configuration](../interfaces/05-tlb-configuration.md) |

`Review observation` entries CLU-NAME and TLB-TERM are explicitly not formal controlled-rule violations. The optional KMD callback/init concern in KMD-EV-013 informs CLU-READY, MC-KMD and TLB-OWNER; it is not a demonstrated runtime defect or an additional formal finding. Source constant differences do not prove ABI incompatibility. TLB-DYNAMIC and the five REUSE records explain evidence-acceptance failures without manufacturing a substantive violation.

## Resolution boundary

All records remain open at review completion; no SAD/source correction or external ticket was made. The owner must decide intended architecture and supported variant before choosing whether SAD or implementation should change for drift. Correcting local table wording, defining contracts/behavior and supplying shared analysis are suggested follow-up work, not edits performed by this review. Adding SRS, external planning records, a wrapper or a new baseline requires renewed scope approval.

Full status and coverage qualifications are in the [final report](../reports/sad-review-report.md). SAD-04 is Blocked in all five reviews; SAD-09 is scoped N/A rather than an inferred failure of external PM activity.
