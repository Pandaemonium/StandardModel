# Aristotle proof/strategy job: full L2 generator domain

## Scientific target

The live continuum lane now has the exact momentum-fibre evolution

```text
U_t(k) = exp(-i t H(k,m))
```

as a representative-safe complex-linear isometry on
`L2(R^3, C^4)`, strong continuity of every orbit, and the pointwise
finite-dimensional derivative with generator `G_m(k) = -i H(k,m)`.

The next gate is the unbounded generator theorem. Define the natural graph
domain

```text
D(G_m) = {f in L2 : k |-> G_m(k) f(k) has an L2 representative}.
```

For every `f` in this domain, prove the strong derivative at zero

```text
lim_{t -> 0} ||(U_t f - f) / t - G_m f||_2 = 0.
```

An equivalent sequential or `HasDerivAt` formulation is acceptable if it
uses the displayed graph domain and the actual live multiplier.

## Existing exact inputs

- `PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean`
  - `momMult`
  - `momMultL2Isometry`
  - representative theorem and exact norm preservation
- `PhysicsSM/Draft/NullEdge/MomMultL2StrongContinuity.lean`
  - zero-time identity
  - strong continuity of every fixed-state orbit
- `AgentTasks/aristotle-standalone/exact-flow-generator-20260713/ExactFlowGenerator.lean`
  - `fibreGenerator`
  - `exactFlow_hasDerivAt`
  - `momMult_apply_hasDerivAt_zero`
- `PhysicsSM/Draft/NullEdge/VariablePointwiseL2Isometry.lean`
  - representative-safe pointwise lift and composition API

## Requested output

1. First determine the cleanest Lean 4.28 definition of the graph domain and
   generator action that is independent of representatives.
2. Try to prove the full strong-derivative theorem on that domain. A likely
   route is a pointwise matrix-exponential difference quotient plus a
   domination by a constant multiple of `||G_m(k) f(k)||`, followed by the
   same `Lp` dominated-convergence API used in
   `MomMultL2StrongContinuity`.
3. If that domination is not available directly, prove the strongest
   non-tautological dense-domain rung, such as compact-momentum-support states,
   and state exactly what remains to reach the graph domain.
4. Include a nonzero state/domain witness or a theorem showing an explicit
   compact-support class lies in the domain.
5. Return a concise completion report listing statement changes, remaining
   proof holes, assumptions, and exact Lean blockers.

## Hard boundaries

- Do not replace the graph-domain condition by an assumption that already
  states convergence of the difference quotient.
- Do not call strong continuity differentiability.
- Do not claim a bounded full-`L2` generator, operator-norm continuity,
  Stone's theorem, Fourier transport, a position-space PDE, a continuum
  limit, or Lorentz restoration.
- Preserve the generator sign `-i H`. The explicit `2*pi` Fourier
  convention belongs only to the later position-space transport.
- Do not weaken or silently redefine the live multiplier.
- No new `a x i o m`, `o p a q u e`, `u n s a f e`, or compiler-trust
  shortcut. A documented handoff with exact blockers is preferable to a
  misleading theorem.

## Submission metadata

- Lab work item: `CONT-FOURIER-001`
- Context pack:
  `AgentTasks/context-packs/exact-flow-l2-generator-domain-20260713-20260713-040738.md`
- Trust target: ordinary Mathlib/project axioms only
- Priority: highest-value independent continuum successor while the exact
  time-group, Fourier-derivative, and temperate-growth jobs remain in flight
- Submission project:
  `AgentTasks/aristotle-submit/afpl-l2-generator-domain-20260713-project`
- Aristotle project:
  `864c1c0d-c6e6-485f-b657-3f6b9b6fe529`
- Status: RUNNING; submitted 2026-07-13 04:09 PDT
