# AI use log

This log records only assistance and validation that have actually occurred. It will be updated as implementation proceeds.

## Phase 1

- **Tool/model:** OpenAI Codex, GPT-6 (this development session).
- **Representative prompt:** “Start with Phase 1: report a requirement-by-requirement implementation plan, recommended stack, proposed architecture, phase complexity, and prerequisites.”
- **Relevant assistance:** extracted and compared the official assignment PDF with the user's master prompt; proposed a Qt 6 desktop shell around an independent C++17 core; drafted the initial architecture and phase map; created the initial documentation and directory layout.
- **Developer edits:** none reported; this session is building the project from an initially empty workspace. The stack remains a recommendation and is not yet built.
- **Independent verification:** read all three pages of the official PDF; checked the project directory tree; inspected compiler, Git, and qmake versions. Structural verification found all planned directories and core documents. No application build or tests were performed.
- **Challenge test:** compared the master prompt's suggested six navigation sections with the official PDF. The PDF requires the coherent Geometry, Thermal Analysis, Performance, and Hardware views, while separately requiring neural-network calculations and submission/report materials. The plan follows the PDF's explicit view requirement while retaining the neural work and submission requirements; it does not silently treat the broader prompt's navigation list as authoritative.
- **Unsuitable suggestion identified:** none generated and then rejected in this phase. The challenge test above is the required deliberate check; its outcome is recorded rather than inventing a failed AI suggestion.

## C++ foundation and thermal solver

- **AI assistance:** Codex assisted with drafting the initial CMake target, C++17 solver, focused tests, and FEM notes in response to the user's request to proceed systematically after Phase 1.
- **Developer edits/review:** the implementation was reviewed against the PDF equations and requirements. A single-element prescribed-temperature edge case was found during review and corrected; a regression test was added. The current solution computes midpoint values by FE interpolation and compares them with the analytical solution.
- **Validation evidence:** Apple Clang 21 compiled the solver and tests with `-std=c++17 -Wall -Wextra -Wpedantic`; the test executable reported `thermal tests passed`. `git diff --check` was clean. CMake configuration was not run because CMake is unavailable.
- **Challenge:** verified the closed-form midpoint interpolation error `q h^2/(8k)` against all four required mesh sizes and checked the separate one-element edge case. This supports the calculations independently of nodal-only error checks.
- **Unsuitable suggestion identified:** no generated suggestion was rejected in this phase; the concrete implementation defect found by review was corrected and recorded in the FEM notes.

## Geometry and CSV parser work

- **AI assistance:** Codex drafted the C++ parser interfaces/implementation, negative tests, self-created examples, and format notes for the assignment's required ASCII STL and ANSYS-style nodal CSV formats.
- **Developer edits/review:** parser structure and validation were reviewed against the exact PDF schema and the ASCII-only requirement. The STL parser enforces facet structure and finite coordinates. The CSV requires the specified ordered header and five fields. A 16 MiB per-file limit is documented and tested.
- **Validation evidence:** Apple Clang 21 built the geometry and thermal test executables with C++17 warning flags; geometry and thermal test programs both reported `passed`. Geometry tests include valid/malformed/empty/non-finite cases, the oversize boundary, and bundled examples. `git diff --check` was clean.
- **Challenge:** the CSV fixture is expressly labeled synthetic and the STL's unitless nature is documented; neither is presented as an ANSYS export or CAD-origin file.
- **Unsuitable suggestion identified:** none in this segment; the validation challenge confirmed and documented the synthetic provenance and input limits.

## Serial/parallel performance work

- **AI assistance:** Codex drafted the deterministic batch generator, serial and bounded-thread runners, five-repetition benchmark protocol, CLI, tests, and performance record structure.
- **Developer edits/review:** checked result indexing for deterministic ordering, capped workers by requested count, logical CPU count, and case count, and added join cleanup if worker creation fails. The actual measured values were produced by running the compiled CLI, not supplied by AI.
- **Validation evidence:** the performance tests exercised reproducible generated cases, positive parameters, serial/parallel agreement for 1-4 requested workers, result ordering, invalid requests, five measured repetitions, speedup/efficiency formulas, and `<=1e-8 C` agreement. Geometry and thermal test executables also passed after integration.
- **Actual run:** 500 cases x 10,000 elements, seed `20261102`, Apple Clang 21.0.0, `-O2 -DNDEBUG` and warning/thread flags. The raw samples are in `results/csv/performance_benchmark.csv`; medians and machine details are in `docs/performance_benchmark.md`. Observed maximum difference: 0 C. UI launch-to-ready was not measured.
- **Challenge:** compared the parallel one-worker timing with serial and preserved its slower actual median as evidence of setup/scheduling overhead instead of smoothing or replacing it.
- **Unsuitable suggestion identified:** none; the intentionally challenged result is recorded as measured and interpreted with its limits.

## Handwritten backpropagation calculation

- **AI assistance:** Codex drafted the C++ forward pass, chain-rule gradients, simultaneous update, tests, loss-history CSV/SVG output, and concise derivation guide from the assignment's exact configuration.
- **Developer edits/review:** reviewed the chain rule and confirmed the update uses all gradients from the original parameter vector. No automatic differentiation library is used. The appendix is a guide for the candidate to write by hand; it is not represented as a completed handwritten submission.
- **Validation evidence:** the C++ test checks the forward pass, all four central finite differences (`epsilon=1e-6`, tolerance `1e-5`), each simultaneous update formula, 100 subsequent steps, and loss reduction. The test reported `backprop tests passed`. The actual C++ demo generated the CSV and SVG; loss decreased from `1.1825418190` to `1.7026224287e-20`.
- **Challenge:** verified each gradient numerically against independent central finite differences and retained the error threshold required by the PDF.
- **Unsuitable suggestion identified:** none; the finite-difference challenge is recorded as the deliberate validation check.

## Embedded-system mock and design

- **AI assistance:** Codex drafted simulated adapters and tests and used manufacturer documentation to prepare the representative NUCLEO-F446RE, Arty A7-35, and JTAG-HS2 design notes.
- **Developer edits/review:** explicitly modeled the Arty's separate onboard J10 USB-JTAG/UART and external J8 JTAG header. The external adapter is a debug/programming interface and is not represented as a compute board. Voltage and connector notes are tied to vendor manuals; no physical validation is claimed.
- **Validation evidence:** C++ tests exercised discovery/capabilities for all three devices, connection, telemetry, disconnection, and timeout recovery; output was `hardware tests passed`. A combined core compile also ran the hardware tests successfully.
- **Challenge:** checked the voltage-domain design against the manufacturer's distinct power and logic references, and documented the need to match JTAG VREF to the target and to keep the FPGA I/O below its specified limit.
- **Unsuitable suggestion identified:** none. The hardware documentation intentionally describes a safe plan and simulation boundary, not an unverified wiring claim.

## Desktop frontend

- **AI assistance:** Codex drafted the Qt 5.15 main window and module pages, projected geometry canvas, asynchronous parser/compute calls, plots, status messages, and CSV export controls.
- **Developer edits/review:** selected Qt 5 because it is the only installed Qt version, checked the C++17 target and local qmake build, and kept the machine-specific SDK framework search path out of the tracked project. The geometry canvas is described as projected painter-based rendering, not OpenGL or a production CAD viewer.
- **Validation evidence:** the GUI compiled and linked. Ordinary window creation failed with `Cannot create window: no screens available`. A Qt offscreen capture tool now runs the same asynchronous geometry import handlers, thermal solver, measured UI benchmark, mock hardware state changes, neural training, and results navigation, then saves timestamped PNGs and an action log. All five C++ test executables passed after frontend integration.
- **Challenge:** visual review of the first thermal screenshot showed the y-axis stopped at 100 C and clipped the analytical peak near 185 C. The chart range now derives from the analytical curve and FE nodes; the updated screenshot shows the entire curve. The Reports page also retained old nested rows across refreshes; recursive layout cleanup fixed the duplicates/overlap. The screenshot tool calls the same asynchronous import handler used after file selection, while explicitly not claiming that the file picker or a live desktop was visually exercised.
- **Unsuitable suggestion identified:** none in the initial UI implementation; the deliberate screenshot challenge exposed and corrected the thermal chart range and report-list refresh defects.

## Ownership statement (current)

The project architecture, source, self-created examples, and documentation in this repository were created for this assessment workspace. No third-party project code or datasets were incorporated. Qt and report-generation dependencies, versions, and licensing notes are recorded in `DEPENDENCIES.md`.

## Candidate handwritten calculation and report appendix

- **AI assistance:** Codex provided the assignment's sample values and worked numerical forward-pass, gradient, and parameter-update values from the project's derivation guide, then reviewed the candidate-provided handwritten calculation photo.
- **Candidate contribution:** The candidate wrote and photographed the calculation by hand. The photo was appended to the technical report unchanged at the candidate's request.
- **Validation and limitation:** The values shown were checked against the derivation guide. The submitted handwritten page shows the final updated parameter values, but does not expand every update as a full learning-rate-times-gradient substitution. No edits were made to the handwriting or photo content.

## Live macOS UI verification and table display fix

- **Candidate evidence:** The candidate opened the rebuilt application in a visible macOS window and supplied screenshots showing the ASCII tetrahedron (4 triangles), synthetic nodal temperature CSV (5 nodes), and completed four-mesh thermal analysis.
- **AI assistance and change:** After reviewing the thermal screenshot, Codex identified that the convergence table values were invisible in the live UI and set an explicit dark text color for table cells. The app was rebuilt, and the candidate's later screenshot shows all four expected errors: 1.25, 0.3125, 0.078125, and 0.01953125 C.
- **Performance evidence:** The candidate supplied a live macOS screenshot of a completed five-repeat benchmark using 500 cases of 1000 elements. The UI displayed median serial time 10.4909 ms and parallel medians 8.0225, 4.2765, 2.9766, and 2.3191 ms for 1–4 workers, with speedups 1.3077, 2.4532, 3.5245, and 4.5237, respectively; maximum temperature difference was 0 C. This screenshot documents that run only; the host hardware is unidentified and independent reproduction is not established.
- **Neural and hardware evidence:** The candidate supplied a live screenshot showing the UI's forward pass, gradients, one simultaneous parameter update, and displayed loss after 100 steps. Another screenshot shows NUCLEO-F446RE with “simulated” in the adapter label and connection state. These confirm visible UI behavior only; no physical device was connected or tested.
- **Additional user materials:** The candidate supplied four Numbers workbooks for the thermal rod, thermal FEM, performance benchmark, and backpropagation outputs. They were copied without editing into `outputs/spreadsheets/` and added to the source/evidence archive. Screenshots of the workbook views and the thermal FEM formulation page were preserved in the walkthrough folder. The typed FEM formulation in `docs/calculations/thermal_fem.md` records the model, element matrices, Thomas solve, analytical midpoint-error check, and one-element boundary-condition regression case.
- **Validation scope:** The screenshots verify these displayed Mac workflows only. No additional automated test suite was run for this style-only change, and Windows packaging remains unverified.
