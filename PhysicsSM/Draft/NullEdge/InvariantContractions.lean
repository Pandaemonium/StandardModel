import Mathlib

/-!
# Invariant-tensor uniqueness for finite Yukawa contractions

This module classifies the actual invariant tensors for the weak `SU(2)` and
color `SU(3)` fundamental representations in concrete finite matrix form.
Every invariant weak bilinear form is a unique scalar multiple of the standard
alternating tensor, and every color endomorphism commuting with the fundamental
`SU(3)` action is a unique scalar multiple of the identity.

The physical consequence is deliberately scoped: once a one-generation
Yukawa channel has the legal representation and hypercharge pattern, gauge
symmetry fixes its weak and color contractions up to scalar coefficients. It
does not select those Yukawa coefficients, classify flavor matrices, or prove
that these are all Standard Model mass mechanisms.

Provenance: target statements prepared in the AFPL origin-of-mass lane; proofs
returned by Aristotle project `7c70f6e1-5a0f-4d8d-a549-86b3ef4f8a9f`
(task `89283a17-26eb-4e43-adbd-91a689c003c1`) and replayed locally under Lean
4.28, July 20, 2026.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.InvariantContractions

noncomputable section

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex
abbrev M3 := Matrix (Fin 3) (Fin 3) Complex

/-- Standard alternating tensor on the weak doublet. -/
def epsilon2 : M2 := !![0, 1; -1, 0]

/-- Concrete `SU(2)` matrix predicate used by the classification. -/
def IsSU2 (U : M2) : Prop := Uᴴ * U = 1 ∧ U.det = 1

/-- A bilinear-form matrix invariant under the fundamental `SU(2)` action. -/
def IsSU2InvariantForm (A : M2) : Prop :=
  ∀ U : M2, IsSU2 U → U.transpose * A * U = A

/-- Determinant covariance of the alternating two-dimensional tensor. -/
theorem transpose_epsilon_mul (U : M2) :
    U.transpose * epsilon2 * U = U.det • epsilon2 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [Matrix.mul_apply, Matrix.det_fin_two, epsilon2] <;> ring

/-- The standard alternating tensor is `SU(2)` invariant. -/
theorem epsilon2_invariant : IsSU2InvariantForm epsilon2 := by
  exact fun U hU => by
    rw [transpose_epsilon_mul U, hU.2, one_smul]

/-- **Weak-contraction classification.** Every bilinear form invariant under
the fundamental `SU(2)` action is a unique scalar multiple of `epsilon2`. -/
theorem su2_invariant_form_iff (A : M2) :
    IsSU2InvariantForm A ↔
      ∃ c : Complex,
        A = c • epsilon2 ∧
          ∀ d : Complex, A = d • epsilon2 → d = c := by
  constructor;
  · intro hA
    obtain ⟨c, hc⟩ : ∃ c : Complex, A = c • epsilon2 := by
      obtain ⟨c, hc⟩ : ∃ c : Complex,
          A 0 1 = c ∧ A 1 0 = -c ∧ A 0 0 = 0 ∧ A 1 1 = 0 := by
        have := hA
          (Matrix.diagonal
            (fun i => if i = 0 then Complex.I else -Complex.I)) ?_ <;>
          norm_num [Matrix.mul_apply, Matrix.det_fin_two] at *;
        · have := hA
            (Matrix.of fun i j =>
              if i = 0 ∧ j = 1 then -1
              else if i = 1 ∧ j = 0 then 1 else 0) ?_ <;>
            norm_num [← Matrix.ext_iff, Fin.forall_fin_two,
              Matrix.mul_apply] at *;
          · grind +suggestions;
          · constructor <;>
              norm_num [← Matrix.ext_iff, Fin.forall_fin_two,
                Matrix.mul_apply, Matrix.det_fin_two];
        · constructor <;>
            norm_num [← Matrix.ext_iff, Fin.forall_fin_two,
              Matrix.mul_apply, Matrix.conjTranspose];
      exact ⟨c, by
        ext i j
        fin_cases i <;> fin_cases j <;>
          simp +decide [hc, epsilon2]⟩;
    simpa [hc, epsilon2] using
      congr_arg (fun m : Matrix _ _ Complex => m 0 1) hd.symm
  · rintro ⟨c, rfl, hc⟩ U hU
    simp +decide [hU.2, transpose_epsilon_mul]

/-- Concrete `SU(3)` matrix predicate used by the color classification. -/
def IsSU3 (U : M3) : Prop := Uᴴ * U = 1 ∧ U.det = 1

/-- A color endomorphism commuting with the fundamental `SU(3)` action. -/
def IsSU3Equivariant (A : M3) : Prop :=
  ∀ U : M3, IsSU3 U → U * A = A * U

/-- **Color-contraction classification.** Every endomorphism commuting with
the fundamental `SU(3)` action is a unique scalar multiple of the identity. -/
theorem su3_equivariant_iff (A : M3) :
    IsSU3Equivariant A ↔
      ∃ c : Complex,
        A = c • (1 : M3) ∧
          ∀ d : Complex, A = d • (1 : M3) → d = c := by
  constructor;
  · intro hA
    have h_comm : ∀ U : M3, IsSU3 U → U * A = A * U := by
      exact hA;
    set D0 : M3 := Matrix.diagonal
      ![(-1 : Complex), (-1 : Complex), (1 : Complex)]
    set D1 : M3 := Matrix.diagonal
      ![(-1 : Complex), (1 : Complex), (-1 : Complex)];
    have h_diag : ∀ i j : Fin 3, i ≠ j → A i j = 0 := by
      have h_diag : D0 * A = A * D0 ∧ D1 * A = A * D1 := by
        refine' ⟨h_comm D0 _, h_comm D1 _⟩ <;> constructor <;>
          norm_num [Matrix.mul_apply, Matrix.det_fin_three];
        · ext i j
          fin_cases i <;> fin_cases j <;> norm_num [D0];
        · simp +zetaDelta at *;
        · ext i j
          fin_cases i <;> fin_cases j <;>
            norm_num [Matrix.mul_apply, Matrix.conjTranspose];
          all_goals simp +decide [D1, Fin.sum_univ_three];
        · simp +zetaDelta at *;
      simp_all +decide [Fin.forall_fin_succ, ← Matrix.ext_iff];
      simp +zetaDelta at *;
      grind;
    have h_scalar : A 0 0 = A 1 1 ∧ A 1 1 = A 2 2 := by
      set P : M3 := !![0, 0, 1; 1, 0, 0; 0, 1, 0];
      have hP : IsSU3 P := by
        constructor <;>
          norm_num [← List.ofFn_inj, Matrix.mul_apply,
            Matrix.det_fin_three];
        · ext i j
          fin_cases i <;> fin_cases j <;>
            norm_num [Matrix.mul_apply, Fin.sum_univ_succ];
          all_goals simp +decide [P];
        · simp +zetaDelta at *;
      have := congr_fun (congr_fun (h_comm P hP) 0) 2
      have := congr_fun (congr_fun (h_comm P hP) 1) 0
      have := congr_fun (congr_fun (h_comm P hP) 2) 1
      simp_all +decide [Matrix.mul_apply, Fin.sum_univ_three];
      simp +zetaDelta at *;
      tauto;
    refine' ⟨A 0 0, _, _⟩ <;>
      simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_succ];
  · simp +contextual [IsSU3Equivariant]

/-- Nondegenerate controls for the two canonical contractions. -/
theorem canonical_contractions_nonzero :
    epsilon2 ≠ 0 ∧ (1 : M3) ≠ 0 := by
  exact ⟨ne_of_apply_ne (fun m => m 0 1) one_ne_zero,
    ne_of_apply_ne (fun m => m 0 0) one_ne_zero⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantContractions.su2_invariant_form_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms su2_invariant_form_iff

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantContractions.su3_equivariant_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms su3_equivariant_iff

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantContractions.canonical_contractions_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonical_contractions_nonzero

end

end PhysicsSM.Draft.NullEdge.InvariantContractions
