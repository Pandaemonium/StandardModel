# Codex audit job 11: post-Route-B, stability, and first-V2 audit

Act as an adversarial mathematical physicist, Lean semantic reviewer, and
simulation-methods auditor. Read all supplied source snapshots, active proof
targets, run matrices, Audit 10, Grand Strategy 04, simulator source, and the
latest results artifact. Do not edit any source file.

The live state supersedes stale focused-package status claims:

- `SuccessiveAxisDiracWalk` is landed: an ordered internal `4x4` split step is
  exactly unitary, its derivative at zero is `-i H`, and `H^2` is the `3+1`
  massive Clifford scalar. It has no position register, conditional shift,
  lattice spacing, or propagator convergence theorem.
- `DiscretePluckerVariationalFlow` is landed: an adjacent-link action genuinely
  derives its recurrence and exact first integral.
- `DiscretePluckerFlowStability` is landed: weighted-square decomposition,
  positive definiteness on `0 < mu < 4`, and a uniform iterate bound on
  `0 < mu <= 2` with the `4/25` witness and `mu = 5` control.
- The simulator has fourteen benchmark families. S18 is the first V2: a
  fixed-momentum `1+1` free-Dirac split-step reproduction with monotone error and
  a claimed `D(k,m)t^2/n` bound. S19 mirrors the action-derived recurrence.
- Finite Gibbs variance and two simultaneous-coin no-go targets are in flight:
  one positive-real and one stronger complex-scalar statement.

Return `POST_ROUTEB_STABILITY_AUDIT_11.md` with:

1. a declaration-by-declaration semantic audit of the three live modules,
   including derivative orientation, Hermiticity, factor order, exact versus
   first-order content, stability windows, and every supplied dictionary;
2. an independent mathematical check of S18's analytic reference, error metric,
   and displayed `1/n` bound: say precisely whether the bound is proved in Lean,
   merely numerically checked, or imported from splitting analysis;
3. the four over-claim checks and nondegeneracy gate on every new flagship;
4. a verdict on whether the positive-real no-go is enough for the manuscript,
   whether the complex-scalar theorem is true as stated, and the shortest proof
   architecture for its kernel-finrank lemma;
5. exact corrections to `THEORY_COMPLETION_MATRIX.md`,
   `MANUSCRIPT_CLAIM_MATRIX.md`, and `SIMULATION_BENCHMARKS.md`;
6. one exact theorem that adds a finite position register and conditional shifts
   to Route B, with a nonzero witness, negative control, and factor-ordering
   convention;
7. one quantitative convergence theorem after that spatial walk, with an
   explicit norm, compact momentum domain, rate, and falsifier;
8. the single highest-value empirical V2 after S18, choosing between Schottky
   heat capacity, checkerboard dispersion, or another better accepted-physics
   target, with observable, units, error metric, and negative control.

Treat package import gaps as packaging facts. Never infer a live build failure
from a focused package that omits `PhysicsSM`. Record any arithmetic or status
error in the supplied strategy/audit reports. The output should be decisive and
usable as the input to Audit 12 or the 07:00 hard audit.

```yaml
aristotle:
  project_id: a97380fb-4f1a-40c4-a5ae-421f4ac73484
  target_file: POST_ROUTEB_STABILITY_AUDIT_11.md
  submission_project: AgentTasks/aristotle-submit/codex-post-routeb-stability-audit-20260710-11-project
  output_dir: AgentTasks/aristotle-output/a97380fb-4f1a-40c4-a5ae-421f4ac73484
  status: idle; harvested and live-reconciled report preserved
```
