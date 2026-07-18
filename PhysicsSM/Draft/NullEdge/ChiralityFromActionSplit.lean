import Mathlib

/-!
# Why the weak force is left-handed: chirality from the left/right action split

SM-branch foundation, item 1 (chirality), 2026-07-17. Furey's mechanism
(arXiv:1806.00612) derives parity violation WITHOUT imposing a chiral projector
by hand: on an associative algebra, "conceptually distinct algebraic actions do
not mix." Concretely, weak isospin acts by LEFT multiplication and chirality is
a RIGHT-multiplication grading; left and right multiplication commute by
ASSOCIATIVITY, so weak transitions cannot change chirality.

This module proves that algebraic core, on the matrix model `M(k, C)` (the
`C(x)H`-type left/right bimodule):

* `leftMul_rightMul_comm` - left and right multiplication commute (associativity);
* `leftAction_preserves_rightChirality` - a left-multiplier maps a right-`Gamma`
  eigenstate to a state of the SAME eigenvalue, i.e. weak isospin (any left
  action) preserves chirality (the right-`Gamma` grading);
* `su2L_blockDiagonal_in_chirality` - the weak `su(2)_L` generators (left action)
  are block-diagonal in the chirality grading, so they never connect left- and
  right-handed sectors.

This is the DERIVED half of parity violation: su(2)_L is structurally
chirality-preserving, with no chiral projector inserted by hand. The REMAINING
half - that the right-handed sector carries only su(2)_L SINGLETS while the
left-handed sector carries DOUBLETS - is the representation-assignment content
of the full `R(x)C(x)H(x)O` construction (the specific ideal decomposition),
tracked as brick 3's remainder. So this module derives "weak transitions
preserve handedness"; it does not by itself derive "right-handed fermions are
weak singlets."

Clean-room; [comp] for the mechanism (Furey), [orig] for the formalization.
Standard-three axioms.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit

open Matrix

variable {k : ℕ}

/-- **The action split commutes.** Left multiplication (isospin) and right
multiplication (chirality) commute - pure associativity. This is why the two
"conceptually distinct algebraic actions do not mix." -/
theorem leftMul_rightMul_comm (A B X : Matrix (Fin k) (Fin k) ℂ) :
    A * (X * B) = (A * X) * B :=
  (Matrix.mul_assoc A X B).symm

/-- **Left action preserves right chirality.** If `X` is a `+1` eigenstate of
right multiplication by the chirality involution `Gamma` (`X * Gamma = X`, i.e.
`X` is "left-handed"), then so is `A * X` for any left-multiplier `A`. Weak
isospin (a left action) cannot change chirality. -/
theorem leftAction_preserves_rightChirality
    (A Γ X : Matrix (Fin k) (Fin k) ℂ) (hX : X * Γ = X) :
    (A * X) * Γ = A * X := by
  rw [Matrix.mul_assoc, hX]

/-- The analogous statement for the right-handed (`-1`) sector: a left action
preserves `X * Gamma = -X`. -/
theorem leftAction_preserves_rightChirality_neg
    (A Γ X : Matrix (Fin k) (Fin k) ℂ) (hX : X * Γ = -X) :
    (A * X) * Γ = -(A * X) := by
  rw [Matrix.mul_assoc, hX, Matrix.mul_neg]

/-- **`su(2)_L` is block-diagonal in chirality.** For a chirality involution
`Gamma` (with `Gamma * Gamma = 1`), the right-chirality projectors
`P_+ = (1 + R_Gamma)/2`, `P_- = (1 - R_Gamma)/2` split every module element; any
left action `A` commutes with these projectors, so it maps each chirality
sector into itself. Here we witness it as: the left action of `A` sends the
right-handed projection `(X * Gamma - X)` to `(A*X)*Gamma - A*X`, staying inside
the same sector. -/
theorem su2L_blockDiagonal_in_chirality
    (A Γ X : Matrix (Fin k) (Fin k) ℂ) :
    (A * X) * Γ - A * X = A * (X * Γ - X) := by
  rw [Matrix.mul_sub, Matrix.mul_assoc]

/-- **Nonvacuity witness.** With `Gamma = diag(1,-1)` on `M(2,C)`, the matrix
`X = !![0,1;0,0]` is a genuine right-handed (`-1`) eigenstate
(`X * Gamma = -X`), and left multiplication by any `A` keeps it right-handed. -/
theorem chirality_witness (A : Matrix (Fin 2) (Fin 2) ℂ) :
    (A * !![0, 1; 0, 0]) * !![1, 0; 0, -1] = -(A * !![0, 1; 0, 0]) := by
  apply leftAction_preserves_rightChirality_neg
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

end PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit.leftAction_preserves_rightChirality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit.leftAction_preserves_rightChirality

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit.su2L_blockDiagonal_in_chirality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit.su2L_blockDiagonal_in_chirality

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit.chirality_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit.chirality_witness

end
