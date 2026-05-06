# Aristotle Next Wave: aggressive proof jobs after the May 2026 integration

**Prepared**: 2026-05-06
**Status**: submitted
**Purpose**: queue the next ambitious Aristotle jobs now that the Furey
operator layer, anomaly package, `H2O`, `H3O`, complex-line, and
exceptional-Jordan draft foundations are integrated.

**Submission project**:

```text
AgentTasks/aristotle-submit/next-wave-20260506-project
```

The live repository was too large for Aristotle's 100 MB upload limit because
of local build artifacts, so these jobs were submitted from a trimmed project
copy containing Lean source, Lake metadata, task files, and lightweight source
notes.

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| Job 1: Furey operator algebra | `AgentTasks/aristotle-output/furey-operator-algebra-next` | `79238cf7-f9dd-429f-97ed-b2fe96c8d3e4` | complete, integrated |
| Job 2: Jordan product identity | `AgentTasks/aristotle-output/jordan-product-identity-next` | `d2bc1249-49f7-4cdb-b06e-3971faaa5d5c` | complete, integrated |
| Job 3: Octonion complex splitting | `AgentTasks/aristotle-output/octonion-complex-splitting-next` | `5287e902-67dc-4ff0-a569-b67f3b058d98` | complete, integrated |
| Job 4: Jordan projective automorphism | `AgentTasks/aristotle-output/jordan-projective-automorphism-next` | `77b64073-54bc-4068-a625-5feea13ea523` | complete, integrated |
| Job 5: Cayley-Dickson foundation | `AgentTasks/aristotle-output/cayley-dickson-next` | `c02ae3c0-1574-4847-8a7d-e5a91a20db20` | complete, integrated |
| Job 6: SM gauge block Z6 | `AgentTasks/aristotle-output/sm-gauge-block-z6-next` | `55bb70e4-6992-4ff4-8a75-8e214500da9b` | complete, integrated |

## Integration notes

Integrated on 2026-05-06.

Trusted modules added or materially updated:

- `PhysicsSM/Algebra/Furey/OperatorAlgebra.lean`
- `PhysicsSM/Algebra/Jordan/H2OProduct.lean`
- `PhysicsSM/Algebra/Jordan/H3OJordan.lean`
- `PhysicsSM/Algebra/Jordan/H3OJordanDiag.lean`
- `PhysicsSM/Algebra/Jordan/H3OJordanX.lean`
- `PhysicsSM/Algebra/Jordan/H3OJordanY.lean`
- `PhysicsSM/Algebra/Jordan/H3OJordanZ.lean`
- `PhysicsSM/Algebra/Octonion/ComplexSplitting.lean`
- `PhysicsSM/Algebra/Jordan/Automorphism.lean`
- `PhysicsSM/Algebra/Jordan/ProjectiveGeometry.lean`
- `PhysicsSM/Algebra/Division/CayleyDickson.lean`
- `PhysicsSM/Gauge/BlockEmbeddings.lean`
- `PhysicsSM/Gauge/StandardModelGroup.lean`

Draft updates:

- `PhysicsSM/Draft/BaezStandardModelFromOctonions.lean` now delegates the two
  Jordan product placeholders to trusted modules.
- `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` now imports the
  trusted projective-geometry and automorphism scaffolding. Five frontier
  `sorry`s remain.

Verification highlights:

- Targeted `lake env lean` checks passed for the new trusted modules.
- Heavy `H3OJordan` component files were also compiled directly to `.olean`
  with `lake env lean -R . -o ...` so dependent draft checks could run.
- `lake env lean PhysicsSM/Draft/BaezStandardModelFromOctonions.lean` passed.
- `lake env lean PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean`
  passed with the five expected frontier `sorry` warnings.
- `lake build PhysicsSM` remains blocked on Windows by the known
  `proofwidgets/widgetJsAll` cache/path issue before reaching these modules.

These jobs are intentionally optimistic. Aristotle has been strongest when
given focused theorem statements plus permission to add small helper lemmas, so
each job below has a clear write scope, proof target, and minimum useful result.

## Submission strategy

Submit jobs 1 and 2 first. They are high payoff and mostly independent.
Submit job 3 in parallel if Aristotle queue capacity is available. Submit job 4
after job 2, because the projective-geometry refactor benefits from any Jordan
API improvements. Jobs 5 and 6 are larger moonshots and should be queued once
one of the first three returns.

Do not submit two jobs with overlapping write scopes at the same time unless
the second job is explicitly read-only or draft-only.

## Job 1: Furey operator algebra and color commutators

**Priority**: immediate
**Type**: proof / representation theory
**Write scope**:

```text
PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
PhysicsSM.lean
```

**Read first**:

```text
PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean
PhysicsSM/Algebra/Furey/OperatorRepresentations.lean
PhysicsSM/Algebra/Furey/AnomalyBridge.lean
AgentTasks/furey-su3-u1-operator-algebra-moonshot.md
```

**Goal**: turn the current Furey action table into a trusted operator algebra
module.

Requested declarations:

- `EqOnJ` for equality of complex-linear endomorphisms on the submodule `J`;
- `opComm` for commutators of complex-linear endomorphisms;
- diagonal color operators `H12_op`, `H23_op`, `H13_op`;
- complete transition tables for `T12_op`, `T21_op`, `T13_op`, `T31_op`,
  `T23_op`, `T32_op` on all eight basis states;
- finite-basis extension lemmas for proving `EqOnJ` from the eight basis
  states;
- commutator identities such as `[T12,T21] = H12`, `[T23,T32] = H23`,
  `[T13,T31] = H13`, and sign-corrected root-addition identities;
- `Q_op` commutes with all six color operators on `J`;
- singlet/triplet sector preservation facts if time permits.

**Critical convention warning**: color operators must be compositions of left
multiplication maps, not left multiplication by pre-multiplied octonions. Use
the existing `Tij_op` definitions.

**Minimum useful result**: a trusted `OperatorAlgebra.lean` with `EqOnJ`,
`opComm`, all transition tables, and at least the three diagonal commutators.

**Excellent result**: all six color maps commute with `Q_op` on `J`, plus
triplet/singlet invariance.

**Verification**:

```bash
lake env lean PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
lake env lean PhysicsSM/Algebra/Furey/OperatorRepresentations.lean
```

## Job 2: H2O product and H3O Jordan identity moonshot

**Priority**: immediate
**Type**: proof / algebra
**Write scope**:

```text
PhysicsSM/Algebra/Jordan/H2OProduct.lean
PhysicsSM/Algebra/Jordan/H3OJordan.lean
PhysicsSM/Draft/BaezStandardModelFromOctonions.lean
PhysicsSM.lean
```

If Aristotle can integrate cleanly into existing files without making them
messy, it may instead extend:

```text
PhysicsSM/Algebra/Jordan/H2O.lean
PhysicsSM/Algebra/Jordan/H3O.lean
```

**Read first**:

```text
PhysicsSM/Algebra/Jordan/Basic.lean
PhysicsSM/Algebra/Jordan/H2O.lean
PhysicsSM/Algebra/Jordan/H3O.lean
PhysicsSM/Draft/BaezStandardModelFromOctonions.lean
```

**Goal**: close the two finite algebra `sorry`s in the Baez draft if possible,
and promote the useful parts into trusted modules.

Requested `H2O` declarations:

- `jordanProductH2O : H2O -> H2O -> H2O`, preferably with the spin-factor
  coordinate formula

```text
(t1,x1,y1) o (t2,x2,y2)
  = (t1*t2 + x1*x2 + <y1,y2>,
     t1*x2 + t2*x1,
     t1*y2 + t2*y1)
```

  where `<y1,y2>` is the octonion coordinate inner product;
- commutativity;
- identity element;
- formulas for `proj1`, `proj2`;
- Jordan identity.

Requested `H3O` declarations:

- use the existing `jordanProduct` from `H3O.lean`;
- prove the Jordan identity

```text
(a o b) o (a o a) = a o (b o (a o a))
```

  for all `a b : H3O`, or produce the strongest checked finite-coordinate
  helper lemmas toward it;
- if the full identity is too large, prove power-associativity/idempotent
  lemmas needed by projective geometry and leave a precise draft handoff.

**Minimum useful result**: trusted `H2O` Jordan product with commutativity,
unit, standard projections, and Jordan identity.

**Excellent result**: trusted `H3O` Jordan identity, letting us honestly bundle
the Albert algebra as a Jordan algebra rather than just a coordinate product.

**Verification**:

```bash
lake env lean PhysicsSM/Algebra/Jordan/H2OProduct.lean
lake env lean PhysicsSM/Algebra/Jordan/H3OJordan.lean
lake env lean PhysicsSM/Draft/BaezStandardModelFromOctonions.lean
```

## Job 3: Chosen complex splitting O = C plus C^3

**Priority**: immediate/parallel
**Type**: definition / proof / convention bridge
**Write scope**:

```text
PhysicsSM/Algebra/Octonion/ComplexSplitting.lean
PhysicsSM.lean
```

**Read first**:

```text
PhysicsSM/Algebra/Octonion/Basic.lean
PhysicsSM/Algebra/Octonion/ComplexLine.lean
PhysicsSM/Algebra/Octonion/ConventionBridge.lean
PhysicsSM/Draft/BaezStandardModelFromOctonions.lean
```

**Goal**: formalize the coordinate splitting behind the DVT/Yokota route:
the project octonions split as the chosen complex line plus a three-dimensional
complex complement.

Requested declarations:

- a lightweight real-coordinate model for the chosen copy of `C`, for example
  a structure with real and imaginary coordinates;
- maps from the line model into `Octonion` and back;
- a complement-as-three-complex-coordinates model for the six coordinates
  orthogonal to `1` and `e111`;
- explicit decomposition of any octonion into line part plus complement part;
- uniqueness/directness of the decomposition;
- the left and right multiplication tables by `e111` on the six complement
  basis directions;
- proof that the complement is a complex vector space under the chosen
  multiplication by `e111`;
- optional: coordinate splitting for `H3O` into `h_3(C)` plus complement.

**Minimum useful result**: trusted `ComplexSplitting.lean` with decomposition,
directness, and `J^2 = -id` on the three complex complement coordinates.

**Excellent result**: a clean `O_perp ~= C^3` API usable by the DVT/Yokota
stabilizer theorem.

**Verification**:

```bash
lake env lean PhysicsSM/Algebra/Octonion/ComplexSplitting.lean
lake env lean PhysicsSM/Algebra/Octonion/ComplexLine.lean
```

## Job 4: Projective geometry and automorphism group scaffolding

**Priority**: next after job 2
**Type**: proof / refactor
**Write scope**:

```text
PhysicsSM/Algebra/Jordan/Automorphism.lean
PhysicsSM/Algebra/Jordan/ProjectiveGeometry.lean
PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
PhysicsSM.lean
```

**Read first**:

```text
PhysicsSM/Algebra/Jordan/H3O.lean
PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
```

**Goal**: move all non-frontier projective-geometry and automorphism facts out
of draft, and close the "fiddly Lean" group-structure sorries that do not
require compact Lie theory.

Requested declarations:

- `H3OAutomorphism` as a trusted structure;
- trusted `Group H3OAutomorphism`;
- lemmas that automorphisms preserve projections, trace-one points,
  trace-two lines, and incidence;
- trusted `OP2Point`, `OP2Line`, and `LiesOn`;
- trusted standard line and standard complex plane definitions where they only
  use finite coordinate facts from `H3O.lean`;
- trusted group structure on stabilizer subtypes when the closure proof is
  available from the previous lemmas.

**Do not fake** the final `S(U(2) x U(3))` group isomorphism. If the current
draft `StandardModelGaugeGroup` placeholder is too weak to support a real
group instance, replace that `sorry` with a better documented draft statement
instead of forcing a fake proof.

**Minimum useful result**: trusted `Group H3OAutomorphism` plus projection and
incidence preservation lemmas.

**Excellent result**: `ProjectiveCommonStabilizer` gets a trusted group
instance, leaving only the true F4/transitivity/DVT isomorphism statements in
draft.

**Verification**:

```bash
lake env lean PhysicsSM/Algebra/Jordan/Automorphism.lean
lake env lean PhysicsSM/Algebra/Jordan/ProjectiveGeometry.lean
lake env lean PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
```

## Job 5: Cayley-Dickson doubling foundation

**Priority**: moonshot after one early job returns
**Type**: definition / proof
**Write scope**:

```text
PhysicsSM/Algebra/Division/CayleyDickson.lean
PhysicsSM/Algebra/Division/Basic.lean
PhysicsSM.lean
```

**Read first**:

```text
PhysicsSM/Algebra/Octonion/Basic.lean
PhysicsSM/Algebra/Octonion/Conjugation.lean
PhysicsSM/Algebra/Octonion/Norm.lean
EXECUTION_PLAN.md
```

**Goal**: start Milestone 2 with a generic enough doubling API to support
future R -> C -> H -> O bridges, without disturbing the trusted coordinate
octonions.

Requested declarations:

- a `CayleyDickson A` pair type;
- coordinatewise zero/add/neg/sub/scalar operations;
- conjugation;
- multiplication formula with explicit parenthesization;
- norm-squared formula;
- basic simp/ext lemmas;
- conjugation involution;
- real and complex special-case examples if lightweight;
- a draft statement describing how the existing project `Octonion` should
  eventually be related to iterated Cayley-Dickson doubling.

**Minimum useful result**: trusted definitions and basic conjugation/norm simp
lemmas.

**Excellent result**: a norm multiplicativity theorem under a clearly stated
set of hypotheses.

**Verification**:

```bash
lake env lean PhysicsSM/Algebra/Division/CayleyDickson.lean
```

## Job 6: Standard Model gauge group block maps and Z6 kernel

**Priority**: moonshot
**Type**: definition / proof / group theory
**Write scope**:

```text
PhysicsSM/Gauge/StandardModelGroup.lean
PhysicsSM/Gauge/BlockEmbeddings.lean
PhysicsSM.lean
```

**Read first**:

```text
PhysicsSM/Gauge/StandardModelGroup.lean
PhysicsSM/StandardModel/AnomalyPackage.lean
PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean
```

**Goal**: replace the current lightweight `S(U(2) x U(3))` scaffolding with
more concrete block-matrix maps, while keeping quotient/group-isomorphism
theorems in draft if Mathlib infrastructure is not ready.

Requested declarations:

- explicit block determinant lemmas for the slide map

```text
(alpha, g, h) |-> (g, block_diag(alpha * h, alpha^-3))
```

  into `SU(2) x SU(4)`;
- the six central kernel elements as concrete phases;
- proof of the determinant-one condition for the SU(4) block;
- precise kernel statement for the Z6 quotient, as trusted if possible or as
  a well-typed draft theorem if quotient infrastructure is too heavy;
- compatibility comments with the convention `Q = T3 + Y / 2`.

**Minimum useful result**: trusted determinant/block arithmetic and a precise
draft theorem for `(U(1) x SU(2) x SU(3)) / Z6`.

**Excellent result**: a concrete subgroup definition of `S(U(2) x U(3))` as a
block subgroup of `SU(5)` plus the kernel statement.

**Verification**:

```bash
lake env lean PhysicsSM/Gauge/StandardModelGroup.lean
lake env lean PhysicsSM/Gauge/BlockEmbeddings.lean
```

## Suggested first CLI submissions

Use short prompts that point Aristotle to this file and the specific job
section. Example:

```bash
aristotle submit \
  --project-dir C:/Projects/StandardModel \
  --destination AgentTasks/aristotle-output/furey-operator-algebra-next \
  "Read AgentTasks/aristotle-next-wave-2026-05-06.md and carry out Job 1 only. Modify only the stated write scope. Produce trusted Lean with no sorry."
```

```bash
aristotle submit \
  --project-dir C:/Projects/StandardModel \
  --destination AgentTasks/aristotle-output/jordan-product-identity-next \
  "Read AgentTasks/aristotle-next-wave-2026-05-06.md and carry out Job 2 only. Be ambitious about the H3O Jordan identity, but do not use axioms or trusted sorry."
```

```bash
aristotle submit \
  --project-dir C:/Projects/StandardModel \
  --destination AgentTasks/aristotle-output/octonion-complex-splitting-next \
  "Read AgentTasks/aristotle-next-wave-2026-05-06.md and carry out Job 3 only. Keep all convention choices explicit and use the project XOR basis."
```
