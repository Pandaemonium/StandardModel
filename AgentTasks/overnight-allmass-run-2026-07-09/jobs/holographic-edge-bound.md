# claude-holographic-edge-bound — a finite holographic/Bekenstein bound: physical DOF <= boundary null-edge count

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

The holographic principle / Bekenstein bound: the physical degrees of freedom in a region are
bounded by its BOUNDARY area, not its volume. Build the finite null-edge avatar: the dimension of
the physical (positive-sector) state space of a finite region is bounded by the number of null
edges piercing its BOUNDARY. Gravity-side entropy/area result, distinct from the Jacobson
equation of state.

## The model (finite; explicit small linear algebra)

A finite region carries a physical sector = a subspace `Phys` of a state space `V` (the
positive-definite sector of a Krein form, or the kernel of a boundary constraint). The boundary
carries `B` pierced null edges (each a rank-one boundary source). The interior-to-boundary map
`R : V -> (boundary sources)` (restriction / trace to the boundary) is an explicit rational
linear map whose rank is at most `B`.

## Targets

1. `boundary_rank_le_edges`: `rank R <= B` -- the boundary restriction map has rank at most the
   boundary edge count (its target has dimension `B`).
2. `phys_injects_to_boundary`: on the physical sector, the boundary restriction is INJECTIVE
   (a physical state is determined by its boundary data -- a finite "holographic" reconstruction
   hypothesis, stated explicitly and realized on a concrete witness where `R` restricted to `Phys`
   has trivial kernel).
3. `holographic_bound` (payload): `dim Phys = rank (R|_Phys) <= rank R <= B` -- the physical
   degrees of freedom are bounded by the BOUNDARY null-edge count `B`, not the interior volume.
   The finite Bekenstein/holographic bound.
4. `entropy_area_form`: read `dim Phys` as the region entropy and `B` as the area; the bound is
   `S <= B` (area law), with the Bekenstein `S <= B/4`-style constant statable if you carry an
   explicit coefficient. Package with an explicit witness saturating (or nearly saturating) it.

MANDATORY non-degeneracy: an explicit rational witness with `dim Phys > 0`, `B > 0`, the
injective boundary map exhibited, and `dim Phys <= B` a concrete numeric inequality (e.g.
`dim Phys = 2 <= 3 = B`), stated in-theorem; plus a control where a non-physical (interior-only)
state is NOT boundary-determined, so injectivity is a real hypothesis on `Phys`.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational matrices; Mathlib rank/finrank API + ring/norm_num/decide/
fin_cases; NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace HolographicEdgeBound) + ARISTOTLE_SUMMARY.md with honest scope
(a finite linear-algebra holographic bound, not the covariant entropy bound of real gravity).
