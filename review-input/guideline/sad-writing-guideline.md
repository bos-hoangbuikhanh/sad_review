---
artifact: SAD Writing Guideline
source: Confluence
page_title: "SAD Writing Guideline"
page_id: "546996303"
space: "Software Engineering"
author: "Jeong Park"
source_updated: "Aug 25"
snapshot_date: "2026-10-07"
---

# SAD Writing Guideline

- 1 [1. Overview](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#1.-Overview)
  - 1.1 [1.1. SAD content tree](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#1.1.-SAD-content-tree)
  - 1.2 [1.2. How to read this guideline](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#1.2.-How-to-read-this-guideline)
  - 1.3 [1.3. Terminology legend](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#1.3.-Terminology-legend)
  - 1.4 [1.4. Important notes:](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#1.4.-Important-notes%3A)
- 2 [2. Software Level](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#2.-Software-Level)
  - 2.1 [2.1. Static diagram](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#2.1.-Static-diagram)
  - 2.2 [2.2. List of software components](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#2.2.-List-of-software-components)
  - 2.3 [2.3. Interfaces between our software and external systems/sub-systems](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#2.3.-Interfaces-between-our-software-and-external-systems%2Fsub-systems)
- 3 [3. Software Component Level](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#3.-Software-Component-Level)
  - 3.1 [3.1. Static view](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#3.1.-Static-view)
    - 3.1.1 [3.1.1. Diagram](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#3.1.1.-Diagram)
    - 3.1.2 [3.1.2. Interface Description](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#3.1.2.-Interface-Description)
  - 3.2 [3.2. Dynamic view](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#3.2.-Dynamic-view)
    - 3.2.1 [3.2.1 Activity Diagram](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#3.2.1-Activity-Diagram)
    - 3.2.2 [3.2.2 Sequence Diagram](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#3.2.2-Sequence-Diagram)
- 4 [4. SW Architecture Analysis](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#4.-SW-Architecture-Analysis)
  - 4.1 [4.1. Timing / Performance Analysis](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#4.1.-Timing-%2F-Performance-Analysis)
  - 4.2 [4.2. Resource Consumption Analysis](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#4.2.-Resource-Consumption-Analysis)
  - 4.3 [4.3. Architecture Design Rationale](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#4.3.-Architecture-Design-Rationale)
  - 4.4 [4.4. Reuse and Suitability Assessment](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#4.4.-Reuse-and-Suitability-Assessment)
  - 4.5 [4.5. Project Estimate / Planning Impact](https://bos-semi.atlassian.net/wiki/spaces/SE/pages/546996303/SAD+Writing+Guideline#4.5.-Project-Estimate-%2F-Planning-Impact)

# 1. Overview

This section explains the purpose and structure of this Software Architecture Design (SAD) guideline. It helps teams document the software architecture consistently, from the high-level software view down to each software component view. The SAD should make the architecture understandable, reviewable, and traceable for implementation, integration, testing, and ASPICE Base Practice evidence.

## 1.1. SAD content tree

Codebeamer Template: [Software Architecture Design Specification Template (SAD)](http://cb.corp.bos-semi.com/cb/tracker/271456 "http://cb.corp.bos-semi.com/cb/tracker/271456")

- **Software Architectural Design at Software level →** [Software Level](https://bos-semi.atlassian.net/wiki/spaces/SSPH/pages/536674429 "https://bos-semi.atlassian.net/wiki/spaces/SSPH/pages/536674429")

  - Static view

    - Diagram
    - List of software components
    - Interface description

      - Interface 1
      - Interface 2
      - …
      - Interface N
  - Dynamic view
- **Software Architectural Design at SW component level →** [Software Component Level](https://bos-semi.atlassian.net/wiki/spaces/SSPH/pages/536674429 "https://bos-semi.atlassian.net/wiki/spaces/SSPH/pages/536674429")

  - [SWC-01] SWC 1

    - Static view

      - Diagram
      - Interface description

        - Interface 1
        - Interface 2
        - …
        - Interface N
    - Dynamic view
  - [SWC-02] SWC 2…
  - [SWC-03] SWC 3…
  - …
  - [SWC-N] SWC N…
- **SW Architecture Analysis →** [SW Architecture Analysis](https://bos-semi.atlassian.net/wiki/spaces/SSPH/pages/536674429 "https://bos-semi.atlassian.net/wiki/spaces/SSPH/pages/536674429")

  - Timing / Performance Analysis
  - Resource Consumption Analysis
  - Architecture Design Rationale
  - Reuse and Suitability Assessment
  - Project Estimate / Planning Impact

## 1.2. How to read this guideline

Read this guideline from the top-level software architecture first, then drill down into each software component. The recommended reading flow is:

1. Start with Section 1.1 SAD content tree to understand the expected document structure and the relationship among the software level, software component level, and SW architecture analysis.
2. Read Section 2 Software Level to understand the overall software architecture, including the static diagram, list of software components, and external or subsystem interfaces.
3. Use Section 3 Software Component Level for each SWC listed in Section 2.2. For each software component, describe the applicable static view, provided interfaces, required interfaces, API details, and dynamic behavior according to its Design Scope defined in Section 2.2.
4. Perform Section 4 SW Architecture Analysis after the draft architecture is defined and before formal stakeholder review. Evaluate technical feasibility, relevant quality characteristics and constraints, timing/performance, resource usage, architecture decisions and rationale, reuse/suitability, and project estimate/planning impact as applicable.
5. Use Section 4 as the default Architecture Analysis Evidence. Architecture Analysis is a separate engineering activity from formal stakeholder Review; a separate Architecture Analysis Report is not required by default. Record evaluation results, assumptions, constraints, rationale, and conclusions in the SAD.
6. Check the examples and templates in each subsection before creating new content. Keep naming, table format, diagram style, interface descriptions, and analysis tables consistent across all components.
7. Use Section 5 when source code analysis, diagram generation, or draft documentation can be accelerated with ChatGPT, Copilot, or similar tools. Always review and correct AI-generated outputs before using them as official SAD content.

## 1.3. Terminology legend

- Software level: the top-level architecture view that shows the main software components and interfaces with external systems or subsystems.
- Software component level: the detailed architecture view for each SWC, including internal modules, provided interfaces, and required interfaces.
- Static view: the structural view, including diagrams, component lists, and interface descriptions.
- Dynamic view: the behavioral view that describes software component internal behavior and inter-component behavior at runtime.
- BP: Base Practice evidence used for ASPICE assessment.

## 1.4. Important notes:

1. This guideline's structure may differ slightly from the tree in Codebeamer, as it is designed to help readers understand how to create SAD. However, the overall content aligns with the Codebeamer format
2. Since we are reverse engineering, we should use AI tools like ChatGPT and Copilot to speed SAD creation and reduce workload. These tools analyze our source code and generate diagrams and documents. Refer to How to create SAD with AI tools support for details.

# 2. Software Level

The software level describes the system at the highest level of abstraction. It shows how external systems, users, or other subsystems interact with our software, highlights the main responsibilities of the software, and explains the key data/control flows across system boundaries.

At the software level, provide three kinds of information:

- [1] Static diagram showing our software's decomposition into smaller components → Static Diagram at SW Level
- [2] List of software components → 2.2. List of software components
- [3] Interfaces between our software and external systems or subsystems → Static Diagram at SW Level
- [4] How each component connects to others → Static Diagram at SW Level

## 2.1. Static diagram

It shows the main internal components and their communication. Describe each component’s responsibility and key interactions.

- Each component should represent a major part of the software with a clear responsibility.
- The diagram should show how these components are connected

![image-20260720-070712.png](assets/image-20260720-070712.png)

Static Diagram at SW Level

Note: Use meaningful component names, and label the arrows with interface names, so readers can understand the architecture without additional explanation.

## 2.2. List of software components

This section should include a brief description of each SWC's functionalities designed in 2.1. Static Diagram and identify the Design Scope of each component.

| SW Component ID | Description | Design Scope |
| --- | --- | --- |
| [SWC-01] SWC Safety Monitoring | The Safety Monitoring shall: Coordinate board bring-up and startup sequencing. Initialize safety features and supervision chain. Execute periodic safety loop and coordinate major safety modules. | BOS-developed |
| [SWC-02] SWC Error Manager | The Error Manager shall: Consume error events from collectors/interrupt sources. Classify severity and dispatch handling actions. Coordinate clearing, recovery, and escalation. | BOS-developed |
| [SWC-03] SWC Error Monitoring | The Error Monitoring shall: Monitor occurrence and recurrence of system errors. Track frequency and trend of repeated faults. Provide monitoring status to error handling/reporting paths. | BOS-developed |
| [SWC-04] SWC Error Reporting | The Error Reporting shall: Package and transmit error/heartbeat data to External Safety MCU. Maintain E2E frame context (request ID, unique ID echo, counter, CRC). Process incoming external commands related to safety control. | BOS-developed |

**Black-box Components**

A third-party or externally supplied software component may be treated as a black-box when its internal design is not controlled or modified by BOS. Identify such components as Third-party / Black-box in the Design Scope column.

- Internal decomposition and internal implementation behavior may be omitted for a black-box component.
- The SAD shall still provide sufficient externally observable information for architecture understanding, integration, and verification, including applicable interfaces, inputs/outputs, expected behavior, relevant states or modes, error/recovery behavior, and applicable timing or interaction constraints.
- If the available interface and behavior information is insufficient for integration or verification, additional information shall be identified or obtained.
- BOS-developed wrapper, adaptation, configuration, or control logic shall be described separately when it contains meaningful design or runtime behavior.

## 2.3. Interfaces between our software and external systems/sub-systems

They show which external systems, users, or subsystems communicate with our software. For each interface, describe the purpose, main input/output data, communication method, and direction of data or control flow.

*For example:*

The SPI Communication provides safety communication over SPI (master or slave) for error reporting and alive health monitoring with external Safety MCU. It ensures data integrity, bounded latency, and independent fault detection from the Mainland execution.

| Interface Name | SPI Data transmission |
| --- | --- |
| Interface Type | Hardware signals |
| Description | The system uses the SPI protocol (Master/Slave based on Customer requirements) to exchange data with External Safety MCU. Software shall access to SPI related registers for HW configuration. Operating mode: Master/Slave based on customer requirements. Operating Frequency: 10 MHz (the other frequencies also shall be supported based customer requirements). Clock Polarity (CPOL): 0 (CPOL 1 also shall be supported based customer requirements). Clock Phase (CPHA): 0 (CPHA 1 also shall be supported based customer requirements). Transfer Mode: Full duplex (Transmit and Receive or Transmit only or Receive only based customer requirements). Data Frame: 8-bit (16-bit/32-bit also shall be supported based customer requirements). Software shall write to SPI related Data registers for exchanging data. |
| Provider Component | Safety Island CM7 |
| Consumer Component | External Safety MCU |
| Preconditions | System ready (Safety Island M7 booted up successfully) |
| Output | SPI data message sent to External Safety MCU |

For more details, refer to this document for External interface description at SW level → [Interface description SADS-187289](http://cb.corp.bos-semi.com/cb/issue/187289 "http://cb.corp.bos-semi.com/cb/issue/187289")

# 3. Software Component Level

The software component level describes the internal design of each software component listed in the Software Level (SWC-01 Safety Monitoring, SWC-02 Error Manager, SWC-03 Error Monitoring, SWC-04 Error Reporting, …). It shows how each component is decomposed into smaller internal modules or units, defines the provided and required interfaces (APIs), and explains the connections between internal parts. For components identified as black-box in Section 2.2, internal decomposition may be omitted according to the defined Design Scope.

The purpose of this table is to summarize the selected software component at the SWC level, including its ID, name, responsibilities, provided APIs, required interfaces, and global variables. It provides a quick reference for understanding the component scope before detailing its static and dynamic design.

| SWC ID | SWC-02 |
| --- | --- |
| Name | SWC Error Manager |
| Description | Provides full error lifecycle management for the SAFE subsystem by receiving, mapping, and dispatching hardware interrupt notifications from the Error Collector and Error Handler drivers. The component maps IRQs to error table entries, enqueues errors by severity, clears and re-enables hardware error sources, forwards error data to external blocks via the Error Reporting module, triggers software alerts through the Error Handler Controller for safety-critical errors, and passes errors to the Error Monitoring module for latency tracking. |
| Provided interface | error\_manager\_init error\_manager\_process error\_manager\_push\_error |
| Required interface | error\_collector\_register\_error\_event error\_collector\_enable\_all\_blocks error\_collector\_get\_reg error\_collector\_set\_reg error\_collector\_enable\_err\_en error\_collector\_diag\_clock\_clear\_error error\_handler\_register\_error\_event error\_handler\_controller\_software\_alert\_indicate error\_reporting\_send\_data error\_reporting\_get\_error\_level error\_monitoring\_process error\_profiling\_start error\_profiling\_set\_error error\_profiling\_stop mailbox\_controller\_send\_msg clock\_monitoring\_is\_started clock\_monitoring\_clear\_state |
| Global Variables | N/A |

## 3.1. Static view

### 3.1.1. Diagram

AI Agent Instruction

This diagram shows the **decomposition** of a software component into smaller internal modules or units. At this level, describe how the selected component is designed internally, including its sub-components, their responsibilities, and how they communicate with each other.

For the software component level, provide the following information:

1. Provided and required interfaces: Show interfaces a component provides to others, which other components can use. Show interfaces a component requires as input for internal operations.
2. Internal decomposition: show the main internal modules, units or interfaces inside the component. Each item should have a clear responsibility.
3. Internal interface connection: illustrate how internal parts communicate, showing connections between parts or interfaces without details.
4. (Optional) Data/control flow: explain the important input, output, and processing flow inside the component.

*Note: Use meaningful names for internal modules and label arrows with interface names, data names, or control signals so readers can understand the component design clearly.*

For example:

![image-20260720-072514.png](assets/image-20260720-072514.png)

Static Diagram at SWC level

For more details, refer to [Software Architectural Design at SW component level SADS-187336](http://cb.corp.bos-semi.com/cb/issue/187336 "http://cb.corp.bos-semi.com/cb/issue/187336")

### 3.1.2. Interface Description

The interface description explains how other software components or modules can use an API provided by this component. Each API should be documented clearly so the caller understands its purpose, required inputs, expected outputs, and possible results.

For each API, provide the following information:

1. Interface name: write the exact API/function name, including its return type and parameters if applicable.
2. Interface type: describe the return data type or interface category.
3. Description: explain what the API does, when it should be called, and any important conditions, limitations, or sequence requirements.
4. Consumer software component(s): list the software components, modules, or users that call or use this API.
5. Parameter(s): describe each input/output parameter, including name, type, direction, valid range, and meaning. If there is no parameter, write None.
6. Return value: describe all possible return values and what each value means, including success and error cases.

*Note: The API description should be detailed enough for implementation, integration, and testing. Use exact names from the source code and keep the description consistent with the component design.*

| Interface Name | int8\_t error\_manager\_init(void) |
| --- | --- |
| Interface Type | int8\_t |
| Description | This API initializes the Error Manager module, making the system ready to receive error signals from the Error Collector and the Error Handler hardware. Once called successfully, the Error Manager is fully set up to detect, classify, and process error events from all SoC subsystems (CPU, NPU, PCIe, MIFCL, SAFE block, etc.) through its main processing loop error\_manager\_process(). This interface shall be called once during system startup and before error\_manager\_process(). Note: ensure that error\_manager\_init() is called exactly once during the system initialization phase, and the integration code guarantees that no repeated invocation occurs. |
| Consumer SW Component(s) | Safety Monitoring |
| Parameter(s) | None |
| Return value |  |

For more details, refer to [Software Architectural Design at SW component level SADS-187336](http://cb.corp.bos-semi.com/cb/issue/187336 "http://cb.corp.bos-semi.com/cb/issue/187336")

## 3.2. Dynamic view

The Dynamic View complements the static architecture by describing **Component Internal Behavior** and **Inter-component Behavior** at runtime. The behavior shall be described at a level sufficient to support applicable software component and integration verification.

- Component Internal Behavior: describes how an individual software component reacts to a trigger or input, performs major processing and decisions, changes relevant state or data, and produces an output or observable result.
- Inter-component Behavior: describes how software components interact through interfaces, events, messages, callbacks, or other communication mechanisms to realize software behavior.

An Activity Diagram is recommended as the primary representation of Component Internal Behavior. It may also include interactions with other components when those interactions are necessary to understand the component behavior.

When an Activity Diagram alone is not sufficient to describe the behavior at a level needed for verification, additional textual description shall be provided. The description should clarify applicable conditions, states or modes, concurrency, timing constraints, error or recovery behavior, or other information necessary to understand and verify the behavior.

A Sequence Diagram shall be created for critical interaction scenarios where correctness depends on interaction order, asynchronous communication, timing, synchronization, state dependency, or error/recovery behavior between software components. The Sequence Diagram should show the participating components, messages or calls, exchanged data where relevant, conditions, and important timing or response constraints.

The level of detail and number of Dynamic Views may vary according to the component behavior and verification needs. Components that only provide static data or configuration and have no meaningful runtime behavior may be excluded, provided that the reason is documented.

**Applicability Criteria**

Dynamic View applicability shall be determined based on the architectural significance of the component behavior and interaction and the verification needs, rather than by applying the same diagram set to every software component.

- Component Internal Behavior shall be described for software components with meaningful runtime behavior. An Activity Diagram is recommended as the primary representation; additional textual description may be used where needed for verification.
- Components that only provide static data/configuration or have no meaningful runtime behavior may omit the Dynamic View with a documented rationale.
- A Sequence Diagram shall be created when an inter-component interaction is architecturally significant due to one or more of the following: safety or security relevance; execution order dependency; timing or latency dependency; asynchronous communication, interrupt, callback, or message-queue behavior; concurrency or synchronization; state or mode dependency; error, recovery, reset, or fallback behavior; or interaction complexity that is not sufficiently explained by the Activity Diagram.

For components identified as black-box in Section 2.2, internal behavior may be omitted. Architecturally significant interactions with the black-box component shall still be described according to the Dynamic View applicability criteria.

### 3.2.1 Activity Diagram

AI Agent Instructions

*Ex) UML notation*

![image-20260724-030329.png](assets/image-20260724-030329.png)

### 3.2.2 Sequence Diagram

AI Agent Instructions

*Note: Create the Sequence Diagram only when the timing or event ordering between software components has a functional impact. Otherwise, describe the logical behavior using an Activity Diagram.*

![image-20260724-030355.png](assets/image-20260724-030355.png)

# 4. SW Architecture Analysis

Architecture Analysis is an engineering activity performed after a draft SAD is defined and before formal stakeholder review. It evaluates whether the defined software architecture is technically feasible and suitable for the target system, relevant software requirements, and applicable constraints. Section 4 of the SAD is the default Architecture Analysis Evidence; a separate Architecture Analysis Report is not required by default.

The analysis should cover the following aspects as applicable:

- Technical feasibility
- Relevant quality characteristics and constraints
- Timing / performance
- Resource usage and constraints
- Architectural design decisions and rationale
- Reuse and suitability, where applicable
- Alternative/reference architecture comparison when a meaningful architecture choice exists
- Project estimate / planning impact

**[Instruction]**

Record a concise overall analysis summary before the detailed subsections. At minimum, explicitly state the analysis result and rationale for Technical Feasibility and Relevant Quality Characteristics / Constraints. Use Sections 4.1–4.5 for the detailed timing/performance, resource, architecture-decision, reuse/suitability, and project-planning evidence. If an aspect is not applicable, state N/A with a short reason rather than leaving the evidence ambiguous.

| Analysis Aspect | Result / Rationale |
| --- | --- |
| Technical Feasibility | Feasible / Conditional / Not Feasible — summarize the basis, assumptions, constraints, and required follow-up where applicable. |
| Relevant Quality Characteristics / Constraints | Identify the applicable quality characteristics or constraints and summarize how the architecture addresses them; reference Sections 4.1–4.5 when detailed evidence exists. |

*Note: Record evaluation results, assumptions, constraints, rationale, and conclusions. The SAD Review Checklist verifies that this evidence is present and appropriate; it does not replace the Architecture Analysis activity itself.*

## 4.1. Timing / Performance Analysis

**[Instruction]**

This subsection describes the timing and performance evaluation of the software architecture. The purpose is to ensure that the defined architecture satisfies applicable timing/performance constraints and that important execution paths fit the target system.

The following information should be described where applicable:

- Execution context of software components, such as task or interrupt
- Execution cycle of periodic functions or response-time constraints
- Estimated execution time or worst-case execution time
- Performance-critical path or bottleneck, when relevant
- CPU load contribution and overall load estimation, when meaningful
- Compliance with applicable timing/performance constraints

Timing/performance analysis may be performed using engineering estimation, static analysis, measurement-based evaluation, simulation, or other suitable engineering evidence. The analysis should preferably consider overall scheduling/critical-path behavior rather than each component in isolation.

**[Example]**

| Component | Execution Context | Cycle Time | Estimated Execution Time | CPU Load Contribution | Remarks |
| --- | --- | --- | --- | --- | --- |
| Safety Monitoring | OS Task: SafetyTask | 10 ms | 1.8 ms | 18% | Includes fault detection and diagnostic update |
| Communication Manager | OS Task: CommTask | 20 ms | 0.9 ms | 4.5% | Handles CAN message processing |
| Diagnostic Service | OS Task: DiagTask | Event-based | 0.6 ms | Negligible | Executed only when a diagnostic request is received |

The Safety Monitoring component is executed periodically every 10 ms within the SafetyTask. The estimated worst-case execution time is approximately 1.8 ms.

The total CPU load of the software architecture is estimated to be approximately 42%, which satisfies the system constraint of CPU load below 70%.

## 4.2. Resource Consumption Analysis

**[Instruction]**

This subsection describes the evaluation of software resource consumption to ensure that the software architecture fits within the hardware resource limitations.

Typical resource aspects include:

- ROM / Flash usage
- RAM usage
- Stack usage
- Buffer usage
- Global memory usage

Resource analysis may be based on estimation during early design phases and refined using measurements after implementation. Both component-level estimation and total resource consumption should be described where possible.

**[Example]**

| Component | ROM Usage | RAM Usage | Stack Usage | Remarks |
| --- | --- | --- | --- | --- |
| Safety Monitoring | 18 KB | 3 KB | 512 B | Includes fault detection logic |
| Communication Manager | 12 KB | 2 KB | 384 B | Handles CAN message processing |
| Diagnostic Service | 8 KB | 1 KB | 256 B | UDS diagnostic service |

**Total resource estimation:**

| Resource | Estimated Usage | Available Resource | Margin |
| --- | --- | --- | --- |
| ROM | 38 KB | 256 KB | Sufficient |
| RAM | 6 KB | 64 KB | Sufficient |
| Stack | 1.1 KB | 8 KB | Sufficient |

The estimated ROM usage of the software architecture is approximately 38 KB. The estimated RAM usage is approximately 6 KB. Both values are within the available memory limits of the target hardware platform.

## 4.3. Architecture Design Rationale

**[Instruction]**

This subsection describes the key architectural design decisions and their rationale. The purpose of this section is to explain why the software architecture is structured in a particular way.

Typical aspects that may be addressed include:

- Component decomposition strategy
- Interface design decisions
- Communication mechanisms between components
- Separation of functional responsibilities
- Maintainability and scalability considerations
- Performance considerations

Each significant architectural decision should be accompanied by a short explanation describing the reasoning behind the decision.

When a meaningful alternative, reference architecture, or platform choice exists, record the relevant comparison criteria and why the selected option was chosen. Do not invent artificial alternatives when there is no meaningful alternative.

**[Example]**

| Design Decision | Rationale |
| --- | --- |
| Centralized Safety Supervisor | Centralizing safety control simplifies coordination and improves system-level verification. |
| Separation of Monitoring, Reaction, and Reporting | Functional separation improves modularity and limits the impact of changes. |
| Hardware Abstraction Layer | Hardware abstraction decouples safety logic from device-specific drivers. |
| Dedicated Reset and Recovery Control | Centralized reset handling ensures predictable system recovery behavior. |

**Centralized Safety Supervisor**

- A dedicated safety supervisor component coordinates safety-related initialization and periodic supervision of safety mechanisms.
- This component provides a single control point for safety activities within the Safety Island architecture and simplifies system startup sequencing.

**Separation of Monitoring, Reaction, and Reporting**

- Fault monitoring, fault reaction, and error reporting functions are implemented as separate software components.
- This separation reduces complexity and allows each function to be developed, verified, and maintained independently.

**Hardware Abstraction Layer**

- Hardware-dependent services such as timers, communication interfaces, GPIO control, and interrupt services are accessed through a common abstraction layer.
- This approach isolates safety application logic from hardware-specific driver implementations and improves portability and maintainability.

**Dedicated Reset and Recovery Control**

- Reset and recovery operations are handled by a dedicated architectural function.
- Centralizing reset handling prevents conflicting reset requests and ensures consistent system recovery behavior during fault conditions.

## 4.4. Reuse and Suitability Assessment

**[Instruction]**

This subsection evaluates the suitability of reused software components or frameworks within the defined architecture.

The following aspects may be considered:

- Reused software modules
- Platform libraries
- Third-party components
- AUTOSAR BSW components
- Previously developed internal components

The assessment should describe whether the reused component is appropriate for the current project context.

Evaluation criteria may include:

- Functional suitability
- Interface compatibility
- Resource impact
- Compliance with system constraints

**[Example]**

| Component | Source | Reuse Type | Suitability Assessment |
| --- | --- | --- | --- |
| Watchdog Manager | Platform Library v3.2 | Reused component | Previously used in multiple projects with proven reliability |
| Communication Driver | AUTOSAR BSW | Framework component | Fully compatible with the communication stack |
| Diagnostic Service | Internal Module | Reused module | Minor interface adaptation required |

The component has been used in previous projects and has demonstrated stable operation in production environments. Any adaptation, limitation, or verification activity required for reuse should be recorded as part of the suitability assessment.

## 4.5. Project Estimate / Planning Impact

**[Instruction]**

Evaluate whether significant architecture decisions create a meaningful impact on project estimate or planning. Consider schedule, engineering resources, tooling/environment, integration or verification scope, and other project-planning items only when relevant.

- Record identified impact and required follow-up in the SAD or linked project record.
- Communicate significant planning impact to PM so the WBS/project plan can be updated when needed.
- If there is no significant impact, a short statement such as “No significant planning impact” is sufficient.
