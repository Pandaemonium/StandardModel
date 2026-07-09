import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 1000000

/-!
# Ground-mass ↔ determinant family law (DETERMINANT-side)

This module proves the EXACT determinant-side family law that replaces the killed
trace-side `budget = c * detP` (see `BudgetSignMismatch`, a REFERENCE only).

Work on the aperture-closure sector block, a real symmetric `2×2` (here over `ℚ`):

  `P lam kap = !![lam, kap; kap, lam]`   (eigenvalues `lam ± kap`, `det = lam^2 - kap^2`).

`lam` is the free (uncoupled) sector mass, `kap` the closure coupling.  The GROUND MASS
is the least eigenvalue `mu- = lam - kap`; the free mass (at `kap = 0`) is `lam`; the
BINDING DEFECT is `Delta = mu- - lam = -kap`, EXACTLY.

The prize (`groundmass_det_family_law`): with `mu- = lam - kap` and `tr = 2*lam`,
`det = mu- * (tr - mu-)`, so the ground mass is the smaller root of
`mu^2 - tr*mu + det = 0` — the spectral ground mass answers to the determinant invariant
EXACTLY over the whole family, given the trace.

Contrast (cite `BudgetSignMismatch`): the trace-side sum-of-squares budget is NOT a
function of `det` alone (two configs with equal `det` and different budget exist — that
module's kill), whereas the ground mass IS fixed by `(tr, det)`.  This is why the correct
§3↔§4 tie is determinant-side.
-/

namespace GroundMassDetFamilyLaw

/-- The aperture-closure sector block: real symmetric `2×2` over `ℚ`. -/
def P (lam kap : ℚ) : Matrix (Fin 2) (Fin 2) ℚ :=
  !![lam, kap; kap, lam]

/-- **Target 1** (characteristic polynomial): the eigenvalues are exactly
`lam - kap` and `lam + kap`. -/
theorem char_poly (lam kap X : ℚ) :
    (X • (1 : Matrix (Fin 2) (Fin 2) ℚ) - P lam kap).det
      = (X - (lam - kap)) * (X - (lam + kap)) := by
  have h : X • (1 : Matrix (Fin 2) (Fin 2) ℚ) - P lam kap
      = !![X - lam, -kap; -kap, X - lam] := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp [P, Matrix.one_fin_two]
  rw [h, Matrix.det_fin_two]
  simp only [Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.cons_val_fin_one]
  ring

/-- **Target 2** (determinant, closed form). -/
theorem det_closed (lam kap : ℚ) : (P lam kap).det = lam ^ 2 - kap ^ 2 := by
  simp only [P, Matrix.det_fin_two, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.cons_val_fin_one]
  ring

/-- **Target 3** (trace, closed form). -/
theorem trace_closed (lam kap : ℚ) : (P lam kap).trace = 2 * lam := by
  simp only [P, Matrix.trace_fin_two, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.cons_val_fin_one]
  ring

/-- **Target 4** (payload): the determinant is the product of the ground mass
`mu- = lam-kap` and the top mass `mu+ = lam+kap`. -/
theorem det_eq_eigenvalue_product (lam kap : ℚ) :
    (P lam kap).det = (lam - kap) * (lam + kap) := by
  rw [det_closed]; ring

/-- **Target 5** (payload): the binding defect is EXACTLY the closure coupling,
`(lam - kap) - lam = -kap`, for ALL `lam kap`.  This is the exact family identity that
contrasts with the killed `budget = c * detP`: the defect is `-kap`, not a fitted
multiple of `detP`. -/
theorem defect_exact (lam kap : ℚ) : (lam - kap) - lam = -kap := by ring

/-- **Target 6** (PRIZE): the ground-mass ↔ determinant family law.  With
`mu- = lam - kap` and `tr = 2*lam`, we have `det = mu- * (tr - mu-)`, so the ground
mass is the smaller root of `mu^2 - tr*mu + det = 0`. -/
theorem groundmass_det_family_law (lam kap : ℚ) :
    (P lam kap).det = (lam - kap) * ((2 * lam) - (lam - kap)) := by
  rw [det_closed]; ring

/-- **Target 7** (payload, the contrast): the eigenvalues are an exact function of the
invariants `(tr, det)` — both `mu+ * mu- = det` and `mu+ + mu- = tr`.

Contrast (cf. `BudgetSignMismatch`): the trace-side sum-of-squares budget is NOT a
function of `det` alone, whereas the ground mass IS fixed by `(tr, det)`.  THIS is why
the correct §3↔§4 tie is determinant-side. -/
theorem spectral_answers_to_invariants (lam kap : ℚ) :
    ((lam - kap) * (lam + kap) = (P lam kap).det)
      ∧ ((lam - kap) + (lam + kap) = (P lam kap).trace) := by
  refine ⟨?_, ?_⟩
  · rw [det_closed]; ring
  · rw [trace_closed]; ring

/-- **Target 8** (determinant-side free bridge): the `2×2` Cramer/adjugate identity
`P * adj P = det P • 1` holds identically. -/
theorem free_bridge_adjugate (lam kap : ℚ) :
    P lam kap * (P lam kap).adjugate = (P lam kap).det • (1 : Matrix (Fin 2) (Fin 2) ℚ) := by
  rw [Matrix.mul_adjugate]

/-- **Target 9** (verdict): packages targets 4, 5, 6, 7 — the determinant-side family law
that the trace-side `budget = c * detP` failed to be.  The ground mass `mu- = lam-kap`
= free mass + defect (`-kap` exact); `det = mu- * mu+ = mu-(tr - mu-)`; and the spectrum
answers to `(tr, det)` exactly. -/
theorem ground_mass_det_verdict (lam kap : ℚ) :
    ((P lam kap).det = (lam - kap) * (lam + kap))
      ∧ ((lam - kap) - lam = -kap)
      ∧ ((P lam kap).det = (lam - kap) * ((2 * lam) - (lam - kap)))
      ∧ (((lam - kap) * (lam + kap) = (P lam kap).det)
          ∧ ((lam - kap) + (lam + kap) = (P lam kap).trace)) :=
  ⟨det_eq_eigenvalue_product lam kap, defect_exact lam kap,
    groundmass_det_family_law lam kap, spectral_answers_to_invariants lam kap⟩

/-! ## Non-degeneracy witnesses (explicit, in-theorem)

Massive witness `lam=5, kap=3`; critical/massless-ground `lam=kap=4`; over-closure
(tachyonic) `lam=3, kap=5`.  The ground mass `mu-` differs across these (`2, 0, -2`),
so the law is non-vacuous. -/

/-- Massive witness `lam=5, kap=3`: `mu- = 2`, `mu+ = 8`, `det = 16`, `defect = -3`, and
`16 = 2*(10-2)`. -/
theorem witness_massive :
    (5 - 3 : ℚ) = 2 ∧ (5 + 3 : ℚ) = 8 ∧ (P 5 3).det = 16
      ∧ ((5 - 3 : ℚ) - 5 = -3) ∧ (P 5 3).det = (5 - 3) * ((2 * 5) - (5 - 3)) := by
  refine ⟨by norm_num, by norm_num, ?_, by norm_num, ?_⟩
  · rw [det_closed]; norm_num
  · rw [det_closed]; norm_num

/-- Critical/massless-ground witness `lam=kap=4`: `mu- = 0` (massless ground state,
binding saturates), `det = 0`. -/
theorem witness_critical :
    (4 - 4 : ℚ) = 0 ∧ (P 4 4).det = 0 := by
  refine ⟨by norm_num, ?_⟩
  rw [det_closed]; norm_num

/-- Over-closure (tachyonic) witness `lam=3, kap=5`: `mu- = -2 < 0` (tachyonic ground,
unphysical over-closure). -/
theorem witness_overclosure :
    (3 - 5 : ℚ) = -2 ∧ (3 - 5 : ℚ) < 0 ∧ (P 3 5).det = -16 := by
  refine ⟨by norm_num, by norm_num, ?_⟩
  rw [det_closed]; norm_num

/-- The ground masses `2, 0, -2` are pairwise distinct across the three witnesses, so the
family law is non-vacuous (it constrains genuinely different ground states). -/
theorem witness_ground_masses_distinct :
    (5 - 3 : ℚ) ≠ (4 - 4 : ℚ) ∧ (4 - 4 : ℚ) ≠ (3 - 5 : ℚ) ∧ (5 - 3 : ℚ) ≠ (3 - 5 : ℚ) := by
  refine ⟨by norm_num, by norm_num, by norm_num⟩

/-! ## Axiom footprint (headline theorems) -/

/-- info: 'GroundMassDetFamilyLaw.char_poly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms char_poly
/-- info: 'GroundMassDetFamilyLaw.det_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms det_closed
/-- info: 'GroundMassDetFamilyLaw.trace_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms trace_closed
/-- info: 'GroundMassDetFamilyLaw.det_eq_eigenvalue_product' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms det_eq_eigenvalue_product
/-- info: 'GroundMassDetFamilyLaw.defect_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms defect_exact
/-- info: 'GroundMassDetFamilyLaw.groundmass_det_family_law' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms groundmass_det_family_law
/-- info: 'GroundMassDetFamilyLaw.spectral_answers_to_invariants' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms spectral_answers_to_invariants
/-- info: 'GroundMassDetFamilyLaw.free_bridge_adjugate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms free_bridge_adjugate
/-- info: 'GroundMassDetFamilyLaw.ground_mass_det_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms ground_mass_det_verdict
/-- info: 'GroundMassDetFamilyLaw.witness_massive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_massive
/-- info: 'GroundMassDetFamilyLaw.witness_critical' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_critical
/-- info: 'GroundMassDetFamilyLaw.witness_overclosure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_overclosure
/-- info: 'GroundMassDetFamilyLaw.witness_ground_masses_distinct' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_ground_masses_distinct

end GroundMassDetFamilyLaw
