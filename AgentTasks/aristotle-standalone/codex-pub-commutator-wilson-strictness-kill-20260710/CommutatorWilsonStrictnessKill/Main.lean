import Mathlib

/-!
# Strict-locality kill for the commutator-Wilson candidate

The candidate gate uses factors with angle `r*q`.  In this family, integer
`r` gives a genuine finite Fourier harmonic and hence finite lattice range.
This target proves that every such integer-range member has a trivial Wilson
gate at the zone edge and therefore retains all three even-corner aliases.

This is a family-scoped obstruction.  It is not a no-go for every possible
finite-range QCA.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

def alpha1 : Mat4 := !![0,0,0,1; 0,0,1,0; 0,1,0,0; 1,0,0,0]
def alpha2 : Mat4 := !![0,0,0,-I; 0,0,I,0; 0,-I,0,0; I,0,0,0]
def alpha3 : Mat4 := !![0,0,1,0; 0,0,0,-1; 1,0,0,0; 0,-1,0,0]
def beta : Mat4 := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]
def gamma5 : Mat4 := !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]

def factor (f : Real) (A : Mat4) : Mat4 :=
  (Real.cos f : Complex) • (1 : Mat4) +
    (-(Real.sin f : Complex) * I) • A

def uprod (l : List Mat4) : Mat4 := l.foldr (· * ·) 1

def wilsonAxis (q r : Real) : Mat4 :=
  uprod [factor (r * q) beta, factor (r * q) gamma5,
    factor (-(r * q)) beta, factor (-(r * q)) gamma5]

def successor (qx qy qz r m : Real) : Mat4 :=
  uprod [factor qx alpha1, factor qy alpha2, factor qz alpha3,
    wilsonAxis qx r, wilsonAxis qy r, wilsonAxis qz r, factor m beta]

/-- An integer-frequency factor at the zone edge is scalar. -/
theorem factor_int_pi (n : Int) (A : Mat4) :
    factor ((n : Real) * Real.pi) A =
      (((-1 : Real) ^ n : Real) : Complex) • (1 : Mat4) := by
  sorry

/-- The commutator-Wilson gate is exactly trivial at `q=pi` for every integer
frequency, so its proposed strict finite-range specialization cannot lift the
zone-edge aliases. -/
theorem wilsonAxis_pi_int (n : Int) :
    wilsonAxis Real.pi (n : Real) = 1 := by
  sorry

/-- The three massless even corners remain exact zero-quasienergy aliases for
every integer-frequency member of this candidate family. -/
theorem successor_even_corners_int (n : Int) :
    successor Real.pi Real.pi 0 (n : Real) 0 = 1 ∧
    successor Real.pi 0 Real.pi (n : Real) 0 = 1 ∧
    successor 0 Real.pi Real.pi (n : Real) 0 = 1 := by
  sorry

/-- The rational-Pythagorean de-aliasing certificate used by the noninteger
Bloch control cannot be instantiated by any integer finite-range frequency. -/
theorem no_integer_pythagorean_zone_edge (n : Int) :
    ¬ (Real.cos ((n : Real) * Real.pi) = 3 / 5 ∧
       Real.sin ((n : Real) * Real.pi) = 4 / 5) := by
  sorry

/-- Concrete nonvacuity control: at integer range one the Wilson gate is
trivial and the first even corner is exactly the identity. -/
theorem range_one_alias_control :
    wilsonAxis Real.pi 1 = 1 ∧ successor Real.pi Real.pi 0 1 0 = 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill
