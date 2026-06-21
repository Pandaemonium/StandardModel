# Aristotle task: null-edge overnight synthesis wave

Date: 2026-06-21

## Goal

Run an intentionally ambitious overnight proof wave for the null-edge causal
graph program.  The target file collects finite theorem statements that would
substantially strengthen the program if Aristotle can discharge them.

Target file:

```text
PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean
```

Expected module:

```text
PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle
```

## Why this target

The current repo has a strong finite theorem spine:

- trusted checkerboard dynamics;
- trusted finite Pluecker mass theorem;
- no-sorry twistor/Pluecker wrapper;
- no-sorry Yukawa finite gauge-bookkeeping wrapper;
- trusted causal-diamond holonomy invariance and composition;
- integrated higher-gauge path-pair coherence wrapper;
- draft order-complex cochain seed.

This overnight wave asks Aristotle to turn those islands into more powerful
program-level wrappers.  The targets are deliberately ambitious, but they are
still finite algebra, finite combinatorics, and exact bookkeeping.  No
continuum limit, smooth geometry, analytic quantum field theory, or unproved
physics dynamics is being asserted.

## Target clusters

### 1. Stacked causal diamonds

Prove list-level finite Stokes wrappers for vertical stacks of path pairs:

```lean
pathPairDefect_flatPathPair
pathPairDefect_verticalStack_transport
pathPairDefect_verticalStack_comm
pathPairDefect_verticalStack_eq_one_of_all_flat
```

Mathematical intent:

- Non-Abelian stack defects are ordered products of transported cell defects.
- Abelian stack defects are plain products of the individual cell defects.
- Flat cells compose to a flat stack.

Likely proof route:

- Induction on `List (PathPair G)`.
- Use `pathPairDefect_verticalCompose_transport`,
  `pathPairDefect_verticalCompose_comm`, `transportDefect_one`,
  `transportDefect_mul`, and `mul_assoc`.

### 2. Endpoint gauge covariance for path pairs

Prove:

```lean
pathPairDefect_gaugeTransformPathPair
pathPairDefect_gaugeTransformPathPair_comm
```

Mathematical intent:

- Abstract path-pair defects transform exactly like diamond defects.
- In the Abelian case, the defect is invariant.

Likely proof route:

- Unfold `gaugeTransformPathPair` and `pathPairDefect`.
- Use `group` for the non-Abelian statement and `simp [mul_comm]` for the
  Abelian statement.

### 3. Multi-twistor projective mass

Prove:

```lean
multiTwistorPairwiseMass_rescale
multiTwistorPairwiseMass_rescale_const
twoTwistorMassInvariant_eq_zero_iff_pi_collinear
multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction
multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction
multiTwistorMassSqTraceConvention_eq_zero_iff_common_pi_direction
```

Mathematical intent:

- Multi-twistor pairwise mass has the expected projective rescaling law.
- Vanishing multi-twistor mass is exactly common projective momentum-spinor
  direction, assuming the chosen base spinor is nonzero.
- The determinant and trace normalization conventions have the same massless
  locus.

Likely proof route:

- Use `infinityTwistorPairing_rescale`,
  `twoTwistorMassInvariant_rescale`,
  `multi_twistor_momentum_det_eq_pairwiseMass`,
  `multiTwistorMassSqDetConvention_eq_pairwiseMass`,
  `multiTwistorMassSqTraceConvention_eq_two_pairwiseMass`,
  and the trusted `fin_bundle_mass_zero_iff_common_direction`.
- For the trace convention, use that `(2 : ℂ) ≠ 0`.

### 4. Yukawa legality classifier

Prove:

```lean
candidateOfYukawaFlip_gaugeLegal
candidateGaugeLegal_iff_exists_yukawaFlip
```

Mathematical intent:

- The finite Standard-Model-like legality predicates pick out exactly the
  four one-generation Yukawa flip channels.

Likely proof route:

- Case split on `CandidateYukawaVertex.left`,
  `CandidateYukawaVertex.right`, and `CandidateYukawaVertex.higgs`.
- Use exact rational arithmetic via `norm_num`.
- Use existing declarations:
  `gaugeLegalPattern_all`, `higgsInsertion_hypercharge_matches`,
  `weakYukawaPattern_all`, `colorNeutralPattern_all`, and
  `YukawaFlip.hyperchargeDefect_eq_zero`.

### 5. Checkerboard endpoint kernels

Prove:

```lean
pathSum_right_right_closed_form_all
pathSum_right_left_closed_form_all
rightStartedPathKernel_eq_closed
```

Mathematical intent:

- Package the right-starting checkerboard endpoint kernel with closed forms
  valid for all `q`, including the straight boundary case `q = 0`.

Likely proof route:

- Split on `q = 0`.
- Use `pathSum_right_right_straight`,
  `pathSum_right_left_straight_zero`,
  `pathSum_right_right_closed_form`, and
  `pathSum_right_left_closed_form`.
- Use structure extensionality for `rightStartedPathKernel_eq_closed`.

### 6. Cochain wrappers

Prove:

```lean
coboundary_is_cocycle
cohomologous_refl
cohomologous_symm
cohomologous_trans
```

Mathematical intent:

- Add first cohomology-language wrappers around the finite order-complex seed
  theorem `cochainCoboundary_comp_self_eq_zero`.

Likely proof route:

- Use `AddMonoidHom.ext`, `cochainCoboundary_comp_self_eq_zero`, and additive
  group algebra for differences.

## Claim boundary

This job does not claim:

- a continuum Dirac limit;
- a continuum Stokes theorem;
- non-Abelian gerbe holonomy;
- projective twistor geometry beyond the current spinor chart;
- a Standard Model mass spectrum;
- a Kähler-Dirac operator.

These are finite wrappers that make those later conjectures sharper.

## Verification before submission

Already run locally:

```text
lake env lean PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean
```

Expected result: the target file typechecks with 21 intentional `sorry`
warnings.

Before submission, run.  On this Windows host, `powershell -File` is the
available form:

```powershell
powershell -ExecutionPolicy Bypass `
  -File Scripts/prepare_aristotle_submission.ps1 `
  -JobName null-edge-overnight-synthesis-20260621 `
  -TaskNote AgentTasks/null-edge-overnight-synthesis-aristotle-2026-06-21.md `
  -CheckPath PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean
```

This package has already been prepared and structurally checked at:

```text
AgentTasks/aristotle-submit/null-edge-overnight-synthesis-20260621-project
```

Submit with a prompt of this form:

```text
Please prove as many of the 21 intentional sorry targets as possible in
PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean.

This is an ambitious overnight null-edge causal graph synthesis wave.  Do not
weaken theorem statements unless a statement is false; if a statement is false
or underspecified, leave a clear note and prove the largest correct helper
lemma you can.

Use the imported theorem islands aggressively:
- PhysicsSM.Gauge.CausalDiamondHolonomy
- PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle
- PhysicsSM.Spinor.PluckerMass
- PhysicsSM.Draft.TwistorPluckerMass
- PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle
- PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle
- PhysicsSM.Draft.NullEdgeCochainDiamond

Helper lemmas in the same file are welcome.  The final target should contain
no sorry/admit/axiom/opaque/unsafe if possible.
```

## Overnight operating plan

When the user asks to submit:

1. Prepare the submission package with the command above.
2. Submit the package to Aristotle.
3. Record `project_id`, `task_id`, and output directory below.
4. Sleep for one hour.
5. Check `aristotle list`.
6. If the project is still running, sleep/check again.
7. If complete, fetch with `Scripts/aristotle/integrate_completed.py` in dry
   run mode, inspect candidate files, then integrate only if clean.
8. If Aristotle proves only a subset, create a follow-up file/task note from
   the remaining hard targets and resubmit.

## Submission

```yaml
aristotle:
  project_id: 9f6f58de-936e-4c7c-9baa-79611df5f136
  task_id: c76e7d6e-22e4-49ac-baae-3d824b0b7f7c
  target_file: PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-overnight-synthesis-20260621-project
  output_dir: AgentTasks/aristotle-output/9f6f58de-936e-4c7c-9baa-79611df5f136
  status: submitted
  last_checked: RUNNING
  submitted_at: 2026-06-21
```

## Hourly checks

- Cycle 1, after ~1 hour: project `RUNNING`; task
  `c76e7d6e-22e4-49ac-baae-3d824b0b7f7c` `IN_PROGRESS`.
- Cycle 2, after ~2 hours: project `RUNNING`; task
  `c76e7d6e-22e4-49ac-baae-3d824b0b7f7c` `IN_PROGRESS`.
- Cycle 3, after ~3 hours: project `RUNNING`; task
  `c76e7d6e-22e4-49ac-baae-3d824b0b7f7c` `IN_PROGRESS`.
- Cycle 4, after ~4 hours: project `RUNNING`; task
  `c76e7d6e-22e4-49ac-baae-3d824b0b7f7c` `IN_PROGRESS`.
- Cycle 5, after ~5 hours: project `RUNNING`; task
  `c76e7d6e-22e4-49ac-baae-3d824b0b7f7c` `IN_PROGRESS`.
- Live progress question, after ~5.5 hours, via
  `aristotle continue --mode ask --wait`: Aristotle reports that all 21
  intentional `sorry` targets have been proved as stated, with no mathematical
  blockers and no need to split, cancel, or resubmit. It says the current work
  is a final cleanup/verification pass after replacing leftover `exact?`
  placeholders; project remains `RUNNING` and the task remains `IN_PROGRESS`
  while the target module compile finishes.
- Instruct-mode intervention, after the job appeared stuck in verification:
  submitted `aristotle continue --mode instruct --wait` asking Aristotle to
  stop waiting on the long build and return or expose the current code. The CLI
  accepted the prompt but the connection dropped before returning a message.
- In-progress snapshot: `aristotle download` succeeded even while the project
  remained `RUNNING`, when given an archive filename rather than a directory:
  `AgentTasks/aristotle-output/9f6f58de-936e-4c7c-9baa-79611df5f136/in-progress-snapshot.zip`.
  Extracted target:
  `AgentTasks/aristotle-output/9f6f58de-936e-4c7c-9baa-79611df5f136/in-progress-snapshot-extract/null-edge-overnight-synthesis-20260621-project_aristotle/PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean`.
- Local check of the extracted snapshot found one real Lean error in
  `candidateOfYukawaFlip_gaugeLegal`: the proof left four
  `WeakLegal`/`ColorNeutral`/`hyperchargeDefect = 0` subgoals unsolved. Repaired
  locally using the imported table lemmas
  `leftMultiplet_chirality_left`, `rightMultiplet_chirality_right`,
  `weakYukawaPattern_all`, `colorNeutralPattern_all`,
  `higgsInsertion_hypercharge_matches`, and
  `YukawaFlip.hyperchargeDefect_eq_zero`.
- Integrated the repaired snapshot into the live draft file. Placeholder scan
  shows no proof placeholders; the only `sorry` match is in the module doc
  comment. Local verification:
  `lake env lean PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean`
  passed, and
  `lake build PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle` passed.

## Semantic review and trusted promotion

Promoted to trusted code on 2026-06-21:

- `PhysicsSM/Gauge/CausalDiamondStack.lean`
  - Promoted the finite vertical-stack path-pair defect API and endpoint gauge
    covariance wrappers.
  - Semantic boundary: this is finite group algebra over the existing
    `PathPair` abstraction in `PhysicsSM.Gauge.CausalDiamondHolonomy`. It does
    not assert a continuum Stokes theorem or gerbe-holonomy interpretation.
  - Trusted dependencies only: imports `PhysicsSM.Gauge.CausalDiamondHolonomy`.
- `PhysicsSM/Spinor/TwistorPluckerMass.lean`
  - Promoted the finite spinor-chart twistor pairing, Plucker mass convention
    bridges, projective rescaling laws, and common-direction massless criteria.
  - Semantic boundary: this is the finite `Spinor2` chart already controlled by
    the trusted Plucker determinant theorem. It does not claim global
    projective twistor geometry.
  - Review note: the common-direction theorem was tied directly to the trusted
    `fin_bundle_mass_zero_iff_common_direction`, rather than relying on the
    longer draft proof text.
  - Trusted dependencies only: imports `PhysicsSM.Spinor.PluckerMass`.
- `PhysicsSM/StandardModel/YukawaGauge.lean`
  - Promoted the finite one-generation Yukawa flip bookkeeping and the candidate
    gauge-legality classifier.
  - Semantic boundary: the classifier says the local predicates defined in this
    module pick out exactly the four encoded one-generation Yukawa channels. It
    does not assert a Standard Model mass spectrum or a complete Lagrangian.
  - Trusted dependencies only: imports `Mathlib.Tactic` and
    `PhysicsSM.StandardModel.OneGenerationTable`.
- `PhysicsSM/Gauge/OrderComplexCochain.lean`
  - Promoted the formal ordered-simplex chain boundary, integral cochain
    coboundary, cocycle/coboundary wrappers, and cohomologous equivalence
    lemmas.
  - Semantic boundary: this is a formal free-abelian-chain toy order-complex API
    over ordered lists, not a geometric cellular cohomology theorem for a
    specific manifold or causal complex.
  - Trusted dependencies only: imports `Mathlib`.

Left in draft for a focused later pass:

- Checkerboard all-`q` endpoint-kernel packaging:
  `pathSum_right_right_closed_form_all`,
  `pathSum_right_left_closed_form_all`, and
  `rightStartedPathKernel_eq_closed`.
- Reason: the proved snapshot depends on the draft checkerboard bridge modules
  `PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle`,
  `PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle`, and
  `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`. The statements look
  plausible and locally check in draft, but promotion should migrate and review
  those prerequisites as their own trusted checkerboard package.

Promotion verification:

- `lake env lean PhysicsSM/Gauge/CausalDiamondStack.lean`
- `lake build PhysicsSM.Gauge.CausalDiamondStack`
- `lake env lean PhysicsSM/Spinor/TwistorPluckerMass.lean`
- `lake build PhysicsSM.Spinor.TwistorPluckerMass`
- `lake env lean PhysicsSM/StandardModel/YukawaGauge.lean`
- `lake build PhysicsSM.StandardModel.YukawaGauge`
- `lake env lean PhysicsSM/Gauge/OrderComplexCochain.lean`
- `lake build PhysicsSM.Gauge.OrderComplexCochain`
- `lake build PhysicsSM`

The promoted trusted modules do not import `PhysicsSM.Draft` and contain no
proof `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, or `native_decide`.
