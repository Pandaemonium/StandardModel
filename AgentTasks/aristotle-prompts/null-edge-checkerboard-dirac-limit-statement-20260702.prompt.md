# Null-edge checkerboard topology-explicit Dirac-limit statement

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build commands

Run narrow checks first:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
lake env lean PhysicsSM/Draft/CheckerboardContinuumNext.lean
lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
```

If you add a compiling Lean scaffold, run the narrow check for that file too.

## Current verified state

The checkerboard lane has a finite, kernel-checked base:

- `PhysicsSM.Draft.Checkerboard1D` gives the two-direction transfer model,
  finite path amplitudes, turn count, tuple path sums, and matrix-power
  endpoint path sums.
- `PhysicsSM.Draft.CheckerboardContinuumScaffold` gives endpoint bookkeeping,
  the unitary isotropic step, the generator `isotropicGenerator`, the packaged
  first-order remainder `isotropicStepFirstOrderRemainder`, scalar quotient
  estimates, finite derivatives, the explicit local scalar matrix norm
  `matrixL1Norm`, and normed small-angle estimates.
- `PhysicsSM.Draft.CheckerboardContinuumNext` gives turn-count parity, velocity
  endpoint binomial counts, the one-parameter group law
  `isotropicStep theta ^ n = isotropicStep (n * theta)`, exact product/remainder
  identities, fixed-time subdivision guardrails, quantitative accumulated-angle
  product-error bounds, and local BigO/little-o filter transport statements.
- `PhysicsSM.Draft.CheckerboardSpacetimeCounts` gives refined spacetime endpoint
  counts, Earle/Jacobson-Schulman style binomial-product closed forms, and
  closed-form finite propagator formulas.

Important guardrail: fixed-time subdivision at angle `T` is exact:

```text
isotropicStep (T / (N + 1)) ^ (N + 1) = isotropicStep T
```

Therefore subdivision alone does not make the first-order linearization error
against `1 + T * generator` vanish. Any future continuum statement must use a
topology and scaling limit that compares the correct finite evolution objects,
not this false fixed-`T` linearization claim.

## Literature orientation

Use these as orientation, not as already-formalized facts:

- Strauch, "Relativistic quantum walks", arXiv:quant-ph/0508096.
- Arrighi, Forets, and Nesme, "The Dirac equation as a quantum walk: higher
  dimensions, observational convergence", arXiv:1307.3524.
- Skopenkov and Ustinov, "Feynman checkers: towards algorithmic quantum
  theory", arXiv:2007.12879.
- Arrighi, Di Molfetta, Marquez-Martin, and Perez, "The Dirac equation as a
  quantum walk over the honeycomb and triangular lattices", arXiv:1803.01015.
- Nzongani et al., "Dirac quantum walk on tetrahedra", arXiv:2404.09840.

## Requested work

Please design the next Lean-facing theorem boundary for a topology-explicit
checkerboard-to-Dirac statement. This is a statement/design job, not a request
to prove a full continuum limit.

The desired output is a concrete, reviewable plan that answers:

1. What finite evolution object should be compared with the continuum
   1+1D Dirac evolution?
2. What interpolation or observation map should be introduced from lattice data
   to continuum spinor data?
3. What norm/topology should the Lean theorem use first: finite-dimensional
   matrix norm, pointwise compact-time observation norm, `L2`, distributional,
   or another topology?
4. Which scaling parameters should be explicit? Include lattice spacing, time
   step, number of steps, mass angle, momentum range, and initial-data
   regularity or bandlimit if needed.
5. Which current finite theorems can be dependencies, and which analytic
   lemmas are still missing?
6. What is the smallest honest theorem statement we can add next without
   claiming more physics than the Lean objects represent?

If you add Lean, prefer a compiling scaffold of definitions/records and
statement-free helper APIs. If a theorem cannot be proved now, put the intended
statement in Markdown or a Lean comment rather than adding proof placeholders.
Do not introduce new untrusted constants or change existing theorem statements.

## Suggested Lean-facing shape

One likely next layer is a record, perhaps named
`CheckerboardDiracScalingData`, that stores:

- lattice spacing `eps : Real`;
- number of steps `N : Nat`;
- total time `T : Real`;
- mass parameter `m : Real`;
- angle rule, for example `theta = eps * m` or a source-justified variant;
- a momentum or compact observation window;
- any regularity/bandlimit hypothesis.

Then state, in docs or comments if not yet provable, a theorem boundary such as:

```text
checkerboard_dirac_limit_statement
```

The theorem should be explicitly labeled as an analytic scaffold until the
required estimates are present.

## Strategy request

Please rank the best next pieces after this design step. Compare:

- a momentum-space finite-dimensional matrix-exponential/Trotter estimate;
- an interpolation/observation API for lattice spinors;
- a source-faithful path-sum asymptotic theorem from checkerboard counts;
- a scheduler/relativistic-clock abstraction that avoids assuming a universal
  physical clock;
- returning to the hyperdiamond pole-structure lane.

For each, label the claim type: finite identity, asymptotic theorem,
reconstruction theorem, consistency check, or physical prediction.

## Constraints

- Do not assert convergence to the continuum Dirac equation as already proved.
- Do not assert the false fixed-`T` linearization limit described above.
- Keep 1+1D checkerboard estimates separate from 3+1D hyperdiamond/Gate C.
- Avoid global norm/typeclass instances unless there is a clear Mathlib-native
  reason.
- Keep the physical reading modest: this is a finite/asymptotic theorem
  boundary, not a completed physical theory.

## Desired output

Return:

1. any modified Lean/docs files;
2. exact commands run and whether they passed;
3. a semantic review of the proposed theorem boundary;
4. a dependency list of missing analytic lemmas;
5. ranked next steps and the single best next Aristotle job.
