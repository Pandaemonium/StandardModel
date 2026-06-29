Gate C1 branchKernel_chiralIndex_zero dependency audit, C232

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C226 proposed the bridge theorem:

```text
branchKernel_chiralIndex_zero
```

Intended meaning:

```text
The actual C21 branch kernel has zero chiral index in the GateC1 projector
vocabulary. This preserves the known obstruction; it is not a release theorem.
```

The C226 suggested target statement was:

```lean
theorem branchKernel_chiralIndex_zero (a : Fin 4) (P : CMat4)
    (hP   : IsIdempotentElem P)
    (hcom : Commute gamma5 P)
    (hran : forall v : Spin -> Complex,
      P *ᵥ v = v <-> cliffordSymbol (branchP a) *ᵥ v = 0) :
    chiralIndex gamma5 P = 0
```

The files included here are:

- `NullEdgeActualCliffordSymbol.lean`
- `NullEdgeBranchClassifierAPI.lean`
- `NullEdgeFlavoredChirality.lean`
- `NullEdgeTasteOnlyOriginNoGo.lean`
- `ProjectorPersistence.lean`

Known issue from Codex context:

```text
PhysicsSM/Draft/TetrahedralNullBranch.lean was not found at that guessed path.
The actual dependency surface for NullEdgeActualCliffordSymbol must be located
or reconstructed before proving the bridge.
```

Task:

Audit the exact dependency surface needed to prove
`branchKernel_chiralIndex_zero`.

Please answer:

1. Which imported declarations are missing from the included files?
2. Which missing declarations are essential versus cosmetic?
3. What is the smallest bridge module statement that can be typechecked in the
   live repo once dependencies are available?
4. What helper lemmas should be proved first?
5. Is C226's proposed `hran`-based statement sufficient, or should the projector
   range condition be strengthened?
6. What exact Aristotle proof package should Codex submit next once the missing
   dependency path is found?

Constraints:

- Preserve the zero-index obstruction.
- Do not invent a new gamma convention.
- Do not claim a physical Weyl release.
- Do not weaken the theorem into a vacuous hypothesis-only statement unless you
  clearly label it as an API warm-up.

Requested output:

- dependency map;
- missing declaration list;
- final recommended theorem statement;
- helper lemma queue;
- next proof-package recipe.
