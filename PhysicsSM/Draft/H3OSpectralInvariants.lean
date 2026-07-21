import PhysicsSM.Draft.H3OCharacteristicEquation
import PhysicsSM.Draft.CubicRealSpectrum
import Mathlib

/-!
# Spectral invariants of `h3(O)`: scale covariance and dimensionless ratios (P7)

**Status: DRAFT. Strictly structural - no numeric mass claimed (plan P7
discipline).**

Plan P7 steps 2-3 (`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`),
building on the landed cubic characteristic equation
(`h3o_characteristic_equation`: `X^3 = tr(X) X^2 - sigma(X) X + det(X) 1`).

Contents:

1. **Scale covariance (kernel):** under `X -> t • X` the invariant triple
   transforms with weights `(1, 2, 3)`:
   `trace (t • X) = t * trace X`, `sigmaH3O (t • X) = t^2 * sigmaH3O X`,
   `detH3O (t • X) = t^3 * detH3O X`. These are the "mass-DIMENSION" laws of
   the three flavor invariants.
2. **Dimensionless ratio invariants:** `ratioSigma = sigma^3 / det^2` and
   `ratioTrace = trace^3 / det` are invariant under `X -> t • X` (`t != 0`) -
   the structural statement behind "the spectrum determines mass RATIOS, not
   masses". `[interp]` is confined to that sentence; the theorems are pure
   algebra.
3. **Vieta bridge:** IF the characteristic cubic of `X` has real root multiset
   `{x, y, z}` (the real-spectrum hypothesis - the J4 Aristotle job
   `cubic-real-spectrum-20260718` proves it from `0 <= discr`), THEN
   `x + y + z = trace X`, `x*y + x*z + y*z = sigmaH3O X`, `x*y*z = detH3O X`:
   the invariant triple IS the elementary-symmetric data of the three
   eigenvalues. (Stated conditionally on the root multiset; no discriminant
   claim made here.)

Provenance: elementary symmetric-function algebra; Freudenthal invariants per
the landed module (Baez 2002 sec 3.4 / DVT lineage, clean-room). Conventions:
`H3O` field layout and XOR octonions per `PhysicsSM.Algebra.Jordan.H3O`.
-/

noncomputable section

namespace PhysicsSM.Draft.H3OSpectralInvariants

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Draft.H3OCharacteristicEquation
open Polynomial

/-! ## 1. Scale covariance -/

/-- `trace` has scale weight 1. -/
theorem trace_smul (t : ℝ) (X : H3O) : trace (t • X) = t * trace X := by
  simp [trace]
  ring

/-- `sigmaH3O` has scale weight 2. -/
theorem sigma_smul (t : ℝ) (X : H3O) :
    sigmaH3O (t • X) = t ^ 2 * sigmaH3O X := by
  unfold sigmaH3O
  simp [trace, jordanProduct, octonionInner]
  ring

/-- `detH3O` has scale weight 3 (the Freudenthal norm is cubic). -/
theorem det_smul (t : ℝ) (X : H3O) : detH3O (t • X) = t ^ 3 * detH3O X := by
  unfold detH3O
  simp [PhysicsSM.Algebra.Octonion.normSq]
  ring

/-! ## 2. Dimensionless ratio invariants -/

/-- The first dimensionless spectral ratio `sigma^3 / det^2` (weight
`6 - 6 = 0`). -/
def ratioSigma (X : H3O) : ℝ := (sigmaH3O X) ^ 3 / (detH3O X) ^ 2

/-- The second dimensionless spectral ratio `trace^3 / det` (weight
`3 - 3 = 0`). -/
def ratioTrace (X : H3O) : ℝ := (trace X) ^ 3 / detH3O X

/-- **`ratioSigma` is scale-invariant**: the structural "mass-ratio, not mass"
statement for the quadratic invariant. -/
theorem ratioSigma_smul (t : ℝ) (ht : t ≠ 0) (X : H3O) :
    ratioSigma (t • X) = ratioSigma X := by
  unfold ratioSigma
  rw [sigma_smul, det_smul]
  field_simp

/-- **`ratioTrace` is scale-invariant.** -/
theorem ratioTrace_smul (t : ℝ) (ht : t ≠ 0) (X : H3O) :
    ratioTrace (t • X) = ratioTrace X := by
  unfold ratioTrace
  rw [trace_smul, det_smul]
  field_simp

/-! ## 3. The Vieta bridge: invariants = elementary symmetric functions -/

/-- The characteristic cubic of `X`: `t^3 - tr t^2 + sigma t - det`. -/
def charCubic (X : H3O) : Cubic ℝ :=
  ⟨1, -(trace X), sigmaH3O X, -(detH3O X)⟩

/-- **Vieta 1:** if the characteristic cubic has real roots `{x, y, z}`, their
sum is the trace. -/
theorem trace_eq_root_sum (X : H3O) (x y z : ℝ)
    (h3 : (Cubic.map (RingHom.id ℝ) (charCubic X)).roots = {x, y, z}) :
    trace X = x + y + z := by
  have hb := Cubic.b_eq_three_roots (P := charCubic X)
    (φ := RingHom.id ℝ) one_ne_zero h3
  simp [charCubic] at hb
  linarith

/-- **Vieta 2:** the pairwise-product sum is `sigmaH3O`. -/
theorem sigma_eq_root_pairs (X : H3O) (x y z : ℝ)
    (h3 : (Cubic.map (RingHom.id ℝ) (charCubic X)).roots = {x, y, z}) :
    sigmaH3O X = x * y + x * z + y * z := by
  have hc := Cubic.c_eq_three_roots (P := charCubic X)
    (φ := RingHom.id ℝ) one_ne_zero h3
  simp [charCubic] at hc
  linarith

/-- **Vieta 3:** the root product is `detH3O`. -/
theorem det_eq_root_product (X : H3O) (x y z : ℝ)
    (h3 : (Cubic.map (RingHom.id ℝ) (charCubic X)).roots = {x, y, z}) :
    detH3O X = x * y * z := by
  have hd := Cubic.d_eq_three_roots (P := charCubic X)
    (φ := RingHom.id ℝ) one_ne_zero h3
  simp [charCubic] at hd
  linarith

/-! ## 4. The composed real-spectrum statement (J4 + Vieta) -/

/-- **`h3(O)` real spectrum (composed):** if the characteristic discriminant is
nonnegative, the element has three real eigenvalues whose elementary symmetric
functions are EXACTLY the Freudenthal invariants `(trace, sigma, det)`. The
discriminant nonnegativity for Jordan-hermitian elements is the remaining
analytic step, displayed here as the hypothesis (pre-registered next target -
NOT assumed proven). -/
theorem h3o_real_spectrum_of_discr_nonneg (X : H3O)
    (hd : 0 ≤ (charCubic X).discr) :
    ∃ x y z : ℝ, trace X = x + y + z ∧ sigmaH3O X = x * y + x * z + y * z ∧
      detH3O X = x * y * z := by
  obtain ⟨x, y, z, h3⟩ :=
    CubicRealSpectrum.cubic_real_splits_of_discr_nonneg (charCubic X)
      one_ne_zero hd
  have hmap : Cubic.map (RingHom.id ℝ) (charCubic X) = charCubic X := by
    simp [Cubic.map]
  have h3' : (Cubic.map (RingHom.id ℝ) (charCubic X)).roots = {x, y, z} := by
    rw [hmap]; exact h3
  exact ⟨x, y, z, trace_eq_root_sum X x y z h3',
    sigma_eq_root_pairs X x y z h3', det_eq_root_product X x y z h3'⟩

end PhysicsSM.Draft.H3OSpectralInvariants

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.H3OSpectralInvariants.det_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.H3OSpectralInvariants.det_smul

/-- info: 'PhysicsSM.Draft.H3OSpectralInvariants.ratioSigma_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.H3OSpectralInvariants.ratioSigma_smul

/-- info: 'PhysicsSM.Draft.H3OSpectralInvariants.sigma_eq_root_pairs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.H3OSpectralInvariants.sigma_eq_root_pairs

/-- info: 'PhysicsSM.Draft.H3OSpectralInvariants.h3o_real_spectrum_of_discr_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.H3OSpectralInvariants.h3o_real_spectrum_of_discr_nonneg
