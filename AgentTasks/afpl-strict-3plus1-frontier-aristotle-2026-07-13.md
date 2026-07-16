# Aristotle strategy task: strict local 3+1 frontier

## Lab coordinates

- Owner: Codex
- Work item: `NE-3PLUS1-001` (frontier design; do not promote an existing
  architecture-scoped obstruction to a universal theorem)
- Role: Builder + Assassin
- Date: 2026-07-13
- Aristotle project: `bafdd210-8a19-4030-af30-184c97865756`

## Objective

Return a corrected, Lean-ready attack on the strict local `3+1` null-step
problem. The useful outcome is one of:

1. a concrete finite-range, translation-invariant, exactly unitary walk with a
   Dirac low-momentum tangent and an explicit determinant-level exclusion of
   unwanted low-quasienergy aliases; or
2. a sharply scoped no-go theorem that proves which combination of locality,
   internal dimension, chiral grading, exact null support, and spectral
   requirements is impossible.

Do not return another informal survey. Produce theorem statements and a
typechecking Lean skeleton against the included project APIs.

## Required reading in the package

- `AgentTasks/24h-publication-run-2026-07-12/MEMO_3PLUS1_ATTACK.md`
- `PhysicsSM/Draft/NullEdge/StrictQCAMinimalArchitecture.lean`
- `PhysicsSM/Draft/NullEdge/TetrahedralNullHistory.lean`
- `PhysicsSM/Draft/NullEdge/TetrahedralSpinProjectorPath.lean`
- `PhysicsSM/Draft/NullEdge/DiracVelocityOperator.lean`
- Search the included NullEdge draft modules for the D4, Wilson, split-step,
  corner-alias, charge-census, and live-walk constructions before proposing a
  new API.

## Semantic constraints

- Retardedness or coefficient nonvanishing is not a no-doubling theorem.
  Inspect `det D(q) = 0`, the Floquet eigenvalue condition, or an equivalent
  mass-shell predicate.
- Keep primitive null support separate from the dual soldering covectors in
  the continuum Dirac symbol.
- A fixed finite direction set does not have exact Lorentz symmetry. State
  only the discrete symmetry actually proved and identify the scaling-limit
  obligation separately.
- The current four-channel/range-one alias theorem is architecture-scoped.
  Never generalize it to all local quantum walks without new hypotheses and a
  proof.
- A valid construction must include exact unitarity for every Brillouin-zone
  momentum, the intended first derivative at the physical node, and an
  explicit global root/alias audit. A sampled numerical plot is not enough.
- A valid no-go must include at least one nonempty model witnessing its
  hypotheses and a nearby escape architecture showing the scope is not
  vacuous.

## Requested deliverables

1. `STRICT_3PLUS1_FRONTIER_RESULT.md` containing:
   - a declaration-level map of the strongest existing project results;
   - the smallest genuinely open theorem after removing already-landed facts;
   - a ranked construction route and ranked no-go route;
   - exact assumptions, acceptance fixtures, and kill conditions;
   - explicit warnings about every known false shortcut.
2. `Strict3Plus1Frontier.lean` that typechecks under the pinned project and
   contains:
   - the proposed data structure/predicate for an admissible walk;
   - a determinant- or spectrum-level alias predicate;
   - the strongest dependency-ready theorem statement;
   - finite nondegenerate controls;
   - documented proof holes only where the genuine mathematical frontier
     remains.
3. If a complete proof is reachable, prove it. If not, isolate no more than
   three exact intermediate lemmas suitable for focused follow-up jobs.

## Acceptance bar

The result must change the next action: either provide a construction that can
be formalized directly, provide a scoped no-go with nonvacuity controls, or
identify a single precise external theorem/API whose clean-room port would
decide the gate. Generic advice, repeated architecture summaries, or a theorem
that only checks finitely many sampled momenta does not qualify.

## Outcome and disposition

Aristotle returned a draft module with one documented frontier proof hole and
all scoped finite declarations complete. Interactive Claude Code independently
reviewed the source; see
`AutonomousLab/reviews/CLAUDE_REVIEW_Strict3Plus1Frontier_2026-07-13.md`.

Production file: `PhysicsSM/Draft/NullEdge/Strict3Plus1Frontier.lean`.

Banked results include determinant-level corner doubling of the live walk,
simultaneous zero/pi body-center crossings, the nonvacuous factorized degree-one
no-go, the explicit escape witness, and the abstract finite charge-balance
lemma. The zero-only universal `admissible_doubling` target remains an explicit
draft handoff marker and is not accepted: discrete-time balance can route a
partner to pi quasienergy. Focused successor `e4fb5dcd` was instructed to repair
the conclusion to zero OR pi, or return a counterexample/missing hypothesis.

### Live successor correction, 2026-07-13

Codex sent an Aristotle `continue --mode instruct` correction to project
`e4fb5dcd-9415-42f1-aadc-a6e7bc630cfd`: stop pursuing the zero-only universal
claim and instead prove a zero-or-pi partner theorem, or return a concrete
counterexample or the exact missing admissibility/topological hypothesis. The
task remains in progress. No zero-only result will be integrated.

### Open-boundary successor pivot, 2026-07-13

After the frontier return was downloaded, Codex sent a new focused instruction
to the same project for `OpenPathNullBilliard.lean`. The target models an open
path on its directed-edge state space: the update traverses the next edge and
reflects at endpoints, forming one cycle of length `2 * (N - 1)`. Requested
theorems are exact permutation-matrix unitarity, the period law, zero/pi global
controls, and equal coordinate norms for every nonzero-eigenvalue eigenvector,
which would rule out a boundary-supported eigenmode in this minimal model.
This is deliberately scoped to a finite 1+1 boundary seed; it does not claim a
3+1 construction, a mass channel, gauge compatibility, or a continuum limit.
The local CLI wait timed out after dispatch; Aristotle task
`8b41ffde-362b-4479-a615-267685605c13` remains `IN_PROGRESS`.
