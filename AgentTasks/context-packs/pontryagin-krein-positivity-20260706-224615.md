# Aristotle semantic context pack

Generated: 2026-07-06T22:46:36
Query: `finite Pontryagin Krein space J self adjoint invariant maximal nonnegative subspace D sharp D physical sector positivity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `docs/NULLSTRAND.md` [Krein double guardrails]

Score: `0.831`

```text
## Krein double guardrails

The minimal finite Krein API is:

```text
J = J^dagger = J^{-1}
[u, v]_J = <u, J v>
A^sharp = J A^dagger J
```

Given `D_- := D_+^sharp`, the doubled operator:

```text
D_dbl = [[0, D_-], [D_+, 0]]
```

is the right finite object to audit for `J`-self-adjointness.

Do not overclaim. Krein self-adjointness does not by itself imply positivity,
unitary time evolution, real spectrum, stability, anomaly cancellation, or a
chiral Standard Model sector.
```

### 2. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/AgentTasks/null-edge-k2-krein-positive-release-criterion-note.md` [The K2 module: `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`]

Score: `0.817`

```text
sitive` bridging to the matrix-level positivity.
- **Sharpness**: `Pnull_krein_indefinite` (full sector is indefinite), `releasesKreinPositive_iff_full` (C22's `ReleasesKreinPositive` is exactly the unsatisfiable "retain-everything" instance), `full_sector_not_releases` (re-derives C22's negative result), and `kreinPositive_sector_subset_phys` (`physSel` is the maximal Krein-positive sector).
- `k2_physical_sector_release_summary` bundles the result.

All new theorems are proved with no `sorry` and use only standard axioms (`propext`, `Classical.choice`, `Quot.sound`). Everything is for the modeled Wave-8 gradings, consistent with C22's honest scope: the upstream `OperatorForcesAlignment` obligation (identifying actual operator branch chirality with `g5`) remains the only residual, now cleanly separated from the positivity question this module resolves.
```

### 3. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/AgentTasks/null-edge-k2-krein-positive-release-criterion-note.md` [The K2 module: `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`]

Score: `0.815`

```text
### The K2 module: `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`
Since C22 already proves the modeled branch Krein pattern is `(+,−,+,−)` (so not all branches are Krein-positive), the criterion is built around a **physical-sector projection**, not a blanket positivity claim:

- `sectorProj sel` — projector onto the branches retained by a selector; `KreinPositiveSector P := kreinJ * P = P` (the modeled Krein metric restricts to `+1`, i.e. positive-definite, on the range of `P`).
- `kreinJ_Pbranch`: the Krein metric acts on branch `a` by its signature `branchKreinSig a`.
- **General sufficient condition** `sectorProj_kreinPositive`: any sector whose retained branches all have Krein signature `+1` is Krein-positive.
- **Canonical physical sector** `physSel`/`Pphys = Pbranch 0 + Pbranch 2`: retains exactly the Krein-positive branches. Proved idempotent, symmetric, rank 2; `Pphys_kreinPositive` and `Pphys_krein_form` (`Pphys·J·Pphys = Pphys`).
- **Species splitting made explicit**: `retained_dirac_pair` shows the retained pair `{0,2}` is one left-chiral + one right-chiral mode, both Krein-positive (a healthy Dirac pair); `discarded_krein_negative`/`discarded_ghost_pair` show the projected-out pair `{1,3}` is *exactly* the Krein-negative ghost sector — the negative branches are explicitly excluded, not hidden.
- **The deliverable release theorem** `physical_sector_releases`: the physical sector satisfies the sector-restricted predicate `ReleasesKreinPositiveOnSector` (aligned chirality and Krein-positive on every retained branch), with `releasesOnSector_imp_kreinPositive` bridging to the matrix-level positivity.
- **Sharpness**: `Pnull_krein_indefinite` (full sector is indefinite), `releasesKreinPositive_iff_full` (C22's `ReleasesKreinPositive` is exactly the u
```

### 4. `PhysicsSM/Draft/NullEdgeSuperDiracKreinCore.lean`

Score: `0.808`

```text
namespace PhysicsSM.Draft.NullEdgeSuperDiracKreinCore

open Matrix Complex

variable {Idx : Type*} [Fintype Idx] [DecidableEq Idx]

/-- A finite `J`-self-adjointness predicate for the Krein form with symmetry `J`.

For the indefinite form `<x,y>_J = x^dagger J y`, this is the matrix identity
`J D = D^dagger J`.  In the Lorentzian super-Dirac program this is the better
target than ordinary positive-definite Hilbert self-adjointness.
-/
```

### 5. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h2-chi-e-from-furey-krasnov-structure/fur-h2-chi-e-from-furey-krasnov-structure_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [20.6 Gate C addendum: Krein audit is necessary but not stability]

Score: `0.788`

```text
### 20.6 Gate C addendum: Krein audit is necessary but not stability

Finite Krein algebra:

```text
J = J^dagger = J^{-1}
A^sharp = J A^dagger J
D_- = D_+^sharp
D_dbl = [[0, D_-], [D_+, 0]]
J_dbl = [[J, 0], [0, J]]
```

Target theorem:

```text
D_dbl is J_dbl-self-adjoint.
```

Non-claims:

- Real spectrum.
- Positivity.
- No growing modes.
- Unitary time evolution.
- Sensible spectral action.
- Anomaly safety.
- Chiral imbalance.

Minimal statement:

```text
Krein doubling repairs Lorentzian adjointness; chirality still requires an
index/domain-wall/overlap/anomaly mechanism.
```

Add a separate finite-box spectral stability audit:

- Are eigenvalues real on finite periodic boxes?
- Are nonreal eigenvalues paired and non-growing under the chosen evolution?
- Is `D_- D_+` positive or at least sectorial on the physical subspace?
- Is there a consistent projection to a Hilbert-positive observable sector?
```

### 6. `AgentTasks/aristotle-downloads-wave12-13-20260626/c59-post-c21-projected-release-criterion/c59-post-c21-projected-release-criterion_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [20.6 Gate C addendum: Krein audit is necessary but not stability]

Score: `0.788`

```text
### 20.6 Gate C addendum: Krein audit is necessary but not stability

Finite Krein algebra:

```text
J = J^dagger = J^{-1}
A^sharp = J A^dagger J
D_- = D_+^sharp
D_dbl = [[0, D_-], [D_+, 0]]
J_dbl = [[J, 0], [0, J]]
```

Target theorem:

```text
D_dbl is J_dbl-self-adjoint.
```

Non-claims:

- Real spectrum.
- Positivity.
- No growing modes.
- Unitary time evolution.
- Sensible spectral action.
- Anomaly safety.
- Chiral imbalance.

Minimal statement:

```text
Krein doubling repairs Lorentzian adjointness; chirality still requires an
index/domain-wall/overlap/anomaly mechanism.
```

Add a separate finite-box spectral stability audit:

- Are eigenvalues real on finite periodic boxes?
- Are nonreal eigenvalues paired and non-growing under the chosen evolution?
- Is `D_- D_+` positive or at least sectorial on the physical subspace?
- Is there a consistent projection to a Hilbert-positive observable sector?
```

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [20.6 Gate C addendum: Krein audit is necessary but not stability]

Score: `0.788`

```text
### 20.6 Gate C addendum: Krein audit is necessary but not stability

Finite Krein algebra:

```text
J = J^dagger = J^{-1}
A^sharp = J A^dagger J
D_- = D_+^sharp
D_dbl = [[0, D_-], [D_+, 0]]
J_dbl = [[J, 0], [0, J]]
```

Target theorem:

```text
D_dbl is J_dbl-self-adjoint.
```

Non-claims:

- Real spectrum.
- Positivity.
- No growing modes.
- Unitary time evolution.
- Sensible spectral action.
- Anomaly safety.
- Chiral imbalance.

Minimal statement:

```text
Krein doubling repairs Lorentzian adjointness; chirality still requires an
index/domain-wall/overlap/anomaly mechanism.
```

Add a separate finite-box spectral stability audit:

- Are eigenvalues real on finite periodic boxes?
- Are nonreal eigenvalues paired and non-growing under the chosen evolution?
- Is `D_- D_+` positive or at least sectorial on the physical subspace?
- Is there a consistent projection to a Hilbert-positive observable sector?
```

### 8. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [20.6 Gate C addendum: Krein audit is necessary but not stability]

Score: `0.788`

```text
### 20.6 Gate C addendum: Krein audit is necessary but not stability

Finite Krein algebra:

```text
J = J^dagger = J^{-1}
A^sharp = J A^dagger J
D_- = D_+^sharp
D_dbl = [[0, D_-], [D_+, 0]]
J_dbl = [[J, 0], [0, J]]
```

Target theorem:

```text
D_dbl is J_dbl-self-adjoint.
```

Non-claims:

- Real spectrum.
- Positivity.
- No growing modes.
- Unitary time evolution.
- Sensible spectral action.
- Anomaly safety.
- Chiral imbalance.

Minimal statement:

```text
Krein doubling repairs Lorentzian adjointness; chirality still requires an
index/domain-wall/overlap/anomaly mechanism.
```

Add a separate finite-box spectral stability audit:

- Are eigenvalues real on finite periodic boxes?
- Are nonreal eigenvalues paired and non-growing under the chosen evolution?
- Is `D_- D_+` positive or at least sectorial on the physical subspace?
- Is there a consistent projection to a Hilbert-positive observable sector?
```

## Scoped paper hits

### 1. On Noncommutative and semi-Riemannian Geometry

Score: `0.755`
Zotero key: `F877GT5B`
arXiv: `math-ph/0110001`
DOI: `10.48550/arXiv.math-ph/0110001`
URL: https://arxiv.org/abs/math-ph/0110001

Abstract:

Introduces semi-Riemannian spectral triples using Krein spaces and Krein-selfadjoint Dirac operators, with recovery of signature data from spectral data.

### 2. An Argument for Strong Positivity of the Decoherence Functional

Score: `0.750`
Zotero key: `arxiv:2011.06120`
arXiv: `2011.06120`
URL: http://arxiv.org/abs/2011.06120

Abstract:

Argues that strong positivity is the correct physical positivity condition for path-integral/decoherence-functional quantum theory, via closure and maximality under tensor products.

### 3. Krein spectral triples and the fermionic action

Score: `0.733`
Zotero key: `PFAG59D4`
arXiv: `1505.01939`
DOI: `10.1007/s11040-016-9207-z`
URL: https://www.zotero.org/19894138/items/PFAG59D4

Abstract:

Motivated by the space of spinors on a Lorentzian manifold, we define Krein spectral triples, which generalise spectral triples from Hilbert spaces to Krein spaces. This Krein space approach allows for an improved formulation of the fermionic action for almost-commutative manifolds. We show by explicit calculation that this action functional recovers the correct Lagrangians for the cases of electrodynamics, the electro-weak theory, and the Standard Model. The description of these examples does not require a real structure, unless one includes Majorana masses, in which case the internal spaces also exhibit a Krein space structure.

### 4. Moduli spaces of Dirac operators for finite spectral triples

Score: `0.725`
Zotero key: `XEECSHKK`
arXiv: `0902.2068`
DOI: `10.1007/978-3-8348-9831-9_2`
URL: http://arxiv.org/abs/0902.2068

Abstract:

The structure theory of finite real spectral triples developed by Krajewski and by Paschke and Sitarz is generalised to allow for arbitrary KO-dimension and the failure of orientability and Poincare duality, and moduli spaces of Dirac operators for such spectral triples are defined and studied. This theory is then applied to recent work by Chamseddine and Connes towards deriving the finite spectral triple of the noncommutative-geometric Standard Model.

### 5. An analysis of completely-positive trace-preserving maps on M2

Score: `0.716`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`
