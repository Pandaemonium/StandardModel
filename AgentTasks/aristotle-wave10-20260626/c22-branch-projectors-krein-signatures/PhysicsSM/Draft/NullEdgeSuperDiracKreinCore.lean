import PhysicsSM.Draft.NullEdgeDiracTwoSheetCore

/-!
# Draft.NullEdgeSuperDiracKreinCore

Finite algebra for the Lorentzian/Krein refinement of the causal super-Dirac
conjecture.

The corrected super-Dirac target should not treat the Pluecker determinant and
the Higgs/Yukawa square as two additive mass terms. The Pluecker determinant is
the kinetic symbol of the Dirac block, while the Yukawa square is the internal
mass block; the mass shell equates them.

This module isolates a second structural point: once a finite operator satisfies
`D^2 = m^2 I`, the normalized operator `J = (1 / m) D` is an involution. This is
the natural finite candidate for the Krein fundamental symmetry on a mass shell.
It is also exactly the difference of the plus and minus branch projectors already
proved in `NullEdgeDiracTwoSheetCore`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSuperDiracKreinCore

open Matrix Complex

variable {Idx : Type*} [Fintype Idx] [DecidableEq Idx]

/-- A finite `J`-self-adjointness predicate for the Krein form with symmetry `J`.

For the indefinite form `<x,y>_J = x^dagger J y`, this is the matrix identity
`J D = D^dagger J`.  In the Lorentzian super-Dirac program this is the better
target than ordinary positive-definite Hilbert self-adjointness.
-/
def IsKreinSelfAdjoint (J D : Matrix Idx Idx Complex) : Prop :=
  J * D = D.conjTranspose * J

/-- The mass-shell fundamental symmetry `J = m^{-1} D`, written with ASCII
division notation as `(1 / m) D`. -/
def massShellJ (D : Matrix Idx Idx Complex) (m : Complex) :
    Matrix Idx Idx Complex :=
  (1 / m : Complex) • D

/-- If `D^2 = m^2 I`, then the normalized mass-shell operator `J = m^{-1}D`
squares to the identity. -/
theorem massShellJ_sq_eq_one
    (D : Matrix Idx Idx Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix Idx Idx Complex)) :
    massShellJ D m * massShellJ D m = (1 : Matrix Idx Idx Complex) := by
  have hm' : m ≠ 0 := bne_iff_ne.mp hm
  simp only [massShellJ]
  rw [Matrix.smul_mul, Matrix.mul_smul, hD]
  match_scalars
  field_simp [hm']

omit [Fintype Idx] in
/-- The mass-shell `J` is the difference of the two Dirac branch projectors. -/
theorem massShellJ_eq_plus_minus_projectors
    (D : Matrix Idx Idx Complex) (m : Complex) :
    massShellJ D m =
      PhysicsSM.Draft.NullEdgeDiracTwoSheetCore.plusProjector D m -
        PhysicsSM.Draft.NullEdgeDiracTwoSheetCore.minusProjector D m := by
  rw [PhysicsSM.Draft.NullEdgeDiracTwoSheetCore.plusProjector_sub_minusProjector]
  ext i j
  simp [massShellJ, div_eq_mul_inv]

omit [DecidableEq Idx] in
/-- Ordinary self-adjointness plus commutation with `J` implies
`J`-self-adjointness.  This is a useful Euclidean-to-Krein comparison lemma:
it shows exactly which extra compatibility is needed if a positive-definite
self-adjoint operator is used as an intermediate model. -/
theorem isKreinSelfAdjoint_of_selfAdjoint_commutes
    (J D : Matrix Idx Idx Complex)
    (hD : D.conjTranspose = D)
    (hcomm : J * D = D * J) :
    IsKreinSelfAdjoint J D := by
  unfold IsKreinSelfAdjoint
  rw [hD]
  exact hcomm

omit [DecidableEq Idx] in
/-- A self-adjoint mass-shell operator is self-adjoint for its own mass-shell
Krein symmetry.  This is the finite algebra behind the idea that the branch
symmetry `J = m^{-1}D` is not optional decoration once a mass square root is
fixed. -/
theorem massShellJ_kreinSelfAdjoint_of_selfAdjoint
    (D : Matrix Idx Idx Complex) (m : Complex)
    (hD : D.conjTranspose = D) :
    IsKreinSelfAdjoint (massShellJ D m) D := by
  unfold IsKreinSelfAdjoint massShellJ
  rw [hD]
  rw [Matrix.smul_mul, Matrix.mul_smul]

/-- The mass-shell constraint equates the kinetic Pluecker symbol and the
internal Yukawa mass square.  This deliberately records equality, not an
additive contribution to the square. -/
def MassShellConstraint (kineticPlucker yukawaSq : Complex) : Prop :=
  kineticPlucker = yukawaSq

/-- Under the mass-shell constraint, replacing the kinetic symbol by the Yukawa
square is only substitution, not adding a second mass block. -/
theorem kineticSymbol_eq_yukawa_of_massShell
    {kineticPlucker yukawaSq : Complex}
    (h : MassShellConstraint kineticPlucker yukawaSq) :
    kineticPlucker = yukawaSq := h

end PhysicsSM.Draft.NullEdgeSuperDiracKreinCore

end
