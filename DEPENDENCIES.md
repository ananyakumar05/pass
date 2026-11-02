# Build and dependency record

## Application dependencies

| Component | Version / requirement | Use | Verification |
|---|---|---|---|
| C++ | C++17 | All parsing, numerical computation, concurrency, and simulated device logic | Core modules and five test programs compiled with Apple Clang 21 on macOS arm64 |
| Qt | Qt 5.15.2, Widgets and Concurrent | Desktop interface, asynchronous tasks, and event handling | GUI compiled and linked with the available qmake. Interactive display could not be opened in this session. |
| CMake | 3.20 or newer | Cross-platform source build configuration | Not installed on this host; CMake configure/build remains unverified. |
| Threads | C++ standard library threads | Bounded parallel batch execution | Performance tests and benchmark executable compiled and ran. |
| ReportLab | 4.4.9 (report generation environment only) | Build the assessment PDF report | Not a runtime dependency; PDF was rendered and inspected before delivery. |

The C++ core does not depend on Qt. No external C++ package manager or third-party C++ libraries are used, so there is no package lockfile. The versions and unresolved platform checks are recorded here instead. The installed Qt runtime is dynamically linked. Any Windows redistribution must include the appropriate Qt libraries and applicable LGPL/GPL notices and comply with the selected Qt licensing terms. No Qt runtime bundle is included in this source archive.

## Observed development toolchain

- Apple Clang 21.0.0, macOS arm64.
- Qt 5.15.2 from the available Anaconda qmake installation.
- CMake was not found on `PATH` or in the checked local tool locations.
- Windows 11 x64, MSVC, and the Windows Qt deployment tools were not available for verification.

## Reproduction notes

- Run `./scripts/run_tests.sh` on macOS/Linux with a C++17 compiler and standard threads support.
- Configure and build the application using CMake 3.20+ and Qt 5.15+ Widgets/Concurrent, or use `UnifiedEngineeringWorkbench.pro` with matching qmake.
- The local Qt build needed a machine-specific SDK framework search-path adjustment due to a mismatch between the installed Qt and host SDK. That path is intentionally not stored in project files. A clean cross-platform build must be confirmed on the target environment.
