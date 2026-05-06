# Aristotle next wave 2 - 2026-05-06

Purpose: prepare the next aggressive batch of proof-specialist jobs after the
2026-05-06 integration wave. These are intentionally ambitious but still
focused enough that Aristotle can work inside small theorem surfaces and return
kernel-checkable patches.

Status: submitted 2026-05-06.

Submission project:

```text
AgentTasks/aristotle-submit/next-wave-2-20260506-project
```

Submitted jobs:

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| Job A: CD3-to-Octonion bridge | `AgentTasks/aristotle-output/cd3-octonion-bridge-next` | `e89f71be-ad2a-4a62-8338-2c54cbb9d932` | queued |
| Job B: H3O trace form and splitting | `AgentTasks/aristotle-output/h3o-trace-form-splitting-next` | `101775e5-36e8-4eaa-ba61-e9a1c5007c33` | queued |
| Job C: common stabilizer group closure | `AgentTasks/aristotle-output/common-stabilizer-closure-next` | `0bd47cc5-58ec-48b8-87ed-d84e6db7a367` | queued |
| Job D: concrete Standard Model block subgroup | `AgentTasks/aristotle-output/sm-block-subgroup-next` | `cdb75897-66e3-4fa7-a3db-f9075971299d` | queued |
| Job E: Furey weak-isospin and hypercharge bridge | `AgentTasks/aristotle-output/furey-hypercharge-bridge-next` | `ce91075d-58ce-4049-87b2-9eb0492d76a8` | queued |
| Job F: DVT/Yokota first block action | `AgentTasks/aristotle-output/dvt-yokota-block-action-next` | `d988fff7-f5f9-426b-8176-486b6d69688a` | queued |

General constraints for every job:

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or `sorry` in trusted
  modules.
- Do not weaken theorem statements just to make proofs pass.
- Keep octonion multiplication parenthesized and respect the project XOR
  convention.
- Add provenance comments when a statement is sourced from Baez-Schwahn,
  Dubois-Violette-Todorov, Krasnov, Furey, or Baez 2021.
- Run the smallest relevant `lake env lean <file>` check before returning.

## Job A: CD3-to-Octonion bridge

Write scope:

- `PhysicsSM/Algebra/Division/CayleyDicksonOctonionBridge.lean`
- optional tiny additions to `PhysicsSM/Algebra/Division/CayleyDickson.lean`
  only if needed for reusable simp lemmas.

Goal:

Build the explicit bridge between `CayleyDickson.CD3` and the project's trusted
XOR-basis `Octonion`. Start with a coordinate map and prove enough basis
multiplication facts to identify the convention mismatch cleanly.

Target declarations:

- `CD3.toOctonion : CD3 -> Octonion`
- `CD3.ofOctonion : Octonion -> CD3`
- `CD3.toOctonion_ofOctonion`
- `CD3.ofOctonion_toOctonion`
- basis lemmas for the images of the eight Cayley-Dickson basis vectors.
- multiplication comparison theorem for basis vectors, or a table-valued
  theorem if a sign correction is necessary.

Ambitious stretch:

- Prove full multiplication preservation after the correct basis/sign map is
  installed.
- Prove squared-norm preservation.

Why now:

This connects Milestone 2 to the existing octonion foundation and makes the
future Albert algebra tower semantically auditable.

## Job B: H3O trace form and splitting

Write scope:

- `PhysicsSM/Algebra/Jordan/TraceForm.lean`
- optional small imports from `H3OJordan.lean` and `ComplexSplitting.lean`.

Goal:

Define the trace bilinear form on `H3O` and prove the clean coordinate
characterization of the chosen `h_3(C)` block and its complement.

Target declarations:

- `H3O.traceForm : H3O -> H3O -> Real`
- symmetry and additivity/scalar lemmas needed by downstream projections.
- `InStandardB` iff all three off-diagonal octonion entries lie in the chosen
  complex line.
- coordinate complement predicate for the three off-diagonal components.
- directness/intersection theorem for the `h_3(C)` part and complement.

Ambitious stretch:

- Define projection maps `H3O.toH3CPart` and `H3O.toComplementPart` and prove
  `a = toH3CPart a + toComplementPart a`.
- Prove trace-form orthogonality of the two summands.

Why now:

This is the next concrete step toward the Dubois-Violette-Todorov/Yokota block
action and keeps the geometric story grounded in coordinates.

## Job C: common stabilizer group closure

Write scope:

- `PhysicsSM/Algebra/Jordan/Stabilizer.lean`
- optional refactor of draft definitions from
  `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` into the trusted
  file if all proofs close.

Goal:

Close the draft group-structure hole for the automorphisms that stabilize both
the standard complex projective plane and the standard octonionic line.

Target declarations:

- `StabilizesStandardComplexPlane`
- `StabilizesStandardOctonionicLine`
- `ProjectiveCommonStabilizer`
- `instGroupProjectiveCommonStabilizer`
- preservation lemmas for identity, multiplication, and inverse.

Ambitious stretch:

- Prove the standard line stabilizer and common stabilizer actions preserve
  incidence `LiesOn`.
- Move the corresponding draft `sorry` out of
  `ExceptionalJordanProjectiveGeometry.lean`.

Why now:

This is the smallest remaining trusted subgroup API needed before attempting
the Standard Model gauge-group identification.

## Job D: concrete Standard Model block subgroup

Write scope:

- `PhysicsSM/Gauge/StandardModelSubgroup.lean`
- optional additions to `PhysicsSM/Gauge/BlockEmbeddings.lean`.

Goal:

Turn the current `S(U(2) x U(3))`/`Z6` scaffold into a more concrete subgroup
API suitable for the stabilizer theorem, without pretending to have a finished
compact Lie group quotient theory.

Target declarations:

- block-pair carrier predicate for the determinant-one `U(2) x U(3)` block
  subgroup.
- identity, multiplication, and inverse closure.
- map from `U(1) x SU(2) x SU(3)` into the block subgroup, using the existing
  `omega`, `kernelPhases`, and determinant lemmas.
- kernel-membership facts for the six phases.

Ambitious stretch:

- Prove the kernel is exactly the six-phase subgroup already represented by
  `KernelElement`.
- State a quotient theorem in draft only if exact quotient infrastructure is
  not available.

Why now:

The DVT stabilizer endpoint needs a usable algebraic target for
`S(U(2) x U(3))`; this job builds that target with no hidden quotient claims.

## Job E: Furey weak-isospin and hypercharge bridge

Write scope:

- `PhysicsSM/Algebra/Furey/HyperchargeBridge.lean`
- optional imports from `OperatorAlgebra.lean`,
  `StandardModel/AnomalyPackage.lean`, and `Algebra/Furey/AnomalyBridge.lean`.

Goal:

Use the trusted Furey finite state table to define weak isospin and
hypercharge assignments and prove the convention `Q = T3 + Y/2` on the
available basis states.

Target declarations:

- `T3_op` or a finite table `T3Value`.
- `YValue` for the eight Furey basis states.
- `Q_eq_T3_add_halfY` on each basis state.
- compatibility lemmas with the existing electric-charge operator `Q_op`.

Ambitious stretch:

- Connect the assignments to the anomaly package and prove the one-generation
  rational anomaly equalities for the represented state table.

Why now:

The operator algebra is now trusted. The next physics-facing theorem should
make the Standard Model convention explicit instead of leaving `Q_op` as an
isolated finite arithmetic result.

## Job F: DVT/Yokota first block action

Write scope:

- `PhysicsSM/Algebra/Jordan/DVTAction.lean`
- optional imports from `ComplexSplitting.lean`, `TraceForm.lean`, and
  `ProjectiveGeometry.lean`.

Goal:

Formalize the first coordinate-level DVT/Yokota action on the
`h_3(C) plus complement` splitting, proving linear preservation facts before
attempting the full Jordan-product automorphism theorem.

Target declarations:

- a finite-dimensional coordinate model for the complement using the existing
  `O = C plus C^3` splitting.
- action skeleton `(g, h) . (X, M)` at the level of typed coordinates, with
  conservative hypotheses on matrices if full unitary groups are too heavy.
- preservation of the `h_3(C)` summand.
- preservation of the complement summand.
- compatibility with the projection maps from Job B.

Ambitious stretch:

- Prove a first nontrivial central-kernel lemma for scalar phase pairs.
- State the full `(SU(3) x SU(3)) / Z3` action theorem in draft form with
  precise missing infrastructure notes.

Why now:

This is the concrete coordinate route from the trusted splitting theorem toward
the DVT stabilizer theorem, and it can make progress before the full compact
Lie group story is available.

## Recommended submission order

1. Job C, because it can directly remove one draft `sorry`.
2. Job A, because it audits a major convention boundary.
3. Job B, because it feeds Job F and improves the Jordan geometry API.
4. Job E, because the Furey operator layer is newly complete.
5. Job D, because it sharpens the gauge target for Milestone 8.
6. Job F, after Job B if possible; otherwise submit with the existing
   `ComplexSplitting` API and ask Aristotle to return a scoped scaffold.
