import Mathlib

/-!
# Positive-sector selection in signature (1,1)

For the Krein involution `J = diag(1,-1)`, this module classifies
Krein-self-adjoint `2 x 2` complex operators and proves the first finite
selection dichotomy:

* a strict real spectral gap produces a nonzero invariant eigenline with
  positive Krein norm;
* an eigendirection with nonreal eigenvalue is necessarily Krein-neutral.

The strict-gap and nonreal regimes are proved separately.  No biconditional is
claimed at the repeated-root or exceptional-point boundary.  Exact positive
and neutral witnesses make both regimes nonvacuous.

Provenance: theorem design from the 2026-07-10 positive-sector audit.  Proofs
clean-room integrated from Aristotle project
`99a0e4b5-1c1e-40e3-8c8a-e7b36337a3b7` and checked under Lean 4.28.0.
-/

namespace PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy

open Matrix

/-- Signature-(1,1) Krein involution. -/
def Jm : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, -1]

/-- Krein norm of a two-component vector. -/
noncomputable def kreinNorm (v : Fin 2 -> Complex) : Complex :=
  star v ⬝ᵥ Jm.mulVec v

set_option maxHeartbeats 1000000 in
/-- Two-way normal form of a Krein-self-adjoint operator. -/
theorem jsa_normal_form (D : Matrix (Fin 2) (Fin 2) Complex) :
    Jm * D = Dᴴ * Jm ↔
      ∃ (a d : Real) (b : Complex),
        D = !![(a : Complex), b; -(starRingEnd Complex) b, (d : Complex)] := by
  constructor
  · intro h
    refine ⟨(D 0 0).re, (D 1 1).re, D 0 1, ?_⟩
    have h00 := congrFun (congrFun h 0) 0
    have h10 := congrFun (congrFun h 1) 0
    have h11 := congrFun (congrFun h 1) 1
    simp only [Jm, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.conjTranspose_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
      Matrix.cons_val_fin_one, one_mul, mul_one, zero_mul, mul_zero, add_zero,
      zero_add, neg_mul, mul_neg] at h00 h10 h11
    have e00 : D 0 0 = ((D 0 0).re : Complex) :=
      (Complex.conj_eq_iff_re.mp
        (by rw [starRingEnd_apply]; exact h00.symm)).symm
    have e11 : D 1 1 = ((D 1 1).re : Complex) :=
      (Complex.conj_eq_iff_re.mp
        (by rw [starRingEnd_apply]; exact (neg_inj.mp h11).symm)).symm
    have e10 : D 1 0 = -(starRingEnd Complex) (D 0 1) := by
      rw [starRingEnd_apply, ← neg_eq_iff_eq_neg]
      exact h10
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp only [Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
        Matrix.cons_val_fin_one]
    · exact e00
    · rfl
    · exact e10
    · exact e11
  · rintro ⟨a, d, b, rfl⟩
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp only [Jm, Matrix.mul_apply, Fin.sum_univ_two,
        Matrix.conjTranspose_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
        Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
        Matrix.cons_val_fin_one, starRingEnd_apply] <;>
      simp [Complex.conj_ofReal]

/-- Normal-form operator. -/
noncomputable def Dnf (a d : Real) (b : Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  !![(a : Complex), b; -(starRingEnd Complex) b, (d : Complex)]

/-- Characteristic-relation eigenvector helper. -/
theorem eigen_eq (a d : Real) (b : Complex) (lam : Real)
    (hid : (lam - a) * (lam - d) = -Complex.normSq b) :
    (Dnf a d b).mulVec ![b, ((lam - a : Real) : Complex)] =
      (lam : Complex) • ![b, ((lam - a : Real) : Complex)] := by
  have hidC : ((lam : Complex) - a) * ((lam : Complex) - d) =
      -(Complex.normSq b : Complex) := by
    exact_mod_cast hid
  have hbb : (starRingEnd Complex) b * b =
      (Complex.normSq b : Complex) := by
    rw [mul_comm]
    exact Complex.mul_conj b
  funext i
  fin_cases i <;>
    simp only [Dnf, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply,
      Matrix.cons_val', Matrix.empty_val', Matrix.cons_val_fin_one,
      Pi.smul_apply, smul_eq_mul]
  · push_cast
    ring
  · push_cast
    linear_combination -hbb - hidC

/-- Krein norm of a normal-form eigenvector with real second coordinate. -/
theorem krein_val (b : Complex) (c : Real) :
    kreinNorm ![b, ((c : Real) : Complex)] =
      ((Complex.normSq b - c ^ 2 : Real) : Complex) := by
  unfold kreinNorm Jm
  simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_two,
    Matrix.cons_val_zero, Matrix.cons_val_one, Pi.star_apply, Matrix.of_apply,
    Matrix.cons_val', Matrix.empty_val', Matrix.cons_val_fin_one, one_mul,
    zero_mul, add_zero, zero_add]
  rw [show star b = (starRingEnd Complex) b from rfl, mul_comm,
    Complex.mul_conj]
  have hc : star (c : Complex) = (c : Complex) := by
    rw [← starRingEnd_apply, Complex.conj_ofReal]
  rw [hc]
  push_cast
  ring

/-- A strict real gap guarantees a strictly positive invariant eigenline. -/
theorem positive_selection_exists (a d : Real) (b : Complex) (hb : b ≠ 0)
    (hgap : 4 * Complex.normSq b < (a - d) ^ 2) :
    ∃ (lam : Real) (v : Fin 2 -> Complex), v ≠ 0 ∧
      (Dnf a d b).mulVec v = (lam : Complex) • v ∧
      0 < (kreinNorm v).re ∧ (kreinNorm v).im = 0 := by
  have hnbpos : 0 < Complex.normSq b := Complex.normSq_pos.mpr hb
  set nb := Complex.normSq b with hnbdef
  set m := (a - d) / 2 with hmdef
  have hgap' : nb < m ^ 2 := by
    rw [hmdef]
    nlinarith [hgap]
  set delta := m ^ 2 - nb with hDeltaDef
  have hDeltaPos : 0 < delta := by
    rw [hDeltaDef]
    linarith
  set r := Real.sqrt delta with hrdef
  have hrsq : r ^ 2 = delta := Real.sq_sqrt hDeltaPos.le
  have hrpos : 0 < r := Real.sqrt_pos.mpr hDeltaPos
  have hrltabs : r < |m| := by
    have hlt : delta < |m| ^ 2 := by
      rw [sq_abs, hDeltaDef]
      linarith
    calc
      r = Real.sqrt delta := hrdef
      _ < Real.sqrt (|m| ^ 2) := Real.sqrt_lt_sqrt hDeltaPos.le hlt
      _ = |m| := Real.sqrt_sq (abs_nonneg m)
  have main : forall eps : Real, eps ^ 2 = delta -> r ^ 2 < eps * m ->
      ∃ (lam : Real) (v : Fin 2 -> Complex), v ≠ 0 ∧
        (Dnf a d b).mulVec v = (lam : Complex) • v ∧
        0 < (kreinNorm v).re ∧ (kreinNorm v).im = 0 := by
    intro eps heps hepsm
    refine ⟨(a + d) / 2 + eps,
      ![b, ((((a + d) / 2 + eps) - a : Real) : Complex)], ?_, ?_, ?_, ?_⟩
    · intro hv
      have : b = 0 := by
        have h := congrFun hv 0
        simpa using h
      exact hb this
    · apply eigen_eq
      rw [← hnbdef]
      have h2 : eps ^ 2 = ((a - d) / 2) ^ 2 - nb := by
        rw [heps, hDeltaDef, hmdef]
      linear_combination h2
    · rw [krein_val]
      simp only [Complex.ofReal_re]
      have hc : (a + d) / 2 + eps - a = eps - m := by
        rw [hmdef]
        ring
      rw [hc]
      nlinarith [heps, hepsm, hrsq]
    · rw [krein_val]
      exact Complex.ofReal_im _
  rcases lt_or_gt_of_ne
      (show m ≠ 0 by
        intro h
        rw [h] at hgap'
        norm_num at hgap'
        linarith) with hm | hm
  · apply main (-r)
    · rw [neg_pow]
      simp [hrsq]
    · have hh : r * (-m) > r * r := by
        apply mul_lt_mul_of_pos_left _ hrpos
        have habs : |m| = -m := abs_of_neg hm
        rw [habs] at hrltabs
        linarith
      nlinarith [hh]
  · apply main r
    · exact hrsq
    · have hh : r * m > r * r := by
        apply mul_lt_mul_of_pos_left _ hrpos
        have habs : |m| = m := abs_of_pos hm
        rw [habs] at hrltabs
        linarith
      nlinarith [hh]

/-- A nonreal eigenvalue of a Krein-self-adjoint operator has a neutral
eigendirection. -/
theorem nonreal_forces_neutral (D : Matrix (Fin 2) (Fin 2) Complex)
    (hD : Jm * D = Dᴴ * Jm) (lam : Complex) (hlam : lam.im ≠ 0)
    (v : Fin 2 -> Complex) (hv : D.mulVec v = lam • v) :
    kreinNorm v = 0 := by
  have adj : star (D.mulVec v) ⬝ᵥ Jm.mulVec v =
      star v ⬝ᵥ Dᴴ.mulVec (Jm.mulVec v) := by
    rw [Matrix.star_mulVec, ← Matrix.dotProduct_mulVec]
  have key : star v ⬝ᵥ Jm.mulVec (D.mulVec v) =
      star (D.mulVec v) ⬝ᵥ Jm.mulVec v := by
    rw [Matrix.mulVec_mulVec, hD, ← Matrix.mulVec_mulVec, adj]
  rw [hv] at key
  have hk : lam * kreinNorm v =
      (starRingEnd Complex) lam * kreinNorm v := by
    have e1 : star v ⬝ᵥ Jm.mulVec (lam • v) =
        lam * kreinNorm v := by
      unfold kreinNorm Jm
      simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_two,
        Matrix.cons_val_zero, Matrix.cons_val_one, Pi.star_apply,
        Pi.smul_apply, smul_eq_mul, Matrix.of_apply, Matrix.cons_val',
        Matrix.empty_val', Matrix.cons_val_fin_one]
      ring
    have e2 : star (lam • v) ⬝ᵥ Jm.mulVec v =
        (starRingEnd Complex) lam * kreinNorm v := by
      unfold kreinNorm Jm
      simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_two,
        Matrix.cons_val_zero, Matrix.cons_val_one, Pi.star_apply,
        Pi.smul_apply, smul_eq_mul, Matrix.of_apply, Matrix.cons_val',
        Matrix.empty_val', Matrix.cons_val_fin_one, star_mul',
        starRingEnd_apply]
      ring
    rw [← e1, ← e2]
    exact key
  have hfac : (lam - (starRingEnd Complex) lam) * kreinNorm v = 0 := by
    linear_combination hk
  rcases mul_eq_zero.mp hfac with h | h
  · exfalso
    apply hlam
    rw [Complex.sub_conj] at h
    have h3 : (2 * lam.im : Real) = 0 := by
      have hi := congrArg Complex.im h
      simpa using hi
    simpa using h3
  · exact h

/-- Exact positive and negative lines in the strict-gap regime. -/
theorem witness_positive :
    (Dnf 2 0 (3 / 5)).mulVec ![3 / 5, -(1 / 5)] =
      ((9 / 5 : Real) : Complex) • ![3 / 5, -(1 / 5)] ∧
    kreinNorm ![3 / 5, -(1 / 5)] = 8 / 25 ∧
    (Dnf 2 0 (3 / 5)).mulVec ![3 / 5, -(9 / 5)] =
      ((1 / 5 : Real) : Complex) • ![3 / 5, -(9 / 5)] ∧
    kreinNorm ![3 / 5, -(9 / 5)] = -(72 / 25) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · funext i
    fin_cases i <;>
      simp [Dnf, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
        starRingEnd_apply] <;> norm_num
  · unfold kreinNorm Jm
    simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Pi.star_apply,
      Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
      Matrix.cons_val_fin_one]
    norm_num [Complex.ext_iff]
  · funext i
    fin_cases i <;>
      simp [Dnf, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
        starRingEnd_apply] <;> norm_num
  · unfold kreinNorm Jm
    simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Pi.star_apply,
      Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
      Matrix.cons_val_fin_one]
    norm_num [Complex.ext_iff]

/-- Exact nonreal neutral control. -/
theorem witness_neutral :
    Jm * !![0, 1; -1, 0] =
      (!![0, 1; -1, 0] : Matrix (Fin 2) (Fin 2) Complex)ᴴ * Jm ∧
    (!![0, 1; -1, 0] : Matrix (Fin 2) (Fin 2) Complex).mulVec
        ![1, Complex.I] = Complex.I • ![1, Complex.I] ∧
    kreinNorm ![1, Complex.I] = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Jm, Matrix.mul_apply, Fin.sum_univ_two,
        Matrix.conjTranspose_apply]
  · funext i
    fin_cases i <;>
      simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_two,
        Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply,
        Matrix.cons_val', Matrix.empty_val', Matrix.cons_val_fin_one,
        Pi.smul_apply, smul_eq_mul] <;> simp [Complex.I_mul_I]
  · unfold kreinNorm Jm
    simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Pi.star_apply,
      Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
      Matrix.cons_val_fin_one]
    simp

end PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.jsa_normal_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.jsa_normal_form

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.positive_selection_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.positive_selection_exists

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.nonreal_forces_neutral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.nonreal_forces_neutral

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.witness_positive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.witness_positive

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.witness_neutral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PositiveSectorSelectionDichotomy.witness_neutral
