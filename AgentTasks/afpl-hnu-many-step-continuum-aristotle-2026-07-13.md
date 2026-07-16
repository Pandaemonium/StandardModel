# Aristotle proof/strategy: HNU compact-momentum many-step continuum bound

```yaml
aristotle:
  project_id: 73a1d386-9910-493b-84b2-1867bdf6ef2e
  task_id: 5780bc23-454d-4d27-b6a4-809498b454fa
  target_file: HNUManyStepContinuum.lean
  expected_module: HNUManyStepContinuum
  status: queued
```

## Purpose

This is Bridge B2-B3 from the continuum/3+1 synthesis. It asks for a
quantitative bridge from the exact HNU endpoint to the continuum Weyl flow,
not merely a derivative at the origin.

## Target

Using `HNUExactCore.lean`, define

```text
W(q, eps) = endpoint (eps * q)
H_W(q) = q0 sigma1 + q1 sigma2 + q2 sigma3
E(q, eps) = exp(-i eps H_W(q)).
```

For a displayed compact bound on `q`, prove an explicit one-step estimate

```text
||W(q,eps) - E(q,eps)|| <= C(q or R) * eps^2
```

for a stated small-step range. Then telescope exact unitarity to obtain a
fixed-time many-step estimate for `eps = t/n` that vanishes as `1/n`.

Reuse theorem shapes and finite norm estimates from the uploaded
`FixedMomentumManyStepContinuum.lean`, but do not identify its `1+1` walk with
the HNU endpoint. If a complete estimate is too large, return the strongest
kernel-checked local remainder lemma and a precise decomposition of the
remaining bound.

## Acceptance

- Exact coefficient/sign conventions agree with the HNU tangent theorem, or a
  mismatch is reported rather than hidden.
- Compact momentum and small-step hypotheses are explicit.
- The proof is in matrix/operator norm and uses exact unitarity for telescoping.
- Include a nonzero rational/axis witness and standard-three guards.
- No position-space, full-`L2`, Lorentz, winding, chirality, or primitive-null
  claim follows from this job alone.

## 2026-07-13 harvest and live-port successor

Task `5780bc23-454d-4d27-b6a4-809498b454fa` completed the full quantitative
ladder on its self-contained HNU exact core:

- an explicit operator-norm `O(eps^2)` one-step estimate for the exact HNU
  endpoint at fixed momentum;
- an exact-unitarity telescope with `O(t^2 / n)` finite-time error;
- convergence of the `n`-step endpoint word to the Weyl exponential for every
  fixed `q` and `t`;
- nonzero axis controls and standard-three guards.

The returned theorem uses the task's standalone `HNUExactCore.Core` API.  Its
endpoint formula appears algebraically identical to the live endpoint after the
Pauli/projector name map, but headline integration requires a kernel-checked
bridge rather than visual comparison.  Independent Claude review was requested
in mailbox message `msg-20260713-205603-2e149b00`.

Successor task `c7a35679-00c4-4406-a7e1-e54558ed0c52` now targets a direct
live-import port.  It must prove the rotation factorization or explicit endpoint
equality against `PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint`, preserve all
quantitative statements, and expose no second physical endpoint in the public
API.  Until that port replays, the result is harvested but not integrated.
