Gate C1 corrected overlap and Ginsparg-Wilson algebra, C248

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

After C243/C247, the intended free sign-kernel theorem gives a self-adjoint
gapped operator `H_tet`.  Then:

```text
epsilon = sign(H_tet)
epsilon dagger = epsilon
epsilon^2 = 1
```

Define:

```text
D_ov,tet = (rho/a) * (1 + gamma5 * epsilon).
```

Pro feedback emphasizes a projector correction:

```text
gamma5 * epsilon is generally gamma5-Hermitian/unitary, not a self-adjoint
involution.

The self-adjoint involution for the modified chiral projector is:

hat_gamma5 =
  gamma5 * (1 - (a/rho) * D_ov,tet)
  = -epsilon.
```

Task:

Prove the abstract algebraic overlap/GW theorem under minimal assumptions.

Target assumptions:

```text
gamma5 dagger = gamma5;
gamma5^2 = 1;
epsilon dagger = epsilon;
epsilon^2 = 1;
D = (rho/a) * (1 + gamma5 * epsilon);
a != 0;
rho != 0.
```

Target conclusions:

```text
D gamma5 + gamma5 D =
  (a/rho) D gamma5 D.

hat_gamma5 = gamma5 * (1 - (a/rho) * D) = -epsilon.

hat_gamma5 dagger = hat_gamma5.
hat_gamma5^2 = 1.

P_hat_pm = (1 +/- hat_gamma5)/2 are idempotent projectors.
```

If star-adjoint projectors are too much for the first pass, prove the algebraic
idempotence/involution theorem first.

Relevant integrated file:

```text
PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapKernel.lean
```

Requested output:

- Lean theorem statements and proofs if feasible;
- exact assumptions;
- any correction to the existing `normalized_ginspargWilson_of_involutions`
  theorem;
- recommended integration target file.
