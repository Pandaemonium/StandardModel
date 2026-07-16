# Aristotle strategy job: Lorentz invariance in distribution with decorations

## Context

The project has a kernel-checked no-go for nonempty finite support invariant
under a noncompact rational Lorentz boost, and a source-audited reading of the
Bombelli-Henson-Sorkin result: a Poisson sprinkling can be Lorentz invariant in
distribution even though no individual locally finite realization is fixed.
The remaining scientific debt is to formalize the distributional statement and
state exactly which null-edge decorations still owe Lorentz-covariant laws.

## Task

Act as Aristotle mathematical strategist and no-go analyst. Map the Lean 4.28
Mathlib probability/Poisson APIs and design a formal theorem ladder for the
strongest distributional Lorentz statement currently supportable.

Required output:

1. An exact finite-volume Poisson point-process invariance statement under a
   measure-preserving measurable equivalence, with all sigma-finiteness and
   measurability assumptions visible.
2. A route from count distributions on measurable partitions to point-process
   law equality, or a precise explanation of the missing API.
3. A theorem shape for equivariant marks/decorations and an explicit counterexample
   showing arbitrary tetrad or frame labels break invariance in distribution.
4. A clean separation between causal-order/conformal information and the scale
   or tetrad data still supplied.
5. Typechecking Lean skeletons and named Mathlib declarations; no invented
   Poisson-process theorem may be assumed.

Write `AFPL_L0_DISTRIBUTIONAL_FORMALIZATION_STRATEGY.md`.

## Primary files

- `PhysicsSM/Draft/NullEdge/L0FiniteSupportBoostNoGo.lean`
- `AutonomousLab/work/NE-LORENTZ/L0-DIST-001_primary_source_audit.md`
- `docs/NULLSTRAND.md`

Success is a finite-volume theorem ready for proof plus a decoration kill
control. A verified Mathlib API obstruction is an acceptable sharpened result.

## Submission metadata

- Aristotle project: `28e4ff06-27b9-40e5-8ed3-38cc787feab0`
- Submitted: 2026-07-12 by Codex
- Lab work item: `L0-DIST-001`
