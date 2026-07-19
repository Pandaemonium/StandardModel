import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Data.Real.Basic

noncomputable section

/-!
# Formal second jets of four-dimensional matrix curves

This module contains the small coefficient algebra shared by the local
Lorentz-plaquette curvature theorem and the periodic vacuum-wave continuation
audit.  A jet is normalized as

`1 + t linear + t^2 quadratic + O(t^3)`.

The definitions are purely algebraic.  They do not assert that a supplied
matrix curve has the displayed expansion; analytic remainder witnesses live
in the consuming modules.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet

/-- First and second coefficients of a four-dimensional real matrix curve,
normalized as `1 + t linear + t^2 quadratic + O(t^3)`. -/
structure MatrixSecondJet where
  linear : Matrix (Fin 4) (Fin 4) Real
  quadratic : Matrix (Fin 4) (Fin 4) Real

namespace MatrixSecondJet

/-- Product rule through quadratic order. -/
def mul (left right : MatrixSecondJet) : MatrixSecondJet where
  linear := left.linear + right.linear
  quadratic := left.quadratic + right.quadratic + left.linear * right.linear

/-- Second jet of `exp(t generator)`. -/
def exponential
    (generator : Matrix (Fin 4) (Fin 4) Real) : MatrixSecondJet where
  linear := generator
  quadratic := (1 / 2 : Real) • (generator * generator)

/-- Second jet of `exp(-t generator)`. -/
def inverseExponential
    (generator : Matrix (Fin 4) (Fin 4) Real) : MatrixSecondJet where
  linear := -generator
  quadratic := (1 / 2 : Real) • (generator * generator)

end MatrixSecondJet

end PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet
