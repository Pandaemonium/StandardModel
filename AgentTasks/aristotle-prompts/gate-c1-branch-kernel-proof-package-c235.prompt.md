Gate C1 branchKernel_chiralIndex_zero proof package, C235

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C226 proposed a bridge theorem:

```text
branchKernel_chiralIndex_zero
```

Intended meaning:

```text
The actual C21 branch kernel has zero chiral index in the GateC1 projector
vocabulary. This is an obstruction theorem, not a release theorem.
```

C232 is still running as a dependency audit, but Codex has now located the
actual local dependency that was previously guessed incorrectly:

```text
PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean
```

This request project includes the relevant live files under their import paths:

```text
PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean
PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
PhysicsSM/Draft/NullEdgeTasteOnlyOriginNoGo.lean
PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean
PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean
```

Target statement shape:

```lean
theorem branchKernel_chiralIndex_zero (a : Fin 4) (P : CMat4)
    (hP   : IsIdempotentElem P)
    (hcom : Commute gamma5 P)
    (hran : forall v : Spin -> Complex,
      P *ᵥ v = v <-> cliffordSymbol (branchP a) *ᵥ v = 0) :
    chiralIndex gamma5 P = 0
```

Task:

Try to produce the bridge module, or the strongest honest near-term theorem if
the full statement needs additional helper lemmas.

Please:

1. Preserve the actual gamma convention from `NullEdgeActualCliffordSymbol`.
2. Use the C226 GateC1 obstruction lemmas:
   `chiralIndex_zero_of_rank_balanced` or
   `chiralIndex_zero_of_trace_zero`.
3. Prove or isolate these helpers if possible:
   `gamma5_anticommutes_cliffordSymbol`;
   `branchKernel_rank_two`;
   `branchKernel_chiralTrace_zero`;
   or a precise range/kernel projector lemma.
4. Do not claim a chiral release.
5. If the full theorem cannot be proved, return the exact missing lemma list
   and the smallest next proof job.

Requested output:

- proposed bridge module;
- theorem statement;
- proof status;
- missing lemmas if any;
- semantic risks and no-overclaim boundary.
