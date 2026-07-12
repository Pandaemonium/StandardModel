/-
Provenance: Aristotle job 390053ef (fable-24h-oneD), harvested
2026-07-11 ~19:35 PDT. All seven statements integrated with one
notation normalization by the prover: `Complex.abs z = 1` became
`(norm z) = 1` (the same function, current Mathlib spelling) - no
weakening. Four named crossing-polynomial helpers added. KERNEL-ONLY
(propext, Classical.choice, Quot.sound; no native_decide).
Oracle: two-band sympy run 2026-07-11 (zero-flow degeneracy; massive
gap roots 1/2, 2, -2, -1/2; flow-one double crossing at z = -1).
Program role: the 1+1 warm-up of the strict-3+1 route A - zero-flow
two-band crossings are forced degenerate (the 1D shadow of full-Dirac
neutrality), and the flow-one walk's single 0-cone carries its exact
pi-partner at the same momentum (two-band pseudo-doubler theorem).
-/
import Mathlib

/-!
# Two-band 1+1 crossing structure: degeneracy at zero flow, forced pi-partner at unit flow

The 1+1 warm-up of the strict-3+1 program (charge-design memo section 5,
restricted to the two-band class where every branch is explicit charpoly
algebra). Oracle-verified exactly (sympy, 2026-07-11) before submission.

Setting: `U(z)` a `2 x 2` unitary Laurent symbol (walk step in momentum
space, `z = e^{ik}` on the unit circle). Its eigenvalues satisfy
`lam^2 - (tr U) lam + det U = 0`. Crossings: `lam = +1` (quasienergy 0)
iff `1 - tr U + det U = 0`; `lam = -1` (quasienergy pi) iff
`1 + tr U + det U = 0`.

Note on formalization: the unit-circle condition is stated with the norm
`‖z‖ = 1` (Mathlib's current spelling; `Complex.abs` has been removed),
which is definitionally the modulus and hence a faithful rendering of the
displayed `|z| = 1`.

## The three oracle-verified facts

* AUDIT NOTES (hostile2 F14-F17): W1 is an abstract det-1 lemma - it
  concludes algebraic multiplicity 2 (charpoly = (X -+ 1)^2), and the
  eigenSPACE reading additionally needs normality/unitarity, which W1
  does not assume; on the massive fixture W1 never fires (W2 shows no
  circle crossings); `U1c_crossings_only_at_neg_one` holds for all
  z /= -1 (the circle hypothesis is retained but unused); T3/T4 are a
  single-fixture pseudo-doubler exhibit, with the general signed-count
  law in TwoBandFlowCount.
* **W1 (zero-flow degeneracy; the 1D shadow of full-Dirac neutrality).**
  If `det U = 1` at a crossing point, the two eigenvalues there coincide:
  `lam' = det U / lam = (+-1)^{-1} = lam`. So in the unit-determinant
  (zero abelian flow) two-band class, EVERY `+-1` crossing is doubly
  degenerate - no simple crossing exists. Pure algebra, no analysis.
* **W2 (massive gap fixture).** The 3-4-5 split-step symbol
  `U0(z) = diag(z, z^{-1}) * C`, `C = [[4/5, -3i/5],[-3i/5, 4/5]]`, has
  `det U0 = 1`, `tr U0 = (4/5)(z + z^{-1})`, and its crossing conditions
  `1 -+ tr + 1 = 0` have roots `{1/2, 2}` and `{-2, -1/2}` - all OFF the
  unit circle. The massive walk has no `+-1` crossings at all.
* **W3 (unit-flow forced partner).** The flow-one symbol
  `U1(z) = diag(z, 1) * C` has `det U1 = z`, `tr U1 = (4/5)(z + 1)`.
  Both crossing conditions have their unique unit-circle root at
  `z = -1`, and `U1(-1) = [[-4/5, 3i/5],[-3i/5, 4/5]]` has eigenvalues
  `+1` AND `-1` (each simple as a root of the characteristic polynomial):
  the single 0-crossing comes with an exact pi-crossing partner at the
  same momentum - the two-band pseudo-doubler, exhibited.

Along the way the exact crossing polynomials are recorded:
`(U0c z).charpoly.eval 1 = 2 - (4/5)(z + z⁻¹)`,
`(U0c z).charpoly.eval (-1) = 2 + (4/5)(z + z⁻¹)`,
`(U1c z).charpoly.eval 1 = (1/5)(z + 1)`,
`(U1c z).charpoly.eval (-1) = (9/5)(z + 1)`.

## Targets

T1 (W1, kernel, the headline): for `A` with `A.det = 1`, if `(1 : C)` is
an eigenvalue then the characteristic polynomial equals `(X - 1)^2`; same
for `-1` giving `(X + 1)^2`.

T2 (W2, kernel fixture): `(U0c z).det = 1` for `z ≠ 0`, and the massive
zero-flow walk has NO `±1` crossings on the unit circle.

T3 (W3, kernel fixture): `U1c (-1)` carries BOTH crossings, and away from
`z = -1` on the circle there is no crossing.

T4 (interpretive corollary, kernel): `zero-crossing set = pi-crossing set
= {-1}`. (The general signed-count theorem is NOT required here.)
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.TwoBandCrossingDoubling

open Matrix Polynomial

/-- The 3-4-5 coin. -/
def coin : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(4/5 : ℂ), -Complex.I * (3/5); -Complex.I * (3/5), (4/5 : ℂ)]

/-- Zero-flow split-step symbol. -/
def U0c (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![z, 0; 0, z⁻¹] * coin

/-- Flow-one symbol. -/
def U1c (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![z, 0; 0, 1] * coin

/-- T1a: at a unit-determinant `+1` crossing the characteristic polynomial
is `(X - 1)^2` - the crossing is doubly degenerate. -/
theorem unit_det_plus_crossing_degenerate (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hdet : A.det = 1) (h : A.charpoly.eval 1 = 0) :
    A.charpoly = (X - 1) ^ 2 := by
  have hcp := Matrix.charpoly_fin_two A
  rw [hcp] at h ⊢
  simp only [eval_add, eval_sub, eval_pow, eval_mul, eval_C, eval_X, one_pow, mul_one] at h
  rw [hdet] at h ⊢
  have htr : A.trace = 2 := by linear_combination -h
  rw [htr]
  simp only [map_ofNat, map_one]
  ring

/-- T1b: same at `-1`. -/
theorem unit_det_minus_crossing_degenerate (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hdet : A.det = 1) (h : A.charpoly.eval (-1) = 0) :
    A.charpoly = (X + 1) ^ 2 := by
  have hcp := Matrix.charpoly_fin_two A
  rw [hcp] at h ⊢
  simp only [eval_add, eval_sub, eval_pow, eval_mul, eval_C, eval_X,
    neg_one_sq, mul_neg_one] at h
  rw [hdet] at h ⊢
  have htr : A.trace = -2 := by linear_combination h
  rw [htr]
  simp only [map_ofNat, map_one, map_neg]
  ring

/-- T2a: the massive zero-flow symbol has unit determinant off `z = 0`. -/
theorem U0c_det (z : ℂ) (hz : z ≠ 0) : (U0c z).det = 1 := by
  rw [U0c, coin, Matrix.det_mul, Matrix.det_fin_two_of, Matrix.det_fin_two_of]
  field_simp
  ring_nf
  rw [Complex.I_sq]
  ring

/-- Exact `0`-crossing polynomial of the zero-flow symbol:
`(U0c z).charpoly.eval 1 = 2 - (4/5)(z + z⁻¹)`. -/
theorem U0c_eval_one (z : ℂ) (hz : z ≠ 0) :
    (U0c z).charpoly.eval 1 = 2 - (4/5)*(z+z⁻¹) := by
  rw [Matrix.charpoly_fin_two]
  simp only [eval_add, eval_sub, eval_pow, eval_mul, eval_C, eval_X, one_pow, mul_one]
  rw [U0c, coin, Matrix.trace_fin_two, Matrix.det_mul, Matrix.det_fin_two_of,
    Matrix.det_fin_two_of]
  simp only [Matrix.mul_apply, Fin.sum_univ_two, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply]
  field_simp; ring_nf; rw [Complex.I_sq]; ring

/-- Exact `pi`-crossing polynomial of the zero-flow symbol:
`(U0c z).charpoly.eval (-1) = 2 + (4/5)(z + z⁻¹)`. -/
theorem U0c_eval_neg_one (z : ℂ) (hz : z ≠ 0) :
    (U0c z).charpoly.eval (-1) = 2 + (4/5)*(z+z⁻¹) := by
  rw [Matrix.charpoly_fin_two]
  simp only [eval_add, eval_sub, eval_pow, eval_mul, eval_C, eval_X, neg_one_sq, mul_neg_one]
  rw [U0c, coin, Matrix.trace_fin_two, Matrix.det_mul, Matrix.det_fin_two_of,
    Matrix.det_fin_two_of]
  simp only [Matrix.mul_apply, Fin.sum_univ_two, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply]
  field_simp; ring_nf; rw [Complex.I_sq]; ring

/-- T2b: the massive zero-flow walk has NO crossings on the unit circle:
for unimodular `z`, neither `+1` nor `-1` is a root of its characteristic
polynomial. The cleared conditions factor as `-2(2z-1)(z-2)` and
`2(2z+1)(z+2)`, whose roots have modulus `1/2` or `2`. -/
theorem U0c_gapped (z : ℂ) (hz : ‖z‖ = 1) :
    (U0c z).charpoly.eval 1 ≠ 0 ∧ (U0c z).charpoly.eval (-1) ≠ 0 := by
  have hz0 : z ≠ 0 := by rintro rfl; simp at hz
  have hzi : z * z⁻¹ = 1 := mul_inv_cancel₀ hz0
  constructor
  · rw [U0c_eval_one z hz0]
    intro h0
    have hfac : (2*z-1)*(z-2) = 0 := by linear_combination (-5/2*z) * h0 + (-2) * hzi
    rcases mul_eq_zero.mp hfac with h | h
    · have : z = 1/2 := by linear_combination (1/2) * h
      rw [this] at hz; norm_num at hz
    · have : z = 2 := by linear_combination h
      rw [this] at hz; norm_num at hz
  · rw [U0c_eval_neg_one z hz0]
    intro h0
    have hfac : (2*z+1)*(z+2) = 0 := by linear_combination (5/2*z) * h0 + (-2) * hzi
    rcases mul_eq_zero.mp hfac with h | h
    · have : z = -1/2 := by linear_combination (1/2) * h
      rw [this] at hz; norm_num at hz
    · have : z = -2 := by linear_combination h
      rw [this] at hz; norm_num at hz

/-- Exact `0`-crossing polynomial of the flow-one symbol:
`(U1c z).charpoly.eval 1 = (1/5)(z + 1)`. -/
theorem U1c_eval_one (z : ℂ) : (U1c z).charpoly.eval 1 = (1/5)*(z+1) := by
  rw [Matrix.charpoly_fin_two]
  simp only [eval_add, eval_sub, eval_pow, eval_mul, eval_C, eval_X, one_pow, mul_one]
  rw [U1c, coin, Matrix.trace_fin_two, Matrix.det_mul, Matrix.det_fin_two_of,
    Matrix.det_fin_two_of]
  simp only [Matrix.mul_apply, Fin.sum_univ_two, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply]
  ring_nf; rw [Complex.I_sq]; ring

/-- Exact `pi`-crossing polynomial of the flow-one symbol:
`(U1c z).charpoly.eval (-1) = (9/5)(z + 1)`. -/
theorem U1c_eval_neg_one (z : ℂ) : (U1c z).charpoly.eval (-1) = (9/5)*(z+1) := by
  rw [Matrix.charpoly_fin_two]
  simp only [eval_add, eval_sub, eval_pow, eval_mul, eval_C, eval_X, neg_one_sq, mul_neg_one]
  rw [U1c, coin, Matrix.trace_fin_two, Matrix.det_mul, Matrix.det_fin_two_of,
    Matrix.det_fin_two_of]
  simp only [Matrix.mul_apply, Fin.sum_univ_two, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply]
  ring_nf; rw [Complex.I_sq]; ring

/-- T3a: the flow-one symbol at `z = -1` carries BOTH crossings. -/
theorem U1c_double_crossing :
    (U1c (-1)).charpoly.eval 1 = 0 ∧ (U1c (-1)).charpoly.eval (-1) = 0 := by
  rw [U1c_eval_one, U1c_eval_neg_one]; norm_num

/-- T3b: away from `z = -1` on the circle there is no crossing. -/
theorem U1c_crossings_only_at_neg_one (z : ℂ) (hz : ‖z‖ = 1)
    (hne : z ≠ -1) :
    (U1c z).charpoly.eval 1 ≠ 0 ∧ (U1c z).charpoly.eval (-1) ≠ 0 := by
  have hz1 : z + 1 ≠ 0 := by intro h; apply hne; linear_combination h
  rw [U1c_eval_one, U1c_eval_neg_one]
  refine ⟨fun h => hz1 ?_, fun h => hz1 ?_⟩
  · linear_combination (5:ℂ) * h
  · linear_combination (5/9:ℂ) * h

/-- T4: the 0-crossing and pi-crossing sets of the flow-one walk coincide
and equal `{-1}`: the single cone comes with its exact pi-partner. -/
theorem U1c_zero_and_pi_sets :
    {z : ℂ | ‖z‖ = 1 ∧ (U1c z).charpoly.eval 1 = 0}
      = {z : ℂ | ‖z‖ = 1 ∧ (U1c z).charpoly.eval (-1) = 0}
    ∧ {z : ℂ | ‖z‖ = 1 ∧ (U1c z).charpoly.eval 1 = 0} = {-1} := by
  have key : ∀ z : ℂ, (U1c z).charpoly.eval 1 = 0 ↔ z = -1 := by
    intro z; rw [U1c_eval_one]; constructor
    · intro h; have : z + 1 = 0 := by linear_combination (5:ℂ) * h
      linear_combination this
    · intro h; rw [h]; ring
  have key2 : ∀ z : ℂ, (U1c z).charpoly.eval (-1) = 0 ↔ z = -1 := by
    intro z; rw [U1c_eval_neg_one]; constructor
    · intro h; have : z + 1 = 0 := by linear_combination (5/9:ℂ) * h
      linear_combination this
    · intro h; rw [h]; ring
  constructor
  · ext z; simp only [Set.mem_setOf_eq, key z, key2 z]
  · ext z; simp only [Set.mem_setOf_eq, key z, Set.mem_singleton_iff]
    constructor
    · rintro ⟨_, h⟩; exact h
    · rintro h; refine ⟨?_, h⟩; rw [h]; norm_num

end PhysicsSM.Draft.NullEdge.TwoBandCrossingDoubling
