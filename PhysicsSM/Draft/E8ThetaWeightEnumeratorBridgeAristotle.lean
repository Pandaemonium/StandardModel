import PhysicsSM.Draft.E8ThetaCoeffGapAristotle
import PhysicsSM.Draft.WeightContribCoeffProof
import PhysicsSM.Draft.E8ThetaMFBridgeHelper
import SpherePacking.ModularForms.JacobiTheta

/-!
# Aristotle target: Hamming weight enumerator to E8 theta

This draft file prepares a sharper follow-up target after Aristotle job
`a9a170c1-b4ec-4a0e-8468-ca2db69e6f75`.

The previous job did not close the all-coefficient formula

```lean
hammingThetaConvolutionCoeff n =
  if n = 0 then 1 else 240 * sigma3 n
```

but it confirmed useful small cases and a coefficient-extraction theorem from
`thetaSeries = e4Series`.

The literature route for the remaining bridge is:

1. The theta series of a Construction A lattice is the complete/symmetrized
   weight enumerator evaluated at the one-dimensional coset theta series.
2. For the binary extended Hamming `[8,4,4]` code this is
   `even^8 + 14 * even^4 * odd^4 + odd^8`.
3. In analytic Jacobi-theta notation this is the usual E8 theta function,
   equivalent to the SPL theorem `SpherePacking.ModularForms.E4_eq_thetaE4`
   after tracking the project normalization `sqNorm = 4*n`.

This file exposes two proof targets:

* a purely formal coefficient target
  `weightContribFormalSeries_coeff`, which should be approachable by
  `PowerSeries.coeff_prod` and a finite-support-antidiagonal bijection;
* the full SPL coefficient bridge
  `splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff`, which would close
  the E8 theta/E4 theorem immediately.

If the SPL analytic q-expansion bridge is out of reach, proving the formal
coefficient target is still valuable scaffolding for the next round.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.setOption false
set_option maxHeartbeats 400000

open SpherePacking.ModularForms

namespace PhysicsSM.Coding
namespace E8ThetaSPLBridge

/-! ## Formal one-dimensional lift series -/

/-- Coordinate coefficient used in the weight-`w` Construction A product. -/
def parityLiftCoeff (w : Nat) (i : Fin 8) (s : Nat) : Nat :=
  if i.val < w then oddLiftCoeff s else evenLiftCoeff s

/--
The one-dimensional formal series for coordinate `i` in the canonical
weight-`w` residue pattern.
-/
noncomputable def parityLiftSeries (w : Nat) (i : Fin 8) : PowerSeries Nat :=
  PowerSeries.mk fun s => parityLiftCoeff w i s

/--
Product of the eight one-dimensional lift series for a canonical residue of
Hamming weight `w`.

Its `s`-th coefficient should be exactly `weightContribConvolution w s`.
-/
noncomputable def weightContribFormalSeries (w : Nat) : PowerSeries Nat :=
  (Finset.univ : Finset (Fin 8)).prod fun i => parityLiftSeries w i

/--
Pure formal coefficient target.

This is the algebraic content of the Construction A theta/weight-enumerator
bridge after the codeword-weight grouping has already been proved in
`ConstructionAThetaConvolution.lean`.

Proved using the general `coeff_finset_prod_eq_sum_fin` lemma which connects
`PowerSeries.coeff_prod` (using `finsuppAntidiag`) with the explicit
`Fin (s+1)` formulation in `weightContribConvolution`.
-/
theorem weightContribFormalSeries_coeff (w s : Nat) :
    PowerSeries.coeff s (weightContribFormalSeries w) =
      weightContribConvolution w s := by
  unfold weightContribFormalSeries
  rw [coeff_finset_prod_eq_sum_fin]
  unfold weightContribConvolution
  congr 1
  ext parts
  split_ifs with h
  case pos =>
    congr 1
    ext i
    simp [parityLiftSeries, parityLiftCoeff, PowerSeries.coeff_mk]
  case neg =>
    rfl

/-! ## Formal Hamming weight-enumerator series -/

/--
The formal Hamming weight-enumerator theta series over `Nat`.

For the extended Hamming `[8,4,4]` code the nonzero weight distribution is
`A_0 = 1`, `A_4 = 14`, and `A_8 = 1`, represented here by the existing
`extendedHamming8WeightDist` function.
-/
noncomputable def hammingWeightEnumeratorFormalSeries : PowerSeries Nat :=
  PowerSeries.C (extendedHamming8WeightDist 0) * weightContribFormalSeries 0 +
  PowerSeries.C (extendedHamming8WeightDist 4) * weightContribFormalSeries 4 +
  PowerSeries.C (extendedHamming8WeightDist 8) * weightContribFormalSeries 8

/--
The formal Hamming weight-enumerator series has the same `4*n` coefficient as
the project-local Hamming theta convolution.
-/
theorem hammingWeightEnumeratorFormalSeries_coeff (n : Nat) :
    PowerSeries.coeff (4 * n) hammingWeightEnumeratorFormalSeries =
      hammingThetaConvolutionCoeff n := by
  rw [hammingWeightEnumeratorFormalSeries, hammingThetaConvolutionCoeff]
  simp only [map_add]
  rw [PowerSeries.coeff_C_mul, PowerSeries.coeff_C_mul, PowerSeries.coeff_C_mul]
  rw [weightContribFormalSeries_coeff, weightContribFormalSeries_coeff,
    weightContribFormalSeries_coeff]

/-! ## Analytic theta-constant reduction -/

/--
Doubling map on the upper half-plane.

This is the normalization used by the classical Construction A theta formula:
the scaled Construction A exponent is `sqNorm / 4`, so the one-dimensional
even and odd lift series correspond to theta constants at `2 * tau`.
-/
noncomputable def twoTau (tau : UpperHalfPlane) : UpperHalfPlane :=
  ⟨(2 : Complex) * (tau : Complex), by
    simpa using mul_pos (by norm_num : (0 : Real) < 2) tau.im_pos⟩

/--
The analytic Hamming theta polynomial in theta constants.

Classically this is
`Theta3(2*tau)^8 + 14*Theta3(2*tau)^4*Theta2(2*tau)^4 + Theta2(2*tau)^8`,
the weight enumerator `x^8 + 14*x^4*y^4 + y^8` evaluated at the even and odd
one-dimensional theta constants.
-/
noncomputable def hammingThetaConstantPolynomial (tau : UpperHalfPlane) : Complex :=
  (Θ₃ (twoTau tau)) ^ 8 +
  (14 : Complex) * (Θ₃ (twoTau tau)) ^ 4 * (Θ₂ (twoTau tau)) ^ 4 +
  (Θ₂ (twoTau tau)) ^ 8

/--
Algebraic heart of the standard theta-constant proof.

Given the two classical duplication identities

* `Theta2(tau)^2 = 2 * Theta2(2*tau) * Theta3(2*tau)`;
* `Theta4(tau)^2 = Theta3(2*tau)^2 - Theta2(2*tau)^2`,

the Hamming weight-enumerator theta polynomial is exactly SPL's
`thetaE4 = H2^2 + H2*H4 + H4^2`.

This theorem is now fully algebraic; the remaining analytic work is to prove
the two duplication identities in SPL's theta-constant conventions and to show
that the q-expansion coefficients of `hammingThetaConstantPolynomial` are the
formal Hamming coefficients above.
-/
theorem hammingThetaConstantPolynomial_eq_thetaE4_of_duplication
    (hTheta2_sq : forall tau : UpperHalfPlane,
      (Θ₂ tau) ^ 2 = (2 : Complex) * Θ₂ (twoTau tau) * Θ₃ (twoTau tau))
    (hTheta4_sq : forall tau : UpperHalfPlane,
      (Θ₄ tau) ^ 2 = (Θ₃ (twoTau tau)) ^ 2 - (Θ₂ (twoTau tau)) ^ 2)
    (tau : UpperHalfPlane) :
    hammingThetaConstantPolynomial tau = SpherePacking.ModularForms.thetaE4 tau := by
  unfold hammingThetaConstantPolynomial SpherePacking.ModularForms.thetaE4 H₂ H₄
  simp only [Pi.add_apply, Pi.mul_apply, Pi.pow_apply]
  set a : Complex := Θ₃ (twoTau tau)
  set b : Complex := Θ₂ (twoTau tau)
  have h2pow : (Θ₂ tau) ^ 4 = ((2 : Complex) * b * a) ^ 2 := by
    calc
      (Θ₂ tau) ^ 4 = ((Θ₂ tau) ^ 2) ^ 2 := by ring
      _ = ((2 : Complex) * b * a) ^ 2 := by
        rw [hTheta2_sq tau]
  have h4pow : (Θ₄ tau) ^ 4 = (a ^ 2 - b ^ 2) ^ 2 := by
    calc
      (Θ₄ tau) ^ 4 = ((Θ₄ tau) ^ 2) ^ 2 := by ring
      _ = (a ^ 2 - b ^ 2) ^ 2 := by
        rw [hTheta4_sq tau]
  rw [h2pow, h4pow]
  ring

/--
Conditional closing theorem from the two precise analytic ingredients.

This packages the remaining gap in the most local form I can currently see:
prove the two theta-constant duplication identities, and prove that the
q-expansion of the Hamming theta polynomial has coefficients
`hammingThetaConvolutionCoeff`.
-/
theorem splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff_of_duplication
    (hTheta2_sq : forall tau : UpperHalfPlane,
      (Θ₂ tau) ^ 2 = (2 : Complex) * Θ₂ (twoTau tau) * Θ₃ (twoTau tau))
    (hTheta4_sq : forall tau : UpperHalfPlane,
      (Θ₄ tau) ^ 2 = (Θ₃ (twoTau tau)) ^ 2 - (Θ₂ (twoTau tau)) ^ 2)
    (hHamming_qExpansion : forall n : Nat,
      PowerSeries.coeff n (ModularFormClass.qExpansion (1 : Real)
        hammingThetaConstantPolynomial) =
        (hammingThetaConvolutionCoeff n : Complex))
    (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex) := by
  have hfun :
      hammingThetaConstantPolynomial = SpherePacking.ModularForms.thetaE4 := by
    funext tau
    exact hammingThetaConstantPolynomial_eq_thetaE4_of_duplication
      hTheta2_sq hTheta4_sq tau
  calc
    PowerSeries.coeff n splThetaE4Series =
        PowerSeries.coeff n (ModularFormClass.qExpansion (1 : Real)
          hammingThetaConstantPolynomial) := by
      unfold splThetaE4Series
      rw [hfun]
    _ = (hammingThetaConvolutionCoeff n : Complex) := hHamming_qExpansion n

/-- Full theta-series identity from the precise analytic bridge ingredients. -/
theorem thetaSeries_eq_e4Series_of_duplication
    (hTheta2_sq : forall tau : UpperHalfPlane,
      (Θ₂ tau) ^ 2 = (2 : Complex) * Θ₂ (twoTau tau) * Θ₃ (twoTau tau))
    (hTheta4_sq : forall tau : UpperHalfPlane,
      (Θ₄ tau) ^ 2 = (Θ₃ (twoTau tau)) ^ 2 - (Θ₂ (twoTau tau)) ^ 2)
    (hHamming_qExpansion : forall n : Nat,
      PowerSeries.coeff n (ModularFormClass.qExpansion (1 : Real)
        hammingThetaConstantPolynomial) =
        (hammingThetaConvolutionCoeff n : Complex)) :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series :=
  thetaSeries_eq_e4Series_of_spl_theta_coeff_bridge
    (splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff_of_duplication
      hTheta2_sq hTheta4_sq hHamming_qExpansion)

/-- Coefficient formula from the precise analytic bridge ingredients. -/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_duplication
    (hTheta2_sq : forall tau : UpperHalfPlane,
      (Θ₂ tau) ^ 2 = (2 : Complex) * Θ₂ (twoTau tau) * Θ₃ (twoTau tau))
    (hTheta4_sq : forall tau : UpperHalfPlane,
      (Θ₄ tau) ^ 2 = (Θ₃ (twoTau tau)) ^ 2 - (Θ₂ (twoTau tau)) ^ 2)
    (hHamming_qExpansion : forall n : Nat,
      PowerSeries.coeff n (ModularFormClass.qExpansion (1 : Real)
        hammingThetaConstantPolynomial) =
        (hammingThetaConvolutionCoeff n : Complex))
    (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n :=
  hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq
    (thetaSeries_eq_e4Series_of_duplication hTheta2_sq hTheta4_sq
      hHamming_qExpansion) n

/-! ## SPL bridge target -/

/--
The E8 representation number formula: the Hamming Construction A
convolution coefficient equals the standard Eisenstein E₄ coefficient.

This was the single remaining sorry in the SPL–Construction A bridge; it is
now closed by reusing `hammingThetaConvolutionCoeff_eq_e4Coeff` from
`E8ThetaCoeffGapAristotle.lean`.

From `thetaE8_MF_eq_E4` (proved in `E8ThetaDim8MF.lean`) we know the
analytic E8 theta series equals E₄ as a weight-4 modular form.
The remaining gap is connecting the *analytic* theta series
(defined over SPL's `E8Lattice`) to the *combinatorial* Construction A
shell counts (defined over the project's `e8IntLattice`).

**Proof route** (two independent sub-lemmas):

1. **Theta q-expansion coefficient identification** — adapt SPL's
   `qExpansion_coeff_two_thetaSeries_eq_thetaCoeff` from 24 to 8
   dimensions and from coefficient 2 to all coefficients.

2. **Lattice isometry** — establish a norm-preserving bijection between
   SPL's `E8Lattice` (D₈⁺ half-integer model) and the project's
   `e8IntLattice` (Construction A over the extended Hamming code),
   using the Gram-matrix congruence from `E8SpherePackingImported.lean`.
-/
lemma e8_repr_number_eq_hammingConv (n : ℕ) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n :=
  -- The all-`n` representation-number formula is already established
  -- sorry-free in `E8ThetaCoeffGapAristotle.lean` via the rank-8 theta
  -- modular form `thetaE8_MF` (`thetaE8_MF_eq_E4`) and the q-expansion /
  -- shell-count bridge in `E8ThetaMFBridgeAristotle.lean`.  This closes the
  -- SPL/Hamming coefficient bridge by reusing that result.
  hammingThetaConvolutionCoeff_eq_e4Coeff n

theorem splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex) := by
  rw [splThetaE4Series_coeff_eq_local_e4, e8_repr_number_eq_hammingConv]
  by_cases hn : n = 0 <;> simp [hn]

/--
Closing theorem from the SPL coefficient bridge.

This theorem should become sorry-free as soon as
`splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff` is proved.
-/
theorem thetaSeries_eq_e4Series_from_spl_theta_coeff_bridge :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series :=
  thetaSeries_eq_e4Series_of_spl_theta_coeff_bridge
    splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff

/--
The all-coefficient divisor-sum formula follows from the SPL coefficient
bridge through the series equality.
-/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_from_spl_bridge (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n :=
  hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq
    thetaSeries_eq_e4Series_from_spl_theta_coeff_bridge n

end E8ThetaSPLBridge
end PhysicsSM.Coding
