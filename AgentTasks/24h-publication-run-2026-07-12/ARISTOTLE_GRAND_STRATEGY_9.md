# Aristotle grand strategy 9: exact census and continuum composition

Review the complete current publication state after the exact stationary-Weyl
off-corner alias and the arbitrary-`L2` point-sampler correction. Do not edit
files and do not run a broad build. Return `GRAND_STRATEGY9_REPORT.md`.

## Project objective

Produce the strongest honest publication portfolio around the null-edge origin
of mass: exact finite theorems, a strict local `3+1` regulator or sharp no-go,
a changing-lattice `R^3` Dirac-flow convergence theorem, operational
consequences of the Pluecker phase, and a manuscript whose bold claims are
visibly separated from reconstruction hypotheses.

## Read first

- `GOAL_PROMPT_CODEX.md`, `RUN_PLAN.md`, `PAPER_GATE_MATRIX.md`, and
  `MANUSCRIPT_CLAIM_DELTA.md` in this run directory;
- `GRAND_STRATEGY8_REPORT.md` and
  `B_Z2CUBED_FLAVOUR_COVER_STRATEGY_REPORT.md`;
- `B_STATIONARY_AMPLITUDE_WEYL_ORACLE_2026-07-11.md` and
  `Scripts/oracle/analyze_stationary_amplitude_weyl.py`;
- `StationaryAmplitudeWeylTangent.lean`,
  `StationaryAmplitudeWeylAlias.lean`, and
  `StationaryAmplitudeWeylExactOffCornerAlias.lean`;
- `ChangingMomentumCellSampling.lean`, `ChangingMomentumL2Density.lean`,
  and the point-sampler no-go target;
- the technical manuscript sections on the stationary-amplitude walk and the
  changing-lattice continuum limit.

## Required analysis

1. **Exact stationary root census.** Derive the most economical exact real
   polynomial system for `weylStep = I` on three unit circles. Give a concrete
   elimination/resultant/Groebner route that proves completeness, not merely
   another root. The known exact roots are the origin, `(-1,1,-1)`, and the
   `9-40-41` conjugate pair with `z_z=1`. The oracle's remaining fully off-axis
   root is approximately
   `q/pi=(-0.441334330,-0.522325560,0.624904120)`. State the exact certificate
   needed for that root and how to isolate it from extraneous complex roots.
2. **Minimal-doubling verdict.** Explain what exact count would be physically
   meaningful, including zero versus pi quasienergy and Jacobian signs. Do not
   infer Chern charge from a finite Jacobian sign alone.
3. **Cell-average `L2` repair.** Assuming the point-sampler no-go lands, state
   the smallest exact Lean theorem sequence for normalized finite-cell averages:
   AE invariance, linearity, `L2` contraction, constant normalization, wrong
   scaling control, dense-core convergence, arbitrary-`L2` three-epsilon
   extension, and live-multiplier composition.
4. **Publication leverage.** Rank the next six proof jobs by how much they
   improve acceptance prospects for Papers A/B/D/F. Include one-sentence
   manuscript consequences and explicit kill conditions.
5. **Adversarial audit.** Identify every current sentence or gate that still
   confuses a finite relabelling, local tangent, pointwise sampler, Jacobian
   sign, or oracle root with the stronger physical conclusion.
6. Provide two focused Aristotle proof packages that can be launched
   immediately, with exact declarations, imports, nonzero witnesses, and
   negative controls.

```yaml
aristotle:
  project_id: cbbc6200-7cc3-482d-a195-06a6711efba2
  task_id: 577efb11-74f9-43f7-bdb4-38e1903d3b4c
  target_file: review-only
  expected_module: GRAND_STRATEGY9_REPORT.md
  expected_report: AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY9_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-grand-strategy9-20260712-project
  output_dir: AgentTasks/aristotle-output/cbbc6200-7cc3-482d-a195-06a6711efba2
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvested 2026-07-12 01:01 PDT. The report is live at
`GRAND_STRATEGY9_REPORT.md`. It independently derived a complementary
`t_x`-elimination factorization and ranks the exact stationary census and
cell-average `L2` contraction as the two highest-leverage jobs; both are now in
flight. Its claimed four/zero census is an exact CAS result, not yet a kernel
theorem. The report also ranks the Paper-F positive-decomposition moduli
capstone as the next inexpensive composition.
