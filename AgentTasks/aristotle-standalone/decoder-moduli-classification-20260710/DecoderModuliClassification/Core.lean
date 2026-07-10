import Mathlib

/-!
# Complete decoder moduli for the three-state nilpotent carrier

For the explicit differential `Q = E_01`, classify every complex `3 x 3`
decoder commuting with `Q`.  The target proves that four normal-form
coordinates are exactly presentation gauge of the form `Q R + R Q`, while the
remaining coordinate is the action on the one-dimensional cohomology class.

This is finite matrix algebra.  It does not claim that every finite carrier has
one-dimensional moduli or that this witness classifies a continuum theory.
-/

noncomputable section

open Matrix Complex

namespace DecoderModuliClassification

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- The nilpotent constraint differential of the positive-Hodge witness. -/
def Q : Mat3 := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

def CommutesQ (D : Mat3) : Prop := D * Q = Q * D

def exactDeformation (R : Mat3) : Mat3 := Q * R + R * Q

def ChainHomotopic (D D' : Mat3) : Prop :=
  exists R, D' = D + exactDeformation R

/-- Complete five-coordinate normal form for a chain-map decoder. -/
def normalForm (a b c h mu : Complex) : Mat3 :=
  !![a, b, c; 0, a, 0; 0, h, mu]

/-- The coordinate acting on the surviving `e_2` cohomology class. -/
def physicalEigenvalue (D : Mat3) : Complex := D 2 2

lemma commutesQ_iff (D : Mat3) :
    CommutesQ D ↔ D 1 0 = 0 ∧ D 2 0 = 0 ∧ D 1 2 = 0 ∧ D 0 0 = D 1 1 := by
  unfold CommutesQ
  rw [<- Matrix.ext_iff]
  constructor
  · intro h
    refine ⟨?_, ?_, ?_, ?_⟩
    · have hx := h 1 1
      simp [Q, Matrix.mul_apply, Fin.sum_univ_three] at hx
      linear_combination hx
    · have hx := h 2 1
      simp [Q, Matrix.mul_apply, Fin.sum_univ_three] at hx
      linear_combination hx
    · have hx := h 0 2
      simp [Q, Matrix.mul_apply, Fin.sum_univ_three] at hx
      linear_combination -hx
    · have hx := h 0 1
      simp [Q, Matrix.mul_apply, Fin.sum_univ_three] at hx
      linear_combination hx
  · rintro ⟨h1, h2, h3, h4⟩ i j
    fin_cases i <;> fin_cases j <;>
      simp [Q, Matrix.mul_apply, Fin.sum_univ_three, h1, h2, h3, h4]

@[simp] lemma physicalEigenvalue_normalForm (a b c h mu : Complex) :
    physicalEigenvalue (normalForm a b c h mu) = mu := by
  simp [physicalEigenvalue, normalForm]

lemma exactDeformation_apply_22 (R : Mat3) :
    (exactDeformation R) 2 2 = 0 := by
  simp [exactDeformation, Q, Matrix.mul_apply, Fin.sum_univ_three,
    Matrix.add_apply, Matrix.vecMul, dotProduct, Matrix.cons_val]

lemma commutesQ_exactDeformation (R : Mat3) :
    CommutesQ (exactDeformation R) := by
  rw [commutesQ_iff]
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    simp [exactDeformation, Q, Matrix.mul_apply, Fin.sum_univ_three,
      Matrix.add_apply, Matrix.vecMul, dotProduct, Matrix.cons_val]

lemma exactDeformation_normalForm (a b c h : Complex) :
    exactDeformation (!![b, 0, 0; a, 0, c; h, 0, 0]) =
      normalForm a b c h 0 := by
  apply Matrix.ext
  intro i j
  fin_cases i <;> fin_cases j <;>
    simp [exactDeformation, Q, normalForm, Matrix.add_apply]

/-- Target 1: every commuting decoder, and only such a decoder, has the
displayed five-coordinate normal form. -/
theorem commutes_iff_normalForm (D : Mat3) :
    CommutesQ D ↔
      exists a b c h mu, D = normalForm a b c h mu := by
  rw [commutesQ_iff]
  constructor
  · rintro ⟨h1, h2, h3, h4⟩
    refine ⟨D 0 0, D 0 1, D 0 2, D 2 1, D 2 2, ?_⟩
    apply Matrix.ext
    intro i j
    fin_cases i <;> fin_cases j <;>
      simp [normalForm] <;>
      first
        | rfl
        | exact h1
        | exact h2
        | exact h3
        | exact h4
        | exact h4.symm
  · rintro ⟨a, b, c, h, mu, rfl⟩
    refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [normalForm]

/-- Target 2: exact presentation deformations are precisely the commuting
decoders with zero physical coordinate. -/
theorem exact_iff_commutes_and_physical_zero (D : Mat3) :
    (exists R, exactDeformation R = D) ↔
      CommutesQ D ∧ physicalEigenvalue D = 0 := by
  constructor
  · rintro ⟨R, rfl⟩
    exact ⟨commutesQ_exactDeformation R, exactDeformation_apply_22 R⟩
  · rintro ⟨hcomm, hphys⟩
    obtain ⟨a, b, c, h, mu, rfl⟩ := (commutes_iff_normalForm D).mp hcomm
    rw [physicalEigenvalue_normalForm] at hphys
    subst hphys
    exact ⟨_, exactDeformation_normalForm a b c h⟩

/-- Target 3: on the full commuting-decoder space, the physical eigenvalue is
a complete invariant of chain-homotopy classes. -/
theorem chainHomotopic_iff_physicalEigenvalue_eq
    (D D' : Mat3) (hD : CommutesQ D) (hD' : CommutesQ D') :
    ChainHomotopic D D' ↔
      physicalEigenvalue D' = physicalEigenvalue D := by
  constructor
  · rintro ⟨R, rfl⟩
    simp [physicalEigenvalue, Matrix.add_apply, exactDeformation_apply_22 R]
  · intro hphys
    have hdiff_comm : CommutesQ (D' - D) := by
      unfold CommutesQ at hD hD' ⊢
      rw [Matrix.sub_mul, Matrix.mul_sub, hD, hD']
    have hdiff_phys : physicalEigenvalue (D' - D) = 0 := by
      simp only [physicalEigenvalue, Matrix.sub_apply]
      rw [show D' 2 2 = D 2 2 from hphys, sub_self]
    obtain ⟨R, hR⟩ :=
      (exact_iff_commutes_and_physical_zero (D' - D)).mpr
        ⟨hdiff_comm, hdiff_phys⟩
    exact ⟨R, by rw [hR]; abel⟩

/-- Target 4: every commuting decoder is chain-homotopic to the unique
one-coordinate representative supported on the physical class. -/
theorem canonical_representative (D : Mat3) (hD : CommutesQ D) :
    ChainHomotopic D (normalForm 0 0 0 0 (physicalEigenvalue D)) := by
  have hcomm' : CommutesQ
      (normalForm 0 0 0 0 (physicalEigenvalue D)) := by
    rw [commutesQ_iff]
    refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [normalForm]
  rw [chainHomotopic_iff_physicalEigenvalue_eq D _ hD hcomm']
  simp

/-- Target 5: same-physical-mass presentations can be genuinely distinct yet
equivalent, whereas changing the physical mass leaves the equivalence class. -/
theorem nondegenerate_moduli_controls :
    normalForm 0 0 0 0 2 ≠ normalForm 1 3 4 5 2 ∧
      ChainHomotopic (normalForm 0 0 0 0 2) (normalForm 1 3 4 5 2) ∧
      ¬ ChainHomotopic (normalForm 0 0 0 0 2) (normalForm 0 0 0 0 3) := by
  have hc0 : CommutesQ (normalForm 0 0 0 0 2) := by
    rw [commutesQ_iff]
    refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [normalForm]
  have hc1 : CommutesQ (normalForm 1 3 4 5 2) := by
    rw [commutesQ_iff]
    refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [normalForm]
  have hc2 : CommutesQ (normalForm 0 0 0 0 3) := by
    rw [commutesQ_iff]
    refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [normalForm]
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have h01 := congrArg (fun M => M 0 1) h
    simp [normalForm] at h01
  · rw [chainHomotopic_iff_physicalEigenvalue_eq _ _ hc0 hc1]
    simp
  · rw [chainHomotopic_iff_physicalEigenvalue_eq _ _ hc0 hc2]
    simp only [physicalEigenvalue_normalForm]
    norm_num

end DecoderModuliClassification
