# Johnston four-dimensional light-cone coarea successor

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: preregistered analytic successor

## Purpose

Lift the one-variable Johnston delta sequence in squared timelike separation
to the full future-light-cone distribution in `3+1` Minkowski spacetime. This
is the analytic successor to
`johnston-4d-lightcone-delta-aristotle-2026-07-17.md` and the deterministic
precursor to the random-sprinkling benchmark.

## Locked conventions

Use mostly-minus signature and future-cone coordinates

```text
x = (t, r * omega),
s = t^2 - r^2,
t = sqrt(r^2 + s),
r > 0, s > 0, omega in S^2.
```

The spacetime volume element is

```text
d^4 x = r^2 dt dr dOmega
      = r^2 / (2 * sqrt(r^2+s)) ds dr dOmega.
```

For a compactly supported continuous test function `f`, define its spherical
average at fixed `(t,r)` by

```text
fbar(t,r) = (1/(4*pi)) * integral_{S^2} f(t,r*omega) dOmega.
```

With

```text
k_rho(s) = sqrt(rho)/(2*pi*sqrt(6))
           * exp(-(rho*pi/24) * s^2),
```

the expected-link pairing over the timelike future is exactly

```text
integral_{r>0} integral_{s>0}
  k_rho(s) * 2*pi*r^2/sqrt(r^2+s)
  * fbar(sqrt(r^2+s),r) ds dr.
```

## Locked limit

The target is

```text
limit_{rho -> infinity} expected-link pairing
  = integral_{r>0} r * fbar(r,r) dr
  = pairing of theta(t) * delta(t^2-r^2)/(2*pi) with f.
```

The coefficient follows from two independent factors:

```text
integral_{s>0} k_rho(s) ds = 1/(2*pi),
limit_{s -> 0+} 2*pi*r^2/sqrt(r^2+s) = 2*pi*r.
```

Their product is `r`, matching direct integration of the continuum retarded
light-cone distribution. No endpoint renormalization may be added.

## Lean theorem ladder

1. Prove the radial Jacobian is nonnegative and bounded by `2*pi*r` for
   `r,s >= 0`.
2. For fixed `r > 0`, apply the one-variable delta-sequence theorem to the
   bounded continuous function
   `s |-> 2*pi*r^2/sqrt(r^2+s) * fbar(sqrt(r^2+s),r)`.
3. Bound the absolute inner pairing by `r * ||fbar||_infinity` using kernel
   positivity and exact normalization.
4. Apply dominated convergence on a compact radial support.
5. Separately formalize the spherical-coordinate/coarea identity for compactly
   supported continuous tests.
6. Compose the two results and retain the future-time orientation explicitly.

The first four steps may initially use an abstract bounded continuous
`F(r,s)` in place of the spherical average. The fifth step must remain a
separate public theorem so an abstract radial lift is not mislabeled as a full
Minkowski distribution theorem.

Mathlib already provides the general-dimensional radial measure machinery in
its additive-Haar sphere decomposition. Relevant declarations include
`MeasureTheory.Measure.toSphere`,
`MeasureTheory.Measure.measurePreserving_homeomorphUnitSphereProd`, and
`MeasureTheory.integral_fun_norm_addHaar`; the last displays the radial density
`r^(finrank-1)` explicitly. These APIs should be preferred over the
two-dimensional `polarCoord` chart. The timelike substitution
`t = sqrt(r^2+s)` remains a separate one-dimensional change-of-variables
lemma.

## Scope split

This successor proves an ensemble-expectation distributional limit only. It
does not prove:

- concentration of individual Poisson sprinklings around the expectation;
- convergence of higher link-path powers or the massive Bessel tail;
- a Feynman/Hadamard state or spectral positivity;
- an interacting nonabelian Higgs-doublet propagator; or
- a gauge-invariant Higgs pole.

## Kill conditions

Stop or revise the normalization if any checked derivation gives a coefficient
different from `1/(2*pi)` for the retarded light-cone distribution. Stop the
claimed full lift if the proof covers only radial test functions, silently
drops the future Heaviside factor, needs support separated from `r=0`, or uses
pointwise rather than distributional convergence.

## Primary provenance

- Steven Johnston, *Particle propagators on discrete spacetime*,
  arXiv:0806.3083.
- Nomaan X, Fay Dowker, and Sumati Surya, *Scalar Field Green Functions on
  Causal Sets*, arXiv:1701.07212.
