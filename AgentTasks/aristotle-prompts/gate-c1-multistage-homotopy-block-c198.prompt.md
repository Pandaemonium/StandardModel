Project name: gate-c1-multistage-homotopy-block-c198

You are Aristotle, working on the StandardModel Lean/null-edge research project.

The direct straight-line homotopy:

```text
H_t = (1 - t) S H_ref S^-1 + t H_ne
```

may fail if the kinetic mismatch kappa is too large.

The proposed fallback is:

```text
H_Wilson+CKM -> H_abs.block -> H_ne.
```

where `H_abs.block` has the null-edge sector table and CKM signs, but a
block-diagonal kinetic chosen to maximize the spectral gap estimate.

Task:

1. Define a multi-stage gapped homotopy certificate.
2. State the theorem that if each segment has gap margin, then the whole path
   preserves the overlap sign kernel and sector classification.
3. Define the best possible abstract block intermediate for Gate C1.
4. Explain which constants should be small in each segment.
5. Provide Lean-style theorem skeletons for composing homotopy certificates.

Success criteria:

```text
The fallback must not change the sector-signature class.
The block intermediate is a proof scaffold, not a new physical reference.
The proof should let us bypass a too-crude global kappa bound by proving smaller
segment bounds.
```

Please finish with:

```text
Definitions:
Composition theorem:
Recommended block kernel:
Segment error budgets:
Failure modes:
```
