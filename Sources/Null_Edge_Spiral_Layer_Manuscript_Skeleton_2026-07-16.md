# The spiral layer of the null-edge program: an exactly solved corner calculus

Skeleton v0.1, 2026-07-16 (claude). Status: SKELETON - section stubs,
claim-calculus table, and kernel-anchor map only; no prose beyond
abstracts of intent. Companion to (not part of) the all-mass manuscript
(`Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`); program context in
`AutonomousLab/work/SPIRAL-LAYER/CLAUDE_SPIRAL_LAYER_PROGRAM_NOTE_2026-07-16.md`.

Claim calculus: `T` source-verified theorem; `T|H` conditional on
displayed hypotheses; `M` machine-verified (program-internal); `C`
pre-registered conjecture; originality tags `[orig]/[comp]/[import]`.
Every `M` row below carries a build-enforced axiom guard
(`[propext, Classical.choice, Quot.sound]`) in the named module.

## 0. Abstract (intent)

The 1+1 checkerboard's corner factor `i*eps*m` is an input convention;
the program's founding intuition pictured chiral spirals instead. We
resolve the tension exactly at the finite level with a two-by-two
spin-coherent corner calculus: the mass MAGNITUDE is orientation-blind
and per-corner maximal on hairpins (the zigzag reading), while the
PHASE, the spin transport, and the matter/antimatter distinction live
entirely in oriented (spiral) content - and the checkerboard's `i` is
itself a theorem, the quarter-turn lune. Corner phases are half solid
angles; polygon phases decompose over fan triangles; CP-odd observables
are exactly oriented-volume functionals; smooth closure costs only
phase while kinks cost magnitude; and the framed Wilson rectangle
inherits the strong-coupling area law at unchanged string tension with
the exact hemisphere-Berry corner constant.

## 1. The corner calculus (wave 1)

Anchors: `PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean`,
`HairpinLunePhaseAristotle.lean`, `ChiralSpiralCommutatorAristotle.lean`.

- M [orig] pair bend factor `(1 + a.b)/2`; antipodal annihilation
  (exact reversals forbidden in the free channel).
- M [orig] two-channel corner sum (free + flip = 1); flip maximal at
  the hairpin. Bridge to the kinematic wedge: `GateI1.MassCoinBridge`.
- M [orig] three-cycle Bargmann invariant
  `(1 + sum dots + i triple)/4`; planar content CP-inert at three
  corners; orientation reversal = conjugation (the antiparticle
  reading).
- M [orig] hairpin lune values -1/4 and +1/4; magnitude factorizes
  into bend factors.
- M [orig] chiral rotation ladders `[D0, A_pm] = pm 2 g5 A_pm`; zitter
  double commutator at rate 2E; on-shell transverse momentum = m;
  spin-half iff zitter radius `1/(2m)`.

## 2. The corner factor is a theorem (wave 2)

Anchors: `SpinCornerFourCycleAristotle.lean`,
`ChiralSpiralMassiveAristotle.lean`, `PlanarCornerRealityAristotle.lean`.

- M [orig] exact lune-phase law
  `tr(P(z)P(u,v,0)P(-z)P(u',v',0)) = conj(u+iv)(u'+iv')/4`; the
  quarter-turn corner equals `i/4`: the checkerboard corner factor is
  DERIVED (headline theorem 1).
- M [orig] massive helix algebra: `(Dtot m)^2 = (1+m^2)`, transverse
  ladders anticommute with the full massive operator, zitter oscillator
  at exactly `2E`, massless reduction recovers wave 1.
- M [orig] all-orders planar CP-inertness (real-subalgebra closure);
  nonplanar escape witness (headline theorem 2: zigzags cannot
  CP-violate at any order).

## 3. Corner phases are solid angles (waves 3-5)

Anchors: `BargmannSolidAngleAristotle.lean`,
`BargmannCocycleAristotle.lean`, `BargmannFanInductionAristotle.lean`.

- M [orig] on Re > 0: `arg tr(PaPbPc) = arctan(triple/(1+dots))`;
  with the Van Oosterom-Strackee identity [import: IEEE TBME 1983]
  this is the signed half solid angle (triangle law).
- M [orig] cocycle law (diagonal-unit form and the strictly stronger
  matrix-slot form): cutting along a diagonal factorizes the invariant
  with a positive-real diagonal trace.
- M [orig] fan factorization + fan phase law: polygon invariants times
  interior diagonal traces equal products of fan-triangle invariants;
  polygon phases are sums of triangle half-solid-angles at every n
  (headline theorem 3). Exact nonplanar pentagon witness `(9+i)/25`.

## 4. CP-odd = oriented volume (wave 6)

Anchor: `BargmannJarlskogToyAristotle.lean`.

- M [orig] two-family Jarlskog decomposition:
  `Im(z_A conj z_B) = [triple_A(1+dots_B) - triple_B(1+dots_A)]/16` -
  every CP-odd two-family interference is a function of oriented
  volumes and CP-even dots (headline theorem 4, CKM-shaped).
- M [orig] CP/swap oddness; proper-rotation frame invariance;
  both-planar protection; one-planar witness 3/20 (a single planar
  family is NOT CP-protection - the relative phase is what counts).

## 5. Closure: smooth costs phase, kinks cost magnitude (wave 7 + T2)

Anchors: `CapSquareBerryAristotle.lean`,
`GateYM/FramedAreaLawTransfer.lean`,
`GateYM/StrongCouplingAreaLaw.lean` (landed YM1 interface).

- M [orig] cap-square family: closed invariant = `cornerAmp(t)^4`
  exactly; magnitude `((1+t^2)/2)^4`; equatorial hemisphere Berry sign
  `-1/4` as a kernel fact (cross-checked by the wave-1 hairpin value -
  same enclosed hemisphere); polar degenerate control; kink insertion
  costs exactly one corner factor with phase untouched (headline
  theorem 5).
- M [orig/comp] framed area law: a framing scalar with norm <= 1
  cannot degrade the strong-coupling area law and enters as a pure
  area-independent prefactor at the SAME string tension (the
  character-expansion factorization remains the displayed hypothesis
  of the landed YM1 interface).
- M [orig] constant runs collapse (idempotence): an `a x b`
  axis-aligned rectangle's spin factor equals the four-corner square
  factor for ALL side lengths; combined:
  `norm(framed rectangle Wilson value) <= (1/4) exp(-sigma_R A)`
  with the exact hemisphere constant (headline theorem 6).

## 6. What is NOT claimed

No continuum limit, no Lorentz recovery, no physical Yukawa/CKM/QCD
values, no claim that nature's phases are these finite geometric ones.
The four over-claim modes checklist applies to every section; each
statement above is finite, kernel-checked, and convention-pinned
(XOR-basis octonion conventions do not enter; Pauli conventions match
the wave-1 module docstrings).

## 5b. The crossover, exactly (T3; landed same day)

Anchor: `GateYM/KinkAreaCrossover.lean`.

- M [orig] the two-projector semigroup is one-dimensional:
  `(P(a)P(b))^(k+1) = ((1+a.b)/2)^k (P(a)P(b))` (unit b only); the
  k-kink penalty is exactly `(1/2)^k` times the hemisphere sign.
- M [orig] the perimeter-versus-area crossover is exact:
  `(1/2)^k <= exp(-sigma A)` iff `sigma A <= k log 2` - crossover kink
  count `k* = sigma A / log 2` (headline theorem 7).
- M [orig/comp] composed k-kinked framed rectangle bound
  `(1/2)^k (1/4) exp(-sigma_R A)` at unchanged string tension.

## 7. Open targets

- Fan-induction packaging as a single named polygon theorem citing the
  landed pieces (cosmetic).
- Two-family toy -> three-family Jarlskog with genuine rephasing
  structure (C2 successor; grade C, gate to be preregistered).
- (C1, C2, C3 gates: ALL CLOSED as of 2026-07-16 13:15.)

## Claim-anchor table (to be generated mechanically)

Every M row above maps to (module, declaration, guard line) - generate
from the claim registry rows SPIRAL-* plus the waves 5-7 rows pending
the next manager window; the table is mechanical once those land.
