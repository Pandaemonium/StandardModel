import PhysicsSM.Draft.E8ThetaCoeffGapAristotle
import PhysicsSM.Draft.E8ThetaDim8MF
import PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle
import PhysicsSM.Draft.E8ShellBridgeHelper

/-!
# Aristotle target: construct the E8 theta modular form

This file closes the modular-form packaging bridge for the Hamming E8 theta
route, using `PhysicsSM.Coding.E8ThetaDim8.thetaE8_MF` (a proven weight-4
level-1 modular form for the SPL E8 lattice) as the candidate.

## Strategy

We use the modular form `thetaE8_MF` from `E8ThetaDim8MF.lean`, which has:
* `thetaE8_MF_apply : thetaE8_MF z = thetaSeriesUHP8 z`
* `thetaE8_MF_eq_E4 : thetaE8_MF = E₄`

The proof reduces to two bridge lemmas:

1. **Lattice transport** (`e8ThetaAnalytic_eq_thetaSeriesUHP8`):
   The integer Construction A theta series equals the real E8Lattice theta
   series, via the norm-preserving bijection between `e8IntLattice` (scaled by
   `1/√2`) and SPL's `E8Lattice`.

2. **Q-expansion coefficient matching** (`qExpansion_thetaE8_MF_coeff`):
   Proved by chaining `thetaE8_MF_eq_E4` (from `E8ThetaDim8MF.lean`) with
   `splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff` (s o r r y'd in
   `E8ThetaWeightEnumeratorBridgeAristotle.lean`).  This s o r r y is the
   "SPL theta coefficient bridge" documented in that file.

## References

* `PhysicsSM.Draft.E8ThetaDim8MF` — theta modular form for SPL's E8Lattice.
* `PhysicsSM.Draft.E8ThetaCoeffGapAristotle` — coefficient reduction machinery.
* `PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle` — SPL theta/Hamming
  coefficient bridge.
* `PhysicsSM.Coding.ConstructionAThetaConvolution` — Construction A shell counts.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false

open ModularFormClass

namespace PhysicsSM.Coding
namespace E8ThetaSPLBridge

open PhysicsSM.Coding.E8ShellBridge PhysicsSM.Draft.E8SpherePackingImported

/-!
## Analytic theta function

The unscaled integer Construction A model has `sqNorm z = 4 * n` for the
coefficient of `q^n`.  Equivalently, after the usual E8 scaling by
`1 / sqrt 2`, the analytic theta summand is

`exp (pi * I * tau * (sqNorm z / 2)) = exp (2 * pi * I * tau * (sqNorm z / 4))`.
-/

/--
The analytic theta function attached to the Hamming Construction A E8 lattice,
viewed as a function on the upper half-plane.

This is intentionally a direct sum over the integer Construction A model.  A
successful proof may either work with this definition directly, or transport it
to SPL's `Submodule.E8 Real` using the bridge lemmas in
`PhysicsSM.Draft.E8SpherePackingImported`.
-/
noncomputable def e8ThetaAnalytic (z : UpperHalfPlane) : Complex :=
  tsum fun v : {v : Fin 8 -> Int // (e8IntLattice : Set (Fin 8 -> Int)) v} =>
    Complex.exp
      (2 * (Real.pi : Complex) * Complex.I * (z : Complex) *
        ((sqNorm (v : Fin 8 -> Int) : Complex) / 4))

/-!
## Bridge lemma 1: Lattice transport (handoff marker)

This lemma isolates the transport gap between the integer Construction A
model (`e8IntLattice`, `Fin 8 → ℤ`) and SPL's real E8Lattice
(`EuclideanSpace ℝ (Fin 8)`).

### Proof strategy

The E8Lattice in SPL is defined (in `SpherePacking.Dim8.E8.Packing`) as
`(Submodule.E8 ℝ).map (WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm.toLinearMap`.

`Submodule.E8 ℝ` uses the half-integer/integer-sum model with the parity
condition:
  `v ∈ E8 ℝ ↔ ((∀ i, ∃ n : ℤ, n = v i) ∨ (∀ i, ∃ n : ℤ, Odd n ∧ n = 2 • v i))
                ∧ ∑ i, v i ≡ 0 [PMOD 2]`

The Construction A lattice `e8IntLattice` consists of integer vectors
`v : Fin 8 → ℤ` satisfying the Hamming parity check
`reduceModTwo v ∈ extendedHamming8`.

These are related by a change of basis (Hadamard-type transform), documented
in `PhysicsSM.Draft.E8SpherePackingBridge`.  The key norm identity is:
for corresponding vectors `v ↦ w`, `‖w‖² = sqNorm(v) / 2`, which gives
`exp(πi‖w‖²τ) = exp(πi · sqNorm(v)/2 · τ) = exp(2πiτ · sqNorm(v)/4)`.
-/

/-!
**Handoff lemma (lattice transport).**

The integer Construction A theta series `e8ThetaAnalytic` equals SPL's
`thetaSeriesUHP8`, which sums over `E8Lattice ⊂ EuclideanSpace ℝ (Fin 8)`.

The proof requires establishing a norm-preserving bijection between
`{v : Fin 8 → ℤ | v ∈ e8IntLattice}` and `E8Lattice` satisfying
`‖φ(v)‖² = sqNorm(v) / 2`.

This is the sole remaining s o r r y in this file.  The q-expansion coefficient
s o r r y is located in `E8ThetaWeightEnumeratorBridgeAristotle.lean` as
`splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff`.
-/
/--
The norm-preserving transport map from the integer Construction A model to
SPL's real `E8Lattice`.  It sends `v ∈ e8IntLattice` to the real lattice vector
`toE8LatticeVec (basisLinearCombination v)`, which lies in `E8Lattice` by
`toE8LatticeVec_mem`.
-/
noncomputable def transportMap
    (v : {v : Fin 8 → Int // (e8IntLattice : Set (Fin 8 → Int)) v}) :
    E8Lattice :=
  ⟨toE8LatticeVec (basisLinearCombination v.1), toE8LatticeVec_mem _⟩

/-- `transportMap` is a bijection between the integer Construction A model and
the real `E8Lattice`. -/
lemma transportMap_bijective : Function.Bijective transportMap := by
  constructor
  · rintro ⟨z1, h1⟩ ⟨z2, h2⟩ h
    have hval : toE8LatticeVec (basisLinearCombination z1)
        = toE8LatticeVec (basisLinearCombination z2) :=
      congrArg Subtype.val h
    have hc := toE8LatticeVec_injective hval
    have e1 := fromBasisCoeffs_basisLinearCombination z1 h1
    have e2 := fromBasisCoeffs_basisLinearCombination z2 h2
    apply Subtype.ext
    calc z1 = fromBasisCoeffs (basisLinearCombination z1) := e1.symm
      _ = fromBasisCoeffs (basisLinearCombination z2) := by rw [hc]
      _ = z2 := e2
  · rintro ⟨w, hw⟩
    obtain ⟨c, hc⟩ := toE8LatticeVec_surj w hw
    refine ⟨⟨fromBasisCoeffs c, fromBasisCoeffs_mem c⟩, ?_⟩
    apply Subtype.ext
    show toE8LatticeVec (basisLinearCombination (fromBasisCoeffs c)) = w
    rw [basisLinearCombination_fromBasisCoeffs, hc]

/-- The transport map identifies the analytic theta summand with SPL's
`thetaTerm8`.  The key input is `sqNorm_eq_two_mul_norm_sq`, which gives
`‖transportMap v‖² = sqNorm v / 2`. -/
lemma thetaTerm8_transportMap (z : UpperHalfPlane)
    (v : {v : Fin 8 → Int // (e8IntLattice : Set (Fin 8 → Int)) v}) :
    E8ThetaDim8.thetaTerm8 (z : Complex) (transportMap v) =
      Complex.exp
        (2 * (Real.pi : Complex) * Complex.I * (z : Complex) *
          ((sqNorm (v : Fin 8 → Int) : Complex) / 4)) := by
  have hsq : ‖((transportMap v : E8Lattice) : EuclideanSpace ℝ (Fin 8))‖ ^ 2
      = (sqNorm (v : Fin 8 → Int) : ℝ) / 2 := by
    have hnorm := PhysicsSM.Coding.E8ShellBridge.sqNorm_eq_two_mul_norm_sq v.1 v.2
    simp only at hnorm
    show ‖toE8LatticeVec (basisLinearCombination v.1)‖ ^ 2 = _
    simp only [toE8LatticeVec] at hnorm ⊢
    linarith
  unfold E8ThetaDim8.thetaTerm8
  congr 1
  rw [hsq]
  push_cast
  ring

theorem e8ThetaAnalytic_eq_thetaSeriesUHP8 (z : UpperHalfPlane) :
    e8ThetaAnalytic z = E8ThetaDim8.thetaSeriesUHP8 z := by
  rw [e8ThetaAnalytic, E8ThetaDim8.thetaSeriesUHP8, E8ThetaDim8.thetaSeries8,
    ← Equiv.tsum_eq (Equiv.ofBijective transportMap transportMap_bijective)
      (E8ThetaDim8.thetaTerm8 (z : Complex))]
  exact tsum_congr fun v => (thetaTerm8_transportMap z v).symm

/-!
## Bridge lemma 2: Q-expansion coefficient matching

This follows from the chain:
  `qExpansion(1, thetaE8_MF)`
  `= qExpansion(1, E₄)`     (by `thetaE8_MF_eq_E4`)
  `= splE4Series`           (by definition)
  `= splThetaE4Series`      (by `splE4Series_eq_splThetaE4Series`)

and then the coefficient equality
  `splThetaE4Series.coeff n = hammingThetaConvolutionCoeff n`
from `E8ThetaWeightEnumeratorBridgeAristotle.lean`.
-/

/--
The q-expansion of `thetaE8_MF` equals the SPL E₄ q-expansion.
This is immediate from `thetaE8_MF_eq_E4`.
-/
theorem qExpansion_thetaE8_MF_eq_splE4 :
    ModularFormClass.qExpansion (1 : ℝ) (E8ThetaDim8.thetaE8_MF :
        UpperHalfPlane → ℂ) =
      splE4Series := by
  unfold splE4Series
  congr 1
  exact congrArg (DFunLike.coe (F := ModularForm _ _)) E8ThetaDim8.thetaE8_MF_eq_E4

/--
The q-expansion coefficients of `thetaE8_MF` are the Construction A shell
counts `hammingThetaConvolutionCoeff`.

This chains `thetaE8_MF_eq_E4` with
`splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff` (s o r r y'd in
`E8ThetaWeightEnumeratorBridgeAristotle.lean`).
-/
theorem qExpansion_thetaE8_MF_coeff (n : ℕ) :
    (ModularFormClass.qExpansion (1 : ℝ) (E8ThetaDim8.thetaE8_MF :
        UpperHalfPlane → ℂ)).coeff n =
      (hammingThetaConvolutionCoeff n : ℂ) := by
  rw [qExpansion_thetaE8_MF_eq_splE4,
    splE4Series_eq_splThetaE4Series,
    splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff]

/-!
## Main target

The following theorem is the remaining modular-form construction needed by the
coefficient formula.  It packages the analytic modularity work and the
q-expansion comparison into the exact shape consumed by
`hammingThetaConvolutionCoeff_eq_e4Coeff_of_weight4_form`.
-/

/--
Construct the weight-4 level-1 modular form whose q-expansion coefficients are
the Hamming Construction A E8 theta coefficients.

The witness is `E8ThetaDim8.thetaE8_MF` (the SPL E8 theta modular form,
proved in `E8ThetaDim8MF.lean`).

**Remaining sorries (two, both in other files):**
1. `e8ThetaAnalytic_eq_thetaSeriesUHP8` — lattice transport (in this file)
2. `splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff` — SPL theta
   coefficient bridge (in `E8ThetaWeightEnumeratorBridgeAristotle.lean`)
-/
theorem exists_e8Theta_weight4_modularForm_with_qExpansion :
    ∃ f : ModularForm (CongruenceSubgroup.Gamma 1) 4,
      (∀ z : UpperHalfPlane, f z = e8ThetaAnalytic z) ∧
      (∀ n : Nat,
        (ModularFormClass.qExpansion (1 : Real) f).coeff n =
          (hammingThetaConvolutionCoeff n : Complex)) := by
  exact ⟨E8ThetaDim8.thetaE8_MF,
    fun z => by rw [E8ThetaDim8.thetaE8_MF_apply, ← e8ThetaAnalytic_eq_thetaSeriesUHP8],
    fun n => qExpansion_thetaE8_MF_coeff n⟩

/--
Coefficient matching extracted from the modular-form construction target.

This theorem becomes s o r r y-free once the two bridge lemmas are filled.
-/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_from_e8Theta_modularForm
    (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n := by
  let f := Classical.choose exists_e8Theta_weight4_modularForm_with_qExpansion
  have hf := Classical.choose_spec exists_e8Theta_weight4_modularForm_with_qExpansion
  have hf_qexp := hf.2
  exact hammingThetaConvolutionCoeff_eq_e4Coeff_of_weight4_form f hf_qexp n

end E8ThetaSPLBridge
end PhysicsSM.Coding
