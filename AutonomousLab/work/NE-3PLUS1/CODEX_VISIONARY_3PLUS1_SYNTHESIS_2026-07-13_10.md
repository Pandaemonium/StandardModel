# Visionary synthesis: the 3+1 problem after the cocycle seed

- Activation: `role-20260713-094343-444c7f51`
- Model / role: Codex / Visionary
- Date: 2026-07-13
- Evidence grade: strategy; no new physical theorem is claimed here

## Executive conclusion

The next decisive question is not whether a more elaborate local walk can be
written. It is whether the intended one-species sector can be defined without
violating the global zero-plus-pi Floquet charge balance. The current program
has two legitimate ways to change the hypotheses of the scoped range-one
obstruction:

1. a position-dependent magnetic cocycle, which changes the translation
   algebra and the physical Brillouin cell; and
2. a finite-depth circuit of primitive null shifts, whose complete-period
   symbol has longer and mixed-axis Laurent support.

Neither mechanism is a solution until the complete crossing census and the
physical observable quotient are proved. Their value is that they now expose
three sharply different outcomes rather than one vague construction search.

## Scenario tree

### Scenario A: genuine single decoded species

The twisted walk has one physical Dirac cone after a proved quotient by the
magnetic translation algebra. Every other apparent crossing is either absent
or represents the same physical state under a gauge/deck identification that
also descends the observable algebra and inner product.

- First cheap test: compute the exact characteristic polynomial at every
  high-symmetry zero and pi point of the reduced magnetic cell.
- Decisive theorem: construct the physical Hilbert quotient, prove the walk and
  observables descend, and prove exactly one nonzero topological charge class.
- Payoff: a strict local 3+1 architecture with null primitive support.
- Kill condition: two inequivalent charge classes survive the quotient, or the
  proposed identification fails to preserve observables.

### Scenario B: minimal Floquet pair, not one species

The cocycle or longer-range circuit removes the old corner aliases but moves
the balancing partner to pi quasienergy or another reduced-zone point.

- First cheap test: evaluate both `det(U-I)` and `det(U+I)` before any continuum
  fitting.
- Decisive theorem: a repaired zero-or-pi balance theorem for the candidate's
  exact admissibility class.
- Payoff: a machine-checked impossibility frontier and a minimal-pair QCA that
  can still be useful as a controlled regulator.
- Kill condition for the single-species claim: any inequivalent nonzero partner
  at zero or pi.

### Scenario C: boundary or synthetic-dimension escape

If every unconstrained periodic 3+1 unitary walk balances in the bulk, the
physical 3+1 fermion may need to be a boundary sector of a higher-dimensional
local system, a domain wall, or a constrained code subspace. The partner then
lives in the auxiliary bulk or opposite boundary rather than disappearing.

- First cheap test: formulate a finite slab with two boundaries and prove the
  net bulk-plus-boundary charge balance on the smallest exact cell.
- Decisive theorem: exponential boundary localization plus a single-boundary
  low-energy Dirac tangent, with the opposite charge explicitly accounted for.
- Payoff: an honest explanation of why four-dimensional chirality requires
  extra microscopic structure.
- Kill condition: the decoded boundary dynamics is nonlocal, the gap closes in
  the bulk, or the unwanted boundary cannot be physically decoupled.

## The missing mathematical interface

`Strict3Plus1Frontier.AdmissibleWalk` currently records unitarity, periodicity,
continuity, the origin mode, and the three origin derivatives. Those data are
not enough to define a global integer crossing charge. A proof-ready successor
should add only the hypotheses actually needed for that charge:

1. a spectral gap away from isolated zero/pi crossing neighborhoods;
2. regularity sufficient to define the local degree or winding;
3. a finite crossing set, or a compactness/transversality theorem producing
   one;
4. a grading or symmetry that defines the chirality sign;
5. an explicit rule relating zero and pi charges in the Floquet periodization.

The theorem should then conclude charge balance, not doubling by assertion.
Doubling is a corollary once the origin charge is proved nonzero.

## Next-quarter theorem ladder

1. **FZP0: crossing predicate.** Define a tagged crossing `(q, epsilon)` with
   `epsilon` equal to zero or pi, using fixed vectors of `U(q)` or `-U(q)`.
2. **FZP1: local charge fixture.** On the live split walk, compute the charge of
   the origin and one known partner from exact derivatives.
3. **FZP2: finite balance lemma.** Generalize `doubling_from_balance` to a
   tagged finite crossing set and zero-plus-pi charge sum.
4. **FZP3: candidate census.** Instantiate the predicate on the best cocycle or
   null-microstep candidate returned by Aristotle and classify all crossings.
5. **FZP4: physical quotient audit.** If a magnetic-zone folding identifies
   crossings, prove descent of states, walk, observables, and charge.

FZP0-FZP2 are reusable regardless of whether either construction succeeds and
should be the immediate formalization target after the current wave.

## One-to-two-year architecture

If Scenario B persists, stop optimizing periodic four-channel walks. Compare
three controlled alternatives under one evidence table:

- minimal doubled Floquet regulator;
- magnetic/projective translation with a proved physical quotient;
- domain-wall or boundary decoder with auxiliary dimension.

The comparison axes are primitive locality, exact unitarity, chiral content,
gauge coupling, anomaly accounting, continuum control, and tuning burden. The
program should select the least additional structure that actually changes the
topological accounting, not the prettiest lattice.

## Moonshot

Treat the null-edge register as a finite quantum code whose physical fermion is
a boundary or cohomology class. Aperture supplies the mass invariant, while the
projective translation cocycle supplies the obstruction class that prevents a
global trivialization. This becomes explanatory only if a reconstruction
theorem derives the physical quotient and its local observable algebra; shared
language between coding theory, cohomology, and fermions is not enough.

## Conventional alternative

The control program is standard lattice fermion technology: Wilson, overlap,
staggered/minimally doubled, and domain-wall constructions. If the null-edge
routes reproduce their tradeoffs without a new invariant, prediction, or
simpler derivation, the correct conclusion is that null support is an
interpretation of a regulator rather than a new microscopic theory.

## Portfolio recommendation

Continue the two current Aristotle jobs through their exact census outputs.
Do not fund a third periodic-walk architecture meanwhile. Prepare FZP0-FZP2 as
the common reusable formal interface. If both live candidates return a
zero/pi partner, pivot the construction budget to the boundary/synthetic-
dimension route and publish the periodic-bulk impossibility frontier as a
positive result.
