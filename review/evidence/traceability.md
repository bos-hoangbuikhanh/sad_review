# Traceability Evidence — Approved Scope Version 2

This supporting mapping consolidates the five completed independent interface reviews against the [approved scope](../scope.md) and [verified lock](../scope.lock). Source evidence: [document ledger](document-evidence.md), [UMD ledger](umd-code-evidence.md), [KMD ledger](kmd-code-evidence.md). It records coverage and correspondence, not final checklist decisions or intended architecture inferred from code.

UMD baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`. KMD baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`. SAD: `review-input/sad/umd-kmd-sad.md`, revision 0.1; exact document hashes are in the lock. SAD line references below use that snapshot.

`DOCUMENT FACT` supplies design statements; `IMPLEMENTATION EVIDENCE` supplies observed source behavior. `OPEN ISSUE` identifies missing correspondence or evidence. No assumption is used to bridge them. A **Covered** mapping means only the explicitly bounded proposition has support; **Partial** means broad correspondence with unresolved details; **Missing** means no established binding; **Conflicting** identifies directly differing statements/observations; **Blocked** means a required controlled dependency is unavailable. These mapping statuses are distinct from checklist outcomes.

## Requirement traceability in both directions

| Source | SAD element | Implementation evidence | Status | Gap / conflict |
|---|---|---|---|---|
| Requirement / VC: Not supplied | Cluster, memory, register, multicast and TLB contracts/flows | Supporting source records exist but no controlled requirement baseline | Blocked | Requirement → component/interface/flow → implementation allocation cannot be checked. |
| Material architecture elements → justifying requirement / constraint | UMD/KMD decomposition, device selection, startup, data access, mapping retrieval, completion/lifetime | Implementation cannot create justifying requirements | Blocked | Reverse architecture → requirement traceability cannot be checked. |
| Controlled guideline obligations | Component/interface/dynamic/analysis evidence | Source cannot replace author-owned analysis | Partial | Guideline-to-document evidence is available; it is not product-requirement traceability. See DOC-01–09. |

No requirement IDs, verification conditions, thresholds or intended behavior are invented. This dependency is retained as Blocked under the explicit SAD-04 scope rule. Requirements-semantic consistency is unassessed for every interface, including Cluster's bounded internal-view support.

## SAD-to-implementation mapping

### Cluster

| Source | SAD element | UMD evidence | KMD evidence | Status | Gap / conflict |
|---|---|---|---|---|---|
| SAD:52–63 | No-argument Cluster construction | UMD-EV-003: defaulted ClusterOptions | No C++ Cluster construction in KMD | Covered | Bounded to callability; optional parameters do not contradict the no-input example. |
| SAD:26,54 | Host-detected devices and cluster identity | UMD-EV-002/003: node enumeration, descriptor and logical IDs | KMD-EV-002/003: device ordinals, nodes and identity | Partial | No intended device-selection/identity mapping or partial-discovery policy. |
| SAD:186–202 | Open and initialized object | UMD-EV-004/011: open/query/map/setup, separate start/close | KMD-EV-003/004/010: queries, mappings, file lifetime | Partial | Open aligns; intended initialization processing/completion and ownership are underspecified. Omitted implementation setup is not automatically a contradicted design statement. |
| SAD:26–28,47 | Required KMD dependency | UMD-EV-013: paired device-info/mapping UAPI | KMD-EV-003/004 | Covered | Only static queried-command/field/mapping correspondence; complete compatibility policy is unresolved. |

Independent contract, checklist and findings: [01-cluster.md](../interfaces/01-cluster.md).

### Device Memory Access

| Source | SAD element | UMD evidence | KMD evidence | Status | Gap / conflict |
|---|---|---|---|---|---|
| SAD:65–100 | write_to_device/read_from_device and valid selected device | UMD-EV-005/006: chip/core dispatch and payload paths | KMD-EV-004/005: supporting mappings | Partial | Names/purpose correspond, but chip selector and size width differ; SAD buffer passing/address domains are imprecise. |
| SAD:204–220 | mmap inside read/write interaction | UMD-EV-004/006: setup-time mappings, later BAR2 or BAR0/AP-window transfers | KMD-EV-005: VMA establishment | Conflicting | Inspected ordinary transfers do not call mmap per operation. ATU changes are not new host mappings. |
| SAD:26–28,99 | Device/address selection and validity | UMD-EV-003/005/006 | KMD-EV-002/004 | Partial | Logical chip, node ordinal, mapping offset and device address are distinct but not fully allocated in SAD. |

Independent contract, checklist and findings: [02-device-memory-access.md](../interfaces/02-device-memory-access.md).

### Device Register Access

| Source | SAD element | UMD evidence | KMD evidence | Status | Gap / conflict |
|---|---|---|---|---|---|
| SAD:102–137 | write_to_device_reg/read_from_device_reg | UMD-EV-005/007: chip/core dispatch, four-byte checks, mapped/AP paths | KMD-EV-004/005: supporting setup | Partial | Names/purpose correspond; chip selector, size width, buffer passing and alignment need reconciliation. |
| SAD:222–238 | mmap inside register interaction | UMD-EV-004/007: existing BAR2 or BAR4/AP resources | KMD-EV-005 | Conflicting | Mapping setup precedes the inspected register operation; no per-operation mmap is present. |
| SAD:104–136 | Register address/output meanings | Direct document evidence DOC-05 | Not required | Conflicting | Output rows name memory operations and write address uses a memory-region description. This is internal target evidence. |
| SAD:105,113,121 | Register access with a byte count | UMD-EV-007: length-bearing public API versus single-word AP helper | KMD TLB programming is a separate facility | Partial | Multiword behavior is an owner decision; no required bulk semantics, runtime defect or KMD replacement is inferred. |

Independent contract, checklist and findings: [03-device-register-access.md](../interfaces/03-device-register-access.md).

### Multicast Write

| Source | SAD element | UMD evidence | KMD evidence | Status | Gap / conflict |
|---|---|---|---|---|---|
| SAD:141,248 | Exact noc_multicast_write entry point | UMD-EV-008: no exact occurrence in bounded tracked C/C++ search | No exact public UMD binding established | Missing | Nearby broadcast methods are comparison evidence, not confirmed replacements or proof the operation is absent everywhere. |
| SAD:148,159 | Destination set/range and architecture validity | UMD-EV-008: exclusion arguments, active device-0 broadcast path | KMD-EV-006: multicast-capable configuration fields | Partial | Intended encoding, target coverage and hardware fan-out are unestablished. |
| SAD:240–256 | Mapping-based multicast flow | Existing mappings used by nearby broadcast path | KMD-EV-005 establishes VMAs | Partial | Exact operation remains unbound; a verified replacement call chain cannot be asserted. The document's mapping-only sequence omits payload behavior independently of code. |

Independent contract, checklist and findings: [04-multicast-write.md](../interfaces/04-multicast-write.md).

### TLB Configuration

| Source | SAD element | UMD evidence | KMD evidence | Status | Gap / conflict |
|---|---|---|---|---|---|
| SAD:164–177,265 | Exact get_static_tlb_window identity/result | UMD-EV-009: exact name absent in bounded search; chip/core Writer analogue | KMD-EV-006 is separate allocation/configuration | Missing | No proven mapping from address/TLB-ID and TLB Window to the source Writer or kernel allocation object. |
| SAD:165,179 | Existing static mapping used for BAR access | UMD-EV-004/009: persistent BAR2 and core maps | KMD-EV-004/005 | Partial | Broad supporting mechanism exists; intended target representation, owner and lifetime remain unknown. |
| SAD:258–269 | Userspace-only retrieval sequence | Nearby getter uses established mapping | No per-getter syscall demonstrated or required | Partial | KMD absence is not a contradiction. Applicable mapping-state/failure/lifetime coverage is missing evidence. |

Independent contract, checklist and findings: [05-tlb-configuration.md](../interfaces/05-tlb-configuration.md).

## Reverse mapping gaps

| Observed implementation element | Broad SAD association | Reverse gap / decision |
|---|---|---|
| UMD descriptors, logical chip IDs, per-device handles | Cluster creation/topology and selected-device access | Intended identity model, discovery failure policy and exact topology API allocation are absent. |
| UMD setup-time BAR mappings; KMD query/mmap/file cleanup | Required Character Device interface and access sequences | SAD does not allocate mapping creation/ownership/lifetime versus transfer completion. |
| UMD Tensix BAR2 and DRAM BAR0/ATU/AP routes | Memory access | No exact intended path/constraint allocation; source branches do not become requirements. |
| UMD direct register access and single-word AP helpers | Register access | Register transaction width, ordering, side effects and completion require an owner contract. |
| UMD fixed-device broadcast path/exclusion arguments | Multicast category | No exact noc_multicast_write correspondence; do not rewrite the SAD around the analogue. |
| UMD Writer and core maps versus KMD allocated/configured TLB objects | Static-window getter and KMD dependency | Separate facilities are not proven interchangeable; ownership/lifetime and supported variant require decisions. |
| KMD retained TLB callbacks under conditional probe initialization | Optional setup/configuration context | KMD-EV-013 is an unresolved support question, not proof of ordinary-path execution or runtime failure. |

## Explicit UMD/KMD boundary assessment

| Boundary aspect | Document fact | Implementation evidence | Remaining gap |
|---|---|---|---|
| Component identity | Separate UMD/KMD nodes; only UMD has SWC overview | Separate repositories/userspace and kernel responsibilities | Nodes are distinct, but separate component specifications/design scopes are incomplete. |
| Provided/required relationship | UMD requires KMD; one Character Device edge | Open, identity query, mapping query/mmap and release | The exact required/provided contract, supported variant and failure policy are not specified. |
| Device selection | Target core and sometimes selected device | UMD logical chip → PCI/node mapping; KMD per-device ordinal | Intended selectors and identity/address domains lack explicit mapping. |
| Control/data direction | Application → UMD; UMD → KMD open/mmap | Setup crosses kernel boundary; ordinary payload uses stored userspace mappings | SAD transfer diagrams conflate setup with the memory/register interaction. |
| Lifecycle | Creation and existing-map statements | Cluster/start/close, PCIDevice mappings, kernel file/device/TLB references | Readiness, ownership, rollback, invalidation and supported concurrency are not controlled contracts. |
| Error/completion | Success/return diagrams and validity preconditions | Exceptions/checks, errno paths and AP waits | Source behavior is observed but cannot establish intended failure, recovery or hardware completion guarantees. |
| TLB retrieval | UMD-only getter on existing mapping | Nearby Writer getter uses BAR2; KMD has separate alloc/config facility | No extra KMD message is inherently needed; exact API binding remains unestablished. |
| Static/dynamic consistency | Static dependency broadly agrees with participants | Supporting kernel setup is confirmed | Category-level agreement does not close incomplete contracts or per-operation mapping drift. |

## Open decisions and limitations

Common interface decision IDs with suffixes REQ, REUSE, PLAN and VARIANT retain missing requirements, reuse/alternative applicability, scoped planning applicability and intended implementation variant. Additional lifecycle/ABI, memory serialization, register width/ordering, multicast binding/destinations and TLB ownership/binding decisions are indexed in [findings](../findings/findings.md).

No controlled SRS, additional SUD, firmware/hardware specification, deployment record, runtime data or external PM evidence was supplied. No source behavior or reviewer preference fills those gaps. The exact-name searches cover tracked C/C++ extensions only. No build/runtime/hardware/concurrency test was performed. Static agreement cannot establish hardware correctness or full deployed compatibility. New controlled inputs or baselines require renewed scope approval.
