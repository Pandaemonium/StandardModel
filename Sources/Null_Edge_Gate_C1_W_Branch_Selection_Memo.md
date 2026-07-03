# Null-edge Gate C1 W_branch Selection Memo

Date: 2026-06-29
Status: Updated after Aristotle C278 review of Pro's Taste16 candidate.

## Executive summary

Gate C1 now has two concrete `W_branch` proposals to test.

The first is the Pro branch-locked taste lift.  It uses a 16-state taste register
`Taste = Fin 4 -> Bool` so each branch corner can be locked to a distinct taste
sector.  It is systematic and closest in spirit to Adams/staggered flavored
Wilson overlap constructions.

The second is the Aristotle C277 directional-cosine candidate.  It uses only a
`Fin 4` fiber and selects one non-origin branch corner with a diagonal
matrix-valued Wilson mass.  It is more ad hoc physically, but it has an immediate
checked Lean witness: a one-branch mass window, nonzero retained branch index,
non-scalar audit, and corner gap inequalities.

Recommendation after C278: keep both, but change their roles.  Aristotle C277
is the live finite witness because its Wilson term is non-scalar on the spin
fiber and can potentially escape the commutator/index trap.  Pro's literal
Taste16 lift is a useful mass-window benchmark and a documented negative
example: its pure-taste Wilson term commutes with a spin-only slash, so it should
not be promoted as the physical C1 release operator as written.  The serious
physical-flavored lane should instead be a corrected Adams-style spin-taste
mixing operator.

## Requirements for any acceptable W_branch

A candidate `W_branch(k)` must satisfy the following before it can be part of a
credible C1 route:

- Hermitian pointwise, so the overlap seed can be Hermitian after chirality
  multiplication.
- Non-scalar on the branch/taste/spin fiber.
- Not everywhere anticommuting with spacetime chirality.
- Breaks the balance/taste symmetry on the retained island, so the existing
  zero-index trap does not apply.
- Has a finite mass window: one target branch sector negative, all mirror sectors
  positive.
- Gives a true inverse-propagator gap on the bad sector through the C274 square
  theorem, not a propagator-zero mirror removal.
- Is gauge-safe: Standard Model gauge action should be a spectator on the
  branch/taste selector, or the gauge covariance must be explicitly dressed.
- Leaves room for the later physical bridges: real-space gauge-covariant
  operator, locality of the sign function, anomaly/index transport, and Krein
  no-ghost audit.

## Candidate A: Pro branch-locked Taste16 lift

Formula:

```text
W_branch(k) = I_spin tensor [
    r sum_A (I_taste - cos(k_A) tau_A)
  + lambda sum_A (I_taste - tau_A)
  - m0 I_taste
]
```

Here `Taste = Fin 4 -> Bool`; each `tau_A` is a diagonal taste involution with
`tau_A |t> = + |t>` when `t A = false` and `tau_A |t> = - |t>` when
`t A = true`.

At a branch corner `b` and taste sector `t`, the mass table is:

```text
mu(b,t) = 2 r d(b,t) + 2 lambda wt(t) - m0
```

with symbolic window:

```text
r > 0, lambda > 0, 0 < m0 < 2 min(r, lambda).
```

At `r = lambda = m0 = 1`, the target `(b,t)=(0000,0000)` has mass `-1`, while
all bad sectors have mass at least `+1`.

Strengths:

- Distinguishes all 16 branch corners cleanly.
- Has a transparent exact mass table and margin.
- Is closest to flavored/staggered Wilson overlap intuition.
- Gauge action can remain a spectator on `V_SM`.
- C278 proves the symbolic mass window exactly in
  `ProTaste16Review.proMass_window`.

Risks:

- Adds a 16-state taste register, which may be more structure than the null-edge
  seed originally intended.
- Passing the mass table does not guarantee the actual overlap trace/index is
  nonzero in the repo conventions.
- As literally written, this candidate is pure taste:
  `W = I_spin tensor W_taste`.  C278 proves that it commutes with any
  spin-only kinetic slash `Q = Q_spin tensor I_taste`.
- Because the commutator vanishes, the `i[W,Q]` term in the C274 square theorem
  cannot provide the needed chiral release.  The literal Taste16 lift falls back
  into the commuting/index-trap regime.

Best next test:

- Keep the literal Taste16 lift as a mass-level benchmark and negative control.
  Do not treat it as the physical C1 operator unless a spin-mixing correction is
  added.

## Candidate B: Aristotle C277 directional-cosine Fin4 witness

Formula:

```text
W_branch(k) = diag(mPhys(k), mMir(k), mMir(k), mMir(k))
            = mMir(k) I + (2 r cos(k_0) - 2 rho) E00
```

where:

```text
Rstd(k)  = sum_A (1 - cos k_A)
Rstar(k) = (1 + cos k_0) + sum_{A=1}^3 (1 - cos k_A)
mPhys(k) = r Rstar(k) - rho
mMir(k)  = r Rstd(k) + rho
```

The retained target is the non-origin branch:

```text
b* = (true,false,false,false).
```

At branch corners:

```text
branchMass(b) = 2 r d(b,b*) - rho.
```

Window:

```text
0 < rho < 2 r.
```

At `r = rho = 1`, the target has mass `-1`, and every other branch has positive
mass.

Strengths:

- Already has a checked draft Lean implementation in
  `TetraFlavoredOverlapCandidate.lean`.
- Instantiates the production `BranchMassScanWitness` and
  `FlavoredWilsonSearchSpec` APIs.
- Gives immediate nonzero retained branch index in the finite scan.
- Its retained chirality marker is now tied to the checked finite spin-island
  trace `(gamma5 * E00).trace = 1`, rather than being an unexplained constant.
- Provides corner gap inequalities that feed the C274 gap-transfer theorem.

Risks:

- Selects a non-origin branch and explicitly singles out coordinate `0`, so it
  is less symmetric and less obviously physical.
- It may be best understood as a witness that the APIs can express branch
  retention, not as the final Standard Model operator.
- It does not yet prove gauge-covariant real-space realization, locality,
  anomaly matching, or Krein health.

Best next test:

- Integrate the module as a draft finite witness, then ask whether a symmetric
  average/orbit version can retain one physical Weyl line without reintroducing
  the zero-index trap.

## Selection policy

Use a two-lane policy:

1. Minimal witness lane: Aristotle C277 proves the Lean interfaces are live.  It
   remains the primary live finite benchmark.
2. Benchmark/negative-control lane: Pro's literal Taste16 lift records a clean
   branch/taste mass window and the commuting trap.
3. Physical candidate lane: develop a corrected Adams-style spin-taste mixing
   candidate, schematically `gamma5 tensor xi5`, and test it against the C274
   bad-sector gap theorem and the overlap/GW index.

Do not declare C1 closed from either candidate until the following bridges are
proved or explicitly imported by gapped homotopy:

- sector gap for `W^2 + i[W,Q]` in the actual null-edge operator;
- separated spectral island and projector;
- nonzero overlap/GW index, not just mass-table index;
- no propagator-zero ghost substitution;
- gauge covariance and SM anomaly bridge;
- locality/quasi-locality of `sign(H)`;
- Krein positivity/no-ghost audit.

## Immediate work queue

1. Build and keep `TetraFlavoredOverlapCandidate.lean` as the minimal checked
   finite witness.
2. Keep `ProTaste16Review.lean` as the exact mass-window and commuting-trap
   benchmark for the literal Pro lift.
3. Upgrade C277's spin-island chiral trace marker into the full computed
   overlap/GW sign/index.
4. Prove a mirror-sector lower bound for `W^2 + i[W,Q]` and feed it into the
   C274 branch-Wilson gap theorem.
5. Develop a corrected Adams-style spin-taste candidate and prove that its
   commutator with the slash is nonzero before spending effort on its full mass
   table.
