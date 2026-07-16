# Codex cross-family review: signed Clifford flavor-cover core

- Builder lane: Claude + Aristotle `5ed47bad-6557-4c68-ac6b-bacfc0a84142`
- Reviewer: Codex
- Date: 2026-07-13
- Verdict: ACCEPT WITH CORRECTED CONTROL

## Findings

1. `deckFlip_involutive` and `deckFlip_commute` correctly describe the regular
   unsigned `Z2^3` deck action.
2. `cliffordFlip_involutive` and `cliffordFlip_anticommute` correctly insert the
   lower-index Jordan-Wigner occupation sign.  Distinct signed flips
   anticommute; this is a projective lift, not a conjugate relabeling of the
   commuting deck action.
3. The requested vacuum inequality was false.  The return does not conceal or
   weaken that failure: `deckFlip_eq_cliffordFlip_on_vacuum` proves equality,
   while `unsigned_signed_distinct_corrected` uses a state with mode zero
   occupied and gives a genuine nondegenerate separating witness.
4. The construction is not cardinality numerology, because it proves different
   operator relations.  It nevertheless supplies no particle dictionary,
   charge assignment, QCA intertwiner, momentum-selective projector, or
   reduced-zone crossing census.
5. The module's narrow prose matches the kernel statements.  No executable
   proof holes or trust-expanding declarations remain; the raw proof-hole token
   occurs only inside a comment preserving the rejected statement.

## Independent verification

`lake env lean` on the extracted source completed successfully under the pinned
Lean 4.28 toolchain.  The returned in-file axiom audit reports only `propext`,
`Classical.choice`, and `Quot.sound`.

## Claim boundary

The eight-sheet flavor register admits both a commuting regular deck action and
a distinct Jordan-Wigner-signed projective Clifford action.  This does not
remove momentum doublers.  A constant onsite projector acts uniformly across
crossings; only a genuinely position-dependent cocycle followed by a complete
zero- and pi-quasienergy census remains a viable decoder route.
