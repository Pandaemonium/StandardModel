# Track B cycle 1: path-sum envelope is not kernel control

Date: 2026-06-27

Track: B, obstruction-geometry / information-flow generalization

## Named failure mode

```text
Envelope-as-kernel-control fallacy
```

## Statement

The non-ultralocal Gate C1 plan uses Feynman-style sums over allowed null-edge
paths:

```text
K(x,y;U) = sum_gamma A(gamma;U).
```

The first C108 path-sum theorem target proves only that a length-indexed
absolute envelope is summable under geometric path-count and amplitude-damping
bounds:

```text
pathCount(n) <= C b^n
ampBound(n) <= A a^n
a b < 1
```

This is useful, but it does not yet prove control of the actual kernel
`K(x,y;U)`.

## Missing bridge

To turn the envelope into a physical/non-ultralocal certificate, prove:

```text
if every length-n path amplitude satisfies
  |A(gamma;U)| <= ampBound(n)
and the number of length-n allowed paths from x to y is <= pathCount(n),
then
  sum_{length gamma = n} |A(gamma;U)|
    <= pathCount(n) * ampBound(n).
```

Then summability of the length envelope implies absolute convergence of the
path sum. A later theorem must also relate path length to graph/spacetime
separation if the certificate is used as a spread or decay statement.

## Why this matters

This prevents the non-ultralocal plan from claiming path-sum control merely
because an abstract sequence is summable. The theorem stack must connect:

```text
path amplitudes -> finite length shells -> envelope -> kernel control
```

and separately:

```text
path amplitude gauge covariance -> kernel gauge covariance.
```

## Next theorem target

```text
PathShellEnvelopeBoundsKernel:
  finite shell count + per-path absolute amplitude bound
  => length-shell kernel contribution bound.
```

Then:

```text
PathSumEnvelopeControlsKernel:
  shell bound + summable envelope
  => absolute convergence/control of K(x,y;U).
```
