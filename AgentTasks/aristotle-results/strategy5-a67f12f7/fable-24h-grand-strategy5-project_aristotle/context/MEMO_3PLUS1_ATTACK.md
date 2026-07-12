# Memo: what it takes to crack strict 3+1

Fable, 2026-07-11 (24h run, T+6h). Program-level; shared with Codex
(B-lane owner). Everything below uses the program claim discipline:
statements marked KNOWN cite kernel-checked results; VERIFY marks a
literature fact that must be full-text-checked before any manuscript
use; the rest is strategy.

## 1. The problem, stated exactly

Exhibit a strictly local (finite-range Laurent symbol), exactly unitary,
translation-invariant discrete-time update on a 3+1 lattice with finite
internal dimension whose quasienergy spectrum has exactly one Dirac
point --- an involutory unit-speed Dirac tangent at the origin --- and
no other +-1-quasienergy crossings anywhere in the zone, at either
quasienergy 0 or pi.

OR prove that no such update exists in a stated architecture class: a
discrete-time Nielsen-Ninomiya theorem.

Either outcome is field-changing for the discrete-spacetime and QCA
communities. The second is the one the evidence favors.

## 2. What we already know (the fence, all kernel-checked)

The obstruction suite pins every cheap exit:

- **Complete crossing classification** (all-zone determinant
  factorization, `det(U^4 -+ 1) = 4 P_{0,pi}`; `FullBlochZeroClassification`,
  `FullBlochSplitPlus/Minus`): for the successive-axis family, 0- and
  pi-quasienergy modes occur exactly where all three momentum cosines
  vanish simultaneously. The three even-parity corner aliases are exact,
  and the 0/pi Floquet pairing is explicit --- pseudo-doublers (Gupta-Short
  language) are tracked, not ignored.
- **All-coins alias theorem** (`eq:genericcorneralias`): in the
  four-channel, range-one, single-factor-per-axis architecture, NO
  momentum-independent onsite coin removes any even-parity alias. Onsite
  data is not an exit.
- **Stationary-amplitude no-go** (`StationaryAmplitudeNoGo`): no
  degree-one nearest-neighbor factor supports a stay-put amplitude
  compatible with origin normalization, exact unitarity, and the full
  involutory Dirac tangent. Consequently (kernel corollary) the
  Gupta-Short stay-put family --- the only published doubler- and
  pseudo-doubler-free walks --- necessarily has a NON-involutory tangent,
  and their own Appendix F concedes residual Weyl-like states.
- **Body-center kill**: the massive body-center step retains +-1
  eigenmodes at every mass angle; that regulator never opens a global
  Floquet gap.
- **Temporal blocking**: exact two-step blocking closes only the mass
  subgroup; composition-order effects are exact. Blocking does not
  manufacture new exits.
- **B-lane invariant state** (Codex): Laurent-unit theorem, additive
  flow exponent, exact Fourier determinant phase law --- and the decisive
  negative: the determinant (U(1)-level) flow is BLIND on the live
  stationary-amplitude witness (zero flow, nonidentity). The abelian
  invariant does not decide the problem.

The fence teaches: every surviving exit changes the architecture ---
larger internal cell, longer range, coupled non-separable substeps,
non-cubic lattice, or abandoning the involutory tangent (the Gupta-Short
price).

## 3. The crux: one missing mathematical object

Everything reduces to one question:

> **Is there an integer-valued, exactly computable, per-crossing local
> charge for finite-range unitary Bloch symbols, additive over
> crossings, whose zone-total must vanish, and which a genuine
> involutory Dirac tangent forces to be nonzero?**

If yes, the no-go follows by pure bookkeeping: total = 0, single Dirac
point contributes +-1 (per chirality), so a compensating crossing must
exist somewhere in the zone at quasienergy 0 or pi --- i.e. a doubler or
pseudo-doubler. This is the discrete-time, Floquet-aware analogue of
Nielsen-Ninomiya part I, and the topological heuristic (periodicity of
the zone torus; local Chern charge of an isolated band crossing) says it
should exist. The published landscape is consistent with it: Gupta-Short
evade doubling exactly by dropping the involutory tangent --- precisely
the hypothesis the charge argument needs.

Why it is not already a theorem here:

1. The known 1D machinery (GNVW flow index for quantum walks/QCA ---
   VERIFY exact statement and scope before manuscript use) is a K_1-type
   winding; 3D needs the next boundary map down (Chern-type charge on
   spheres around crossings). Degree/Chern theory is not in Mathlib in
   usable form; a Lean-first route must reformulate the charge as exact
   algebra.
2. The determinant phase law is exactly the abelian shadow of this
   charge, and Codex's live witness proves the shadow is blind. The
   nonabelian layer is genuinely new work, not bookkeeping.

## 4. The exact-algebra formulation to aim at (route A, the no-go)

- **A1 (local charge, algebraically).** For a Laurent symbol `U(k)` with
  an isolated +-1 crossing at `k0`, define the charge as an algebraic
  residue/degree: the local degree at `k0` of the map built from the
  adjugate of `U(k) -+ 1` restricted to the crossing eigenspace (2x2
  Weyl block after jet reduction), computed via resultants -- no
  integrals, no homotopy. Bezout-style local degrees of polynomial maps
  are finite algebra and Lean-plausible. Gate: the definition must
  reproduce, by exact computation, charge +-1 on the four crossings of
  our own cubic walk and charge totals 0.
- **A2 (sum-zero).** For Laurent symbols, det(U -+ 1)-type objects are
  Laurent polynomials whose zero sets carry global degree fixed by the
  monomial determinant (Laurent-unit theorem is exactly the right
  input). Sum of local degrees = global degree = 0 by periodicity.
  This is a polynomial identity family, not analysis.
- **A3 (tangent forces charge).** An involutory unit-speed Dirac tangent
  at the crossing is a nondegeneracy statement at the jet level; it
  forces the 2x2 crossing block to have nonzero local degree. Finite
  linear algebra.
- **A4 (assembly + class statement).** Single-cone hypothesis + A1-A3
  give the contradiction. The theorem's value scales with the class:
  minimum publishable = the separable and bounded-range classes our
  no-gos already live in; field-changing = all finite-range,
  finite-cell, translation-invariant exactly-unitary updates.
- **Kill condition for route A:** if the A1 charge computes to zero on
  our own cubic-walk crossings (blind, like the determinant flow), the
  residue formulation is wrong or the invariant does not exist at this
  level; pivot weight to route B and to a sharper invariant design.

## 5. Route B (the construction), run in parallel as scouting + kill-tests

- **B1. Tetrahedral full-Bloch audit** (open problem 3). Compute the
  tetrahedral walk's complete blocked-cell Bloch symbol and run the SAME
  exact crossing census we ran for the cubic family. Outcome either
  kills "the obstruction is cubic-specific" or exhibits the evading
  lattice.
- **B2. Pavia Weyl/Dirac automaton audit.** The D'Ariano-Perinotti
  school derives Weyl automata on non-primitive lattices (VERIFY: their
  published all-zone spectrum claims, not just the small-k limit). Run
  our exact census on their symbol. If it is genuinely single-cone with
  an involutory tangent, route A is dead and the field already has the
  construction (unlikely --- else Gupta-Short 2026 would not present
  stay-put as the frontier); if not, we have a new exact statement about
  a published automaton (same genre as the Gupta-Short corollary).
- **B3. Systematic exact sweep.** Our alias criteria are polynomial
  conditions on symbol coefficients. Parametrize unitary Laurent symbols
  with internal cell <= 8 and range <= 2 (with the derived Pluecker coin
  retained), impose origin normalization + full Dirac tangent + the
  exact no-other-crossing conditions, and run exact elimination /
  SOS-certificate search per architecture cell. Every candidate that
  survives the oracle gets the kernel-level determinant census. A
  nonempty survivor set kills route A and IS the paper; a proven-empty
  bounded-class sweep is itself a publishable exhaustive no-go ("no
  strict single-cone walk with cell <= 8, range <= 2"), and feeds A4's
  class statement.

## 5b. Route C (user-proposed, 2026-07-11): embrace the doublers

The reframe: stop treating the extra species as a disease of the free
walk; treat the free-level doublers as physical and ask the
INTERACTION - a chirality-flipping coupling read from the derived field
z, i.e. exactly a frozen Higgs-Yukawa datum - to gap the partners in
the full path sum.

Where this sits in the known landscape (all VERIFY before manuscript
use): (i) it is the Wilson mechanism read as a path sum - in the
hopping expansion a Wilson term is precisely a per-step
chirality-flip amplitude that grows toward the zone boundary, marrying
the doublers off with momentum-dependent mass; (ii) it is the
minimally-doubled program's philosophy (Karsten-Wilczek/Borici-Creutz
keep two species and call them a flavor doublet; graphene realizes two
physical Dirac valleys - embracing doubling IS standard condensed
matter); (iii) its chiral-gauge version is the symmetric mass
generation / mirror-fermion-decoupling program (Eichten-Preskill
lineage) - the genuinely open frontier, because Nielsen-Ninomiya's
sting is not the extra species but their OPPOSITE chirality
assignments: naive embracing vectorizes the weak interaction, so the
partners must be gapped, not just accepted, and gapping them without
breaking the chiral symmetry explicitly is the hard part.  The
adversarial literature for this route is in our graph with full text:
Golterman-Shamir, "Propagator zeros and lattice chiral gauge theories"
(arXiv:2311.12790) and "Constraints on the symmetric mass generation
paradigm for lattice chiral gauge theories" (arXiv:2505.20436) - C3/C4
must be designed against their constraint arguments, and any Route C
manuscript sentence needs their exact statements checked first (the
constraints they prove are the professional version of the C3 kill
condition). (iv) Our own
checkerboard layer already IS the proposed object: the formalized
history sum carries chirality flips weighted z / conj z per corner -
"every trajectory, flipping chirality through a Higgs-like coupling"
is literally `ComplexPlueckerCheckerboardPathSum` with the derived
Pluecker field as the frozen Higgs.

**The finite laboratory result (this run, oracle-exact, gated).** On
the 4-site ring, the free two-particle lift carries TEN exact +-1
modes: six at momentum K=0 and four at K=2 - and K=2 on a 4-ring is
momentum pi, the doubler sector. Composing with the local pair kick
(the derived interaction at the 3-4-5 fixture) leaves exactly SIX +-1
modes: at the factor-multiset level the interaction removed precisely
the pi-momentum quartet and kept the K=0 modes. That is
interaction-induced doubler gapping, computed exactly, in flight for
kernel formalization (boundstate + momentum jobs).
Eigenvector-level check (run 2026-07-11, exact): the surviving +-1
kernels have dimensions 4 and 2 as the factorization requires, but they
are momentum-HYBRIDIZED - K-weights mix K=0 and K=2 (one surviving -1
vector is even purely K=2), consistent with [V, T2] /= 0. So the
mechanism is reshuffle-and-gap, not sector deletion: the multiset
statement ("four fewer +-1 modes, trade matching the K=2 quartet") is
exact; the naive "the kick deletes the pi-sector modes" is FALSE at
eigenvector level and must never be written. This sharpens C3: the
right bookkeeping is which CHIRAL content survives, not which momentum
label.

**Route C plan.**
- C1 (cheap, now): the eigenvector-level identification above; then
  the same experiment with the kick strength as the dial (the
  threshold alpha-sweep from the boundstate seed already shows level
  extraction onset between 0.3 and 0.8) - "how much Higgs does it take
  to gap the doublers" as an exact finite curve.
- C2: one-particle version with a POSITION-space chirality-flip layer
  driven by z(x) (the variable-field walk exists:
  `VariablePlueckerLocalWalk`); measure the alias modes' fate exactly.
- C3: the chirality bookkeeping test - the honest kill condition for
  the whole route: compute the gauge/chirality assignment of the
  gapped vs surviving modes. If gapping the partners requires the
  flip coupling to transform WRONGLY under the would-be chiral gauge
  action (the Nielsen-Ninomiya sting), record it as the exact finite
  incarnation of the SMG obstruction - itself a publishable sharp
  statement.
- C4 (the prize, hard): a finite SMG-style theorem - conditions on a
  z-driven interaction under which the composed walk's low-energy
  sector has HALF the free chiral content with the chiral symmetry
  intact. Even a fixture-level instance with controls would be new.

Route C does not compete with route A: A concerns the FREE involutory
walk (and stands - our free-level fence is untouched); C concedes
free-level doubling and moves the burden to the interacting theory,
which is where the field's open chiral-gauge problem actually lives.

## 6. Milestones, owners, gates

- **M1 (days; oracle-first).** B1 + B2 audits and the B3 sweep
  infrastructure. Owner: Fable oracles + Aristotle census jobs. Gate:
  each audit produces an exact crossing table with kernel-checkable
  certificates.
- **M2 (the crux; 1-2 weeks).** A1/A2 designed and validated by exact
  computation on three named symbols: the cubic walk (expect charges
  +-1, total 0), the Gupta-Short family (expect the non-involutory
  tangent to zero out the forced charge --- consistency), and Codex's
  live zero-flow witness (the invariant MUST separate it; that is the
  acceptance test the determinant flow failed). Owner: joint; the
  scoping is submitted to Aristotle as a strategy job now.
- **M3 (Lean warm-up; parallel).** The 1+1 discrete-time doubling
  theorem, kernel-checked: for finite-range 1D walks, a single
  nondegenerate +-1 crossing with involutory tangent is impossible ---
  the GNVW-flow shadow of A1-A4, entirely within reach of current
  machinery (winding of the chiral-block determinant is exact Laurent
  algebra; the B-lane phase law is the main lemma). Publishable on its
  own; de-risks every A-step.
- **M4.** The 3+1 theorem in the largest class M2 supports, or the B3
  construction, with the loser direction recorded as the other paper's
  boundary section.

## 7. What is NOT needed

- No continuum analysis: every step above is finite algebra on Laurent
  symbols. The continuum limit machinery already exists and only enters
  after M4.
- No new physics assumptions: the hypotheses are locality, unitarity,
  translation invariance, finite cell, and the tangent condition ---
  all already formalized objects in this repo.
- No reliance on Nielsen-Ninomiya itself: the action-based theorem
  neither implies nor is implied by the discrete-time statement (scope
  row now in Paper A); we inherit its topology heuristic, not its proof.

## 8. Immediate actions taken with this memo

1. Strategy job (Aristotle) submitted: design the A1 residue-form local
   charge + A2 sum-zero at the level of exact algebra, with the
   three-symbol validation protocol of M2 and the live-witness
   separation as the acceptance test.
2. B1/B2/B3 queued behind the current fleet (census, momentum,
   boundstate, restop, halfcharge2 have priority through tonight's
   freeze); first B-milestone oracles scheduled for the post-audit
   window unless the user re-prioritizes.
3. This memo cross-referenced from the ledger and the gate matrix
   B-row (Codex owns the B-lane; A1-A4 design review is joint).
