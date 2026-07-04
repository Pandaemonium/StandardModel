import Mathlib

/-!
# The Penrose tree-graph inequality (abstract finite `SimpleGraph` form)

This standalone module targets the single hardest open combinatorial theorem on
the null-edge Yang-Mills / Kotecky-Preiss ladder: the **Penrose tree-graph
inequality**, which bounds the absolute value of the (scaled) Mayer/Ursell
cluster coefficient of a finite graph by its number of labeled spanning trees.

Concretely, for a finite `SimpleGraph G` on a `Fintype` vertex set:

* `ursellSum G` is the alternating sum over CONNECTED spanning subgraphs
  `T <= G` of `(-1) ^ (number of edges of T)`. Dividing by `n!` (with
  `n = Fintype.card V`) recovers the standard Ursell/truncated cluster
  coefficient of the hard-core polymer model, whose Mayer edge factor is `-1`
  on incompatible pairs and `0` otherwise (so only subgraphs of `G` contribute,
  each with sign `(-1)^edges`).
* `spanningTreeCount G` is the number of labeled spanning trees of `G` (subgraphs
  that are `SimpleGraph.IsTree`, i.e. connected and acyclic; connectivity is over
  ALL of `V`, so a tree subgraph is automatically spanning).

The theorem `treeGraphBound_ursell` states

    (ursellSum G).natAbs <= spanningTreeCount G.

## Provenance and math background

This is the classical tree-graph bound underlying the Kotecky-Preiss cluster
expansion. Standard references:

* O. Penrose, "Convergence of fugacity expansions for classical systems", in
  Statistical Mechanics: Foundations and Applications (1967) - the original
  partition scheme / tree-graph identity.
* R. Kotecky and D. Preiss, "Cluster expansion for abstract polymer models",
  Comm. Math. Phys. 103 (1986) 491-498.
* R. Fernandez and A. Procacci, "Cluster expansion for abstract polymer models:
  new bounds from an old approach", Comm. Math. Phys. 274 (2007) 123-140,
  arXiv:math-ph/0605041 (Section 2 sets up the Ursell/truncated coefficient and
  reuses the Penrose tree-graph inequality).

For the hard-core sign structure the bound is a PLAIN spanning-tree count on the
right (each spanning tree contributes weight 1); the classical proof is a
combinatorial partition / sign-reversing involution on the connected spanning
subgraphs that are NOT trees, NOT a determinant / matrix-tree argument. Mathlib
has `SimpleGraph.IsTree`, spanning-tree EXISTENCE (`Connected.exists_isTree_le`),
`Fintype (SimpleGraph V)`, and `edgeFinset`, but NO spanning-tree count formula,
no Cayley's formula, and no alternating-sign connected-subgraph machinery - so
this theorem must be built from the combinatorial partition, which is exactly
why it is parked as its own package.

## Numerical sanity checks (from the strategy analysis, hand-verified)

* Triangle `K_3`: connected spanning subgraphs are 3 trees (2 edges, sign `+1`)
  and 1 triangle (3 edges, sign `-1`), so `ursellSum = 3 - 1 = 2`; spanning
  trees `= 3`; `|2| <= 3` holds (not tight).
* Single edge `K_2`: `ursellSum = -1`, spanning trees `= 1`, `|-1| = 1` (tight).

## Status

Statement freeze with a documented proof handoff (`treeGraphBound_ursell` is a
`s o r r y`). Everything else in this file is proved. Once this abstract
`SimpleGraph V` theorem is closed, the null-edge project's
`PolymerKPConclusion.treeGraphBound_ursell` (stated on `Cluster S` via the
cluster incompatibility graph) follows by specializing `G := X.graph S hdec`.

Claim label: **finite identity** (target); the file is Mathlib-only so it can
ship inside a focused Aristotle package.
-/

open scoped Classical BigOperators

namespace PenroseTreeGraph

variable {V : Type*} [Fintype V]

/-- The number of labeled spanning trees of a finite `SimpleGraph G`:
subgraphs `T <= G` that are trees (`IsTree` = connected + acyclic, hence
spanning over all of `V`). -/
noncomputable def spanningTreeCount (G : SimpleGraph V) : Nat :=
  (Finset.univ.filter (fun T : SimpleGraph V => T ≤ G ∧ T.IsTree)).card

/-- The `n!`-scaled Ursell / Mayer cluster coefficient of a finite graph `G`:
the alternating sum over connected spanning subgraphs `T <= G` of
`(-1) ^ (number of edges of T)`. -/
noncomputable def ursellSum (G : SimpleGraph V) : Int :=
  ∑ T ∈ Finset.univ.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected),
    (-1 : Int) ^ (T.edgeFinset.card)

/-- **Penrose tree-graph inequality.** The absolute value of the `n!`-scaled
Ursell coefficient of a finite graph is at most its number of labeled spanning
trees.

Proof handoff (the unavoidable hard combinatorial content):
prove Penrose's inequality by a direct finite combinatorial partition of the
connected spanning subgraphs, or a sign-reversing involution on the non-tree
connected spanning subgraphs, so that after cancellation only the spanning
trees survive (each contributing sign `+1` or `-1`), whence
`|ursellSum| <= spanningTreeCount`. Do NOT route through the matrix-tree theorem or Cayley's
formula (absent from Mathlib and unnecessary). Suggested stepping stones:
the `K_2` and `K_3` base cases (hand-checked in the module docstring), then a
fixed connected graph via the involution, then the general bound. Likely need:
a Mathlib-friendly encoding of "connected spanning subgraph" as
`{T : SimpleGraph V // T <= G /\ T.Connected}` and a sign-reversing involution
on its non-tree part. -/
theorem treeGraphBound_ursell (G : SimpleGraph V) :
    (ursellSum G).natAbs ≤ spanningTreeCount G := by
  sorry

end PenroseTreeGraph
