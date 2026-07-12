import PhysicsSM.Draft.NullEdge.CommutatorRegulator

/-!
# Corner invisibility of zero-offset commutator regulators

The exact group-commutator primitive is attractive because its first jet
vanishes.  This target records a severe boundary: if either phase angle has
zero sine, the commutator is already trivial (under the corresponding
involution hypothesis).  Consequently a product whose angles are integer
linear forms in cubic lattice momenta is invisible at every `0/pi` corner and
cannot remove the live walk's corner aliases.
-/

namespace PhysicsSM.Draft.NullEdge.CommutatorCornerInvisibility

open CommutatorRegulator

theorem phaseStep_sine_zero (c : Real) (A : M4) :
    phaseStep c 0 A = (c : Complex) • 1 := by
  sorry

theorem regulator_first_sine_zero
    (cp cq sq : Real) (A G : M4)
    (hG : G * G = 1) (hp : cp ^ 2 = 1)
    (hq : cq ^ 2 + sq ^ 2 = 1) :
    regulator cp 0 cq sq A G = 1 := by
  sorry

theorem regulator_second_sine_zero
    (cp sp cq : Real) (A G : M4)
    (hA : A * A = 1) (hp : cp ^ 2 + sp ^ 2 = 1)
    (hq : cq ^ 2 = 1) :
    regulator cp sp cq 0 A G = 1 := by
  sorry

def cornerSign (b : Bool) : Real := if b then -1 else 1

theorem cornerSign_sq (b : Bool) : cornerSign b ^ 2 = 1 := by
  sorry

/-- At a cubic corner every integer-frequency phase step is central, so the
commutator loop is exactly invisible. -/
theorem regulator_corner_trivial (bp bq : Bool) (A G : M4) :
    regulator (cornerSign bp) 0 (cornerSign bq) 0 A G = 1 := by
  sorry

/-- Finite products of corner-invisible regulators remain invisible. -/
theorem product_corner_trivial (n : Nat) (R : Fin n -> M4)
    (hR : forall i, R i = 1) :
    (List.ofFn R).foldl (fun acc r => acc * r) 1 = 1 := by
  sorry

/-- Negative control: the rational noncentral quarter-turn fixture proves that
the same primitive is not globally trivial away from the corner locus. -/
theorem exists_nontrivial_away_from_corners :
    Exists fun A : M4 => Exists fun G : M4 =>
      regulator 0 1 0 1 A G ≠ 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.CommutatorCornerInvisibility
