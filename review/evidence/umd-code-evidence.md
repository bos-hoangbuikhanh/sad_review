# UMD Code Evidence — Approved Scope Version 2

Repository: `source/bos-umd`; branch `develop`; commit `86e0ab17209d7af8f741ac34c158ebbf71612ea4`. Local HEAD and develop reference match the locked baseline, with a clean worktree including untracked files. [Scope lock](../scope.lock); [document evidence](document-evidence.md); [KMD evidence](kmd-code-evidence.md).

This is read-only static `IMPLEMENTATION EVIDENCE`. It consolidates evidence collected for all five completed interface reviews. No item supplies intended architecture, requirements, a final checklist result or runtime proof. Paths below are relative to `source/bos-umd` unless explicitly prefixed with `source/`; citations use one-based line spans. All items inherit the repository/baseline stated above; repeated fields make that binding explicit. Evidence IDs retain their interface-review identifiers; unused identifiers from earlier working records are not additional coverage claims.

## UMD-EV-001 — Checked-in source selection

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: CMakeLists.txt:58–62; device/CMakeLists.txt:64–92.
- Symbol: EAGLE_AS_TT build option and source-list selection.
- Related SAD section/interface: All five interfaces; SAD:26–28.
- Observed behavior: EAGLE_AS_TT defaults ON and selects the Blackholeplus/BOS implementation. The evidence below follows that chain; generic paths were inspected only for selection/correspondence.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: A checked-in default is not the intended or deployed build configuration. No build was performed.

## UMD-EV-002 — Device discovery and identity

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/pci_device.cpp:105–165.
- Symbol: PCIDevice::enumerate_devices; PCIDevice::enumerate_devices_info.
- Related SAD section/interface: Cluster; SAD:54,194–200.
- Observed behavior: Enumeration scans numeric entries under /dev/bos, opens/queries device information and skips individual nodes whose information open/query fails. The returned device numbers are available for descriptor construction.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Discovery behavior does not establish the intended failure policy or complete Ethernet/remote topology support. PCI device number, logical chip ID and PCI BDF are distinct identities.

## UMD-EV-003 — Cluster construction and device selection

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/cluster.h:29–59,82; device/blackholeplus/cluster.cpp:157–178,265–334,738–794.
- Symbol: ClusterOptions; Cluster::Cluster; local-chip construction; create_cluster_descriptor.
- Related SAD section/interface: Cluster and selected-device context for access APIs; SAD:52–63,99.
- Observed behavior: Cluster accepts ClusterOptions with a default argument, so Cluster() is callable without arguments. It checks option combinations, creates or uses a descriptor, selects logical chip IDs and constructs chips. Descriptor generation enumerates PCI devices and records logical-to-PCI mappings. Inspected construction distinguishes local silicon, mock/simulation and unsupported remote cases.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Optional constructor arguments alone do not contradict the SAD no-input example. Not all option combinations or complete topology discovery are verified. Source ID mapping does not define intended device selection.

## UMD-EV-004 — Device open, queries and persistent mappings

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/pci_device.cpp:170–324,382–394.
- Symbol: PCIDevice constructor/destructor; driver-version lookup.
- Related SAD section/interface: Cluster; memory/register/multicast mapping dependency; TLB existing-window precondition.
- Observed behavior: The constructor opens the numeric device node, obtains device information and mapping descriptors, then establishes and stores BAR0 WC, BAR2 UC and BAR4 UC mappings. Destruction closes/unmaps resources. The constructor has an IOMMU-related semantic-version check using the BOS module version from sysfs. Ordinary memory/register chains below reuse stored mappings.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Static lifetime evidence does not prove reset/removal safety, deployed ABI compatibility or a complete version policy. Device-window/ATU changes are distinct from creation of host VMAs by mmap.

## UMD-EV-005 — Public memory and register declarations

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/cluster.h:271–285,300–316; device/blackholeplus/cluster.cpp:576–605.
- Symbol: Cluster::write_to_device; read_from_device; write_to_device_reg; read_from_device_reg.
- Related SAD section/interface: Memory SAD:65–100; register SAD:102–137.
- Observed behavior: Write declarations take const void* mem_ptr, uint32_t size_in_bytes, chip_id_t chip, CoreCoord core and uint64_t addr. Read declarations take void* mem_ptr, chip_id_t chip, CoreCoord core, uint64_t addr and uint32_t size. Both return void. Public wrappers select a chip and translate/forward core access. The adjacent BOS public DMA methods throw.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Drift candidate: SAD uses size_t and no explicit chip argument; read output-buffer passing is unclear in the SAD. These differences do not establish which artifact must change. Exposed KMD DMA facilities do not establish DMA use by these ordinary functions.

## UMD-EV-006 — Memory payload routes

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/local_chip.cpp:177–205; device/blackholeplus/blackhole_tt_device.cpp:232–310,469–627,717–841; device/blackholeplus/tt_device.cpp:95–195.
- Symbol: LocalChip memory dispatch; write/read_dram_memory; write/read_tensix_memory; packet_set_atu; write_block/read_block; device-copy helpers.
- Related SAD section/interface: Memory SAD:65–100,204–220.
- Observed behavior: LocalChip routes supported translated cores to DRAM or Tensix and rejects other targets. Tensix uses checked static mappings and BAR2. DRAM chunks transfers over a BAR0 window and, when needed, requests ATU changes through BAR4 AP packets. Block helpers copy to/from mapped device memory, including volatile word access and partial-word handling. No per-transfer mmap is present in these inspected chains.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Drift candidate: SAD places mmap inside the public read/write interaction; implementation maps at device setup then transfers payload. No firmware behavior, hardware timing, atomicity or serialization guarantee is established. Source ranges and response waits are not controlled requirements.

## UMD-EV-007 — Register payload routes and width

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/local_chip.cpp:266–310; device/blackholeplus/blackhole_tt_device.cpp:313–446,843–1018; device/blackholeplus/tt_device.cpp:95–195.
- Symbol: LocalChip register dispatch; Tensix/DRAM register access; packet_write_regs; packet_read_regs.
- Related SAD section/interface: Register SAD:102–137,222–238.
- Observed behavior: Register dispatch checks address and byte-count divisibility by four and routes supported cores. Tensix uses mapped BAR2 register space; DRAM-core register access translates the target and uses BAR4 AP packet helpers. The inspected AP helpers transfer one uint32_t value, despite a length-bearing public interface. They do not implement a loop over the word count. No per-operation mmap occurs in these chains.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Drift candidates: precise signatures/alignment differ from SAD description and the sequence places mapping inside each access. Multiword semantics, side effects, atomicity and ordering are owner decisions; no runtime bug or required bulk semantics are inferred from the single-word helper alone.

## UMD-EV-008 — Bounded multicast lookup and nearby broadcast code

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: Tracked C/C++ exact-name search across repository; device/blackholeplus/cluster.h:340–382; device/blackholeplus/cluster.cpp:471–553; device/blackholeplus/blackhole_tt_device.cpp:631–715.
- Symbol: noc_multicast_write (searched); nearby broadcast_write_to_cluster/broadcast helpers.
- Related SAD section/interface: Multicast SAD:139–160,240–256.
- Observed behavior: The exact name noc_multicast_write has no occurrence in the tracked C/C++ search described below. Nearby broadcast APIs have chip/row/column exclusion arguments. The inspected active path uses get_tt_device(0); the prior loop applying chip exclusion is commented out. The lower helper checks a fixed BAR2 broadcast region and performs mapped writes.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Drift candidate: no exact public API binding is established. Nearby broadcast APIs, exclusion arguments and fixed-device behavior do not prove equivalence to the SAD destination set/range. No hardware fan-out or external wrapper was verified.

## UMD-EV-009 — Bounded TLB getter lookup and writer analogue

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: Tracked C/C++ exact-name search across repository; device/blackholeplus/cluster.h:389–399; device/blackholeplus/cluster.cpp:376–377,400–411; device/blackholeplus/local_chip.cpp:75–94; device/blackholeplus/tlb_manager.cpp:22–49,60–111.
- Symbol: get_static_tlb_window (searched); get_static_tlb_writer; TLBManager getter/configuration methods.
- Related SAD section/interface: TLB SAD:162–180,258–269.
- Observed behavior: The exact name get_static_tlb_window has no occurrence in the tracked search. Nearby get_static_tlb_writer takes chip_id_t/CoreCoord and returns tt::Writer. Header comments require existing/unchanged mapping and a Cluster lifetime longer than the writer. Initialization populates core memory/register maps; the getter checks a mapped core/BAR2 and derives address/size to construct a Writer. This path does not invoke KMD CONFIGURE_TLB. Inspected BOS configure_tlb/dynamic configuration methods throw.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Drift candidate: writer identity, inputs and result do not establish equivalence to an address/TLB-ID window getter. Source comments are implementation contracts, not controlled SAD requirements. A userspace-only getter is plausible supporting evidence; a kernel call on each retrieval is not required by this review.

## UMD-EV-010 — Errors, waits and observable transfer outcomes

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/pci_device.cpp:170–324; device/blackholeplus/local_chip.cpp:177–205,266–310; device/blackholeplus/blackhole_tt_device.cpp:232–446,469–627,717–1018.
- Symbol: Open/query/map failure paths; target checks; AP response polling; memory/register helpers.
- Related SAD section/interface: Cluster, memory and register outcomes; SAD:52–137 and dynamic sequences.
- Observed behavior: Inspected code contains exceptions/checks for setup or unsupported target/range/alignment conditions and AP response polling with timeout/error exits. Source diagnostics and local checks provide observable implementation behavior but do not supply the absent SAD failure/completion contract.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: No execution, fault injection, concurrency or complete diagnostic-policy assessment was performed. Polling constants are not approved timing budgets. Local success/waits cannot establish hardware completion, end-to-end concurrency safety or reset/removal recovery.

## UMD-EV-011 — Initialization, start/close and ownership

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/blackholeplus/local_chip.cpp:28–94; device/blackholeplus/blackhole_tt_device.cpp:19–24; device/blackholeplus/cluster.cpp:390–394,662–678; device/blackholeplus/pci_device.cpp:310–324.
- Symbol: LocalChip initialization; device constructor; Cluster destructor/start_device/close_device; PCIDevice destructor.
- Related SAD section/interface: Cluster SAD:54,186–202; mapping lifetime for access/TLB.
- Observed behavior: Construction initializes local core maps, optional host-memory resources and mutex resources, and invokes MPU initialization through the device constructor. Separate start_device and close_device methods exist. Cluster and PCIDevice cleanup paths release owned descriptor/mapping resources.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Construction cannot be equated with all possible started/readiness states without an intended contract. Partial failure/rollback and removal/concurrency policies were not proven. The open-only SAD sequence does not itself deny omitted implementation setup steps.

## UMD-EV-013 — Paired UMD/KMD boundary ABI

- Repository: `source/bos-umd`.
- Baseline: `develop @ 86e0ab17209d7af8f741ac34c158ebbf71612ea4`.
- File: device/ioctl.h:16–83; device/blackholeplus/pci_device.cpp:193–248,382–394; paired source/bos-kmd/ioctl.h:10–83 and source/bos-kmd/memory.c:372–449.
- Symbol: TENSTORRENT_IOCTL_GET_DEVICE_INFO; TENSTORRENT_IOCTL_QUERY_MAPPINGS; mapping records and driver-version handling.
- Related SAD section/interface: Required KMD interface, Cluster and mappings; SAD:26–28,47,196,214,232,250.
- Observed behavior: The used device-info and mapping-query ioctl magic/numbers, fixed-width field order and mapping IDs agree statically across the headers. UMD requests eight mapping records; KMD supplies six valid BAR UC/WC records and clears extras. UMD API-version constant is 1 while KMD is 2; inspected UMD construction uses a sysfs semantic-version gate. GET_DRIVER_INFO appears as a definition rather than a call in the inspected BOS constructor chain.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Agreement is limited to these inspected exchanges, not the entire UAPI, runtime structure layout, every build or deployed compatibility. Different API constants alone do not prove incompatibility. An intended compatibility policy remains unresolved.

## Search bounds and interpretation

The exact-name search was:

```sh
git -C source/bos-umd grep -n -E 'noc_multicast_write|get_static_tlb_window' -- '*.cpp' '*.cc' '*.c' '*.h' '*.hpp'
```

It returned exit code 1 and no matches. This is a negative result only for tracked files matching those extensions at the locked commit. It does not cover outside wrappers, generated/deployed binaries, firmware or an unapproved revision. Nearby implementations are recorded as comparison evidence, not confirmed replacements.

The main call chains were followed from public declarations through Cluster, LocalChip, device helpers and PCIDevice setup. KMD services were examined separately to distinguish mapping setup from payload movement. No source, configuration, branch or commit was changed, and no build/hardware test was run. Intended variant, exact API binding, completion/lifetime, compatibility and optional feature support remain owner decisions in the [interface reviews](../reports/sad-review-report.md).
