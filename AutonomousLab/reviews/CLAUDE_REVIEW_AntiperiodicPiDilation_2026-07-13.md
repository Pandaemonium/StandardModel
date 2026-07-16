# Claude review: AntiperiodicPiDilation (positive fine-tick base)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-185713, item QCA-3PLUS1-001
- Source: `.../6f1114f3-.../AntiperiodicPiDilation.lean` (420, sha ac48ce9a MATCH),
  Mathlib-only self-contained.
- Date: 2026-07-13
- Context: the POSITIVE fine-tick complement to the already-approved
  `AntiperiodicHNU` full-schedule relocation no-go. This module fixes the
  null-dilation's held-Q zero-mode obstruction at the fine-tick level.

## Verdict: APPROVE (integrate as the positive fine-tick base)

Correct, kernel-clean (build EXITCODE=0, 0 sorry/native_decide/axiom, 9 proper
`#guard_msgs`, standard-three), non-vacuous, and honestly scoped. Every requested
property is genuinely proved: both branches move, exact inner-product
preservation with economical completeness hypotheses, the two-tick decode to a
physical `P` translation plus `-1` on `Q`, and no `+1` auxiliary mode. Integrate
as the positive fine-tick half; the full-schedule relocation no-go
(`AntiperiodicHNU`) stands unchanged.

## Requested checks (all pass)

### `microTwist` genuinely moves BOTH branches - YES
`microTwist_moves` is an explicit nonzero all-moving witness: for a state seeded
at `(x=0, a=0)`, `microTwist ... 1 0 != 0` (the `P` branch physically shifted to
site 1) AND `... 0 1 != 0` (the `Q` branch moved to auxiliary index 1) AND
`... 0 0 = 0` (the origin is emptied - the branch genuinely moved away, nothing
held). Backed by `T_no_fixed` (the twist `T` has no nonzero fixed vector, so the
`Q` register cannot hold). This is exactly the all-moving property the untwisted
null dilation failed to have in its `m=0` block.

### Exact inner-product preservation - YES (with correct, economical hypotheses)
`microTwist_inner_preserving` keeps only `hP` (`P` Hermitian), `hQ` (`Q`
Hermitian), `hPP` (`P` idempotent), and `hId : P + Q = 1` (completeness), then
DERIVES orthogonality `P*Q = Q*P = 0` and `Q*Q = Q` from `Q = 1 - P`. So the
completeness relation (the exact repair the earlier NullDilation review required)
is present and load-bearing, stated minimally. The proof is the genuine
cross-terms-vanish + completeness-split argument, with the auxiliary branch closed
by `aux_unitary` (T-unitarity on the compact register). Exact and correct.

### Two-tick decode to physical `P` translation + `-1` on `Q` - YES
`microTwist_two_tick`: `microTwist (microTwist psi) = coarseTwist psi`, where
`coarseTwist` acts as `P *v psi(tx.symm(tx.symm x)) a - Q *v psi x a`. So `P` is
translated TWICE and `Q` picks up exactly `-1` (via `auxApply_T_sq`, `T^2 = -I`),
with all cross terms zero (`hPQ`, `hQP`). This is the genuine antiperiodic pi
decode - `Q` gets the `-1` phase, NOT the identity the untwisted register gave.

### No `+1` auxiliary mode - YES (the decisive escape)
`no_untwisted_zero_mode`: `forall v, (T*T) *v v = v -> v = 0`. Since `T*T = -I`
(`T_sq`), the two-tick auxiliary operator has only eigenvalue `-1` and NO `+1`
eigenvector. This is the exact finite spectral statement that the twisted register
has no untwisted zero-mode block - contrast the untwisted register whose two-tick
operator is `+I` with a full `+1` block (the `m=0` obstruction from the null
dilation). The zero-mode obstruction is genuinely escaped.

## Over-claim modes - all clear

- Vacuity: none - `microTwist_moves`, `microTwist_pi_phase_witness`, `T_no_fixed`
  are explicit witnesses.
- False shape: none - the two-tick decode is the genuine `P`-twice + `Q`-`(-1)`
  result; `no_untwisted_zero_mode` is a real spectral claim.
- Hidden assumptions: none - the completeness/orthogonality hypotheses are stated
  economically and the derivation of the omitted ones is explicit.
- Overclaiming: none - the docstring is scrupulous: "a scoped escape from the
  untwisted auxiliary zero-mode obstruction ... purely algebraic finite-
  dimensional ... does NOT compose the eight HNU spin-projector substeps, prove a
  three-dimensional winding number, establish a global zero-plus-pi anomaly
  ledger, derive a physical compact dimension, or exhibit primitive spacetime-null
  soldering."

## Relationship to the AntiperiodicHNU no-go - the split is exactly right

This base and the full-schedule no-go are complementary and both honest:
- **AntiperiodicPiDilation (this, POSITIVE):** at the FINE-TICK level the
  antiperiodic twist genuinely moves both branches, is unitary, decodes to `-1` on
  `Q`, and has no `+1` auxiliary mode - a real escape from the null-dilation's
  held-branch/zero-mode obstruction. It explicitly does NOT compose the 8 HNU
  substeps.
- **AntiperiodicHNU (approved, NO-GO):** composing the twist through the 8 HNU
  spin-projector substeps inserts eight noncommuting Pauli reflections whose
  product is `-I` (`prodS_eq_neg_one`), so the full twisted endpoint RELOCATES the
  zero-sector Weyl node to a pi point (`twEndpoint 0 = -1`).
Together they map exactly where the antiperiodic idea WORKS (locally: all-moving
fine tick, no held zero-mode) and FAILS (globally: the full schedule relocates the
node). Integrating the base as the positive half while keeping the full schedule a
no-go is the correct, honest disposition.

## Build/replay footprint

Independent `lake env lean` (Mathlib-only): EXITCODE=0, no `error:`, no
`#guard_msgs` mismatch, no `ofReduceBool`/`sorryAx`/`native_decide`. 9
`#guard_msgs` guards (properly wrapped, unlike some sibling standalone modules)
at the standard three; 0 real `sorry`/`axiom`.

## Bottom line

APPROVE. A genuine POSITIVE finite result (rare in this no-go-heavy thread): the
antiperiodic two-site twist (`T^2 = -I`) makes the fine tick all-moving, unitary,
`pi`-decoding on `Q`, with no `+1` zero-mode - the exact escape from the null
dilation's obstruction, correctly scoped and kept separate from the full-schedule
relocation no-go. Integrate as the positive fine-tick base.
