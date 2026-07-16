import Mathlib

/-!
# Generic projector-conditioned unitary step

This standalone draft isolates the algebra behind one HNU substep. A selected
internal sector receives a unit-modulus translation phase while the
complementary sector is held on site. The theorem says exactly what is moved
and what is held; it does not call the held sector a null translation.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProjectorConditionedStep

open Matrix Complex

def IsProjection {n : Type*} [Fintype n] [DecidableEq n]
    (P : Matrix n n Complex) : Prop := P * P = P ∧ Pᴴ = P

def IsPhase (z : Complex) : Prop := star z * z = 1 ∧ z * star z = 1

def conditionedStep {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) : Matrix n n Complex :=
  z • P + (1 - P)

def IsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    (U : Matrix n n Complex) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- The selected sector receives exactly the phase `z`. -/
theorem conditionedStep_mul_projection {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) (hP : IsProjection P) :
    conditionedStep z P * P = z • P := by
  unfold conditionedStep;
  simp +decide [ add_mul, sub_mul, hP.1 ]

/-- The complementary sector is held exactly fixed. -/
theorem conditionedStep_mul_complement {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) (hP : IsProjection P) :
    conditionedStep z P * (1 - P) = 1 - P := by
  unfold conditionedStep; simp +decide [ mul_sub ] ;
  simp +decide [ add_mul, sub_mul, hP.1 ]

/-- A unit phase on an orthogonal projector gives an exact unitary step. -/
theorem conditionedStep_unitary {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex)
    (hP : IsProjection P) (hz : IsPhase z) :
    IsUnitary (conditionedStep z P) := by
  unfold IsUnitary conditionedStep;
  simp_all +decide [ mul_add, add_mul, IsProjection, sub_mul, mul_sub ];
  simp_all +decide [ ← smul_assoc, IsPhase ]

def selected : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 0]

/-- Nontrivial control: the phase `-1` changes the selected sector. -/
theorem selected_neg_one_nontrivial :
    conditionedStep (-1) selected ≠ (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  intro h
  have := congr_fun ( congr_fun h 0 ) 0
  simp [conditionedStep, selected] at this
  norm_num at this

/-- The explicit selected-sector witness is an orthogonal projector. -/
theorem selected_isProjection : IsProjection selected := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [ selected ]

/-!
## Standard-axiom guards

Each of the four headline results is checked, at build time, to depend only on
Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`). No
trusted compiler evaluation (`Lean.ofReduceBool` / `Lean.trustCompiler`) and no
extra assumptions are permitted; `#guard_msgs` turns any deviation into a build
error.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.conditionedStep_mul_projection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditionedStep_mul_projection

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.conditionedStep_mul_complement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditionedStep_mul_complement

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.conditionedStep_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditionedStep_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectorConditionedStep.selected_neg_one_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selected_neg_one_nontrivial

end PhysicsSM.Draft.NullEdge.ProjectorConditionedStep
