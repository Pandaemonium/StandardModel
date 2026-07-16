# Claude review: half-space + open-boundary 3+1 landings (3 modules)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-145535, item QCA-3PLUS1-001
- Sources (`PhysicsSM/Draft/NullEdge/`): `HalfSpaceDefectIndex` (230),
  `SpinBlindScheduleCollapse` (143), `OpenBoundaryWeyl3DLift` (400).
- Checks: false shape/vacuity, corrected `N=0` edge case, fixed-window
  stabilization genuinely derived, prose leak 1D->U3 spectrum, spin-blind class
  coverage. NOT to be read as W=1/Fredholm/bulk-edge/continuum-Weyl/single-species.
- Date: 2026-07-13

## Verdict: ACCEPT all 3 (draft-trust, exemplary)

A high-quality tranche that visibly internalizes my prior feedback: proper
build-enforced `#guard_msgs` guards throughout, the OD5 finite-time-vs-asymptotic
distinction stated explicitly, honest missing-API audits, and a self-documented
corrected false edge case. All flagship claims (W=1/Fredholm/bulk-edge/continuum
-Weyl/single-species) are correctly withheld. No changes required to bank.

## HalfSpaceDefectIndex - EXEMPLARY

- **The "sorry" is comment-only (FALSE ALARM).** The only `sorry` (line 69) is
  inside the `/- ... -/` block (61-77) that documents the FALSE ORIGINAL `N=0`
  statement. The live corrected theorem `unilateral_star_mul_sub_mul_star`
  (line 78, hypothesis `1 <= N`) is fully proved. Build shows no "declaration
  uses sorry" warning.
- **Corrected `N=0` edge case (the requested check) - HANDLED WELL.** The
  docstring explains that at `N=0` the truncated shift on `Fin 1` is the zero
  matrix, so the commutator is `0` (not `1` at `(0,0)`); the original identity
  is false there and is corrected to require `1 <= N` (the two boundary sites
  `0`, `N` distinct). Genuine semantic vigilance, self-documented.
- **Fixed-window stabilization genuinely DERIVED (not assumed).**
  `localized_window_trace_stabilizes`: for `K < N`, the windowed defect trace
  `sum over {i.val <= K}` equals exactly `1`, independent of `N` (the
  compensating `-1` is pinned to the receding far site). This is the rigorous
  form of my OD5 fixed-window decoupling, proved via `Finset.sum_eq_single` at
  site 0.
- **Vacuity/false shape - clean.** `localized_source_defect = 1` (nonvacuous),
  `global_defect_trace_zero`/`trace_conjTranspose_commutator_zero` (finite trace
  cancels), `permMatrix_no_defect` (zero-defect unitary control).
- **Honest Fredholm audit.** Explicitly stops at the finite localized precursor;
  a nonzero index needs the infinite one-sided shift on `l^2(N)` + Fredholm
  theory absent from pinned Mathlib (source-audited: only a prose mention + a
  TODO). "No bulk-edge / bulk-boundary correspondence is asserted." 3 proper
  guards.

## SpinBlindScheduleCollapse - EXEMPLARY, covers the declared class

- **Coverage of the declared spin-blind class (the requested check) - YES.**
  `finite_schedule_collapse` quantifies over ALL finite lists
  `xs : List (Complex x M2)` of `(scalar phase, fixed coin)` stages and proves
  each collapses to `(prod scalars) . (ordered prod of coins)`. That is the full
  declared class (scalar spin-blind shift x fixed momentum-independent coin).
  Projector-conditioned shifts are correctly OUTSIDE this class (they are the
  escape; they do not collapse to `scalar . Cfixed`).
- **It is the missing bridge to L9.** The collapse DERIVES the `scalar . Cfixed`
  form (hence scalar logarithmic derivative, since `Cfixed` is constant) that
  `SpinBlindWindingObstruction` (L9) previously only ASSUMED. The derivative
  bridge (`scalar_logDeriv_algebraic`, `scalar_logDeriv_bridge`) honestly records
  the exact further hypotheses (differentiability + `Complex.slitPlane`) needed
  to realize the scalar log-derivative.
- **Non-vacuous.** `witness_collapse` (`stage 2 1 * stage 3 pauliX = 6 . pauliX`)
  + `witness_ne_one`. 3 proper guards.

## OpenBoundaryWeyl3DLift - EXEMPLARY, no 1D->U3 prose leak

- **Prose leak 1D reflecting shift -> full U3 spectrum (the requested check) -
  DOES NOT LEAK.** Both prose and kernel are 1D-scoped: the docstring states the
  eigenvector-uniform-magnitude result is for "the one-dimensional reflecting
  permutation ... ITS eigenvectors ... rules out localization for the bare
  reflecting shift ONLY; it does not classify the spectrum of `U3`." And the
  theorem `eigen_uniform_magnitude` is typed over `State N -> C` (the 1D
  register), NOT `Reg N`/`U3`. No false shape.
- **What is genuinely proved.** Full Pauli/Clifford algebra with orientation
  `sx sy sz = i.1` (labeled "a finite algebraic orientation sign, not a
  momentum-space charge"); `U3_unitary` (exact finite factorization, not a
  Hamiltonian exponential); `shiftX_local` (each coordinate moves <= 1 edge,
  strict locality); `U3_interior_equality` inherited from my OD5
  `OpenDiamondCausalExhaustion.evolveAlong_eq_on_head`.
- **Scope internalizes my OD5 point.** "finite-time causal inaccessibility of the
  boundary is NOT spectral elimination of surface modes ... does NOT establish
  spectral single-species"; "No minimality or continuum-tangent theorem";
  "A momentum-space origin tangent is not computed." Exactly the finite-time vs
  asymptotic-spectral distinction I flagged in the OD5 review. 3 proper guards.

## Independent build/replay footprint

`lake env lean` on all 3: **every one EXITCODE=0**, no `error:`, no `#guard_msgs`
mismatch, and NO "declaration uses sorry" warning on `HalfSpaceDefectIndex`
(confirming the line-69 `sorry` is inside the documentation comment, not live
code). All 3 use only proper `#guard_msgs (whitespace := lax) in #print axioms`
guards (9 total, 3 each), which passed - so the guarded theorems are kernel-clean
at `[propext, Classical.choice, Quot.sound]`. Source scan: 0 real `sorry` / 0
`native_decide` / 0 `axiom`/`opaque`/`admit`. Kernel-clean tranche.

## Bottom line

ACCEPT all 3 for draft-trust. This tranche is the honest half-space/open-boundary
layer: `HalfSpaceDefectIndex` builds the finite localized-defect precursor (with a
corrected `N=0` case and derived fixed-window stabilization) toward the half-space
index my BB review named; `SpinBlindScheduleCollapse` closes the schedule->L9
bridge for the full spin-blind class; `OpenBoundaryWeyl3DLift` lifts to an exactly
unitary, strictly local 3D register while scrupulously refusing to claim the U3
spectrum or single-species. Nothing over-claims W=1/Fredholm/bulk-edge/continuum
-Weyl/single-species.
