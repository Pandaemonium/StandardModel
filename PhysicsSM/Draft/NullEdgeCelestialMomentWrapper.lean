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

namespace PhysicsSM.Draft.NullEdgeCelestialMomentWrapper

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
  -- Expand `normSq3` of the dipole as a double sum of pairwise dot products.
  have h_expand : normSq3 (weightedDipole w dir)
      = ∑ i : Fin n, ∑ j : Fin n, w i * w j * dot3 (dir i) (dir j) := by
    unfold weightedDipole normSq3 dot3
    simp +decide only [Finset.sum_mul _ _ _, Finset.mul_sum]
    exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ =>
      Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ =>
        Finset.sum_congr rfl fun _ _ => by ring))
  -- The summand `w i * w j * (1 - dot3 (dir i) (dir j))` is symmetric in `i, j`
  -- and vanishes on the diagonal, so the full double sum is twice the `i < j`
  -- part indexed by `finPairIndexSet`.
  have h_symm : ∑ i : Fin n, ∑ j : Fin n, w i * w j * (1 - dot3 (dir i) (dir j))
      = 2 * ∑ p ∈ finPairIndexSet n,
          w p.1 * w p.2 * (1 - dot3 (dir p.1) (dir p.2)) := by
    have h_split : ∑ i : Fin n, ∑ j : Fin n, w i * w j * (1 - dot3 (dir i) (dir j))
        = ∑ p ∈ Finset.filter (fun p : Fin n × Fin n => p.1 < p.2)
              (Finset.univ ×ˢ Finset.univ),
            w p.1 * w p.2 * (1 - dot3 (dir p.1) (dir p.2))
          + ∑ p ∈ Finset.filter (fun p : Fin n × Fin n => p.1 > p.2)
              (Finset.univ ×ˢ Finset.univ),
            w p.1 * w p.2 * (1 - dot3 (dir p.1) (dir p.2)) := by
      rw [← Finset.sum_union]
      · rw [show (Finset.filter (fun p : Fin n × Fin n => p.1 < p.2)
                (Finset.univ ×ˢ Finset.univ)
              ∪ Finset.filter (fun p : Fin n × Fin n => p.1 > p.2)
                (Finset.univ ×ˢ Finset.univ))
            = Finset.filter (fun p : Fin n × Fin n => p.1 ≠ p.2)
                (Finset.univ ×ˢ Finset.univ) from ?_, Finset.sum_filter]
        · erw [Finset.sum_product]
          simp +decide [Finset.sum_ite, Finset.filter_ne]
          simp +decide [dot3]
          simp +decide [show ∀ i, ∑ k, dir i k * dir i k = 1 from fun i => hunit i]
        · grind
      · exact Finset.disjoint_filter.mpr fun _ _ _ _ => lt_asymm ‹_› ‹_›
    convert h_split using 1
    rw [two_mul,
      show (Finset.univ ×ˢ Finset.univ |> Finset.filter fun p : Fin n × Fin n => p.1 > p.2)
          = Finset.image (fun p : Fin n × Fin n => (p.2, p.1))
              (Finset.univ ×ˢ Finset.univ |> Finset.filter fun p : Fin n × Fin n => p.1 < p.2)
        from ?_, Finset.sum_image] <;> norm_num
    · unfold finPairIndexSet; simp +decide [mul_comm, dot3]
    · exact fun p hp q hq h => by aesop
    · ext ⟨i, j⟩; simp [Finset.mem_image]
  -- Each chordal term is `2 * (1 - dot3 ..)` since the directions are unit length.
  have h_rhs : ∀ i j : Fin n,
      normSq3 (fun k => dir i k - dir j k) = 2 * (1 - dot3 (dir i) (dir j)) := by
    intro i j
    have hi := hunit i; have hj := hunit j
    simp only [normSq3, dot3, Fin.sum_univ_three] at *
    linarith
  unfold angularVarianceMass chordalPairMass; simp_all +decide [mul_sub] ; ring_nf
  norm_num [← Finset.mul_sum _ _ _, ← Finset.sum_mul, totalWeight] at * ; linarith

/--
The finite mass diagnostic vanishes exactly when the weighted dipole saturates
the monopole.
-/
theorem angularVarianceMass_zero_iff_dipoleSaturates {n : Nat}
    (w : Fin n -> Real) (dir : Fin n -> Vec3) :
    angularVarianceMass w dir = 0 ↔ DipoleSaturates w dir := by
  grind +locals

end PhysicsSM.Draft.NullEdgeCelestialMomentWrapper

end
