import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The four faces of `mass²` are ONE invariant

For a real symmetric trace-1 `2×2` "density" `ρ = !![p, x; x, 1-p]` we prove the exact
algebraic identities that make the several `mass²` dictionaries into faces of a single
wedge/determinant invariant, and we honestly separate the *one-register* entropies
(`det`, `Slin`, `Hlin`, which are literally equal up to the fixed factor `2`) from the
*two-register* total-variation distance `TVdiag` (a related but distinct, two-argument
object: the Plücker distance between two null edges).

All arithmetic is exact and rational: `Matrix.trace`/`Matrix.mul` + `Fin.sum_univ_two`
+ `ring`/`norm_num`/`decide` + `abs`.  No `Real.sqrt`/`cos`/`sin`, no `Complex`,
no high-degree `nlinarith`.
-/

namespace MassFourFaces

/-- The real symmetric trace-1 `2×2` "density". -/
def rho (p x : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![p, x; x, 1 - p]

/-- The determinant / Plücker invariant `p(1-p) - x²`. -/
def detR (p x : ℚ) : ℚ := p * (1 - p) - x ^ 2

/-- Linear entropy `1 - tr(ρ²)`. -/
def Slin (p x : ℚ) : ℚ := 1 - (rho p x * rho p x).trace

/-- Diagonal ("`Hlin`") linear entropy `1 - (p² + (1-p)²)`. -/
def Hlin (p : ℚ) : ℚ := 1 - (p ^ 2 + (1 - p) ^ 2)

/-- The diagonal celestial 2-outcome readout `d p = (p, 1-p)`, a probability vector. -/
def d (p : ℚ) : Fin 2 → ℚ := ![p, 1 - p]

/-- Total-variation distance of two diagonal readouts:
`½(|p-q| + |(1-p)-(1-q)|)`. -/
def TVdiag (p q : ℚ) : ℚ := (1 / 2) * (|p - q| + |(1 - p) - (1 - q)|)

/-! ## Face 1: linear entropy is exactly twice the determinant -/

/-- `Slin p x = 2 · detR p x`. -/
theorem slin_eq_two_det (p x : ℚ) : Slin p x = 2 * detR p x := by
  simp [Slin, detR, rho, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag]
  ring

/-! ## Face 2: the diagonal linear entropy is the determinant at `x = 0` -/

/-- `Hlin p = 2 · detR p 0`, and `Hlin p = 2·p·(1-p)`. -/
theorem hlin_eq_two_det_diag (p : ℚ) :
    Hlin p = 2 * detR p 0 ∧ Hlin p = 2 * p * (1 - p) := by
  constructor <;> · simp [Hlin, detR]; ring

/-- `detR p 0 = p·(1-p)`. -/
theorem detR_diag (p : ℚ) : detR p 0 = p * (1 - p) := by simp [detR]

/-! ## Face 3 (payload): the det/entropy faces are ONE rational invariant -/

/-- The single-register faces agree: for all `p, x`, `Slin = 2·detR`, and at `x = 0` the
determinant, linear entropy and diagonal linear entropy all coincide (up to the fixed
factor `2`) and equal `2·p·(1-p)`. -/
theorem faces_agree (p x : ℚ) :
    Slin p x = 2 * detR p x ∧
    Slin p 0 = Hlin p ∧
    Hlin p = 2 * detR p 0 ∧
    2 * detR p 0 = 2 * p * (1 - p) := by
  refine ⟨slin_eq_two_det p x, ?_, (hlin_eq_two_det_diag p).1, ?_⟩
  · rw [slin_eq_two_det p 0, (hlin_eq_two_det_diag p).1]
  · simp [detR]; ring

/-! ## Face 4 (payload, the honest separation): TV is the two-register Plücker distance -/

/-- The total-variation distinguishability of two diagonal readouts collapses to `|p-q|`,
which is exactly the magnitude of the `2×2` Plücker wedge `|p(1-q) - (1-p)q|`.  So `TV`
is the *Plücker distance between two edges* — a two-argument object distinct from the
one-register entropy, yet built from the same wedge/determinant data — and it vanishes
exactly when the two edges are collinear (`p = q`, massless). -/
theorem tv_is_plucker_distance (p q : ℚ) :
    TVdiag p q = |p - q| ∧
    TVdiag p q = |p * (1 - q) - (1 - p) * q| ∧
    TVdiag p p = 0 := by
  have hTV : TVdiag p q = |p - q| := by
    have h : (1 - p) - (1 - q) = -(p - q) := by ring
    simp only [TVdiag, h, abs_neg]; ring
  refine ⟨hTV, ?_, ?_⟩
  · rw [hTV]; congr 1; ring
  · simp [TVdiag]

/-! ## The four-faces verdict -/

/-- Package: `det`, `Slin`, `Hlin` are one single-register `mass²` invariant (equal up to
the factor `2`); `TV` is the two-register Plücker distance of the null directions; and all
four vanish exactly at masslessness (`x = 0` with `p ∈ {0,1}` on the single-register side,
`p = q` on the two-register side).  This is the consolidation that the several `mass²`
dictionaries are faces of one wedge/determinant invariant, NOT four independent results. -/
theorem four_faces_verdict :
    -- (i) the single-register faces are one invariant
    (∀ p x : ℚ, Slin p x = 2 * detR p x) ∧
    (∀ p : ℚ, Hlin p = 2 * detR p 0 ∧ Slin p 0 = Hlin p) ∧
    -- (ii) TV is the two-register Plücker distance
    (∀ p q : ℚ, TVdiag p q = |p * (1 - q) - (1 - p) * q|) ∧
    -- (iii) single-register masslessness: det/Slin/Hlin vanish exactly for p ∈ {0,1}
    (∀ p : ℚ, detR p 0 = 0 ↔ p = 0 ∨ p = 1) ∧
    (∀ p : ℚ, Slin p 0 = 0 ↔ p = 0 ∨ p = 1) ∧
    (∀ p : ℚ, Hlin p = 0 ↔ p = 0 ∨ p = 1) ∧
    -- (iv) two-register masslessness: TV vanishes exactly for collinear edges p = q
    (∀ p q : ℚ, TVdiag p q = 0 ↔ p = q) := by
  refine ⟨fun p x => slin_eq_two_det p x,
          fun p => ⟨(hlin_eq_two_det_diag p).1, (faces_agree p 0).2.1⟩,
          fun p q => (tv_is_plucker_distance p q).2.1, ?_, ?_, ?_, ?_⟩
  · intro p
    rw [detR_diag]
    constructor
    · intro h
      rcases mul_eq_zero.1 h with h0 | h1
      · exact Or.inl h0
      · exact Or.inr (by linarith)
    · rintro (rfl | rfl) <;> norm_num
  · intro p
    rw [slin_eq_two_det, detR_diag]
    constructor
    · intro h
      have : p * (1 - p) = 0 := by linarith
      rcases mul_eq_zero.1 this with h0 | h1
      · exact Or.inl h0
      · exact Or.inr (by linarith)
    · rintro (rfl | rfl) <;> norm_num
  · intro p
    rw [(hlin_eq_two_det_diag p).1, detR_diag]
    constructor
    · intro h
      have : p * (1 - p) = 0 := by linarith
      rcases mul_eq_zero.1 this with h0 | h1
      · exact Or.inl h0
      · exact Or.inr (by linarith)
    · rintro (rfl | rfl) <;> norm_num
  · intro p q
    rw [(tv_is_plucker_distance p q).1, abs_eq_zero, sub_eq_zero]

/-! ## MANDATORY non-degeneracy: explicit rationals -/

/-- Pure/massless: `ρ (1/2) (1/2)` is a pure state — the off-diagonal `x = 1/2` makes the
determinant (hence the linear entropy) vanish: `Slin = 0` and `det = 0`.  (Note `Hlin`,
the *diagonal* readout, ignores `x`, so `Hlin (1/2) = 1/2 ≠ 0` here — they agree only at
`x = 0`.) -/
theorem nondeg_pure_massless :
    Slin (1 / 2) (1 / 2) = 0 ∧ detR (1 / 2) (1 / 2) = 0 := by
  constructor
  · rw [slin_eq_two_det]; norm_num [detR]
  · norm_num [detR]

/-- Mixed: `ρ (1/2) 0` has `Slin = 1/2 = Hlin = 2·det`. -/
theorem nondeg_mixed :
    Slin (1 / 2) 0 = 1 / 2 ∧ Hlin (1 / 2) = 1 / 2 ∧ 2 * detR (1 / 2) 0 = 1 / 2 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [slin_eq_two_det]; norm_num [detR]
  · norm_num [Hlin]
  · norm_num [detR]

/-- TV non-degeneracy: `TVdiag (1/2) (1/2) = 0` (collinear) vs `TVdiag 1 0 = 1`. -/
theorem nondeg_tv : TVdiag (1 / 2) (1 / 2) = 0 ∧ TVdiag 1 0 = 1 := by
  constructor
  · rw [(tv_is_plucker_distance _ _).1]; norm_num
  · rw [(tv_is_plucker_distance _ _).1]; norm_num

/-! ## Axiom footprint of every headline (kernel-checked only) -/

/-- info: 'MassFourFaces.slin_eq_two_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms slin_eq_two_det

/-- info: 'MassFourFaces.hlin_eq_two_det_diag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hlin_eq_two_det_diag

/-- info: 'MassFourFaces.faces_agree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms faces_agree

/-- info: 'MassFourFaces.tv_is_plucker_distance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tv_is_plucker_distance

/-- info: 'MassFourFaces.four_faces_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms four_faces_verdict

/-- info: 'MassFourFaces.nondeg_pure_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondeg_pure_massless

/-- info: 'MassFourFaces.nondeg_mixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondeg_mixed

/-- info: 'MassFourFaces.nondeg_tv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondeg_tv

end MassFourFaces
