# A decoded-code route to 3+1 null dynamics

Date: 2026-07-13
Role: Visionary / Skeptic / Research Scientist
Status: proposed architecture with an algebraic handoff; not a completed 3+1 construction

## Executive claim

The current 3+1 obstruction may be aimed at the wrong target. We have been
asking a finite, translation-invariant regulator to contain exactly one
physical Dirac species over its entire Brillouin zone. A continuum theory does
not require that. It requires a specified physical encoding whose decoded
evolution converges to the Dirac flow, together with a theorem that regulator
sectors do not contaminate physical observables.

The proposed architecture therefore has three layers:

1. an exactly unitary microscopic walk with strict null one-step support;
2. an invariant rank-four decoded sector carrying the massive Dirac algebra;
3. a sampling or constraint gate that separates this sector from ultraviolet
   aliases and controls leakage once interactions are added.

This relaxes the assumption that physical states form the whole unconstrained
Bloch bundle. It does not relax exact microscopic unitarity or null support.

## Why the obvious routes fail

- The minimal range-one four-channel walk retains exact high-frequency copies.
- A Wilson term removes spatial zeros by breaking the relevant chiral symmetry,
  but exact unitary Floquet packaging retains a conjugate zero/pi partner.
- A momentum-independent projector on a naked regular eight-sheet cover acts
  uniformly on momentum aliases; it cannot distinguish the desired cone.
- The eight regular sheets cannot simultaneously be interpreted as a Standard
  Model multiplet with nonconstant charges while deck transformations act
  transitively.

These are scoped results. None rules out a decoded sector whose locality lives
in the microscopic evolution and observables rather than in an ultralocal
spectral projector.

## Algebraic ingredient: a projective Clifford cover

Use the eight states of a three-bit cover as the basis of
`Lambda*(C^3)`. Bare bit flips commute. Jordan-Wigner-signed flips anticommute
and realize the left Clifford action. This signed action is not a basis change
of the bare cover: conjugation preserves commutators. It is a genuinely
projective deck action, equivalently a fermionic two-cocycle or pi closure
holonomy.

The corrected onsite projector is not rank two and is not primitive. Let
`c_j` be the three left signed flips, `r_j` the commuting right signed flips,
and `Gamma` the parity/mass grading. An even right bivector

    B = i r_0 r_1

can satisfy `B^2 = 1` and commute with every `c_j` and with `Gamma`. Hence

    P = (1 + B) / 2

is the candidate rank-four nonprimitive projector. The immediate finite target
is to prove idempotence, Hermiticity, nontriviality, rank four, and all four
commutation relations. This is only an onsite algebraic decoder. It does not
yet remove a Brillouin-zone copy.

Draft handoff:
`AgentTasks/aristotle-standalone/clifford-cover-projector-20260713/CliffordCoverProjector.lean`.

## Preferred physical interpretation: decoded sub-Nyquist sector

Let `E_a` sample continuum states whose Fourier support lies in a fixed compact
physical window strictly inside the reciprocal Nyquist boundary. Let `D_a`
decode lattice states back to the continuum. The finite walk `U_a` may contain
ultraviolet aliases outside that window. The required theorem is instead

    sup_(|t| <= T) ||D_a U_a^[t/a] E_a psi - exp(-it H_D) psi|| -> 0

for a stated regularity class, plus an invariance or leakage estimate for the
encoded subspace.

For the free translation-invariant theory, momentum conservation can make the
sub-Nyquist code exactly invariant. For variable coefficients or interactions,
exact invariance is generally too strong; the honest successor is a quantitative
bound on leakage into the regulator sector.

This route does not claim that copies are absent. It claims they are not in the
physical code and become inaccessible in the scaling limit. That distinction
must remain explicit in manuscript prose.

## Why corner-only cohomology is not enough

A tempting BRST/Koszul construction makes the seven nonorigin zero/pi corners
exact while retaining cohomology at the origin. This is a useful finite kill
test but not a solution by itself. A physical Dirac particle requires a
four-dimensional band over a neighborhood of low momentum, not only four
states at one point. A local analytic differential that has cohomology on an
open momentum neighborhood and nowhere else faces a much stronger rank and
locality problem.

Any cohomological proposal must therefore prove all of the following:

- rank-four positive cohomology throughout a low-momentum window;
- a local cochain evolution inducing the Dirac transfer on that cohomology;
- no physical local observable coupling to exact alias states;
- a uniform continuum and interaction-leakage bound.

Without those items, `gauge-exact doubler` is only a renamed deletion.

## Alternative escape: changing null frames

A second lateral route drops fixed microscopic translation invariance. Alternate
between distinct decorated null frames, or use an aperiodic but controlled frame
schedule. Every microstep remains exactly unitary and null-supported, while the
fixed Brillouin torus used by the doubling argument no longer exists. The
continuum tangent must average to the isotropic Dirac symbol.

The smallest decisive fixture is a short periodic schedule of two or more null
frames. Compute its exact Floquet spectrum and kill the route if any unwanted
zero/pi crossing survives with order-one overlap with the decoded sector. A
positive finite fixture would still require a changing-lattice continuum proof;
absence of a common alias at a few corners is not sufficient.

## Proof ladder

### D1. Even-right projector

Prove the rank-four onsite theorem for `P`, including Hermiticity and explicit
nonzero/nonidentity witnesses. Also retain the no-conjugacy theorem separating
signed Clifford flips from bare commuting deck flips.

### D2. Twisted local intertwiner

Construct a cocycle-twisted local unitary `U_tw(q)` and prove

    P U_tw(q) = U_tw(q) P

for every momentum. Prove exact unitarity and strict null position-space
support. If no such walk exists in the proposed range/channel class, return the
missing-hypothesis or no-go theorem rather than weakening the target.

### D3. Full-zone census

Compute every zero and pi quasienergy crossing of the compressed walk. The
route fails if `P` merely moves or duplicates the unwanted cones.

### D4. Encoded continuum theorem

Define `E_a` and `D_a` explicitly and compose the existing fixed-momentum and
bulk/tail estimates into a changing-lattice convergence theorem for the
rank-four decoded sector.

### D5. Interaction leakage

For a local many-fermion interaction `V_a`, prove either exact code invariance
or a bound of the form

    ||(1 - P_code) exp(-it(H_a + V_a)) P_code|| <= epsilon(a,T),

with `epsilon(a,T) -> 0` on the claimed regime. This is the gate that turns a
free sampling convention into a physical superselection claim.

## Fast kill conditions

1. `P` fails to commute with the mass/parity generator.
2. No cocycle-twisted finite-range unitary intertwines `P` while preserving null
   support.
3. The compressed full-zone spectrum retains an undeclared zero/pi cone.
4. The decoder is nonlocal in a way that makes local observables couple at
   order one to regulator sectors.
5. Interactions generate order-one leakage at fixed physical time as the
   spacing tends to zero.
6. The changing-frame alternative has a common alias or fails the isotropic
   Dirac tangent.

## Current assessment

This is a plausible new attack, not a resolution. Its advantage is conceptual
precision: it separates microscopic null locality, algebraic spinor decoding,
and continuum sector selection instead of demanding one finite Bloch matrix do
all three jobs. D1 is ready for Aristotle. D2 and D3 are the decisive
construction-or-kill pair. D4 can reuse the existing continuum machinery. D5
is the price of claiming a physical theory rather than a free regulator model.
