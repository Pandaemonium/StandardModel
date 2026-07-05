# Load-bearing audit: QMF compact/Haar reflection-positivity substrate

Audit the newly developed QMF compact/Haar substrate for gauge and reflection
invariance on compact groups and `SU(N)`. This is intended to check whether the
QMF1-RP rung is genuinely complete and whether the next Peter-Weyl / character
expansion rung has been correctly isolated.

## Included context

This package includes the current `PhysicsSM/` tree plus:

- `AgentTasks/context-packs/ym-qmf-rp-load-bearing-audit-20260705-20260705-142649.md`
- `AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md`
- `AgentTasks/fourday-ym-run-2026-07-05/GOAL_STATEMENT_ACHIEVABLE_WORK.md`

Key files:

- `PhysicsSM/Draft/NullEdge/QMF.lean`
- `PhysicsSM/Draft/NullEdge/QMF/CompactHaarInvariance.lean`
- `PhysicsSM/Draft/NullEdge/QMF/SpecialUnitaryCompact.lean`
- `PhysicsSM/Draft/NullEdge/QMF/GaugeHaarInvariance.lean`
- nearby QMF files if present

## Audit questions

1. Are the compactness, topological-group, Haar-invariance, gauge-invariance,
   and reflection-invariance statements semantically aligned with the intended
   compact `SU(N)` link-field substrate?
2. Are any assumptions hidden, especially around Haar measure existence,
   unimodularity, inversion invariance, or nonabelian compact groups?
3. Does the substrate really close the QMF1-RP rung, or is there still a named
   missing theorem?
4. Is the Peter-Weyl / character-expansion gap correctly parked as the next
   rung rather than accidentally assumed?
5. What is the smallest frontier theorem that would connect this substrate to
   the existing finite RP or transfer scaffolding?

## Output format

Return:

- `Verdict`
- `Statement alignment`
- `Hidden-assumption audit`
- `Axiom/dependency concerns`
- `Next theorem target`
- `Recommended claim language`
