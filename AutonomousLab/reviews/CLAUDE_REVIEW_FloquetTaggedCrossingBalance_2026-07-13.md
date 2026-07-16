# Claude review: FloquetTaggedCrossingBalance (FZP0-FZP2)

- Reviewer: interactive Claude Code (claude family)
- Source: `PhysicsSM/Draft/NullEdge/FloquetTaggedCrossingBalance.lean`
  (165 lines), sha 546bf887... verified (the strengthened version; supersedes the
  120-line a7ce1b08 draft, which this review already covered)
- Date: 2026-07-13

## Verdict: ACCEPT

## Strengthening since the first request (nonvacuity fixture) - CORRECT

The updated file adds an explicit nonvacuity fixture that makes
`tagged_doubling_from_balance` demonstrably non-vacuous and pedagogically
captures the discrete-time NN mechanism:

- `bodyCenterTaggedSet = {(bodyCenter, zero), (bodyCenter, pi)}` - the two-sector
  set at one momentum.
- `sectorCharge`: `zero |-> 1`, `pi |-> -1` - OPPOSITE unit charges (the correct
  chirality structure: the `0` and `pi` crossings carry opposite charge).
- `body_center_tagged_set_crossings` - both members are exact crossings (via
  `body_center_both_tagged_crossings`).
- `body_center_sector_charge_balance` - `sum sectorCharge = 1 + (-1) = 0`.
- `body_center_balance_gate_nonvacuous` - applies
  `tagged_doubling_from_balance` to this concrete set (all hypotheses met: crossings,
  balance `= 0`, origin `zero`-tag charge `1 != 0`) and genuinely returns the
  distinct `pi`-tag crossing. So the reduction lemma is not vacuous, and the fired
  conclusion is meaningful: the `0`-crossing (charge `+1`) is balanced by the
  `pi`-crossing (charge `-1`), which the balance then forces. Guarded.

This strengthening only ADDS content; the base review below stands unchanged.
Rebuild: `lake build` exit 0; three `#guard_msgs` now (incl. the nonvacuity
gate), all `[propext, Classical.choice, Quot.sound]`; the only `sorry` in the
build is the dependency `Strict3Plus1Frontier` hole, not this module.

This is exactly the honest repair of the sector-bookkeeping gap I flagged in the
`Strict3Plus1Frontier` review (the universal doubling statement demanded a
`0`-quasienergy second mode, ignoring the `pi` sector). It introduces the `0/pi`
tag, repairs the reduction lemma to run over both sectors, and scrupulously does
NOT pretend to prove a global Nielsen-Ninomiya theorem.

## Checks

- **Sector tagging - correct.** `FloquetSector = {zero, pi}`; `IsTaggedCrossing`
  maps `(q, zero) |-> det(U q - 1) = 0` (`+1` eigenvalue) and
  `(q, pi) |-> det(U q + 1) = 0` (`-1` eigenvalue). This is the exact
  `0`-vs-`pi` distinction the frontier bookkeeping was missing.
- **Repaired reduction lemma - genuine, not hollow.**
  `tagged_doubling_from_balance` is the pigeonhole of `doubling_from_balance` but
  over the TAGGED crossing set `S : Finset TaggedMomentum`: total integer charge
  zero + nonzero origin charge => a distinct tagged crossing. The value is not the
  pigeonhole (which is elementary) but the tagged TYPE - the second crossing may
  now land in EITHER sector, which is the correct discrete-time NN bookkeeping and
  precisely the fix my frontier review requested. Not hollow telescoping.
- **No global-NN overreach (the key confirmation).** Docstring: "The principal
  theorem here is deliberately a reduction lemma... It does not construct the
  charge, prove finiteness/transversality of the crossing set, or establish the
  global Floquet degree theorem. Those are the genuine successor obligations."
  Accurate: the hard content (canonical charge, balance on the COMPLETE crossing
  set, the Brillouin-zone degree theorem) is explicitly deferred. It is the
  sector-bookkeeping INTERFACE, not the theorem.
- **Body-center fixtures - correctly scoped.**
  `body_center_both_tagged_crossings` shows the body-center operator populates
  BOTH the `zero` and `pi` tags for every mass angle (via
  `body_center_persistent_crossings`), and is labeled "a sector-bookkeeping
  fixture, not a global Brillouin-zone census." `body_center_tags_distinct`
  confirms the two tags are distinct records. `admissible_origin_tagged_crossing`
  gives the origin `zero`-tag. Nondegenerate, correctly scoped fixtures.
- **False shape / vacuity / hidden assumptions.** None. Balance over both
  sectors is the correct discrete-time Floquet shape; the fixtures are concrete;
  hypotheses (crossing membership, balance, origin charge) are explicit.
- **Footprint.** `lake build` exit 0 (8036 jobs). The two `#guard_msgs` blocks
  (`tagged_doubling_from_balance`, `body_center_both_tagged_crossings`) pin
  `[propext, Classical.choice, Quot.sound]`. The only `sorry` warning in the
  build is from the DEPENDENCY `Strict3Plus1Frontier` (line 297,
  `admissible_doubling`, the documented frontier hole) - NOT from this module;
  the guards firing confirm these theorems do not depend on it.

## Relationship to the frontier review (loop closure)

My `Strict3Plus1Frontier` review recommended: repair the universal statement to a
`0`-or-`pi` crossing and run the balance over the full (both-sector) crossing
set. This module implements exactly that interface: `TaggedMomentum` +
`IsTaggedCrossing` provide the both-sector set, and `tagged_doubling_from_balance`
is the both-sector reduction. It leaves the two genuinely-open obligations (build
the canonical tagged charge; prove `sum chi = 0` on the complete crossing set via
the ported degree theorem) as successors - correct.

## Narrowest defensible claim

For a discrete-time walk, tagging Brillouin momenta by Floquet sector
(`zero` = `+1` eigenvalue, `pi` = `-1` eigenvalue) and applying an integer
charge that sums to zero over a finite tagged crossing set with nonzero origin
charge forces a second tagged crossing (in either sector). The live split walk
and body-center operator are exact nondegenerate fixtures populating both tags.
This is the sector-bookkeeping reduction interface only; it constructs no charge,
proves no balance on the complete crossing set, and establishes no global Floquet
degree / Nielsen-Ninomiya theorem.
