# Codex Lean progress: tetrahedral global free-gap scaffold

Date: 2026-06-28

Created Draft file:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralGlobalGap.lean
```

Purpose:

```text
Factor the post-C240 global free-gap theorem into small finite obligations.
```

Main definitions:

```text
branchAngles:
  Boolean branch table -> k_A in {0, pi}.

branchCount:
  number of pi coordinates.

wilsonScalar r rho k:
  r * sum_A (1 - cos(k_A)) - rho.

KineticDetection K:
  K is nonnegative, and K(k) = 0 forces all sin(k_A) = 0.

freeGapScalar K r rho k:
  K(k) + wilsonScalar(r,rho,k)^2.

tetraKineticCoeffNormSq:
  Euclidean coefficient-norm proxy for sum_A B_A sin(k_A) in the C240
  Dirac-vector coefficient basis.
```

Main theorem shape:

```text
freeGapScalar_ne_zero_of_kineticDetection:
  If K satisfies KineticDetection, k is in the fundamental period, and
  0 < rho < 2r, then freeGapScalar K r rho k is nonzero.
```

Concrete tetrahedral target:

```text
tetrahedral_freeGapScalar_ne_zero:
  The same no-zero theorem for tetraKineticCoeffNormSq.
```

Handoff points:

```text
sin_zero_to_branchAngles:
  period plus sin(k_A)=0 for all A implies k is a Boolean branch table.

tetraKineticCoeffNormSq_detection:
  the tetrahedral coefficient norm vanishes only when every sin(k_A) vanishes.
```

Expected proof route for the second handoff:

```text
1. Sum of squares zero gives all four coefficient equations.
2. Convert normalized vTetra equations to unscaled wTetra equations.
3. Apply C240's homogeneous injectivity / branch-inference theorem.
```

Status:

```text
Draft/unverified.
Contains explicit proof placeholders at the two handoff points.
No live Lean check was run.
No trusted theorem or GateC1_NU claim is made.
```
