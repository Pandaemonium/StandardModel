# Aristotle audit/design job: all-time position-space Dirac PDE

- Work item: `CONT-FOURIER-001`
- Role: Assassin / Oracle
- Priority: P95 continuum reconstruction
- Date: 2026-07-13
- Aristotle project: `180406b2-61c5-4d07-bf0d-43225dff2b47`

## Mission

Audit the now-landed continuum ladder and produce the strongest semantically
correct, Lean-ready theorem statement for differentiating the exact
Fourier-conjugated Dirac flow on a displayed domain. Distinguish the cheap
Schwartz statement from the full `L2` graph-domain statement.

## Inputs to inspect

- `PhysicsSM/Draft/NullEdge/ExactFlowGenerator.lean`
- `PhysicsSM/Draft/NullEdge/ExactFlowL2GroupCapstone.lean`
- `PhysicsSM/Draft/NullEdge/ExactFlowSchwartzGroup.lean`
- `PhysicsSM/Draft/NullEdge/FourierDiracSchwartzCapstone.lean`
- `PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean`
- the active target
  `AgentTasks/aristotle-targets/afpl_position_dirac_schwartz_operator.lean`
- the active full-`L2` generator job `864c1c0d-c6e6-485f-b657-3f6b9b6fe529`

## Required output

Return an adversarial memo and one typechecking Lean target skeleton for the
next proof job. It must state, with exact signs and composition order:

1. a momentum-Schwartz derivative of the exact flow at zero, then at arbitrary
   time if justified;
2. Fourier transport to a position-Schwartz derivative;
3. equality of that generator with the packaged position Dirac operator and
   its explicit `-I/(2*pi)` spatial normalization;
4. the exact relation, if any, to the representative-safe `L2` graph-domain
   theorem;
5. zero state plus a nonzero rest or Gaussian control.

List the missing Mathlib API for differentiating a parameterized
`SchwartzMap.bilinLeftCLM`, and provide a 30/90/240-minute fallback ladder.

## Kill and honesty conditions

- A raw Fourier symbol identity is not yet a time-evolution PDE.
- Do not infer differentiability in Schwartz topology from pointwise
  differentiability alone.
- Do not call a fixed-continuum PDE a changing-lattice continuum limit.
- Preserve Mathlib's Fourier convention and the right-multiplication generator
  orientation.
- If the all-time theorem is unsupported, scope to `t=0` and name the precise
  topology/domain gap.

The output must be concrete enough for immediate Aristotle proof submission.

## 2026-07-13 snapshot, repair, and restart

The broad audit job exceeded the two-hour stall threshold.  Its snapshot is
stored at
`AgentTasks/aristotle-output/180406b2-61c5-4d07-bf0d-43225dff2b47/in-progress-snapshot.zip`.
The snapshot returned a useful adversarial memo and an all-time pointwise
momentum-generator theorem, but it did not prove a Schwartz-topology
time derivative, a position-space PDE, or an `L2` graph-domain theorem.

The returned all-time proof did not replay in the live project because of a
type-inference mismatch in the arbitrary-time composition.  It was repaired in
`PhysicsSM/Draft/NullEdge/ExactFlowGeneratorAllTime.lean` by composing the
accepted zero-time derivative with the fixed-time multiplier, applying the
exact group law, and translating the time variable.  The repaired file passes
direct Lean replay and received independent Claude review.  Its scope remains
strictly pointwise at fixed momentum.

The stalled broad job was cancelled and the same Aristotle project was
restarted on the static Schwartz scaffolding only:
`genSymbol_hasTemperateGrowth` and `positionGenSchwartz_eq_dirac`, with a zero
state as an optional control.  The live analytic blocker remains differentiation
of the time-parameterized `SchwartzMap.bilinLeftCLM` in Schwartz topology with
uniform temperate remainder bounds.
