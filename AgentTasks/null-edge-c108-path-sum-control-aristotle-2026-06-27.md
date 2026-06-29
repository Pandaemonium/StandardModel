# Aristotle C108: path-sum control for non-ultralocal Gate C1

Date: 2026-06-27
Gate: C1_NL
Dependency class: Independent
Submission style: focused standalone Mathlib package

## Project context

The project has introduced a non-ultralocal Gate C1 branch:

```text
Gate C1_NL:
  declared non-ultralocal physical chiral release with a canonical
  spectral/Riesz/sign/path-sum branch projector, true bad-sector inverse gap,
  ghost/anomaly/Krein/gauge audits, and regulator stability.
```

The user's preferred nonlocality control is combinatorial and Feynman-style:

```text
K(x,y;U) = sum over allowed paths gamma : x -> y of A(gamma;U).
```

Exponential decay should not be a primitive definition. It should be one useful
corollary when path-count growth and per-path damping are subcritical.

## Context pack

Generated before submission:

```text
AgentTasks/context-packs/gate-c1-nl-path-sum-control-c108-20260627-145843.md
```

## Target file

```text
AgentTasks/aristotle-standalone/c108-path-sum-control-20260627/C108PathSumControl/PathSumControl.lean
```

## What to prove

Please repair and prove the standalone Lean file without weakening the intended
mathematical content.

Primary theorem:

```lean
theorem summable_pathLengthContribution_of_geometric_bounds
    (pathCount ampBound : Nat -> Real)
    (C A a b : Real)
    (hC : 0 <= C)
    (hA : 0 <= A)
    (ha : 0 <= a)
    (hb : 0 <= b)
    (hab : a * b < 1)
    (hcount_nonneg : forall n, 0 <= pathCount n)
    (hamp_nonneg : forall n, 0 <= ampBound n)
    (hcount : forall n, pathCount n <= C * b ^ n)
    (hamp : forall n, ampBound n <= A * a ^ n) :
    Summable (PathLengthContribution pathCount ampBound)
```

Tail theorem:

```lean
theorem summable_shifted_pathLengthContribution_of_geometric_bounds
    ...
    Summable (fun k => PathLengthContribution pathCount ampBound (N + k))
```

You may add helper lemmas. If the statement needs a small API adjustment, keep
the intended content:

```text
subcritical path-count growth plus per-path damping implies summable path
length contributions.
```

## Proof sketch

Bound:

```text
pathCount n * ampBound n
  <= (C * b^n) * (A * a^n)
  = C*A*(a*b)^n.
```

Since `0 <= a*b < 1`, the geometric series is summable. Apply a comparison
test. The shifted-tail version follows by applying the first theorem to the
shifted sequence or by summability under composition with `fun k => N+k`.

## Deliverables

Return:

```text
1. The completed Lean file.
2. Whether either theorem statement changed.
3. Helper lemmas added.
4. Any remaining holes.
5. Whether the narrow check passed:
   lake env lean C108PathSumControl/PathSumControl.lean
```

## Claim boundary

This does not prove C1_NL. It only proves the first combinatorial control
lemma:

```text
path-sum tails can be controlled by path-count growth plus per-path damping.
```
