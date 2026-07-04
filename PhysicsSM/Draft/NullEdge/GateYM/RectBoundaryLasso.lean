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

/-! ## Helper lemmas for the lasso identity -/

/-- Abstract reversed telescoping product in a group: for `f : Fin (n+1) -> G`,
the reversed product of the differences `f (i+1) * (f i)⁻¹` collapses to
`f (last) * (f 0)⁻¹`. -/
theorem reversed_telescope_prod {n : Nat} (f : Fin (n + 1) -> G) :
    (List.ofFn fun i : Fin n => f (i.rev.succ) * (f (i.rev.castSucc))⁻¹).prod
      = f (Fin.last n) * (f 0)⁻¹ := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [List.ofFn_succ_last, List.prod_append]
      have hpre : (List.ofFn fun i : Fin n =>
            (f (i.castSucc.rev.succ) * (f (i.castSucc.rev.castSucc))⁻¹)).prod
          = f ((Fin.last n).succ) * (f ((0 : Fin (n + 1)).succ))⁻¹ := by
        have := ih (fun k => f k.succ)
        simpa [Fin.rev_castSucc, Fin.castSucc_succ] using this
      simp only [Fin.rev_last]
      rw [hpre]
      simp only [Fin.succ_zero_eq_one, List.prod_cons, List.prod_nil, mul_one,
        Fin.castSucc_zero, Fin.succ_last]
      rw [mul_assoc, inv_mul_cancel_left]

/-- Holonomy of the vertical walk from the bottom boundary to row `k` is the
left-parenthesized product of the vertical link values below row `k`. -/
theorem rectVerticalWalkAux_hol {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (i : Fin (Lx + 1)) :
    forall (k : Nat) (hk : k <= Ly),
      OrientedLattice.hol U (rectVerticalWalkAux Lx Ly i k hk)
        = (List.ofFn fun m : Fin k =>
            U (Sum.inr (i, ⟨m, Nat.lt_of_lt_of_le m.2 hk⟩))).prod := by
  intro k hk
  induction' k with k ih generalizing i
  · rfl
  · convert congr_arg₂ ( · * · ) ( ih i ( Nat.le_of_succ_le hk ) )
      ( show OrientedLattice.hol U ( OrientedLattice.Walk.cons
          ( OrientedLattice.Step.castEndpoints _ _
            ( OrientedLattice.Step.fwd
              ( Sum.inr ( i, ⟨ k, Nat.lt_of_succ_le hk ⟩ ) ) ) )
          ( OrientedLattice.Walk.nil _ ) ) =
          U ( Sum.inr ( i, ⟨ k, Nat.lt_of_succ_le hk ⟩ ) ) from ?_ ) using 1
    convert OrientedLattice.hol_append _ _ _ using 1
    · rw [ List.ofFn_succ' ]
      aesop
    · simp +decide [ OrientedLattice.hol ]
      rw [OrientedLattice.stepHol_castEndpoints]
      rfl

/-- Holonomy of the full vertical walk along column `i` is the product of the
vertical link values in that column. -/
theorem rectVerticalWalk_hol {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (i : Fin (Lx + 1)) :
    OrientedLattice.hol U (rectVerticalWalk Lx Ly i)
      = (List.ofFn fun j : Fin Ly => U (Sum.inr (i, j))).prod := by
  unfold rectVerticalWalk
  rw [rectVerticalWalkAux_hol U i Ly le_rfl]

/-- Holonomy of the horizontal walk vanishes when all horizontal links are `1`. -/
theorem rectHorizontalWalk_hol_one {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (j : Fin (Ly + 1))
    (hh : forall h, U (Sum.inl h) = (1 : G)) :
    OrientedLattice.hol U (rectHorizontalWalk Lx Ly j) = 1 := by
  have h_ind : forall (k : Nat) (hk : k <= Lx),
      OrientedLattice.hol U (rectHorizontalWalkAux Lx Ly j k hk) = 1 := by
    intro k hk
    induction' k with k ih
    · rfl
    · convert congr_arg₂ ( · * · ) ( ih ( Nat.le_of_succ_le hk ) )
        ( show OrientedLattice.hol U ( OrientedLattice.Walk.cons
            ( OrientedLattice.Step.castEndpoints _ _
              ( OrientedLattice.Step.fwd
                ( Sum.inl ( ⟨ k, Nat.lt_of_succ_le hk ⟩, j ) ) ) )
            ( OrientedLattice.Walk.nil _ ) ) = 1 from ?_ ) using 1
      convert OrientedLattice.hol_append _ _ _ using 1
      · norm_num
      · simp +decide [ OrientedLattice.hol ]
        exact hh _
  exact h_ind _ le_rfl

/-- Under the comb tree slice, a plaquette holonomy collapses to the difference
of its right and left vertical links. -/
theorem rectPlaquette_hol_treeSlice {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G))
    (hTree : IsCombTreeSlice Lx Ly U) (p : Fin Lx × Fin Ly) :
    (rectPlaquette Lx Ly p).hol U
      = U (Sum.inr (p.1.succ, p.2)) * (U (Sum.inr (p.1.castSucc, p.2)))⁻¹ := by
  have h1 : U (Sum.inl (p.1, p.2.castSucc)) = 1 := hTree (Sum.inl (p.1, p.2.castSucc))
  have h2 : U (Sum.inl (p.1, p.2.succ)) = 1 := hTree (Sum.inl (p.1, p.2.succ))
  rw [rectPlaquette_hol_formula, h1, h2]
  group

/-- Under the comb tree slice, the reversed product of the plaquette holonomies
in row `j` telescopes to the right-boundary vertical link at row `j`. -/
theorem rectRowProd_treeSlice {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G))
    (hTree : IsCombTreeSlice Lx Ly U) (j : Fin Ly) :
    (List.ofFn fun i : Fin Lx => (rectPlaquette Lx Ly (i.rev, j)).hol U).prod
      = U (Sum.inr (Fin.last Lx, j)) := by
  have hstep : (fun i : Fin Lx => (rectPlaquette Lx Ly (i.rev, j)).hol U)
      = (fun i : Fin Lx =>
          (fun k : Fin (Lx + 1) => U (Sum.inr (k, j))) (i.rev.succ)
            * ((fun k : Fin (Lx + 1) => U (Sum.inr (k, j))) (i.rev.castSucc))⁻¹) := by
    funext i
    simpa using rectPlaquette_hol_treeSlice U hTree (i.rev, j)
  rw [hstep, reversed_telescope_prod (fun k : Fin (Lx + 1) => U (Sum.inr (k, j)))]
  have h0 : U (Sum.inr ((0 : Fin (Lx + 1)), j)) = 1 := hTree (Sum.inr j)
  simp [h0]

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
  have hh : forall h, U (Sum.inl h) = (1 : G) := fun h => hTree (Sum.inl h)
  have hv0 : (List.ofFn fun j : Fin Ly =>
        U (Sum.inr ((0 : Fin (Lx + 1)), j))).prod = 1 := by
    apply List.prod_eq_one
    intro x hx
    simp only [List.mem_ofFn] at hx
    obtain ⟨j, rfl⟩ := hx
    exact hTree (Sum.inr j)
  have hRHS : reversedRowMajorPlaquetteProd Lx Ly U
      = (List.ofFn fun j : Fin Ly => U (Sum.inr (Fin.last Lx, j))).prod := by
    unfold reversedRowMajorPlaquetteProd
    have hfun : (fun j : Fin Ly =>
          (List.ofFn fun i : Fin Lx =>
            (rectPlaquette Lx Ly (i.rev, j)).hol U).prod)
        = (fun j : Fin Ly => U (Sum.inr (Fin.last Lx, j))) := by
      funext j
      exact rectRowProd_treeSlice U hTree j
    rw [hfun]
  rw [rectBoundary_hol_formula, rectHorizontalWalk_hol_one U 0 hh,
    rectHorizontalWalk_hol_one U (Fin.last Ly) hh,
    rectVerticalWalk_hol U (Fin.last Lx),
    rectVerticalWalk_hol U (0 : Fin (Lx + 1)), hv0, hRHS]
  group

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
