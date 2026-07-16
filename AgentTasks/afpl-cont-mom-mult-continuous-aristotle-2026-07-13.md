# AFPL Aristotle target: live multiplier continuity

- Work item: `CONT-FOURIER-001`.
- Role: Research Scientist.
- Status: LANDED LOCALLY; the theorem was solved before an Aristotle slot
  opened, so the prepared submission was intentionally not fired. The proof
  was accepted by independent Claude review
  `msg-20260713-020903-6a2357a7`, promoted into
  `PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean`, and passed both its
  8,046-job targeted build and the 8,421-job aggregate axiom guard.
- Target:
  `AgentTasks/aristotle-standalone/cont-mom-mult-continuous-20260713/MomMultContinuous.lean`.
- Semantic context pack:
  `AgentTasks/context-packs/cont-mom-mult-continuous-20260713-20260713-013753.md`.
- Submission project:
  `AgentTasks/aristotle-submit/afpl-cont-mom-mult-continuous-20260713-project`.
- Purpose: prove that the actual exact Dirac momentum multiplier is continuous
  and therefore almost-everywhere strongly measurable.  This supplies the
  live measurability hypothesis for the queued representative-safe `L2`
  isometry lift.
- Semantic boundary of this theorem: no `L2` lift, Fourier transport,
  time-group theorem, generator identity, or PDE claim. A separate definition
  now composes this theorem with the reviewed generic lift to obtain the exact
  momentum-space `L2` isometry.
- Provenance: clean-room composition of the repository's exact-flow definition,
  its sharp momentum-Lipschitz theorem, and Mathlib continuity APIs.
