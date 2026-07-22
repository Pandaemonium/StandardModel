# Aristotle semantic context pack

Generated: 2026-07-21T13:10:19
Query: `inverse Cayley transform live massive HNU certified sign commutes with unitary rest projector beta tan half angle`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean`

Score: `0.853`

```text
import PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignHermitian

/-!
# Cayley reduction of the gapped massive HNU walk to a Hermitian band selector

The massive HNU walk is an exactly unitary `4 x 4` Bloch family. For every
fixed mass angle strictly between zero and pi, the landed global-gap theorem
excludes both Floquet eigenvalues `+1` and `-1` on the closed Brillouin cube.
Those are precisely the two hypotheses needed for the inverse Cayley transform

`A(U) = i (U - 1) (U + 1)^-1`.

The `-1` gap makes `A(U)` a finite Hermitian matrix. The additional `+1` gap
makes it invertible. The existing certified-sign API can then produce the
unique self-adjoint involution `sign(A(U))`, and hence an orthogonal projector
onto one Cayley-sign sector.

This is a band-selection bridge, not a locality theorem. The matrix inverse is
pointwise in momentum and can be nonlocal in position space. Quasi-locality or
decay of the resulting projector requires a separate analytic theorem.

Provenance:
- C. Bourne, "Index Theory of Chiral Unitaries and Split-Step Quantum Walks,"
  SIGMA 19 (2023) 053, DOI 10.3842/SIGMA.2023.053. Consulted for the use of
  Cayley transforms and projection indices for gapped chiral unitaries.
- The finite matrix algebra below is a clean-room formalization in the
  repository's HNU and matrix conventions.

Draft status: theorem statements are typechecked handoff targets. Documented
proof holes are not landed results.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
open PhysicsSM.Dr
```

### 2. `AgentTasks/context-packs/hnu-cayley-band-selector-20260721-20260721-103444.md` [Aristotle semantic context pack]

Score: `0.833`

```text
# Aristotle semantic context pack

Generated: 2026-07-21T10:34:53
Query: `gapped unitary inverse Cayley transform Hermitian invertible certified sign projector massive HNU Floquet band`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.
```

### 3. `AgentTasks/hnu-cayley-band-selector-aristotle-2026-07-21.md` [Objective]

Score: `0.826`

```text
## Objective

Eliminate every proof handoff in
`PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` without changing its
definitions or theorem statements.

The target converts the already-gapped live massive HNU Floquet fiber to the
Hermitian matrix

```text
A(U) = i (U - 1) (U + 1)^-1.
```

The landed HNU theorem excludes both `+1` and `-1` throughout the closed
Brillouin cube for every mass angle in `(0, pi)`. The `-1` gap makes the inverse
Cayley transform well-defined and Hermitian; the `+1` gap makes it invertible.
The existing Gate-C2 certified-sign modules then supply a self-adjoint
involution and an orthogonal negative-sign projector.

Semantic context:
`AgentTasks/context-packs/hnu-cayley-band-selector-20260721-20260721-103444.md`.
```

### 4. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [cayleyGenerator]

Score: `0.814`

```text
def cayleyGenerator (U : Mat4) : Mat4 :=
  Complex.I • (U - 1) * (U + 1)⁻¹

/-- A unitary matrix with no `-1` eigenvalue has a Hermitian inverse Cayley
transform. -/
```

### 5. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [cayleyGenerator_isHermitian]

Score: `0.811`

```text
theorem cayleyGenerator_isHermitian (U : Mat4)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex)
    (hpi : (U + 1).det ≠ 0) :
    (cayleyGenerator U).IsHermitian := by
  sorry

/-- If the unitary also has no `+1` eigenvalue, its inverse Cayley transform is
invertible. -/
```

### 6. `AgentTasks/hnu-cayley-band-selector-aristotle-2026-07-21.md` [Available anchors]

Score: `0.811`

```text
## Available anchors

- `HNUPlueckerMassiveStay.massiveHNU_unitary`
- `HNUMassiveGlobalGap.massiveHNU_zero_pi_gap`
- `OverlapSignExistence.certifiedSign_exists`
- `OverlapSignHermitian.signCertificate_isHermitian`
- `Matrix.isUnit_iff_isUnit_det`
- `Matrix.invertibleOfIsUnitDet`

For a pointwise HNU generator, construct the local `Invertible` instance from
`hnuCayleyGenerator_isUnit`, then invoke the certified-sign API. The final
projector algebra follows from `eps * eps = 1` and `eps.IsHermitian`.
```

### 7. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [Mat4]

Score: `0.805`

```text
abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- Inverse Cayley transform with branch cut at Floquet eigenvalue `-1`. -/
```

### 8. `PhysicsSM/Draft/NullEdge/HNUPlueckerMassiveStay.lean` [massiveHNU_unitary]

Score: `0.805`

```text
theorem massiveHNU_unitary (z : Complex) (hz : Ne z 0)
    (a : Real) (k : Fin 3 -> Real) :
    massiveHNU z a k ∈ Matrix.unitaryGroup (Fin 4) Complex := by
  unfold massiveHNU;
  have := Pluecker3Plus1ComplexMass.massCoin4_unitary_group z hz a 0;
  simp_all +decide [ Matrix.mem_unitaryGroup_iff, Matrix.mul_assoc ];
  simp_all +decide [ ← mul_assoc, diracHNU_unitary ]

/-
At zero momentum the complete step is exactly the derived Pluecker mass
coin, so the stay/turn amplitude is not an independent parameter.
-/
```

## Scoped paper hits

### 1. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.741`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 2. An analysis of completely-positive trace-preserving maps on M2

Score: `0.735`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.721`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Renormalizing Yukawa interactions in the standard model with matrices and noncommutative geometry

Score: `0.718`
Zotero key: `SHPRQMGH`
arXiv: `1906.02297`
URL: https://arxiv.org/abs/1906.02297

Abstract:

Shows that gauge-independent terms in the one-loop and multi-loop beta-functions of the Standard Model can be computed from Wetterich functional renormalization of a matrix model associated with the finite spectral triple underlying the spectral-action computation of the Standard Model Lagrangian. Provides a matrix-Yukawa duality for beta-functions.

### 5. Hierarchy of quark masses, Cabibbo angles and CP violation

Score: `0.716`
Zotero key: `AKMVETAK`
DOI: `10.1016/0550-3213(79)90316-X`
URL: https://doi.org/10.1016/0550-3213(79)90316-x
