import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Celestial spherical code — mass = chordal separation of null directions

A finite, *rational* (no `Real.sqrt`/`cos`/`arccos`, no `Complex`) avatar of the
spherical-code / spherical-design notions.  Each null edge is a direction on the
celestial 2-sphere, modelled as a rational unit vector `u : Fin 3 → ℚ` with
`dot u u = 1`.  The **mass** of a two-edge state is the **chordal separation** of the
two null directions, `chordSq u v = ∑ᵢ (uᵢ - vᵢ)²`:

* coincident directions (chordal distance `0`) = collinear = massless;
* separated directions = massive; antipodal = maximal (`4`).

A maximally symmetric massless multiplet — null directions in perfect balance — is a
**tight frame / spherical 2-design**: its frame operator `S U = ∑ₖ outer (U k) (U k)`
is isotropic (`S = I` for the coordinate frame).

Provenance (reference, NOT an import; version-pinned, clean-room): the spherical-code /
spherical-design programs — Sphere-Packing-Lean and LeanCamCombi
(Delsarte–Goethals–Seidel designs, tight frames).  This is a finite rational avatar of
spherical codes/designs on `S²`, not a claim about physical multiplets' quantum numbers.
-/

namespace CelestialSphericalCode

/-- Rational inner product of two `Fin 3 → ℚ` vectors. -/
def dot (u v : Fin 3 → ℚ) : ℚ := ∑ i, u i * v i

/-- Chordal distance squared between two null directions — the (rational) **mass**
of the two-edge state. -/
def chordSq (u v : Fin 3 → ℚ) : ℚ := ∑ i, (u i - v i) ^ 2

/-- Coordinate frame vector `e₀ = (1,0,0)`. -/
def e0 : Fin 3 → ℚ := ![1, 0, 0]
/-- Coordinate frame vector `e₁ = (0,1,0)`. -/
def e1 : Fin 3 → ℚ := ![0, 1, 0]
/-- Coordinate frame vector `e₂ = (0,0,1)`. -/
def e2 : Fin 3 → ℚ := ![0, 0, 1]

/-- A rational (Pythagorean-triple) point on `S²`: `(3/5, 4/5, 0)`. -/
def pyth : Fin 3 → ℚ := ![3 / 5, 4 / 5, 0]

/-- The coordinate ortho-frame `![e₀, e₁, e₂]` — the balanced massless multiplet. -/
def orthoframe : Fin 3 → (Fin 3 → ℚ) := ![e0, e1, e2]

/-- Frame operator `S U i j = ∑ₖ (U k) i * (U k) j` (sum of outer products). -/
def frameOp {n : ℕ} (U : Fin n → (Fin 3 → ℚ)) : Matrix (Fin 3) (Fin 3) ℚ :=
  fun i j => ∑ k, U k i * U k j

/-- A non-tight *control* configuration: two coincident directions `![e₀, e₀, e₁]`. -/
def control : Fin 3 → (Fin 3 → ℚ) := ![e0, e0, e1]

/-- **Target 1.** For unit vectors, the chordal separation reads off the inner product:
`chordSq u v = 2 - 2 · dot u v`.  Pure `Finset`/`ring` expansion. -/
theorem chord_eq_two_sub_two_inner (u v : Fin 3 → ℚ)
    (hu : dot u u = 1) (hv : dot v v = 1) :
    chordSq u v = 2 - 2 * dot u v := by
  simp only [chordSq, dot, Fin.sum_univ_three] at *
  ring_nf; ring_nf at hu hv; linarith

/-- The chordal separation (mass) is always nonnegative. -/
theorem chordSq_nonneg (u v : Fin 3 → ℚ) : 0 ≤ chordSq u v :=
  Finset.sum_nonneg (fun _ _ => sq_nonneg _)

/-- For unit vectors the chordal separation is at most `4` (maximal at the antipode). -/
theorem chordSq_le_four (u v : Fin 3 → ℚ) (hu : dot u u = 1) (hv : dot v v = 1) :
    chordSq u v ≤ 4 := by
  have hs : (0 : ℚ) ≤ ∑ i, (u i + v i) ^ 2 :=
    Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  simp only [chordSq, dot, Fin.sum_univ_three] at *
  ring_nf; ring_nf at hu hv hs; linarith

/-- **Target 2 (payload).** Massless ⇔ collinear: the mass vanishes exactly when the two
null edges point the same way, `chordSq u v = 0 ↔ u = v`. -/
theorem massless_iff_collinear (u v : Fin 3 → ℚ) : chordSq u v = 0 ↔ u = v := by
  constructor
  · intro h
    simp only [chordSq, Fin.sum_univ_three] at h
    have h0 : (u 0 - v 0) ^ 2 = 0 := by
      nlinarith [sq_nonneg (u 0 - v 0), sq_nonneg (u 1 - v 1), sq_nonneg (u 2 - v 2)]
    have h1 : (u 1 - v 1) ^ 2 = 0 := by
      nlinarith [sq_nonneg (u 0 - v 0), sq_nonneg (u 1 - v 1), sq_nonneg (u 2 - v 2)]
    have h2 : (u 2 - v 2) ^ 2 = 0 := by
      nlinarith [sq_nonneg (u 0 - v 0), sq_nonneg (u 1 - v 1), sq_nonneg (u 2 - v 2)]
    funext i
    fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one] <;>
      [exact sub_eq_zero.mp (pow_eq_zero_iff (by norm_num) |>.mp h0);
       exact sub_eq_zero.mp (pow_eq_zero_iff (by norm_num) |>.mp h1);
       exact sub_eq_zero.mp (pow_eq_zero_iff (by norm_num) |>.mp h2)]
  · intro h; subst h; simp [chordSq]

/-- **Target 2 (payload), antipode.** The antipode gives the maximal chordal separation:
`chordSq u (-u) = 4` for a unit vector `u`. -/
theorem chordSq_antipode (u : Fin 3 → ℚ) (hu : dot u u = 1) : chordSq u (-u) = 4 := by
  simp only [chordSq, dot, Fin.sum_univ_three, Pi.neg_apply] at *
  ring_nf; ring_nf at hu; linarith

/-- **Target 3 (payload — the design core).** The coordinate frame `![e₀, e₁, e₂]` is a
spherical **tight frame / 2-design**: its frame operator is isotropic, `S U = I`
(equivalently `∑ₖ outer (U k) (U k) = (n/d)·I` with `n = d = 3`). -/
theorem orthoframe_is_tight_frame : frameOp orthoframe = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [frameOp, orthoframe, e0, e1, e2, Fin.sum_univ_three]

/-- **Non-tight control.** With two coincident directions the frame operator is *not*
isotropic: `frameOp control` is not any scalar multiple of the identity (its `(0,0)`
entry is `2` while its `(2,2)` entry is `0`), showing tightness is a real constraint. -/
theorem control_not_tight :
    ¬ ∃ c : ℚ, frameOp control = c • (1 : Matrix (Fin 3) (Fin 3) ℚ) := by
  rintro ⟨c, hc⟩
  have h00 := congrFun (congrFun hc 0) 0
  have h22 := congrFun (congrFun hc 2) 2
  simp [frameOp, control, e0, e1, Fin.sum_univ_three] at h00 h22
  rw [← h00] at h22; norm_num at h22

/-- Explicit off-isotropic entries of the control frame operator: `(0,0) = 2`, `(2,2) = 0`. -/
theorem control_entries :
    frameOp control 0 0 = 2 ∧ frameOp control 2 2 = 0 := by
  refine ⟨?_, ?_⟩
  · simp [frameOp, control, e0, e1, Fin.sum_univ_three]
    norm_num
  · simp [frameOp, control, e0, e1, Fin.sum_univ_three]

/-- Non-degeneracy witnesses: explicit rational unit vectors and chordal values. -/
theorem nondegeneracy_witnesses :
    dot e0 e0 = 1 ∧ dot pyth pyth = 1 ∧
    chordSq e0 e0 = 0 ∧ chordSq e0 e1 = 2 ∧ chordSq e0 (-e0) = 4 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;>
    simp [dot, chordSq, e0, e1, pyth, Fin.sum_univ_three] <;> norm_num

/-- **Target 4.** `spherical_code_verdict` — the packaged verdict.

* mass = chordal separation, `chordSq u v = 2 - 2 · dot u v` for unit directions;
* the mass is bounded, `0 ≤ chordSq u v ≤ 4`;
* zero iff collinear (massless), `chordSq u v = 0 ↔ u = v`;
* maximal `4` at the antipode, `chordSq u (-u) = 4`;
* a balanced massless multiplet is a tight frame / spherical 2-design,
  `frameOp orthoframe = I`;
* tightness is a real constraint: the control `![e₀, e₀, e₁]` is not isotropic. -/
theorem spherical_code_verdict :
    (∀ u v : Fin 3 → ℚ, dot u u = 1 → dot v v = 1 →
        chordSq u v = 2 - 2 * dot u v) ∧
    (∀ u v : Fin 3 → ℚ, 0 ≤ chordSq u v) ∧
    (∀ u v : Fin 3 → ℚ, dot u u = 1 → dot v v = 1 → chordSq u v ≤ 4) ∧
    (∀ u v : Fin 3 → ℚ, chordSq u v = 0 ↔ u = v) ∧
    (∀ u : Fin 3 → ℚ, dot u u = 1 → chordSq u (-u) = 4) ∧
    frameOp orthoframe = 1 ∧
    (¬ ∃ c : ℚ, frameOp control = c • (1 : Matrix (Fin 3) (Fin 3) ℚ)) :=
  ⟨chord_eq_two_sub_two_inner, chordSq_nonneg, chordSq_le_four,
    massless_iff_collinear, chordSq_antipode, orthoframe_is_tight_frame,
    control_not_tight⟩

-- Axiom footprint checks on every headline (exactly `propext, Classical.choice, Quot.sound`).
/-- info: 'CelestialSphericalCode.chord_eq_two_sub_two_inner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chord_eq_two_sub_two_inner

/-- info: 'CelestialSphericalCode.massless_iff_collinear' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_iff_collinear

/-- info: 'CelestialSphericalCode.orthoframe_is_tight_frame' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms orthoframe_is_tight_frame

/-- info: 'CelestialSphericalCode.spherical_code_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spherical_code_verdict

end CelestialSphericalCode
