Project name: gate-c1-clifford-symbol-to-reference-gap-c209

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Cycle 4 Neo4j doc search suggests that the concrete input for C205 should come
from existing null-edge Clifford-symbol work, especially:

```text
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean
```

C205 exposed the missing non-scalar input:

```text
K (Gamma x) + Gamma (K x) = 0
```

or the equivalent Clifford/gamma anticommutation/norm-square identity needed to
prove `ReferenceIsGapped`.

Task:

1. Propose the exact theorem statements connecting existing null-edge Clifford
   symbol modules to the C205 `DiracFiber.anticomm` input.
2. Identify which existing declarations are likely relevant and which new small
   lemmas are needed.
3. State the minimal theorem:

```text
existing Clifford symbol conventions
-> anticommutation/norm identity
-> ReferenceIsGapped input.
```

4. If the existing actual Clifford symbol is not compatible with the
   Wilson/Neuberger reference, say so and identify the bridge needed.
5. Return a Lean-oriented proof plan that can be used for a focused repo job.

Success criteria:

```text
Do not invent a new gamma convention if the repo already has one.
Separate actual theorem obligations from convention/bridge obligations.
No full GateC1_NU claim.
```

Please finish with:

```text
Relevant existing modules:
Needed theorem statements:
Bridge/convention risks:
Proof plan:
Next focused Lean job:
```
