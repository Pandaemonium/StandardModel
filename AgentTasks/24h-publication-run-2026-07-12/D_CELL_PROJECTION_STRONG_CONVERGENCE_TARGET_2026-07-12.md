# Gate D cell-projection strong-convergence target

## Objective

Prove the declarations in
`AgentTasks/aristotle-targets/codex_24h_d_cell_projection_strong_convergence.lean`
without weakening the final statement. The target is the first
representative-safe arbitrary-`L2(R^3)` convergence theorem for the changing
momentum cells:

```lean
theorem projectAt_tendsto_strong_L2
    (f : Momentum3 -> Complex) (hf : MemLp f 2 volume) :
    Tendsto
      (fun N => ∫ x, ‖projectAt N f x - f x‖ ^ 2)
      atTop (nhds 0)
```

Here `projectAt N` is the normalized cell-average projection with the landed
Gate D schedule

```text
h_N = 1 / (N + 1),
K_N = (N + 1)^2,
integer labels k_i in [-K_N, K_N].
```

Thus `h_N -> 0` and `K_N h_N = N + 1 -> infinity`. The theorem is a genuine
strong `L2` limit on `R^3`; it does not compose live walk dynamics, Fourier
transport, or the Dirac PDE.

## Existing inputs

- `ChangingMomentumCellProjectionL2.projectFinite_L2_contraction` proves the
  normalized finite projection is an `L2` contraction, assuming the local
  `L1` and global squared-integrability facts.
- `ChangingMomentumL2Density.memLp_exists_compact_global_lipschitz_eLpNorm_approx`
  supplies one compactly supported smooth globally Lipschitz approximant to an
  arbitrary `MemLp` field.
- `ScaledChangingMomentumWalk.physicalSpacing_tendsto_zero` and
  `physicalRadius_tendsto_atTop` pin the same mesh and box schedule used by the
  live Gate D multiplier theorem.
- `ChangingMomentumCellSampling` supplies the half-open-cell geometry and the
  center-sampling dense-core rate. Its global convergence theorem cannot be
  applied directly to the complete scheduled cube because that theorem assumes
  uniformly bounded represented volume.

## Mathematical route

1. Derive local Bochner integrability on each finite-volume cell from
   `MemLp f 2 volume`. This discharges, rather than assumes, the local input to
   the landed contraction theorem.
2. Prove eventual coverage of every compact support by the explicit scheduled
   cell cube. The half-open upper face is harmless because the physical radius
   tends to infinity and an eventual strict margin can be chosen.
3. Localize a compactly supported field to `activeModes`: scheduled cells on
   which the field is nonzero. Although the complete box volume grows like
   `N^3`, the active-cell union remains inside a fixed enlargement of the
   compact support once `h_N <= 1`, so its volume is uniformly bounded.
4. On one cell, show the normalized average differs from a globally
   `L`-Lipschitz field by at most `L h_N`. Two points in the same product
   sup-norm cell are at distance at most the side length.
5. Integrate that pointwise estimate only over the active cells. This gives a
   bound of the form `V (L h_N)^2` and proves strong convergence on the compact
   Lipschitz core.
6. Convert the landed `eLpNorm` density result at exponent two into an
   arbitrarily small squared-integral error, retaining compact support,
   smoothness, global Lipschitz control, and `MemLp` membership for the same
   approximant.
7. Use linearity and contraction in the three-term identity
   `P_N f - f = P_N(f-g) + (P_N g-g) + (g-f)`. The target records the explicit
   estimate

   ```text
   integral |P_N f - f|^2
     <= 6 integral |f-g|^2 + 3 integral |P_N g-g|^2.
   ```

   Density makes the first term arbitrarily small, and compact-core convergence
   makes the second term eventually small.

## Why this statement is honest

- It does not use point values on arbitrary `L2` representatives. The operator
  is built from normalized cell averages and is already AE-invariant.
- It does not assume a uniform bound on the complete expanding box volume;
  such a hypothesis is false for the explicit exhausting schedule.
- It does not hide the desired conclusion in an abstract approximation
  hypothesis. Compact smooth Lipschitz density is a landed theorem, and the
  mesh and box are concrete definitions.
- It does not require continuity or pointwise regularity of the arbitrary input
  `f`.
- It is not a live-evolution or position-space theorem. Those remain successor
  compositions after this projection gate lands.

## Proof holes and expected blockers

The target is intentionally a typechecking handoff with documented `s o r r y`
markers. The principal obligations are:

- `memLp_two_integrableOn_momentumCell`: find the clean Mathlib Holder API for
  `L2` restricted to a finite-measure cell.
- `projectAt_sub`: manage set-integral linearity with the local integrability
  facts and distribute the finite indicator sum.
- `compactSupport_eventually_covered`: convert compact support to a coordinate
  bound and connect rounding to `Finset.Icc` labels.
- `active_cellUnion_volume_eventually_bounded`: prove the geometric
  localization to a fixed enlarged cube. This is the load-bearing new argument.
- `projectAt_eq_active`: remove scheduled cells whose normalized integral is
  zero because the field vanishes identically on that cell.
- `projectFinite_pointwise_error_on_cell`: normalize the integral estimate and
  prove the cell-diameter bound in the product sup norm.
- `compact_lipschitz_projectAt_tendsto_sq_error_zero`: combine coverage,
  inactive-cell removal, localized volume, and `h_N -> 0`.
- `memLp_exists_compact_smooth_lipschitz_sq_approx`: convert the exponent-two
  `eLpNorm` estimate to a squared Bochner integral without changing the
  approximant.
- `projectAt_sq_error_le_of_approx`: formalize the three-term squared inequality,
  projection linearity, and contraction.
- `projectAt_tendsto_strong_L2`: perform the final epsilon allocation.

Aristotle should preserve all statements. If a statement is false because of a
half-open boundary, integrability, or `eLpNorm` conversion issue, report the
exact counterexample or missing hypothesis rather than adding an assumption to
the final theorem.

## Overclaim audit

- **Vacuity:** pass. `MemLp f 2 volume` has abundant witnesses, including zero
  and compact smooth functions; the explicit schedule is already constructed.
- **Hollow telescoping:** pass. The compact-core convergence and contraction
  extension are separate nontrivial analytic steps.
- **Docstring outruns kernel:** open. The target remains draft while any proof
  hole is present and must not be cited as landed or kernel-checked.
- **False shape:** pass at target level. The conclusion is the actual global
  squared `L2(R^3)` error tending to zero for the concrete projections.

## Submission metadata

```yaml
aristotle:
  project_id: 08c2af1b-fb78-4bc2-b9ba-b8b040084012
  task_id: 074bff5a-3026-4a48-ac3d-e21249587fd3
  target_file: AgentTasks/aristotle-targets/codex_24h_d_cell_projection_strong_convergence.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongConvergence
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-cell-projection-strong-l2-20260712-project
  output_dir: pending
  status: canceled-after-two-hour-stall-partial-harvest
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Verification record

Direct check run from `C:\Projects\StandardModel`:

```text
lake env lean AgentTasks/aristotle-targets/codex_24h_d_cell_projection_strong_convergence.lean
```

The two-hour snapshot was harvested before cancellation. Six additional
theorems were solved and verified locally: cell-local integrability,
`projectAt_memLp`, squared-error integrability, projection subtraction,
inactive-cell removal, the pointwise Lipschitz cell bound, and the compact
smooth squared-integral density bridge. Together with the original proved
schedule and contraction results, they were promoted to
`ChangingMomentumCellProjectionStrongScaffold.lean`; its targeted build passes
(8,039 jobs) with no proof escapes.

Five theorem-sized gaps remained in the oversized job: compact support
coverage, active-cell volume control, compact Lipschitz convergence, the
quantitative three-term estimate, and final arbitrary-`L2` convergence. The
geometry pair and three-term estimate were resubmitted separately as
`1f673a93` and `d1a1fbfe`. The final two convergence theorems will be composed
after those focused jobs land.
