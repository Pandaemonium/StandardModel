import Mathlib

/-!
# Finite spinor-network closure and celestial mass

This standalone Aristotle target isolates the finite moment-map identity behind
the spinor-network/closure sharpening of the null-edge program.

The vectors `u i` should be read as unit celestial directions and the weights
`w i` as visible null energies.  The theorem says that the pairwise angular
spread of the fan is exactly the Minkowski-style mass square
`(E^2 - |C|^2) / 4`, where `C = sum_i w_i u_i` is the closure vector.
-/

noncomputable section

namespace NullEdgeSpinorNetworkClosure

open BigOperators

/-- A real three-vector in coordinates. -/
abbrev Vec3 := Fin 3 -> Real

/-- Euclidean dot product on coordinate three-vectors. -/
def dot (a b : Vec3) : Real :=
  Finset.univ.sum fun k : Fin 3 => a k * b k

/-- Squared Euclidean norm. -/
def normSq (a : Vec3) : Real :=
  dot a a

/-- Total visible null energy of a finite weighted fan. -/
def energy {n : Nat} (w : Fin n -> Real) : Real :=
  Finset.univ.sum fun i : Fin n => w i

/-- Closure / total spatial momentum vector of a finite weighted fan. -/
def closureVector {n : Nat}
    (w : Fin n -> Real) (u : Fin n -> Vec3) : Vec3 :=
  fun k : Fin 3 => Finset.univ.sum fun i : Fin n => w i * u i k

/--
Pairwise angular mass of a weighted celestial fan:
`sum_{i<j} w_i w_j (1 - u_i . u_j) / 2`.
-/
def pairwiseAngularMass {n : Nat}
    (w : Fin n -> Real) (u : Fin n -> Vec3) : Real :=
  ((Finset.univ : Finset (Fin n × Fin n)).filter fun p => p.1 < p.2).sum
    fun p => (w p.1 * w p.2 * (1 - dot (u p.1) (u p.2))) / 2

/--
Moment-map mass square of a weighted celestial fan:
`(E^2 - |C|^2) / 4`.
-/
def momentMassSq {n : Nat}
    (w : Fin n -> Real) (u : Fin n -> Vec3) : Real :=
  (energy w ^ 2 - normSq (closureVector w u)) / 4

/--
Main finite closure identity.  For unit celestial directions, pairwise angular
spread equals the mass square obtained from the energy and closure vector.
-/
theorem pluckerMass_eq_energy_sq_sub_closureDefect_sq
    {n : Nat} (w : Fin n -> Real) (u : Fin n -> Vec3)
    (hunit : ∀ i : Fin n, normSq (u i) = 1) :
    pairwiseAngularMass w u = momentMassSq w u := by
  sorry

/--
If the weighted fan is closed, its moment-map mass square is the rest-frame
value `E^2 / 4`.
-/
theorem closed_spinorFan_mass_eq_energy_sq_over_four
    {n : Nat} (w : Fin n -> Real) (u : Fin n -> Vec3)
    (hclosed : closureVector w u = 0) :
    momentMassSq w u = energy w ^ 2 / 4 := by
  unfold momentMassSq
  rw [hclosed]
  simp [normSq, dot]

/--
The pairwise angular mass has the rest-frame value when the unit fan is closed.
-/
theorem closed_spinorFan_is_restFrame
    {n : Nat} (w : Fin n -> Real) (u : Fin n -> Vec3)
    (hunit : ∀ i : Fin n, normSq (u i) = 1)
    (hclosed : closureVector w u = 0) :
    pairwiseAngularMass w u = energy w ^ 2 / 4 := by
  rw [pluckerMass_eq_energy_sq_sub_closureDefect_sq w u hunit]
  exact closed_spinorFan_mass_eq_energy_sq_over_four w u hclosed

end NullEdgeSpinorNetworkClosure

end
