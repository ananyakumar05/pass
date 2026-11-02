# Package readiness

This workspace contains a source-and-evidence package candidate. It is not the verified Windows submission.

- The assigned candidate ID is `RA2311003011025`; the refreshed archive uses that ID in its filename. Confirm the assessment portal requires the same filename convention before uploading.
- `Launch.exe` and the Qt Windows runtime bundle are not present. The checked-in relative-path launcher source and `packaging/windows/Build-WindowsPackage.ps1` have not been built or run on Windows.
- A GitHub Actions workflow now exists at `.github/workflows/build-windows.yml` to build and package on a Windows runner. It has not been executed, so no Windows binary or verified Windows package is available yet.
- CMake is not installed in the available macOS environment. CMake configuration, Windows/MSVC compilation, ZIP extraction, one-click launch, and clean-machine verification are unverified.
- The evidence includes nine Qt offscreen walkthrough captures and nine user-provided live macOS screenshots showing STL import, synthetic CSV import, four-mesh thermal results, a five-repeat performance run, neural-network calculations/training, a simulated hardware connection, thermal FEM documentation, and Numbers workbook views. Four Numbers workbooks are included. These do not verify Windows standalone behavior or establish the host hardware identity; physical hardware was not tested.
- A candidate-provided handwritten calculation photo has since been appended to the report PDF in `outputs/Unified_Engineering_Workbench_Technical_Report.pdf`. It shows the forward pass, gradients, and final parameter values; the full substituted arithmetic for each update is not written out.

Use the Windows packaging handoff only on a Windows 11 x64 development machine with compatible Visual Studio and Qt tools. Follow its clean-machine checklist and verify license notices/runtime obligations before treating the resulting archive as submission-ready.
