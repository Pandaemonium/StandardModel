Project name: gate-c1-finite-carrier-freeze-c214

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Current state:

`GateC1_NU_Free` has an abstract external theorem stack, but C212 says we are
still choosing the concrete operator until the finite carrier, basis, field,
`H_ref`, `H_ne`, and kappa range are frozen.

Relevant repo modules surfaced by Neo4j:

```text
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean
```

Task:

1. Propose the concrete finite carrier for the first `GateC1_NU_Free` model.
2. Specify the basis and exact scalar field to use in Lean.
3. Identify how the existing actual Clifford symbol and branch classifier
   should be reused.
4. State what new finite data must be added for the CKM sector.
5. Return a falsifiable operator-freeze proposal, including what would make it
   fail.

Success criteria:

```text
Concrete enough to implement.
No vague "some finite space" language.
Use existing project modules where possible.
No background-gauge or quantum claims.
```

Please finish with:

```text
Carrier:
Basis:
Scalar field:
Existing module reuse:
New finite data:
Failure conditions:
Next Lean file:
```
