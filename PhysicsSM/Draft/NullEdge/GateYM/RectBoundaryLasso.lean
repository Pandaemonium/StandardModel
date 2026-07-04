import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.RectTreeGauge

/-!
# Gate YM1: rectangular boundary circuit for the lasso identity

This module starts queue item T11/Q11 for the four-day YM run.  It pins the
typed boundary circuit of the concrete `RectTreeGauge.rectLattice` before the
hard lasso theorem is sent to Aristotle.

The convention is the standard counterclockwise boundary of the full
`Lx x Ly` rectangle:

1. bottom side, left to right;
2. right side, bottom to top;
3. top side, right to left (the reverse of the top horizontal walk);
4. left side, top to bottom (the reverse of the left vertical walk).

The theorem `rectBoundary_hol_formula` records this order at the holonomy
level.  The next T11 step is the tree-gauge-slice lasso theorem: at tree
links equal to `1`, the boundary holonomy equals the row-major product of all
plaquette holonomies with the horizontal index reversed in each row.  The
pointwise identity at general tree values is not claimed here and is expected
to be false.

Draft-trust: kernel-checked convention layer; no proof of the lasso identity
yet.  The lasso statement below is deliberately left as a documented draft
handoff for Aristotle.  Claim label: finite identity / convention pin.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace RectBoundaryLasso

open GaugeCoreGeneral RectTreeGauge

variable {G : Type} [Group G]

/-- Horizontal walk along row `j`, from the left boundary to column `k`. -/
def rectHorizontalWalkAux (Lx Ly : Nat) (j : Fin (Ly + 1)) :
    (k : Nat) -> (hk : k <= Lx) ->
      OrientedLattice.Walk (rectLattice Lx Ly) ((0 : Fin (Lx + 1)), j)
        (⟨k, Nat.lt_succ_of_le hk⟩, j)
  | 0, _ => OrientedLattice.Walk.nil _
  | k + 1, hk => by
      have hk' : k <= Lx := Nat.le_trans (Nat.le_succ k) hk
      have hki : k < Lx := Nat.lt_of_succ_le hk
      let i : Fin Lx := ⟨k, hki⟩
      let s0 : OrientedLattice.Step (rectLattice Lx Ly)
          ((rectLattice Lx Ly).src (Sum.inl (i, j)))
          ((rectLattice Lx Ly).tgt (Sum.inl (i, j))) :=
        OrientedLattice.Step.fwd (Λ := rectLattice Lx Ly) (Sum.inl (i, j))
      have hsrc :
          ((rectLattice Lx Ly).src (Sum.inl (i, j)))
            = (⟨k, Nat.lt_succ_of_le hk'⟩, j) := by
        simp [rectLattice, i]
      have htgt :
          ((rectLattice Lx Ly).tgt (Sum.inl (i, j)))
            = (⟨k + 1, Nat.lt_succ_of_le hk⟩, j) := by
        simp [rectLattice, i]
      exact OrientedLattice.Walk.append (rectHorizontalWalkAux Lx Ly j k hk')
        (OrientedLattice.Walk.cons
          (OrientedLattice.Step.castEndpoints hsrc htgt s0) (OrientedLattice.Walk.nil _))

/-- Horizontal walk along row `j`, from the left boundary to the right boundary. -/
def rectHorizontalWalk (Lx Ly : Nat) (j : Fin (Ly + 1)) :
    OrientedLattice.Walk (rectLattice Lx Ly) ((0 : Fin (Lx + 1)), j) (Fin.last Lx, j) :=
  rectHorizontalWalkAux Lx Ly j Lx le_rfl

/-- Vertical walk along column `i`, from the bottom boundary to row `k`. -/
def rectVerticalWalkAux (Lx Ly : Nat) (i : Fin (Lx + 1)) :
    (k : Nat) -> (hk : k <= Ly) ->
      OrientedLattice.Walk (rectLattice Lx Ly) (i, (0 : Fin (Ly + 1)))
        (i, ⟨k, Nat.lt_succ_of_le hk⟩)
  | 0, _ => OrientedLattice.Walk.nil _
  | k + 1, hk => by
      have hk' : k <= Ly := Nat.le_trans (Nat.le_succ k) hk
      have hki : k < Ly := Nat.lt_of_succ_le hk
      let j : Fin Ly := ⟨k, hki⟩
      let s0 : OrientedLattice.Step (rectLattice Lx Ly)
          ((rectLattice Lx Ly).src (Sum.inr (i, j)))
          ((rectLattice Lx Ly).tgt (Sum.inr (i, j))) :=
        OrientedLattice.Step.fwd (Λ := rectLattice Lx Ly) (Sum.inr (i, j))
      have hsrc :
          ((rectLattice Lx Ly).src (Sum.inr (i, j)))
            = (i, ⟨k, Nat.lt_succ_of_le hk'⟩) := by
        simp [rectLattice, j]
      have htgt :
          ((rectLattice Lx Ly).tgt (Sum.inr (i, j)))
            = (i, ⟨k + 1, Nat.lt_succ_of_le hk⟩) := by
        simp [rectLattice, j]
      exact OrientedLattice.Walk.append (rectVerticalWalkAux Lx Ly i k hk')
        (OrientedLattice.Walk.cons
          (OrientedLattice.Step.castEndpoints hsrc htgt s0) (OrientedLattice.Walk.nil _))

/-- Vertical walk along column `i`, from the bottom boundary to the top boundary. -/
def rectVerticalWalk (Lx Ly : Nat) (i : Fin (Lx + 1)) :
    OrientedLattice.Walk (rectLattice Lx Ly) (i, (0 : Fin (Ly + 1))) (i, Fin.last Ly) :=
  rectVerticalWalkAux Lx Ly i Ly le_rfl

/-- The counterclockwise boundary walk of the full rectangle. -/
def rectBoundaryWalk (Lx Ly : Nat) :
    OrientedLattice.Walk (rectLattice Lx Ly) ((0 : Fin (Lx + 1)), (0 : Fin (Ly + 1)))
      ((0 : Fin (Lx + 1)), (0 : Fin (Ly + 1))) :=
  OrientedLattice.Walk.append (rectHorizontalWalk Lx Ly (0 : Fin (Ly + 1)))
    (OrientedLattice.Walk.append (rectVerticalWalk Lx Ly (Fin.last Lx))
      (OrientedLattice.Walk.append
        (OrientedLattice.Walk.reverse (rectHorizontalWalk Lx Ly (Fin.last Ly)))
        (OrientedLattice.Walk.reverse (rectVerticalWalk Lx Ly (0 : Fin (Lx + 1))))))

/-- Boundary holonomy convention pin: bottom, right, inverse top, inverse left. -/
theorem rectBoundary_hol_formula {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) :
    OrientedLattice.hol U (rectBoundaryWalk Lx Ly)
      = OrientedLattice.hol U (rectHorizontalWalk Lx Ly (0 : Fin (Ly + 1)))
    * (OrientedLattice.hol U (rectVerticalWalk Lx Ly (Fin.last Lx))
      * ((OrientedLattice.hol U (rectHorizontalWalk Lx Ly (Fin.last Ly)))⁻¹
        * ((OrientedLattice.hol U (rectVerticalWalk Lx Ly (0 : Fin (Lx + 1))))⁻¹
          * 1))) := by
  simp [rectBoundaryWalk, OrientedLattice.hol_append, OrientedLattice.hol_reverse]

/-! ## Tree-slice lasso statement -/

/-- The comb tree slice: all horizontal links and the leftmost vertical column
are fixed to the identity. -/
def IsCombTreeSlice (Lx Ly : Nat)
    (U : (rectLattice Lx Ly).LinkField (G := G)) : Prop :=
  ∀ t : RectTree Lx Ly, U (treeLink Lx Ly t) = 1

/-- Ordered product of all plaquette holonomies in row-major order, with the
horizontal index reversed inside each row.

The product order is:
`P(Lx-1,0) * ... * P(0,0) * P(Lx-1,1) * ... * P(0,Ly-1)`.
`List.ofFn`/`List.prod` is used instead of `Finset.prod` because the gauge
group may be noncommutative. -/
def reversedRowMajorPlaquetteProd (Lx Ly : Nat)
    (U : (rectLattice Lx Ly).LinkField (G := G)) : G :=
  (List.ofFn fun j : Fin Ly =>
    (List.ofFn fun i : Fin Lx =>
      (rectPlaquette Lx Ly (i.rev, j)).hol U).prod).prod

/-- Tree-slice lasso identity: on the comb tree slice, the full rectangle
boundary holonomy equals the ordered product of all plaquette holonomies, with
row-major order and reversed horizontal index inside each row.

This is the accepted T11 Aristotle target.  It explicitly does not claim the
expected-false pointwise identity at general tree values. -/
theorem rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G))
    (hTree : IsCombTreeSlice Lx Ly U) :
    OrientedLattice.hol U (rectBoundaryWalk Lx Ly)
      = reversedRowMajorPlaquetteProd Lx Ly U := by
  /-
  Proof handoff:
  Current target is the accepted T11 tree-slice lasso identity.  Use
  `rectPlaquette_hol_formula` and `rectBoundary_hol_formula`.
  Under `hTree`, all horizontal links and the leftmost vertical links are `1`.
  Each plaquette in row `j` should reduce to
  `U (Sum.inr (i.succ, j)) * (U (Sum.inr (i.castSucc, j)))^-1`.
  Multiplying the row in reversed `i` order telescopes to the right boundary
  vertical link at row `j` times the inverse left-column tree link.  The left
  term is `1` by `hTree`, and products over increasing `j` give the right
  vertical boundary holonomy.  The top, bottom, and left boundary factors are
  tree links and vanish by `hTree`.
  -/
  sorry

/-- Observable form of the tree-slice lasso identity.  This is intentionally
stated for any function `chi`; no class-function or ensemble reduction is used
at this stage. -/
theorem apply_rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice
    {Lx Ly : Nat} (chi : G → α)
    (U : (rectLattice Lx Ly).LinkField (G := G))
    (hTree : IsCombTreeSlice Lx Ly U) :
    chi (OrientedLattice.hol U (rectBoundaryWalk Lx Ly))
      = chi (reversedRowMajorPlaquetteProd Lx Ly U) := by
  exact congrArg chi
    (rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice U hTree)

end RectBoundaryLasso
end GateYM
end NullEdge
end Draft
end PhysicsSM
