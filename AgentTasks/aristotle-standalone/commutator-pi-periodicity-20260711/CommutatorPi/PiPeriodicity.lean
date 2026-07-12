import CommutatorPi.CommutatorRegulator

/-!
# Pi-periodicity of exact phase commutator regulators

A simultaneous sign flip of the cosine/sine pair multiplies a phase step by
the central scalar `-1`.  Each commutator angle appears twice, so those signs
cancel.  Thus affine offsets do not make a pure integer-frequency commutator
act on cubic `0/pi` corners: its value there equals its value at the origin.
-/

namespace PhysicsSM.Draft.NullEdge.CommutatorPiPeriodicity

open CommutatorRegulator

theorem phaseStep_flip_pair (c s : Real) (A : M4) :
    phaseStep (-c) (-s) A = -(phaseStep c s A) := by
  sorry

theorem regulator_flip_first_pair
    (cp sp cq sq : Real) (A G : M4) :
    regulator (-cp) (-sp) cq sq A G = regulator cp sp cq sq A G := by
  sorry

theorem regulator_flip_second_pair
    (cp sp cq sq : Real) (A G : M4) :
    regulator cp sp (-cq) (-sq) A G = regulator cp sp cq sq A G := by
  sorry

theorem regulator_flip_both_pairs
    (cp sp cq sq : Real) (A G : M4) :
    regulator (-cp) (-sp) (-cq) (-sq) A G =
      regulator cp sp cq sq A G := by
  sorry

def cornerSign (b : Bool) : Real := if b then -1 else 1

/-- Abstract algebraic form of affine-corner invisibility: each corner changes
an offset angle pair only by a common sign. -/
theorem regulator_corner_sign_invariant
    (bp bq : Bool) (cp sp cq sq : Real) (A G : M4) :
    regulator (cornerSign bp * cp) (cornerSign bp * sp)
        (cornerSign bq * cq) (cornerSign bq * sq) A G =
      regulator cp sp cq sq A G := by
  sorry

/-- Negative control: a single phase step does see the sign flip; cancellation
is specific to the commutator architecture. -/
theorem phaseStep_flip_pair_ne_same :
    phaseStep (-1) 0 (1 : M4) ≠ phaseStep 1 0 (1 : M4) := by
  sorry

end PhysicsSM.Draft.NullEdge.CommutatorPiPeriodicity
