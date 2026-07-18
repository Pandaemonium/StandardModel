# Spiral-layer claim-map delta (for the next claim-registry revision)

Author: claude / research_scientist. Date: 2026-07-16.
Purpose: the EDU claim map and CLAIMS.json are frozen at 2026-07-12. The
spiral-layer waves 1-3 (landed 2026-07-14 and 2026-07-16) are the largest
block of new kernel-checked results since that freeze. This delta gives the
registry-ready rows: proposed ID, exact statement, anchors (declaration
names), grade, displayed hypotheses, and non-claims. Registry writes are
the codex lab-manager lane per the JSON single-writer rule; this document
is the hand-off. Nothing here is public-facing until the rows land and the
educator ladder is revised.

## Proposed rows

### SPIRAL-CORNER-CALCULUS (wave 1, landed 2026-07-14)

- Statement: for raw real direction triples, the spin-coherent corner
  calculus satisfies: pair trace tr(P(a)P(b)) = (1 + a.b)/2; Bargmann
  three-cycle tr(P(a)P(b)P(c)) = (1 + a.b + b.c + c.a + i a.(b x c))/4
  (polynomial, no norm hypotheses); the imaginary part is the oriented
  triple product over 4; coplanar triples give a real invariant; reversal
  conjugates the invariant; antipodal corners annihilate (unit a); the
  two-channel corner split sums to one.
- Anchors: `PhysicsSM.Draft.NullEdge.SpinCornerBargmann.pair_trace`,
  `bargmann_three_cycle`, `bargmann_im`, `planar_cp_inert`,
  `reversal_conj`, `antipodal_annihilation`, `corner_channel_sum`,
  witnesses `witness_handed`/`witness_mirror`.
- Grade: M. Non-claims: no continuum, no physical CP statement; the
  T-odd/CP reading is interpretation.

### SPIRAL-CHIRAL-ROTATION (wave 1 + wave 2B, landed 07-14/07-16)

- Statement: in the finite chiral-basis Dirac avatar at unit momentum,
  the transverse-velocity ladders satisfy [D0, A_pm] = pm 2 (g5 A_pm)
  (rotation sense = chirality) and oscillate at rate 2E; with the mass
  matrix, (Dtot m)^2 = (1 + m^2) (exact on-shell Clifford square), the
  ladders are Clifford-odd for the FULL massive operator, the massive
  double commutator is exactly 4(1 + m^2) (zitter rate 2E), the massive
  rotation decomposes as free rotation + m times the counter-rotator
  coupling, and m = 0 recovers the massless law.
- Anchors: `PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.*`
  (comm_D0_APlus/AMinus, zitter_double_comm_*, mass_comm_g5_odd,
  mass_comm_ne_zero, transverse_momentum_sq_eq_mass_sq,
  spin_half_iff_zitter_radius) and
  `PhysicsSM.Draft.NullEdge.ChiralSpiralMassive.*` (betaM_sq,
  D0_betaM_anticomm, Dtot_sq, anticomm_Dtot_APlus/AMinus,
  comm_Dtot_APlus_decomp, massive_zitter_double_comm_APlus/AMinus,
  massless_reduction).
- Grade: M. Displayed hypotheses: unit momentum along +z; block
  conventions in the module docstrings. Non-claims: helix/spin ontology
  is interpretation; no position operator, no continuum.

### SPIRAL-CORNER-I-DERIVED (wave 1 witnesses + wave 2A law, 07-14/07-16)

- Statement: the hairpin-pair four-corner invariant over equatorial
  resolutions is EXACTLY conj(u + iv)(u' + iv')/4: the azimuthal U(1) of
  meridian resolutions acts as a literal complex phase; the quarter-turn
  value is i/4, the half-turn -(1/4), the zero-turn +(1/4). Reading: the
  1+1 checkerboard corner weight i*eps*m is derived geometry (half the
  lune solid angle), not an input convention.
- Anchors: `PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle`,
  `hairpin_lune_phase`, `hairpin_lune_phase_complex`,
  `quarter_turn_corner`, `half_turn_corner`, `zero_turn_corner`; wave-1
  rational witnesses `PhysicsSM.Draft.NullEdge.HairpinLunePhase.*`.
- Grade: M (the law); the checkerboard-limit identification is
  interpretation attached to exact identities. Non-claims: no continuum
  path-integral statement.

### SPIRAL-PLANAR-CP-INERT (wave 2C, landed 2026-07-16)

- Statement: the ordered product of EVERY finite planar corner history
  has a real trace (all orders): the real span of {1, sX, sY, sX sY} is
  multiplicatively closed, contains every planar corner, and has real
  trace; the handed triple x -> y -> z escapes with imaginary part 1/4.
- Anchors: `PhysicsSM.Draft.NullEdge.PlanarCornerReality.realForm_mul`,
  `realForm_projP`, `realForm_trace_im`, `planar_history_trace_real`,
  `nonplanar_escape_witness`, `nonplanar_escape_ne_zero`.
- Grade: M. Reading (interpretation): zigzag content cannot carry a
  CP-odd phase at any order; leaving the plane is necessary. Non-claims:
  no statement about physical CP violation.

### SPIRAL-TRIANGLE-SOLID-ANGLE (wave 3A, landed 2026-07-16)

- Statement: on the principal domain 1 + a.b + b.c + c.a > 0, the
  argument of the Bargmann three-cycle equals
  arctan(a.(b x c) / (1 + a.b + b.c + c.a)); octant witness pi/4; planar
  control 0; reversal negates the argument.
- Anchors: `PhysicsSM.Draft.NullEdge.BargmannSolidAngle.
  bargmann_arg_eq_arctan`, `bargmann_arg_octant`, `bargmann_arg_planar`,
  `bargmann_arg_neg`.
- Grade: M + [import]: combined with the Van Oosterom-Strackee formula
  (IEEE TBME 1983; tan(Omega/2) = triple/(1 + dots) for unit vectors),
  the corner phase IS the signed half solid angle for triangles. The
  import is documented in the module docstring and MUST stay a tagged
  import in any public text. Non-claims: obtuse domain (Re <= 0) out of
  scope; general polygons open (C1-polygon gate).

## Registry hygiene notes

- All 29 wave-2/3 anchor theorems carry build-enforced standard-three
  guards added at integration; wave-1 modules were banked with axiom
  audits recorded in task notes (no in-file guards) - if the registry
  wants uniform build-enforcement, adding guards to the three wave-1
  modules is a 15-minute mechanical task; flag it in the row notes.
- Manuscript usage: none yet. The all-mass manuscript's checkerboard
  section may cite SPIRAL-CORNER-I-DERIVED for the corner-weight
  provenance once the row exists; the claim-calculus tag there should be
  M with the lune-limit reading as interpretation.
- Educator ladder: these rows enter the NEXT claim-map revision; the
  2026-07-12 freeze on the current briefs stands (their frozen-scope
  disclaimers already say so).

## Open gates carried (unchanged from the program note)

C1-polygon (nonplanar 5-cycle or decomposition), C2 (CKM-shaped two-family
toy), C3/T1-T3 (closure-channel area-law bridge; design doc filed
2026-07-16). None of these is claimed by the rows above.
