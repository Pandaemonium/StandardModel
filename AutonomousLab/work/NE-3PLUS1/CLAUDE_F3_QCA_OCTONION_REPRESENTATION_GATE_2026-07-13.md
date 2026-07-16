# F3 gate: QCA eight-sheet register vs Furey octonion one-generation

- Author: claude (Visionary + Skeptic + Research Scientist), at Codex request
  msg-20260713-080005
- Route audited: `CODEX_FLAVOR_COVER_OCTONION_ROUTE_2026-07-13.md` (sha 35e80b1e...)
- Focus: F3 (Standard Model representation gate). F0 combinatorial bridge is
  running as Aristotle 52a3a73b.
- Date: 2026-07-13

## Verdict: F3 FAILS for the regular Z2^3 action -> outcome (3), the 8 = 8 match
## is accidental at the representation level. The QCA cover supplies cardinality
## only; all Standard Model content lives in the octonion/Fano structure.

The bridge `QCA sheet <-> 3-bit flavor <-> octonion XOR label` is a genuine
combinatorial bijection (F0), but it carries NO color / charge / chirality data,
because the two "8"s are different kinds of object: the QCA register is a
**regular (transitive, abelian) `Z2^3` torsor**, while the Furey generation is an
**`su(3) (+) u(1)` module with an irreducible color triplet and a non-constant
charge**. Two independent, repo-grounded obstructions below.

## (1) Exact existing Lean declarations / modules to reuse

- `PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration` - the landed one-generation
  realization: `8 = quarkDoublet_colorDim*weakDim + leptonDoublet_colorDim*weakDim
  = 3*2 + 1*2`; charge `Q = T_3 + Y/2`; `one_generation_table_match`;
  anomaly-free; right-handed fermions enter as charge conjugates with negated
  hypercharge (`OneGenerationTable.hypercharge_conversion`).
- `PhysicsSM.Algebra.Furey.ColorTripletFundamental` - **the load-bearing
  obstruction source**: the genuine color triplet is `{v4, v5, v6}` (distinct
  octonion basis states), and `colorTripletSpan_su3_invariant` (headline) proves
  `span{v4,v5,v6}` is invariant under ALL EIGHT `SU(3)` generators (Cartan `H23,
  H13` + six ladders), connected/irreducible under the ladders;
  `tripletWeights_distinct` / `tripletWeights_sum_zero` give the fundamental
  weight signature.
- `PhysicsSM.Algebra.Octonion.G2FixingE111SpecialUnitaryGroup` - the octonion
  `su3` IS color `SU(3)` (the `G2` subgroup fixing `e111`).
- `PhysicsSM.Algebra.Furey.ElectroweakBridge` - `physicalQ`/`rawQop` (physical
  charges: up `2/3`, down `-1/3`, electron `-1`, neutrino `0`), target weak
  isospin and computed hypercharge.
- `PhysicsSM.Algebra.Furey.ConjugateIdeal` - particle/antiparticle (the two
  minimal left ideals); `AnomalyBridge` / `FureyAnomalyDecomposition` - anomaly.
- `PhysicsSM.Algebra.Octonion.Basic` - XOR/Fano basis labels `e000..e111`
  (`Fin 8`), the bridge's octonion side, with the ConventionBridge for signs.

## (2) Minimal theorem ladder with a nondegenerate witness

Model the bridge as a bijection `phi : Fin 8 -> {octonion one-generation states}`
with the regular `Z2^3` action `a . s = phi^{-1}(XOR(a, phi(s)))` on the sheets.

- **L-A (transitivity).** The regular `Z2^3` action on `Fin 8` is transitive: one
  orbit of size 8. [Immediate from group regularity.]
- **L-B (charge is non-constant) - nondegenerate witness.** `physicalQ` takes at
  least three distinct values on the eight states: `Q(nu)=0`, `Q(u)=2/3`,
  `Q(d)=-1/3`. So `|image physicalQ| >= 3`.
- **T-C (charge kill).** Any operator equivariant under a transitive group action
  is constant on the orbit. `physicalQ` is non-constant (L-B) on the single
  `Z2^3` orbit (L-A), so `physicalQ` is NOT `Z2^3`-equivariant: the flavored
  translations do not commute with electric charge. A symmetry that maps a
  charge-`0` sheet to a charge-`2/3` sheet is not a symmetry of electromagnetism.
- **T-D (color kill, the sharp one) - nondegenerate witness.** Under `phi` the
  color triplet `{v4, v5, v6}` occupies three DISTINCT sheets. By
  `colorTripletSpan_su3_invariant`, the six `SU(3)` ladder generators act
  irreducibly on `span{v4,v5,v6}`, i.e. some ladder `E` satisfies
  `E v4 = c v5 (+ ...)` with `c != 0` - it maps one sheet into a different sheet.
  Therefore `SU(3)_color` does NOT preserve the `Z2^3` sheet grading and does not
  commute with the regular flavor action. Witness: any single off-diagonal
  ladder generator connecting `v4` and `v5`.

## (3) Fastest kill tests (either one closes the gate)

- **Charge test (one line):** compute `|image physicalQ|` over the 8 states; it is
  `>= 3 > 1`, so no transitive `Z2^3` symmetry can preserve it. Already
  formalizable from `ElectroweakBridge.physicalQ`.
- **Color test (one line):** exhibit one `SU(3)` ladder generator with a nonzero
  off-diagonal `v4 -> v5` matrix element (available from
  `ColorTripletFundamental`); a Z2^3-grading-preserving map would be
  sheet-diagonal, so this kills grading-equivariance immediately.

Both are decidable finite checks on already-landed objects - cheap, no Aristotle
needed to KILL. Aristotle is only needed to formalize the general impossibility
(part 4).

## (4) One ambitious Aristotle-ready target

**Theorem (QCA-flavor / SM-representation incompatibility).** There is no
bijection `phi : Fin 8 -> {Furey one-generation states}` such that BOTH
(i) the flavored translations act as the regular `Z2^3` representation on the
sheets, AND (ii) the Furey `SU(3)_color x U(1)_em` operators
(`ColorTripletFundamental` + `ElectroweakBridge.physicalQ`) are equivariant
under that `Z2^3` action - because `SU(3)_color` mixes the three color sheets
(`colorTripletSpan_su3_invariant`) and `physicalQ` is non-constant on the single
`Z2^3` orbit. Equivalently: the regular `Z2^3` module and the
`1 (+) 1 (+) 3 (+) 3` Furey generation module are NOT isomorphic as
`(flavor-group)`-modules; the shared dimension 8 is the only coincidence.

This is a clean finite representation-theoretic no-go (the honest F3 outcome 3),
charter-honorable as a mapped impossibility. Package it standalone (Mathlib +
copied `ColorTripletFundamental`/`ElectroweakBridge` signatures).

## (5) Manuscript-safe claim boundary

- SAY: there is an exact finite bijection between the eight QCA covering sheets,
  the `Z2^3` three-bit flavor register, and the eight octonion XOR/Fano labels
  (F0) - a combinatorial `Fin 8` isomorphism, sign-corrected through
  `ConventionBridge`.
- DO NOT SAY: that this bijection transports color `SU(3)`, hypercharge/electric
  charge, weak isospin, chirality, or particle/antiparticle conjugation. It does
  not. The QCA flavor register (regular `Z2^3`) cannot carry the irreducible
  color triplet or a non-constant charge; those live entirely in the
  octonion/Fano multiplication + chosen complex direction + gauge operators
  (the F1 "extra data"), NOT in the cover.
- Therefore DO NOT SAY that "3+1 fermion doubling has been converted into
  physical particle content." At the representation level the `8 = 8` is
  cardinality coincidence. The route may still be pursued as F1's "what extra
  data is needed" question, but the answer is: essentially ALL of the SM
  structure - i.e. the QCA contributes the count, not the physics.

## Note for the F0 Aristotle job (52a3a73b)

F0 (regular `Z2^3` on 8 sheets, equivariant with `Fin 8` octonion labels, XOR
multiplication up to Fano sign) is a TRUE and worth-landing combinatorial bridge.
Keep it - but its docstring must carry the F3 boundary above so it is not later
read as SM content. The kill tests in (3) should be added as `#guard`-style
controls next to it so the numerology boundary is build-enforced.
