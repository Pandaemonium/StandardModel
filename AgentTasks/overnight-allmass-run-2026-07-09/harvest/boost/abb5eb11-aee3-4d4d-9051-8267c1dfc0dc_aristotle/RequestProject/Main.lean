import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Mass is boost-invariant: an explicit rational Lorentz boost preserves `eta` and `det P = m²`

This file grounds the boost-invariance of the "Plücker mass" (`mass = det P`) in a finite,
purely rational avatar.  We exhibit an EXPLICIT RATIONAL Lorentz boost — a genuine element of
`SO(1,1)` with rational entries, obtained from the Pythagorean rapidity `β = 3/5 ⇒ γ = 5/4`,
`γβ = 3/4` — and show:

* it preserves the `(t,x)` Minkowski metric `eta2` (`Lᵀ * eta2 * L = eta2`), hence `det L = 1`;
* it preserves the Minkowski interval `E² - k²` of any 2-momentum;
* the little-group spinor determinant `det P(E,k) = E² - k²` (the invariant mass squared) is
  UNCHANGED under the boost;
* by contrast, an individual 4-vector component (a naive "minor") DOES change under the boost.

So "mass = det P" is genuinely frame-independent *because* it is the determinant (the little-group
invariant), confirming the audit's convention point.

**Honest scope.** This is a `1+1`D rational boost avatar (`SO(1,1)`), tied to the `(+,-,-,-)`
convention; it is not the full `SO(1,3)`.
-/

namespace RationalBoostInvariance

/-- The `(t,x)` Minkowski metric `eta = diag(1, -1)` in the `(+,-)` convention. -/
def eta2 : Matrix (Fin 2) (Fin 2) ℚ := !![1, 0; 0, -1]

/-- The explicit rational Lorentz boost with `β = 3/5`, `γ = 5/4`, `γβ = 3/4`
(symmetric boost in the `(t,x)` plane; `γ² - (γβ)² = 25/16 - 9/16 = 1`). -/
def L : Matrix (Fin 2) (Fin 2) ℚ := !![5/4, 3/4; 3/4, 5/4]

/-- The Minkowski square pairing on 2-momenta: `u ⬝ v = u₀ v₀ - u₁ v₁`. -/
def mdot2 (u v : Fin 2 → ℚ) : ℚ := u 0 * v 0 - u 1 * v 1

/-- The little-group Hermitian (here real) matrix `P(E,k) = diag(E+k, E-k)`,
the `(t,z)`-restricted `p.sigma`; its determinant is the invariant mass squared. -/
def Pmat (E k : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![E + k, 0; 0, E - k]

/-- Explicit component form of the boosted 2-momentum. -/
theorem mulVec_comp (p : Fin 2 → ℚ) :
    L.mulVec p = ![5/4 * p 0 + 3/4 * p 1, 3/4 * p 0 + 5/4 * p 1] := by
  ext i
  fin_cases i <;>
    simp [L, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- The spinor determinant is exactly the invariant mass squared `E² - k²`. -/
theorem det_Pmat (E k : ℚ) : (Pmat E k).det = E ^ 2 - k ^ 2 := by
  simp [Pmat, Matrix.det_fin_two]
  ring

/-! ## Target 1: `L` is a Lorentz boost -/

/-- `L` preserves the Minkowski metric: `Lᵀ * eta2 * L = eta2`. -/
theorem boost_on_shell : L.transpose * eta2 * L = eta2 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [L, eta2, Matrix.mul_apply, Fin.sum_univ_two, Matrix.transpose_apply] <;> norm_num

/-- A proper boost: `det L = 1`. -/
theorem det_boost : L.det = 1 := by
  simp [L, Matrix.det_fin_two]; norm_num

/-! ## Target 2: the boost preserves the Minkowski interval -/

/-- For any 2-momentum `p`, the Minkowski square `E² - k²` is invariant under `L`. -/
theorem boost_preserves_interval (p : Fin 2 → ℚ) :
    mdot2 (L.mulVec p) (L.mulVec p) = mdot2 p p := by
  rw [mulVec_comp]
  simp only [mdot2, Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-! ## Target 3: the spinor determinant (mass²) is boost-invariant -/

/-- The payload: boosting `p = (E,k)` to `p' = L.mulVec p`, the spinor determinant
`det P(E',k') = det P(E,k) = E² - k² = m²` is unchanged. -/
theorem mass_boost_invariant (E k : ℚ) :
    (Pmat ((L.mulVec ![E, k]) 0) ((L.mulVec ![E, k]) 1)).det = (Pmat E k).det := by
  rw [mulVec_comp]
  simp only [det_Pmat, Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-! ## Target 4: an individual component is NOT boost-invariant -/

/-- The audit's contrast: a single 4-vector component (here `E` for `p = (1,0)`) changes under
the boost, `(L.mulVec (1,0)) 0 = 5/4 ≠ 1`, unlike the invariant determinant. -/
theorem frame_dependence_control :
    (L.mulVec (![1, 0] : Fin 2 → ℚ)) 0 ≠ (![1, 0] : Fin 2 → ℚ) 0 := by
  rw [mulVec_comp]
  norm_num

/-! ## Mandatory non-degeneracy witnesses -/

/-- The boost sends `(1,0)` to `(5/4, 3/4)` explicitly. -/
theorem boost_of_rest : L.mulVec (![1, 0] : Fin 2 → ℚ) = ![5/4, 3/4] := by
  rw [mulVec_comp]; norm_num

/-- Massive witness: `p = (5,3)` has `m² = 16`, and its boost still has `E'² - k'² = 16`. -/
theorem massive_witness :
    mdot2 (![5, 3] : Fin 2 → ℚ) (![5, 3] : Fin 2 → ℚ) = 16 ∧
    mdot2 (L.mulVec (![5, 3] : Fin 2 → ℚ)) (L.mulVec (![5, 3] : Fin 2 → ℚ)) = 16 := by
  refine ⟨by simp [mdot2]; norm_num, ?_⟩
  rw [mulVec_comp]; simp [mdot2]; norm_num

/-- Null witness: `p = (1,1)` stays null (`E'² - k'² = 0`). -/
theorem null_witness :
    mdot2 (![1, 1] : Fin 2 → ℚ) (![1, 1] : Fin 2 → ℚ) = 0 ∧
    mdot2 (L.mulVec (![1, 1] : Fin 2 → ℚ)) (L.mulVec (![1, 1] : Fin 2 → ℚ)) = 0 := by
  refine ⟨by simp [mdot2], ?_⟩
  rw [mulVec_comp]; simp [mdot2]; norm_num

/-! ## Target 5: the packaged verdict -/

/-- Package: the explicit rational Lorentz boost `L` (`β = 3/5`)
* preserves the metric `eta2` (`Lᵀ * eta2 * L = eta2`) and is proper (`det L = 1`);
* preserves the Minkowski interval of every 2-momentum;
* leaves the spinor determinant `mass² = det P = E² - k²` invariant;
* while individual momentum components change under it.

Hence "mass = det P" is genuinely frame-independent BECAUSE it is the determinant (the
little-group invariant). -/
theorem boost_invariance_verdict :
    (L.transpose * eta2 * L = eta2) ∧
    (L.det = 1) ∧
    (∀ p : Fin 2 → ℚ, mdot2 (L.mulVec p) (L.mulVec p) = mdot2 p p) ∧
    (∀ E k : ℚ,
      (Pmat ((L.mulVec ![E, k]) 0) ((L.mulVec ![E, k]) 1)).det = (Pmat E k).det) ∧
    (∀ E k : ℚ, (Pmat E k).det = E ^ 2 - k ^ 2) ∧
    ((L.mulVec (![1, 0] : Fin 2 → ℚ)) 0 ≠ (![1, 0] : Fin 2 → ℚ) 0) :=
  ⟨boost_on_shell, det_boost, boost_preserves_interval, mass_boost_invariant,
    det_Pmat, frame_dependence_control⟩

/-! ## Axiom footprint: exactly `[propext, Classical.choice, Quot.sound]` on every headline. -/

/-- info: 'RationalBoostInvariance.boost_on_shell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms boost_on_shell
/-- info: 'RationalBoostInvariance.det_boost' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms det_boost
/-- info: 'RationalBoostInvariance.boost_preserves_interval' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms boost_preserves_interval
/-- info: 'RationalBoostInvariance.mass_boost_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms mass_boost_invariant
/-- info: 'RationalBoostInvariance.frame_dependence_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms frame_dependence_control
/-- info: 'RationalBoostInvariance.boost_invariance_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms boost_invariance_verdict

end RationalBoostInvariance
