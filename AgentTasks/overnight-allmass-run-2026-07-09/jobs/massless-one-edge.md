# claude-massless-one-edge — edge count IS the mass classification (massless = 1 null edge, massive = 2)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

The title claim "all mass comes from massless edges" is backed by: every mass decomposes into
null edges. Sharpen it into a CLASSIFICATION by edge count. A particle momentum is a 2x2 real
symmetric PSD matrix P (the direction Gram / momentum bispinor); "null edges" are its rank-one
PSD summands. Prove the exact dictionary: massless <=> exactly ONE null edge (rank 1, det 0);
massive <=> exactly TWO null edges (rank 2, det > 0). So the number of massless edges IS the
mass class.

## Targets (REAL symmetric 2x2, rational witnesses; rank/det API)

1. `massless_iff_one_edge`: for PSD P != 0, `det P = 0` <=> `rank P = 1` <=> `P = v v^T` for a
   single nonzero v (one null edge). Massless = a single light-like direction.
2. `massive_iff_two_edges`: for PSD P, `det P > 0` <=> `rank P = 2` <=> `P = v v^T + w w^T` with
   v, w linearly independent (two null edges, non-collinear) <=> `P` is positive-definite. Massive
   = two disagreeing light-like directions; `det P = (v0 w1 - v1 w0)^2` is the squared disagreement.
3. `edge_count_eq_rank`: define `edgeCount P = rank P`; prove `edgeCount` is exactly the minimal
   number of null (rank-one PSD) edges summing to P (>= via rank subadditivity, <= via the explicit
   eigen/Cholesky-free construction for 2x2). So mass class = edge count: 0 edges (P=0, trivial),
   1 edge (massless), 2 edges (massive).
4. `mass_from_edges` (payload): package — `m^2 := det P` satisfies `m^2 = 0` iff one edge, `m^2 > 0`
   iff two edges, and in the two-edge case `m^2 = |v ^ w|^2` (the Pluecker disagreement of the two
   null edges). "All mass comes from (two or more) massless edges" as a rank/edge-count theorem.

MANDATORY non-degeneracy: massless witness `P = (1,0)(1,0)^T = !![1,0;0,0]` (det 0, rank 1);
massive witness `v=(1,0), w=(3/5,4/5)`, `P = !![1 + 9/25, 12/25; 12/25, 16/25]`, `det = 16/25 > 0`
(rank 2) — explicit rationals stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL 2x2 rational matrices; use Mathlib rank/det API + ring/norm_num/
decide/fin_cases; NO Complex, NO Real.sqrt, NO nlinarith deg>=3. Build in-project under 3 min.
Deliver RequestProject/Main.lean (namespace MasslessEdgeCount) + ARISTOTLE_SUMMARY.md.
