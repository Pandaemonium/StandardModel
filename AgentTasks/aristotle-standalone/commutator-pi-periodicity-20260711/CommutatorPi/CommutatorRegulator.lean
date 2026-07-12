import Mathlib

/-!
# Exact matrix commutator regulator

This module packages the finite matrix identities behind a candidate
strict-local group-commutator regulator. Trigonometric/Laurent realization and
the chirality-odd choice of generators remain separate composition steps.

Provenance: focused target prepared locally; Aristotle project
`1b5d1015-a2a1-4f4a-b0da-5ab23a328c94`, task
`d231e2c6-855d-4671-ab3e-13284c72a398`, completed the proofs and identified a
false original statement missing the hypothesis `G * G = 1`. The corrected
theorem and an explicit counterexample to the omitted hypothesis are recorded
below.
-/

namespace PhysicsSM.Draft.NullEdge.CommutatorRegulator

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

def IsUnitary (U : M4) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

noncomputable def phaseStep (c s : Real) (A : M4) : M4 :=
  (c : Complex) • 1 - (Complex.I * (s : Complex)) • A

noncomputable def regulator (cp sp cq sq : Real) (A G : M4) : M4 :=
  phaseStep cp sp A * phaseStep cq sq G *
    phaseStep cp (-sp) A * phaseStep cq (-sq) G

theorem isUnitary_mul {U V : M4} (hU : IsUnitary U) (hV : IsUnitary V) :
    IsUnitary (U * V) := by
  constructor <;> simp_all +decide [Matrix.mul_assoc]
  all_goals simp_all +decide [← mul_assoc, IsUnitary]

theorem phaseStep_zero_one (A : M4) :
    phaseStep 0 1 A = (-Complex.I) • A := by
  unfold phaseStep
  aesop

theorem phaseStep_zero_neg_one (A : M4) :
    phaseStep 0 (-1) A = Complex.I • A := by
  simp [phaseStep]

theorem regulator_quarterTurn_eq (A G : M4) :
    regulator 0 1 0 1 A G = A * G * A * G := by
  unfold regulator phaseStep
  norm_num
  norm_num [← smul_assoc]

theorem phaseStep_conjTranspose
    (c s : Real) (A : M4) (hHerm : A.conjTranspose = A) :
    (phaseStep c s A).conjTranspose = phaseStep c (-s) A := by
  simp +decide [phaseStep]
  rw [hHerm]

theorem phaseStep_reverse_mul
    (c s : Real) (A : M4)
    (hA : A * A = 1) (hcircle : c ^ 2 + s ^ 2 = 1) :
    phaseStep c (-s) A * phaseStep c s A = 1 := by
  have hz' : Complex.I * (((-s : Real)) : Complex) *
      (Complex.I * (((s : Real)) : Complex)) = ((s : Complex) ^ 2) := by
    push_cast
    ring_nf
    rw [Complex.I_sq]
    ring
  simp only [phaseStep]
  have expand :
      ((c : Complex) • (1 : M4) -
          (Complex.I * ((-s : Real) : Complex)) • A) *
        ((c : Complex) • (1 : M4) -
          (Complex.I * ((s : Real) : Complex)) • A) =
      ((c : Complex) ^ 2 + (s : Complex) ^ 2) • (1 : M4) := by
    simp only [sub_mul, mul_sub, smul_mul_smul_comm, Matrix.mul_one,
      Matrix.one_mul, hA]
    rw [hz']
    push_cast
    module
  rw [expand]
  have hcast : (c : Complex) ^ 2 + (s : Complex) ^ 2 = 1 := by
    exact_mod_cast hcircle
  rw [hcast, one_smul]

theorem phaseStep_mul_reverse
    (c s : Real) (A : M4)
    (hA : A * A = 1) (hcircle : c ^ 2 + s ^ 2 = 1) :
    phaseStep c s A * phaseStep c (-s) A = 1 := by
  simpa only [neg_neg] using
    phaseStep_reverse_mul c (-s) A hA (by nlinarith [hcircle])

theorem phaseStep_unitary
    (c s : Real) (A : M4)
    (hHerm : A.conjTranspose = A)
    (hA : A * A = 1) (hcircle : c ^ 2 + s ^ 2 = 1) :
    IsUnitary (phaseStep c s A) := by
  constructor
  · rw [phaseStep_conjTranspose c s A hHerm]
    exact phaseStep_reverse_mul c s A hA hcircle
  · rw [phaseStep_conjTranspose c s A hHerm]
    exact phaseStep_mul_reverse c s A hA hcircle

theorem regulator_unitary
    (cp sp cq sq : Real) (A G : M4)
    (hAHerm : A.conjTranspose = A) (hGHerm : G.conjTranspose = G)
    (hA : A * A = 1) (hG : G * G = 1)
    (hp : cp ^ 2 + sp ^ 2 = 1) (hq : cq ^ 2 + sq ^ 2 = 1) :
    IsUnitary (regulator cp sp cq sq A G) := by
  have hAneg : IsUnitary (phaseStep cp (-sp) A) :=
    phaseStep_unitary cp (-sp) A hAHerm hA (by nlinarith [hp])
  convert isUnitary_mul
      (isUnitary_mul
        (isUnitary_mul
          (phaseStep_unitary cp sp A hAHerm hA hp)
          (phaseStep_unitary cq sq G hGHerm hG hq))
        hAneg)
      (phaseStep_unitary cq (-sq) G hGHerm hG (by nlinarith [hq])) using 1

theorem regulator_first_axis_zero
    (cq sq : Real) (A G : M4)
    (hG : G * G = 1) (hq : cq ^ 2 + sq ^ 2 = 1) :
    regulator 1 0 cq sq A G = 1 := by
  unfold regulator
  convert phaseStep_mul_reverse cq sq G hG hq using 1
  ext i j
  simp +decide [phaseStep]

theorem regulator_second_axis_zero
    (cp sp : Real) (A G : M4)
    (hA : A * A = 1) (hp : cp ^ 2 + sp ^ 2 = 1) :
    regulator cp sp 1 0 A G = 1 := by
  convert phaseStep_mul_reverse cp sp A hA hp using 1
  unfold regulator phaseStep
  norm_num

/-- Perfectly anticommuting involutions make the quarter-turn commutator
collapse to the central value `-I`. Both involution hypotheses are necessary. -/
theorem anticommuting_quarterTurn_eq_neg_one
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1)
    (hanti : A * G = -(G * A)) :
    regulator 0 1 0 1 A G = -1 := by
  unfold regulator phaseStep
  simp +decide [mul_assoc, hanti]
  simp +decide [← mul_assoc, ← smul_assoc, hA, hG, hanti]

/-- Commuting involutions make the quarter-turn commutator trivial. -/
theorem commuting_quarterTurn_eq_one
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1)
    (hcomm : A * G = G * A) :
    regulator 0 1 0 1 A G = 1 := by
  rw [regulator_quarterTurn_eq]
  calc
    A * G * A * G = A * (G * A) * G := by simp only [mul_assoc]
    _ = A * (A * G) * G := by rw [← hcomm]
    _ = (A * A) * (G * G) := by simp only [mul_assoc]
    _ = 1 := by rw [hA, hG, Matrix.one_mul]

/-- Counterexample to the original false statement that omitted `G * G = 1`.
The displayed `A` is an involution and anticommutes with `G`, but the
quarter-turn regulator is not `-I`. -/
theorem exists_failure_without_second_involution :
    Exists fun A : M4 => Exists fun G : M4 =>
      A * A = 1 ∧ A * G = -(G * A) ∧
        regulator 0 1 0 1 A G ≠ -1 := by
  refine ⟨!![1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,1],
    !![0,2,0,0;2,0,0,0;0,0,0,0;0,0,0,0], ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_four]
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    simp [regulator_quarterTurn_eq, Matrix.mul_apply,
      Fin.sum_univ_four] at h00
    norm_num at h00

/-- Symmetric counterexample: dropping `A * A = 1` also breaks the central
collapse, even with Hermitian generators. -/
theorem exists_failure_without_first_involution :
    Exists fun A : M4 => Exists fun G : M4 =>
      G * G = 1 ∧ A * G = -(G * A) ∧
        regulator 0 1 0 1 A G ≠ -1 := by
  refine ⟨!![0,2,0,0;2,0,0,0;0,0,0,0;0,0,0,0],
    !![1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,1], ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_four]
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    simp [regulator_quarterTurn_eq, Matrix.mul_apply,
      Fin.sum_univ_four] at h00
    norm_num at h00

/-- Noncentral mixed fixture: some Hermitian involutions have a quarter-turn
regulator different from both central values. -/
theorem exists_noncentral_quarterTurn :
    Exists fun A : M4 => Exists fun G : M4 =>
      A.conjTranspose = A ∧ G.conjTranspose = G ∧
      A * A = 1 ∧ G * G = 1 ∧
      regulator 0 1 0 1 A G ≠ 1 ∧
      regulator 0 1 0 1 A G ≠ -1 := by
  use !![0,1,0,0;1,0,0,0;0,0,1,0;0,0,0,1]
  use !![3/5,4/5,0,0;4/5,-3/5,0,0;0,0,1,0;0,0,0,1]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · intro h
    have h01 := congrFun (congrFun h 0) 1
    norm_num [regulator_quarterTurn_eq, Matrix.mul_apply,
      Fin.sum_univ_succ] at h01
  · intro h
    have h01 := congrFun (congrFun h 0) 1
    norm_num [regulator_quarterTurn_eq, Matrix.mul_apply,
      Fin.sum_univ_succ] at h01

/-- Strong noncentrality: the same rational fixture is not any scalar matrix,
not merely different from `+I` and `-I`. -/
theorem exists_genuinely_noncentral_quarterTurn :
    Exists fun A : M4 => Exists fun G : M4 =>
      A.conjTranspose = A ∧ G.conjTranspose = G ∧
      A * A = 1 ∧ G * G = 1 ∧
      ∀ z : Complex, regulator 0 1 0 1 A G ≠ z • 1 := by
  use !![0,1,0,0;1,0,0,0;0,0,1,0;0,0,0,1]
  use !![3/5,4/5,0,0;4/5,-3/5,0,0;0,0,1,0;0,0,0,1]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
  · intro z h
    have h01 := congrFun (congrFun h 0) 1
    norm_num [regulator_quarterTurn_eq, Matrix.mul_apply,
      Fin.sum_univ_succ, Matrix.smul_apply] at h01

end PhysicsSM.Draft.NullEdge.CommutatorRegulator
