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

/-- Plaquette-level form of the reflected-walk holonomy identity.

The opposite group is load-bearing: for nonabelian gauge groups, reflecting a
boundary reverses multiplication order, so a same-group inverse statement would
be false in general. -/
theorem op_hol_reflectLinkField_mirrorPlaquette
    (p : Plaquette Λ) (U : Λ.LinkField (G := G)) :
    MulOpposite.op (p.hol (R.reflectLinkField U)) =
      (mirrorPlaquette R p).hol (ReflectionCore.Reflection.opLinkField U) := by
  change MulOpposite.op (OrientedLattice.hol (R.reflectLinkField U) p.walk) =
      OrientedLattice.hol (ReflectionCore.Reflection.opLinkField U)
        (mirrorPlaquette R p).walk
  rw [mirrorPlaquette_walk]
  exact R.op_hol_reflectLinkField_mirrorWalk U p.walk

/-- Pointwise local-weight form of plaquette reflection.

The reflected plaquette over a `G`-valued link field is compared with the
mirrored plaquette over the pointwise opposite-group link field. This packages
`op_hol_reflectLinkField_mirrorPlaquette` in the form needed for product
weights. -/
theorem localWeight_hol_reflectLinkField_mirrorPlaquette
    {α : Type*} (localWeight : G → α)
    (p : Plaquette Λ) (U : Λ.LinkField (G := G)) :
    localWeight (p.hol (R.reflectLinkField U)) =
      (fun h : MulOpposite G => localWeight h.unop)
        ((mirrorPlaquette R p).hol (ReflectionCore.Reflection.opLinkField U)) := by
  have h := op_hol_reflectLinkField_mirrorPlaquette R p U
  rw [← h]
  simp

/-- Finite product-weight form of plaquette reflection.

This is the first product-level bridge from reflected link fields to mirrored
plaquette families. It intentionally stops before asserting that a chosen
plaquette family is reflection-stable or that a Wilson local weight has the
extra symmetry needed to identify the opposite-group expression with the
original Wilson action. -/
theorem productWeight_reflectLinkField_mirrorPlaquette
    {ι M : Type*} [Fintype ι] [CommMonoid M]
    (P : ι → Plaquette Λ) (localWeight : G → M)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight P localWeight (R.reflectLinkField U) =
      PlaquetteCore.productWeight (fun i => mirrorPlaquette R (P i))
        (fun h : MulOpposite G => localWeight h.unop)
        (ReflectionCore.Reflection.opLinkField U) := by
  unfold PlaquetteCore.productWeight
  refine Finset.prod_congr rfl ?_
  intro i _hi
  exact localWeight_hol_reflectLinkField_mirrorPlaquette R localWeight (P i) U

/-- A finite plaquette family is stable under reflection if reflection mirrors
the family up to a finite reindexing. -/
def IsMirrorStableFamily {ι : Type*} (P : ι → Plaquette Λ) (τ : ι ≃ ι) : Prop :=
  ∀ i : ι, mirrorPlaquette R (P i) = P (τ i)

/-- Reflection invariance of a product plaquette weight for a mirror-stable
family, assuming the local weight has the required opposite-group compatibility.

The compatibility hypothesis is intentionally explicit. For a concrete Wilson
weight it should come from the chosen orientation/unitarity convention; this
theorem only proves the finite reindexing and product bookkeeping. -/
theorem productWeight_reflectLinkField_of_mirrorStable
    {ι M : Type*} [Fintype ι] [CommMonoid M]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → M)
    (hstable : IsMirrorStableFamily R P τ)
    (U : Λ.LinkField (G := G))
    (hop : ∀ i : ι,
      (fun h : MulOpposite G => localWeight h.unop)
        ((P i).hol (ReflectionCore.Reflection.opLinkField U)) =
      localWeight ((P i).hol U)) :
    PlaquetteCore.productWeight P localWeight (R.reflectLinkField U) =
      PlaquetteCore.productWeight P localWeight U := by
  rw [productWeight_reflectLinkField_mirrorPlaquette R P localWeight U]
  unfold PlaquetteCore.productWeight
  calc
    (∏ i : ι,
        (fun h : MulOpposite G => localWeight h.unop)
          ((mirrorPlaquette R (P i)).hol (ReflectionCore.Reflection.opLinkField U)))
        =
      ∏ i : ι,
        (fun h : MulOpposite G => localWeight h.unop)
          ((P (τ i)).hol (ReflectionCore.Reflection.opLinkField U)) := by
          refine Finset.prod_congr rfl ?_
          intro i _hi
          rw [hstable i]
    _ = ∏ i : ι, localWeight ((P (τ i)).hol U) := by
          refine Finset.prod_congr rfl ?_
          intro i _hi
          rw [hop (τ i)]
    _ = ∏ i : ι, localWeight ((P i).hol U) := by
          simpa using (Equiv.prod_comp τ (fun i => localWeight ((P i).hol U)))

end PlaquetteReflection
end GateYM
end NullEdge
end Draft
end PhysicsSM
