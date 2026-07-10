# codex-goalII-familyrank-cp-bridge-20260709

You are Aristotle working in the `PhysicsSM` Lean project.

## Goal

Create and prove a new module:

```text
PhysicsSM/Draft/NullEdge/KMFamilyRankBridge.lean
```

This job should connect the Goal II CP phase count to the already-landed
family-rank no-go:

- `PhysicsSM.Draft.NullEdge.KMPhaseCounting`
- `PhysicsSM.Draft.NullEdge.FiniteKMCP`
- `PhysicsSM.Draft.NullEdge.IncidenceCorank`
- `PhysicsSM.Draft.NullEdge.FamilyRankNoGo`

Run the narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/KMFamilyRankBridge.lean
```

## Intended theorem pieces

The run needs a theorem saying that "exactly one physical Dirac CP phase"
selects three generations in the arithmetic/corank model, which is the same
numerical rank-fixing datum `FamilyRankNoGo` says is otherwise missing.

Please prove as many of these as cleanly possible:

```lean
theorem physicalPhases_eq_one_iff (N : Nat) :
    FiniteKM.physicalPhases N = 1 <-> N = 3
```

If the exact theorem needs a hypothesis such as `1 <= N`, use the weakest true
hypothesis and explain it.

Then prove a strand-rank version using `FamilyRankNoGo.completionCount`:

```lean
theorem cp_one_iff_three_completions (n : Nat) :
    FiniteKM.physicalPhases (n + 1) = 1 <->
      FamilyRankNoGo.completionCount n = 3
```

or, if the indexing convention should be `N = n + 1`, provide the corrected
statement and proof.

Finally prove a no-go/bridge theorem shaped like:

```lean
theorem cp_one_supplies_rankfixing :
    (forall n, FiniteKM.physicalPhases (n + 1) = 1 <-> n = 2)
```

## Claim discipline

This should NOT say CP dynamics derives three generations physically. It should
say: in this finite arithmetic/corank model, the predicate "one physical CP
phase" is equivalent to the rank-fixing datum `n = 2` / three completions.
That is exactly the kind of explicit axiom `FamilyRankNoGo` demanded.

Add guard pins for the headline theorem(s). Do not introduce new global
assumptions.
