# Claude cross-family review: FlavorCoverChargeObstruction (+ guard)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (formalizing the F3 charge kill from my QCA-octonion audit)
- Source: `PhysicsSM/Draft/NullEdge/FlavorCoverChargeObstruction.lean` (101 lines,
  sha 340fca88...) + `...FlavorCoverChargeObstructionAxiomGuard.lean` (24 lines,
  sha 8cbb30f7...)
- Date: 2026-07-13

## Verdict: ACCEPT

A faithful, correctly-scoped Lean formalization of the charge obstruction (my
F3 "T-C charge kill"): a scalar invariant under the regular (transitive) deck
action is constant, and an explicit nonconstant 6+2 hypercharge labeling is
therefore not deck-invariant.

## Checks

- **Algebraic direction - correct.** `deckInvariant_forces_constant`: from
  `DeckInvariant q` (`forall g x, q (g+x) = q x`), instantiate `g := y - x` to get
  `q ((y-x)+x) = q x`, i.e. `q y = q x`. This is exactly transitivity of the
  regular action forcing constancy. `leftDoubletHypercharge_not_deckInvariant`
  then contradicts nonconstancy. Direction and logic sound.
- **6+2 cardinality - correct and decide-checked.** `leptonSheets` (`x0=0 && x1=0`,
  `x2` free) has card 2 (`leptonSheets_card`, `decide`); the complement has card 6
  (`quarkSheets_card`, `decide`). Matches the left-handed one-generation doublet
  state count: 6 quark-doublet states (u,d) x 3 colors + 2 lepton-doublet states
  (nu, e).
- **Convention match - correct.** Lepton-doublet hypercharge `-1` and
  quark-doublet hypercharge `1/3` are the standard `Q = T_3 + Y/2` assignments
  (`Q(nu)=0, Q(e)=-1`; `Q(u)=2/3, Q(d)=-1/3`), matching
  `StandardModel.OneGenerationTable`. The labeling is presented as "an explicit
  6+2 labeling" (a representative nonconstant witness), not as a canonical
  bit-to-particle map - which is the honest framing, since the argument needs
  only SOME nonconstant SM-shaped labeling.
- **Vacuity / hollow-telescoping - clean.** Concrete witnesses (`leptonWitness =
  (0,0,0)`, `quarkWitness = (1,0,0)`) with `-1 != 1/3`; decide-checked
  cardinalities. Non-vacuous. Not hollow: it is the intended cheap kill test,
  presented as exactly that (a necessary obstruction, not a full no-go).
- **Physics inference scope - correctly scoped (the key point).** The docstring
  states it kills ONLY "the bare identification of QCA cover sheets with charged
  SM states when physical translations act as naked regular sheet permutations,"
  and explicitly exempts "gauge-twisted translation, a decoded/quotient charge,
  or physical breaking of the full deck symmetry." This matches my F3 audit
  scope precisely and does not overclaim a general no-go.
- **Axiom footprint / guard.** The guard pins `leptonSheets_card`,
  `quarkSheets_card`, and the headline
  `leftDoubletHypercharge_not_deckInvariant` at `[propext, Classical.choice,
  Quot.sound]`. The cardinalities use `decide` (kernel-checked, no
  `ofReduceBool`), so the footprint is genuinely standard-three. Build:
  `lake build ...FlavorCoverChargeObstructionAxiomGuard` exit 0 (8027 jobs),
  guards fired.

## Minor (optional)

The main-module file could also carry an inline guard on
`deckInvariant_forces_constant` (the general lemma) for uniformity; currently only
the guard file pins the three witnesses/headline. Non-blocking.

## Narrowest defensible claim

For the regular additive `(ZMod 2)^3` deck action on the eight flavor-cover
sheets, any scalar label commuting with every deck translation is constant;
hence the explicit nonconstant 6+2 hypercharge-shaped labeling (`-1` on two
sheets, `1/3` on six) is not deck-invariant. Physically: cover sheets cannot
carry nonconstant Standard Model charges while all naked regular deck
translations remain symmetries. It does NOT constrain gauge-twisted translations,
decoded/quotient charges, or theories where the deck symmetry is physically
broken.
