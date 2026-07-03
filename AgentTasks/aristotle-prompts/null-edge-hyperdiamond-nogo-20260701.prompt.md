# Aristotle prompt: hyperdiamond no-go reframing

You are Aristotle working on the PhysicsSM null-edge project.

This is a focused standalone package containing the Gate C no-go surface and
the new crosswalk docs. Start with:

```text
lake build HyperdiamondNoGo
```

## Context

Aristotle project `b1558b4a-ab97-4522-a6d5-16f9862dc2b6` evaluated the
standalone package and recommended that Gate C be reframed as a lattice-fermion
no-go problem rather than a growing release ledger.

The package includes:

```text
PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean
PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
NullEdgeStandalone/docs/HYPERDIAMOND_CROSSWALK.md
NullEdgeStandalone/docs/GATE_C.md
NullEdgeStandalone/docs/PHYSICS_CONTEXT.md
NullEdgeStandalone/docs/ARISTOTLE_EVALUATION.md
```

Central existing theorem:

```text
PhysicsSM.Draft.NullEdgeActualCliffordSymbol.no_full_symbol_single_chirality
```

Physical reading: the bare high-momentum null branch kernel is
chirality-balanced, so the flat bare symbol does not release a single Weyl
branch.

## Requested work

Please do as much of the following as possible.

1. Audit `HYPERDIAMOND_CROSSWALK.md` against the Lean files. Identify any
   overstatement, missing hypothesis, or convention mismatch.

2. Propose exact Lean theorem statements that would sharpen the current no-go.
   Especially valuable:

   - a theorem bundling the four high-momentum branch facts with
     `no_full_symbol_single_chirality`;
   - a theorem stating that any branch-release proof using only the bare full
     symbol cannot derive a single chirality sign;
   - a theorem identifying which extra projection data would be needed to break
     the balanced kernel.

3. If a small strengthening is tractable in the focused package, implement it in
   a new Lean file and make it build. Do not weaken existing statements.

4. Write `HYPERDIAMOND_NOGO_ARISTOTLE_REPORT.md` with:

   - a corrected crosswalk if needed;
   - the exact next theorem names and statements;
   - which Nielsen-Ninomiya-style assumptions are represented in the current
     finite Lean package and which are not;
   - a recommendation for whether the projected/Wilson release schemas should
     stay frozen.

## Rules

- Do not extend the release ledger by adding more satisfiable clauses.
- Do not claim equivalence to the Borici-Creutz operator unless the Lean
  definitions prove it.
- Treat negative/no-go content as progress.
- Do not introduce placeholder or escape-hatch declarations.
