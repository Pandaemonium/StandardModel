Gate C1 Euclidean Clifford convention and centered kernel theorem, C247

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The current first free C1 model is the tetrahedral scalar-Wilson overlap kernel:

```text
H_tet(k) =
  gamma5 [
    (i/a) sum_A B_A sin(k_A)
    + (1/a) (r sum_A (1 - cos(k_A)) - rho)
  ].
```

Pro feedback warns that the overlap sign-kernel proof must use Euclidean
Hermitian gamma matrices / Hilbert-space convention.  Lorentzian null slash
singularities belong to the path/soldering interpretation, not to the spectral
gap proof.

Task:

Formalize the Euclidean convention layer needed to connect C240 and C239.

Target statements:

```text
B_A dagger = B_A.
{gamma5, B_A} = 0.

D_ne^0(k) = (i/a) sum_A B_A sin(k_A)
  satisfies:
    (D_ne^0(k)) dagger = -D_ne^0(k),
    {D_ne^0(k), gamma5} = 0.

W(k) = (1/a)(r sum_A(1 - cos k_A) - rho) * 1
  satisfies:
    W(k) dagger = W(k),
    [W(k), gamma5] = 0.

Therefore:
  H_tet(k) = gamma5 (D_ne^0(k) + W(k))
  is Hermitian.
```

Also check this convention point:

```text
Do not state that gamma5 * B_A is Hermitian if B_A is Hermitian and
anticommutes with gamma5.  It is anti-Hermitian in the Euclidean convention.
```

Relevant integrated files:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralBranchWindow.lean
PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapKernel.lean
```

Requested output:

- Lean theorem statements and proofs if feasible;
- exact algebraic assumptions;
- whether the theorem can be standalone over an abstract star algebra;
- recommended integration target file;
- any convention mismatch found.
