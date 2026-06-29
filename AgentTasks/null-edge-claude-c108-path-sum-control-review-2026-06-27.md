# Claude adversarial review packet: C108 path-sum control for C1_NL

Date: 2026-06-27
Project: Null-edge / Gate C1_NL
Subject: C108 `PathSumControl`

## Context

The project has split Gate C1 into two branches:

```text
C1_local:
  local/quasi-local release or no-go/escape-hatch clarification.

C1_NL:
  declared non-ultralocal release using a canonical spectral/Riesz/sign/path-sum
  branch projector with true bad-sector inverse gap, ghost/anomaly/Krein/gauge
  audits, and regulator stability.
```

The user prefers a Feynman/path-integral-style nonlocality control:

```text
K(x,y;U) = sum over allowed paths gamma : x -> y of A(gamma;U)
```

rather than making exponential decay the primitive assumption. Exponential decay
should be a sufficient corollary when path-count growth and per-path damping are
subcritical.

## Exact Lean source under review

The wrapper call attaches:

```text
AgentTasks/aristotle-standalone/c108-path-sum-control-20260627/C108PathSumControl/PathSumControl.lean
```

## Intended reading

The target is a finite analytic/combinatorial proxy:

```text
pathCount n <= C b^n
ampBound n <= A a^n
a*b < 1
term n = pathCount n * ampBound n
```

Then the total path-length contribution should be summable, and shifted tails
should also be summable.

## Questions for Claude

Please attack both the Lean statement and the project strategy.

1. Is the theorem statement mathematically correct over `Real`, or are extra
   hypotheses needed, such as `a*b >= 0`, `C*A >= 0`, or absolute values?
2. Is `Summable (PathLengthContribution pathCount ampBound)` the right first
   target, or should the primitive be a tail-bound inequality with an explicit
   geometric estimate?
3. Does this theorem capture the user's path-sum preference well enough, or is
   it too weak/too exponential in disguise?
4. What is the main overclaim risk if we cite C108 later in the Gate C1_NL
   narrative?
5. What should the next theorem be after C108: Riesz projector gauge covariance,
   explicit path-amplitude gauge covariance, finite-volume regulated sums, or
   conditional oscillatory path-sum control?

## Requested output

Return:

```text
Verdict:
- sound / needs adjustment / false / too weak

Statement issues:
- ...

Gate C1_NL interpretation risks:
- ...

Best next theorem:
- ...
```
