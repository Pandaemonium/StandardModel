Gate C1 tetrahedral free global gap bound, C243

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C240 completed the finite branch-window theorem for the tetrahedral
Null-Edge Overlap free symbol. It proved the coframe identities, branch
inference, 16 branch table subject to the independent-angle/lattice-duality
hypothesis, and scalar Wilson branch masses:

```text
m_n = (2 r n - rho) / a.
```

For:

```text
a > 0,
0 < rho < 2r,
```

C240 proves:

```text
m_0 < 0,
m_n > 0 for n = 1, ..., 4.
```

Now we need the global free no-zero/gap theorem, not just exact branch-point
signs.

Free scalar expression:

```text
H_C1(k) =
  gamma5 [
    (i/a) sum_A B_A sin(k_A)
    + (r/a) sum_A (1 - cos(k_A))
    - rho/a
  ].
```

Suggested scalar lower-bound target:

```text
F(k) =
  |sum_A B_A sin(k_A)|^2
  + [r sum_A (1 - cos(k_A)) - rho]^2.
```

Codex's informal tetrahedral kinetic identity is:

```text
Let s_A = sin(k_A), S = sum_A s_A, Q = sum_A s_A^2.

|sum_A B_A s_A|^2 = (3/4) Q - (1/8) S^2 >= (1/4) Q.
```

If this exact norm identity is convention-dependent, prove the strongest
correct lower bound under the same tetrahedral coframe conventions used in
C240.

Task:

1. Prove a Lean theorem that `F(k) = 0` is impossible under:

```text
r > 0,
0 < rho < 2r,
k_A in [0, 2*pi),
independent tetrahedral branch coordinates.
```

2. Prefer a direct proof:

```text
If the kinetic norm term is zero, then all sin(k_A) = 0.
Then every k_A is 0 or pi in the fundamental period.
Then C240's branch-mass window makes the Wilson scalar nonzero.
```

3. If feasible, prove a quantitative positive lower bound. If not, return the
cleanest no-zero theorem and explain what analytic compactness theorem would
be needed for a uniform numerical gap.

4. Keep the result finite/free only. Do not claim gauge, anomaly, Krein,
determinant-line, or GateC1_NU closure.

Additional Pro feedback to incorporate:

```text
Do not state that H_tet has a physical zero at k = 0.  In the overlap
construction, H_tet is the gapped sign kernel.  The physical zero belongs to
D_ov,tet, not to H_tet.
```

The strongest desired theorem is:

```text
H_tet(k)^2 >= (c^2 / a^2) * 1
```

for all `k` on the rank-4 tetrahedral torus, with `c > 0`.

If an explicit lower bound is feasible, use Pro's suggested split:

```text
lambda = rho / r in (0,2)
delta = (1/2) * min(lambda, 2 - lambda)
alpha = lambda - delta
beta = lambda + delta

c^2 =
  min {
    r^2 * delta^2,
    (1/4) * min(alpha * (2 - alpha), beta * (2 - beta))
  }.
```

The proof idea:

```text
Either |rR - rho| >= r delta, giving the Wilson lower bound,
or R in [alpha,beta] subset (0,2), and the sine/kinetic term gives the lower
bound.
```

If formalizing this explicit bound is too heavy, first prove the no-zero theorem
and return the compactness theorem needed for a uniform positive gap.

Relevant integrated file:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralBranchWindow.lean
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralGlobalGap.lean
```

Codex has added a Draft scaffold in `TetrahedralGlobalGap.lean` with the
following intended split:

```text
KineticDetection K:
  K(k) >= 0;
  K(k) = 0 => forall A, sin(k_A) = 0.

freeGapScalar K r rho k =
  K(k) + [r sum_A(1 - cos(k_A)) - rho]^2.
```

It then states:

```text
freeGapScalar_ne_zero_of_kineticDetection;
tetraKineticCoeffNormSq_detection;
tetrahedral_freeGapScalar_ne_zero.
```

The most valuable proof target is to discharge the two handoff points in that
file:

```text
sin_zero_to_branchAngles;
tetraKineticCoeffNormSq_detection.
```

If those are proved, the no-zero theorem follows by the scalar Wilson window.

Requested output:

- Lean theorem statements and proofs if feasible;
- exact assumptions;
- proof status;
- whether scalar Wilson is enough at the free-symbol no-zero level;
- recommended integration target file.
