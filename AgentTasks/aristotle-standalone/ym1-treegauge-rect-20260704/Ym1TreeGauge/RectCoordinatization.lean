import Mathlib

/-!
# YM1 tree-gauge layer: comb-gauge plaquette coordinatization of the 2D
open rectangle

Standalone Mathlib-only target. This file is a focused Aristotle package for
one construction in a larger 2D lattice-gauge-theory formalization program.

## The mathematical goal

On the open (free-boundary) `Lx x Ly` plaquette rectangle, the link-field
configuration space `E -> G` is in bijection with
(plaquette holonomies) x (tree link values), where the spanning "comb" tree
consists of ALL horizontal links plus the leftmost column of vertical links.
This is the classical tree-gauge change of variables behind the 2D lattice
Yang-Mills exact solution: plaquette holonomies become INDEPENDENT
coordinates.

The generic ensemble consequences (partition function factorization, Wilson
area law) are already proved in the parent repository against the
`PlaquetteCoordinatization` interface copied below - this package must ONLY
construct the concrete coordinatization.

## Conventions (fixed, do not change)

- Vertices: `Fin (Lx+1) x Fin (Ly+1)`, coordinate `(i, j)` with `i`
  horizontal, `j` vertical.
- Links (all positively oriented): horizontal links
  `Fin Lx x Fin (Ly+1)` from `(i, j)` to `(i+1, j)`; vertical links
  `Fin (Lx+1) x Fin Ly` from `(i, j)` to `(i, j+1)`. The link type is the
  disjoint sum, horizontal = `Sum.inl`, vertical = `Sum.inr`.
- Traversing a link forward contributes `U e`; backward contributes
  `(U e)^(-1)`.
- Plaquette `(i, j)` (for `i : Fin Lx`, `j : Fin Ly`) is the counterclockwise
  based closed 4-walk from `(i, j)`: right along horizontal `(i, j)`, up
  along vertical `(i+1, j)`, left (reverse) along horizontal `(i, j+1)`,
  down (reverse) along vertical `(i, j)`.
- Holonomy multiplies step contributions left-to-right along the walk with
  right-nested parenthesization (see `hol` below); the kernel-checked
  formula for the plaquette holonomy is pinned by
  `rectPlaquette_hol_formula` (PROVED below by `rfl` - keep it compiling; if
  a change you make breaks it, the change contradicts the conventions).
- Tree (residual) links: ALL horizontal links, plus vertical links in the
  leftmost column `i = 0`. Non-tree links: vertical links with `i >= 1`.
  There are exactly `Lx * Ly` non-tree links, one "solved" by each
  plaquette, row by row: within row `j`, plaquette `(0, j)` determines
  vertical link `(1, j)` from tree data, then plaquette `(1, j)` determines
  vertical link `(2, j)`, and so on. Rows are independent.

## The target

`rectCoordinatization` at the bottom: replace its `s_o_r_r_y` (spelled
normally in the code) with a construction. The DESIGNED-IN easy path:

1. Define the forward map
   `toCoord U := (fun p => (rectPlaquette Lx Ly p).hol U, fun t => U (treeLink t))`.
   With this choice the interface field `hol_coord` is DEFINITIONAL
   (`rfl`), so the entire remaining content is bijectivity.
2. Prove `Function.Bijective toCoord` via
   `Fintype.bijective_iff_injective_and_card` (the card identity is
   `|G|^(2*Lx*Ly + Lx + Ly)` on both sides after `Fintype.card_fun` /
   `Fintype.card_prod` / `Fintype.card_sum` bookkeeping), OR construct an
   explicit inverse by per-row recursion (`Fin.induction` along `i`,
   solving `U_v(i+1, j)` from the plaquette value `(i, j)`, the three
   already-known links, and the pinned holonomy formula), whichever is
   easier in practice.
3. Injectivity, if you take that route: two link fields with equal tree
   restrictions and equal plaquette holonomies agree on the leftmost
   vertical column and all horizontal links by assumption, and then agree
   on vertical column `i+1` by induction on `i` using
   `rectPlaquette_hol_formula` (solve for the vertical-link factor; the
   other three factors are equal by the induction hypothesis).

Do NOT weaken the statement: do not add hypotheses (abelian `G`,
nonempty/decidable extras beyond what is already there), do not change the
conventions, do not replace the `Equiv` by an injection or a mere
cardinality statement. If the general case truly stalls, the acceptable
fallback (documented as such) is the same statement for `Lx = 1` only, via
`rectCoordinatizationOneColumn : ... (rectLattice 1 Ly) ...` - but attempt
the general case first; the row-independence makes it genuinely one
`Fin.induction`.

The definitions `OrientedLattice`, `Step`, `Walk`, `stepHol`, `hol`,
`Plaquette`, `Plaquette.hol`, `PlaquetteCoordinatization` below are verbatim
copies (clean-room, same-repo provenance) of the parent repository's
`GateYM` draft interfaces; keep their statements EXACTLY as they are so the
result can be copied back.
-/

namespace Ym1TreeGauge

/-- (Copied interface.) Oriented lattice: source and target maps for
positively oriented links. -/
structure OrientedLattice where
  V : Type*
  E : Type*
  src : E → V
  tgt : E → V

namespace OrientedLattice

variable (Λ : OrientedLattice)
variable {G : Type} [Group G]

/-- (Copied interface.) A link field assigns a group element to every
positively oriented link. -/
abbrev LinkField : Type _ := Λ.E → G

/-- (Copied interface.) One oriented traversal step. -/
inductive Step : Λ.V → Λ.V → Type _
  | fwd (e : Λ.E) : Step (Λ.src e) (Λ.tgt e)
  | rev (e : Λ.E) : Step (Λ.tgt e) (Λ.src e)

/-- (Copied interface.) A typed walk. -/
inductive Walk : Λ.V → Λ.V → Type _
  | nil (x : Λ.V) : Walk x x
  | cons {x y z : Λ.V} : Step Λ x y → Walk y z → Walk x z

variable {Λ}

/-- (Copied interface.) Holonomy contribution of one step. -/
def stepHol (U : Λ.LinkField (G := G)) : {x y : Λ.V} → Step Λ x y → G
  | _, _, Step.fwd e => U e
  | _, _, Step.rev e => (U e)⁻¹

/-- (Copied interface.) Holonomy of a typed walk. -/
def hol (U : Λ.LinkField (G := G)) : {x y : Λ.V} → Walk Λ x y → G
  | _, _, Walk.nil _ => 1
  | _, _, Walk.cons s w => stepHol U s * hol U w

end OrientedLattice

open OrientedLattice

/-- (Copied interface.) A based plaquette: a closed typed 4-walk. -/
structure Plaquette (Λ : OrientedLattice) where
  base : Λ.V
  v1 : Λ.V
  v2 : Λ.V
  v3 : Λ.V
  step0 : OrientedLattice.Step Λ base v1
  step1 : OrientedLattice.Step Λ v1 v2
  step2 : OrientedLattice.Step Λ v2 v3
  step3 : OrientedLattice.Step Λ v3 base

namespace Plaquette

/-- (Copied interface.) The closed typed walk underlying a plaquette. -/
def walk {Λ : OrientedLattice} (p : Plaquette Λ) :
    OrientedLattice.Walk Λ p.base p.base :=
  OrientedLattice.Walk.cons p.step0 <|
    OrientedLattice.Walk.cons p.step1 <|
      OrientedLattice.Walk.cons p.step2 <|
        OrientedLattice.Walk.cons p.step3 <|
          OrientedLattice.Walk.nil p.base

/-- (Copied interface.) Plaquette holonomy. -/
def hol {Λ : OrientedLattice} {G : Type} [Group G]
    (p : Plaquette Λ) (U : Λ.LinkField (G := G)) : G :=
  OrientedLattice.hol U p.walk

end Plaquette

/-- (Copied interface.) A plaquette coordinatization: link fields are
equivalent to (plaquette coordinates) x (residual coordinates), and the
`i`-th plaquette holonomy IS the `i`-th plaquette coordinate. -/
structure PlaquetteCoordinatization (Λ : OrientedLattice) (G : Type) [Group G]
    {ι : Type} (P : ι → Plaquette Λ) (τ : Type) where
  /-- The change of variables. -/
  coord : Λ.LinkField (G := G) ≃ (ι → G) × (τ → G)
  /-- Plaquette holonomies ARE the plaquette coordinates. -/
  hol_coord : ∀ (U : Λ.LinkField (G := G)) (i : ι), (P i).hol U = (coord U).1 i

/-! ## The concrete 2D open rectangle (new content, conventions pinned) -/

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

/-- Convention pin: the plaquette holonomy formula, kernel-checked by `rfl`.
`hol p(i,j) = U_h(i,j) * (U_v(i+1,j) * (U_h(i,j+1)^(-1) * (U_v(i,j)^(-1) * 1)))`. -/
theorem rectPlaquette_hol_formula {Lx Ly : ℕ} {G : Type} [Group G]
    (U : (rectLattice Lx Ly).LinkField (G := G)) (p : Fin Lx × Fin Ly) :
    (rectPlaquette Lx Ly p).hol U
      = U (Sum.inl (p.1, p.2.castSucc))
        * (U (Sum.inr (p.1.succ, p.2))
          * ((U (Sum.inl (p.1, p.2.succ)))⁻¹
            * ((U (Sum.inr (p.1.castSucc, p.2)))⁻¹ * 1))) := rfl

/-- The designed-in forward map: a link field maps to its tuple of plaquette
holonomies together with its restriction to the tree links. With this choice
the interface field `hol_coord` is definitional. -/
def rectToCoord (Lx Ly : ℕ) (G : Type) [Group G] :
    (rectLattice Lx Ly).LinkField (G := G) →
      (Fin Lx × Fin Ly → G) × (RectTree Lx Ly → G) :=
  fun U => (fun p => (rectPlaquette Lx Ly p).hol U, fun t => U (treeLink Lx Ly t))

/-
Row-independence induction core: if two link fields agree on all
horizontal links (`h_h`), agree on the leftmost vertical column (`h_v0`),
and have equal plaquette holonomies (`h_hol`), then they agree on every
vertical link, proved by `Fin.induction` on the column index `i` within each
row `j` using `rectPlaquette_hol_formula`.
-/
lemma rectVertical_eq {Lx Ly : ℕ} {G : Type} [Group G]
    (U U' : (rectLattice Lx Ly).LinkField (G := G))
    (h_h : ∀ h, U (Sum.inl h) = U' (Sum.inl h))
    (h_v0 : ∀ j : Fin Ly, U (Sum.inr ((0 : Fin (Lx + 1)), j))
      = U' (Sum.inr ((0 : Fin (Lx + 1)), j)))
    (h_hol : ∀ p : Fin Lx × Fin Ly,
      (rectPlaquette Lx Ly p).hol U = (rectPlaquette Lx Ly p).hol U') :
    ∀ (j : Fin Ly) (i : Fin (Lx + 1)), U (Sum.inr (i, j)) = U' (Sum.inr (i, j)) := by
  -- Fix `j`, then induct on the column index `i` with `Fin.induction`.
  intro j i
  induction' i using Fin.induction with i ih
  · exact h_v0 j
  · specialize h_hol (i, j)
    simp_all +decide [rectPlaquette_hol_formula]

/-- The forward map `rectToCoord` is injective. -/
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

/-
Cardinality bookkeeping: the domain and codomain of `rectToCoord` are
finite types of the same cardinality `(card G) ^ (2*Lx*Ly + Lx + Ly)`.
-/
lemma rectToCoord_card (Lx Ly : ℕ) (G : Type) [Group G] [Fintype G] :
    Fintype.card (RectE Lx Ly → G)
      = Fintype.card ((Fin Lx × Fin Ly → G) × (RectTree Lx Ly → G)) := by
  simp +decide only [RectE, Fintype.card_fun, Fintype.card_sum, Fintype.card_prod, Fintype.card_fin, RectTree];
  rw [ ← pow_add ] ; ring

/-- **TARGET.** The comb-gauge plaquette coordinatization of the 2D open
rectangle: link fields are equivalent to (plaquette holonomies) x (tree link
values), with plaquette holonomies as the plaquette coordinates. -/
noncomputable def rectCoordinatization (Lx Ly : ℕ) (G : Type) [Group G]
    [Fintype G] :
    PlaquetteCoordinatization (rectLattice Lx Ly) G
      (rectPlaquette Lx Ly) (RectTree Lx Ly) := by
  haveI : Fintype (rectLattice Lx Ly).E := inferInstanceAs (Fintype (RectE Lx Ly))
  haveI : DecidableEq (rectLattice Lx Ly).E := inferInstanceAs (DecidableEq (RectE Lx Ly))
  refine { coord := Equiv.ofBijective (rectToCoord Lx Ly G) ?_, hol_coord := fun _ _ => rfl }
  rw [Fintype.bijective_iff_injective_and_card]
  refine ⟨rectToCoord_injective Lx Ly G, ?_⟩
  convert rectToCoord_card Lx Ly G using 2

end Ym1TreeGauge
