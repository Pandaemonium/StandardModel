import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.TreeGaugeBridge

/-!
# Gate YM1: the concrete 2D open rectangle and its comb-gauge
coordinatization - the area law lands on a real lattice

This module integrates Aristotle project `1d9b5b19` (task note
`AgentTasks/ym1-treegauge-rect-aristotle-2026-07-04.md`): the comb-gauge
plaquette coordinatization of the `Lx x Ly` open (free-boundary) rectangle,
i.e. the classical tree-gauge change of variables behind the 2D lattice
Yang-Mills exact solution. Combined with the generic bridge
(`TreeGaugeBridge.lean`), the finite-group Wilson-loop area law now holds on
a CONCRETE lattice: `rect_wilson_loop_expectation_area_law` below.

## Conventions (oracle/freeze C-1, C-2 compatible; pinned by `rfl`)

- Vertices `Fin (Lx+1) x Fin (Ly+1)`; horizontal links `Sum.inl (i, j)`
  from `(i, j)` to `(i+1, j)`; vertical links `Sum.inr (i, j)` from
  `(i, j)` to `(i, j+1)`.
- Plaquette `(i, j)`: counterclockwise right/up/left(rev)/down(rev); the
  exact holonomy formula is kernel-pinned by `rectPlaquette_hol_formula`
  (a `rfl` lemma - any convention drift breaks it).
- Comb tree: ALL horizontal links plus the leftmost vertical column;
  non-tree links (one per plaquette, row by row) are the vertical links
  with `i >= 1`.

## Provenance

Definitions and the pinned formula were prepared in-repo (2026-07-04); the
coordinatization construction (`rectToCoord` bijectivity: per-row
`Fin.induction` injectivity plus cardinality bookkeeping) was produced by
Aristotle project `1d9b5b19-bbd4-4d29-9c15-1ee08156ec95` on the standalone
package `AgentTasks/aristotle-standalone/ym1-treegauge-rect-20260704/` and
integrated here after semantic review (conventions unchanged, statement not
weakened, no added hypotheses). Axiom footprint verified locally:
`[propext, Classical.choice, Quot.sound]`.

## What remains for the freeze Theorem 2 statement (explicit)

The observable in `rect_wilson_loop_expectation_area_law` is
`chi_R(orderedProd of the region's plaquette holonomies)`. Identifying it
with the boundary-circuit Wilson loop `chi_R(hol U (rectangle boundary))`
is the comb-ordering lasso decomposition - a separate finite-geometry
theorem, not yet attempted (planned as the next focused Aristotle job).

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`GaugeCoreGeneral`, `PlaquetteCore`, `TreeGaugeBridge`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace RectTreeGauge

open scoped Matrix

open GaugeCoreGeneral PlaquetteCore CategoryTheory

/-- Link type of the `Lx x Ly` open rectangle: horizontal links (left) and
vertical links (right). -/
abbrev RectE (Lx Ly : ℕ) : Type :=
  (Fin Lx × Fin (Ly + 1)) ⊕ (Fin (Lx + 1) × Fin Ly)

/-- The `Lx x Ly` open-rectangle lattice. -/
def rectLattice (Lx Ly : ℕ) : OrientedLattice where
  V := Fin (Lx + 1) × Fin (Ly + 1)
  E := RectE Lx Ly
  src := Sum.elim (fun h => (h.1.castSucc, h.2)) (fun v => (v.1, v.2.castSucc))
  tgt := Sum.elim (fun h => (h.1.succ, h.2)) (fun v => (v.1, v.2.succ))

instance (Lx Ly : ℕ) : Fintype (rectLattice Lx Ly).E :=
  inferInstanceAs (Fintype (RectE Lx Ly))

instance (Lx Ly : ℕ) : DecidableEq (rectLattice Lx Ly).E :=
  inferInstanceAs (DecidableEq (RectE Lx Ly))

/-- The counterclockwise plaquette at `(i, j)`: right, up, left, down. -/
def rectPlaquette (Lx Ly : ℕ) (p : Fin Lx × Fin Ly) :
    Plaquette (rectLattice Lx Ly) where
  base := (p.1.castSucc, p.2.castSucc)
  v1 := (p.1.succ, p.2.castSucc)
  v2 := (p.1.succ, p.2.succ)
  v3 := (p.1.castSucc, p.2.succ)
  step0 := OrientedLattice.Step.fwd (Λ := rectLattice Lx Ly) (Sum.inl (p.1, p.2.castSucc))
  step1 := OrientedLattice.Step.fwd (Λ := rectLattice Lx Ly) (Sum.inr (p.1.succ, p.2))
  step2 := OrientedLattice.Step.rev (Λ := rectLattice Lx Ly) (Sum.inl (p.1, p.2.succ))
  step3 := OrientedLattice.Step.rev (Λ := rectLattice Lx Ly) (Sum.inr (p.1.castSucc, p.2))

/-- Residual (tree) link type: all horizontal links, plus the leftmost
column of vertical links. -/
abbrev RectTree (Lx Ly : ℕ) : Type :=
  (Fin Lx × Fin (Ly + 1)) ⊕ Fin Ly

/-- Embedding of tree coordinates into the link type. -/
def treeLink (Lx Ly : ℕ) : RectTree Lx Ly → RectE Lx Ly
  | Sum.inl h => Sum.inl h
  | Sum.inr j => Sum.inr ((0 : Fin (Lx + 1)), j)

variable {G : Type} [Group G]

/-- Convention pin: the plaquette holonomy formula, kernel-checked by `rfl`.
`hol p(i,j) = U_h(i,j) * (U_v(i+1,j) * (U_h(i,j+1)^(-1) * (U_v(i,j)^(-1) * 1)))`. -/
theorem rectPlaquette_hol_formula {Lx Ly : ℕ}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (p : Fin Lx × Fin Ly) :
    (rectPlaquette Lx Ly p).hol U
      = U (Sum.inl (p.1, p.2.castSucc))
        * (U (Sum.inr (p.1.succ, p.2))
          * ((U (Sum.inl (p.1, p.2.succ)))⁻¹
            * ((U (Sum.inr (p.1.castSucc, p.2)))⁻¹ * 1))) := rfl

/-- The designed-in forward map: a link field maps to its tuple of plaquette
holonomies together with its restriction to the tree links. With this choice
the `hol_coord` interface field is definitional. -/
def rectToCoord (Lx Ly : ℕ) (G : Type) [Group G] :
    (rectLattice Lx Ly).LinkField (G := G) →
      (Fin Lx × Fin Ly → G) × (RectTree Lx Ly → G) :=
  fun U => (fun p => (rectPlaquette Lx Ly p).hol U, fun t => U (treeLink Lx Ly t))

/-- Row-independence induction core (Aristotle `1d9b5b19`): if two link
fields agree on all horizontal links and on the leftmost vertical column,
and have equal plaquette holonomies, then they agree on every vertical link.
`Fin.induction` on the column index within each row, via the pinned
holonomy formula. -/
lemma rectVertical_eq {Lx Ly : ℕ}
    (U U' : (rectLattice Lx Ly).LinkField (G := G))
    (h_h : ∀ h, U (Sum.inl h) = U' (Sum.inl h))
    (h_v0 : ∀ j : Fin Ly, U (Sum.inr ((0 : Fin (Lx + 1)), j))
      = U' (Sum.inr ((0 : Fin (Lx + 1)), j)))
    (h_hol : ∀ p : Fin Lx × Fin Ly,
      (rectPlaquette Lx Ly p).hol U = (rectPlaquette Lx Ly p).hol U') :
    ∀ (j : Fin Ly) (i : Fin (Lx + 1)), U (Sum.inr (i, j)) = U' (Sum.inr (i, j)) := by
  intro j i
  induction' i using Fin.induction with i ih
  · exact h_v0 j
  · specialize h_hol (i, j)
    simp_all +decide [rectPlaquette_hol_formula]

/-- The forward map `rectToCoord` is injective (Aristotle `1d9b5b19`). -/
lemma rectToCoord_injective (Lx Ly : ℕ) (G : Type) [Group G] :
    Function.Injective (rectToCoord Lx Ly G) := by
  intro U U' h
  have h1 := congrArg Prod.fst h
  have h2 := congrArg Prod.snd h
  have h_hol : ∀ p : Fin Lx × Fin Ly,
      (rectPlaquette Lx Ly p).hol U = (rectPlaquette Lx Ly p).hol U' := by
    intro p; exact congrFun h1 p
  have h_tree : ∀ t : RectTree Lx Ly, U (treeLink Lx Ly t) = U' (treeLink Lx Ly t) := by
    intro t; exact congrFun h2 t
  have h_h : ∀ hh : Fin Lx × Fin (Ly + 1), U (Sum.inl hh) = U' (Sum.inl hh) := by
    intro hh; exact h_tree (Sum.inl hh)
  have h_v0 : ∀ j : Fin Ly, U (Sum.inr ((0 : Fin (Lx + 1)), j))
      = U' (Sum.inr ((0 : Fin (Lx + 1)), j)) := by
    intro j; exact h_tree (Sum.inr j)
  have h_v := rectVertical_eq U U' h_h h_v0 h_hol
  funext e
  cases e with
  | inl hh => exact h_h hh
  | inr v =>
    obtain ⟨i, j⟩ := v
    exact h_v j i

/-- Cardinality bookkeeping (Aristotle `1d9b5b19`): both sides of
`rectToCoord` have cardinality `|G|^(2 Lx Ly + Lx + Ly)`. -/
lemma rectToCoord_card (Lx Ly : ℕ) (G : Type) [Group G] [Fintype G] :
    Fintype.card (RectE Lx Ly → G)
      = Fintype.card ((Fin Lx × Fin Ly → G) × (RectTree Lx Ly → G)) := by
  simp +decide only [RectE, Fintype.card_fun, Fintype.card_sum,
    Fintype.card_prod, Fintype.card_fin, RectTree]
  rw [← pow_add]
  ring

/-- **The comb-gauge coordinatization of the 2D open rectangle**
(Aristotle `1d9b5b19`): link fields are equivalent to
(plaquette holonomies) x (tree link values), with plaquette holonomies AS
the plaquette coordinates. -/
noncomputable def rectCoordinatization (Lx Ly : ℕ) (G : Type) [Group G]
    [Fintype G] :
    TreeGaugeBridge.PlaquetteCoordinatization (rectLattice Lx Ly) G
      (rectPlaquette Lx Ly) (RectTree Lx Ly) := by
  refine { coord := Equiv.ofBijective (rectToCoord Lx Ly G) ?_,
           hol_coord := fun _ _ => rfl }
  rw [Fintype.bijective_iff_injective_and_card]
  refine ⟨rectToCoord_injective Lx Ly G, ?_⟩
  convert rectToCoord_card Lx Ly G using 2

/-- **Theorem 2 on a concrete lattice.** On the `Lx x Ly` open rectangle,
the link-ensemble Wilson expectation of `chi_R(orderedProd of the region's
plaquette holonomies)`, over ANY ordered region of `m` distinct plaquettes,
is EXACTLY `chi_R(1) * wilsonNormalizedGamma^m`. The only remaining distance
to the freeze statement is the boundary-circuit lasso identification of the
observable (module docstring). -/
theorem rect_wilson_loop_expectation_area_law {n : ℕ} [Fintype G]
    (Lx Ly : ℕ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep ℂ G) [Simple R]
    {m : ℕ} (hm : m ≤ Lx * Ly) (e : Fin m ↪ Fin Lx × Fin Ly) :
    TreeGaugeBridge.linkExpectation (rectPlaquette Lx Ly)
        (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
        (fun U => R.character
          (IndependentPlaquetteEnsemble.orderedProd
            fun k => (rectPlaquette Lx Ly (e k)).hol U))
      = R.character 1 * Theorem2AreaLaw.wilsonNormalizedGamma beta rho R ^ m := by
  have hm' : m ≤ Fintype.card (Fin Lx × Fin Ly) := by
    simpa [Fintype.card_prod, Fintype.card_fin] using hm
  exact TreeGaugeBridge.wilson_link_loop_expectation_area_law
    (rectCoordinatization Lx Ly G) beta rho hmul hone hunit R hm' e

end RectTreeGauge
end GateYM
end NullEdge
end Draft
end PhysicsSM
