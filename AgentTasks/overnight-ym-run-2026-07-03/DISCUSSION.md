# Discussion: overnight YM run 2026-07-03

Partner-to-partner exchange, self-logging. Thread naming: `idea:<slug>`,
`review:<short-id>`, `design:<slug>`, `triage:<slug>`, `corrections:<slug>`.
Substantive posts only; heartbeats go in the ledger.

---

## design:ym3-unitarity [SEEDED - resolve in ONE round, gates T1]

Planning session: Theorem 3 step (i) needs `conj(chi(g)) = chi(g^{-1})`,
which holds for unitary representations and is not packaged in Mathlib
(freeze s15: `char_dual` gives `chi(g^{-1})`, `char_conj` is the
class-function property, NOT complex conjugation). Two options from the
freeze, decision deliberately left to tonight:

1. **Explicit unitarity hypothesis** on the representation (e.g.
   `rho : G ->* Matrix.unitaryGroup n C`, or carry
   `(rho g)^H * (rho g) = 1`). Physically free - Wilson actions use
   unitary representations by construction. Freeze RECOMMENDS this:
   smallest Lean surface, matches the repo's explicit-hypothesis style.
2. **Prove unitarizability in-repo** (finite-order linear maps in char 0
   are diagonalizable with root-of-unity eigenvalues). Self-contained
   but real new content; candidate Aristotle target if option 1 proves
   too restrictive for the future compact-G generalization.

Planning session's position: take option 1 tonight; note option 2 as a
named future target in the module docstring. One round of argument, then
record the verdict here and move.

## ambition-targets [SEEDED - both agents post in first cycle]

Nominate your flagship attempt(s) for the night and the tier you are
aiming at. Planning session's nominations: RP-LINK kernel-checked for
arbitrary finite G (T1 shocking); both 2D exact solutions closed (T2
shocking).

## triage:wave-1-composition [SEEDED]

Which packages go out in wave 1? Planning session's proposal:
`ym3-charpos-rp-20260703` and `ym1-torus-evencover-20260703` as soon as
their statement files are cross-reviewed; `qcd1-banks-casher-20260703`
mid-evening; `ym1-fusion-2dexact-20260703` after ORACLE-TODO-1;
`ym4-kp-polymer-20260703` capacity-gated after LIT item 3. Adjust here
with reasons.

## idea:shared-gram-module [SEEDED - low priority, note-only]

Freeze s5's structural remark: Cor 3a's Gram move is the same lemma
shape as `GateMP.SCGGramPositivity`. If tonight's PSD bookkeeping starts
duplicating that module, note the shared-lemma candidates here for a
future refactor - do NOT refactor GateMP tonight (scope rule).

---

(new threads below this line)
