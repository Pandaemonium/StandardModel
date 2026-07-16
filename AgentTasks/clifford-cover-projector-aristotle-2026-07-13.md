# Clifford-cover projector Aristotle handoff (2026-07-13)

```yaml
aristotle:
  project_id: null
  task_id: null
  target_file: CliffordCoverProjector/CliffordCoverProjector.lean
  expected_module: CliffordCoverProjector.CliffordCoverProjector
  submission_project: AgentTasks/aristotle-submit/afpl-even-right-clifford-projector-20260713
  output_dir: null
  status: ready-not-submitted
```

## Objective

Eliminate all 15 proof holes in the focused standalone file without changing
any theorem statement, definition, convention, or import. Small private helper
lemmas may be added when needed. The returned target must pass:

```powershell
lake env lean CliffordCoverProjector/CliffordCoverProjector.lean
```

The source models the three-bit flavor register `State := (Fin 3 -> ZMod 2) ->
Complex`. Its left signed flips use lower occupation parity; its commuting
right signed flips use upper occupation parity. The even right bivector is
`B = I r_0 r_1`, and `projector = (1 + B) / 2`.

## Semantic priorities

1. Prove the even-right projector is an idempotent, nonprimitive rank-four
   projector on the eight-dimensional complex state space.
2. Prove it commutes with every left signed flip and with `Gamma`.
3. Prove `B` is Hermitian and involutive, then prove the projector is
   Hermitian in the stated delta-basis sense, nonzero, nonidentity, and rank 4.
   (`projector_nonzero` and `projector_nonidentity` are already derived once
   `projector_vacuum_value` is filled.)
4. Complete the no-conjugacy control: a commuting family of invertible deck
   flips cannot simultaneously be an anticommuting family after conjugation.
5. Preserve the explicit finite sign conventions and kernel-reduced `decide`
   lemmas. Do not replace results with assumptions or trusted escape hatches.

For rank, a useful route is the existing handoff: the matrix decomposes into
four disjoint two-dimensional toggle pairs, with one `+1` and one `-1`
eigenvector for `B` in each pair. An explicit basis/equivalence argument is
welcome. Do not weaken `projector_rank_four` or replace exact finrank with an
inequality.

## Required proof targets (15)

- `leftFlip_involutive`
- `rightFlip_involutive`
- `leftFlip_rightFlip_commute`
- `rightFlip_anticommute`
- `Gamma_rightFlip_anticommute`
- `B_involutive`
- `B_commutes_left`
- `B_commutes_Gamma`
- `B_hermitian`
- `projector_idempotent`
- `projector_vacuum_value`
- `projectorLinear.map_add'`
- `projectorLinear.map_smul'`
- `projector_rank_four`
- `commuting_anticommuting_family_not_invertible`

## Claim boundary

This is a finite algebraic projector and no-conjugacy result. It does **not**
prove a physical decoder, reconstruct physical states, or remove full-zone
fermion doubling. In particular, rank reduction on this finite register is not
a determinant-level no-doubling theorem for a full momentum zone.

## Acceptance checks

- All 15 proof holes are eliminated.
- No theorem statement or definition is weakened or silently changed.
- No new `a x i o m`, `o p a q u e`, `u n s a f e`, `a d m i t`, or
  `n a t i v e _ d e c i d e` is introduced.
- Only ordinary kernel-checked Lean proofs remain (standard Mathlib axioms such
  as choice/propext/quotient soundness are acceptable when induced by APIs).
- The completion report lists solved targets, any helper lemmas, statement
  changes (expected: none), remaining holes (expected: none), and axioms used.

## Submission status

Focused package repaired on 2026-07-13 by copying the standalone target
verbatim to
`CliffordCoverProjector/CliffordCoverProjector.lean`, the module path imported
by the package root. The package now contains the exact standalone definitions,
theorem statements, conventions, and 15 proof holes listed above; no statement
was weakened.

The narrow command
`lake env lean CliffordCoverProjector/CliffordCoverProjector.lean` was attempted
from the focused package and produced no diagnostics before a 30-second local
timeout. This is an inconclusive environment/startup timeout, not a reported
Lean error or a passing check.

Ready locally but not submitted. No independent fleet-slot check was completed
during this repair, so submission was deliberately skipped. No project ID or
task ID exists yet.
