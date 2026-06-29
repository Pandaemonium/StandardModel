Gate C1 Null-Edge Overlap strategy audit, C238

You are Aristotle helping the StandardModel null-edge / NullStrand program.

Big-picture context:

The project goal is to reproduce the Standard Model using discrete lightlike
steps inspired by Feynman checkerboard path sums. The current Gate C1 blocker is
the chiral release problem: the bare retarded null-edge finite seed is
chirality-balanced and should not be treated as the final physical release
operator.

The current strategic pivot is:

```text
null-edge path combinatorics
  -> null-edge-derived Hermitian Wilson/Ginsparg-Wilson kernel
  -> overlap/sign/domain-wall chiral release
  -> path-sum interpretation of the sign/resolvent kernel.
```

New candidate kernel:

```text
H_ne[U] =
  gamma5 [
    D_ne^0[U] + W_ne[U] + M_br[U] - rho/a
  ],

D_ne^0[U] =
  sum_A B_A (T_A[U] - T_A[U]^dagger) / (2a),

W_ne[U] =
  (r / 2a) sum_A omega_A (2 - T_A[U] - T_A[U]^dagger).
```

Here `T_A[U]` is the gauge-covariant shift along null edge `A`, `B_A` are
Clifford-odd soldering matrices, `W_ne` is the null-edge Wilson Laplacian, and
`M_br` is initially zero unless scalar Wilson fails the branch-mass test.

The proposed release operator is:

```text
D_ov,ne = (rho/a) (1 + gamma5 sign(H_ne)).
```

The proposed first concrete tetrahedral model uses four future-directed null
vectors `n_A = (1, v_A)`, where the spatial `v_A` are regular tetrahedron
vertices, and

```text
B_A = (1/4) gamma4 + (3/4) v_A^i gamma_i.
```

Task:

Give a blunt strategy audit of this operator proposal. Do not try to prove the
whole theory. Instead answer:

1. Is this the right first serious Gate C1 kernel, relative to the current
   Wilson/Neuberger/domain-wall pivot?
2. What exact assumptions are needed for `H_ne` to be a valid Hermitian overlap
   sign kernel?
3. Should the first theorem use the centered/gamma5-Hermitian kernel, the
   retarded/advanced Hermitian dilation, or both?
4. Is the tetrahedral `B_A` coframe a good first 3+1-dimensional test model?
5. Is the scalar Wilson term plausibly enough for the tetrahedral free branch
   test, or should we immediately plan for `M_br`?
6. What are the first three theorem statements Codex should try to formalize?
7. What are the most likely hidden traps: gauge covariance, Brillouin-zone
   geometry, chirality convention, Krein/Hilbertization, anomaly source
   contract, path-sum convergence, or something else?
8. Which assumptions from earlier Gate C1 work should now be discarded?
9. Which completed Draft modules are most relevant to reuse:
   `CKMWilsonWindow`, `GappedHomotopy`, `SignStability`,
   `ProjectorPersistence`, `OperatorFreeze`, `BranchKernelChiralIndexZero`,
   `SpectralProjectorAPI`?
10. What exact next Aristotle jobs should be launched after this batch?

Constraints:

- Do not claim GateC1_NU is solved.
- Do not claim live repo verification.
- Do not treat raw retarded `D_+` as a valid sign kernel unless it has been
  Hermitianized or dilated.
- Do not use propagator zeros as mirror removal.
- Keep CKM/internal texture separate from spacetime doubler resolution.

Requested output:

- strategy verdict;
- theorem ladder;
- assumption audit;
- recommended first Lean/API statements;
- high-risk traps;
- next job queue.
