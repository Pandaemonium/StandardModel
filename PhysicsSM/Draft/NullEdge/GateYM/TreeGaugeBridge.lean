import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.IndependentPlaquetteEnsemble

/-!
# Gate YM1: generic tree-gauge bridge - link ensembles with plaquette
coordinates collapse to the independent-plaquette ensemble

`IndependentPlaquetteEnsemble.lean` proved the Wilson-loop expectation area
law in the INDEPENDENT-PLAQUETTE ensemble. The remaining layer of freeze
Theorem 2 is the tree-gauge change of variables identifying the LINK-field
ensemble with that plaquette ensemble. This module proves the GENERIC half of
that layer, isolating exactly what the concrete 2D geometry must supply.

## The abstraction

`PlaquetteCoordinatization P tau`: an equivalence
`LinkField ~ (plaquette coordinates) x (residual coordinates)` under which
the `i`-th plaquette holonomy IS the `i`-th plaquette coordinate. This is
precisely what the comb/spanning-tree gauge supplies on a 2D open rectangle:
the non-tree links biject with plaquettes (triangular change of variables:
each plaquette contains exactly one link not in the tree, so plaquette
holonomies can be solved for link values), and the tree links are the
residual coordinates `tau`.

## What is proved (generic, no geometry)

Given ANY coordinatization:

- `linkPartition_eq`: the link partition function is `|G|^(card tau)` times
  the independent-plaquette partition function (the residual coordinates are
  unweighted and integrate to `|G|` each).
- `linkNumerator_eq` / `linkExpectation_eq_loopExpectation`: for the
  observable `chi(orderedProd of the in-region plaquette holonomies)`, the
  link-ensemble expectation IS `IndependentPlaquetteEnsemble.loopExpectation`;
  the `|G|^(card tau)` factors cancel.
- `wilson_link_loop_expectation_area_law`: combined with the area law, the
  link-ensemble expectation of `chi_R(orderedProd of in-region plaquette
  holonomies)` is EXACTLY `chi_R(1) * wilsonNormalizedGamma^m`.

## What the concrete 2D instance must still supply (NOT proved here)

1. A concrete 2D open-rectangle `OrientedLattice`, its plaquette family, and
   a `PlaquetteCoordinatization` for it (the comb-tree gauge bijection).
2. The loop-holonomy identification: for the rectangular boundary circuit
   `C` enclosing the region `e`, a proof that
   `chi (hol U C) = chi (orderedProd fun k => (P (e k)).hol U)` for class
   functions `chi` - the lasso/comb-ordering decomposition of the Wilson
   loop into enclosed plaquette holonomies (each lasso is conjugated by its
   tail; the comb ordering telescopes the tails, leaving a single overall
   conjugation killed by the class function). Note the identity is NOT true
   for arbitrary orderings in a nonabelian group; the ordering matters.

Item 2 is why the theorems below phrase the observable via plaquette
holonomies rather than a boundary-circuit holonomy: that is the exact
interface the geometric layer must meet.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites: `PlaquetteCore`,
`IndependentPlaquetteEnsemble`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TreeGaugeBridge

open scoped Matrix

open GaugeCoreGeneral PlaquetteCore FusionConvolution IndependentPlaquetteEnsemble
open CategoryTheory

variable {G : Type} [Group G] [Fintype G]
variable {Λ : OrientedLattice}
variable {ι : Type} [Fintype ι] [DecidableEq ι]
variable {τ : Type} [Fintype τ] [DecidableEq τ]

/-- A plaquette coordinatization of a lattice: link fields are equivalent to
(plaquette coordinates) x (residual coordinates), and the `i`-th plaquette
holonomy is the `i`-th plaquette coordinate. The comb/spanning-tree gauge on
a 2D open rectangle supplies exactly this data, with `tau` the tree links. -/
structure PlaquetteCoordinatization (Λ : OrientedLattice) (G : Type) [Group G]
    {ι : Type} (P : ι → Plaquette Λ) (τ : Type) where
  /-- The change of variables from link fields to plaquette + residual
  coordinates. -/
  coord : Λ.LinkField (G := G) ≃ (ι → G) × (τ → G)
  /-- Plaquette holonomies ARE the plaquette coordinates. -/
  hol_coord : ∀ (U : Λ.LinkField (G := G)) (i : ι), (P i).hol U = (coord U).1 i

section LinkEnsemble

variable [Fintype (Λ.LinkField (G := G))]

/-- Complex-valued link-ensemble partition function for a product of local
plaquette weights. (The real Wilson case is the complex cast
`Theorem2AreaLaw.wilsonLocalWeightC`.) -/
def linkPartition (P : ι → Plaquette Λ) (w : G → ℂ) : ℂ :=
  ∑ U : Λ.LinkField (G := G), ∏ i, w ((P i).hol U)

/-- Complex-valued link-ensemble numerator for an arbitrary observable. -/
def linkNumerator (P : ι → Plaquette Λ) (w : G → ℂ)
    (obs : Λ.LinkField (G := G) → ℂ) : ℂ :=
  ∑ U : Λ.LinkField (G := G), (∏ i, w ((P i).hol U)) * obs U

/-- Complex-valued link-ensemble expectation. -/
def linkExpectation (P : ι → Plaquette Λ) (w : G → ℂ)
    (obs : Λ.LinkField (G := G) → ℂ) : ℂ :=
  linkNumerator P w obs / linkPartition P w

/-- Under a plaquette coordinatization, the link partition function is
`|G|^(card tau)` times the independent-plaquette partition function: the
residual (tree) coordinates are unweighted. -/
theorem linkPartition_eq {P : ι → Plaquette Λ}
    (C : PlaquetteCoordinatization Λ G P τ) (w : G → ℂ) :
    linkPartition P w
      = (Fintype.card G : ℂ) ^ Fintype.card τ * partition w ι := by
  rw [linkPartition, ← Equiv.sum_comp C.coord.symm
    (fun U : Λ.LinkField (G := G) => ∏ i, w ((P i).hol U)),
    Fintype.sum_prod_type]
  have hterm : ∀ (V : ι → G) (t : τ → G),
      (∏ i, w ((P i).hol (C.coord.symm (V, t)))) = ∏ i, w (V i) := by
    intro V t
    refine Finset.prod_congr rfl ?_
    intro i _hi
    rw [C.hol_coord (C.coord.symm (V, t)) i, Equiv.apply_symm_apply]
  calc
    ∑ V : ι → G, ∑ t : τ → G, ∏ i, w ((P i).hol (C.coord.symm (V, t)))
        = ∑ V : ι → G, ∑ _t : τ → G, ∏ i, w (V i) := by
          refine Finset.sum_congr rfl ?_
          intro V _hV
          exact Finset.sum_congr rfl fun t _ht => hterm V t
    _ = ∑ V : ι → G, (Fintype.card G : ℂ) ^ Fintype.card τ * ∏ i, w (V i) := by
          refine Finset.sum_congr rfl ?_
          intro V _hV
          rw [Finset.sum_const, Finset.card_univ, Fintype.card_fun,
            nsmul_eq_mul]
          push_cast
          ring
    _ = (Fintype.card G : ℂ) ^ Fintype.card τ * partition w ι := by
          simp only [IndependentPlaquetteEnsemble.partition]
          rw [Finset.mul_sum]

/-- Under a plaquette coordinatization, the link numerator with the
`chi(orderedProd of in-region plaquette holonomies)` observable is
`|G|^(card tau)` times the independent-plaquette loop numerator. -/
theorem linkNumerator_eq {P : ι → Plaquette Λ}
    (C : PlaquetteCoordinatization Λ G P τ) (w chi : G → ℂ)
    {m : ℕ} (e : Fin m ↪ ι) :
    linkNumerator P w
        (fun U => chi (orderedProd fun k => (P (e k)).hol U))
      = (Fintype.card G : ℂ) ^ Fintype.card τ * loopNumerator w chi e := by
  rw [linkNumerator, ← Equiv.sum_comp C.coord.symm
    (fun U : Λ.LinkField (G := G) =>
      (∏ i, w ((P i).hol U)) * chi (orderedProd fun k => (P (e k)).hol U)),
    Fintype.sum_prod_type]
  have hterm : ∀ (V : ι → G) (t : τ → G),
      (∏ i, w ((P i).hol (C.coord.symm (V, t))))
          * chi (orderedProd fun k => (P (e k)).hol (C.coord.symm (V, t)))
        = (∏ i, w (V i)) * chi (orderedProd fun k => V (e k)) := by
    intro V t
    congr 1
    · refine Finset.prod_congr rfl ?_
      intro i _hi
      rw [C.hol_coord (C.coord.symm (V, t)) i, Equiv.apply_symm_apply]
    · congr 2
      funext k
      rw [C.hol_coord (C.coord.symm (V, t)) (e k), Equiv.apply_symm_apply]
  calc
    ∑ V : ι → G, ∑ t : τ → G,
        (∏ i, w ((P i).hol (C.coord.symm (V, t))))
          * chi (orderedProd fun k => (P (e k)).hol (C.coord.symm (V, t)))
        = ∑ V : ι → G, ∑ _t : τ → G,
            (∏ i, w (V i)) * chi (orderedProd fun k => V (e k)) := by
          refine Finset.sum_congr rfl ?_
          intro V _hV
          exact Finset.sum_congr rfl fun t _ht => hterm V t
    _ = ∑ V : ι → G, (Fintype.card G : ℂ) ^ Fintype.card τ
          * ((∏ i, w (V i)) * chi (orderedProd fun k => V (e k))) := by
          refine Finset.sum_congr rfl ?_
          intro V _hV
          rw [Finset.sum_const, Finset.card_univ, Fintype.card_fun,
            nsmul_eq_mul]
          push_cast
          ring
    _ = (Fintype.card G : ℂ) ^ Fintype.card τ * loopNumerator w chi e := by
          simp only [IndependentPlaquetteEnsemble.loopNumerator]
          rw [Finset.mul_sum]

/-- **Generic tree-gauge bridge.** Under any plaquette coordinatization, the
link-ensemble expectation of `chi(orderedProd of in-region plaquette
holonomies)` equals the independent-plaquette `loopExpectation`: the
residual-coordinate factors `|G|^(card tau)` cancel between numerator and
partition function. -/
theorem linkExpectation_eq_loopExpectation {P : ι → Plaquette Λ}
    (C : PlaquetteCoordinatization Λ G P τ) (w chi : G → ℂ)
    {m : ℕ} (e : Fin m ↪ ι) :
    linkExpectation P w
        (fun U => chi (orderedProd fun k => (P (e k)).hol U))
      = loopExpectation w chi e := by
  rw [linkExpectation, linkPartition_eq C w, linkNumerator_eq C w chi e,
    loopExpectation]
  have hc : (Fintype.card G : ℂ) ^ Fintype.card τ ≠ 0 :=
    pow_ne_zero _ (Nat.cast_ne_zero.mpr Fintype.card_ne_zero)
  rw [mul_div_mul_left _ _ hc]

/-- **Theorem 2, link-ensemble form modulo geometry.** Under any plaquette
coordinatization, the link-ensemble Wilson expectation of
`chi_R(orderedProd of in-region plaquette holonomies)` is EXACTLY
`chi_R(1) * wilsonNormalizedGamma^m`. The only remaining gap to the freeze
statement is geometric: constructing a coordinatization for the concrete 2D
open rectangle and identifying this observable with the boundary-circuit
Wilson loop (comb-ordering lasso decomposition). -/
theorem wilson_link_loop_expectation_area_law {n : ℕ}
    {P : ι → Plaquette Λ}
    (C : PlaquetteCoordinatization Λ G P τ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep ℂ G) [Simple R]
    {m : ℕ} (hm : m ≤ Fintype.card ι) (e : Fin m ↪ ι) :
    linkExpectation P (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
        (fun U => R.character (orderedProd fun k => (P (e k)).hol U))
      = R.character 1 * Theorem2AreaLaw.wilsonNormalizedGamma beta rho R ^ m := by
  rw [linkExpectation_eq_loopExpectation C
    (Theorem2AreaLaw.wilsonLocalWeightC beta rho) R.character e,
    wilson_loop_expectation_area_law beta rho hmul hone hunit R hm e]

end LinkEnsemble

end TreeGaugeBridge
end GateYM
end NullEdge
end Draft
end PhysicsSM
