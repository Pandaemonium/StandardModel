# Stress-energy boundary and physical controls: Aristotle semantic audit

```yaml
aristotle:
  project_id: b06875b1-56d6-45df-8292-495f0477cb11
  task_id: 7d0f4765-6fe6-4ec9-9d83-6494ddad5392
  target_file: PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean
  expected_module: PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls
  submission_project: AgentTasks/aristotle-submit/null-edge-stress-energy-controls-20260714-project
  output_dir: AgentTasks/aristotle-output/b06875b1-56d6-45df-8292-495f0477cb11
  status: complete and harvested 2026-07-14
```

## Objective

Audit the new G6-G8 boundary and control module. The exact target already passes
its narrow Lean check. Aristotle should attack the interpretation, unit and sign
conventions, and nonvacuity while preserving all theorem statements unless a
precise mathematical defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-stress-energy-controls-20260714-20260714-233107.md
```

## Locked interpretation

1. The two matrix witnesses prove only that the displayed scalar summaries
   (`T_00` or ordinary matrix trace) do not determine a symmetric component
   matrix. They do not claim that every conceivable scalar functional fails to
   encode a tensor through an artificial injection.
2. The weak-field theorem assumes the displayed mostly-minus-compatible
   reduction `G_00 = 2 Laplacian(Phi) / c^2`, nonrelativistic source
   `T_00 = rho c^2`, and field-equation coupling `8 pi G / c^4` with zero
   cosmological term. It checks arithmetic normalization only.
3. `rho` in the Newtonian theorem is mass density. The FLRW continuity section
   uses natural units and treats `rho` and pressure as quantities with the same
   units.
4. The scale-factor continuity equation assumes a homogeneous perfect fluid and
   uses differentiation with respect to nonzero scale factor `a`. It does not
   derive FLRW geometry, a Friedmann equation, or equations of state.
5. No theorem defines physical stress-energy from the null-edge action. The
   point is to show why scalar channel budgets are insufficient and to record
   conditional benchmark controls.

## Required audit

1. Verify symmetry, equal-scalar, and distinct-tensor witnesses and determine
   exactly what no-go language they justify.
2. Check the `8 pi G / c^4` reduction, all powers of `c`, the meaning of `rho`,
   and signature/sign assumptions.
3. Check the dust and radiation derivatives and scale-factor continuity
   equations, including the `a != 0` boundary and natural-unit convention.
4. Search for vacuity, hidden positivity assumptions, and misleading physical
   names.
5. State the exact next theorem needed to obtain a symmetric conserved
   stress-energy tensor from a coframe/metric variation.
6. Run only the narrow target command. Do not run a broad build.

## Success and failure criteria

Success requires a theorem-by-theorem semantic verdict and exact prose
corrections for any overclaim. A false statement requires an explicit
counterexample. Do not weaken the formal statements for convenience.

## Required report

Return the command and result, assumption footprints, convention audit,
falsification attempts, and a concise G6-G8 ledger separating formal controls
from graph-derived physics.

## Harvested result

Aristotle found every submitted formal statement true and preserved all theorem
signatures. Its narrow Lean command passed. The two witnesses establish only
that the displayed `T_00` projection and ordinary matrix trace are noninjective
on symmetric component matrices. The weak-field theorem correctly cancels the
powers of `c` under the convention
`G_mu_nu = (8 pi G / c^4) T_mu_nu`, and the dust and radiation controls exactly
satisfy the assumed natural-unit scale-factor continuity equation for nonzero
`a`.

The audit tightened the distinction between energy density in the component
and FLRW sections and mass density in the Newtonian section. It also made
explicit that `traceBudget` is not the metric trace, that the weak-field result
assumes a mostly-minus-compatible reduction and zero cosmological term, and
that none of the controls derives a metric, stress tensor, Newtonian limit, or
FLRW dynamics from null edges. Those prose corrections were integrated
manually.

The downloaded candidate predates the live
`symmetricStress_unique_of_fullMetricVariation` theorem and must not replace
the live file. That newer theorem supplies the constructive uniqueness
counterpart: equal responses to every symmetric metric variation determine a
symmetric tensor. It still does not construct that response from a matter
action or prove conservation.

The exact next G6 bridge is to define stress-energy by first variation of the
actual null-edge matter action, then derive symmetry and, from diffeomorphism
invariance plus on-shell matter equations, covariant conservation. A coframe
formulation additionally needs local Lorentz invariance or a spin-current
improvement.

Full downloaded audit:

```text
AgentTasks/aristotle-output/b06875b1-56d6-45df-8292-495f0477cb11/extracted/project-files.tar/null-edge-stress-energy-controls-20260714-project_aristotle/AgentTasks/null-edge-stress-energy-controls-audit-report.md
```
