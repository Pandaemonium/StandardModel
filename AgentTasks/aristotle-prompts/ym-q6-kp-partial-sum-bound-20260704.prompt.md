# Aristotle proof job: Q6 rooted KP partial-sum bound

You are acting as a Lean 4 proof agent for a draft mathematical physics
formalization. The goal is a focused proof package for the remaining M2/Q6
Kotecky-Preiss combinatorial crux, not a redesign.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Repository Context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

This focused submission package contains the three Lean files needed for the
target:

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TreeGraphInequality.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`

The live project is a Lean 4 / Mathlib repository pinned to
`leanprover/lean4:v4.28.0`. Check the target first with:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

The semantic context pack is included at:

```text
AgentTasks/context-packs/ym-q6-kp-partial-sum-bound-20260704-20260704-201911.md
```

It is context-selection evidence only. Verify every theorem statement against
the Lean files in the package.

## Mathematical Context

`PolymerKPCriterion.lean` defines a finite abstract polymer system with:

- finite polymer type `Gamma`;
- symmetric incompatibility relation `S.incompatible`;
- real polymer weights `S.weight`;
- nonnegative energy function `S.energy`;
- `KPCondition`, the finite Kotecky-Preiss hypothesis
  `sum_{h incompatible with g} |weight h| * exp(energy h) <= energy g`.

`PolymerKPConclusion.lean` defines:

- ordered clusters `Cluster S` as `n : Nat` and `poly : Fin n -> Gamma`;
- the incompatibility graph on `Fin X.n`;
- connected clusters and clusters touching a polymer;
- `absWeight` and `energyOf`;
- `ClusterCoeffData`, an abstract coefficient interface:

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

Important current status:

- Aristotle project `071d1370` found the old bare C2 theorem false without
  self-incompatibility. That counterexample is integrated locally as
  `kp_convergence_bound_false`.
- The corrected C2 theorem is now
  `kp_convergence_bound_of_selfIncompatible`, still a documented handoff.
- Aristotle project `e4458430` proved the Penrose tree-graph inequality for a
  finite `SimpleGraph`; it is integrated as `TreeGraphInequality.lean`.
- `PolymerKPConclusion.treeGraphBound_ursell` is now kernel-checked by
  specialization. Do not reproach the Penrose theorem in this job.
- Q7 has conditional adapters from explicit plaquette KP sums to
  `PlaquetteKPBound`, but those are downstream. This job is abstract Q6 only.

## Exact Target

Please prove the theorem `kp_partial_sum_bound` in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` without changing its
public statement:

```lean
theorem kp_partial_sum_bound
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma)
    (s : Finset {X : Cluster S // X.Connected S hdec /\ X.Touches S g0}) :
    (s.sum (fun X => |D.coeff X.1| * X.1.absWeight S))
      <= |S.weight g0| * Real.exp (S.energy g0)
```

You may add small helper lemmas in `PolymerKPConclusion.lean` if they are
local, clearly named, and preserve the definitions and public theorem surface.

## Non-Targets

Do not change or attempt to prove:

- `TreeGraphInequality.treeGraphBound_ursell`;
- `PolymerKPConclusion.treeGraphBound_ursell`;
- `kp_convergence_bound_of_selfIncompatible`;
- `kp_tail_bound`;
- `ClusterCoeffData`;
- `Cluster`, `spanningTreeCount`, `ursellSum`, `KPCondition`, or
  `PolymerSystem`.

Do not weaken `kp_partial_sum_bound` silently. If it is false as stated, return
a precise counterexample or the smallest corrected Lean statement, plus any
kernel-checked helper lemmas you obtained.

## Suggested Proof Shape

The intended mathematics is the finite Kotecky-Preiss tree-sum estimate:

1. Use `D.treeGraphBound` to replace `|D.coeff X|` by a spanning-tree count
   divided by `X.n!`.
2. Expand the tree count as a finite sum over labeled spanning trees of the
   incompatibility graph.
3. Use the fact that the cluster touches `g0` to choose a root occurrence, then
   orient/count rooted trees from that root. Overcounting is acceptable in the
   upper-bound direction.
4. Apply the KP condition recursively along rooted tree edges. The desired
   result is the standard rooted tree estimate bounded by
   `|S.weight g0| * exp (S.energy g0)`.

If this exact ordered-cluster encoding introduces a missing factor (for example
an uncontrolled root-choice factor from "touches" rather than "rooted at
slot 0"), say so explicitly and give the corrected statement. Do not hide a
factor in a stronger assumption.

## Success Criteria

Preferred output:

1. A modified `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` where
   `kp_partial_sum_bound` is proved.
2. The exact command run, preferably
   `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.
3. A short list of helper lemmas added.

Acceptable negative output:

1. A precise proof that the target statement is false or currently
   underspecified.
2. The smallest corrected theorem shape.
3. Any partial helper lemmas that typecheck.

Do not introduce new assumptions, fake declarations, broad imports beyond what
the package needs, or executable escape hatches. The Lean kernel is the source
of truth.
