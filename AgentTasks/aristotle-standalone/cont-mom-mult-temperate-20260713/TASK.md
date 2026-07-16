# Aristotle target: temperate exact Dirac multiplier

## Strategic role

This is the next dependency-ready F3 rung for `CONT-FOURIER-001`. The accepted
F1 theorem gives representative-safe inverse-Fourier `L2` transport. Active
jobs `e790e78a` and `3b1fe9d3` separately target pointwise multiplier isometry
and the explicit `2*pi` derivative symbol. Neither proves that the exact
momentum multiplier preserves Schwartz space.

Mathlib's `SchwartzMap.bilinLeftCLM` has exactly the needed shape: it maps a
Schwartz function `f` to `x |-> B (f x) (g x)` when the second function `g` has
temperate growth. Taking `g(k)` to be the exact bounded spinor operator and
`B(v,A)=A(v)` reduces the Schwartz-preservation gate to the immutable theorem in
`ChangingCellFourierTemperate.lean`.

## Immutable target

Prove, without changing definitions or weakening the conclusion:

```lean
theorem momMultForGrowth_hasTemperateGrowth (m t : Real) :
    Function.HasTemperateGrowth (momMultForGrowth m t) := by
  ...
```

The multiplier is the project's exact flow

```text
exp(-i t H(k)),
H(k) = k_0 alpha_1 + k_1 alpha_2 + k_2 alpha_3 + m beta,
```

transported through `Matrix.toEuclideanCLM`.

## Required proof content

1. Reuse `Compact3Plus1DiracRate.H_isHermitian` and
   `exactFlow_mem_unitary`; do not reprove the finite Dirac algebra.
2. Establish `ContDiff Real infinity` for the operator-valued map.
3. Bound every iterated Frechet derivative by a polynomial in `norm k` as
   required by `Function.HasTemperateGrowth`.
4. Exploit unitarity or a Duhamel/simplex derivative formula. A generic bound
   of the form `exp(C * norm k)` does not prove temperate growth and is an
   invalid route.
5. Add exact controls after the main theorem:
   - `t = 0`, where the multiplier is the identity;
   - zero momentum;
   - a nonzero rest or `3-4-5` momentum witness.
6. Keep the expected assumption footprint to the standard kernel axioms. Do
   not introduce a new axiom, opaque placeholder, trust-expanding evaluator, or
   hidden finite-dimensional assumption.

## Scoped fallback

If the full all-derivatives theorem is blocked by missing Mathlib matrix-exp
derivative infrastructure, do not replace it with mere smoothness or a local
bound. Return:

- the strongest typechecking bounded-derivative lemma actually proved;
- the exact remaining `HasTemperateGrowth` field or iterated derivative goal;
- the smallest reusable Duhamel derivative lemma that would close it.

That fallback is a useful blocker report, not completion of the immutable
target.

## Boundaries

Even a completed theorem proves only that the exact multiplier preserves the
Schwartz class when composed through the appropriate bilinear map. It does not
by itself prove the `L2` multiplier lift, the Dirac PDE, strong continuity,
PDE uniqueness, Lorentz restoration, or an interacting continuum theory.

## Provenance and API checks

- Project flow: `PhysicsSM/Draft/NullEdge/Compact3Plus1DiracRate.lean`.
- Accepted F1 bridge: `PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean`.
- Mathlib temperate growth:
  `Mathlib/Analysis/Distribution/TemperateGrowth.lean`.
- Mathlib Schwartz bilinear multiplication:
  `Mathlib/Analysis/Distribution/SchwartzSpace/Basic.lean`, declaration
  `SchwartzMap.bilinLeftCLM`.
- Strategy source: Aristotle project
  `5d4f2be5-f731-40ea-9dee-d5716b20be69`, with the generic exponential-growth
  route explicitly rejected here.
