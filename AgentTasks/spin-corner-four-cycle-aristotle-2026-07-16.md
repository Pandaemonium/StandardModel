# Aristotle job: four-cycle Bargmann + exact hairpin lune-phase law (spiral wave 2, job A)

Date: 2026-07-16
Context: spiral-layer wave 2, continuing the 2026-07-14 zigzag-vs-spiral
thread after wave 1 landed (ChiralSpiralCommutatorAristotle,
SpinCornerBargmannAristotle, HairpinLunePhaseAristotle all integrated).

```yaml
aristotle:
  project_id: 3b35a00c-6139-4105-9ac9-7742c7810bb2
  task_id: TBD
  target_file: FourCycleCore/SpinCornerFourCycle.lean
  expected_module: FourCycleCore.SpinCornerFourCycle
  submission_project: AgentTasks/aristotle-submit/spin-corner-four-cycle-20260716-project
  source_root: AgentTasks/aristotle-standalone/spin-corner-four-cycle-20260716
  output_dir: AgentTasks/aristotle-output/3b35a00c-6139-4105-9ac9-7742c7810bb2
  status: submitted
  integration_target: PhysicsSM/Draft/NullEdge/SpinCornerFourCycleAristotle.lean
```

## Goal

Upgrade the wave-1 rational hairpin witnesses (-1/4 vs +1/4) to exact laws:
the general polynomial four-cycle Bargmann identity, its orientation
corollaries, and the crown jewel `hairpin_lune_phase`:
tr(P(z) P(u,v,0) P(-z) P(u',v',0)) = (conj(u+iv) * (u'+iv'))/4 - the
azimuthal U(1) of meridian resolutions acts as a literal complex phase, so
the 1+1 checkerboard corner factor i IS the quarter-turn lune
(`quarter_turn_corner`: trace = i/4), as a theorem rather than a witness.

## Statements (9, placeholder-proof targets, do not weaken)

`four_cycle`, `four_cycle_im`, `four_cycle_planar_real`,
`four_cycle_reversal_conj`, `hairpin_lune_phase`,
`hairpin_lune_phase_complex`, `quarter_turn_corner`, `half_turn_corner`,
`zero_turn_corner`.

## Preflight

- Statements typechecked 2026-07-16 (`lake env lean`, only placeholder
  warnings).
- Coefficients hand-derived twice from
  tr(ABCD) = 2[(a.b)(c.d) - (a x b).(c x d)] and cross-checked against BOTH
  wave-1 rational witnesses: hairpin (z,x,-z,-x) -> -(1/4), backtrack -> +1/4.
- The lune law was verified symbolically: Sum-dots = -1 + (u u' + v v'),
  quadratic term contributes +(u u' + v v'), triples t(abd) = t(bcd)
  = u v' - v u', others vanish; total (1/4)[(u u' + v v') + i(u v' - v u')].

## Semantic review checklist (for integration)

- The four-cycle quadratic terms must stay exactly
  (a.b)(c.d) + (a.d)(b.c) - (a.c)(b.d) (sign of the crossed term is the
  content).
- `hairpin_lune_phase` must remain hypothesis-free (polynomial); ez is unit
  by construction, which is what discharges the a.c = -1 use.
- Orientation: triple stays right-handed; `quarter_turn_corner` = +i/4 (not
  -i/4) fixes the handedness convention linking meridian order to phase
  sign; flipping it silently flips the matter/antimatter reading.
- Axiom audit per theorem; kernel decide fine; no compiled-evaluator tactic.
