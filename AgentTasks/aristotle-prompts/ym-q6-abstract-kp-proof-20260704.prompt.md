# Aristotle proof job: Q6 abstract KP C1/C2 package

You are acting as a Lean 4 proof agent for a draft mathematical physics
formalization.  The goal is a focused proof package, not a design rewrite.

Formatting: ASCII only, LF line endings.  In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Repository Context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

This focused submission package contains only:

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
- task/context notes copied under `AgentTasks/`

The live project is a Lean 4 / Mathlib repository pinned to
`leanprover/lean4:v4.28.0`.  The focused package is intended to be checked
with:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

## Mathematical Context

We are formalizing the abstract Kotecky-Preiss finite polymer cluster
conclusion.  The base file `PolymerKPCriterion.lean` defines a finite polymer
system with:

- a finite polymer type `Gamma`;
- a symmetric incompatibility relation;
- real polymer weights;
- a nonnegative energy function;
- `KPCondition`, the usual bound
  `sum_{h incompatible with g} |weight h| * exp(energy h) <= energy g`.

The conclusion file `PolymerKPConclusion.lean` defines:

- ordered clusters `Cluster S` as `n : Nat` and `poly : Fin n -> Gamma`;
- the incompatibility graph on `Fin X.n`;
- connected clusters and clusters touching a polymer;
- `absWeight`, `energyOf`;
- direct finite definitions `spanningTreeCount` and `ursellSum`;
- abstract coefficient data:

```lean
structure ClusterCoeffData (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) where
  coeff : Cluster S -> Real
  coeff_disconnected :
    forall X : Cluster S, Not (X.Connected S hdec) -> coeff X = 0
  treeGraphBound :
    forall X : Cluster S,
      |coeff X| * (Nat.factorial X.n : Real)
        <= (spanningTreeCount S hdec X : Real)
```

Prior Aristotle strategy jobs already fixed the scope:

- Project `2427a253` concluded that C1 absolute convergence and C2
  convergence bound are supported by bare `KPCondition`, while the metric tail
  C3 needs extra geometry/coercivity.
- Project `34d675b8` confirmed the ordered-cluster normalization
  `|coeff X| * X.n! <= spanningTreeCount X`, with `spanningTreeCount` counting
  labeled spanning trees of the incompatibility graph.  The concrete Penrose
  theorem for `ursellSum` is a separate hard target and is NOT part of this
  job.

The semantic preflight context pack is included at:

```text
AgentTasks/context-packs/ym-q6-abstract-kp-proof-20260704-141307.md
```

Use it only as context selection evidence; verify every statement against the
Lean files in this package.

## Targets

Please prove, if true, the two abstract C1/C2 theorems in
`PolymerKPConclusion.lean`:

```lean
theorem kp_cluster_summable
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma) :
    Summable (fun X : {X : Cluster S //
        X.Connected S hdec /\ X.Touches S g0} =>
      |D.coeff X.1| * X.1.absWeight S)

theorem kp_convergence_bound
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma) :
    (tsum (fun X : {X : Cluster S //
        X.Connected S hdec /\ X.Touches S g0} =>
      |D.coeff X.1| * X.1.absWeight S * Real.exp (X.1.energyOf S)))
        <= S.energy g0
```

You may add small helper lemmas in `PolymerKPConclusion.lean` if needed.

## Non-Targets

Do not try to prove or change:

- `treeGraphBound_ursell`;
- `kp_tail_bound`;
- the concrete `ursellSum` coefficient;
- the definitions of `PolymerSystem`, `KPCondition`, `Cluster`,
  `spanningTreeCount`, or `ClusterCoeffData`;
- the public statements of `kp_cluster_summable` or
  `kp_convergence_bound`.

If the exact statements above are false or need an additional hypothesis
(for example self-incompatibility, a different factorial normalization, a
missing finite-energy condition, or a stronger coefficient interface), do not
weaken them silently.  Return a precise blocker report with the smallest
counterexample or missing lemma, and identify the first corrected statement we
should cross-review.

## Success Criteria

Preferred output:

1. A modified `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` where
   both target theorems are proved and the non-target proof placeholders remain
   documented draft handoffs.
2. The exact command you ran, preferably:
   `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.
3. A short list of any helper lemmas added.

Acceptable negative output:

1. A precise explanation of why either target statement is currently
   unprovable or false.
2. The smallest corrected Lean statement shape.
3. Any partial helper lemmas that still typecheck.

Do not introduce new assumptions, fake declarations, broad imports beyond what
the package needs, or executable escape hatches.  This is draft GateYM code, but
kernel-checked proof is still the source of truth.
