import Mathlib

/-!
# One finite model assembling the A3 transfer-mass obligations

This module closes a logical assembly gap left by the separate finite transfer,
observable, and observable-gap linkage modules. One explicit three-state model
simultaneously has:

* a symmetric positive-definite transfer matrix `T = A.transpose * A`;
* a simple top eigenvalue `9` and first excited eigenvalue `4`;
* a nonconstant observable invariant under the stated finite permutation action;
* nonzero overlap of that observable with the first excited eigenspace; and
* the exact normalized correlation law `6 * (4 / 9)^n`.

The resulting finite correlation mass is therefore exactly `log (9 / 4)`.

## Scope

This is a finite proof-of-architecture, not a lattice Yang--Mills theorem. Its
gauge group is `(ZMod 3)ˣ`, a two-element group acting on three states. It does
not construct an `SU(3)` transfer matrix, prove reflection positivity for a
gauge action, take a thermodynamic limit, or derive a QCD mass gap. It proves
that positivity, gap, gauge invariance, and first-excited overlap can coexist in
one nondegenerate finite model.

## Provenance

Aristotle project `43ae3d92-5b5e-4620-b18f-47085022ffa8`, locally rechecked
under the pinned project toolchain on 2026-07-21. The target was prepared from
the A3 obligations isolated in `FiniteTransferPositivity`,
`SU3PlaquetteObservable`, and `ObservableGapLinkage`. Claim grade M, [comp].
-/

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace CompositeMassBridge

noncomputable section

/-- The three-state configuration space. -/
abbrev State := ZMod 3

/-- A nontrivial finite gauge group. Its units act on the three states by
multiplication: zero is fixed and the other two states are permuted. -/
abbrev Gauge := (ZMod 3)ˣ

/-- The stated permutation action of the gauge group on the state space. -/
def gaugeAct (g : Gauge) (s : State) : State := (g : ZMod 3) * s

lemma gaugeAct_one (s : State) : gaugeAct 1 s = s := by
  decide +revert

lemma gaugeAct_mul (g h : Gauge) (s : State) :
    gaugeAct (g * h) s = gaugeAct g (gaugeAct h s) := by
  decide +revert

/-- An orthogonal eigenbasis. `e0` is the vacuum, `e1` is gauge invariant,
and `e2` is gauge odd. -/
def e0 : State → ℝ := fun _ => 1
def e1 : State → ℝ := fun s => if s = 0 then -2 else 1
def e2 : State → ℝ := fun s => if s = 0 then 0 else if s = 1 then 1 else -1

/-- The observable is the first excited eigenvector itself. -/
def observable : State → ℝ := e1

/-- A symmetric square root of the transfer matrix, with eigenvalues 3, 2, 1. -/
def A : Matrix State State ℝ := fun i j =>
  e0 i * e0 j + (1 / 3 : ℝ) * e1 i * e1 j + (1 / 2 : ℝ) * e2 i * e2 j

/-- The transfer matrix, explicitly presented as the Gram matrix `A.transpose * A`. -/
def T : Matrix State State ℝ := A.transpose * A

def inner (x y : State → ℝ) : ℝ := dotProduct x y

lemma gauge_invariance (g : Gauge) (s : State) :
    observable (gaugeAct g s) = observable s := by
  unfold observable gaugeAct
  fin_cases g <;> fin_cases s <;> rfl

lemma eigenbasis_orthogonality :
    inner e0 e0 = 3 ∧ inner e1 e1 = 6 ∧ inner e2 e2 = 2 ∧
    inner e0 e1 = 0 ∧ inner e0 e2 = 0 ∧ inner e1 e2 = 0 := by
  unfold e0 e1 e2 inner
  norm_num [Finset.sum_ite, dotProduct]
  norm_cast

lemma basis_decomposition (x : State → ℝ) :
    x = (inner e0 x / 3) • e0 + (inner e1 x / 6) • e1 +
      (inner e2 x / 2) • e2 := by
  unfold inner e0 e1 e2
  simp +decide [funext_iff, Fin.forall_fin_succ, dotProduct]
  intro i
  erw [Fin.sum_univ_three, Fin.sum_univ_three, Fin.sum_univ_three]
  fin_cases i <;> simp +decide <;> ring!
  · grind
  · grind +qlia

lemma A_symmetric : A.IsSymm := by
  ext i j
  simp +decide [A]
  ring

lemma T_is_gram : T = A.transpose * A := rfl

lemma T_symmetric : T.IsSymm := by
  ext i j
  unfold T
  norm_num [Matrix.mul_apply, mul_comm]

lemma A_eigenvectors :
    A.mulVec e0 = 3 • e0 ∧ A.mulVec e1 = 2 • e1 ∧ A.mulVec e2 = e2 := by
  refine' ⟨_, _, _⟩
  · unfold A e0
    ext i
    norm_num [Matrix.mulVec, dotProduct]
    ring
    fin_cases i <;> norm_num [Fin.sum_univ_succ, e1, e2]
    · rw [Finset.sum_eq_multiset_sum]
      norm_cast
      erw [Multiset.map_coe]
      norm_num
      norm_num [List.finRange]
      grind +qlia
    · rw [show (Finset.univ : Finset (ZMod 3)) = {0, 1, 2} by decide]
      simp +decide
      norm_num
    · erw [Fin.sum_univ_three]
      norm_num [Fin.ext_iff]
      grind
  · ext i
    fin_cases i <;> norm_num [Matrix.mulVec, dotProduct]
    · erw [Fin.sum_univ_three]
      norm_num [e0, e1, e2, A]
      grind +qlia
    · erw [Fin.sum_univ_three]
      norm_num [A, e1]
      simp +decide [e0, e2]
      norm_num
      grind +qlia
    · erw [Fin.sum_univ_three]
      norm_num [A, e1]
      unfold e0 e2
      norm_num [Fin.ext_iff]
      grind +qlia
  · ext x
    fin_cases x <;> unfold A <;> norm_num [Matrix.mulVec, dotProduct]
    · unfold e0 e1 e2
      norm_num [Fin.sum_univ_succ]
      rw [Finset.sum_eq_multiset_sum]
      norm_cast
      erw [Multiset.map_coe]
      norm_num
      norm_num [List.finRange]
      grind +qlia
    · unfold e0 e1 e2
      norm_num [Fin.sum_univ_succ]
      rw [show (Finset.univ : Finset (ZMod 3)) = {0, 1, 2} by decide]
      simp +decide
      norm_num
    · erw [Fin.sum_univ_three]
      norm_num [e0, e1, e2]
      grind

lemma A_injective : Function.Injective A.mulVec := by
  intro x y hxy
  obtain ⟨a0, a1, a2, hx⟩ : ∃ a0 a1 a2 : ℝ, x = a0 • e0 + a1 • e1 + a2 • e2 := by
    exact ⟨_, _, _, basis_decomposition x⟩
  obtain ⟨b0, b1, b2, hy⟩ : ∃ b0 b1 b2 : ℝ, y = b0 • e0 + b1 • e1 + b2 • e2 := by
    exact ⟨_, _, _, basis_decomposition y⟩
  have h_mulVec :
      A.mulVec (a0 • e0 + a1 • e1 + a2 • e2) =
        3 * a0 • e0 + 2 * a1 • e1 + a2 • e2 := by
    simp +decide [A_eigenvectors, Matrix.mulVec_add, Matrix.mulVec_smul]
  have h_mulVec' :
      A.mulVec (b0 • e0 + b1 • e1 + b2 • e2) =
        3 * b0 • e0 + 2 * b1 • e1 + b2 • e2 := by
    simp_all +decide [Matrix.mulVec_add, Matrix.mulVec_smul]
    rw [show A.mulVec e0 = 3 • e0 from A_eigenvectors.1,
      show A.mulVec e1 = 2 • e1 from A_eigenvectors.2.1,
      show A.mulVec e2 = e2 from A_eigenvectors.2.2]
    norm_num [mul_comm]
  simp_all +decide [funext_iff, ZMod, Fin.forall_fin_succ]
  grind +locals

/-- Positive definiteness in the concrete real quadratic-form sense. -/
lemma T_positive_definite (x : State → ℝ) (hx : x ≠ 0) :
    0 < inner x (T.mulVec x) := by
  unfold inner T
  have h_norm :
      x ⬝ᵥ (A.transpose * A).mulVec x = (A.mulVec x) ⬝ᵥ (A.mulVec x) := by
    simp +decide [Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec]
  exact h_norm.symm ▸ lt_of_le_of_ne
    (Finset.sum_nonneg fun _ _ => mul_self_nonneg _)
    (Ne.symm <| by
      intro H
      exact hx <| A_injective <| by
        ext i
        simpa [dotProduct] using
          Finset.sum_eq_zero_iff_of_nonneg
            (fun _ _ => mul_self_nonneg _) |>.1 H i)

lemma T_eigenvectors :
    T.mulVec e0 = 9 • e0 ∧ T.mulVec e1 = 4 • e1 ∧ T.mulVec e2 = e2 := by
  unfold T
  simp +decide [← Matrix.mulVec_mulVec, A_symmetric, A_eigenvectors, smul_smul]
  simp_all +decide [funext_iff, Matrix.mulVec, dotProduct]
  simp +decide [show State = ZMod 3 from rfl, Fin.sum_univ_three, A, e0, e1, e2]
  simp +decide [show (Finset.univ : Finset State) = {0, 1, 2} by rfl,
    Finset.sum] at *
  norm_num at *
  exact ⟨fun x => by split_ifs <;> norm_num,
    fun x => by split_ifs <;> norm_num,
    fun x => by split_ifs <;> norm_num⟩

/-- Every vector lies in the displayed three one-dimensional spectral subspaces. -/
lemma spectral_resolution (x : State → ℝ) :
    T.mulVec x = 9 * (inner e0 x / 3) • e0 +
      4 * (inner e1 x / 6) • e1 + (inner e2 x / 2) • e2 := by
  convert congr_arg (fun t : State → ℝ => T.mulVec t) (basis_decomposition x) using 1
  rw [Matrix.mulVec_add, Matrix.mulVec_add, Matrix.mulVec_smul,
    Matrix.mulVec_smul, Matrix.mulVec_smul]
  rw [T_eigenvectors.1, T_eigenvectors.2.1, T_eigenvectors.2.2]
  norm_num [mul_assoc, mul_left_comm, smul_smul]

lemma top_eigenvalue_nondegenerate (x : State → ℝ)
    (hx : T.mulVec x = 9 • x) : ∃ c : ℝ, x = c • e0 := by
  have h_spectral := spectral_resolution x
  have h_coeff : inner e1 x = 0 ∧ inner e2 x = 0 := by
    simp_all +decide [funext_iff, State]
    simp_all +decide [show (Finset.univ : Finset (ZMod 3)) = {0, 1, 2} by decide, inner]
    simp_all +decide [show (Finset.univ : Finset (ZMod 3)) = {0, 1, 2} by decide,
      dotProduct, e0, e1, e2]
    grind
  simp_all +decide [mul_comm, mul_assoc, mul_left_comm]
  exact ⟨inner e0 x / 3, by
    ext i
    have := congr_fun hx i
    norm_num at *
    linarith⟩

lemma second_eigenvalue_nondegenerate (x : State → ℝ)
    (hx : T.mulVec x = 4 • x) : ∃ c : ℝ, x = c • e1 := by
  have hx_decomp := basis_decomposition x
  have hx_t := spectral_resolution x
  have h_eq :
      9 * (inner e0 x / 3) • e0 + 4 * (inner e1 x / 6) • e1 +
          (inner e2 x / 2) • e2 =
        4 • ((inner e0 x / 3) • e0 + (inner e1 x / 6) • e1 +
          (inner e2 x / 2) • e2) := by
    rw [← hx_t, hx, ← hx_decomp]
  have h_coeff : inner e0 x = 0 ∧ inner e2 x = 0 := by
    have h0 := congr_fun h_eq 0
    have h1 := congr_fun h_eq 1
    have h2 := congr_fun h_eq 2
    norm_num [e0, e1, e2] at *
    exact ⟨by linarith, by linarith⟩
  exact ⟨inner e1 x / 6, by simpa [h_coeff] using hx_decomp⟩

lemma explicit_spectral_order : (1 : ℝ) < 4 ∧ (4 : ℝ) < 9 := by norm_num

lemma explicit_spectral_gap : (4 : ℝ) < 9 := explicit_spectral_order.2

lemma first_excited_overlap : inner e1 observable = 6 ∧ inner e1 observable ≠ 0 := by
  unfold inner observable e1
  norm_num [dotProduct]
  norm_cast

/-- Vacuum-subtracted, vacuum-normalized two-point function. -/
def connectedCorrelation (n : ℕ) : ℝ :=
  (9 : ℝ)⁻¹ ^ n * inner observable ((T ^ n).mulVec observable)

lemma transfer_power_on_observable (n : ℕ) :
    (T ^ n).mulVec observable = (4 : ℝ) ^ n • observable := by
  induction n <;> simp_all +decide [pow_succ', Matrix.mulVec_smul]
  simp_all +decide [← Matrix.mulVec_mulVec, ← smul_assoc]
  rw [Matrix.mulVec_smul,
    show T.mulVec observable = 4 • observable from ?_]
  ring
  · ext
    norm_num
    ring
  · convert T_eigenvectors.2.1 using 1

/-- Before vacuum normalization, the connected spectral contribution decays
exactly with the first-excited transfer eigenvalue `4`. -/
lemma unnormalized_connected_exact (n : ℕ) :
    inner observable ((T ^ n).mulVec observable) = 6 * (4 : ℝ) ^ n := by
  have h := transfer_power_on_observable n
  simp_all +decide [inner]
  convert congr_arg (fun x : ℝ => x * 4 ^ n) first_excited_overlap.1 using 1
  ring!

/-- The exact normalized connected-correlation law for the explicit model. -/
lemma connectedCorrelation_exact (n : ℕ) :
    connectedCorrelation n = 6 * ((4 : ℝ) / 9) ^ n := by
  have h_inner :
      inner observable ((T ^ n).mulVec observable) =
        (4 : ℝ) ^ n * inner observable observable := by
    convert congr_arg (fun x => inner observable x)
      (transfer_power_on_observable n) using 1
    unfold inner
    norm_num [dotProduct, Finset.mul_sum _ _ _]
    ring
  unfold connectedCorrelation
  rw [h_inner]
  ring
  rw [show inner observable observable = 6 by exact first_excited_overlap.1]
  norm_num [mul_assoc, ← mul_pow]
  ring

/-- The finite correlation mass is the log ratio of the vacuum and first-excited
transfer eigenvalues. -/
def correlationMass : ℝ := Real.log ((9 : ℝ) / 4)

lemma correlation_mass_exact : correlationMass = Real.log ((9 : ℝ) / 4) := rfl

/-- One theorem collecting all A3 obligations for the same explicit finite model. -/
theorem one_model_discharges_all_A3 :
    T = A.transpose * A ∧ Function.Injective A.mulVec ∧ T.IsSymm ∧
    (∀ x : State → ℝ, x ≠ 0 → 0 < inner x (T.mulVec x)) ∧
    T.mulVec e0 = 9 • e0 ∧ T.mulVec e1 = 4 • e1 ∧
    (∀ x : State → ℝ, T.mulVec x = 9 • x → ∃ c : ℝ, x = c • e0) ∧
    (4 : ℝ) < 9 ∧
    (∀ g : Gauge, ∀ s : State, observable (gaugeAct g s) = observable s) ∧
    inner e1 observable ≠ 0 ∧
    (∀ n : ℕ, connectedCorrelation n = 6 * ((4 : ℝ) / 9) ^ n) ∧
    correlationMass = Real.log ((9 : ℝ) / 4) := by
  refine' ⟨T_is_gram, A_injective, T_symmetric, _, _, _, _, _⟩
  · exact T_positive_definite
  · exact T_eigenvectors.1
  · exact T_eigenvectors.2.1
  · convert top_eigenvalue_nondegenerate using 1
  · exact ⟨by norm_num, gauge_invariance, first_excited_overlap.2,
      connectedCorrelation_exact, correlation_mass_exact⟩

end

end CompositeMassBridge
