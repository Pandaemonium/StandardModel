# Aristotle semantic context pack

Generated: 2026-07-21T15:26:46
Query: `massive HNU inverse Cayley Hermitian generator exact opposite eigenvalue pairing two positive two negative certified sign projector rank two`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [hnuCayley_negativeProjector_exists]

Score: `0.871`

```text
theorem hnuCayley_negativeProjector_exists (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    ∃ eps P : Mat4,
      SignCertificate (hnuCayleyGenerator a k) eps ∧
      eps.IsHermitian ∧
      P = (2 : Complex)⁻¹ • (1 - eps) ∧
      P * P = P ∧ P.IsHermitian := by
  sorry

end PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector
```

### 2. `AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_CAYLEY_BAND_SELECTOR_2026-07-21.md` [Repository fit]

Score: `0.868`

```text
## Repository fit

The live HNU family has exactly the required finite hypotheses:

1. `massiveHNU_unitary`: each fiber is unitary.
2. `massiveHNU_zero_pi_gap`: for `0 < a < pi` and momentum in the closed
   Brillouin cube, both `det(U - 1)` and `det(U + 1)` are nonzero.
3. `OverlapSignExistence.certifiedSign_exists`: every invertible Hermitian
   finite matrix has a certified sign.
4. `OverlapSignHermitian.signCertificate_isHermitian`: that certified sign is
   a self-adjoint involution.

Define

```text
A(U) = i (U - 1) (U + 1)^-1.
```

The `-1` gap makes the denominator invertible and, with unitarity, makes `A`
Hermitian. The `+1` gap makes `A` invertible. Its certified sign then gives the
orthogonal projector `(1 - sign(A))/2` onto one Cayley-sign sector.
```

### 3. `AgentTasks/hnu-cayley-band-selector-aristotle-2026-07-21.md` [Available anchors]

Score: `0.867`

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

### 4. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean`

Score: `0.861`

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

### 5. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [hnuCayley_certifiedSign_exists]

Score: `0.859`

```text
theorem hnuCayley_certifiedSign_exists (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    ∃ eps : Mat4,
      SignCertificate (hnuCayleyGenerator a k) eps ∧ eps.IsHermitian := by
  sorry

/-- The certified sign supplies an orthogonal finite band projector. The
choice `(1 - eps)/2` selects the negative Cayley-sign sector. -/
```

### 6. `PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` [hnuCayleyGenerator_isHermitian]

Score: `0.837`

```text
theorem hnuCayleyGenerator_isHermitian (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    (hnuCayleyGenerator a k).IsHermitian := by
  sorry

/-- The same generator is invertible: the `+1` Floquet gap becomes the zero
gap of the Hermitian Cayley generator. -/
```

### 7. `PhysicsSM/Draft/NullEdge/GateC2/OverlapSignExistence.lean` [certifiedSign_exists]

Score: `0.835`

```text
theorem certifiedSign_exists (H : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) :
    SignCertificate H (epsCFC H) := by
  set A := CFC.sqrt (H ^ 2) with hA
  have hpsd2 : (H ^ 2).PosSemidef := by
    have hsq : H ^ 2 = Hᴴ * H := by rw [hHherm.eq, sq]
    rw [hsq]; exact Matrix.posSemidef_conjTranspose_mul_self H
  have hA_sq : A ^ 2 = H ^ 2 := CFC.sq_sqrt (a := H ^ 2) (nonneg_iff_posSemidef.mpr hpsd2)
  have hApsd : A.PosSemidef := nonneg_iff_posSemidef.mp (CFC.sqrt_nonneg (H ^ 2))
  have hcomm : Commute A H := by
    have hc : Commute (H ^ 2) H := (Commute.refl H).pow_left 2
    rw [hA]; unfold CFC.sqrt; exact hc.cfcₙ_nnreal NNReal.sqrt
  have hcommInv : Commute A (⅟H) := hcomm.invOf_right
  have hepsH : epsCFC H * H = A := by
    unfold epsCFC; rw [← hA, mul_assoc, invOf_mul_self, mul_one]
  refine ⟨?_, ?_, ?_⟩
  · -- involution: (A * ⅟H) * (A * ⅟H) = 1
    unfold epsCFC; rw [← hA]
    have h1 : A * ⅟H * (A * ⅟H) = A * A * (⅟H * ⅟H) := by
      rw [mul_assoc, ← mul_assoc (⅟H), ← hcommInv.eq, mul_assoc, mul_assoc]
    rw [h1, ← sq, ← sq, hA_sq, sq, sq]
    rw [mul_assoc H H, ← mul_assoc H (⅟H), mul_invOf_self, one_mul, mul_invOf_self]
  · -- commutation: (A * ⅟H) * H = H * (A * ⅟H), both equal A
    rw [hepsH]
    unfold epsCFC; rw [← hA, ← mul_assoc, ← hcomm.eq, mul_assoc, mul_invOf_self, mul_one]
  · -- positivity: (epsCFC H) * H = A is PSD
    rw [hepsH]; exact hApsd

/-- **The certified overlap sign is well-defined and explicit.**  For a gapped
Hermitian `H`, every sign certificate equals `epsCFC H = |H| H^-1` (existence +
uniqueness). -/
```

### 8. `Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md` [2. What is proved]

Score: `0.835`

```text
al calculus).** The key C2b interface. A
**sign certificate** for a gapped (invertible) Hermitian `H` is a matrix `eps`
with `eps^2 = 1`, `eps H = H eps`, and `eps H` positive semidefinite - the finite,
functional-calculus-free defining conditions of `sign(H) = H |H|^{-1}`
(`OverlapSignCertificate.SignCertificate`). Two theorems make it well-posed:
- UNIQUENESS (`certifiedSign_unique`): any two certificates for the same `H`
  coincide. Slick proof: `(eps H)^2 = H^2` (from commutation + involution) and
  `eps H` PSD, so `eps H` is THE positive-semidefinite square root of `H^2`
  (unique); invertibility of `H` cancels.
- EXISTENCE (`OverlapSignExistence.certifiedSign_exists`, proved by Aristotle,
  ported): `epsCFC H = CFC.sqrt(H^2) . H^{-1} = |H| H^{-1}` is a certificate. The
  load-bearing step is `Commute (CFC.sqrt(H^2)) H` (a continuous-functional-
  calculus commutation).
- SELF-ADJOINTNESS (`OverlapSignHermitian.signCertificate_isHermitian`): any
  certificate for an invertible Hermitian `H` is automatically Hermitian, so the
  finite certificate conditions force a genuine self-adjoint involution.
Together (`certifiedSign_eq_epsCFC`): the certified overlap sign of any gapped
Hermitian is well-defined AND explicitly `|H| H^{-1}`. The STATEMENTS use only
involution + commutation + the Loewner order; the CFC appears only as a proof tool
for existence. A certified sign yields a GW overlap
(`SignCertificate.dov_ginspargWilson`).

Self-consistency (`OverlapSignHermitian.lean`): the three certificate conditions
already FORCE self-adjointness (`signCertificate_isHermitian` - `eps H` PSD is
Hermitian, so `H eps^* = H eps`, cancel `H`), so `eps^* = eps` is not an extra
hypothesis.  Hence `epsCFC H` is a genuine SELF-ADJOINT INVOLUTION - an orthogonal
reflection (`epsCFC_isSel
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.759`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Decay Properties of Spectral Projectors with Applications to Electronic Structure

Score: `0.756`
Zotero key: `8CPJCV8S`
arXiv: `1203.3953`
DOI: `10.1137/100814019`
URL: https://doi.org/10.1137/100814019

Abstract:

This paper applies approximation theory and matrix analysis to spectral projectors of large sparse Hermitian matrices. It proves exponential off-diagonal decay for the density matrix of gapped systems at zero temperature in orthogonal and non-orthogonal representations, and discusses metallic systems at positive temperature.

### 3. Pseudo-Hermitian Random Matrix Models: General Formalism

Score: `0.735`
Zotero key: `W56B45DZ`
arXiv: `2109.09221`
DOI: `10.1016/j.nuclphysb.2022.115678`
URL: http://arxiv.org/abs/2109.09221

Abstract:

Pseudo-hermitian matrices are matrices hermitian with respect to an indefinite metric. They can be thought of as the truncation of pseudo-hermitian operators, defined over some Krein space, together with the associated metric, to a finite dimensional subspace. As such, they can be used, in the usual spirit of random matrix theory, to model chaotic or disordered PT-symmetric quantum systems, or their gain-loss-balanced classical analogs, in the phase of broken PT-symmetry. The eigenvalues of pseudo-hermitian matrices are either real, or come in complex-conjugate pairs. In this paper we introduce a family of pseudo-hermitian random matrix models, depending parametrically on their metric. We apply the diagrammatic method to obtain its averaged resolvent and density of eigenvalues as explicit functions of the metric, in the limit of large matrix size N. The numbers of complex and real eigenvalues depend on the signature of the metric, that is, the numbers of its positive and negative eigenvalues.

### 4. The Exceptional Jordan Eigenvalue Problem

Score: `0.730`
Zotero key: `WEZ86AZW`
arXiv: `math-ph/9910004`
URL: http://arxiv.org/abs/math-ph/9910004

Abstract:

We discuss the eigenvalue problem for 3x3 octonionic Hermitian matrices which is relevant to the Jordan formulation of quantum mechanics. In contrast to the eigenvalue problems considered in our previous work, all eigenvalues are real and solve the usual characteristic equation. We give an elementary construction of the corresponding eigenmatrices, and we further speculate on a possible application to particle physics.

### 5. An Analysis of Completely-Positive Trace-Preserving Maps on 2x2 Matrices

Score: `0.729`
Zotero key: `PKMDHXHA`
arXiv: `quant-ph/0101003`
URL: http://arxiv.org/abs/quant-ph/0101003

Abstract:

We give a useful new characterization of the set of all completely positive, trace-preserving (i.e., stochastic) maps from 2x2 matrices to 2x2 matrices. These conditions allow one to easily check any trace-preserving map for complete positivity. We also determine explicitly all extreme points of this set, and give a useful parameterization after reduction to a certain canonical form.

### 6. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.726`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039
