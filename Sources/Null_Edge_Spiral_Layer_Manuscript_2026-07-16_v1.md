# The spiral layer of the null-edge program: an exactly solved corner calculus

Draft v1, 2026-07-16 (claude, from skeleton v0.1 of the same day).
Status: complete prose draft for Director review; every mathematical
claim is kernel-checked in the named Lean module with a build-enforced
axiom guard pinning `[propext, Classical.choice, Quot.sound]`, and the
claim-anchor table at the end maps each claim to its declaration.
Companion to (not part of) the all-mass manuscript
(`Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`).

Claim calculus: `T` source-verified theorem; `T|H` conditional on
displayed hypotheses; `M` machine-verified (program-internal); `C`
pre-registered conjecture; originality tags `[orig]/[comp]/[import]`.

## 0. Abstract

In the exactly solved 1+1 checkerboard model, mass enters through
direction reversals weighted by `i*eps*m`: the corner factor `i` is an
input convention, and the picture of massive propagation is a zigzag.
The founding intuition of the null-edge program pictured something
else: null edges winding in chiral spirals. This paper resolves the
tension exactly, at the finite level, with a two-by-two spin-coherent
corner calculus over raw direction triples. The resolution is not a
victory for either picture but a precise division of labor:

- the mass MAGNITUDE is orientation-blind and per-corner maximal on
  exact reversals - the zigzag reading is correct about where
  magnitude lives;
- the PHASE, the spin transport, and the matter/antimatter distinction
  live entirely in oriented content - the spiral reading is correct
  about where orientation physics lives;
- and the checkerboard's `i` itself stops being an input: it is a
  theorem, the quarter-turn lune phase.

Concretely, we prove: corner phases are signed half solid angles;
polygon phases decompose exactly over fan triangles at every order;
CP-odd two-family observables are exactly oriented-volume functionals
(a CKM-shaped decomposition), with planar content CP-inert at all
orders; smooth closure of a history costs only phase while kinks cost
magnitude, with an exact perimeter-versus-area crossover; and a framed
Wilson rectangle inherits the strong-coupling area law at unchanged
string tension with an exact hemisphere-Berry corner constant. Every
statement is finite, kernel-checked, and convention-pinned. No
continuum limit is claimed.

## 1. The question and the objects

**The question.** Does mass zig-zag, or spiral? The 1+1 checkerboard
says: amplitudes `(i*eps*m)^(number of reversals)` - mass counts
corners, and the only geometry is back-and-forth. The program's
founding picture says: null edges wind around the propagation axis,
and mass is the winding. Both cannot be the whole story in 3+1, and at
the finite level neither needs to be conjectural: the question can be
asked of an exactly solvable corner calculus and answered by the
kernel.

**The objects.** A corner is a change of null direction. To a raw
direction triple `a` (no normalization built in) associate the
spin-coherent corner matrix

    P(a) = (1 + a . sigma) / 2

on two-component spinors. A history is an ordered product of corner
matrices; its invariant is the trace. Unit-length directions make
`P(a)` a rank-one projector; the calculus below is polynomial in the
direction components wherever possible, with unit hypotheses displayed
exactly where they are used and nowhere else. Conventions (Pauli
matrices, right-handed triple product `a.(b x c)`, trace normalization)
are pinned in the module docstrings of the anchors; the XOR-basis
octonion conventions of the wider program do not enter this layer.

## 2. The corner calculus (wave 1)

Anchors: `PhysicsSM/Spinor/SpinCornerBargmann.lean` (PROMOTED to the
trusted tree 2026-07-16), `HairpinLunePhaseAristotle.lean`,
`ChiralSpiralCommutatorAristotle.lean` (`PhysicsSM/Draft/NullEdge/`).

**M [orig] Pair bend factor and antipodal annihilation.** The
two-corner invariant is `tr(P(a)P(b)) = (1 + a.b)/2`; for unit `a`,
`P(a)P(-a) = 0`. Free (same-helicity) transport prefers gentle bends
and cannot reverse exactly: it curves, it cannot hairpin.

**M [orig] Two-channel corner sum.** For every pair,
`tr(P(a)P(b)) + tr(P(a)P(-b)) = 1`: unity splits into a free channel
`(1 + a.b)/2` and a flip channel `(1 - a.b)/2`, the flip maximal at the
exact reversal. The flip channel is the mass channel; the parent
repository's `GateI1.MassCoinBridge` ties its amplitude to the
kinematic wedge (geometric mass = coupling mass), which is where this
layer plugs into the mass program.

**M [orig] Three-cycle Bargmann invariant.** For any three directions,

    tr(P(a)P(b)P(c)) = [(1 + a.b + b.c + c.a) + i a.(b x c)] / 4.

The imaginary part is one quarter of the oriented volume - the ONLY
T-odd scalar at three corners. Coplanar triples have real invariant;
reversing the order conjugates the invariant (the CPT/antiparticle
reading); the coordinate octant realizes `(1 + i)/4` and its mirror
`(1 - i)/4`.

**M [orig] Hairpin lune values.** Resolving a pair of hairpins through
opposite meridians gives trace `-1/4`; the same-meridian backtrack
gives `+1/4`; the magnitude factorizes into the two right-angle bend
factors. The sign is pure enclosed geometry: `i^2 = -1` for two
checkerboard corners, as a kernel fact.

**M [orig] Chiral rotation ladders.** In the finite chiral-basis Dirac
avatar at unit momentum, `[D0, A_pm] = pm 2 g5 A_pm`: each Weyl
sector's transverse velocity is a rotation ladder whose sense is its
chirality. The zitter double commutator runs at rate `2E`; on-shell
transverse momentum equals the mass (boost-independent); the orbital
condition `L = 1/2` holds iff the zitter radius is `1/(2m)`.

## 3. The corner factor is a theorem (wave 2)

Anchors: `SpinCornerFourCycleAristotle.lean`,
`ChiralSpiralMassiveAristotle.lean`, `PlanarCornerRealityAristotle.lean`.

**Headline theorem 1 (M [orig]): the checkerboard `i` is derived.**
The exact lune-phase law

    tr(P(z) P(u,v,0) P(-z) P(u',v',0)) = conj(u + i v) (u' + i v') / 4

evaluates a hairpin pair resolved through arbitrary meridians; the
quarter-turn corner equals exactly `i/4`. The 1+1 corner factor `i` is
the quarter-turn lune phase - an output of the geometry, not an input
convention. The wave-1 values `-1/4` and `+1/4` are recovered as the
half-turn and zero-turn endpoints.

**M [orig] Massive helix algebra.** With the mass coupling switched
on: `(Dtot(m))^2 = (1 + m^2) * 1` on shell; the transverse ladders
anticommute with the full massive operator; the massive rotation
decomposes as the free rotation plus `m` times the counter-rotator
coupling; the zitter oscillator runs at exactly `2E`
(`[Dtot,[Dtot,A_pm]] = 4(1+m^2) A_pm`); and `m = 0` recovers wave 1.
The mass term is exactly the coupling between the two counter-rotating
spirals.

**Headline theorem 2 (M [orig]): zigzags cannot CP-violate at any
order.** Every history whose directions lie in a common plane has REAL
invariant, at every length (real-subalgebra closure plus list
induction), with a nonplanar escape witness `1/4` showing the
hypothesis is needed. Spiraling is necessary for CP-odd phases in this
calculus.

## 4. Corner phases are solid angles (waves 3-5)

Anchors: `BargmannSolidAngleAristotle.lean`,
`BargmannCocycleAristotle.lean`, `BargmannFanInductionAristotle.lean`.

**M [orig] Triangle law.** On the domain `Re > 0`,

    arg tr(P(a)P(b)P(c)) = arctan( a.(b x c) / (1 + a.b + b.c + c.a) ).

By the Van Oosterom-Strackee formula [import: standard spherical
trigonometry, IEEE TBME 1983] the right side is the signed HALF SOLID
ANGLE of the spherical triangle - the corner phase is geometric phase,
exactly, with the octant checking `pi/4 = (1/2)(pi/2)`.

**M [orig] Cocycle law.** For unit diagonal directions `a, c` (and, in
the strictly stronger matrix-slot form, ARBITRARY matrices in the other
two slots),

    tr(PaXPc) tr(PaPcY) = tr(PaXPcY) tr(PaPc):

cutting a history along a diagonal factorizes the invariant, and the
diagonal pair trace `(1 + a.c)/2` is a nonnegative real - it
contributes no phase.

**Headline theorem 3 (M [orig]): polygon phases decompose over fan
triangles at every order.** By induction on the rim (the fan
factorization), a polygon invariant times its interior diagonal traces
equals the product of its fan-triangle invariants; under nondegenerate
diagonals the polygon PHASE equals the phase of the product of triangle
invariants - i.e., a sum of kernel-checked half solid angles. The
nonplanar pentagon with apex `e_z` and rim `(e_x, (3/5,0,4/5),
(0,3/5,4/5), e_y)` evaluates to exactly `(9 + i)/25`.

## 5. CP-odd = oriented volume (wave 6)

Anchor: `BargmannJarlskogToyAristotle.lean`.

**Headline theorem 4 (M [orig]): the two-family Jarlskog
decomposition.** For two three-corner families A and B, the CP-odd
interference observable is exactly

    Im(z_A conj z_B) = [ triple_A (1 + dots_B) - triple_B (1 + dots_A) ] / 16,

fully polynomial with no unit hypotheses: every CP-odd two-family
interference is a function of the two oriented volumes and the CP-even
dot sums - the CKM shape. It is odd under family swap and under CP
(reversing both corner orders), invariant under a common proper
rotation (only relative geometry enters), protected when BOTH families
are planar, and nonzero for one spiraling family against one planar
family (exact witness `3/20`): a single planar family is NOT
CP-protection; the relative phase is what counts.

A design note (with a decisive numeric preflight) records why the
rephasing analogy requires INTERLEAVED mixed traces for a three-family
extension: family-internal invariants are rigid-rotation-inert. The
three-family Jarlskog is grade `C`, gate to be preregistered.

## 6. Closure: smooth costs phase, kinks cost magnitude (wave 7)

Anchors: `CapSquareBerryAristotle.lean`,
`GateYM/FramedAreaLawTransfer.lean`, `GateYM/KinkAreaCrossover.lean`,
with the landed YM1 `GateYM/StrongCouplingAreaLaw.lean` interface.

**Headline theorem 5 (M [orig]): the closure dichotomy.** Along the
cap-square family of smooth spherical squares, the closed four-corner
invariant is `cornerAmp(t)^4` exactly, with magnitude `((1+t^2)/2)^4`
and the equatorial hemisphere Berry sign `-1/4` as a kernel fact
(cross-checked against the wave-1 hairpin value: same enclosed
hemisphere). Inserting a kink costs exactly one corner factor with the
phase untouched. Smooth deformation moves PHASE; kinks pay MAGNITUDE.

**Headline theorem 6 (M [orig/comp]): the framed area law.** A framing
scalar of norm at most one cannot degrade the strong-coupling area law
and enters as a pure area-independent prefactor at the SAME string
tension (the character-expansion factorization remains the displayed
hypothesis of the landed YM1 interface). Constant runs collapse by
idempotence, so an `a x b` axis-aligned rectangle's spin factor equals
the four-corner square factor for ALL side lengths; combined,

    |framed rectangle Wilson value| <= (1/4) exp(-sigma_R A)

with the exact hemisphere constant `1/4`.

**Headline theorem 7 (M [orig]): the crossover, exactly.** The
two-projector semigroup is one-dimensional:
`(P(a)P(b))^(k+1) = ((1+a.b)/2)^k (P(a)P(b))` (unit `b` only), so the
k-kink penalty is exactly `(1/2)^k` times the hemisphere sign, and

    (1/2)^k <= exp(-sigma A)  iff  sigma A <= k log 2:

the perimeter-versus-area crossover happens at kink count
`k* = sigma A / log 2`. The composed k-kinked framed rectangle obeys
`(1/2)^k (1/4) exp(-sigma_R A)` at unchanged string tension.

## 7. The answer, assembled

| Quantity | Zigzag (planar) content | Spiral (handed) content |
| --- | --- | --- |
| mass magnitude (det/invariant level) | insensitive | insensitive |
| per-corner mass amplitude | maximal (hairpin; wedge law) | suppressed by `(1-a.b)/2 < max` |
| free-leg transport | forbidden to reverse | generic (gentle bends) |
| corner phase | `i` per corner DERIVED (quarter-turn lune) | half solid angle, any polygon |
| spin | no transverse structure to carry it | rotation ladder, sense = chirality |
| CP-odd invariants | none, at any order (theorem) | oriented-volume functionals (CKM-shaped) |
| antiparticle | sign bookkeeping | orientation reversal = conjugation |
| closure cost | magnitude (kinks; `(1/2)^k`, crossover at `k*`) | phase (Berry/holonomy; hemisphere `-1/4`) |

Mass zig-zags; its phase, spin, and matter/antimatter orientation
spiral. The checkerboard is the planar shadow in which only the
hairpins survive - and even its famous `i` was the spiral speaking.

## 8. What is NOT claimed

No continuum limit, no Lorentz recovery, no prediction of any physical
Yukawa, CKM, or QCD value, and no claim that nature's phases are these
finite geometric ones. The framed area law is conditional on the
displayed character-expansion hypothesis of the YM1 interface (`T|H`
posture at the physics-facing level even though each Lean statement is
`M`). Each section was reviewed against the four over-claim modes
(vacuity - every hypothesis carries an explicit witness; hollow
telescoping; docstring-outruns-kernel; false shape). The spin-coherent
calculus is standard quantum-mechanical geometric-phase material
(Bargmann invariants; clean-room from Schroedinger zitterbewegung, the
Penrose zigzag picture, Hestenes zitter kinematics as reading, and
standard spin-1/2 geometric phase); the corner-history REPACKAGING and
every named theorem shape above are program-original.

## 9. Claim-anchor table

Modules under `PhysicsSM/Draft/NullEdge/` unless marked TRUSTED (`PhysicsSM/Spinor/`); every declaration
carries an in-file `#guard_msgs`/`#print axioms` pin to
`[propext, Classical.choice, Quot.sound]`.

| # | Claim | Module | Key declarations |
|---|---|---|---|
| 1 | pair bend, annihilation, channels | Spinor/SpinCornerBargmann (TRUSTED) | pair_trace, antipodal_annihilation, corner_channel_sum |
| 2 | three-cycle invariant, CP readings | Spinor/SpinCornerBargmann (TRUSTED) | bargmann_three_cycle, bargmann_im, planar_cp_inert, reversal_conj, witness_handed/mirror |
| 3 | hairpin lune values | HairpinLunePhaseAristotle | hairpin_pair_trace, backtrack_pair_trace, hairpin_magnitude |
| 4 | chiral ladders, zitter, dictionary | ChiralSpiralCommutatorAristotle | comm_D0_APlus/AMinus, zitter_double_comm_*, transverse_momentum_sq_eq_mass_sq, spin_half_iff_zitter_radius |
| 5 | HT1: corner i derived | SpinCornerFourCycleAristotle | hairpin_lune_phase (four_cycle), quarter_turn_corner |
| 6 | massive helix, 2E | ChiralSpiralMassiveAristotle | Dtot_sq, comm decompositions, massive_zitter_double_comm_*, massless_reduction |
| 7 | HT2: all-orders planar CP-inertness | PlanarCornerRealityAristotle | planar_history_trace_real, nonplanar_escape_witness |
| 8 | triangle solid-angle law | BargmannSolidAngleAristotle | bargmann_arg_eq_arctan (+octant/planar/reversal) |
| 9 | cocycle (diagonal + matrix slot) | BargmannCocycleAristotle | bargmann_cocycle, bargmann_cocycle_arg, *_general |
| 10 | HT3: fan factorization + phases | BargmannFanInductionAristotle | proj_collapse, bargmann_cocycle_matrix, fan_factorization, fan_arg, pentagon_witness |
| 11 | HT4: Jarlskog decomposition | BargmannJarlskogToyAristotle | jarlskog_decomposition, _antisymm, _cp_odd, _rotation_invariant, _both_planar, jarlskog_witness |
| 12 | HT5: cap-square closure dichotomy | CapSquareBerryAristotle | cap_square_invariant, cap_square_normSq, equator_square_invariant, pole_square_invariant, kink_insertion_penalty |
| 13 | HT6: framed area law | GateYM/FramedAreaLawTransfer | framed_wilson_area_law(+_sharp,_strict), proj_pow_collapse, rectangle_sequence_collapse |
| 14 | HT7: exact crossover | GateYM/KinkAreaCrossover | pair_pow_collapse, kinked_square_trace, kink_dominance_iff, kinked_framed_rectangle_area_law |

Registry rows: SPIRAL-CORNER-CALCULUS, SPIRAL-CHIRAL-ROTATION,
SPIRAL-CORNER-I-DERIVED, SPIRAL-PLANAR-CP-INERT,
SPIRAL-TRIANGLE-SOLID-ANGLE, SPIRAL-POLYGON-SOLID-ANGLE,
SPIRAL-CP-JARLSKOG-TOY, SPIRAL-BERRY-CLOSURE, SPIRAL-FRAMED-AREA-LAW,
SPIRAL-COCYCLE-GENERAL (`AutonomousLab/state/CLAIMS.json`, all
anchor-confirmed by the second family on 2026-07-16).
