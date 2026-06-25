# Claude call: 2026-06-24 round 005 adversarial next job

## Metadata

- Model/tool: `claude -p --bare --tools "" --model sonnet`
- Role in loop: adversarial critique
- Status: completed
- Usefulness rating: pending

## Query

```text
Adversarial critique for Round 005. Newly integrated P1-F cluster: SU2
stabilizer of observer spin frame; two-null scalar bridge det rho and m/E;
residual unitary congruence preserves trace-normalized determinant. P9 screen
quotient bound is also integrated.

We need one next finite standalone Aristotle proof job. Candidate: specialize
the SU2 stabilizer output U = B^-1 A to the normalized determinant invariance
theorem, proving same observer block + det-one frames implies
traceNormalizedDet(observerConjugate (B^-1*A) P)=traceNormalizedDet P. Is this
worth the slot, or should we pivot to P4/P7/P2/P9? Name one job to avoid.
```

## Response

```text
Verdict: worth the slot only if it is genuinely a one-screen glue lemma. The
substantive math is already discharged twice: "B^-1 A in SU(2)" lives in
`NullEdgeObserverSpinFrameSU2.lean`, and residual unitary congruence preserves
`traceNormalizedDet` in `NullEdgeP1SU2NormalizedDetInvariance.lean`.

Recommendation: pivot. Highest expected-value targets:

1. P9 follow-up: an invariant screen-norm or projector-norm corollary that turns
the screen quotient bound into a usable downstream estimate.
2. P4 / mass-shell-side bridge: if det rho <-> m/E is now provable as a scalar
identity, extract m^2 from the determinant rather than re-proving frame
invariance.
3. P7, only if the leaf lemma is genuinely one-file scope.

Job to avoid:

Avoid another P1-F internal decoration lemma, especially anything of the form
"observer-conjugate of an SU(2) residual preserves X" for X in Hermiticity,
positive semidefiniteness, rank, or trace. These would be corollaries of the
new P1 cluster and risk making P1-F look padded.
```
