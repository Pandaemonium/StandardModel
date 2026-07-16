# Aristotle strategy-to-proof job: Schwartz generator and PDE capstone

- Work item: `CONT-FOURIER-001`
- Role: Builder / Oracle / Assassin
- Priority: P97 continuum reconstruction
- Date: 2026-07-13

```yaml
aristotle:
  project_id: 7f0c4cea-6a2b-4903-96ff-95886f9138b3
  submission_project: AgentTasks/aristotle-submit/afpl-schwartz-generator-pde-capstone-20260713-project
  output_dir: AgentTasks/aristotle-output/7f0c4cea-6a2b-4903-96ff-95886f9138b3
  status: integrated
```

## Outcome

Aristotle completed all six target theorems. Interactive Claude Code performed
the required cross-family semantic review and returned `ACCEPT`; see
`AutonomousLab/reviews/CLAUDE_REVIEW_ExactFlowSchwartzGeneratorCapstone_2026-07-13.md`.
The production module is
`PhysicsSM/Draft/NullEdge/ExactFlowSchwartzGeneratorCapstone.lean`.

The result is deliberately pointwise in momentum. It proves the exact `-i H`
time derivative and its Fourier-conjugated position-Dirac form, while recording
the missing Frechet-space differentiation API needed for a derivative in the
full Schwartz topology.

## Mission

Use the newly landed continuous Schwartz-space position Dirac operator to prove
the strongest honest generator theorem for the exact free Dirac time group.
Prefer a completed Lean module. If the Schwartz-topology differentiability API
blocks the final theorem, return a typechecking target with immutable statements,
all tractable helper lemmas proved, and the exact missing Mathlib lemma isolated.

## Required inputs

- `PhysicsSM/Draft/NullEdge/ExactFlowGenerator.lean`
- `PhysicsSM/Draft/NullEdge/ExactFlowSchwartzGroup.lean`
- `PhysicsSM/Draft/NullEdge/PositionDiracSchwartzOperator.lean`
- `PhysicsSM/Draft/NullEdge/FourierDiracSchwartzCapstone.lean`
- `PhysicsSM/Draft/NullEdge/ExactFlowL2GroupCapstone.lean`

## Target ladder

1. Prove pointwise in momentum that the derivative at time zero of
   `exactFlowSchwartzCLM m t g` is `-I` times multiplication by `H`, preserving
   all existing Fourier normalizations.
2. Lift that result to a derivative in the Schwartz topology if the available
   continuous-linear-map APIs support it.
3. Conjugate through Fourier transform and identify the position-space
   generator exactly as `-I` times `positionDiracSchwartzCLM m`.
4. State the resulting free Dirac evolution equation with its precise topology
   and domain.
5. Include zero-time, zero-state, and one nonzero exact control showing that the
   result is not a constant-orbit tautology.

## Semantic constraints

- Keep Mathlib's Fourier convention and the exact `-I/(2*pi)` position
  coefficient.
- Distinguish pointwise momentum differentiation, Schwartz-topology
  differentiation, and strong `L2` differentiation.
- Do not claim a closed self-adjoint `L2` generator, Stone's theorem, a
  changing-lattice limit, interacting dynamics, or Lorentz restoration.
- Do not weaken a topology silently. If the strongest lift is blocked, name the
  exact API/theorem needed and land the lower rung explicitly.
- Use no trust-expanding declarations or evaluator shortcuts.

## Required output

Return a concise strategy memo and a typechecking Lean file containing either
the completed capstone or a proof-ready target with a sharply isolated blocker.
Report every changed statement and the exact verification command.
