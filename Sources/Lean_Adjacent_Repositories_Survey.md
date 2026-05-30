# Public Lean repositories adjacent to the StandardModel project

Prepared: 2026-05-30

Purpose: record public Lean repositories that may help this project formalize
octonions, Standard Model algebra, E8 lattices, Clifford/spinor structures,
Lie theory, modular forms, and physics-adjacent infrastructure.

This is a practical integration survey, not an endorsement of every theorem or
claim in the listed repositories. The Lean kernel verifies formal statements,
but semantic alignment, conventions, source provenance, and licensing remain
our responsibility.

## Search method

I used authenticated GitHub API code search for public Lean files with terms
including:

- `Octonion`, `CayleyDickson`, `CliffordAlgebra`, `Spinor`, `SpinGroup`,
  `PinGroup`
- `RootSystem`, `Dynkin`, `LieAlgebra`, `LieSubalgebra`, `Representation`
- `E8`, `SpherePacking`, `Hamming`, `ConstructionA`, `ModularForm`
- `StandardModel`, `Gauge`, `Anomaly`, `Hypercharge`
- `Jordan`, `Exceptional`, `Lorentz`, `Pauli`

The raw search was noisy: many hits were mathlib forks, generated files, or
speculative theorem collections. The repositories below are the ones that look
potentially useful after reading metadata, toolchains, licenses, READMEs, and
representative Lean files.

## Quick ranking

| Rank | Repository | Usefulness | Importability now | License | Notes |
| --- | --- | --- | --- | --- | --- |
| 1 | `leanprover-community/physlib` | Very high | Not directly; Lean `v4.29.1` | Apache-2.0 | Best Standard Model/anomaly/relativity source. |
| 2 | `math-inc/Sphere-Packing-Lean` | Very high | Yes, aligned with Lean `v4.28.0` | Apache-2.0 | Best E8/sphere-packing match for current toolchain. |
| 3 | `leanprover-community/mathlib4` | Very high | Already via pinned mathlib | Apache-2.0 | Clifford, Lie, root systems, Jordan basics. |
| 4 | `thefundamentaltheor3m/Sphere-Packing-Lean` | High | Not directly; Lean `v4.29.0` | Apache-2.0 | Newer upstream E8/sphere-packing development. |
| 5 | `CBirkbeck/LeanModularForms` | Medium-high | Not directly; Lean `v4.29.0-rc8` | Apache-2.0 | Modular forms/theta-side inspiration. |
| 6 | `pygae/lean-ga` | Medium | No; Lean 3 style | MIT | Geometric algebra/versor API patterns only. |
| 7 | `eric-wieser/lean-matrix-cookbook` | Medium | Maybe with porting; Lean `v4.22.0-rc4` | MIT | Matrix proof patterns. |
| 8 | `peabrainiac/lean-catdg` | Low-medium now | Not directly; Lean `v4.29.0` | Apache-2.0 | Later geometry/categorical infrastructure. |
| 9 | `xiyin137/OSreconstruction` | Low-medium now | Not directly; Lean `v4.29.0` | Apache-2.0 | QFT reconstruction/analytic physics, later target. |
| caution | miscellaneous speculative repos | Low | Varies | often none/unclear | Do not copy; possibly read only for ideas. |

## `leanprover-community/physlib`

Repository: <https://github.com/leanprover-community/physlib>

Metadata checked:

- Toolchain: `leanprover/lean4:v4.29.1`
- License: Apache-2.0
- Description: "A project to digitalise results from physics into Lean."
- Note: formerly `lean-phys-community/PhysLean`.

Representative files inspected:

- `Physlib/Particles/StandardModel/AnomalyCancellation/NoGrav/Basic.lean`
- `Physlib/Particles/StandardModel/AnomalyCancellation/NoGrav/One/Lemmas.lean`
- `Physlib/Particles/BeyondTheStandardModel/PatiSalam/Basic.lean`
- `Physlib/Particles/BeyondTheStandardModel/GeorgiGlashow/Basic.lean`
- `Physlib/Relativity/CliffordAlgebra.lean`
- `Physlib/Relativity/PauliMatrices/CliffordAlgebra.lean`
- `Physlib/Relativity/LorentzAlgebra/Basic.lean`
- `Physlib/Relativity/Bispinors/Basic.lean`
- `QuantumInfo/ForMathlib/HermitianMat/Jordan.lean`

Useful declarations and themes seen:

- Standard Model anomaly-cancellation systems:
  - `SMNoGrav`
  - `SU2Sol`
  - `SU3Sol`
  - `cubeSol`
  - maps between charge, linear, quadratic, and anomaly-free solution types
- Right-handed-neutrino and beyond-Standard-Model anomaly files.
- Pati-Salam and Georgi-Glashow basic model scaffolds.
- Concrete gamma matrices:
  - `gamma0`, `gamma1`, `gamma2`, `gamma3`, `gamma5`
  - a `diracAlgebra` subalgebra of `Matrix (Fin 4) (Fin 4) Complex`
- Pauli-matrix Clifford algebra maps.
- Lorentz algebra as a Lie subalgebra of matrices preserving the Minkowski
  form.
- Bispinor tensor API.
- Hermitian matrix Jordan product API:
  - `HermitianMat.symmMul`
  - commutativity, identity, and compatibility lemmas.

How it can help us:

1. Standard Model anomaly API.
   Our project has its own anomaly and charge tables. Physlib gives a much more
   mature way to package anomaly equations as systems, solution types, and
   maps. We should compare its `SMNoGrav` design with our
   `PhysicsSM.StandardModel.AnomalyPackage` and Furey charge-table modules.

2. Hypercharge normalization review.
   Physlib has hypercharge and anomaly files with explicit Standard Model
   conventions. These are useful cross-checks for our `Q = T3 + Y/2`
   convention and for future `S(U(2) x U(3))` theorem statements.

3. Clifford/spinor scaffolding.
   Physlib's concrete gamma and Pauli matrix files can help when we connect the
   octonionic-qubit/Krasnov track to Clifford algebra and spinor statements.
   We should not copy formulas blindly; metric signature and gamma conventions
   must be documented.

4. Lorentz algebra and bispinors.
   The Lorentz matrix-subalgebra approach is a useful pattern for our eventual
   "physics layer": define a concrete carrier predicate/substructure first,
   prove closure, then state representation claims.

5. Jordan matrix product.
   The Hermitian matrix Jordan product file is adjacent to our exceptional
   Jordan algebra work. It may provide mathlib-ready naming and proof style for
   commutative nonassociative products on Hermitian matrices.

Recommended use:

- Do not import directly while we are pinned to Lean `v4.28.0`.
- Use as a source of API design, theorem names, and convention comparisons.
- Consider a dedicated compatibility note:
  `Sources/Physlib_Compatibility_Notes.md`.
- Consider submitting Aristotle jobs that compare our anomaly table to
  Physlib's `SMNoGrav` equations after we decide a normalization map.

Risks:

- Toolchain mismatch: physlib tracks Lean `v4.29.1`, while this project is
  pinned to `v4.28.0`.
- Physics convention mismatch: gamma matrices, metric signature, particle
  naming, and hypercharge normalization need explicit bridges.
- Copying code is possible under Apache-2.0, but clean-room re-formalization
  from mathematical statements is still preferable for trusted code.

## `math-inc/Sphere-Packing-Lean`

Repository: <https://github.com/math-inc/Sphere-Packing-Lean>

Metadata checked:

- Toolchain: `leanprover/lean4:v4.28.0`
- License: Apache-2.0
- Description: Lean formalization of the sphere packing problem in dimensions
  8 and 24.

How it can help us:

1. This is the best version to align with the current project toolchain.
   Our `AGENTS.md` already names compatibility with Sphere-Packing-Lean as a
   reason for freezing at Lean `v4.28.0`.

2. It is the right dependency to consult for E8 lattice facts while we continue
   the Hamming code/Construction A/E8 side of the project.

3. It helps keep the "E8 proof layer" separate from the octonionic physics
   layer. This is philosophically important: E8 lattice facts should be trusted
   via kernel-checked lattice formalization, not inferred from physics
   heuristics.

Recommended use:

- Prefer this repo when building Aristotle submission copies that need
  Sphere-Packing-Lean under Lean `v4.28.0`.
- Keep E8 bridge work explicit: our Construction A code should prove the
  precise equivalences it needs, rather than relying on informal "this is E8"
  claims.

Risks:

- It is a specialized project; importing too much into native Windows builds
  can create toolchain/cache friction.
- Keep it in SPL-enabled submission copies when possible, as our existing
  workflow notes recommend.

## `thefundamentaltheor3m/Sphere-Packing-Lean`

Repository: <https://github.com/thefundamentaltheor3m/Sphere-Packing-Lean>

Metadata checked:

- Toolchain: `leanprover/lean4:v4.29.0`
- License: Apache-2.0
- Description: formalization of Viazovska's sphere-packing solution in
  dimension 8.

Representative files inspected:

- `SpherePacking/Basic/E8.lean`
- `SpherePacking/Basic/SpherePacking.lean`
- `SpherePacking/CohnElkies/LPBound.lean`
- `SpherePacking/ModularForms/Derivative.lean`

Useful declarations and themes seen:

- E8 as a submodule:
  - `Submodule.E8`
  - `Submodule.mem_E8`
  - `Submodule.mem_E8'`
  - `Submodule.mem_E8''`
- Even lattice predicates and integer-to-field casting helpers.
- `SpherePacking` and `PeriodicSpherePacking` structures.
- Density definitions and Cohn-Elkies linear-programming bound.
- Modular-form derivative infrastructure:
  - `D`
  - `D_add`
  - `D_sub`
  - `D_smul`

How it can help us:

1. E8 membership API.
   The `Submodule.E8` style is useful to compare against our Construction A
   E8 definitions. If names or theorem shapes differ, we should write bridge
   lemmas rather than duplicate semantic claims.

2. Sphere-packing-theorem frontier.
   If our E8 manuscript wants a trusted connection to optimality or density,
   this repo shows the direction of travel.

3. Modular-form/theta strategy.
   The derivative and modular-form files are relevant to the E8 theta series
   work, especially when deciding whether to formalize theta identities inside
   our repo or align with upstream modular-form APIs.

Recommended use:

- Use for design comparison and future-port awareness.
- For actual current builds, prefer the `math-inc` Lean `v4.28.0` fork.

Risks:

- Toolchain mismatch with this project.
- The E8 representation may not match our Hamming/Construction A definitions
  definitionally; use explicit bridge theorems.

## `leanprover-community/mathlib4`

Repository: <https://github.com/leanprover-community/mathlib4>

Metadata checked:

- License: Apache-2.0
- Current upstream is ahead of our pinned dependency, but mathlib is already
  the project's foundational library.

Relevant modules found:

- Clifford algebra:
  - `Mathlib/LinearAlgebra/CliffordAlgebra/Basic.lean`
  - `Mathlib/LinearAlgebra/CliffordAlgebra/Conjugation.lean`
  - `Mathlib/LinearAlgebra/CliffordAlgebra/SpinGroup.lean`
- Lie theory:
  - `Mathlib/Algebra/Lie/Basic.lean`
  - `Mathlib/Algebra/Lie/CartanCriterion.lean`
  - `Mathlib/Algebra/Lie/Weights/RootSystem.lean`
  - `Mathlib/LinearAlgebra/RootSystem/*.lean`
- Representation theory:
  - `Mathlib/RepresentationTheory/*.lean`
- Jordan algebra:
  - `Mathlib/Algebra/Jordan/Basic.lean`
- Coding/modular-form-adjacent:
  - `Mathlib/InformationTheory/Hamming.lean`
  - `Mathlib/NumberTheory/ModularForms/*.lean`

How it can help us:

1. Prefer mathlib abstractions over local reinvention.
   For Clifford, root systems, Lie algebras, representations, matrices, and
   modules, mathlib should be searched first.

2. Use mathlib's names where possible.
   The more our declarations mirror mathlib naming conventions, the easier
   future upstreaming or interoperability will be.

3. Avoid over-localizing general facts.
   If we need a general theorem about root systems, submodules, linear maps,
   Clifford algebra, or Hermitian matrices, it may belong upstream or in a
   for-mathlib file rather than deep inside an octonion-specific namespace.

Risks:

- Upstream mathlib may contain APIs not present in our pinned version. Always
  check the local `.lake/packages/mathlib` version before relying on a name.

## `CBirkbeck/LeanModularForms`

Repository: <https://github.com/CBirkbeck/LeanModularForms>

Metadata checked:

- Toolchain: `leanprover/lean4:v4.29.0-rc8`
- License: Apache-2.0
- Description from README: the repository develops modular forms in Lean 4 with
  the goal of cleaning material for mathlib.

Representative files inspected:

- `LeanModularForms.lean`
- `LeanModularForms/Modularforms/Delta.lean`

Useful declarations and themes seen:

- Modular discriminant:
  - `Delta`
  - `DiscriminantProductFormula`
  - `Delta_eq_eta_pow`
  - `Delta_ne_zero`
  - `Discriminant_T_invariant`
  - `Discriminant_S_invariant`
  - `Discriminant_SIF`

How it can help us:

1. E8 theta and modular forms.
   If the E8 publication track needs stronger modular-form facts, this repo
   offers a useful view of the current modular-form formalization frontier.

2. Naming and proof style.
   It may help structure future `theta` or `Delta` bridge modules so they are
   closer to mathlib's likely direction.

Recommended use:

- Reference only for now; do not import directly under Lean `v4.28.0`.
- Compare against mathlib's local modular-form API before adding any local
  theorem.

Risks:

- Toolchain mismatch.
- Modular forms are convention-heavy; weights, slash actions, cusp conditions,
  and normalizations need explicit documentation.

## `pygae/lean-ga`

Repository: <https://github.com/pygae/lean-ga>

Metadata checked:

- Lean 3 project (`leanpkg.toml`)
- License: MIT
- Description: partial formalization of geometric algebra.

Representative files inspected:

- `src/geometric_algebra/from_mathlib/versors.lean`
- `src/geometric_algebra/nursery/chisolm.lean`
- `src/geometric_algebra/from_mathlib/category_theory.lean`

Useful declarations and themes seen:

- `versors`
- reverse/magnitude lemmas for versors
- Clifford/geometric-algebra categorical packaging
- early multivector/blade experiments

How it can help us:

1. Geometric algebra API inspiration.
   Useful when thinking about Clifford group, Pin/Spin, versors, and their
   action on vectors.

2. Terminology bridge.
   Helps translate physics-geometric-algebra language into Lean structures.

Recommended use:

- Read as historical/reference material only.
- Do not import directly; it is Lean 3 and predates current mathlib APIs.

Risks:

- Lean 3 code and old mathlib names.
- Some concepts may now be represented differently in Lean 4 mathlib.

## `eric-wieser/lean-matrix-cookbook`

Repository: <https://github.com/eric-wieser/lean-matrix-cookbook>

Metadata checked:

- Toolchain: `leanprover/lean4:v4.22.0-rc4`
- License: MIT
- Description: Matrix Cookbook identities proved in Lean.

How it can help us:

1. Matrix identity proof patterns.
   We already prove many block-matrix and determinant identities. This repo
   can be useful for proof style and lemma search.

2. Future block embeddings.
   Standard Model block maps, Lorentz matrices, Pauli matrices, and gamma
   matrices all need robust matrix-component proofs.

Recommended use:

- Reference only unless a theorem has been upstreamed or ports cleanly.

Risks:

- Older Lean version.
- Matrix notation and APIs may have changed.

## `peabrainiac/lean-catdg`

Repository: <https://github.com/peabrainiac/lean-catdg>

Metadata checked:

- Toolchain: `leanprover/lean4:v4.29.0`
- License: Apache-2.0
- Description: categorical differential geometry, originally orbifolds.

How it can help us:

This is not immediately useful for the current algebraic octonion/Standard
Model track. It may become relevant if we eventually formalize geometric
bundles, spaces with singularities, or categorical differential geometry
around gauge theory.

Recommended use:

- Keep as a later-stage reference.

## `xiyin137/OSreconstruction`

Repository: <https://github.com/xiyin137/OSreconstruction>

Metadata checked:

- Toolchain: `leanprover/lean4:v4.29.0`
- License: Apache-2.0
- Description: Osterwalder-Schrader reconstruction and supporting von Neumann
  algebra infrastructure.

How it can help us:

This is QFT-adjacent rather than octonion-adjacent. It may be useful if the
project eventually moves from finite algebraic Standard Model structures to
constructive QFT, Euclidean reconstruction, or operator algebra.

Recommended use:

- Not a current dependency.
- Worth watching as a physics-analysis formalization effort.

## Speculative repositories and caution list

These repositories appeared in code search but should not be treated as trusted
sources for our Lean code without significant review:

- `JohnnyTeutonic/lean_proofs_sm`
- `ken-okabe/8bit-theory`
- `iarnoldy/UFT`
- `yablokolabs/quantaforge`
- `jagg-ix/*` physics/Lean experiments
- `forkjoin-ai/gnosis-math`
- `CrystalToe/CrystalAgent`

Reasons for caution:

- Missing or unclear license in several cases.
- Some files look like speculative or generated theorem collections.
- Some contain very broad physics claims that may not be semantically aligned
  with their Lean statements.
- `CrystalToe/CrystalAgent` is AGPL-3.0, so copying code into trusted source
  is inappropriate for this project.

Possible use:

- Read only as informal inspiration.
- Do not copy implementation text.
- Do not cite as mathematical authority unless a specific theorem, license,
  and convention have been audited.

## Concrete next actions for this project

### 1. Physlib comparison note

Create `Sources/Physlib_Compatibility_Notes.md` comparing:

- our `StandardModel.AnomalyPackage`
- our Furey `Q_op`/hypercharge/electroweak bridge files
- physlib's `SMNoGrav` and related anomaly systems

Goal: define a normalization map between our tables and physlib's anomaly
equations, or document why they are conventionally different.

### 2. Aristotle jobs for anomaly interoperability

Once the comparison note is written, submit focused Aristotle jobs:

- prove our one-generation charge table satisfies a physlib-shaped anomaly
  polynomial, in our local definitions;
- prove sign/normalization lemmas connecting `rawQopJ`, `rawQopJbar`, and
  hypercharge/electric-charge tables;
- prove finite table equivalences between our row order and physlib's family
  maps.

Do not ask Aristotle to import physlib directly under Lean `v4.28.0`; instead,
copy the minimal statement shape into local trusted files with provenance.

### 3. E8 bridge discipline

Keep using the `math-inc/Sphere-Packing-Lean` compatible path for current E8
work. Compare our Construction A E8 predicates to the upstream `Submodule.E8`
style from the newer Sphere-Packing-Lean repo and add explicit bridge lemmas
only when the target statement is reviewed.

### 4. Modular forms watchlist

Track `CBirkbeck/LeanModularForms` and mathlib modular-form APIs for:

- discriminant/eta identities;
- modular-form derivative API;
- theta-series normalization;
- cusp and slash-action conventions.

This matters for the E8 theta-series publication track.

### 5. Clifford/spinor bridge

Use mathlib and physlib, not speculative repos, as the primary references for:

- Clifford algebra;
- Pin/Spin groups;
- Pauli and gamma matrices;
- Lorentz algebra;
- bispinors.

Before connecting any of this to octonions, record metric signature, gamma
matrix convention, chirality, and basis order.

## Bottom line

The strongest external help is not another octonion Standard Model repo. The
strongest help is infrastructure:

- physlib for Standard Model anomaly equations and physics representation
  scaffolding;
- mathlib for Clifford, Lie, root-system, representation, and Jordan basics;
- Sphere-Packing-Lean for E8 lattice rigor;
- modular-form projects for the theta-series side.

Our octonion/Furey/Baez formalization remains largely original. The public Lean
ecosystem can help us avoid reinventing surrounding infrastructure, but the
octonionic convention bridge and the actual Standard Model reconstruction
theorems still need to be built and reviewed locally.
