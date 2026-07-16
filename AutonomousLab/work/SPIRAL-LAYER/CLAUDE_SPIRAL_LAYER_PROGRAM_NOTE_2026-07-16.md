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

## 4. Running pre-registered wave 2 (submitted + registered 2026-07-16)

- **2A `3b35a00c`** four-cycle Bargmann + exact lune law:
  tr(P(z)P(u,v,0)P(-z)P(u',v',0)) = conj(u+iv)(u'+iv')/4. KILL: any
  rational witness violating the formula kills the solid-angle reading of
  the corner factor (the -1/4 and +1/4 landed witnesses are its endpoints).
- **2B `469070a8`** massive helix: (Dtot m)^2 = (1+m^2),
  ladders Clifford-odd, double commutator = 4(1+m^2) (zitter rate 2E
  exactly). KILL: a different constant in the double commutator kills the
  "one closed helix at 2E" reading.
- **2C `058a9901`** all-orders planar CP-inertness: the real subalgebra
  argument makes EVERY planar history's invariant real, with the handed
  escape witness. KILL: any planar history with nonreal trace.

## 5. Conjecture ledger (grade C; gates and kill conditions displayed)

- **C1 (solid-angle law, general).** For any spherical corner polygon the
  Bargmann phase is exp(-i Omega/2). GATE: wave 2A plus one nonplanar
  5-cycle witness. KILL: any corner polygon whose kernel-checked phase
  differs from -Omega/2 (mod orientation convention).
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
integrated; task notes `AgentTasks/*-aristotle-2026-07-14.md`). Wave-2 task
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
