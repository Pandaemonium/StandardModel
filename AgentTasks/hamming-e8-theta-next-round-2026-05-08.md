# Hamming E8 theta next-round Aristotle jobs - 2026-05-08

Status: submitted 2026-05-08.

Purpose: advance the theta-series side of the Hamming -> Construction A -> E8
manuscript after the trusted file `PhysicsSM/Coding/E8ThetaSeries.lean` proved
the coefficients through `q^4`.

This round is intentionally split into disjoint write scopes so completed jobs
can be integrated independently.

## Submission project

```text
AgentTasks/aristotle-submit/hamming-e8-theta-next-20260508-v2-project
```

This is a slim copy of the current working tree, excluding `.git`, `.lake`, and
`AgentTasks`. An earlier non-destructive copy attempt to the non-`v2` path
timed out after copying only root files, so the `v2` path is the submitted
project.

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| TS1: Mathlib sigma bridge | `AgentTasks/aristotle-output/hamming-e8-theta-sigma-bridge-retry` | `cd0b3c7f-0592-4efe-b86b-9b9b7a78e32d` | queued |
| TS2: q^5 shell coefficient | `AgentTasks/aristotle-output/hamming-e8-theta-q5-shell` | `23728ed4-06ef-413a-a0a9-1b3f45098a9d` | queued |
| TS3: Construction A theta-weight bridge | `AgentTasks/aristotle-output/hamming-e8-theta-weight-bridge` | `ca1695c1-ec6a-48ce-abfc-100bb4b03bd6` | queued |
| TS4: Poisson/modularity scaffold | `AgentTasks/aristotle-output/hamming-e8-theta-poisson-scaffold` | `2354fc26-4b32-4a63-8f47-ba25fb5ca037` | queued |

Submission notes:

- The first TS1 submission, `a200ae32-1d3b-4984-bc20-6f4c54366011`, failed
  immediately with a Harmonic internal error. It was resubmitted with the same
  prompt and same project as `cd0b3c7f-0592-4efe-b86b-9b9b7a78e32d`.

## Shared constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce `axiom`, `opaque`, `unsafe def`, `admit`, or trusted
  `sorry`.
- Trusted modules must be sorry-free.
- Draft modules may contain documented `sorry` only when the target is
  genuinely blocked by missing Mathlib infrastructure.
- Do not import Sphere-Packing-Lean for these jobs.
- Keep theta normalization explicit: the project uses the unscaled integer
  norm `sqNorm z`; theta index `n` means `sqNorm z = 4 * n`.
- Existing trusted theta coefficients:
  - `thetaCoeff_eq_e4Coeff_one`
  - `thetaCoeff_eq_e4Coeff_two`
  - `thetaCoeff_eq_e4Coeff_three`
  - `thetaCoeff_eq_e4Coeff_four`

## TS1: Mathlib sigma bridge

Write scope:

- New trusted file: `PhysicsSM/Coding/E8ThetaSigmaBridge.lean`
- Do not modify `PhysicsSM/Coding/E8ThetaSeries.lean` unless absolutely needed.

Goal:

Connect the local `sigma3` definition in `E8ThetaSeries.lean` with Mathlib's
canonical divisor-sum API, expected to be under `Nat.ArithmeticFunction.sigma`.

Preferred endpoint:

```lean
theorem sigma3_eq_mathlib_sigma (n : Nat) :
    sigma3 n = Nat.ArithmeticFunction.sigma 3 n
```

The exact right-hand side may need adjustment to match Mathlib's API and
codomain. If the canonical theorem has a different name or coercion shape, use
the best Mathlib-native statement and include convenience corollaries for
`n = 1, 2, 3, 4`.

Fallback:

- A trusted theorem for all positive `n` if `n = 0` has a convention mismatch.
- A small API map in comments plus proved lemmas for `n = 1, 2, 3, 4` using
  Mathlib's sigma, if the fully general coercion theorem is unexpectedly hard.

Minimum useful result:

- The manuscript can say the local `sigma3` is compatible with Mathlib's
  arithmetic-function divisor sum.

## TS2: q^5 shell coefficient

Write scope:

- New trusted file: `PhysicsSM/Coding/E8ThetaSeriesQ5.lean`
- Import `PhysicsSM.Coding.E8ThetaSeries`.
- Do not modify `E8ThetaSeries.lean` in this job.

Goal:

Prove the next theta coefficient:

```text
theta coefficient at q^5 = 240 * sigma3 5 = 30240.
```

Use the same normalization as `E8ThetaSeries.lean`: this is the shell
`sqNorm z = 20`.

Suggested strategy:

1. Prove `sigma3_five : sigma3 5 = 126`.
2. Decompose the shell `sqNorm = 20` into:
   - an inner part with all coordinates in `{-3, ..., 3}`, counted by
     `shellCountRange7 20`;
   - a spike part with exactly one coordinate `+/- 4`, and the remaining
     coordinates contributing squared norm `4`.
3. Prove the spike coordinate is unique because two coordinates of absolute
   value `4` would already have norm at least `32`.
4. Use `native_decide` only for finite bounded counts, and document the
   `Lean.trustCompiler` boundary.

Preferred endpoint:

```lean
theorem thetaCoeff_eq_e4Coeff_five :
    -- q^5 shell count, including the spike decomposition,
    -- equals 240 * sigma3 5
```

Fallback:

- A sorry-free file proving the inner count and a precisely stated spike-count
  theorem if the final decomposition proof is the blocker.
- A reusable high-shell decomposition API that will make `q^5` easy in a
  follow-up job.

Minimum useful result:

- At least one new trusted count or decomposition theorem beyond the existing
  `q^4` result.

## TS3: Construction A theta-weight bridge

Write scope:

- New trusted file: `PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean`
- Import `PhysicsSM.Coding.E8ThetaSeries` and
  `PhysicsSM.Coding.HammingWeightEnumerator`.
- Do not modify existing theta files in this job.

Goal:

Start replacing brute-force full-vector shell counts with a theorem that
relates Construction A theta coefficients to the binary code's weight
enumerator.

Suggested finite version:

- Define one-coordinate contribution counts for even and odd residue classes.
- For a binary codeword of Hamming weight `w`, define the contribution to
  `sqNorm = s` as a finite convolution of `w` odd-coordinate factors and
  `8 - w` even-coordinate factors.
- Specialize to the extended Hamming weight distribution `1, 14, 1` at
  weights `0, 4, 8`.

Preferred endpoint:

A trusted theorem showing that the first few E8 shell counts can be computed
from the weight distribution, for example through `q^4` or `q^5`, without
enumerating all `Z^8` vectors directly.

Acceptable fallback endpoints:

1. A theorem partitioning the shell count by `reduceModTwo z` codeword.
2. A theorem proving that the contribution depends only on Hamming weight, not
   on the support positions.
3. A coefficient formula for `q^1` and `q^2` derived from the weight
   distribution.

Minimum useful result:

- A trusted, reusable bridge theorem that makes the paper's MacWilliams and
  theta-series story mathematically connected instead of merely adjacent.

## TS4: Poisson/modularity scaffold

Write scope:

- New draft file: `PhysicsSM/Draft/E8ThetaPoissonScaffold.lean`
- Optional trusted helper file only if fully proved and SPL-free.

Goal:

Prepare the analytic route to the full identity `Theta_E8 = E4` by mapping the
available Mathlib Poisson-summation and Gaussian APIs to the E8 theta series.

Preferred endpoint:

- Import the relevant Mathlib Poisson/Gaussian modules.
- State a precise draft theorem that an even unimodular rank-8 lattice has a
  theta series transforming as a weight-4 modular form under `S : tau |-> -1/tau`.
- Prove any small reusable precursors that are feasible without adding new
  analytic infrastructure.

Fallback:

- A carefully documented API survey inside the draft file identifying exact
  Mathlib declarations for:
  - Gaussian Poisson summation;
  - Fourier transform of a Gaussian;
  - lattice duality/unimodularity;
  - the missing bridge from the discrete E8 shell-count theta series to an
    analytic theta function on the upper half-plane.

Minimum useful result:

- A future-proof draft scaffold with theorem statements that are honest about
  missing modular-forms and analysis infrastructure.
