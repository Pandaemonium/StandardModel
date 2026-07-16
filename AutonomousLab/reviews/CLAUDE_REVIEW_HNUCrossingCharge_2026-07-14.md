# Claude review: HNUCrossingCharge (floquet-transverse composite, refill harvest)

- Reviewer: interactive Claude (claude family), Skeptic, solo mode
- Source: Aristotle job `d82ea36b`, `HNUCrossingCharge.lean` (277) + the composite
  chain (HNUExactCore, HNUTransversePiComposite, HNUParentBoundaryCompletion,
  FloquetTransverseComposite.Core). Date: 2026-07-14

## Verdict: APPROVE (draft-trust) - with the UNSIGNED/chirality-blind scope enforced

Independently built (full 5-module bundle, retargeted imports): `lake build`
EXITCODE=0 (8030 jobs). 0 real sorry/native/axiom; 13 guards; standard-three
`[propext, Classical.choice, Quot.sound]`.

## What it proves

Composing the finite rank-one transverse selector with the exact HNU single-Weyl
micromotion yields EXACTLY ONE zero-quasienergy crossing:
- `composite_plus_one_iff`: on the cube `[-pi,pi]^3`, a nonzero `+1` eigenvector of
  `hnuPiComposite k` exists IFF `k = 0`. Via a genuine block decomposition
  (`Qsel = selector (x) 1`): the composite commutes with `Qsel`, the selected block
  carries the HNU endpoint exactly, the complement acts as `-1` everywhere (control
  `complement_block_neg_one` - no crossing off the selected block).
- `zeroCrossingSet_eq_singleton`, `zero_crossing_count`: the zero-crossing locus =
  `{0}`, cardinality `1`.
- `endpoint_axis`: along the `k0`-axis the endpoint is `cos t . 1 - i sin t . sx`
  (single-Weyl generator), trace `2 cos t`. Witness `witness_crossing_at_zero`,
  boundary control `no_crossing_at_boundary` (no crossing on `k i = pi`).

## The load-bearing scope point (verified honest)

The count is UNSIGNED / CHIRALITY-BLIND. The docstring is exemplary:
"the 'crossing charge' is an unsigned zero-quasienergy crossing count ... does NOT
certify a chiral sign / winding number: the underlying eigenvalue census is
chirality-blind (`census_chirality_blind`), so this data is consistent with EITHER
a genuinely chiral single crossing OR its mirror." Also disclaims real-space
locality, winding integer, bulk-edge, anomaly inflow, continuum tangent, domain
wall, SM. So `zero_crossing_count = 1` is a SINGLE UNSIGNED crossing - NOT a proof
of a signed single chiral Weyl. This is exactly the unsigned-vs-signed discipline;
no over-claim.

## Over-claim audit

- Vacuity: none - explicit origin witness, the `-1` complement control, the
  boundary `pi`-control.
- False shape: none - the count is genuinely 1 via the block decomposition; the
  chirality-blind caveat prevents the single-crossing from being read as signed.
- Docstring-outruns-kernel: none - the honesty boundary is stronger than the
  kernel statement.

## Program fit (closest refill result to Gate-1, but still unsigned)

This is the nearest refill result to the Gate-1 single-Weyl question: the
transverse-selector + HNU composite selects the HNU single crossing (complement
gapped at -1). But it is UNSIGNED - it counts one crossing without certifying net
chirality. So it does NOT resolve the signed-single-Weyl question that the Gate-1
half-space window-defect determination (da29672d, still running) attacks. Feeds the
single-crossing structure; must NOT be quoted as a signed single Weyl.

## Bottom line

APPROVE (draft-trust). Independently rebuilt (5-module chain), standard-three,
exemplary chirality-blind scope. Exactly one UNSIGNED zero-quasienergy crossing
from the transverse-selector + HNU composite. Manuscript may state the single
unsigned crossing; may NOT read it as a signed single chiral Weyl (chirality-blind,
consistent with a crossing or its mirror). Landing: reconcile the reproduced
HNUExactCore with the live one.
