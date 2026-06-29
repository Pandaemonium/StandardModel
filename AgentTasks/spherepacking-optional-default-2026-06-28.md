# SpherePacking made optional by default

Date: 2026-06-28

Purpose:

```text
Remove Sphere-Packing-Lean as a hard dependency from the default Lake workspace
and Aristotle submission flow, while preserving SPL-facing bridge files for
explicit E8/sphere-packing jobs.
```

Changes:

```text
lakefile.toml:
  The active SpherePacking `[[require]]` block was commented out and replaced
  with opt-in instructions.

lake-manifest.json:
  Removed the hard path package entry for SpherePacking.

Scripts/prepare_aristotle_submission.ps1:
  Added `-IncludeSpherePacking`.
  The helper is now SPL-free by default and only patches a remote
  Windows-safe SpherePacking dependency when `-IncludeSpherePacking` is passed.

docs/ARISTOTLE.md / docs/BUILD.md:
  Updated to say SpherePacking is optional and should not be included in
  unrelated Gate C / NullStrand packages.
```

Safety boundary:

```text
No dummy SpherePacking declarations were introduced.
No SPL theorem was replaced by a fake theorem.
SPL-facing modules remain source files, but they are optional targets and will
fail unless an SPL-enabled package is used.
```

How to use:

```text
Normal Gate C / NullStrand work:
  use the default workspace and Aristotle helper.  Do not include SPL.

SPL/E8 bridge work:
  use a dedicated SPL-enabled package or pass `-IncludeSpherePacking` to
  Scripts/prepare_aristotle_submission.ps1, then work on the optional
  PhysicsSMSPL / E8SpherePackingImported lane.
```

Status:

```text
Docs/config/scripts updated.
No local build or Lean verification was run.
```
