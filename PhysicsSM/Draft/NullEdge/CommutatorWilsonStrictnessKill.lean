import Mathlib

/-!
# Strict-locality kill for the commutator-Wilson candidate

The candidate gate uses factors with angle `r*q`. In this family, integer `r`
gives a genuine finite Fourier harmonic and hence finite lattice range. This
module proves that every such integer-range member has a trivial Wilson gate at
the zone edge and therefore retains all three even-corner aliases.

This is a family-scoped obstruction. It is not a no-go for every possible
finite-range QCA. Noninteger values can remove selected aliases as a Bloch
matrix control, but `cos(r*q)` and `sin(r*q)` then are not periodic finite
Laurent polynomials in `exp(i*q)` and do not define the claimed strict local
lattice update.

Provenance: Aristotle project `144a848d-d853-4ab5-b741-2a6fd7e0398b`, created
after semantic rejection of the nonlocal successor interpretation in project
`14ce545e-d17b-432f-a2e7-fb1fe35cfa1a`. Independently compiled under the
pinned Lean 4.28.0 toolchain.
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
  refine' Matrix.ext fun i j => _
  unfold factor
  by_cases hij : i = j <;>
    simp_all +decide [Real.sin_int_mul_pi, Real.cos_int_mul_pi]

/-- The commutator-Wilson gate is exactly trivial at `q=pi` for every integer
frequency. -/
theorem wilsonAxis_pi_int (n : Int) :
    wilsonAxis Real.pi (n : Real) = 1 := by
  unfold wilsonAxis uprod factor
  norm_num [show Real.cos (n * Real.pi) = (-1 : Real) ^ n by
    rw [← Real.rpow_intCast, Real.rpow_def_of_neg] <;> norm_num]
  cases' Int.even_or_odd n with h h <;> rw [h.neg_zpow] <;> norm_num

/-- Every integer-frequency member retains all three massless even-corner
zero-quasienergy aliases. -/
theorem successor_even_corners_int (n : Int) :
    successor Real.pi Real.pi 0 (n : Real) 0 = 1 ∧
    successor Real.pi 0 Real.pi (n : Real) 0 = 1 ∧
    successor 0 Real.pi Real.pi (n : Real) 0 = 1 := by
  unfold successor
  unfold uprod
  simp +decide [wilsonAxis_pi_int]
  unfold factor wilsonAxis
  norm_num [Matrix.mul_assoc]
  unfold factor
  norm_num [uprod]

/-- The rational-Pythagorean de-aliasing certificate used by the noninteger
Bloch control cannot be instantiated by any integer finite-range frequency. -/
theorem no_integer_pythagorean_zone_edge (n : Int) :
    ¬ (Real.cos ((n : Real) * Real.pi) = 3 / 5 ∧
       Real.sin ((n : Real) * Real.pi) = 4 / 5) := by
  norm_num [Real.sin_int_mul_pi]

/-- Concrete nonvacuity control at integer range one. -/
theorem range_one_alias_control :
    wilsonAxis Real.pi 1 = 1 ∧ successor Real.pi Real.pi 0 1 0 = 1 := by
  exact ⟨by simpa using wilsonAxis_pi_int 1,
    by simpa using (successor_even_corners_int 1).1⟩

/-- info: 'PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill.wilsonAxis_pi_int' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wilsonAxis_pi_int

/-- info: 'PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill.successor_even_corners_int' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms successor_even_corners_int

/-- info: 'PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill.no_integer_pythagorean_zone_edge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_integer_pythagorean_zone_edge

/-- info: 'PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill.range_one_alias_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms range_one_alias_control

end PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill
