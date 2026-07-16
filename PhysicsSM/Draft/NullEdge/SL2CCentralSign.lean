import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
import PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport

/-!
# The concrete central sign in `SL(2, C)`

This module realizes the abstract central involution used by the finite
spin-lift obstruction layer as the scalar matrix `-I` in Mathlib's bundled
special linear group `SL(2, C)`.

It also proves that multiplication of an `SL(2, C)` lift by either central sign
does not change its congruence action `X |-> A X A^dagger` on `2 x 2` complex
matrices. Consequently, the edge re-signing operation used by the transport
module preserves this supplied Hermitian-matrix action exactly.

This is the central-sign inclusion in the kernel of the standard Hermitian
action. It does not prove that the kernel contains only `I` and `-I`, construct
the proper orthochronous Lorentz group, prove surjectivity of the covering map,
or derive local lifts from graph data. Claim grade: `M [orig]`.
-/

open Matrix
open scoped MatrixGroups

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SL2CCentralSign

open PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport

/-- Mathlib's determinant-one `2 x 2` complex matrix group. -/
abbrev SL2C := SL(2, Complex)

/-- The scalar matrix `-I`, bundled as an element of `SL(2, C)`. -/
def minusIdentity : SL2C := -(1 : SL2C)

/-- The bundled matrix `-I` is not the identity in `SL(2, C)`. -/
theorem minusIdentity_ne_one : minusIdentity = (1 : SL2C) -> False := by
  intro h
  have h00 := congrArg (fun A : SL2C => A 0 0) h
  norm_num [minusIdentity] at h00

/-- The bundled matrix `-I` has order two. -/
theorem minusIdentity_mul_self : minusIdentity * minusIdentity = (1 : SL2C) := by
  simp [minusIdentity]

/-- The bundled matrix `-I` is central in `SL(2, C)`. -/
theorem minusIdentity_commutes (A : SL2C) :
    minusIdentity * A = A * minusIdentity := by
  simp [minusIdentity]

/-- Concrete realization of the abstract central sign by `-I in SL(2, C)`. -/
def centralSignData : CentralSignData SL2C where
  element := minusIdentity
  ne_one := minusIdentity_ne_one
  mul_self := minusIdentity_mul_self
  commutes := minusIdentity_commutes

/-- The standard `SL(2, C)` congruence action on `2 x 2` complex matrices. On
Hermitian matrices this is the usual spinorial Lorentz action. -/
def hermitianCongruence
    (A : SL2C) (X : Matrix (Fin 2) (Fin 2) Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  (A : Matrix (Fin 2) (Fin 2) Complex) * X *
    Matrix.conjTranspose (A : Matrix (Fin 2) (Fin 2) Complex)

/-- Both central signs act trivially by Hermitian congruence. -/
theorem centralSign_hermitianCongruence
    (b : ZMod 2) (X : Matrix (Fin 2) (Fin 2) Complex) :
    hermitianCongruence (centralSign centralSignData b) X = X := by
  fin_cases b <;>
    simp [hermitianCongruence, centralSignData, minusIdentity]

/-- Multiplying any lift by a central sign leaves its Hermitian congruence
action unchanged. -/
theorem centralSign_mul_hermitianCongruence
    (b : ZMod 2) (A : SL2C) (X : Matrix (Fin 2) (Fin 2) Complex) :
    hermitianCongruence (centralSign centralSignData b * A) X =
      hermitianCongruence A X := by
  fin_cases b <;>
    simp [hermitianCongruence, centralSignData, minusIdentity,
      Matrix.mul_assoc]

/-- The transport module's literal edge re-signing leaves the supplied
Hermitian congruence action of every edge lift unchanged. -/
theorem reSignLift_hermitianCongruence
    {Edge : Type*}
    (lift : Edge -> SL2C) (s : Edge -> ZMod 2) (e : Edge)
    (X : Matrix (Fin 2) (Fin 2) Complex) :
    hermitianCongruence (reSignLift centralSignData lift s e) X =
      hermitianCongruence (lift e) X := by
  exact centralSign_mul_hermitianCongruence (s e) (lift e) X

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CCentralSign.minusIdentity_ne_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms minusIdentity_ne_one

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CCentralSign.centralSign_hermitianCongruence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms centralSign_hermitianCongruence

/-- info: 'PhysicsSM.Draft.NullEdge.SL2CCentralSign.reSignLift_hermitianCongruence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms reSignLift_hermitianCongruence

end PhysicsSM.Draft.NullEdge.SL2CCentralSign
