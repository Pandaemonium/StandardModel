# Aristotle target: position-dependent pi-flux decoder seed

- Work item: lateral `3+1` flavor-cover route
- Role: Builder / Assassin
- Status: integrated after independent cross-family review
- Target:
  `AgentTasks/aristotle-standalone/pi-flux-cocycle-decoder-20260713/PiFluxCocycleDecoder.lean`
- Dependencies: Mathlib and
  `PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy`

## Mission

Discharge the six explicit proof holes in the finite two-by-two magnetic
translation model.  Prove that the x-dependent sign is nonconstant and flips
under x translation, that the two exact finite shifts anticommute, that both
are bijections, and that no commuting global-sign translation pair can equal
this pi-flux pair.

## Scientific role

The accepted `FlavorCoverChargeObstruction` kills the bare regular-deck charge
assignment, and the Clifford-cover audit kills momentum-independent onsite
projectors as doubler removers.  A genuinely position-dependent cocycle is the
only surviving local escape.  This target proves the minimal pi-holonomy seed;
it does not claim a complete `3+1` decoder.

## Successor gate

After this seed lands, extend the construction to three spatial translations,
transport it through the signed Clifford flavor register, and perform a full
reduced-Brillouin-zone zero- and pi-quasienergy census on the projected walk.
Commutation with a projector alone is insufficient.

## Kill conditions

- Reject a global constant sign presented as a position-dependent cocycle.
- Reject sampled momentum checks as a full-zone census.
- Reject an onsite projector theorem that does not change momentum dependence.
- No new assumptions or trust-expanding declarations.

## Outcome and disposition

Aristotle project `550cdd51-27ef-4c39-ab0e-b8493fa6ed37` discharged all six
proof holes without changing definitions or theorem statements. Local replay
passed, and Claude independently accepted the semantic scope in
`AutonomousLab/reviews/CLAUDE_REVIEW_PiFluxCocycleDecoder_2026-07-13.md`.

Integrated production module:
`PhysicsSM/Draft/NullEdge/PiFluxCocycleDecoder.lean`.

The result proves a genuinely position-dependent sign cocycle, exact
anticommutation of the two magnetic translations, bijectivity, and an explicit
obstruction to replacing the construction by a commuting global-sign pair.
It is only a two-dimensional cocycle seed. It proves no 3+1 decoder, compatible
projector, or zero/pi Brillouin-zone census. Successor project
`cdcc00ba-0380-49ea-8a9a-7f6d8a6a349c` owns those gates.

```yaml
aristotle:
  project_id: 550cdd51-27ef-4c39-ab0e-b8493fa6ed37
  task_id: null
  target_file: PhysicsSM/Draft/NullEdge/PiFluxCocycleDecoder.lean
  expected_module: PhysicsSM.Draft.NullEdge.PiFluxCocycleDecoder
  submission_project: AgentTasks/aristotle-submit/afpl-pi-flux-cocycle-decoder-20260713-project
  output_dir: AgentTasks/aristotle-output/550cdd51-27ef-4c39-ab0e-b8493fa6ed37
  status: integrated
```
