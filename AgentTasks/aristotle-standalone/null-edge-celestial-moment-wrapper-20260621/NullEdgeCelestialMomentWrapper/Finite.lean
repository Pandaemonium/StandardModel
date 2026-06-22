import Mathlib

/-!
# Celestial moment wrapper

Standalone finite real-vector algebra for the Bloch/celestial rewrite of
Pluecker mass.

The intended interpretation is:

* `w i` is the energy/weight of a visible null edge;
* `dir i : Fin 3 -> R` is its unit celestial direction;
* `totalWeight w` is the monopole;
* `weightedDipole w dir` is the spatial dipole;
* `angularVarianceMass w dir` is one quarter of the missing dipole.

The main target proves that, for unit directions, the missing-dipole expression
is the pairwise weighted chordal angular variance.
-/

noncomputable section

namespace NullEdgeCelestialMomentWrapper

open BigOperators

abbrev Vec3 := Fin 3 -> Real

def dot3 (x y : Vec3) : Real :=
  ∑ k : Fin 3, x k * y k

def normSq3 (x : Vec3) : Real :=
  dot3 x x

def finPairIndexSet (n : Nat) : Finset (Fin n × Fin n) :=
  Finset.univ.filter fun p => (p.1 : Nat) < (p.2 : Nat)

def totalWeight {n : Nat} (w : Fin n -> Real) : Real :=
  ∑ i : Fin n, w i

def weightedDipole {n : Nat}
    (w : Fin n -> Real) (dir : Fin n -> Vec3) : Vec3 :=
  fun k => ∑ i : Fin n, w i * dir i k

def angularVarianceMass {n : Nat}
    (w : Fin n -> Real) (dir : Fin n -> Vec3) : Real :=
  (1 / 4 : Real) *
    ((totalWeight w) ^ 2 - normSq3 (weightedDipole w dir))

def chordalPairMass {n : Nat}
    (w : Fin n -> Real) (dir : Fin n -> Vec3) : Real :=
  (1 / 4 : Real) *
    ∑ p ∈ finPairIndexSet n,
      w p.1 * w p.2 *
        normSq3 (fun k => dir p.1 k - dir p.2 k)

def UnitDirections {n : Nat} (dir : Fin n -> Vec3) : Prop :=
  ∀ i : Fin n, normSq3 (dir i) = 1

def DipoleSaturates {n : Nat}
    (w : Fin n -> Real) (dir : Fin n -> Vec3) : Prop :=
  normSq3 (weightedDipole w dir) = (totalWeight w) ^ 2

/--
The Bloch/celestial missing-dipole mass equals weighted chordal angular
variance, assuming every celestial direction is unit length.
-/
theorem angularVarianceMass_eq_chordalPairMass {n : Nat}
    (w : Fin n -> Real) (dir : Fin n -> Vec3)
    (hunit : UnitDirections dir) :
    angularVarianceMass w dir = chordalPairMass w dir := by
  sorry

/--
The finite mass diagnostic vanishes exactly when the weighted dipole saturates
the monopole.
-/
theorem angularVarianceMass_zero_iff_dipoleSaturates {n : Nat}
    (w : Fin n -> Real) (dir : Fin n -> Vec3) :
    angularVarianceMass w dir = 0 ↔ DipoleSaturates w dir := by
  sorry

end NullEdgeCelestialMomentWrapper

end
