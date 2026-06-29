Gate C1 C252: tetrahedral kinetic detection lemma for C243

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C240 proved the tetrahedral branch-window theorem. C244 has now integrated the
rank-4 tetrahedral Brillouin-torus theorem. The global free gap theorem C243
still needs a finite kinetic detection lemma in:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralGlobalGap.lean
```

The previous C243 return identified the main remaining finite-algebra target:

```text
tetraKineticCoeffNormSq_detection
```

Task:

Prove the strongest correct version of the tetrahedral kinetic detection lemma
in the existing file vocabulary.

Intended math:

```text
Let s_A = sin(k_A).
If the tetrahedral kinetic norm expression vanishes, then every s_A = 0.
```

Codex's informal identity was:

```text
|sum_A B_A s_A|^2 = (3/4) sum_A s_A^2 - (1/8) (sum_A s_A)^2 >= (1/4) sum_A s_A^2.
```

If the exact coefficient convention in the Lean file differs, prove the
corresponding nonnegative expression and zero-detection theorem actually used by
the file.

Constraints:

```text
Do not run a full lake build.
Prefer narrow checking only if needed.
Do not weaken the detection statement into a tautology.
Do not claim the scalar Wilson free gap unless the existing downstream theorem
actually follows.
```

Requested output:

```text
1. Updated Lean code for `tetraKineticCoeffNormSq_detection` or a replacement.
2. Any helper lemmas proving positivity / zero detection.
3. Whether this closes the kinetic side of C243.
4. Remaining blockers for the full global gap theorem.
```
