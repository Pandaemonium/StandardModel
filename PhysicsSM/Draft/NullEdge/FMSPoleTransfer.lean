import Mathlib

/-!
# Conditional finite FMS pole transfer

This module isolates the finite spectral step after an exact
Fröhlich-Morchio-Strocchi observable expansion.  The result is intentionally
conditional: the leading field must overlap a simple spectral atom, and the
composite remainder must vanish in that atom.  A one-channel cancellation
witness proves that remainder control is necessary.

Physics scope: finite Kallen-Lehmann algebra only.  No continuum pole, LSZ
statement, perturbative dominance, or observed Higgs/vector mass is claimed.

Provenance: theorem design informed by the FMS mechanism and the finite
spectral-measure API used in this project.  The proof is a clean-room finite
complex-analysis formalization; no external code is copied.
-/

open scoped BigOperators ComplexConjugate
open Filter Matrix Complex Set

set_option relaxedAutoImplicit false
set_option autoImplicit false
set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace PhysicsSM.Draft.NullEdge.FMSPoleTransfer

noncomputable section

/-- Squared overlap carried by one finite spectral channel. -/
def weight {m : Nat} (v : Fin m -> Complex) (i : Fin m) : Real :=
  Complex.normSq (v i)

/-- Finite composite observable vector: leading field plus remainder. -/
def composite {m : Nat} (c : Complex)
    (elementary remainder : Fin m -> Complex) : Fin m -> Complex :=
  c • elementary + remainder

/-- Finite diagonal Kallen-Lehmann sum. -/
def klSum {m : Nat} (mass : Fin m -> Real)
    (v : Fin m -> Complex) (z : Complex) : Complex :=
  ∑ i, (weight v i : Complex) / (z - (mass i : Complex))

/-- If the remainder misses channel `k`, the composite overlap there is the
leading overlap scaled by `c`. -/
theorem composite_at_of_remainder_zero {m : Nat}
    (c : Complex) (elementary remainder : Fin m -> Complex) (k : Fin m)
    (hRemainder : remainder k = 0) :
    composite c elementary remainder k = c * elementary k := by
  unfold composite
  aesop

/-- Exact spectral-weight transfer at a channel missed by the remainder. -/
theorem weight_composite_at_of_remainder_zero {m : Nat}
    (c : Complex) (elementary remainder : Fin m -> Complex) (k : Fin m)
    (hRemainder : remainder k = 0) :
    weight (composite c elementary remainder) k =
      Complex.normSq c * weight elementary k := by
  simp_all +decide [composite, weight]

/-- A nonzero leading coefficient preserves positive visibility of the target
spectral atom exactly when the remainder misses that atom. -/
theorem weight_composite_pos_iff {m : Nat}
    (c : Complex) (elementary remainder : Fin m -> Complex) (k : Fin m)
    (hc : c ≠ 0) (hRemainder : remainder k = 0) :
    0 < weight (composite c elementary remainder) k <->
      0 < weight elementary k := by
  rw [weight_composite_at_of_remainder_zero c elementary remainder k hRemainder]
  exact iff_of_eq (by
    rw [mul_pos_iff_of_pos_left (Complex.normSq_pos.mpr hc)])

/-- Analytic residue of a finite diagonal Kallen-Lehmann sum at a simple
spectral channel. -/
theorem tendsto_residue_eq_weight {m : Nat}
    (mass : Fin m -> Real) (v : Fin m -> Complex) (k : Fin m)
    (hSimple : ∀ i, i ≠ k -> mass i ≠ mass k) :
    Tendsto (fun z : Complex => (z - (mass k : Complex)) * klSum mass v z)
      (nhdsWithin (mass k : Complex) ({(mass k : Complex)} : Set Complex)ᶜ)
      (nhds (weight v k : Complex)) := by
  have h_term : ∀ i ≠ k, Filter.Tendsto
      (fun z : Complex => (z - (mass k : Complex)) * (weight v i : Complex) /
        (z - (mass i : Complex)))
      (nhdsWithin (mass k : Complex) ({(mass k : Complex)} : Set Complex)ᶜ)
      (nhds 0) := by
    intro i hi
    convert Filter.Tendsto.div
      (Continuous.continuousWithinAt
        (show Continuous (fun z : Complex =>
          (z - (mass k : Complex)) * (weight v i : Complex)) by continuity))
      (Continuous.continuousWithinAt
        (show Continuous (fun z : Complex => z - (mass i : Complex)) by continuity))
      _ using 2 <;> simp +decide [sub_eq_iff_eq_add, *]
    exact Ne.symm (hSimple i hi)
  have h_limit : Filter.Tendsto
      (fun z : Complex => ∑ i ∈ Finset.univ.erase k,
        (z - (mass k : Complex)) * (weight v i : Complex) /
          (z - (mass i : Complex)))
      (nhdsWithin (mass k : Complex) ({(mass k : Complex)} : Set Complex)ᶜ)
      (nhds 0) := by
    simpa only [Finset.sum_const_zero] using tendsto_finset_sum _ fun i hi =>
      h_term i (Finset.ne_of_mem_erase hi)
  simp_all +decide [mul_div_assoc, Finset.mul_sum _ _ _, klSum]
  simpa using h_limit.add_const (weight v k : Complex) |>
    Filter.Tendsto.congr' (by
      filter_upwards [self_mem_nhdsWithin] with z hz
      rw [mul_div_cancel₀ _ (sub_ne_zero_of_ne hz)]
      ring)

/-- Conditional finite FMS pole transfer.  At a simple atom untouched by the
remainder, the composite residue is exactly the leading residue multiplied by
the squared magnitude of the FMS coefficient. -/
theorem tendsto_composite_residue {m : Nat}
    (mass : Fin m -> Real) (c : Complex)
    (elementary remainder : Fin m -> Complex) (k : Fin m)
    (hSimple : ∀ i, i ≠ k -> mass i ≠ mass k)
    (hRemainder : remainder k = 0) :
    Tendsto
      (fun z : Complex =>
        (z - (mass k : Complex)) *
          klSum mass (composite c elementary remainder) z)
      (nhdsWithin (mass k : Complex) ({(mass k : Complex)} : Set Complex)ᶜ)
      (nhds ((Complex.normSq c * weight elementary k : Real) : Complex)) := by
  convert tendsto_residue_eq_weight mass
    (composite c elementary remainder) k hSimple using 1
  rw [weight_composite_at_of_remainder_zero c elementary remainder k hRemainder]

/-- Remainder control is essential: even with nonzero leading coefficient and
positive elementary weight, a remainder can cancel the target atom exactly. -/
theorem remainder_can_cancel_target_atom :
    let elementary : Fin 1 -> Complex := fun _ => 1
    let remainder : Fin 1 -> Complex := fun _ => -1
    let k : Fin 1 := 0
    weight elementary k = 1 ∧
      (1 : Complex) ≠ 0 ∧
      weight (composite 1 elementary remainder) k = 0 := by
  unfold weight composite
  norm_num

end

end PhysicsSM.Draft.NullEdge.FMSPoleTransfer

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FMSPoleTransfer.tendsto_residue_eq_weight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FMSPoleTransfer.tendsto_residue_eq_weight

/-- info: 'PhysicsSM.Draft.NullEdge.FMSPoleTransfer.tendsto_composite_residue' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FMSPoleTransfer.tendsto_composite_residue

/-- info: 'PhysicsSM.Draft.NullEdge.FMSPoleTransfer.remainder_can_cancel_target_atom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FMSPoleTransfer.remainder_can_cancel_target_atom
