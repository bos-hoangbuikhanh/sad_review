# KMD Code Evidence — Approved Scope Version 2

Repository: `source/bos-kmd`; branch `develop`; commit `12d235aeedb8aa55ede24927c9e09f88c8f278c4`. Local HEAD and develop reference match the locked baseline, with a clean worktree including untracked files. [Scope lock](../scope.lock); [document evidence](document-evidence.md); [UMD evidence](umd-code-evidence.md).

This read-only `IMPLEMENTATION EVIDENCE` ledger consolidates the completed interface reviews. It separates directly observed KMD participation from supporting facilities and unproven correspondence. It does not infer intended architecture or assign final checklist outcomes. Paths are relative to `source/bos-kmd` unless explicitly prefixed with `source/`; line spans are one-based. Evidence identifiers used by the independent reviews are retained; unused identifiers from earlier working records are not additional coverage claims.

## KMD-EV-001 — Checked-in kernel configuration

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: Makefile:13–14.
- Symbol: BLACKHOLEPLUS compile definition.
- Related SAD section/interface: All interfaces; architecture variant context.
- Observed behavior: The checked-in Makefile defines BLACKHOLEPLUS for the driver build. Conditional probe behavior below therefore matters to this source baseline.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: The default does not establish intended/deployed configuration. No kernel module was built or loaded.

## KMD-EV-002 — Per-device enumeration and character-node identity

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: enumerate.c:48–147; chardev.c:81–104.
- Symbol: PCI probe path; character-device registration/devnode callback.
- Related SAD section/interface: Cluster SAD:54,194–200; selected-device dependency for transfers.
- Observed behavior: Probe allocates a per-PCI-device ordinal through an IDR and registers character-device access. The devnode callback names entries bos/N. Device-info queries expose PCI identity; UMD maintains its own logical-chip mapping.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: KMD exposes device instances, not the C++ Cluster abstraction or full cluster topology. Node ordinal, PCI identity and logical chip ID must not be conflated.

## KMD-EV-003 — Character operations and device information UAPI

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: chardev.c:36–42,111–173; ioctl.h:10–83; paired source/bos-umd/device/ioctl.h:16–83.
- Symbol: chardev_fops; device-info and driver-info handlers; ioctl definitions.
- Related SAD section/interface: Required KMD boundary; Cluster SAD:26–28,47,196; memory/register support.
- Observed behavior: File operations provide open/release/ioctl/mmap; no ordinary file read/write payload operation is registered. The device-info handler copies PCI identity information to the caller. Device-info and mapping-query magic/numbers, fixed-width field order and mapping IDs match the paired UMD definitions. KMD driver API constant is 2 while the UMD header constant is 1.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Positive agreement is limited to inspected exchanges. A constant difference alone does not demonstrate incompatibility; the inspected UMD constructor uses a sysfs semantic-version gate. No deployed ABI test or universal compatibility claim is made.

## KMD-EV-004 — Mapping discovery contract

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: ioctl.h:30–83; memory.c:372–449; paired source/bos-umd/device/blackholeplus/pci_device.cpp:216–248.
- Symbol: ioctl_query_mappings; bos_mapping records.
- Related SAD section/interface: Memory/register/multicast setup and TLB support; SAD:214,232,250,179.
- Observed behavior: QUERY_MAPPINGS returns character-device mmap offsets and lengths for UC/WC views of PCI BAR0/2/4 using six defined mapping IDs. UMD requests eight slots; the handler limits valid records to six and clears requested extra records.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Mapping offsets designate file/VMA setup, not application device addresses. QUERY_MAPPINGS does not copy memory/register payloads or establish intended cache/ordering semantics. Static structure agreement does not validate hardware behavior.

## KMD-EV-005 — mmap dispatch and VMA establishment

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: chardev.c:403–408; memory.c:1186–1237.
- Symbol: tt_cdev_mmap; mmap dispatcher and BAR/TLB/DMA routing.
- Related SAD section/interface: Memory SAD:204–220; register SAD:222–238; multicast SAD:240–256; TLB existing mappings.
- Observed behavior: The character-device mmap callback delegates to the memory subsystem. The dispatcher selects supported BAR UC/WC regions, allocated TLB windows or DMA buffers from the requested offset/range. Unmatched requests return -EINVAL. Its role is VMA establishment, not application payload movement.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Direct participation in setup is supported; a kernel transaction for each public UMD access is not. The precise multicast/getter API binding is unestablished, so this facility alone cannot prove their implementations. Runtime mapping, cache behavior and hot removal were not tested.

## KMD-EV-006 — Separate kernel TLB allocation/configuration facility

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: ioctl.h:238–295; memory.c:906–1004,1065–1114,1221–1227; blackhole.c:152–175.
- Symbol: ioctl_allocate_tlb; ioctl_free_tlb; ioctl_configure_tlb; TLB VMA callbacks; hardware TLB configuration callback.
- Related SAD section/interface: TLB SAD:162–180; multicast configuration context; register boundary comparison.
- Observed behavior: Allocation returns an ID and UC/WC mmap offsets and records per-file ownership. Free/configuration check ownership; free rejects mapped windows with -EBUSY. VMA callbacks maintain references and reject splitting. Configuration includes address, coordinate bounds and a multicast field, and the hardware callback writes TLB configuration registers.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: These are allocation/configuration/ownership mechanisms, not a noc_multicast_write payload API or get_static_tlb_window getter. No call from the inspected BOS static-writer chain to this configuration path was established. Retained callbacks do not prove support under every build; see KMD-EV-013.

## KMD-EV-010 — Open/release and device removal lifetime

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: chardev.c:431–499; enumerate.c:150–178.
- Symbol: tt_cdev_open; tt_cdev_release; PCI remove path.
- Related SAD section/interface: Cluster startup/shutdown and resource ownership for all five interfaces.
- Observed behavior: Open allocates per-file private state and holds a device reference. Release cleans file-owned resources, releases TLB/lock ownership and drops the reference. Device removal has separate cleanup/unregistration/reference handling.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: Per-file, per-device and userspace Cluster lifetimes differ. Static cleanup paths do not establish intended failure rollback, hot-removal, concurrent access, stale-pointer or reset recovery semantics.

## KMD-EV-013 — Default-build initialization and retained callback question

- Repository: `source/bos-kmd`.
- Baseline: `develop @ 12d235aeedb8aa55ede24927c9e09f88c8f278c4`.
- File: Makefile:13–14; enumerate.c:119–127; blackhole.c:804–838,992–1014.
- Symbol: BLACKHOLEPLUS conditional probe block; blackhole_init; device-class callbacks.
- Related SAD section/interface: Cluster readiness; optional TLB/register/multicast supporting facilities.
- Observed behavior: Under BLACKHOLEPLUS the probe excludes the init_device/init_hardware/post-init/save-reset-state block. The inspected blackhole initialization routine sets kernel BAR/TLB/mutex state, while corresponding device-class callbacks remain defined.
- Evidence classification: Current implementation evidence (`IMPLEMENTATION EVIDENCE`).
- Limitations / ambiguity: OPEN ISSUE: supported optional callbacks and their initialization prerequisites need an owner decision for the intended build. This static observation is not a reproduced fault, does not prove a callback is invoked in the ordinary UMD transfer path and is not a formal SAD compliance judgment.

## Boundary conclusions reserved for review

Observed KMD services support device open, identity, mapping discovery, VMA establishment and resource lifetime. The inspected ordinary UMD memory/register payloads use established mappings. A static UMD→KMD dependency does not imply that every public UMD call invokes KMD. Kernel TLB configuration and multicast-capable fields cannot stand in for missing exact UMD API bindings.

No source, configuration, branch or commit was changed. No build, module load, hardware operation, runtime ABI test or concurrent/fault scenario was executed. [Traceability](traceability.md) records supporting alignments and unresolved mappings; final decisions remain in the five independent interface reviews and [report](../reports/sad-review-report.md).
