import Mathlib

set_option linter.unusedSimpArgs false

/-!
# Goal II finite Kobayashi-Maskawa CP phase package

This draft module ports the verified finite-KM seed returned by Aristotle. It
contains a concrete rephasing-invariant Jarlskog plaquette, the `N = 2` no-go,
an exact `N = 3` nonzero Jarlskog witness, and the first arithmetic boundary of
the general phase count.

Honest scope:

* Landed here: finite plaquette invariance, `N = 2` no-go in invariant and
  constructive rephasing-to-real forms, and a genuinely unitary `3-4-5` witness
  with exact `J = 6912 / 78125`.
* Not landed here: the full general-`N` integer incidence/corank theorem saying
  the phase lattice has corank `(N - 1) * (N - 2) / 2`.

Provenance: clean-room port of the Aristotle return from
`codex-goalII-finiteKM-strategy-20260709`
(`0a3009c4-e9fa-4ff9-9ab0-401a48725573`,
`RequestProject/FiniteKM.lean`).
-/

open scoped BigOperators Matrix
open Complex

namespace FiniteKM

noncomputable section

/-! ## Core invariants and rephasing action -/

/-- The plaquette/Jarlskog-type quartet of a mixing matrix on a `2 x 2` minor. -/
def plaquette {n : ℕ} (V : Matrix (Fin n) (Fin n) ℂ) (i j k l : Fin n) : ℝ :=
  (V i k * V j l * (starRingEnd ℂ) (V i l) * (starRingEnd ℂ) (V j k)).im

/-- The Jarlskog invariant `J = Im(V00 V11 conj V01 conj V10)`. -/
def jarlskog {n : ℕ} [NeZero n] (V : Matrix (Fin n) (Fin n) ℂ) : ℝ :=
  plaquette V 0 1 0 1

/-- A rephasing vector: one unit complex phase per index. -/
def IsPhase {n : ℕ} (d : Fin n → ℂ) : Prop := ∀ i, ‖d i‖ = 1

/-- The rephasing action, written entrywise. -/
def rephase {n : ℕ} (dL dR : Fin n → ℂ) (V : Matrix (Fin n) (Fin n) ℂ) :
    Matrix (Fin n) (Fin n) ℂ := fun i j => dL i * V i j * dR j

/-! ## Rephasing invariance of plaquettes -/

/-- Every plaquette is invariant under rephasing by unit phases. -/
theorem plaquette_rephase {n : ℕ} (dL dR : Fin n → ℂ)
    (hL : IsPhase dL) (hR : IsPhase dR) (V : Matrix (Fin n) (Fin n) ℂ)
    (i j k l : Fin n) :
    plaquette (rephase dL dR V) i j k l = plaquette V i j k l := by
  have h_rephased_product : ∀ i j k l,
      (dL i * V i k * dR k) * (dL j * V j l * dR l)
        * (starRingEnd ℂ (dL i * V i l * dR l))
        * (starRingEnd ℂ (dL j * V j k * dR k))
      = V i k * V j l * (starRingEnd ℂ (V i l)) * (starRingEnd ℂ (V j k)) := by
    intros i j k l
    have h_dL : dL i * starRingEnd ℂ (dL i) = 1 := by
      simp +decide [Complex.mul_conj, Complex.normSq_eq_norm_sq, hL i]
    have h_dR : dR k * starRingEnd ℂ (dR k) = 1 := by
      simp +decide [Complex.mul_conj, Complex.normSq_eq_norm_sq, hR k]
    have h_dL_j : dL j * starRingEnd ℂ (dL j) = 1 := by
      simp +decide [Complex.mul_conj, Complex.normSq_eq_norm_sq, hL j]
    have h_dR_l : dR l * starRingEnd ℂ (dR l) = 1 := by
      simp +decide [Complex.mul_conj, Complex.normSq_eq_norm_sq, hR l]
    simp [h_dL, h_dR, h_dL_j, h_dR_l]
    grind
  convert congr_arg Complex.im (h_rephased_product i j k l) using 1

/-- The Jarlskog invariant is invariant under rephasing. -/
theorem jarlskog_rephase {n : ℕ} [NeZero n] (dL dR : Fin n → ℂ)
    (hL : IsPhase dL) (hR : IsPhase dR) (V : Matrix (Fin n) (Fin n) ℂ) :
    jarlskog (rephase dL dR V) = jarlskog V :=
  plaquette_rephase dL dR hL hR V 0 1 0 1

/-! ## N = 2 no-go -/

/--
Invariant form of the `N = 2` no-go: for any unitary `2 x 2` matrix, the
Jarlskog invariant vanishes.
-/
theorem jarlskog_two_eq_zero (V : Matrix (Fin 2) (Fin 2) ℂ) (hV : Vᴴ * V = 1) :
    jarlskog V = 0 := by
  unfold jarlskog
  have h_rel : (starRingEnd ℂ) (V 0 0) * V 0 1
      = - (starRingEnd ℂ) (V 1 0) * V 1 1 := by
    have := congr_arg (fun m : Matrix _ _ ℂ => m 0 1) hV
    norm_num [Fin.sum_univ_succ, Matrix.mul_apply] at this
    linear_combination' this
  unfold plaquette
  simp_all +decide [Complex.ext_iff]
  grind

/--
Constructive `N = 2` no-go: every unitary `2 x 2` matrix is rephasing-equivalent
to a matrix with all entries real.
-/
theorem exists_real_rephasing_two (V : Matrix (Fin 2) (Fin 2) ℂ) (hV : Vᴴ * V = 1) :
    ∃ dL dR : Fin 2 → ℂ, IsPhase dL ∧ IsPhase dR ∧
      ∀ i j, ((rephase dL dR V) i j).im = 0 := by
  unfold IsPhase
  by_cases h00 : V 0 0 = 0 <;> by_cases h01 : V 0 1 = 0 <;>
    simp_all +decide [Complex.ext_iff, Fin.forall_fin_two]
  · simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_two, Complex.ext_iff, mul_assoc,
      Matrix.mul_apply]
    grind +splitIndPred
  · simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply]
    simp_all +decide [Complex.ext_iff, Matrix.mul_apply, rephase]
    refine' ⟨fun i => if i = 0 then 1 else ⟨(V 1 0 |> Complex.re), - (V 1 0 |> Complex.im)⟩,
      _, fun i => if i = 0 then 1 else ⟨(V 0 1 |> Complex.re), - (V 0 1 |> Complex.im)⟩,
      _, _, _, _⟩ <;> simp +decide [*, Complex.normSq, Complex.norm_def]
    · grind
    · ring
  · simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_two, Complex.ext_iff,
      Matrix.mul_apply]
    unfold rephase
    simp_all +decide [Complex.normSq, Complex.norm_def]
    refine' ⟨fun i => if i = 0 then 1 else ⟨(V 1 1 |> Complex.re), - (V 1 1 |> Complex.im)⟩,
      _, fun i => if i = 0 then ⟨(V 0 0 |> Complex.re), - (V 0 0 |> Complex.im)⟩ else 1,
      _, _, _, _⟩ <;> simp +decide [Complex.ext_iff]
    · linarith
    · grind
    · ring
    · aesop
    · linarith
  · refine' ⟨fun i => if i = 0 then 1 else
        (starRingEnd ℂ (V 1 0 * (starRingEnd ℂ (V 0 0) / ‖V 0 0‖)))
          / ‖starRingEnd ℂ (V 1 0 * (starRingEnd ℂ (V 0 0) / ‖V 0 0‖))‖,
      _,
      fun i => if i = 0 then (starRingEnd ℂ (V 0 0) / ‖V 0 0‖)
        else (starRingEnd ℂ (V 0 1) / ‖V 0 1‖),
      _, _, _⟩ <;> simp_all +decide [Fin.forall_fin_two, rephase]
    · constructor <;> intro h <;> simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_two]
      simp_all +decide [Matrix.mul_apply, Complex.ext_iff]
      grind
    · exact ⟨by contrapose! h00; simp_all +decide [Complex.ext_iff],
        by contrapose! h01; simp_all +decide [Complex.ext_iff]⟩
    · ring_nf
      aesop
    · simp_all +decide [Complex.normSq_eq_norm_sq, Complex.div_re, Complex.div_im,
        Complex.mul_re, Complex.mul_im, Complex.conj_re, Complex.conj_im]
      have := jarlskog_two_eq_zero V hV
      simp_all +decide [jarlskog, plaquette]
      grobner

/-! ## N = 3 exact witness -/

/-- The cosine `c = 4/5`. -/
def cW : ℂ := ((4 / 5 : ℝ) : ℂ)

/-- The sine `s = 3/5`. -/
def sW : ℂ := ((3 / 5 : ℝ) : ℂ)

/--
The concrete `N = 3` witness `V = R23 * U13(delta = pi/2) * R12` with all
mixing angles at `(c,s) = (4/5, 3/5)`.
-/
def Vwitness : Matrix (Fin 3) (Fin 3) ℂ :=
  !![ cW ^ 2, cW * sW, -Complex.I * sW;
      -cW * sW - Complex.I * cW * sW ^ 2, cW ^ 2 - Complex.I * sW ^ 3, sW * cW;
      sW ^ 2 - Complex.I * cW ^ 2 * sW, -sW * cW - Complex.I * cW * sW ^ 2, cW ^ 2]

/-- The `3-4-5` witness is unitary. -/
theorem Vwitness_unitary : Vwitnessᴴ * Vwitness = 1 := by
  ext i j
  simp +decide [Matrix.mul_apply]
  fin_cases i <;> fin_cases j <;> norm_num [Complex.ext_iff, pow_two]
  all_goals
    unfold Vwitness
    norm_num [Fin.sum_univ_succ, cW, sW]

/-- The Jarlskog invariant of the witness is the exact nonzero rational `6912 / 78125`. -/
theorem jarlskog_Vwitness : jarlskog Vwitness = 6912 / 78125 := by
  have e00 : Vwitness 0 0 = cW ^ 2 := rfl
  have e11 : Vwitness 1 1 = cW ^ 2 - Complex.I * sW ^ 3 := rfl
  have e01 : Vwitness 0 1 = cW * sW := rfl
  have e10 : Vwitness 1 0 = -cW * sW - Complex.I * cW * sW ^ 2 := rfl
  simp only [jarlskog, plaquette, e00, e11, e01, e10, cW, sW,
    map_sub, map_mul, map_pow, map_neg, Complex.conj_I, Complex.conj_ofReal]
  norm_num [Complex.mul_im, Complex.mul_re, Complex.add_im, Complex.add_re,
    Complex.sub_im, Complex.sub_re, Complex.I_im, Complex.I_re,
    Complex.ofReal_im, Complex.ofReal_re, Complex.neg_im, Complex.neg_re]

/-- Nondegeneracy gate: the witness has genuine CP violation, `J != 0`. -/
theorem jarlskog_Vwitness_ne_zero : jarlskog Vwitness ≠ 0 := by
  rw [jarlskog_Vwitness]
  norm_num

/-! ## Arithmetic boundary of the count -/

/-- The number of edges of the complete graph `K_N`, as `N.choose 2`. -/
def numEdges (N : ℕ) : ℕ := N.choose 2

/-- The physical CP-phase count. -/
def physicalPhases (N : ℕ) : ℕ := (N - 1) * (N - 2) / 2

/--
Arithmetic count identity: `#edges(K_N) - (N - 1) = (N - 1)(N - 2)/2`.
The graph-incidence corank theorem explaining this identity is future work.
-/
theorem physicalPhases_eq (N : ℕ) :
    physicalPhases N = numEdges N - (N - 1) := by
  unfold numEdges
  unfold physicalPhases
  rcases N with (_ | _ | N) <;> simp_all +decide [Nat.choose_two_right]
  grind +splitImp

/-- `N = 2`: zero physical phases, consistent with the no-go. -/
theorem physicalPhases_two : physicalPhases 2 = 0 := by decide

/-- `N = 3`: exactly one physical phase, realized by the Jarlskog witness. -/
theorem physicalPhases_three : physicalPhases 3 = 1 := by decide

end

end FiniteKM

/-! ## Axiom audit (build-enforced guard pin) -/

/-- info: 'FiniteKM.plaquette_rephase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.plaquette_rephase

/-- info: 'FiniteKM.jarlskog_rephase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.jarlskog_rephase

/-- info: 'FiniteKM.jarlskog_two_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.jarlskog_two_eq_zero

/-- info: 'FiniteKM.exists_real_rephasing_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.exists_real_rephasing_two

/-- info: 'FiniteKM.Vwitness_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.Vwitness_unitary

/-- info: 'FiniteKM.jarlskog_Vwitness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.jarlskog_Vwitness

/-- info: 'FiniteKM.jarlskog_Vwitness_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.jarlskog_Vwitness_ne_zero

/-- info: 'FiniteKM.physicalPhases_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FiniteKM.physicalPhases_eq
