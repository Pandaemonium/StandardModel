# The spiral layer: does mass zig-zag or spiral? (program note)

Author: claude / research_scientist. Date: 2026-07-16.
Status: program note for the requested work item SPIRAL-LAYER-001 (codex
manager pass asked 2026-07-16, msg-20260716-062012). Everything here is
either a landed kernel-checked result (named declaration), a running
pre-registered target (job ID), or labeled interpretation/conjecture. No
continuum claim is made anywhere in this note.

## 1. The question

The Research Director's founding intuition for the program pictured null
edges forming chiral SPIRALS; the exactly solved 1+1 layer (checkerboard)
instead runs on ZIG-ZAGS (direction reversals weighted i*eps*m). The
question, sharpened over the 2026-07-14 and 2026-07-16 sessions: which
picture does the formal core actually support, is most mass zigzag or
spiral, and what is the breakdown?

## 2. The three-layer answer

**Layer 1 - the mass INVARIANT is orientation-blind.** det P depends only
on unordered pairwise wedge areas (A-PLUECKER-MASS-AREA); no orientation or
handedness enters. At the invariant layer "zigzag vs spiral" is not even a
well-posed question: the mass MAGNITUDE cannot distinguish them. Any
breakdown of mass magnitude is by CHANNEL (turn/Yukawa vs closure/QCD in
the four-channel budget of the all-mass manuscript), not by path shape.

**Layer 2 - the AMPLITUDE calculus has two corner species with OPPOSITE
angular preferences.** Landed wave-1 results (all kernel-checked,
standard-three guards, integrated 2026-07-14/16):

- Free (same-helicity) continuation weight (1 + a.b)/2:
  `SpinCornerCore.pair_trace`; exact reversals are FORBIDDEN -
  `antipodal_annihilation` (P(a)P(-a) = 0 for unit a). Free transport
  prefers gentle bends: it curves, it cannot hairpin.
- Flip (mass) channel weight (1 - a.b)/2, maximal AT the hairpin:
  `corner_channel_sum` splits unity into the two channels; the parent
  repo's `GateI1.MassCoinBridge.onshell_wedge_normSq_eq_coin_sq` ties the
  flip amplitude to the kinematic wedge (geometric mass = coupling mass).
- So a generic massive 3+1 history is forced into the composite shape
  "spiraling free legs punctuated by hairpin mass flips": the zigzag and
  the spiral are BOTH there, in different roles. The 1+1 checkerboard is
  the planar shadow in which only the hairpins survive.

**Layer 3 - orientation (the spiral's own quantum number) lives in the
PHASE, the SPIN, and CP - not in the mass magnitude.** Landed wave-1:

- The Bargmann three-cycle `bargmann_three_cycle` with
  `bargmann_im`: Im tr(P(a)P(b)P(c)) = a.(b x c)/4 - the oriented volume
  is the ONLY T-odd scalar at three corners; `planar_cp_inert`: planar
  content has real invariant; `reversal_conj`: orientation reversal =
  complex conjugation (the CPT/antiparticle reading);
  witnesses (1 +- i)/4.
- The hairpin-pair lune witnesses `HairpinLuneCore.hairpin_pair_trace`
  (-1/4, antipodal meridians = closed great circle) vs
  `backtrack_pair_trace` (+1/4, zero lune), with
  `hairpin_magnitude` factoring the magnitude into the two bend factors:
  the SIGN is pure enclosed geometry - i^2 = -1 for two checkerboard
  corners, as a kernel fact.
- The chiral-spiral commutators `ChiralSpiralCore.comm_D0_APlus/AMinus`
  ([D0, A_pm] = pm 2 g5 A_pm: each Weyl sector's transverse velocity is a
  rotation ladder with sense = chirality), `zitter_double_comm_*` (rate
  2E), `mass_comm_g5_odd` + `mass_comm_ne_zero` (the mass term is exactly
  the coupling between the two counter-rotating spirals), and the helix
  dictionary `transverse_momentum_sq_eq_mass_sq` (transverse momentum = m,
  boost-independent) + `spin_half_iff_zitter_radius` (L = 1/2 iff
  r = 1/(2m)).

Interpretation (no chip): the original chiral-spiral vision is correct
about WHERE orientation physics lives - spin transport, T/CP-odd phases,
the antiparticle conjugation - while the zigzag is correct about where the
mass MAGNITUDE per corner is maximized. "Mass zig-zags; its phase, spin,
and matter/antimatter orientation spiral."

## 3. The breakdown table

| Quantity | Zigzag (planar) content | Spiral (handed) content |
| --- | --- | --- |
| mass magnitude det P | insensitive (orientation-blind) | insensitive |
| per-corner mass amplitude | maximal (hairpin, wedge law) | suppressed by (1-a.b)/2 < max |
| free-leg transport | forbidden to reverse | generic (gentle bends, curvature) |
| corner phase | i per corner as INPUT (1+1) | i = quarter-turn lune, DERIVED (wave 2A target; witnesses landed) |
| spin | cannot carry it (no transverse structure) | rotation ladder, sense = chirality [landed] |
| T/CP-odd invariants | none at 3 corners [landed]; none at any order (wave 2C target) | Im = oriented volume [landed] |
| antiparticle | sign flip only | orientation reversal = conjugation [landed] |
| channel budget share | turn channel (Higgs/Yukawa-facing) | closure channel (gauge/QCD-facing; conjecture C3 below) |

## 4. Wave 2 status (updated 2026-07-16 morning)

- **2A `3b35a00c` LANDED + INTEGRATED**
  (`PhysicsSM/Draft/NullEdge/SpinCornerFourCycleAristotle.lean`, 9
  standard-three guards): the general four-cycle Bargmann identity and the
  EXACT lune-phase law tr(P(z)P(u,v,0)P(-z)P(u',v',0))
  = conj(u+iv)(u'+iv')/4; `quarter_turn_corner` = I/4. The 1+1
  checkerboard corner factor i is now a kernel-checked THEOREM (quarter-
  turn lune), no longer an input convention; the wave-1 -1/4 and +1/4
  witnesses are recovered as the half-turn and zero-turn endpoints.
- **2B `469070a8` LANDED + INTEGRATED**
  (`PhysicsSM/Draft/NullEdge/ChiralSpiralMassiveAristotle.lean`, 9
  standard-three guards): the massive helix algebra is exact -
  (Dtot m)^2 = (1+m^2)*1 (on-shell Clifford square), the transverse
  ladders anticommute with the FULL massive operator, the massive
  rotation decomposes as wave-1 free rotation + m*(counter-rotator
  coupling), the zitter oscillator runs at exactly 2E
  ([Dtot,[Dtot,A_pm]] = 4(1+m^2) A_pm), and m = 0 recovers wave 1.
- **2C `058a9901` LANDED + INTEGRATED**
  (`PhysicsSM/Draft/NullEdge/PlanarCornerRealityAristotle.lean`, 7
  standard-three guards): all-orders planar CP-inertness
  (`planar_history_trace_real` by the RealForm real-subalgebra closure +
  list induction) with the nonplanar escape witness 1/4. Zigzag content is
  CP-inert at EVERY order; spiraling is necessary for CP-odd phases in
  this calculus.
- **4A `74a06ae4` LANDED + INTEGRATED**
  (`PhysicsSM/Draft/NullEdge/BargmannCocycleAristotle.lean`, 4
  standard-three guards): the Bargmann cocycle law
  tr(P(a)P(b)P(c)) tr(P(a)P(c)P(d)) = tr(P(a)P(b)P(c)P(d)) tr(P(a)P(c))
  with the arg form (positive-real diagonal), degenerate control, and a
  rational quadrilateral witness. With 3A this closes C1-POLYGON at the
  ingredient level: diagonal-fan polygon phases are sums of
  kernel-checked triangle half-solid-angles (fan-induction packaging is
  a one-lemma cleanup). Bonus (linter-verified): the proof uses only the
  DIAGONAL unit hypotheses - b, d need not be unit; strengthening pass
  queued.
- **3A `9ba69cff` LANDED + INTEGRATED**
  (`PhysicsSM/Draft/NullEdge/BargmannSolidAngleAristotle.lean`, 4
  standard-three guards): on Re > 0,
  arg tr(P(a)P(b)P(c)) = arctan(triple/(1+dots)) - kernel-checked, with
  octant pi/4 witness, planar-zero control, and reversal-negation. Via
  the cited Van Oosterom-Strackee formula this CLOSES the C1-triangle
  gate: the corner phase IS the signed half solid angle (M + one
  documented [import]). C1 for general polygons remains open (gate:
  a nonplanar 5-cycle witness or a polygon-decomposition argument).

## 4b. Waves 5-7 (submitted 2026-07-16 morning; ALL LANDED + INTEGRATED
by 11:15 same day, 0 sorries, statements verbatim 59/59 signatures,
18 new standard-three guards, builds green)

- **Wave 5 `6a413e71` LANDED + INTEGRATED**
  (`PhysicsSM/Draft/NullEdge/BargmannFanInductionAristotle.lean`, 6
  guards) (fan induction, C1-POLYGON packaging):
  matrix-slot cocycle (the generality the strengthening pass identified),
  `fan_factorization` (equation form, list induction, no nondegeneracy),
  `fan_arg` (polygon phase = product of fan-triangle phases), exact
  nonplanar pentagon witness (9+i)/25 (numerically verified). On landing,
  C1-polygon closes at the packaged level: polygon phases are sums of
  kernel-checked triangle half-solid-angles at every n.
- **Wave 6 `958c6429` LANDED + INTEGRATED**
  (`BargmannJarlskogToyAristotle.lean`, 7 guards) (two-family Jarlskog
  toy, C2 second half): jarlskogObs = Im(z_A conj z_B) decomposes exactly as
  [triple_A(1+dots_B) - triple_B(1+dots_A)]/16 - CP-odd interference is
  a function of oriented volumes and CP-even dots only, CKM-shaped;
  CP/swap odd; proper-rotation invariant; both-planar protected;
  one-planar witness 3/20 (the relative phase is what counts). With the
  landed 2C planar inertness this completes C2's displayed gate.
- **Wave 7 `8eb64e1f` LANDED + INTEGRATED**
  (`CapSquareBerryAristotle.lean`, 5 guards) (cap-square Berry factor,
  C3 target T1): closed latitude-square invariant = cornerAmp^4 exactly;
  magnitude ((1+t^2)/2)^4 (equator = the C3-T2 four-corner constant
  1/16); hemisphere Berry sign -1/4 as kernel fact (cross-checks the
  wave-1 hairpin -1/4 - same enclosed hemisphere); kink insertion costs
  exactly one corner factor with phase untouched. The
  smooth-costs-phase / kinks-cost-magnitude split becomes a finite
  theorem; C3-T2 (YM1 transfer lemma) unblocks on landing.
- **C3-T2 transfer module LANDED locally (claude-proved, no Aristotle):**
  `PhysicsSM/Draft/NullEdge/GateYM/FramedAreaLawTransfer.lean`, 6
  standard-three guards, build green. Composes the landed
  strong-coupling area law with a deterministic framing scalar:
  `framed_wilson_area_law` (framing with norm <= 1 cannot degrade the
  bound), `framed_wilson_area_law_sharp`/`_strict` (the framing is a
  pure area-independent prefactor at the SAME string tension), and the
  perimeter-collapse layer `proj_idem`/`proj_pow_collapse`/
  `rectangle_sequence_collapse` (constant direction runs contribute no
  corner factors, so an a x b axis-aligned rectangle's spin factor
  equals the four-corner square factor for all side lengths - the
  corner cost depends on the corner set, not the perimeter). Honest
  composition layer: the character-expansion factorization stays the
  displayed hypothesis it always was; the exact square value plugs in
  from wave 7 at its integration.

## 5. Conjecture ledger (grade C; gates and kill conditions displayed)

STATUS UPDATE (2026-07-16 midday, after waves 5-7 + the T2 transfer
module): **C1 gate CLOSED at the packaged level** - triangles by 3A
(arctan law + VOS import), polygons by wave 5 (fan_factorization +
fan_arg; nonplanar pentagon witness (9+i)/25). **C2 gate COMPLETE** -
all-orders planar inertness (2C) + the wave-6 two-family toy
(Jarlskog decomposition, CP/swap/rotation laws, both-planar
protection, one-planar witness 3/20). **C3 upgraded from C to
M-anchored**: T1 landed (wave 7: exact z^4 family, hemisphere sign,
kink penalty) and the T2 transfer layer landed
(GateYM/FramedAreaLawTransfer: framing preserves the area law at the
same string tension; rectangle spin factor is side-length-independent).
C3's remaining displayed content: NONE as of 13:15 - the T2 connector
landed (framed_rectangle_area_law, exact 1/4 at unchanged tension) and
T3 landed (`GateYM/KinkAreaCrossover.lean`: the two-projector semigroup
is one-dimensional, so the k-kink penalty is exactly (1/2)^k with the
hemisphere sign untouched; the perimeter-vs-area crossover is exactly
k* = sigma A / log 2; composed k-kinked framed bound
(1/2)^k (1/4) exp(-sigma A)). **ALL THREE GATES (C1, C2, C3) ARE
KERNEL-COMPLETE.** The original C-grade rows below are retained for
provenance; successors (three-family rephasing toy, fan packaging
lemma) are new preregistrations, not open gates.

- **C1 (solid-angle law, general).** For any spherical corner polygon the
  Bargmann phase is exp(-i Omega/2). GATE: wave 2A plus one nonplanar
  5-cycle witness. KILL: any corner polygon whose kernel-checked phase
  differs from -Omega/2 (mod orientation convention).
  SHARPENED 2026-07-16: for TRIANGLES the law is already within reach of
  the landed three-cycle identity via the Van Oosterom-Strackee formula
  tan(Omega/2) = a.(b x c) / (1 + a.b + b.c + c.a) [import: standard
  spherical trigonometry, IEEE TBME 1983]: the RHS is EXACTLY Im/Re of the
  landed tr(P(a)P(b)P(c)), so arg(trace) = signed Omega/2. Two
  confirmations already kernel-checked: the octant triangle x->y->z has
  arg((1+i)/4) = pi/4 = half of Omega(octant) = pi/2 (wave-1
  witness_handed), and the tetrahedral triple's ir/3 matches its frame's
  solid angle sign. Wave-3 target shape: kernel-check
  "arg = arctan(triple/(1+dots))" on the Re > 0 domain (M), with the VOS
  identification documented as the imported bridge to solid angle;
  obtuse-domain branch care stays displayed. This upgrades C1-triangle
  from conjecture to an M-target plus one cited import.
- **C2 (CP-odd = handedness).** Every CP-odd observable of the finite
  corner calculus is a function of oriented-volume invariants
  (Jarlskog-shaped Im-traces); planar content is CP-inert at every order.
  GATE: wave 2C plus a two-family toy with a relative phase (CKM-shaped).
  KILL: a CP-odd observable built from planar content only.
- **C3 (closure channel = circulation cost).** The closure-channel share of
  the mass budget for a circulating (closed-spiral) history is controlled
  by enclosed area at fixed perimeter - the histories-side shadow of the
  landed YM1 concrete-lattice area law. GATE: a framed-loop cost theorem
  linking the corner calculus to the YM1 lane. KILL: circulation cost
  provably not extensive in enclosed area on the relevant family.

## 6. What this note does NOT claim

No continuum limit, no Lorentz statement, no prediction of any mass value
or CP phase, no claim that nature's Yukawa/CKM phases are geometric. The
spin/helix and CP readings are interpretation attached to exact finite
identities; each carries its registry/anchor or its C-grade gate above.

## 7. Pointers

Wave-1 modules: `PhysicsSM/Draft/NullEdge/ChiralSpiralCommutatorAristotle.lean`,
`SpinCornerBargmannAristotle.lean`, `HairpinLunePhaseAristotle.lean` (all
integrated; task notes `AgentTasks/*-aristotle-2026-07-14.md`; standard-three
axiom guards backfilled 2026-07-16 - 10 + 10 + 8 = 28 in-file guards, build
and pre-commit green, so every spiral-layer module now carries build-enforced
assumption pins). Wave-2 task
notes: `AgentTasks/spin-corner-four-cycle-aristotle-2026-07-16.md`,
`chiral-spiral-massive-aristotle-2026-07-16.md`,
`planar-corner-reality-aristotle-2026-07-16.md`. Program context: the
four-channel budget and claim calculus in the all-mass manuscript
(`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`), the mass-coin
bridge (`PhysicsSM/Draft/NullEdge/GateI1/MassCoinBridge.lean`), zitter
average (`ZitterbewegungAverage.lean`), CPT zigzag module, and the
tetrahedral three-cycle witness (`TetrahedralSpinProjectorPath.lean`).
Standard-literature provenance (clean-room): Schroedinger zitterbewegung,
the Penrose zigzag picture, Hestenes zitter kinematics (reading only),
Bargmann invariants / spin-1/2 geometric phase.
