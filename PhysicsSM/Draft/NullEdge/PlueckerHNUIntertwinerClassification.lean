/-
# Classification of the live Pluecker--HNU Clifford intertwiners

This module classifies every `4 x 2` matrix satisfying the two exact Clifford
intertwining equations used by `PlueckerHNUIntertwiner`.  Unlike the standalone
Aristotle package, this live port imports and reuses the repository definitions
of `beta`, `beta5`, `pauli1`, `pauli2`, and `W` directly.

The result is deliberately a non-selection theorem.  The solution space is
two-dimensional over `Complex`; normalization cuts out the coefficient sphere
`normSq a + normSq b = 1`.  Thus the Clifford equations and normalization do
not select the particular live embedding `W`.  No physical selection principle,
mass value, continuum limit, or chirality-isolation claim follows.

Provenance: clean-room live-import port of Aristotle project
`f0d38cd0-cdec-46ef-800b-b588e3e07740`, task
`82733834-727d-44b0-aea0-fca3042df1a5`.  The exact live conventions are those
of `PlueckerHNUIntertwiner` and `Pluecker3Plus1ComplexMass`.
-/
import PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification

open PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner
open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass
open PhysicsSM.Draft.NullEdge.HNUExactCore

/-- The `2 x 2` complex matrices. -/
abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- A second intertwiner, supported on the odd pair of four-component rows. -/
def Wodd : Matrix (Fin 4) (Fin 2) Complex :=
  !![0, 0; 1, 1; 0, 0; -1, 1]

/-- `Wodd` intertwines the first Clifford generator with the first Pauli matrix. -/
theorem beta_Wodd : beta * Wodd = Wodd * pauli1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [beta, Wodd, pauli1, σ1, Matrix.mul_apply, Fin.sum_univ_four]

/-- `Wodd` intertwines the second Clifford generator with minus the second
Pauli matrix. -/
theorem beta5_Wodd : beta5 * Wodd = -(Wodd * pauli2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [beta5, beta, gamma5, Wodd, pauli2, σ2, Matrix.mul_apply,
      Fin.sum_univ_four]

/-- Every live Clifford intertwiner is a unique linear combination of `W` and
`Wodd`, with coefficients visible in entries `(0,0)` and `(1,0)`. -/
theorem intertwiner_decomp (J : Matrix (Fin 4) (Fin 2) Complex)
    (h1 : beta * J = J * pauli1) (h2 : beta5 * J = -(J * pauli2)) :
    J = (J 0 0) • W + (J 1 0) • Wodd := by
  have hI : Complex.I ≠ 0 := Complex.I_ne_zero
  have c00 := congrFun (congrFun h1 0) 0
  have c10 := congrFun (congrFun h1 1) 0
  have c20 := congrFun (congrFun h1 2) 0
  have c30 := congrFun (congrFun h1 3) 0
  have d00 := congrFun (congrFun h2 0) 0
  have d10 := congrFun (congrFun h2 1) 0
  simp [beta, pauli1, σ1, Matrix.mul_apply, Fin.sum_univ_four] at c00 c10 c20 c30
  simp [beta5, beta, gamma5, pauli2, σ2, Matrix.mul_apply,
    Fin.sum_univ_four, smul_eq_mul] at d00 d10
  have e20 : J 2 0 = -(J 0 0) := by
    apply mul_left_cancel₀ hI
    rw [d00, ← c00]
    ring
  have e30 : J 3 0 = -(J 1 0) := by
    apply mul_left_cancel₀ hI
    rw [d10, ← c10]
    ring
  ext i j
  fin_cases i <;> fin_cases j <;> simp [W, Wodd, Matrix.add_apply]
  · exact c00.symm
  · exact c10.symm
  · exact e20
  · rw [← c20, e20]
    ring
  · exact e30
  · rw [← c30, e30]
    ring

/-- The two classification coefficients can be read off directly. -/
theorem decomp_coeff (a b : Complex) :
    (a • W + b • Wodd) 0 0 = a ∧ (a • W + b • Wodd) 1 0 = b := by
  constructor <;> simp [W, Wodd]

/-- `W` and `Wodd` are linearly independent in coefficient form. -/
theorem W_Wodd_linearIndependent (a b : Complex)
    (h : a • W + b • Wodd = 0) : a = 0 ∧ b = 0 := by
  have h00 := congrFun (congrFun h 0) 0
  have h10 := congrFun (congrFun h 1) 0
  simp [W, Wodd] at h00 h10
  exact ⟨h00, h10⟩

/-- The coefficients in the classification are unique. -/
theorem decomp_unique (a b a' b' : Complex)
    (h : a • W + b • Wodd = a' • W + b' • Wodd) : a = a' ∧ b = b' := by
  have h00 := congrFun (congrFun h 0) 0
  have h10 := congrFun (congrFun h 1) 0
  simp [W, Wodd] at h00 h10
  exact ⟨h00, h10⟩

/-- Exact Gram law for the classified intertwiner family. -/
theorem conjTranspose_mul_combo (a b : Complex) :
    (a • W + b • Wodd)ᴴ * (a • W + b • Wodd) =
      ((2 * (Complex.normSq a + Complex.normSq b) : Real) : Complex) • (1 : M2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [W, Wodd, Matrix.add_apply, Matrix.smul_apply, Matrix.mul_apply,
      Fin.sum_univ_four, Matrix.conjTranspose_apply, Matrix.of_apply, Matrix.cons_val',
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_fin_one,
      Matrix.empty_val', Matrix.one_apply, smul_eq_mul] <;>
    push_cast [Complex.normSq_apply, map_add, star, Complex.conj_re, Complex.conj_im] <;>
    simp [Complex.ext_iff, mul_comm] <;> ring

/-- A live Clifford intertwiner is normalized exactly when its two coefficient
norm-squares sum to one. -/
theorem normalized_iff (J : Matrix (Fin 4) (Fin 2) Complex)
    (h1 : beta * J = J * pauli1) (h2 : beta5 * J = -(J * pauli2)) :
    Jᴴ * J = (2 : Complex) • (1 : M2) ↔
      Complex.normSq (J 0 0) + Complex.normSq (J 1 0) = 1 := by
  have hd := intertwiner_decomp J h1 h2
  have key : Jᴴ * J =
      ((2 * (Complex.normSq (J 0 0) + Complex.normSq (J 1 0)) : Real) : Complex) •
        (1 : M2) := by
    conv_lhs => rw [hd]
    rw [conjTranspose_mul_combo]
  rw [key]
  constructor
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    simp at h00
    exact_mod_cast h00
  · intro h
    rw [h]
    norm_num

/-- The live embedding `W` is normalized. -/
theorem W_normalized : Wᴴ * W = (2 : Complex) • (1 : M2) := by
  simpa using W_conjTranspose_mul_W

/-- The second embedding is normalized. -/
theorem Wodd_normalized : Woddᴴ * Wodd = (2 : Complex) • (1 : M2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Wodd, Matrix.mul_apply, Fin.sum_univ_four, Matrix.conjTranspose] <;> norm_num

/-- A nontrivial rational point on the normalized coefficient sphere. -/
def Jmix : Matrix (Fin 4) (Fin 2) Complex :=
  ((3 : Complex) / 5) • W + ((4 : Complex) / 5) • Wodd

/-- The rational mixed witness obeys both intertwining equations. -/
theorem Jmix_intertwiner :
    beta * Jmix = Jmix * pauli1 ∧ beta5 * Jmix = -(Jmix * pauli2) := by
  constructor
  · simp only [Jmix, Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul,
      beta_W, beta_Wodd]
  · simp only [Jmix, Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul,
      beta5_W, beta5_Wodd, smul_neg, neg_add]

/-- The rational mixed witness is normalized. -/
theorem Jmix_normalized : Jmixᴴ * Jmix = (2 : Complex) • (1 : M2) := by
  rw [Jmix, conjTranspose_mul_combo]
  norm_num [Complex.normSq_apply]

/-- `Wodd` is not a scalar multiple of the live embedding `W`. -/
theorem Wodd_not_smul_W : ¬ ∃ c : Complex, Wodd = c • W := by
  rintro ⟨c, hc⟩
  have h10 := congrFun (congrFun hc 1) 0
  simp [W, Wodd] at h10

/-- The rational mixed witness is not a scalar multiple of `W`. -/
theorem Jmix_not_smul_W : ¬ ∃ c : Complex, Jmix = c • W := by
  rintro ⟨c, hc⟩
  have h10 := congrFun (congrFun hc 1) 0
  simp [Jmix, W, Wodd] at h10

/-- The live Clifford equations and normalization do not select `W`. -/
theorem clifford_not_selective :
    ∃ J : Matrix (Fin 4) (Fin 2) Complex,
      (beta * J = J * pauli1) ∧ (beta5 * J = -(J * pauli2)) ∧
      (Jᴴ * J = (2 : Complex) • (1 : M2)) ∧ (¬ ∃ c : Complex, J = c • W) := by
  exact Exists.intro Wodd <|
    And.intro beta_Wodd <| And.intro beta5_Wodd <|
      And.intro Wodd_normalized Wodd_not_smul_W

end PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification

/-! ## Build-enforced standard-three axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.intertwiner_decomp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.intertwiner_decomp

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.decomp_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.decomp_unique

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.conjTranspose_mul_combo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.conjTranspose_mul_combo

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.normalized_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.normalized_iff

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.clifford_not_selective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwinerClassification.clifford_not_selective
