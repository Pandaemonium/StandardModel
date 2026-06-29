Gate C1 C255: post-C244 strategy audit

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Current status:

```text
C240:
  tetrahedral branch-window / scalar Wilson branch table integrated.

C244:
  tetrahedral lattice-duality / Brillouin-torus theorem integrated.
  The four k_A are now independent 2*pi-periodic coordinates for active L_H.

C243:
  global free gap still open.
  Previous return left:
    sin_zero_to_branchAngles;
    tetraKineticCoeffNormSq_detection.

C248:
  corrected overlap/projector algebra still open.
  Previous return did not deliver hat_gamma5 = -epsilon projector package.

C247:
  Euclidean Clifford convention job still running.

C249:
  free no-mirror-pole job still running.

D4:
  envelope/comparison lane only, not active release lattice.
```

Task:

Give a hard-nosed strategy audit for the next 5-10 Aristotle jobs.

Focus on:

```text
1. the fastest route to closing C243;
2. the right minimal standalone algebra target for C248;
3. whether C249 should wait for C243/C248 or can be reframed conditionally;
4. whether C247's result is a hard dependency for C243 or only for physical
   Hermitian interpretation;
5. which D4 side-lane jobs are actually worth doing now versus later;
6. any hidden semantic mismatch in the current L_H / scalar Wilson overlap
   proof spine.
```

Output format:

```text
1. Verdict.
2. Current proof DAG.
3. Highest-value next jobs, ordered.
4. Jobs to avoid for now.
5. Specific theorem statements Aristotle should be asked to prove next.
6. Red flags that would force M_br or a change of operator.
```

Do not propose replacing `L_H` with full D4 unless you explicitly explain how
the null-edge primitive-step claim survives.
