import Mathlib

/-!
# CKM Jarlskog CP invariant (Opus, verified Aristotle ce8ba471)

The concrete CP observable behind the '+1 CP phase' in the A2 3-generation count:
rephasing invariance (left/right diagonal phases), J=0 for real matrices, an
explicit Fourier CKM with J=sqrt3/18, existence of a unitary with nonzero J, and
row/column proportionality => J=0. Namespace kept as prover's CKM. Provenance:
verified at pin from task f10831ff. Standard three. Grade M, [comp]. -/

open scoped BigOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace CKM

/-- A unit complex phase, written in the form used for fermion rephasings. -/
noncomputable def phase (x : ℝ) : ℂ := Complex.exp ((x : ℂ) * Complex.I)

/-- The imaginary part of a four-entry (Jarlskog) quartet. -/
def jarlskogQuartet {n : Type} (V : Matrix n n ℂ) (i k j l : n) : ℝ :=
  (V i j * V k l * star (V i l) * star (V k j)).im

/-- The conventional CKM Jarlskog invariant, using rows and columns 0 and 1. -/
def jarlskog (V : Matrix (Fin 3) (Fin 3) ℂ) : ℝ :=
  jarlskogQuartet V 0 1 0 1

/-- Independent diagonal phase changes of the up- and down-type fields. -/
noncomputable def rephase {n : Type} (a b : n → ℝ) (V : Matrix n n ℂ) : Matrix n n ℂ :=
  fun i j ↦ phase (a i) * V i j * phase (-b j)

lemma phase_star (x : ℝ) : star (phase x) = phase (-x) := by
  unfold phase; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] ;

lemma phase_mul_neg (x : ℝ) : phase x * phase (-x) = 1 := by
  unfold phase; norm_num [ mul_comm Complex.I, Complex.exp_neg ] ;

/-
Every Jarlskog quartet is invariant under independent row and column rephasings.
-/
theorem jarlskogQuartet_rephase {n : Type} (V : Matrix n n ℂ) (a b : n → ℝ)
    (i k j l : n) :
    jarlskogQuartet (rephase a b V) i k j l = jarlskogQuartet V i k j l := by
  unfold jarlskogQuartet rephase;
  simp +decide only [mul_comm, mul_assoc, mul_left_comm, star_mul, phase_star];
  simp +decide [ ← mul_assoc, ← Complex.exp_add, phase ]

/-
In particular, the conventional `3 × 3` CKM invariant is rephasing-invariant.
-/
theorem jarlskog_rephase (V : Matrix (Fin 3) (Fin 3) ℂ)
    (a b : Fin 3 → ℝ) :
    jarlskog (rephase a b V) = jarlskog V := by
  convert jarlskogQuartet_rephase V a b 0 1 0 1

/-- Regard a real matrix as a complex matrix entry by entry. -/
def complexify {n : Type} (V : Matrix n n ℝ) : Matrix n n ℂ :=
  fun i j ↦ (V i j : ℂ)

/-
A real orthogonal mixing matrix has vanishing Jarlskog invariant.
The conclusion in fact only needs the entries to be real; orthogonality is retained
as an explicit hypothesis to match the physical statement.
-/
theorem jarlskog_real_orthogonal (V : Matrix (Fin 3) (Fin 3) ℝ)
    (_hV : V ∈ Matrix.orthogonalGroup (Fin 3) ℝ) :
    jarlskog (complexify V) = 0 := by
  unfold jarlskog jarlskogQuartet complexify; aesop;

/-- A concrete primitive cube root of unity. -/
noncomputable def omega : ℂ := (-(1 : ℝ) / 2 : ℂ) + ((Real.sqrt 3 / 2 : ℝ) : ℂ) * Complex.I

/-- The normalized three-point Fourier matrix, an explicit CKM witness. -/
noncomputable def fourierCKM : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(Real.sqrt 3 / 3 : ℝ), (Real.sqrt 3 / 3 : ℝ), (Real.sqrt 3 / 3 : ℝ);
     (Real.sqrt 3 / 3 : ℝ), (Real.sqrt 3 / 3 : ℝ) * omega,
       (Real.sqrt 3 / 3 : ℝ) * omega ^ 2;
     (Real.sqrt 3 / 3 : ℝ), (Real.sqrt 3 / 3 : ℝ) * omega ^ 2,
       (Real.sqrt 3 / 3 : ℝ) * omega]

lemma sqrt_three_sq : (Real.sqrt 3) ^ 2 = 3 := by
  exact Real.sq_sqrt <| by norm_num;

lemma omega_re : omega.re = -(1 : ℝ) / 2 := by
  unfold omega; norm_num

lemma omega_im : omega.im = Real.sqrt 3 / 2 := by
  unfold omega; norm_num;

/-
The Fourier witness is unitary.
-/
theorem fourierCKM_unitary : fourierCKM ∈ Matrix.unitaryGroup (Fin 3) ℂ := by
  have h_unitary : fourierCKM * fourierCKM.conjTranspose = 1 := by
    ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, fourierCKM ] <;> ring_nf <;> norm_num [ Complex.ext_iff, sq ] ;
    all_goals norm_num [ omega_re, omega_im ] ; ring_nf ; norm_num;; all_goals nlinarith [ Real.sq_sqrt <| show 0 ≤ 3 by norm_num ];
  exact Matrix.mem_unitaryGroup_iff.mpr h_unitary

/-
The witness has the explicitly nonzero invariant `sqrt 3 / 18`.
-/
theorem jarlskog_fourierCKM : jarlskog fourierCKM = Real.sqrt 3 / 18 := by
  unfold jarlskog jarlskogQuartet;
  unfold fourierCKM; norm_num [omega]; ring_nf; norm_num
  grind

/-
Hence CP-violating unitary `3 × 3` mixing matrices exist.
-/
theorem exists_unitary_jarlskog_ne_zero :
    ∃ V : Matrix (Fin 3) (Fin 3) ℂ,
      V ∈ Matrix.unitaryGroup (Fin 3) ℂ ∧ jarlskog V ≠ 0 := by
  grind +suggestions

/-
If the two rows occurring in a quartet are proportional by a phase,
that quartet has zero imaginary part.
-/
theorem jarlskogQuartet_eq_zero_of_rows_phase {n : Type} (V : Matrix n n ℂ)
    (i k j l : n) (t : ℝ) (h : ∀ c, V k c = phase t * V i c) :
    jarlskogQuartet V i k j l = 0 := by
  unfold jarlskogQuartet;
  simp_all +decide [ Complex.ext_iff, phase ];
  ring

/-
The analogous statement for the two columns occurring in a quartet.
-/
theorem jarlskogQuartet_eq_zero_of_cols_phase {n : Type} (V : Matrix n n ℂ)
    (i k j l : n) (t : ℝ) (h : ∀ r, V r l = V r j * phase t) :
    jarlskogQuartet V i k j l = 0 := by
  unfold jarlskogQuartet;
  simp_all +decide [mul_assoc, mul_left_comm, mul_comm, Complex.ext_iff, phase]
  grind

/-
Specialization of row proportionality to the conventional CKM quartet.
-/
theorem jarlskog_eq_zero_of_rows_zero_one_phase (V : Matrix (Fin 3) (Fin 3) ℂ)
    (t : ℝ) (h : ∀ c, V 1 c = phase t * V 0 c) :
    jarlskog V = 0 := by
  convert jarlskogQuartet_eq_zero_of_rows_phase V 0 1 0 1 t h using 1

/-
Specialization of column proportionality to the conventional CKM quartet.
-/
theorem jarlskog_eq_zero_of_cols_zero_one_phase (V : Matrix (Fin 3) (Fin 3) ℂ)
    (t : ℝ) (h : ∀ r, V r 1 = V r 0 * phase t) :
    jarlskog V = 0 := by
  convert jarlskogQuartet_eq_zero_of_cols_phase V 0 1 0 1 t h

end CKM
