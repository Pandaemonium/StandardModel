import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCutPlaquetteExample
import PhysicsSM.Draft.NullEdge.GateYM.WilsonCutPlaquetteEnsemble

/-!
# Gate YM3/Q1: finite indexed families of concrete cut plaquettes

This draft module takes the minimal four-edge cut plaquette from
`ReflectionCutPlaquetteExample.lean` and forms a finite disjoint `K`-indexed
family. The result is a genuine larger cut-bearing lattice with geometrically
distinct plaquettes, one per index, though the components are disconnected and
all have the same local shape.

The module proves the mirror-coordinate holonomy factorization for every
indexed plaquette and then applies `WilsonCutPlaquetteEnsemble.lean` to obtain
reflection positivity for the genuine Wilson `PlaquetteEnsemble.weight` of the
whole finite family, optionally multiplied by a factorized positive/mirror side
contribution.

Scope boundary: this is still not the connected Wilson slab / full RP-LINK
geometry. It is a finite disconnected model that removes another layer of
product-family bookkeeping.

Claim label: **finite identity / concrete disconnected family**. Draft-trust:
kernel-checked; no proof placeholders.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionCutPlaquetteFamily

open scoped Matrix ComplexOrder
open GaugeCoreGeneral PlaquetteCore ReflectionCore
open WilsonWeightPositivity
open ReflectionCutPlaquetteExample
open WilsonCutPlaquetteEnsemble

variable {K : Type} [Fintype K] [DecidableEq K]

/-- The disjoint `K`-indexed sum of the minimal cut-plaquette lattice. -/
def indexedCutPlaqLattice : OrientedLattice where
  V := K × CutPlaqVertex
  E := K × CutPlaqEdge
  src e := (e.1, cutPlaqLattice.src e.2)
  tgt e := (e.1, cutPlaqLattice.tgt e.2)

/-- Vertex reflection acts componentwise on the minimal cut-plaquette
reflection. -/
def indexedReflectVertex : K × CutPlaqVertex → K × CutPlaqVertex :=
  fun v => (v.1, reflectCutPlaqVertex v.2)

/-- Edge reflection acts componentwise on the minimal cut-plaquette
reflection. -/
def indexedReflectEdge : K × CutPlaqEdge → K × CutPlaqEdge :=
  fun e => (e.1, reflectCutPlaqEdge e.2)

/-- Positive-side predicate for the indexed cut-plaquette lattice. -/
def indexedPositiveSide : K × CutPlaqVertex → Prop :=
  fun v => cutPlaqPositiveSide v.2

/-- Reflection structure on the finite disjoint cut-plaquette family. -/
def indexedCutPlaqReflection : Reflection (indexedCutPlaqLattice (K := K)) where
  reflectV := indexedReflectVertex
  reflectE := indexedReflectEdge
  reflectV_involutive := by
    intro v
    cases v with
    | mk k v =>
      cases v <;> rfl
  reflectE_involutive := by
    intro e
    cases e with
    | mk k e =>
      cases e <;> rfl
  reflect_src := by
    intro e
    cases e with
    | mk k e =>
      cases e <;> rfl
  reflect_tgt := by
    intro e
    cases e with
    | mk k e =>
      cases e <;> rfl
  posSide := indexedPositiveSide
  posSide_reflect := by
    intro v
    cases v with
    | mk k v =>
      cases v <;> simp [indexedPositiveSide, indexedReflectVertex,
        reflectCutPlaqVertex, cutPlaqPositiveSide]

/-- The `k`-th concrete cut plaquette in the disjoint indexed family. -/
def cutPlaquetteAt (k : K) : Plaquette (indexedCutPlaqLattice (K := K)) where
  base := (k, CutPlaqVertex.n0)
  v1 := (k, CutPlaqVertex.p0)
  v2 := (k, CutPlaqVertex.p1)
  v3 := (k, CutPlaqVertex.n1)
  step0 := OrientedLattice.Step.fwd (Λ := indexedCutPlaqLattice (K := K))
    (k, CutPlaqEdge.cut0)
  step1 := OrientedLattice.Step.fwd (Λ := indexedCutPlaqLattice (K := K))
    (k, CutPlaqEdge.pos)
  step2 := OrientedLattice.Step.rev (Λ := indexedCutPlaqLattice (K := K))
    (k, CutPlaqEdge.cut1)
  step3 := OrientedLattice.Step.rev (Λ := indexedCutPlaqLattice (K := K))
    (k, CutPlaqEdge.neg)

variable {G : Type} [Group G]

/-- Mirror-coordinate link field for the finite indexed cut-plaquette family. -/
def familyMirrorConfig (a : K → G) (c : K → G × G) (b : K → G) :
    (indexedCutPlaqLattice (K := K)).LinkField (G := G)
  | (k, e) => cutMirrorConfig (a k) (c k) (b k) e

/-- Symmetric read-off word for the `k`-th indexed cut plaquette. -/
def familyCutPlaqEWord (k : K) (c : K → G × G) (x : K → G) : G :=
  cutPlaqEWord (c k) (x k)

omit [Fintype K] [DecidableEq K] in
/-- Holonomy factorization for the `k`-th cut plaquette in the finite disjoint
family. -/
theorem cutPlaquetteAt_hol_familyMirrorConfig
    (k : K) (a b : K → G) (c : K → G × G) :
    (cutPlaquetteAt k).hol (familyMirrorConfig a c b)
      = familyCutPlaqEWord k c a * (familyCutPlaqEWord k c b)⁻¹ := by
  simpa [cutPlaquetteAt, familyMirrorConfig, familyCutPlaqEWord]
    using cutPlaquette_hol_mirrorConfig (a k) (b k) (c k)

variable [Fintype G] {n : ℕ}

omit [Fintype G] [DecidableEq K] in
/-- The genuine Wilson `PlaquetteEnsemble.weight` of the finite disjoint
cut-plaquette family is the product of the indexed Wilson cut kernels. -/
theorem family_weight_mirrorConfig_eq_wilsonKernel_prod
    (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (a b : K → G) (c : K → G × G) :
    PlaquetteEnsemble.weight cutPlaquetteAt
        (WilsonLocalWeight.wilsonLocalWeight beta rho) (familyMirrorConfig a c b)
      = ∏ k : K, wilsonKernel beta rho
          (familyCutPlaqEWord k c a) (familyCutPlaqEWord k c b) :=
  weight_mirrorConfig_eq_wilsonKernel_prod_of_hol_factorization
    cutPlaquetteAt familyMirrorConfig familyCutPlaqEWord
    (fun k a c b => cutPlaquetteAt_hol_familyMirrorConfig k a b c)
    beta rho a c b

/-- Reflection positivity for the genuine Wilson weight of the finite disjoint
cut-plaquette family in mirror coordinates. -/
theorem family_ensemble_reflectionPositive
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    ReflectionPositivityKernel.IsReflectionPositive (A := K → G) (C := K → G × G)
      (fun a c b =>
        ((PlaquetteEnsemble.weight cutPlaquetteAt
            (WilsonLocalWeight.wilsonLocalWeight beta rho)
            (familyMirrorConfig a c b) : ℝ) : ℂ)) :=
  reflectionPositive_of_hol_factorization
    cutPlaquetteAt familyMirrorConfig familyCutPlaqEWord
    (fun k a c b => cutPlaquetteAt_hol_familyMirrorConfig k a b c)
    beta hbeta rho hmul hone hunit

/-- Mixed reflection positivity for a factorized positive/mirror contribution
times the genuine Wilson weight of the finite disjoint cut-plaquette family. -/
theorem factorized_mul_family_ensemble_reflectionPositive
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (h : (K → G) → (K → G × G) → ℂ) :
    ReflectionPositivityKernel.IsReflectionPositive (A := K → G) (C := K → G × G)
      (fun a c b =>
        (h a c * (starRingEnd ℂ) (h b c)) *
          ((PlaquetteEnsemble.weight cutPlaquetteAt
            (WilsonLocalWeight.wilsonLocalWeight beta rho)
            (familyMirrorConfig a c b) : ℝ) : ℂ)) :=
  factorized_mul_reflectionPositive_of_hol_factorization
    cutPlaquetteAt familyMirrorConfig familyCutPlaqEWord
    (fun k a c b => cutPlaquetteAt_hol_familyMirrorConfig k a b c)
    beta hbeta rho hmul hone hunit h

end ReflectionCutPlaquetteFamily
end GateYM
end NullEdge
end Draft
end PhysicsSM
