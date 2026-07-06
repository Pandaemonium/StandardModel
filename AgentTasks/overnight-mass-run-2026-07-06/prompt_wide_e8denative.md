Lane V (trust consolidation). De-nativize the E8-240 flagship: replace the
`n a t i v e _ d e c i d e` proof of the 240-short-vector count (and completeness)
with a KERNEL-checked proof (no Lean.ofReduceBool / Lean.trustCompiler in the
axiom audit), following the repo's NoNative pattern. Both grand-strategy audits
flagged this as the single highest-credibility trust fix (the E8 artifact is
advertised as kernel-proved but is compiler-trust).

START: read `PhysicsSM/Coding/E8ShortVectors.lean` (the current native_decide
proofs of `shortHammingE8Vector_count_eq_240` + completeness) and any existing
`NoNative` module for the pattern. Check with `lake env lean`. If broader build
stalls, SKIP.

Deliver: a kernel-checked (structural / bounded-Finset-enumeration, NO
native_decide) proof of the 240 count and completeness, such that `#print axioms`
shows ONLY `[propext, Classical.choice, Quot.sound]` (no ofReduceBool /
trustCompiler). If a full kernel enumeration is too heavy for one pass, prove the
smallest genuine structural piece and document the residual precisely - a real
narrowing, not native_decide. No new axiom / statement weakening. If lake build
stalls, SKIP; return source + the axiom-audit result.
