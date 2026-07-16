# Aristotle target: projective-measurement quantum DPI

## Strategic role

This is the first genuinely quantum data-processing rung above the landed
classical DPI and general noncommuting Klein inequality. It is intentionally
scoped to one physically meaningful channel: projective measurement in the
eigenbasis of the positive-definite reference state `sigma`.

For the overlap matrix

```text
W = U_rho^H U_sigma,
```

the measured output distribution is

```text
p_j = sum_i lambda_i |W_ij|^2,
q_j = mu_j.
```

The target says `D(p || q) <= S(rho || sigma)`. This is not the already-landed
Klein inequality: it compares relative entropy before and after a nontrivial
quantum-to-classical channel.

## Immutable target

Prove the theorem in `ProjectiveMeasurementDPI.lean` without changing the
definitions, adding hypotheses, or weakening the conclusion.

## Intended route

1. Reuse `GeneralQuantumKlein.overlap_mem_unitaryGroup` and its row/column
   squared-modulus sum lemmas. Do not rebuild the spectral theorem.
2. Use `GeneralQuantumKlein.entropy_trace_eq_sum` and
   `GeneralQuantumKlein.cross_trace_eq_sum` to expand the quantum quantity.
3. The reference cross term is unchanged by this measurement:
   `sum_j p_j log(mu_j) = sum_i,j lambda_i |W_ij|^2 log(mu_j)`.
4. Prove the entropy comparison
   `sum_j p_j log(p_j) <= sum_i lambda_i log(lambda_i)` from convexity of
   `x |-> x log x` and the doubly stochastic matrix `|W_ij|^2`.
5. Derive nonnegativity and normalization of `measuredProb` from PSD, trace
   one, and unitarity rather than assuming them separately.

## Required controls

- State the commuting/shared-eigenbasis equality boundary.
- State a nontrivial qubit superposition example where measurement loses
  distinguishability, or report precisely why Mathlib's noncanonical spectral
  basis prevents an executable witness at this abstraction level.
- Audit the final assumption footprint. Do not introduce a new assumption,
  trust-expanding evaluator, or placeholder declaration.

## Scoped fallback

If the capstone blocks, return the strongest typechecking majorization lemma
for `measuredProb`, the unchanged-cross-term lemma, and the exact remaining
goal. Mere nonnegativity of either side is not completion.

## Boundaries

The theorem is projective-measurement monotonicity in the reference
eigenbasis. It does not prove data processing for arbitrary POVMs, pinching in
an arbitrary basis, partial trace, or arbitrary completely positive
trace-preserving channels. It also does not identify a gravitational channel.

## Provenance

- `PhysicsSM/Draft/NullEdge/GeneralQuantumKlein.lean`: CFC-free spectral log,
  overlap unitarity, cross-trace reduction, and general Klein inequality.
- `PhysicsSM/Draft/NullEdge/FiniteClassicalDPI.lean`: finite classical relative
  entropy and stochastic data processing.
- Mathematical route: standard projective-measurement data processing reduced
  to unistochastic majorization; clean-room theorem statement for this repo.
