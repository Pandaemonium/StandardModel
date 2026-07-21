import PhysicsSM.Draft.NullEdge.SU5RepresentationAction

/-!
# Item-3 closure: the exponentiated U(1)_Y action on `5* (+) Lambda^2(5)`

Target statements for the Aristotle job `su5-group-action-20260719`.

Context.  `SU5RepresentationAction` (landed tonight, PROVEN) closed the
Lie-algebra level: bracket representations and the charge tables as
eigenvalue data.  The status map's residual remainder is the GROUP level.
This
module states the abelian slice - the exponentiated hypercharge circle
acting with the charge tables as PHASES - which is the physically loaded
part (the full nonabelian exponentiation is deliberately out of scope).

Targets: the diagonal exponential closed form, and the exponentiated
eigenvalue payloads on both summands (dual basis covectors pick up
`exp(t Y5bar i)` phases; wedge basis elements pick up `exp(t Y10 i j)`
phases under the two-sided conjugation action).

Pre-registered honesty license: if the natural group action on the dual is
by `exp(-(t) Aᵀ)`-transport rather than the stated form, fix the transport
convention ONCE consistently with the landed Lie-level `dualAct`, record
it, and keep the phase payloads exact.  Every `s o r r y` below is a
documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SU5GroupAction

open Matrix
open PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification
open PhysicsSM.Draft.NullEdge.SU5RepresentationAction

/-- The exponential of the scaled hypercharge generator is the diagonal
phase matrix. -/
theorem exp_YGen_diagonal (t : ℂ) :
    NormedSpace.exp (t • YGen) =
      Matrix.diagonal (fun i => Complex.exp (t * (Y5 i : ℂ))) := by
  rw [YGen, ← Matrix.diagonal_smul, Matrix.exp_diagonal]
  congr 1
  funext i
  rw [Pi.coe_exp, Complex.exp_eq_exp_ℂ]
  rfl

/-- Exponentiated dual payload: the group element acts on the dual basis
covector by the `Y5bar` phase (dual transport `exp(-(t) YGenᵀ)`). -/
theorem exp_dual_phase (t : ℂ) (i : Fin 5) :
    (NormedSpace.exp (-(t) • YGenᵀ)).mulVec (Pi.single i 1) =
      Complex.exp (t * (Y5bar i : ℂ)) • (Pi.single i 1 : Fin 5 → ℂ) := by
  have hYGen_transpose : YGenᵀ = YGen := Matrix.diagonal_transpose _
  convert congr_arg
      (fun x : Matrix (Fin 5) (Fin 5) ℂ => x.mulVec (Pi.single i 1))
      (exp_YGen_diagonal (-t)) using 1
  · rw [hYGen_transpose]
  · simp +decide [Y5bar, funext_iff]
    intro x
    by_cases hx : x = i <;> aesop

/-- Exponentiated `Lambda^2` payload: two-sided conjugation multiplies the
wedge basis element by the pair-sum `Y10` phase. -/
theorem exp_lambda2_phase (t : ℂ) (i j : Fin 5) :
    NormedSpace.exp (t • YGen) * wedgeBasis i j *
        (NormedSpace.exp (t • YGen))ᵀ =
      Complex.exp (t * (Y10 i j : ℂ)) • wedgeBasis i j := by
  rw [exp_YGen_diagonal]
  ext a b
  unfold wedgeBasis Y10
  by_cases hi : i = j <;> by_cases ha : a = i <;> by_cases hb : b = j <;>
    simp +decide [hi, ha, hb, mul_assoc, mul_left_comm] <;> ring
  · rw [Complex.exp_add]
  · grind +splitImp
  · simp +decide [single, Complex.exp_add, mul_comm]
    aesop
  · simp +decide [*, single, Complex.exp_add]
    grind

end PhysicsSM.Draft.NullEdge.SU5GroupAction
