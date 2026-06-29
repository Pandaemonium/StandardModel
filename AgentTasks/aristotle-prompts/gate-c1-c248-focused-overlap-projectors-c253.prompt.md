Gate C1 C253: focused corrected overlap/GW projector algebra

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C248 was supposed to prove the corrected abstract overlap/Ginsparg-Wilson
projector algebra. The prior C248 run returned the already-integrated C239
kernel file and did not deliver the corrected projector package.

We now want a focused algebra result, preferably standalone or added cleanly to:

```text
PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapKernel.lean
```

Mathematical setup:

Let `gamma` and `eps` be involutions in an associative algebra with unit:

```text
gamma^2 = 1
eps^2 = 1
D = 1 + gamma * eps
```

In normalized units, prove:

```text
D * gamma + gamma * D = D * gamma * D
```

and define the corrected modified chirality:

```text
hatGamma = gamma * (1 - D) = -eps.
```

Then prove:

```text
hatGamma^2 = 1;
Pplus = (1 + hatGamma)/2 is idempotent;
Pminus = (1 - hatGamma)/2 is idempotent;
Pplus * Pminus = 0;
Pplus + Pminus = 1.
```

If scalar division by 2 is inconvenient in the existing algebra API, work over a
ring/field where `2` is invertible, or prove the equivalent doubled projector
identities with explicit assumptions.

Physical convention to preserve:

```text
hat_gamma5 = gamma5 * (1 - (a/rho) D_ov) = -epsilon.
```

Do not incorrectly treat `gamma5 * epsilon` as the self-adjoint modified
chirality involution.

Constraints:

```text
Do not run a full lake build.
Prefer a standalone Mathlib algebra file if the project target is too heavy.
Do not change the already-integrated C239 self-adjointness theorem unless
necessary.
```

Requested output:

```text
1. Lean theorem statements and proofs.
2. Exact algebraic assumptions.
3. Recommended integration target.
4. Any convention warnings.
```
