# Aristotle audit job: Q7 strong-coupling polymer map statement layer

You are acting as a Lean/math formalization auditor and strategist.  A small
Lean patch is welcome if you find one, but the primary deliverable is a written
audit of the statement layer and the next lemma DAG.

Formatting: ASCII only, LF line endings.  In prose, spell Lean escape-hatch
tokens with spaces (`s o r r y`, `a x i o m`, `a d m i t`).

## Project context

This is a Lean 4 / Mathlib project formalizing finite lattice gauge theory
building blocks for a Yang-Mills ladder.  This job is Q7 of the four-day run:
map the finite strong-coupling / character expansion to the Q6 abstract polymer
system.

Q6 has just frozen and partially concretized the KP target:

- `PolymerKPCriterion.PolymerSystem Gamma`: finite polymer type, symmetric
  incompatibility relation, real weight, nonnegative energy.
- `KPCondition`: `sum_{h incompatible g} |weight h| * exp(energy h) <= energy g`.
- `PolymerKPConclusion.Cluster`: ordered clusters of polymers.
- `spanningTreeCount`, `ursellSum`: direct finite graph definitions.
- `ClusterCoeffData`: abstract coefficients with disconnected support and a
  Penrose tree-graph-bound hypothesis.

Aristotle project `34d675b8` confirmed that the Q6 normalization is right and
that the concrete Penrose theorem is the hard parked piece.

Q7 should now freeze the finite plaquette-polymer map.  The current Lean file is
`PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean`; it typechecks
locally and is wired into the GateYM aggregator.  It intentionally does NOT
claim a volume-uniform KP proof.

## Current Q7 Lean surface

The file defines:

```lean
structure PlaquetteAdjacency (P : Type*) where
  touch : P -> P -> Prop
  touch_symm : forall p q, touch p q -> touch q p

abbrev PlaquettePolymer (P Rlab : Type*) [Fintype P] [DecidableEq P]
    [Fintype Rlab] (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop) :=
  {x : Prod (Finset P) (P -> Rlab) //
    x.1.Nonempty /\ ConnectedSupport x.1 /\
      forall p : P, p in x.1 -> NontrivialLabel (x.2 p)}
```

The actual Lean uses the product type `Finset P` paired with `P -> Rlab`.

Accessors:

```lean
def PlaquettePolymer.support : PlaquettePolymer ... -> Finset P
def PlaquettePolymer.label : PlaquettePolymer ... -> P -> Rlab
def PlaquettePolymer.coeffProduct (gammaAbs : Rlab -> Real) (X) : Real :=
  X.support.prod (fun p => gammaAbs (X.label p))
```

Support relations:

```lean
def SupportsOverlap (A B : Finset P) : Prop :=
  exists p : P, p in A /\ p in B

def SupportsTouch (Adj : PlaquetteAdjacency P) (A B : Finset P) : Prop :=
  exists p : P, p in A /\ exists q : P, q in B /\ Adj.touch p q

def SupportsOverlapOrTouch (Adj : PlaquetteAdjacency P) (A B : Finset P) :
    Prop :=
  SupportsOverlap A B \/ SupportsTouch Adj A B
```

Main bridge:

```lean
def plaquettePolymerSystem
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha) :
    PolymerSystem
      (PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
```

It sets:

- `incompatible X Y := SupportsOverlapOrTouch Adj X.support Y.support`
- `weight X := X.coeffProduct gammaAbs`
- `energy X := alpha * X.support.card`

The file proves definitional wrappers:

```lean
plaquettePolymerSystem_weight
plaquettePolymerSystem_energy
plaquettePolymerSystem_self_incompatible
PlaquettePolymer.coeffProduct_nonneg
```

Z2 specialization:

```lean
def z2GammaAbs (beta : Real) (_ : PUnit) : Real := |Real.tanh beta|

theorem z2_plaquettePolymer_weight_eq_abs_tanh_area :
  (plaquettePolymerSystem Adj ConnectedSupport (fun _ : PUnit => True)
    (z2GammaAbs beta) alpha halpha).weight X =
    |Real.tanh beta| ^ X.support.card

theorem z2_plaquettePolymer_energy_eq_alpha_area :
  (plaquettePolymerSystem Adj ConnectedSupport (fun _ : PUnit => True)
    (z2GammaAbs beta) alpha halpha).energy X =
    alpha * (X.support.card : Real)
```

## Oracle/context pins

The repository oracle v0.3 checked a small finite Z2 connected-plaquette gas:

- connected plaquette polymers on L=2,3,4 tori,
- touching-support incompatibility,
- weight `tanh(beta)^area`,
- energy `alpha * area`,
- beta=0.04, alpha=0.75 passes the finite checks,
- beta=0.06, alpha=0.75 fails by L>=3.

This oracle is a convention/constant guard only.  It is not proof of a
volume-uniform KP theorem.

The design thread explicitly asked:

1. Should T7 define its own connected plaquette-support API, or wait for/reuse
   Q6's cluster graph interface?
2. Should baseline incompatibility be overlap, graph touching, or two named
   systems with a comparison theorem?
3. What is the correct general finite-group label API before the project has a
   finite type of simple irreducible representations?
4. Is the first honest theorem just the Z2 specialization
   `weight = tanh(beta)^area`, with the general finite-group map kept abstract?

The current file answers provisionally:

- abstract `ConnectedSupport : Finset P -> Prop`, not hard-coded graph API;
- conservative overlap-or-touching incompatibility;
- abstract finite label type `Rlab` and `gammaAbs : Rlab -> Real`, not a claim
  about finite simple irreps;
- Z2 theorem uses `|tanh beta| ^ area` because KP consumes absolute weights.

## Questions

1. Semantic audit: Is this statement layer honest and useful as the Q7 bridge
   into Q6's `PolymerSystem`, or does it bake in a wrong abstraction?  Pay
   special attention to the total label function `P -> Rlab` with constraints
   only on the support, proof-bearing subtype equality, and the abstract
   `ConnectedSupport` predicate.
2. Incompatibility audit: Is overlap-or-touching the right conservative
   baseline?  Should the file also define a separate overlap-only polymer system
   and a theorem `overlap -> overlapOrTouch`, or is that premature?
3. Z2 normalization audit: Is `|Real.tanh beta| ^ support.card` the correct KP
   weight statement?  Should we also prove a beta-nonnegative theorem replacing
   `|tanh beta|` by `tanh beta`, and is the needed Mathlib lemma available?
4. General finite-G audit: Is `gammaAbs : Rlab -> Real` the right honest
   placeholder before a simple-irrep label API exists?  What exact fields would
   a future finite-G label record need (dimension, character, normalized
   coefficient, nontriviality, multiplicity)?
5. Lean proof opportunities: identify any immediate, low-risk lemmas that should
   be added now.  Examples: monotonicity/comparison of overlap vs touching
   incompatibility, weight nonnegativity, an instantiated `KPCondition` statement
   for a finite manually supplied bound, or basic facts connecting this polymer
   type to Q6 clusters.
6. Next proof package: give the smallest useful theorem package to submit after
   this audit.  Do not propose proving volume-uniform KP from the oracle rows
   unless you can state a real finite theorem with explicit hypotheses.

## Output format

1. Verdict: accept / accept with changes / redesign needed.
2. Any semantic bugs or overclaims, ordered by severity.
3. Recommended Lean edits to `StrongCouplingPolymerMap.lean`, with exact theorem
   names and statement shapes.
4. Recommended Aristotle proof package(s), ranked.
5. Notes on how Q7 should feed Q8 without conflating finite oracle checks with
   volume-uniform convergence.

## Guardrails

Do not strengthen the claim to a KP proof unless the hypotheses really imply it.
Do not introduce a fake finite-irrep API.  If the file is only a useful abstract
map and not yet the true finite-group character expansion, say so plainly.
This is a finite statement-freeze / design-audit job, not a continuum mass-gap
claim.
