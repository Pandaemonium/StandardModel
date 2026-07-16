# Claude-family skeptic audit verdict: GAUGE-COV-001

- Reviewer: interactive Claude / skeptic (independent of builder Codex).
- Work item: `GAUGE-COV-001`. Request: `CODEX_GAUGE_COV_AUDIT_REQUEST.md`.
- **Verdict: ACCEPT_WITH_SCOPE.** The kernel proves a finite algebraic
  conjugation-covariance/consistency result with a genuine nonidentity control;
  it does NOT prove nonzero-index existence, locality, a continuum anomaly, or a
  physical gauge-field reconstruction. The module's prose already says exactly
  this.

## Findings first

1. **One-sided unitarity is honest (check #1 PASS).** `Dov_conj` assumes only
   `hU : Uᴴ * U = 1`. Line 47 derives `U * Uᴴ = 1` via `mul_eq_one_comm.mp hU`
   — a *valid theorem* for square matrices (a one-sided inverse of a finite
   matrix is two-sided), not a smuggled second hypothesis. The conjugation then
   telescopes through `Uᴴ * U = 1` (inner cancellation) and `U * Uᴴ = 1` (outer),
   both traceable to the single stated hypothesis.
2. **Package composition is coherent (check #2 PASS).**
   `gauge_covariance_package` returns the conjunction of `SignCertificate.conj`,
   `Dov_conj`, and `overlapIndex_conj` applied to the SAME `U`, `hU`, and
   chirality/kernel data (`g`, `eps`, `hg`, `hc`). No divergent unitary is
   introduced across the three legs.
3. **Nonidentity control is real (check #3 PASS).** `swap2 = !![0,1;1,0]` is
   kernel-verified nonidentity (`swap2_ne_one`), unitary (`swap2_unitary`), and
   genuinely conjugates `diag12 = !![1,0;0,2]` to `diag21 = !![2,0;0,1]`
   (`swap2_conj_diag12`, `diag21_ne_diag12`). So the covariance is not vacuous —
   a concrete nonidentity gauge witness produces a concrete change.
4. **Index results are honest controls, not nonzero-index evidence (check #4
   PASS).** `overlapIndex_self_zero` proves `overlapIndex g g = 0` (trivial
   control). `nonzero_index_forces_gap_closure` is a CONDITIONAL — hypothesis
   `hidx : overlapIndex g eps ≠ 0` implies a zero mode; it asserts NO nonzero
   index. Nothing in the module constructs a nonzero-index background.
5. **Over-claim modes (check #5).** Vacuity: no (swap2 control). Hollow
   telescoping: no (genuine conjugation identity + three-way composition). False
   shape: no (the statements are conjugation covariance + index invariance,
   exactly as written). Docstring-outruns-kernel: no — the docstring states
   "conjugation covariance cannot create a nonzero index" and disclaims locality
   / anomaly / gauge-field reconstruction.

## Declarations inspected

`OverlapGaugeCovarianceCapstone`: `Dov_conj`, `gauge_covariance_package`,
`swap2`, `diag12`, `diag21`, `swap2_unitary`, `swap2_ne_one`,
`swap2_conj_diag12`, `diag21_ne_diag12`, `nonidentity_gauge_control`,
`overlapIndex_self_zero`, `nonzero_index_forces_gap_closure`, and the four guard
pins (kernel-only footprint). Predecessors `SignCertificate.conj`,
`overlapIndex_conj`, `OverlapIndexVanishing.exists_zero_mode_of_overlapIndex_ne_zero`
used as cited (interfaces checked at call sites; same `U`/hypotheses threaded).

## Commands run

- `lake env lean PhysicsSM/Draft/NullEdge/GateC2/OverlapGaugeCovarianceCapstone.lean`
  (re-inspected source; builder's `lake build ... GateC2` PASS 8066 jobs
  corroborates). Guard pins report `[propext, Classical.choice, Quot.sound]`.

## Permitted claim grade and scope

**Grade: finite algebraic covariance / consistency result** (program calculus:
`T`/`M` on the matrix algebra — a machine-verified finite identity). Strongest
permitted wording:

> For finite complex matrices with a certified overlap sign, a single one-sided
> unitary change of basis `U` (`Uᴴ U = 1`) transports the sign certificate and
> the overlap operator `Dov` by conjugation and leaves the finite trace overlap
> index invariant; a concrete nonidentity unitary control witnesses that the
> covariance is nontrivial.

## Forbidden readings (scope boundary — keep explicit)

- NOT an existence theorem for a nonzero-index background (the module only proves
  invariance + a *conditional* gap-closure; the sole unconditional index value
  computed is zero).
- NOT a locality theorem (no locality/support structure is used).
- NOT a continuum anomaly theorem (finite matrices only; index invariance here is
  essentially trace conjugation-invariance, not a topological/index-theorem
  statement).
- NOT a physical gauge-field reconstruction (`U` is an abstract basis change, not
  a dynamical gauge connection).
