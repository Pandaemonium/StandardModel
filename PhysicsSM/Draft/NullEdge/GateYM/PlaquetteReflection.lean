import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionWalk

/-!
# Gate YM3: plaquette reflection holonomy

This draft module lifts the walk-level reflection identity from
`ReflectionWalk` to the abstract four-step plaquettes of `PlaquetteCore`.
It also records the induced finite product-weight identity after replacing
the local weight on `G` by the corresponding local weight on `MulOpposite G`.
For a reflection-stable finite plaquette family, the product weight is
reflection-invariant once the remaining local opposite-group compatibility is
supplied explicitly as a hypothesis.
The file also provides a small paired-family constructor: if two finite
plaquette families are explicitly identified as each other's mirrors, their
disjoint union is mirror-stable by swapping the pair index.
The paired-family constructor also has a direct product-weight corollary, so it
can feed either the abstract product API or the real-valued ensemble wrappers.
The result is still algebraic scaffolding, not reflection positivity: it does
not prove Wilson action reflection covariance for a reflection-stable plaquette
set, cut factorization, or the RP-LINK inequality.

Conventions:
* plaquette boundaries are the typed closed 4-walks from `PlaquetteCore`;
* link reflection uses the endpoint-reversing `ReflectionCore.Reflection`;
* the noncommutative order reversal is recorded in `MulOpposite G`, exactly as
  in `ReflectionWalk`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity**.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PlaquetteReflection

open GaugeCoreGeneral ReflectionCore PlaquetteCore

variable {Λ : OrientedLattice}
variable (R : ReflectionCore.Reflection Λ)

/-- Reflect a plaquette by reversing its boundary orientation and reflecting
all four steps. This is the plaquette-level packaging of
`ReflectionCore.Reflection.mirrorWalk`. -/
def mirrorPlaquette (p : Plaquette Λ) : Plaquette Λ where
  base := R.reflectV p.base
  v1 := R.reflectV p.v3
  v2 := R.reflectV p.v2
  v3 := R.reflectV p.v1
  step0 := R.reflectStep p.step3
  step1 := R.reflectStep p.step2
  step2 := R.reflectStep p.step1
  step3 := R.reflectStep p.step0

/-- The reflected plaquette walk is definitionally the reflected/reversed walk
from `ReflectionWalk`. -/
theorem mirrorPlaquette_walk (p : Plaquette Λ) :
    (mirrorPlaquette R p).walk = R.mirrorWalk p.walk := by
  rfl

variable {G : Type*} [Group G]

/-- **Plaquette-level mirror holonomy identity (N3 fix).**

With the corrected inverse-carrying `reflectLinkField`, the mirror plaquette's
holonomy at `U` is the GROUP INVERSE of the original plaquette's holonomy at
the reflected link field `theta U`. This is the honest same-group replacement
for the previous `MulOpposite`-valued `op_hol_reflectLinkField_mirrorPlaquette`
(pure word reversal), which was not a conjugacy-class invariant for nonabelian
groups (see `MirrorHolonomyConjugation.lean`). -/
theorem hol_mirrorPlaquette_eq_inv
    (p : Plaquette Λ) (U : Λ.LinkField (G := G)) :
    (mirrorPlaquette R p).hol U = (p.hol (R.reflectLinkField U))⁻¹ := by
  change OrientedLattice.hol U (mirrorPlaquette R p).walk =
      (OrientedLattice.hol (R.reflectLinkField U) p.walk)⁻¹
  rw [mirrorPlaquette_walk]
  exact R.hol_mirrorWalk_eq_inv U p.walk

/-- Pointwise local-weight form of plaquette reflection (N3 fix).

If a local weight is invariant under group inversion (`hinv`, e.g. the real
character of a unitary representation), its value on the mirror plaquette at
`U` equals its value on the original plaquette at the reflected link field
`theta U` - no `MulOpposite` needed. -/
theorem localWeight_hol_mirrorPlaquette
    {α : Type*} (localWeight : G → α)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (p : Plaquette Λ) (U : Λ.LinkField (G := G)) :
    localWeight ((mirrorPlaquette R p).hol U) =
      localWeight (p.hol (R.reflectLinkField U)) := by
  rw [hol_mirrorPlaquette_eq_inv, hinv]

/-- Finite product-weight form of plaquette reflection (N3 fix).

For an inversion-invariant local weight, the product weight of the mirrored
plaquette family at `U` equals the product weight of the original family at
the reflected link field `theta U`. -/
theorem productWeight_reflectLinkField_mirrorPlaquette
    {ι M : Type*} [Fintype ι] [CommMonoid M]
    (P : ι → Plaquette Λ) (localWeight : G → M)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight (fun i => mirrorPlaquette R (P i)) localWeight U =
      PlaquetteCore.productWeight P localWeight (R.reflectLinkField U) := by
  unfold PlaquetteCore.productWeight
  refine Finset.prod_congr rfl ?_
  intro i _hi
  exact localWeight_hol_mirrorPlaquette R localWeight hinv (P i) U

/-- A finite plaquette family is stable under reflection if reflection mirrors
the family up to a finite reindexing. -/
def IsMirrorStableFamily {ι : Type*} (P : ι → Plaquette Λ) (τ : ι ≃ ι) : Prop :=
  ∀ i : ι, mirrorPlaquette R (P i) = P (τ i)

/-- The index swap for a paired plaquette family containing a family and its
reflected partner. -/
def mirrorPairIndexEquiv {ι : Type*} : Bool × ι ≃ Bool × ι where
  toFun
    | (false, i) => (true, i)
    | (true, i) => (false, i)
  invFun
    | (false, i) => (true, i)
    | (true, i) => (false, i)
  left_inv := by
    intro x
    cases x with
    | mk b i => cases b <;> rfl
  right_inv := by
    intro x
    cases x with
    | mk b i => cases b <;> rfl

/-- Pair two plaquette families as opposite reflection partners. This is a
small reusable constructor for concrete finite reflection-stable plaquette sets:
the geometry-specific work is reduced to proving the two mirror-direction
equalities used by `mirrorPairFamily_isMirrorStable`. -/
def mirrorPairFamily {ι : Type*} (P Q : ι → Plaquette Λ) : Bool × ι → Plaquette Λ
  | (false, i) => P i
  | (true, i) => Q i

/-- A paired plaquette family is mirror-stable once each half is explicitly
identified as the mirror of the other half. This avoids assuming a concrete
coordinate lattice or a canonical plaquette enumeration. -/
theorem mirrorPairFamily_isMirrorStable {ι : Type*} (P Q : ι → Plaquette Λ)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i) :
    IsMirrorStableFamily R (mirrorPairFamily P Q) (mirrorPairIndexEquiv (ι := ι)) := by
  intro x
  cases x with
  | mk b i =>
      cases b <;> simp [mirrorPairFamily, mirrorPairIndexEquiv, hPQ, hQP]

/-- Reflection invariance of a product plaquette weight for a mirror-stable
family (N3-corrected convention).

The local weight need only be invariant under group inversion (`hinv`); for a
concrete Wilson weight this is exactly the unitary-representation inversion
symmetry `Re chi(g^{-1}) = Re chi(g)`. This replaces the previous
opposite-group compatibility hypothesis, which was the workaround for the
uncorrected word-reversal convention. This theorem still only handles the
finite reindexing and product bookkeeping. -/
theorem productWeight_reflectLinkField_of_mirrorStable
    {ι M : Type*} [Fintype ι] [CommMonoid M]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → M)
    (hstable : IsMirrorStableFamily R P τ)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight P localWeight (R.reflectLinkField U) =
      PlaquetteCore.productWeight P localWeight U := by
  unfold PlaquetteCore.productWeight
  calc
    (∏ i : ι, localWeight ((P i).hol (R.reflectLinkField U)))
        = ∏ i : ι, localWeight ((P (τ i)).hol U) := by
          refine Finset.prod_congr rfl ?_
          intro i _hi
          have h := hol_mirrorPlaquette_eq_inv R (P i) U
          rw [hstable i] at h
          rw [h, hinv]
    _ = ∏ i : ι, localWeight ((P i).hol U) := by
          simpa using (Equiv.prod_comp τ (fun i => localWeight ((P i).hol U)))

/-- Product-weight reflection invariance for a paired plaquette family whose two
halves are explicitly identified as mirror partners. This is the paired-family
specialization of `productWeight_reflectLinkField_of_mirrorStable`. -/
theorem productWeight_reflectLinkField_of_mirrorPair
    {ι M : Type*} [Fintype ι] [CommMonoid M]
    (P Q : ι → Plaquette Λ) (localWeight : G → M)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight (mirrorPairFamily P Q) localWeight (R.reflectLinkField U) =
      PlaquetteCore.productWeight (mirrorPairFamily P Q) localWeight U := by
  exact productWeight_reflectLinkField_of_mirrorStable R (mirrorPairFamily P Q)
    (mirrorPairIndexEquiv (ι := ι)) localWeight
    (mirrorPairFamily_isMirrorStable R P Q hPQ hQP) hinv U

end PlaquetteReflection
end GateYM
end NullEdge
end Draft
end PhysicsSM
