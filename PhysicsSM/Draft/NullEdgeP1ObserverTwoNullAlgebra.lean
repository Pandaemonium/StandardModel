import Mathlib.Tactic

/-!
# P1 observer-axis two-null algebra

This target isolates the scalar algebra behind the observer-conditioned
two-null split. In an observer axis, two opposite null components with energies
`(E+s)/2` and `(E-s)/2` sum to total energy `E`, spatial component `s`, and
mass square `E^2 - s^2`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1ObserverTwoNullAlgebra

def kPlus (E s : Real) : Real :=
  (E + s) / 2

def kMinus (E s : Real) : Real :=
  (E - s) / 2

def splitEnergy (E s : Real) : Real :=
  kPlus E s + kMinus E s

def splitSpatial (E s : Real) : Real :=
  kPlus E s - kMinus E s

def splitMassSq (E s : Real) : Real :=
  splitEnergy E s ^ 2 - splitSpatial E s ^ 2

theorem splitEnergy_eq (E s : Real) :
    splitEnergy E s = E := by
  unfold splitEnergy kPlus kMinus
  ring

theorem splitSpatial_eq (E s : Real) :
    splitSpatial E s = s := by
  unfold splitSpatial kPlus kMinus
  ring

theorem splitMassSq_eq_E_sq_sub_s_sq (E s : Real) :
    splitMassSq E s = E ^ 2 - s ^ 2 := by
  unfold splitMassSq splitEnergy splitSpatial kPlus kMinus
  ring

theorem splitMassSq_eq_four_product (E s : Real) :
    splitMassSq E s = 4 * kPlus E s * kMinus E s := by
  unfold splitMassSq splitEnergy splitSpatial kPlus kMinus
  ring

end PhysicsSM.Draft.NullEdgeP1ObserverTwoNullAlgebra
