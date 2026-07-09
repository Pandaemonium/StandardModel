# Strategy + proof: confinement as a positive-sector obstruction (Conjecture B)

## Context (blind to the wider repo)

A finite null-edge Dirac program works over a **Krein** (indefinite) inner product:
the raw carrier space is an indefinite information ledger; a state becomes a physical
"particle" only after imposing constraints, quotienting gauge/null directions, and
landing in a **positive** physical sector (`Pᴴ J P ≻ 0`). Not every algebraic
excitation survives this positive-sector functor.

The conjecture reframes **confinement** information-theoretically:

> **Non-singlet (colored) gauge sectors fail to admit an isolated positive mass
> sector; color-singlet sectors can.** Colored excitations are "non-decodable
> messages"; singlets are the composite codewords that survive the quotient.

So confinement is not (only) "colored states have infinite energy" — it is a **finite
positivity theorem**: the physical particle catalogue = the excitations that survive
the positive-sector functor, and color non-singlets are excluded because their
constraint-quotient/Krein data admit no positive isolated sector.

## Your task (strategy + proof)

Build the smallest explicit carrier that exhibits this, and prove it:

1. **A carrier with a color grading and a constraint (Gauss) quotient.** On a small
   Clifford⊗color space, define the closure/Krein form `J Q_C`, a color grading (the
   `SU(N)` / center label distinguishing singlet vs non-singlet), and the physical
   Gauss-sector projector (`ker Q_G / range Q_G`, as in the program's BRST setup).
2. **Non-singlet ⇒ no positive isolated sector (theorem).** Prove that the compressed
   closure form on a **colored** (non-singlet) sub-sector is **indefinite / not
   positive-definite** (it has a negative eigenvalue) — so no isolated positive mass
   there. (This is adjacent to the program's balanced-closure no-go: the closure form
   is balanced/indefinite on the physical sector for the non-singlet content.)
3. **Singlet ⇒ positive sector (theorem).** Prove that the **color-singlet**
   compression is positive-definite (aperture-dominated), so it *does* admit a
   positive isolated mass. The contrast is the confinement statement:
   `colored ⇒ indefinite (no isolated particle)`, `singlet ⇒ positive (a particle)`.

The clean win: **confinement as a finite positivity dichotomy** — only singlet
null-disagreement patterns can be made positive. State precisely what distinguishes
the singlet (which grading/quotient data make it positive), so the mechanism is a
criterion, not just one example.

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only; small explicit matrices where the sector positivity is
a finite computation. Deliver Lean file(s) + `ARISTOTLE_SUMMARY.md`: the carrier, the
colored-indefinite theorem, the singlet-positive theorem, the distinguishing
criterion, and an honest boundary (this is a finite positivity *analogue* of
confinement, not a continuum confinement proof).
