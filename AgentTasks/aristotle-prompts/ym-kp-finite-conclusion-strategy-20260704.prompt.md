# Aristotle strategy job: finite KP polymer conclusion (Q6, four-day YM run)

You are acting as a Lean 4 formalization strategist and adversarial
statement-shape auditor, not as a proof search engine. Do not try to build the
whole repository. Return a written report with Lean-syntax definitions and
theorem signatures where requested.

Formatting requirements: ASCII only. In prose, write Lean escape-hatch tokens
in spaced form (`s o r r y`, `a x i o m`, `n a t i v e _ d e c i d e`), never
raw.

## Project context

This is a Mathlib/Lean 4 project, pinned to Lean v4.28.0. The current four-day
Yang-Mills run is executing section 14 of
`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`. Queue item Q6 is the
Kotecky-Preiss finite polymer conclusion:

- finite polymer set;
- no full Ursell generality as the first target;
- finite cluster expansion;
- tree-graph bound;
- tail estimate of the form
  `sum over clusters touching X, distance >= R <= C_X * exp (-m * R)`;
- statement freeze on top of `PolymerKPCriterion.lean`, which currently freezes
  only the finite polymer system and the KP condition.

No gauge-theory content belongs in Q6. Q7 maps Yang-Mills strong-coupling
polymers into the abstract Q6 theorem later.

## Current Lean surface

The project directory includes:

- `PolymerKPCriterion.lean`: the live current condition-only module.
- `CONTEXT_PACK.md`: semantic context pack generated for this target.
- `MATHLIB_INVENTORY.md`: exact grep-verified Mathlib API facts available for
  this target.

The current Lean module defines:

```lean
structure PolymerSystem (Gamma : Type*) [Fintype Gamma] where
  incompatible : Gamma -> Gamma -> Prop
  incompatible_symm : forall g h, incompatible g h -> incompatible h g
  weight : Gamma -> Real
  energy : Gamma -> Real
  energy_nonneg : forall g, 0 <= energy g

def KPCondition (S : PolymerSystem Gamma)
    (incompatibleDecidable : forall g h, Decidable (S.incompatible g h)) : Prop :=
  forall g : Gamma,
    (sum over h incompatible with g of |S.weight h| * Real.exp (S.energy h))
      <= S.energy g
```

Do not silently change this hypothesis shape unless you argue clearly that the
current statement is mathematically inadequate and give the minimal corrected
Lean signature.

## Important statement-shape risk to audit

The bare KP condition controls cluster weights through the energy function. An
exponential tail in an abstract distance does not appear to follow from
`KPCondition` alone unless the statement also assumes some relation between
energy, cluster distance, polymer size/diameter, or a distance-weighted KP
condition. Please explicitly decide this:

- If the Q6 tail bound follows from the frozen `KPCondition` plus a natural
  definition of distance, give the exact lemma DAG.
- If it does not, give a smallest counterexample or failure explanation, then
  state the minimal additional hypotheses needed for the tail theorem.

This is not a trick question. A precise "the tail statement needs one more
hypothesis" is a successful strategy result.

## Deliverable

Return a report named `KP_Finite_Conclusion_Strategy.md` with these numbered
sections:

1. **Verdict on the Q6 statement shape.** State whether the existing
   `PolymerSystem` and `KPCondition` can support the finite convergence theorem
   and the exponential tail theorem. Separate what follows from KP alone from
   what needs additional metric/energy hypotheses.
2. **Minimal Lean API.** Give Lean-syntax definitions/signatures for the exact
   statement package to add, preferably in a new
   `PolymerKPConclusion.lean` importing `PolymerKPCriterion`. Include cluster
   encoding, connectedness, cluster touches, cluster distance/tail predicate,
   cluster absolute weight, and final theorem signatures.
3. **Cluster representation decision.** Choose one: `n : Nat` plus
   `Fin n -> Gamma`, multisets, finite support count functions, or another
   encoding. Justify against Lean ergonomics and the KP math. Explain how
   repeated polymers are represented, since the cluster expansion commonly sums
   over multi-indices even when the physical polymer gas has finite compatible
   configurations.
4. **Tree-graph/Ursell plan.** Decide whether Q6 baseline should define the
   exact Mayer/Ursell coefficient immediately, or first state the conclusion
   against an abstract `clusterCoeff` satisfying a tree-graph bound. Give the
   exact Lean signatures for whichever route you recommend, and list the route
   you reject with reasons.
5. **Lemma DAG.** List every lemma needed from the frozen KP condition to the
   absolute-convergence theorem and from there to the tail theorem. Tag each
   node as one of:
   - `provable-now` (finite sums, graph connectedness, reindexing);
   - `needs-design` (statement/API choice);
   - `external-source` (requires checking a paper theorem);
   - `likely-Aristotle-proof` (good focused proof package).
6. **Mathlib use.** Ground your plan in the available API: `SimpleGraph`
   connectedness and `IsTree`/spanning-tree facts exist; geometric-series and
   `Summable` facts exist; no prebuilt polymer/cluster expansion exists.
   Point out any Mathlib names that are likely helpful and any missing lemmas we
   should not pretend exist.
7. **Sanity checks and counterexamples.** Give small finite polymer systems that
   should be used to sanity-check theorem statements before proof submission:
   trivial one-polymer, two incompatible polymers, no-incompatibility graph, and
   a distance-tail example showing why the extra tail hypotheses are or are not
   necessary.
8. **Recommended next proof package.** Specify the first focused Aristotle proof
   job after the statement freeze: target file, theorem names, and narrow
   `lake env lean ...` command. If the first proof package should be only a
   tree-graph/combinatorics lemma rather than the full KP theorem, say so.

Success criterion: after reading your report, a coding agent should be able to
write the first Q6 statement file without guessing, without weakening the
program's target, and without making the exponential tail theorem false by
omission of a needed hypothesis.
