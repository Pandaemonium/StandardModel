# Causal operator normalization/locality fork: Aristotle hostile audit

```yaml
aristotle:
  project_id: c83d9b6b-b7be-4ba0-9b4e-e9e007e6ed08
  task_id: a9ca8c26-d2b1-4c18-aad5-d63c85492908
  target_file: CausalOperatorLocalityAudit.lean
  expected_module: CausalOperatorLocalityAudit
  submission_project: AgentTasks/aristotle-submit/causal-operator-local-germ-normalization-20260715-project
  output_dir: AgentTasks/aristotle-output/c83d9b6b-b7be-4ba0-9b4e-e9e007e6ed08
  status: completed and harvested 2026-07-15
```

## Objective

Hostilely audit the next curvature route after the global degree-two
mesoscopic algebra and its projected weak calculus failed their preregistered
causal-set gates. Decide whether the next informative step is an analytic
normalization of the retarded kernel, a genuinely local Alexandrov algebra
germ, both in a specified order, or a no-go result.

Semantic context pack:

```text
AgentTasks/context-packs/causal-operator-local-germ-normalization-20260715-182852.md
```

Primary numerical records:

```text
AgentTasks/null-edge-causal-mesoscopic-algebra-stage-a39-benchmark-2026-07-15.md
AgentTasks/null-edge-causal-projected-weak-geometry-stage-a40-benchmark-2026-07-15.md
```

## Exact finite starting point

For a finite operator `B` and multiplication fields `f,h,k`, the kernels are

```text
[[B,M_f],M_h]_{ij} = B_{ij}(f_j-f_i)(h_j-h_i),
[[[B,M_f],M_h],M_k]_{ij}
  = B_{ij}(f_j-f_i)(h_j-h_i)(k_j-k_i).
```

Stage A38 kernel-checks the corrected pairing/double-commutator identity,
normalization, multiplication-potential invariance, weak Hessian symmetry,
and the corresponding `Gamma2` invariance. An ordinary centered finite-
difference d'Alembertian passes the nonlinear flat-chart control: the temporal
and shear Hessians are nonzero while the Bochner Ricci residual is numerical
zero. The weak-calculus implementation is therefore independently controlled.

## Frozen A39 evidence

The candidate algebra was the basis-independent projector onto
`span {1,V,Sym^2 V}`, rank 15, on a two-sided count-depth region. `V` was
tested with supplied oracle coordinates, an order-derived Johnston rank-four
subspace, and a random rank-four negative control. The scale schedule was
`L = c_L sqrt(ell T)`.

Structural controls passed: rank 15, generator-product closure from
`4e-15` to `2e-14`, and general-linear projector covariance below `2.5e-14`.
The physical gates failed. In held-out oracle controls at `N=600`, operator
closure was about `0.675`, `Gamma` closure `0.767`, strong double defect
`0.547`, strong triple defect `1.040`, and the mean pairing was never
Lorentzian. Johnston did not beat the random negative control consistently.
Thus the failure is not explained by the intrinsic generator selector alone.

## Frozen A40 evidence

Stage A40 projected every intermediate `Box`, `Gamma`, Hessian, and `Gamma2`
back into the same degree-two algebra and evaluated the deepest two-sided
orbit. Nonlinear Hessians remained nonzero, so the test was nonvacuous.
Nevertheless, held-out oracle flat controls at `N=600` had weak double defects
`0.530-0.553`, weak triple defects `1.031-1.075`, Lorentz-signature fraction
`0.5`, and flat Ricci residuals `0.989-1.015`. Johnston again failed to beat
random controls. Refinement changed the worst Ricci residual only from
`1.0195` to `1.0151`.

These results kill the tested global region plus strong topology and the
tested global projected weak calculus. They do not kill the exact finite
commutator identities, the degree-two envelope as bookkeeping, or a local
germ with a different continuum normalization.

## Locked constraints

1. The construction may use only the strict order, interval counts, a marked
   event, and explicitly supplied positive microscopic/mesoscopic scales.
2. Embedding coordinates and the target metric are held-out diagnostics only.
3. A random sprinkling cannot canonically select a Lorentz frame. Projectors,
   subspaces, and quotient data must be basis-gauge covariant.
4. Relabeling and general-linear covariance are necessary but not sufficient.
5. No scalar, tensor, shell, core, basis, or hyperparameter may be chosen by
   minimizing target-metric or target-Ricci error.
6. Flat affine, temporal-quadratic, and shear-quadratic charts are mandatory;
   the nonlinear charts must have nonzero Hessian but zero physical Ricci.
7. A retarded boundary must not be silently treated as a symmetric local ball.
8. Do not increase polynomial degree or add another projection unless a
   derivation predicts that change before scoring.
9. Do not claim continuum general relativity from a finite identity or one
   successful sprinkling family.

## Required audit

1. Run only `lake env lean CausalOperatorLocalityAudit.lean` as the Lean
   preflight and report the result.
2. Explain whether the A39/A40 failure magnitudes are expected from the
   continuum moment structure of a retarded causal-set d'Alembertian, from
   finite boundary contamination, from the chosen global `L2` topology, or
   from a more fundamental mismatch.
3. Derive, rather than fit, the continuum action of the four-dimensional
   smeared retarded kernel on constants, affine functions, all independent
   quadratics, and representative cubics. Lock metric signature, operator
   sign, density, discreteness length, nonlocality scale, and boundary terms.
4. Determine whether a scalar normalization, lower-order subtraction, or
   finite-rank operator correction can recover the desired second-order
   principal symbol simultaneously in temporal and spatial directions. State
   a no-go theorem if one scalar cannot do so.
5. Audit whether the A29 rank-one pivot-tensor correction can be lifted to the
   operator before forming commutators without using target coordinates. Give
   an exact finite formula and covariance statement, or reject the lift.
6. Design an exact order-only local Alexandrov algebra germ around a marked
   event: outer patch, protected inner core, retarded-support condition,
   boundary treatment, weights, scale schedule, function-space projector, and
   tie/automorphism handling.
7. State how the local germ is compared across density without assuming a
   supplied tetrad. Separate supplied scale calibration from reconstructed
   conformal information.
8. Preregister the smallest decisive numerical experiment. Include
   development, validation, and held-out seeds; affine and both nonlinear flat
   controls; random negative controls; density/scale refinement; explicit
   thresholds; and kill conditions.
9. Give Lean-facing definitions and theorem signatures for the continuum
   moment target, local patch/core covariance, boundary restriction, projected
   calculus, and any no-go result. Every supplied input must remain visible.
10. Rank the analytic-normalization route and local-germ route by information
    gain, cost, and dependence. End with one decision: implement, revise, or
    stop, plus the exact next artifact to build.

## Required report

Return `ARISTOTLE_SUMMARY.md` and
`CAUSAL_OPERATOR_LOCALITY_NORMALIZATION_AUDIT.md` containing:

- the Lean command result;
- a derivation with convention and dimensional checks;
- a diagnosis of every plausible failure source;
- complete local-germ pseudocode if that route survives;
- finite and asymptotic no-go statements where appropriate;
- a frozen next-stage protocol and kill conditions;
- proposed Lean declarations with no hidden geometry inputs; and
- a short decision with the two routes explicitly ranked.

Do not insert proof holes into the Lean seed and do not claim continuum GR.

## Submission record

- The standalone source passed
  `lake env lean AgentTasks/aristotle-standalone/causal-operator-local-germ-normalization-20260715/CausalOperatorLocalityAudit.lean`.
- The focused package passed the exact required command
  `lake env lean CausalOperatorLocalityAudit.lean` using the repository's
  shared dependency cache.
- The temporary cache junction was removed before upload.
- Submitted project: `c83d9b6b-b7be-4ba0-9b4e-e9e007e6ed08`.
- Submitted task: `a9ca8c26-d2b1-4c18-aad5-d63c85492908`.
- Initial task state: `QUEUED`.
- The semantic-index refresh was attempted twice but exceeded its five-minute
  ceiling. The context pack was generated successfully from the existing
  index and the fresh A38-A40 reports were included directly in the package.

## Harvest and review record

- Final task state: `COMPLETE`.
- Harvested with
  `python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-causal-operator-local-germ-normalization-aristotle-2026-07-15.md c83d9b6b-b7be-4ba0-9b4e-e9e007e6ed08`.
- Returned reports:
  `ARISTOTLE_SUMMARY.md` and
  `CAUSAL_OPERATOR_LOCALITY_NORMALIZATION_AUDIT.md` under the recorded output
  directory.
- Decision: **REVISE**, with analytic moments ranked before the local germ.
- The audit derives the scalar principal-symbol obstruction, rejects a generic
  order-only lift of the A29 rank-one correction, and requires a tapered,
  zero-extended Alexandrov germ with a protected core.
- Semantic review found one convention mismatch in the returned prose:
  equation (1) displays the negative of the live project operator. The live
  discrete row and the A41 continuum implementation agree on
  `A[phi(x) - L^-4 integral W phi]`. The scalar-ratio obstruction and locality
  diagnosis are invariant under that global sign.
- The live finite germ API is now
  `PhysicsSM/Draft/NullEdge/AlexandrovAlgebraGerm.lean`; it retains marked
  endpoints as visible localization indices and proves exact cutoff/core
  relabeling covariance.
