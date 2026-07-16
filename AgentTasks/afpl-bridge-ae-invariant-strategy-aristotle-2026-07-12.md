# Aristotle strategy job: invariant A/E bridge or no-go

## Context

The finite two-dimensional rest operator and active pair generator have an
exact basis-action identification, but `BRIDGE-AE-001` is parked because a
chosen coordinate map is not yet a canonical physical bridge. Reactivation
requires a grading-respecting star-algebra, rank, kernel, commutant, or
representation invariant that distinguishes a natural active-sector map from
arbitrary basis matching, together with a genuine no-extension theorem.

## Task

Act as Aristotle Visionary and Skeptic. Inspect the canonical rest-operator,
pair-generator, full-Fock, grading, and bridge-analysis files. Determine whether
there is a basis-independent bridge worth formalizing.

Required output:

1. Define the source and target structured objects precisely: vector spaces,
   grading, involution, operator action, and any preserved inner product.
2. Classify all intertwiners at nonzero `z` up to the correct automorphism
   group, or prove that no canonical choice exists without extra data.
3. State an invariant no-extension theorem beyond dimension counting, using
   rank/kernel, commutant, grading multiplicity, or star-algebra structure.
4. Give explicit nonzero and `z = 0` controls.
5. Supply exact Lean theorem skeletons using current project declarations, or
   a precise impossibility memo if the current APIs encode only coordinates.

Do not call a basis choice canonical and do not infer physics from matching
matrix entries. Write `AFPL_BRIDGE_AE_INVARIANT_STRATEGY.md`.

## Primary files

- `AutonomousLab/work/NE-BRIDGES/BRIDGE-AE-001_scope_analysis.md`
- `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean`
- `PhysicsSM/Draft/NullEdge/PlueckerPairGenerator.lean`
- `PhysicsSM/Draft/NullEdge/PairActiveSectorExponential.lean`
- `PhysicsSM/Draft/NullEdge/CanonicalFullFockPairExponential.lean`

Success is either a non-coordinate invariant specification ready to typecheck,
or a sharpened no-canonicity theorem that keeps the project parked honestly.

## Submission metadata

- Aristotle project: `3f23d59b-ee6d-43e0-9a4c-bb34c90627a4`
- Submission project: `AgentTasks/aristotle-submit/bridge-ae-invariant-20260712-project`
- Lab work item: `BRIDGE-AE-001`
- Status: submitted 2026-07-12 by Codex
