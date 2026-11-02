# Unified Engineering Workbench

An assessment prototype that combines ASCII STL and nodal temperature inspection, one-dimensional steady thermal FEM, reproducible CPU benchmarking, hand-coded backpropagation, and simulated embedded-device integration.

## Current delivery status

The C++17 core and Qt 5 desktop frontend are implemented. Five core test programs pass using the reproducible script below. Thermal and neural CSV/SVG outputs, a measured performance CSV, and four corresponding Numbers workbooks are included. The app compiled and linked on macOS arm64 with Qt 5.15.2. User-provided live macOS screenshots confirm ASCII STL import, synthetic nodal CSV import, four-mesh thermal results, one five-repeat performance run, neural-network calculations/training, and the simulated hardware-adapter page; see `outputs/walkthrough/`. The benchmark screenshot's hardware identity is unknown, and no physical hardware was tested. Windows 11 packaging, `Launch.exe`, Windows runtime bundling, and standalone execution have not been produced or tested. Do not treat this repository ZIP as the completed Windows one-click submission.

See [the technical report](docs/TECHNICAL_REPORT.md), [the phase plan and verification record](docs/PHASE_PLAN.md), [the architecture](docs/ARCHITECTURE.md), [the dependency record](DEPENDENCIES.md), [the AI-use log](AI_USE_LOG.md), and [the package readiness note](PACKAGING_STATUS.md).

## Prerequisites

- C++17 compiler with standard library threads.
- CMake 3.20 or newer for the CMake source build.
- Qt 5.15 or newer with Widgets and Concurrent for the desktop app.
- Git for source history and Git bundle.

The available development host had Apple Clang 21 and Qt 5.15.2, but no CMake. See `DEPENDENCIES.md` for observed versions, licensing notes, and limitations. The code has not been compiled with MSVC.

## Architecture

- `src/backend/`: Qt-independent C++17 geometry/CSV parsers, thermal FEM solver, parallel batch runner, neural network math, and hardware mocks.
- `src/frontend/`: Qt Widgets desktop application and painter-based geometry canvas.
- `tools/`: benchmark, backpropagation output, and thermal-result generation utilities.
- `tests/`: assertion-based focused tests for all five core modules.
- `data/`: self-created ASCII STL and explicitly synthetic temperature CSV examples.
- `results/`: measured benchmark samples, generated FEM/backpropagation CSVs, and labeled SVG plots.
- `docs/`: design, calculations, hardware integration, test/phase notes, and report.

## Build and run from source

### CMake

From the repository root on a machine with CMake and Qt installed:

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

Run `build/UnifiedEngineeringWorkbench` on single-configuration generators; on Visual Studio, run `build/Release/UnifiedEngineeringWorkbench.exe`. The CMake configuration is present but was not exercised here because CMake was unavailable.

### qmake

Use `UnifiedEngineeringWorkbench.pro` with Qt 5.15+ qmake, then build the generated project using the platform's normal build command. A local macOS SDK adjustment was needed on the development host; its absolute path is intentionally not committed.

## One-click launch and editor task

The requested Windows `Launch.exe` package is not available from this macOS-only environment. A relative-path Win32 launcher source and Windows packaging handoff script are in `packaging/windows/`; both are untested on Windows. The `.vscode/tasks.json` includes a **Launch packaged Unified Engineering Workbench** task that runs `Launch.exe` when that file exists at the repository root; the recommended `ms-vscode.cpptools` extension is listed in `.vscode/extensions.json`. These files do not substitute for a successful Windows build, Qt runtime bundle, or clean-machine test. No editor setup is required for a future standalone package.

## Supported input formats

- ASCII STL with finite vertex coordinates and structurally valid facets; binary STL is not currently supported. STL does not encode units.
- UTF-8/ASCII CSV with the exact header `node_id,x_m,y_m,z_m,temperature_C`; columns are ordered and use metres and degrees Celsius. The bundled example is synthetic, not an ANSYS export.
- File loaders enforce a 16 MiB limit and reject empty, malformed, or non-finite data.

## Tests and generated results

Run the direct C++17 test build and all test programs from the repository root:

```sh
./scripts/run_tests.sh
```

The five tests cover thermal assembly/BCs/convergence and invalid inputs; valid and malformed geometry/CSV; deterministic serial/parallel agreement; neural forward pass/finite differences/update/loss reduction; and device discovery/connect/disconnect/timeout recovery. `results/test_evidence/` contains timestamped output from an actual run.

`tools/capture_walkthrough.pro` builds the Qt screenshot capture utility. With Qt offscreen support, run `uew_capture_walkthrough <project-root> <output-directory>` to exercise module handlers and save PNGs plus a timestamped action log. Existing captures are in `outputs/walkthrough/`; they are offscreen, not a Windows desktop run.

Regenerate the thermal FEM CSV and SVG plots by compiling `tools/thermal_results.cpp` with `src/backend/thermal/thermal_solver.cpp`. The neural plot and training CSV are produced by `tools/backprop_demo.cpp`. Performance samples are recorded in `results/csv/performance_benchmark.csv`; benchmark results depend on hardware and load.

## Limitations

- CMake configuration/build is unverified on this host; the qmake build needed a local SDK workaround.
- Qt GUI offscreen captures are included in `outputs/walkthrough/` with a timestamped action log. The capture tool exercised module handlers and backend computations, but this session has no display server for normal-window verification.
- The geometry renderer is a lightweight projected canvas, not a production CAD/OpenGL viewer.
- UI cancellation, Windows `Launch.exe` packaging, Qt runtime bundling, standalone launch, and Windows editor configuration have not been validated.
- Hardware adapters are simulated only; no physical devices were tested.
- A candidate-provided handwritten calculation photo is appended to the report PDF. It is preserved as submitted; the parameter-update substitutions are not all expanded. The UI walkthrough remains an offscreen capture, not a live Windows demonstration.
- Candidate ID and total development hours were not provided or inferred.
