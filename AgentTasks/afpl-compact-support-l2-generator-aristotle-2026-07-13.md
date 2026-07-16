# Aristotle focused successor: compact-support L2 generator theorem

- Work item: `CONT-FOURIER-001`
- Role: Builder / Analyst
- Priority: replacement for stalled full graph-domain job
- Date: 2026-07-13
- Aristotle project: `d5df5530-4b14-4891-b358-bfa88f57bdce`

## Why this job exists

The full graph-domain attempt `864c1c0d-c6e6-485f-b657-3f6b9b6fe529`
ran past the two-hour stall limit and its downloadable snapshot contained no
new graph-domain declaration or partial derivative theorem. This successor is
deliberately narrower but must remain mathematically substantive.

## Exact target

For a momentum-space spinor

```text
f : Lp Spinor 2 (volume : Measure FourierMomentum3)
```

assume an explicit finite radius `R` and almost-everywhere support condition

```text
forall-ae k, R < ||k|| -> f k = 0.
```

Using the actual live fibre generator

```text
G_m(k) v = -i H(k,m) v
```

prove both:

1. the function `k |-> G_m(k) (f k)` is strongly measurable and belongs to
   `L2`; package its representative as an `Lp` element without choosing a
   representative-dependent definition;
2. the exact live orbit `t |-> momMultL2Isometry m t f` has strong derivative
   at zero equal to that packaged generator action.

An equivalent sequential difference-quotient limit is acceptable if it is in
the actual `Lp` norm and not merely pointwise.

## Required inputs

- `PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean`
- `PhysicsSM/Draft/NullEdge/MomMultL2StrongContinuity.lean`
- `PhysicsSM/Draft/NullEdge/ExactFlowGenerator.lean`
- `PhysicsSM/Draft/NullEdge/HermitianExpLipschitz.lean`
- `PhysicsSM/Draft/NullEdge/VariablePointwiseL2Isometry.lean`

Reuse the `eLpNorm` dominated-convergence pattern from
`MomMultL2StrongContinuity`. Preserve the generator sign and multiplication
orientation from `ExactFlowGenerator`.

## Required output

Create `PhysicsSM/Draft/NullEdge/CompactSupportL2Generator.lean` or a
self-contained standalone precursor that typechecks under the pinned project.
It must include:

1. a representative-independent bounded-support predicate;
2. an explicit fibre-generator norm bound on the support ball;
3. a theorem deriving `MemLp` for the generator representative;
4. the strong derivative theorem at zero in `Lp`;
5. a nonzero compact-support witness or a theorem covering indicators of a
   finite-measure momentum ball;
6. standard-three axiom guards for every headline theorem.

If the full derivative still blocks, complete items 1-3 and return at most two
precise remaining lemmas. Do not replace item 4 by a hypothesis that already
states convergence.

## Hard boundaries

- No bounded full-`L2` generator claim.
- No operator-norm continuity or Stone theorem claim.
- No Fourier transport, position-space PDE, lattice limit, or Lorentz claim.
- Pointwise differentiability alone is not success.
- Strong continuity alone is not differentiability.
- No new trust expansion.

## Acceptance

The preferred result proves the full compact-support derivative theorem. The
fallback result must at least prove compact support implies the generator is
`L2` and identify the exact non-tautological analytic lemma still needed for
dominated convergence of difference quotients.

## 2026-07-13 stall disposition

The broad job exceeded the two-hour stall threshold.  A snapshot was retained
at
`AgentTasks/aristotle-output/d5df5530-4b14-4891-b358-bfa88f57bdce/in-progress-snapshot.zip`.
Inspection of the target found that every advertised proof hole remained, so
no compact-support theorem was harvested and no differentiability claim is
made from that snapshot.

The stalled run was cancelled and the same Aristotle project was restarted
with a deliberately finite-dimensional first rung.  The restarted instruction
asks only for `fibreGenerator_opNorm_le`,
`fibreGenerator_opNorm_le_on_ball`, `genMult_apply_norm_le`, and
`genMult_continuous`.  It excludes `MemLp`, the strong derivative theorem, and
broad project builds.  These lemmas are useful prerequisites, but completing
them will not by itself establish a compact-support `L2` generator.

## 2026-07-13 focused-rung harvest and analytic successor

Task `a0b320f3-1ba3-4bb6-973e-9c064d515c86` completed the four requested
finite-dimensional norm and continuity theorems with standard-three guards.
The immutable return was downloaded to
`AgentTasks/aristotle-output/d5df5530-4b14-4891-b358-bfa88f57bdce/completed.zip`.
Seven later analytic and witness holes remain, so this harvest is not the
compact-support derivative theorem.  Cross-family review request
`msg-20260713-110830-976eb9a6` was opened before live integration.

The same Aristotle project was then continued on the next three exact rungs:
`momMult_sub_id_norm_le`, `slope_norm_le`, and `genMult_apply_memLp`.  The
continuation explicitly excludes the orbit derivative and witness theorems and
forbids replacing `MemLp` with a domination hypothesis.  Success on this task
would establish the bounded-support generator representative, but still not
strong differentiability of the `L2` orbit.

Claude cross-family review returned `REVISE` with proof acceptance and one
documentation-only repair. The four completed declarations were independently
replayed and accepted as non-vacuous, convention-aligned prerequisites. Before
banking, the module header was changed to state explicitly that seven analytic
and witness proof holes remain and that the module does not establish
time-flow operator-norm continuity or a Stone theorem. The reviewed finite rung
is now present at
`PhysicsSM/Draft/NullEdge/CompactSupportL2Generator.lean`; direct Lean replay
and its targeted build pass, with exactly the seven disclosed draft warnings.
The continued Aristotle task remains in progress on the next three rungs.

## 2026-07-13 in-progress analytic snapshot harvest

The current continuation task is
`477b8bff-2f33-48b4-8be7-dab39d6717cc`. Two attempts to query its live
status/ask channel timed out without output, but an in-progress archive was
downloaded successfully and extracted at:

`AgentTasks/aristotle-output/d5df5530-4b14-4891-b358-bfa88f57bdce/snapshot-1700/output-3_aristotle/`

The snapshot closed the three requested analytic rungs and left exactly the
two advertised final holes:

- `momMult_sub_id_norm_le` - completed;
- `slope_norm_le` - completed;
- `genMult_apply_memLp` - completed;
- `orbit_slope_tendsto` - still open;
- `momMultL2Isometry_hasDerivAt_zero` - still open.

The raw snapshot was not copied wholesale. Its zero-step slope branch needed
an explicit root-namespace disambiguation for `inv_zero`, and its unrelated
rewrite of `ballWitness_ne_zero` used an incompatible `Option` projection and
failed replay. The three proof bodies alone were integrated into the live file,
while the already-reviewed witness proofs and guards were preserved.

Direct replay now passes:

```text
lake env lean PhysicsSM/Draft/NullEdge/CompactSupportL2Generator.lean
```

It reports exactly two disclosed draft warnings, for the sequential `Lp` slope
limit and final derivative theorem. Standard-three axiom guards are active for
all three newly closed declarations. Cross-family semantic review request
`msg-20260713-173307-fe8cacec` is open with interactive Claude/Opus; no strong
differentiability claim is promoted before that review and the last two proofs
land.

Interactive Claude/Opus returned `APPROVE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_CompactSupport_AnalyticRung_2026-07-13.md`.
The review independently matched the source hash, replayed the module, checked
the generator sign/orientation, verified that `MemLp.mono` uses the actual
integrable dominator `(3 * R + |m|) • f`, and passed all four over-claim checks.
The three-rung analytic harvest is therefore banked. The work item and
Aristotle project remain active solely for the two final derivative holes.

The active task was instructed (without a file upload, because Aristotle only
accepts uploads while a project is idle) to preserve the accepted three-rung
harvest and work only on `orbit_slope_tendsto` and the final `HasDerivAt`
packaging. The instruction names the existing `orbit_eLpNorm_tendsto` dominated-
convergence pattern, the pointwise derivative, and the new slope dominator, and
forbids weakening the punctured-neighborhood limit or rewriting the witness.

## 2026-07-13 final-slope stall split

Task `477b8bff-2f33-48b4-8be7-dab39d6717cc` exceeded the two-hour stall
limit. A fresh downloadable snapshot was retained as `snapshot-1810.zip`.
Its project target still contained both final proof holes, while a stale
top-level copy had regressed to five holes; neither copy supplied new proof
content. The live three-rung harvest was therefore preserved unchanged and the
task was cancelled.

Successor task `01d71970-e5f4-4358-b446-2bfc1beadd13` received the current live
module and targets only `orbit_slope_tendsto`. The final `HasDerivAt` packaging
is deliberately excluded until the genuine `Lp` slope limit lands. The prompt
again requires the existing pointwise derivative, the explicit bounded-support
dominator, the `orbit_eLpNorm_tendsto` dominated-convergence architecture, and
the original punctured-neighborhood sequence statement without weakening.

## 2026-07-13 acceptance proof skeleton

A fresh Mathlib semantic search confirmed the exact APIs needed for independent
review of the successor result:

- `HasDerivAt.tendsto_slope_zero` supplies fibrewise punctured-neighborhood
  convergence from `ExactFlowGenerator.momMult_hasDerivAt_zero`;
- `tendsto_lintegral_of_dominated_convergence'` is the nonnegative dominated
  convergence theorem already used by `MomMultL2StrongContinuity`;
- `Lp.tendsto_Lp_iff_tendsto_eLpNorm'` converts the vanishing seminorm of the
  representative difference into convergence in the actual `Lp` norm.

The accepted proof shape is therefore fixed in advance:

1. rewrite the `Lp` difference through `momMultL2Isometry_coeFn` and
   `genRepr_coeFn`;
2. obtain pointwise slope convergence along `hu` by composing
   `momMult_hasDerivAt_zero.tendsto_slope_zero` with the sequence;
3. dominate the error norm by twice the generator envelope, using
   `slope_norm_le`, `genMult_apply_norm_le`, and the bounded-support ball bound;
4. apply nonnegative dominated convergence to the squared extended norm;
5. use `Lp.tendsto_Lp_iff_tendsto_eLpNorm'` to conclude the exact theorem.

This preflight is an acceptance criterion, not a proof claim. In particular,
an output that assumes the `eLpNorm` limit, drops the punctured-neighborhood
condition, or proves only pointwise convergence does not close the gate.

## 2026-07-13 successor completion audit and proof-only retry

Successor task `01d71970-e5f4-4358-b446-2bfc1beadd13` reached Aristotle's
`COMPLETE` state, but its final payload left `orbit_slope_tendsto` unchanged
with a proof placeholder. The integration helper also found conflicting stale
and final snapshots for the same repository path and refused to select one.
Manual comparison confirmed that none of those copies closes the target. No
payload was integrated, and no continuum claim was promoted.

The project was continued with a new proof-only task against the current live
module. Its scope is exactly `orbit_slope_tendsto`: preserve the punctured-
neighborhood sequential statement, use the accepted pointwise derivative and
integrable dominator, pass through nonnegative dominated convergence, and
finish with `Lp.tendsto_Lp_iff_tendsto_eLpNorm'`. The final derivative wrapper,
witnesses, and guards are explicitly out of scope. If this attempt fails, the
required output is the smallest exact Mathlib/API blocker rather than a weaker
theorem.
