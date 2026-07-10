# codex exact checkerboard path sum, 2026-07-09 14:00

aristotle:
  project_id: 33a4b055-773f-4378-8535-b25e78c78c61
  target_file: PhysicsSM/Draft/NullEdge/ExactCheckerboardPathSum.lean
  expected_module: PhysicsSM.Draft.NullEdge.ExactCheckerboardPathSum
  submission_project: AgentTasks/aristotle-submit/codex-impact-wave-1400-20260709-project
  output_dir: AgentTasks/aristotle-output/33a4b055-773f-4378-8535-b25e78c78c61
  status: landed from in-progress snapshot with local pinned-toolchain repairs; remote project canceled after landing 2026-07-09

You are Aristotle. Prove the exact finite path-history theorem that turns the
static null-edge carrier into a genuine checkerboard sum over histories.

Target:

```text
PhysicsSM/Draft/NullEdge/ExactCheckerboardPathSum.lean
```

Use these imports and reuse their declarations rather than rebuilding their
combinatorics:

```lean
import Mathlib
import PhysicsSM.Spinor.Checkerboard
import PhysicsSM.Draft.CheckerboardCornerCountAristotle
import PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle
import PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle
import PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle
import PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle
import PhysicsSM.Draft.NullEdge.CheckerboardCarrierBridge
```

Context pack and source provenance:

```text
AgentTasks/context-packs/exact-checkerboard-path-sum-20260709-135720.md
```

The full-text Neo4j search identified arXiv:1012.1564, especially its
"Constructing the Propagator" and corner-count sections, as a convention check.
It also warned that some older Kauffman-Noyes formulas are incorrect. Use the
landed and oracle-validated corner conventions as authoritative.

Mission:

1. Define an explicit Gaussian-rational commutative ring `GaussianRat` as
   rational pairs with the usual complex multiplication, together with
   `ofRat` and `I`. Do not use analytic `Complex` for the payload.
2. For rational `eps` and `m`, define each history amplitude as
   `(I * ofRat (eps * m)) ^ turnCount startDir h`.
3. Specialize the landed generic-semiring path-sum and closed-form theorems to
   prove that the finite sum over histories equals the binomial corner-count
   kernel exactly.
4. Prove the same exact path sum satisfies the landed one-step discrete Dirac
   recursion.
5. Prove the turn-phase boundary: at `m = 0`, every positive-corner history has
   zero amplitude and only zero-corner straight histories can contribute.
6. Include an explicit `n = 3` nondegenerate witness with at least one corner,
   a nonzero amplitude, and visibly different values at two rational masses.

Preferred theorem names:

```lean
GaussianRat.I_sq
pathAmplitude_eq_corner_power
exact_path_sum_eq_closed_kernel
exact_path_sum_dirac_recursion
massless_positive_corner_vanishes
massless_only_straight
t3_mass_dependent_witness
turn_phase_verdict
```

The final verdict must say only this: in the finite 1+1 checkerboard, the
propagator is exactly a sum over null histories and mass enters each history
only through corner amplitudes. Do not claim a continuum limit, a 3+1
propagator, or measured mass. Add footprint guard pins and run:

```text
lake env lean PhysicsSM/Draft/NullEdge/ExactCheckerboardPathSum.lean
lake build PhysicsSM.Draft.NullEdge.ExactCheckerboardPathSum
```
