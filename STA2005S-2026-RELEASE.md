# STA2005S 2026 — v0.2.0 teaching-material snapshot

- [Lecture documents](https://github.com/MiguelRodo/lectures/releases/tag/slides-2026-sta2005s-v0.2.0): download `STA2005S-Lectures-v0.2.0.zip` (36 documents).
- [Evaluation documents — private access required](https://github.com/MiguelRodo/eval/releases/tag/eval-2026-sta2005s-v0.2.0): download `STA2005S-Evaluation-v0.2.0.zip` (27 documents).

Extract each ZIP and open its `index.html`. The bundles include PDFs and HTML with embedded resources. Release manifests and SHA-256 checksums accompany the downloads. Evaluation answers and solutions remain in the private repository for the instructor authoring/conversion workflow.

This compendium coordinates independent repositories, rather than Git submodules. `repos.list` retains the development branches. `repos.sta2005s-2026-v0.2.0.list` selects the current course release tags; the 2025 archives and data repository keep their existing refs. `STA2005S-2026-v0.2.0.json` records exact source commits, including those unchanged repositories.

The lecture and evaluation tags point to stable 0.2.0 source commits. Their development branches resume at 0.2.0-1; publication does not add another minor version. The compendium has no separate R-package version; this tag identifies the coordinated snapshot.

Full builds use the existing original projr workflow, the attached repositories’ explicit `_projr-localonly.yml` profiles and `scripts/r/build_local.R`. The helper preserves configured publication destinations while suppressing git and upload actions during local builds. Course build dependencies are required. This release does not upload to Amathuba.
