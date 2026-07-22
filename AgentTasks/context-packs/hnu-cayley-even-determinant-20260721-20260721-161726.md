# Aristotle semantic context pack

Generated: 2026-07-21T16:17:32
Query: `massive HNU reciprocal characteristic polynomial inverse Cayley transform even shifted determinant opposite spectral energies`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean`

Score: `0.826`

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

### 2. `PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean` [massiveHNU_shifted_det_reduction]

Score: `0.825`

```text
lemma massiveHNU_shifted_det_reduction (a : Real) (k : Fin 3 -> Real)
    (sgn : Complex) (hsgn : sgn = 1 ∨ sgn = -1) :
    (massiveHNU (1 : Complex) a k -
        sgn • (1 : Matrix (Fin 4) (Fin 4) Complex)).det =
      (endpoint k * endpoint (fun i => -k i) -
        (sgn * Real.cos a) •
          (endpoint k + endpoint (fun i => -k i)) +
        (1 : Matrix (Fin 2) (Fin 2) Complex)).det := by
  cases hsgn <;> simp +decide [ *, massiveHNU ]
  · unfold Pluecker3Plus1ComplexMass.massCoin4
    simp +decide [ diracHNU ]
    unfold Pluecker3Plus1ComplexMass.mass4
    simp +decide [ diracBasis, doubledChiralEndpoint ]
    simp +decide [ Pluecker3Plus1ComplexMass.beta,
      Pluecker3Plus1ComplexMass.beta5, Pluecker3Plus1ComplexMass.gamma5,
      Matrix.det_succ_row_zero, Matrix.det_fin_three, Matrix.det_fin_two,
      Matrix.mul_apply, Fin.sum_univ_succ ] at *
    simp +decide [ Matrix.vecMul, dotProduct, Fin.sum_univ_succ ]
    simp +decide [ Fin.succAbove, Matrix.one_apply ]
    field_simp
    norm_cast
    norm_num [ pow_succ, mul_assoc ]
    ring
    norm_num [ Complex.sin_sq ]
    ring
    grind +suggestions
  · unfold diracHNU Pluecker3Plus1ComplexMass.massCoin4
      Pluecker3Plus1ComplexMass.mass4 Pluecker3Plus1ComplexMass.beta
      Pluecker3Plus1ComplexMass.beta5 Pluecker3Plus1ComplexMass.gamma5
    unfold diracBasis doubledChiralEndpoint
    norm_num [ Matrix.det_succ_row_zero ]
    simp +decide [ Fin.sum_univ_succ, Fin.succAbove, Matrix.mul_apply,
      Matrix.one_apply ] at *
    simp +decide [ Matrix.vecMul, Matrix.vecHead, Matrix.vecTail ] at *
    ring_nf at *
    norm_cast
    norm_num [ show (Real.sqrt 2 : Real) ^ 6 = (Real.sqrt 2 ^ 2) ^ 3 by ring,
      show (Real.sqrt 2 : Real) ^ 8 = (Real.sqrt 2 ^ 2) ^ 4 by ring ]
    ring_nf
    norm_cast
    norm_num [
```

### 3. `AgentTasks/hnu-cayley-band-selector-aristotle-2026-07-21.md` [Objective]

Score: `0.818`

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

### 4. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [hnuCayleyGenerator]

Score: `0.810`

```text
def hnuCayleyGenerator (a : Real) (k : Fin 3 -> Real) : Mat4 :=
  cayleyGenerator (massiveHNU (1 : Complex) a k)

/-- The live massive HNU Cayley generator is Hermitian throughout the closed
Brillouin cube at every nontrivial mass angle. -/
```

### 5. `PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean` [endpoint_eq_momentumReverse_iff]

Score: `0.806`

```text
theorem endpoint_eq_momentumReverse_iff (k : Fin 3 -> Real) (hk : InBZ k) :
    endpoint k = endpoint (fun i => -k i) <->
      (forall i, k i = 0) ∨ OnBZBoundary k := by
  have hz := HNUExactCore.zero_census k hk
  have hp := HNUExactCore.pi_census k hk
  constructor
  · intro h
    rcases endpoint_eq_reverse_imp_central k hk h with h0 | hpi
    · exact Or.inl (hz.mp h0)
    · exact Or.inr (hp.mp hpi)
  · intro h
    apply endpoint_central_imp_eq_reverse k
    rcases h with h0 | hpi
    · exact Or.inl (hz.mpr h0)
    · exact Or.inr (hp.mpr hpi)

set_option maxHeartbeats 800000 in
/-- Exact shifted determinants of the local mass coin at the origin. -/
```

### 6. `PhysicsSM/Draft/NullEdge/EvenMassGaps.lean` [Hmass_det]

Score: `0.802`

```text
theorem Hmass_det (m : ℚ) : (Hmass m).det = m^4 := by
  rw [Hmass_eq, Matrix.det_fin_two_of]; ring

/-- **Target 3.** For any nonzero even mass `m`, the Hermitian square `Hₘ` has
`det Hₘ = m⁴ ≠ 0`: it is invertible, hence has **no** zero eigenvalue. The chiral
mode is gapped (massive). -/
```

### 7. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [cayleyGenerator_isHermitian]

Score: `0.800`

```text
theorem cayleyGenerator_isHermitian (U : Mat4)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex)
    (hpi : (U + 1).det ≠ 0) :
    (cayleyGenerator U).IsHermitian := by
  sorry

/-- If the unitary also has no `+1` eigenvalue, its inverse Cayley transform is
invertible. -/
```

### 8. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [cayleyGenerator]

Score: `0.796`

```text
def cayleyGenerator (U : Mat4) : Mat4 :=
  Complex.I • (U - 1) * (U + 1)⁻¹

/-- A unitary matrix with no `-1` eigenvalue has a Hermitian inverse Cayley
transform. -/
```

## Scoped paper hits

### 1. Matching number, Hamiltonian graphs and magnetic Laplacian matrices

Score: `0.713`
Zotero key: `GNEARI9Q`
arXiv: `2010.08828`
DOI: `10.1016/j.laa.2022.02.006`
URL: https://doi.org/10.1016/j.laa.2022.02.006

### 2. The Exceptional Jordan Eigenvalue Problem

Score: `0.710`
Zotero key: `WEZ86AZW`
arXiv: `math-ph/9910004`
URL: http://arxiv.org/abs/math-ph/9910004

Abstract:

We discuss the eigenvalue problem for 3x3 octonionic Hermitian matrices which is relevant to the Jordan formulation of quantum mechanics. In contrast to the eigenvalue problems considered in our previous work, all eigenvalues are real and solve the usual characteristic equation. We give an elementary construction of the corresponding eigenmatrices, and we further speculate on a possible application to particle physics.

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.707`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.704`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299
