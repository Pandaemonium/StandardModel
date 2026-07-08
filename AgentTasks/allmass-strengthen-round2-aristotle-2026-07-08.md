# Aristotle round 2: fresh strengthening jobs (2026-07-08)

Submitted while batch-1 (8b3efa7c: T1/T2/T5) was still proving T2's PosDef. A
round of self-contained, novel, Mathlib-only theorem jobs from the roadmap.

## Jobs

- **F3 mass monogamy** (`allmass-monogamy-20260708-project`): the Plucker mass is
  superadditive over bundle union, excess = cross-disagreement (the kinematic
  root of the `Delta` binding energy); equality iff sub-bundles mutually
  collinear. Self-contained (Spinor := Fin 2 -> C).
  **project_id: 3ebcaf1f-5562-4149-b9fd-73d25582bfae**.
- **F-kin rank/area-spectral bridge** (`allmass-rankarea-20260708-project`):
  massive <=> det P > 0 <=> momentum PosDef; det P = product of light-cone
  eigenvalues (Pro's rank/area reading; the S3<->S4 hinge).
  **project_id: 979a3401-3c43-49bc-a475-942913780abb**.

Both submitted alongside the still-running batch-1 (8b3efa7c: T1/T2/T5).

## Status log

- 2026-07-08: monogamy package verified (`lake env lean` clean); both submitted.
  Harvest with `aristotle download <project_id>` when COMPLETE.
