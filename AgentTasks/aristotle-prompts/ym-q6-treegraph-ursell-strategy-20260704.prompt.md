# Aristotle strategy job: KP tree-graph/Ursell coefficient + Mathlib spanning-tree infrastructure

You are acting as a research strategist for a Lean 4 formalization
project, not primarily as a prover. A short, correct Lean lemma or
definition is welcome if you find one, but the deliverable is a written
analysis: what is true, why, and how it would be proved/defined.

Formatting: ASCII only, LF line endings. Spaced escape-hatch tokens in
prose (`s o r r y`, `a x i o m`).

## Standalone context

We are formalizing the Kotecky-Preiss (KP) abstract polymer cluster
expansion criterion in Lean 4 / Mathlib. An abstract "polymer system" is
a finite type `Gamma` of polymers with a symmetric incompatibility
relation, real weights, and a nonnegative "energy" function. The KP
condition says: for every polymer `g`, the sum over all polymers `h`
incompatible with `g` of `|weight(h)| * exp(energy(h))` is at most
`energy(g)`.

The KP theorem's conclusion is that the cluster expansion for `log Z`
converges. A "cluster" over a polymer system is encoded here as `n : Nat`
plus a member function `Fin n -> Gamma` (ordered, with repetition allowed,
not a multiset/quotient at this stage) such that the incompatibility graph
on `Fin n` (vertices = positions, edges = incompatible pairs of members)
is connected as a `SimpleGraph`.

We have already had an earlier Aristotle strategy job (project `2427a253`,
report on file) confirm: (a) the absolute-convergence and per-polymer KP
bound parts of the conclusion follow from bare `KPCondition` with no extra
hypotheses; (b) an abstract `ClusterCoeffData` interface (a real-valued
`coeff` on clusters, vanishing on disconnected clusters, satisfying a
"tree-graph bound") is the right thing to freeze NOW, deferring the
concrete Ursell/Mayer coefficient to a later proof package. That freeze is
proposed as:

```lean
noncomputable def spanningTreeCount (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (X : Cluster S) : Nat := ...
  -- (placeholder: intended to count spanning trees of X.graph S hdec,
  -- the incompatibility SimpleGraph on Fin X.n)

structure ClusterCoeffData (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) where
  coeff : Cluster S -> Real
  coeff_disconnected :
    forall X : Cluster S, not (X.Connected S hdec) -> coeff X = 0
  treeGraphBound :
    forall X : Cluster S,
      |coeff X| * (Nat.factorial X.n : Real)
        <= (spanningTreeCount S hdec X : Real)
```

(`X.n : Nat` is the cluster's size, i.e. number of polymer slots; the
`n!` factor is there because clusters are encoded via `Fin n -> Gamma`,
an ORDERED sequence with possible repeats, not a genuine multiset/quotient
- deliberately deferred per the earlier strategy report.)

The concrete object `coeff` is intended, eventually, to be instantiated by
the standard Ursell/Mayer cluster coefficient:

```
u(cluster) = (1 / n!) * sum over connected spanning subgraphs T of the
  cluster's incompatibility graph of (-1)^{#edges(T)}
```

(This is the standard combinatorial identity underlying the KP/Mayer
cluster expansion - e.g. as it appears in Kotecky-Preiss 1986 CMP 103,
491-498, and in the modern rederivation Fernandez-Procacci, "Cluster
expansion for abstract polymer models: new bounds from an old approach",
arXiv:math-ph/0605041, which our project's literature effort already has
full-text access to and has checked for polymer graph / self-incompatibility
/ cluster / Ursell / tree-route support language.)

We confirmed Mathlib does NOT (as of a recent check) define Mayer/Ursell
cluster coefficients or connected-subgraph counting for a finite graph.
Before starting a real Lean proof package on this, we want a strategist's
assessment of what actually needs to be built.

## Questions

1. State the EXACT Ursell/Mayer coefficient identity and the associated
   tree-graph inequality (Penrose's identity / the tree-graph bound used
   by Kotecky-Preiss and by Fernandez-Procacci) as precisely as you can
   from the literature (cite which source and equation/section number if
   possible from arXiv:math-ph/0605041 or your own knowledge of the KP86
   paper). Confirm or correct the normalization
   `|coeff X| * n! <= spanningTreeCount X` above: is the `n!` in the right
   place, is `spanningTreeCount` (labeled spanning trees of the
   incompatibility graph on `Fin n`) the right combinatorial object on the
   right-hand side, or does the standard inequality use a different count
   (e.g. spanning trees of the COMPLETE graph on n vertices compatible with
   the incompatibility structure, or a sum weighted by something other than
   plain tree count)? If our stated form is wrong, give the corrected form
   explicitly.
2. Does Mathlib (any recent version) have ANY of the following, even in a
   different guise than expected: (a) a definition or count of spanning
   trees of a `SimpleGraph` on a `Fintype` vertex set (matrix-tree /
   Kirchhoff theorem, or a direct combinatorial spanning-tree
   enumeration), (b) Cayley's formula (`n^{n-2}` labeled trees on `n`
   vertices) for the complete graph case, (c) any existing "connected
   subgraph enumeration with alternating sign" machinery that could serve
   as the Ursell coefficient. Search by concept, not just by guessed name
   (e.g. `SimpleGraph.IsTree`, `SimpleGraph.deleteEdges`, spanning
   subgraphs, `Matrix.det` cofactor / Kirchhoff-style constructions,
   `SimpleGraph.Connected` cardinality lemmas). Report what exists and
   what is missing.
3. Given the gap found in (2), sketch the SMALLEST viable Lean formalization
   path for `spanningTreeCount` that would let `treeGraphBound` and,
   eventually, a concrete `coeff` instantiation be stated and proved
   without inventing an enormous amount of new graph-theory infrastructure.
   Is a direct combinatorial definition via `Finset.filter` over subgraphs
   of `X.graph` (small finite type, since `X.n` is a `Nat` bound at
   statement time) tractable, or does the alternating-sign identity
   fundamentally require a determinant/matrix-tree-theorem route that would
   be a much larger undertaking?
4. Is there a WEAKER but still useful statement that avoids needing the
   exact Ursell coefficient at all - e.g. can the tail-bound theorems
   already frozen (`kp_cluster_summable`, `kp_convergence_bound`,
   `kp_tail_bound`) be proved for an ABSTRACT `ClusterCoeffData` satisfying
   only `coeff_disconnected` and `treeGraphBound` as stated, WITHOUT ever
   constructing the concrete Ursell `coeff`? If so, is the abstract
   `treeGraphBound` hypothesis itself provable in general (i.e. does every
   coefficient satisfying some weaker/more primitive combinatorial
   property automatically satisfy `treeGraphBound`), or does proving
   `treeGraphBound` for the CONCRETE Ursell coefficient remain unavoidable
   before the frozen theorems have any actual instance to apply to?

## Output format

1. Verdict on the exact tree-graph identity (confirm/correct the stated
   normalization), with citation.
2. Mathlib gap-search results (what exists, what is missing, by name).
3. Recommended smallest Lean formalization path for `spanningTreeCount`
   (or the alternate route if a determinant-based approach is genuinely
   required).
4. Answer to Question 4 (whether concrete Ursell instantiation is
   avoidable for now).
5. Recommended next step: proceed to a Lean proof package on
   `spanningTreeCount`/tree-graph infrastructure now, or park this behind
   a different, smaller combinatorial target first.

## Guardrails

Do not weaken the target to make it provable - if the stated
`treeGraphBound` normalization is wrong, report the corrected form
plainly, do not silently accept ours. This is finite combinatorics /
graph theory, "finite identity" scope; nothing physics-related to
conflate with the surrounding Yang-Mills program. A correct, well-
justified answer that the concrete Ursell coefficient is NOT yet
practical to build in Lean (recommending we park it) is exactly as
valuable as a positive formalization path.
