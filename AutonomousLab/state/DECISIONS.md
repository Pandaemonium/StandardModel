# Decision records

## ADR-001: Persistent lab instead of serial autonomous runs

- Date: 2026-07-12
- Status: accepted by Research Director request
- Decision: Maintain AFPL state, portfolio, roles, cadence, and review gates
  under `AutonomousLab/`.
- Rationale: serial runs repeatedly reconstruct context, duplicate work, and
  optimize short horizons. Persistent memory and stage gates enable cumulative
  learning and procedure improvement.
- Consequence: future autonomous goals should enter through AFPL prompts and
  update shared state rather than create a new constitution by default.

## ADR-002: Cross-model independence

- Date: 2026-07-12
- Status: accepted provisionally
- Decision: role copies within one model do not satisfy independent review;
  headline promotion requires a different model or explicit human disposition.
- Rationale: personality prompts change attention but not underlying model
  correlation.
- Review: first monthly metascience review.

## ADR-003: Interactive Claude Code is the sole Claude channel

- Date: 2026-07-12
- Status: accepted by Research Director request
- Decision: AFPL will not invoke Claude through an API or repository review
  wrapper. Claude-family execution and review occur only in the user-started
  interactive Claude Code session and are coordinated through shared state and
  the transactional mailbox.
- Rationale: the established two-terminal workflow is the desired operating
  model, and a second Claude channel adds cost and routing complexity without
  adding model-family independence.
- Consequence: active `opus` assignments migrate to `claude`; the wrapper
  blocker and restoration queue entry are closed. Historical logs retain their
  original channel labels for provenance.

## ADR-004: Two-pronged 3+1 program after the degree-one obstruction

- Date: 2026-07-13
- Status: active research decision
- Decision: pursue both (a) flavored/twisted decoding of the unavoidable
  `Z2^3` cover and (b) finite-depth null microsteps with longer one-period
  effective range.
- Rationale: the first route turns cover multiplicity into an internal-register
  reconstruction problem; the second preserves primitive null locality while
  escaping the proved degree-one single-factor class.
- Mandatory gate: neither route is a resolution until it passes an exact full
  Brillouin-zone census for both zero and pi quasienergy. Extra effective range
  does not evade a degree-agnostic admissibility/topological balance theorem;
  it may only relocate the partner.

## ADR-005: Open causal diamonds as a third 3+1 architecture

- Date: 2026-07-13
- Status: active research decision
- Decision: add a non-periodic route based on finite open causal diamonds,
  spectral-graph mode counting, and an initial-boundary-value propagator.
- Rationale: every current alias theorem assumes or instantiates a periodic
  momentum torus. An odd open path has a unique centered-difference zero, and
  its four-dimensional Clifford tensor sum is a concrete candidate for one
  bulk valley without microscopic translation invariance.
- Mandatory gate: a single finite-volume bulk zero is not a completed 3+1
  theory. Promotion requires a local null-edge recurrence, a norm-preserving
  boundary register, species-versus-spinor bookkeeping, gauge/anomaly control,
  and an interior exhaustion/continuum theorem.
- Design note:
  `AutonomousLab/work/NE-3PLUS1/CODEX_OPEN_CAUSAL_DIAMOND_ROUTE_2026-07-13.md`.

## ADR-006: Promote anomalous Floquet topology as the primary 3+1 escape route

- Date: 2026-07-13
- Status: active research decision
- Decision: treat the full finite-depth micromotion, not only the endpoint
  Floquet matrix, as the next primary object for the strict 3+1 program.
  Published work exhibits a single Weyl fermion in a three-dimensional
  periodically driven lattice through nontrivial Floquet-unitary topology.
  Build a clean-room finite schedule and prove its zero/pi census, local Weyl
  charge, nonzero loop winding, and primitive-null factorization gate.
- Rationale: open-boundary directed-edge walks are exactly unitary, but the
  first three-dimensional Grover and Fourier coins carry exact or
  asymptotically light boundary sectors. An anomalous Floquet loop can
  compensate static Weyl charge through micromotion topology without
  outsourcing the partner to a spatial boundary. This uses, rather than
  suppresses, the project's discrete-time architecture and existing zero/pi
  bookkeeping.
- Mandatory gate: no claim that Null-Edge has a single 3+1 species is
  authorized until the loop invariant, full tagged census, locality,
  null-support factorization, and anomaly gates are all proved. Kill the route
  if primitive-null factorizations force zero winding.
- Design note:
  `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md`.

### 2026-07-13 refinement: combine bulk topology with causal exhaustion

The open-diamond boundary modes are now treated as possible anomaly-inflow
surface sectors, not as modes that a better local boundary coin must remove.
`OpenDiamondCausalExhaustion.evolveAlong_eq_on_head` proves exact finite-time
independence from arbitrary off-cone boundary changes, with a globally distinct
two-update control. The primary route therefore combines anomalous Floquet bulk
winding with a growing-diamond interior limit. This does not discharge the
asymptotic gate: both zero- and pi-surface weights must still decouple while the
interior propagator converges to the intended single-species continuum theory.
