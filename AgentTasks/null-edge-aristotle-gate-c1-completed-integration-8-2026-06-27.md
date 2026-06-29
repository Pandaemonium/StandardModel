# Null-edge Aristotle Gate C1 completed integration 8

Date: 2026-06-27

Integrated job:

```text
C148: finite seed to near-origin branch-line theorem
Project: 64c63643-d56a-4bd8-b8a9-63607dda516c
Task: 23a19849-2a9a-4d41-9cc3-54689431fc76
```

## Executive result

C148 closes an important part of the finite-to-branch bridge, but only at the
certificate/interface level. Aristotle delivered a standalone Lean artifact
showing that a finite sign-kernel seed plus a true inverse-propagator gap and a
nonzero `J`-graded selection invariant gives a stable branch-projector
certificate under sub-gap perturbations.

The result is not yet the physical Gate C1 release. It supplies one of the
bridge certificates needed by the reference-kernel import plan.

## Main technical content

The reported artifact separates the work into finite algebra, gap stability,
the bridge theorem, non-vacuity, and counterexamples.

Finite algebra:

```text
S = sign(H_ne)
P = (1 - S) / 2
Q = (1 + S) / 2
```

It proves that `P` and `Q` are self-adjoint idempotents, complementary, and
recover the sign kernel by `1 - 2P = S`.

Gap stability:

```text
InversePropagatorGap(H)
||E|| < gap
  -> H + E remains invertible
```

This is the exact stability shape we need for the branch-line lift: a true
inverse-propagator gap survives sufficiently small perturbations.

Bridge theorem:

```text
FiniteSeed
  + nonzero J-graded selection invariant Odd_J(sign H_ne)
  + true inverse-propagator gap
  -> stable near-origin branch-projector certificate
```

Counterexamples:

```text
nonzero ordinary trace without a gap does not produce stable branch selection;
ordinary trace is not the correct branch invariant;
the J-graded invariant is the relevant finite selector.
```

## How this changes Gate C1

Before C148, the finite seed and the branch-line topology problem were still
connected mostly by prose. C148 gives a formal bridge shape:

```text
finite sign seed
  -> branch projector P
  -> true gap certificate
  -> sub-gap perturbation stability
  -> stable branch-line projector candidate
```

This means the reference-kernel import plan now has a sharper branch-line
component. The import theorem should require a C148-style certificate, not just
an origin trace.

## Claim boundary

C148 does not prove:

```text
the actual null-edge H_ne has the required mass window;
the finite projector is the physical Weyl line;
the overlap operator linearizes to the Weyl symbol;
SM gauge acts internally relative to J;
anomaly/index data imports correctly;
non-ultralocal control or locality holds;
the standalone Lean artifact is ready for trusted repo promotion.
```

It does prove, in the reported standalone artifact, the finite algebraic and
gap-stability skeleton needed by the branch-line lift certificate.

## Updated next theorem stack

C148 should now feed directly into:

```text
C159: NullEdgeReferenceOverlapImport theorem package.
C160: mass-window/sign-straddling theorem package.
C161: overlap linearization and bad-sector inverse-gap theorem package.
```

The remaining decisive bridge is:

```text
actual H_ne satisfies the C148 finite seed hypotheses along the relevant
near-origin spectral island and stays gapped through the reference homotopy.
```

## Integration status

The job note was updated:

```text
AgentTasks/null-edge-c148-finite-seed-to-branch-line-theorem-aristotle-2026-06-27.md
```

The returned project archive was downloaded to:

```text
AgentTasks/aristotle-output/64c63643-d56a-4bd8-b8a9-63607dda516c/project.zip
```

No live Lean source files were changed in this integration pass.
