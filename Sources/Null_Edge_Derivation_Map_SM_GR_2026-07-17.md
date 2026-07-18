# The null-edge derivation map: from light-speed edges to the Standard Model and general relativity

Author: claude. Date: 2026-07-17. Status: program-level synthesis for
Director review. This document answers the directive "show how we can
derive all of the Standard Model and general relativity from the null-edge
model" in the only honest form available: a rigorous, claim-graded
DEPENDENCY MAP that marks, at every node, what is DERIVED (kernel-checked
from the null-edge structure), SUPPLIED (an input convention/schedule),
IMPORTED (borrowed from another framework), or OPEN (not yet built). It is
NOT a claim that the derivation is complete. It IS the exact statement of
what has been proven, what remains, and what each remaining step requires.

Claim calculus: `T` source-verified theorem; `M` machine-verified
(kernel, program-internal); `C` pre-registered conjecture; tags
`[orig]/[comp]/[import]`. "DERIVED" below means grade M with a landed,
axiom-pinned module.

## 0. The foundational object

The single primitive is the NULL EDGE: a light-speed constituent carrying a
Weyl 2-spinor `psi in C^2`, together with a finite CAUSAL ORDER on the
events the edges connect. Everything downstream is an attempt to grow
spacetime geometry and internal gauge structure from these two data - the
2-spinor (algebra/matter) and the order (causal/geometry) - plus the
minimal decorations honestly required.

The program's distinctive claim is that these TWO aspects of one object are
the shared root of the two great theories: the 2-spinor is simultaneously a
matter state (SM branch) AND, through soldering, a null direction of
spacetime (GR branch). The hinge that makes this precise is the soldering
capstone (node H below).

## 1. GR branch: from causal order + null edges to the Einstein equations

```text
null edge psi  --H-->  future-null direction nu(psi) in Minkowski
                        |
causal order  --G1-->  conformal class (Malament)          [target]
                        |
     + scale decoration --G2-->  metric g                  [Malament split]
                        |
Higgs stress  --G3-->  T_ab sources g                       [DERIVED algebra]
                        |
                    Einstein equations                      [OPEN]
```

- **H (soldering).** `nu(psi) = ` future-null 4-vector of `psi psi-dagger`;
  SL(2,C)-equivariant; two non-parallel null edges sum to a TIMELIKE vector
  with mass^2 = Plucker wedge area. Status: **LANDED 2026-07-17** (`NullEdgeSpinorSolderingAristotle`, 11
  kernel-checked theorems, standard-three guards) with proven bridges to
  BOTH landed islands (`NullEdgeSolderingPluckerBridge`):
  `soldering_mass_eq_plucker_det` (emergent Minkowski mass = `PluckerMass`
  determinant mass) and `nullEdgeVector_eq_hermitianCoords` (null vector =
  `SL2CLorentzAction.hermitianCoords`). DERIVED and concretely soldered.
- **G1 (order -> conformal).** The continuum theorem (Malament 1977;
  Hawking-King-McCarthy 1976): the causal order fixes topology, differential
  structure, and metric UP TO a conformal factor. Finite/discrete analog:
  the program's atlas and operator-lane reconstructions grope toward this.
  Status: **OPEN** (finite analog not a theorem); the operator lane's
  corrected-pairing signature work is the current front. IMPORT for the
  continuum statement; the finite version is the prize.
- **G2 (scale decoration).** Malament split: order gives conformal data for
  FREE; the scale must be SUPPLIED by decoration (event-counting volume +
  a density calibration). Status: the algebra is landed
  (`BareGraphScaleReconstruction`: count-volume needs a density; a hidden
  rescaling is unidentifiable) - **DERIVED as a boundary**, SUPPLIED as a
  quantity. The scale is owed, honestly.
- **G3 (Higgs stress -> gravity).** `T_ab = 2 Re((D_a H)+ D_b H) - g_ab L`,
  sourcing the inverse metric. Status: **DERIVED** algebra
  (`HiggsHilbertStress`), but sources gravity only relative to a
  reconstructed/supplied frame (depends on G1/G2).
- **Einstein equations.** Status: **OPEN.** Requires G1 (frame), G2 (scale),
  G3 (source), and a variational principle tying them - none yet assembled.

The GR branch's honest state: the Lorentz group and null structure are
DERIVED at a point (H); the order->conformal step (G1) is the central open
theorem; scale (G2) is a named debt; the source (G3) is derived algebra
awaiting a frame; the field equation is open.

## 2. SM branch: from the 2-spinor's internal algebra to gauge + matter

CORRECTED 2026-07-17 after auditing the landed `PhysicsSM/Algebra/Furey/`
tree (48 trusted modules). The SM branch is FAR more built than a first
pass suggested: one full generation's electroweak + color quantum numbers
are DERIVED as operators with anomaly cancellation; the repo itself names
the single precise remaining electroweak gap.

```text
2-spinor internal algebra
        |
   division algebras (C, H, O)          [SUPPLIED structure — the deepest debt]
        |
  --S1-->  SU(3)_color FUNDAMENTAL on the color-triplet minimal ideal   [DERIVED]
        |
  --S2a--> Q_op quantized; T3 operator; Y; Q=T3+Y/2; W± su(2) relations;
           one-generation SU(2)^2-U(1)_Y ANOMALY CANCELLATION            [DERIVED]
        |
  --S2b--> W± and T3-eigenvalues FROM the alpha_i octonion ladder        [OPEN: repo-flagged gap]
        |
  --S3-->  full one generation assembled (colour x weak x hypercharge)   [DERIVED package]
        |
  --S4-->  three generations                                             [OPEN]
        |
  mass  --M1-->  mass^2 = Plucker area (Lorentz scalar)     [DERIVED: node H]
  CP    --M2-->  CP-odd = oriented-volume (Jarlskog shape)  [DERIVED mechanism]
```

- **S1 (color).** `Aut(O)` fixing an imaginary unit = Mathlib's SU(3)
  (`Octonion.G2FixingE111SpecialUnitaryGroup`), and the color triplet
  `{v4,v5,v6}` (basis of a minimal left ideal) carries the SU(3)
  FUNDAMENTAL (`ColorTripletFundamental`), with color operators commuting
  with `Q_op` (charge conservation). Status: **DERIVED** (registry
  `FB-SU3`; stronger than a bare group iso - it is the fundamental rep on
  matter states). [orig formalization; comp: Furey].
- **S2a (electroweak quantum numbers).** DERIVED as OPERATORS on the Jbar
  sector: `Q_op` with quantized eigenvalues; the `T3End` weak-isospin
  operator with per-state eigenvalues; hypercharge (`leptonDoublet_hypercharge`
  Y=-1, `quarkDoublet_hypercharge` Y=1/3); operator-level Gell-Mann-Nishijima
  `T3 + Y/2 = Q`; `W±` ladder operators with su(2) commutators
  `[T3,W±]=±W±`, `[Q,W±]=±W±`; and one-generation `SU(2)^2-U(1)_Y` anomaly
  cancellation mapping to `StandardModel.AnomalyPackage`. This is a large,
  trusted, kernel-checked block - anomaly freedom of one generation is a
  nontrivial SM consistency, DERIVED. [orig formalization].
- **S2b (the precise remaining electroweak gap).** `T3End` supplies its
  eigenvalues from the SM table and `W±` are explicit permutation maps
  (`ElectroweakBridge`, `ElectroweakCompletePackage` boundaries).
  IMPORTANT (corrected 2026-07-17): the fix is NOT to re-express W± as
  `alpha_i` combinations within Cl(6) - the repo states (`AnomalyBridge`
  open task 2) that "weak isospin requires SU(2)_L structure BEYOND Cl(6)";
  the `C(x)O` ladder generates only `su(3)_c (+) u(1)`. su(2)_L needs the
  additional QUATERNIONIC `C(x)H` input (Furey's `R(x)C(x)H(x)O`). Status:
  **OPEN but now fully SPECIFIED** (Furey 1806.00612 full text extracted
  2026-07-17): su(2)_L generators `T_3 = B1d B1 - B2d B2`, `T_+/- ~ Bid Bj`
  with WEAK ladders `B_j = i e_7 | beta_j` from the QUATERNIONIC C(x)H
  beta-ladders (NOT the C(x)O alpha_i). One generation = SU(5) `1(+)5*(+)10`.
  Concrete build (4-brick roadmap in the S2b design note): **BRICK 1 LANDED
  2026-07-17** (`WeakIsospinTwoModeSU2Aristotle`, 11 guarded theorems): the
  abstract su(2)_L algebra from two fermionic ladder modes with the doublet
  `T3 = diag(0,1,-1,0)` at `+-1/2`, EXTENDED to the electroweak `U(2) =
  SU(2)_L x U(1)` (`ElectroweakU2FromLadders`, 6 guards): the weak number
  operator commutes with su(2)_L, and Gell-Mann-Nishijima gives the EXACT SM
  charges of one generation (nu=0,e=-1,u=2/3,d=-1/3; hypercharge Y supplied). Bricks 2 (C(x)H spin/chirality, mostly
  landed as the soldering M(2,C)), 3 (the chirality mechanism - the deep
  target), 4 (octonionic realization B_j = i e_7|beta_j + uniqueness closure)
  remain. Completing all four DERIVES one generation's weak isospin.
- **S3 (one generation assembled).** The `OneGenerationPackage` bundles
  colour dim x weak dim x hypercharge against the SM table with anomaly
  freedom. Status: **DERIVED as a consistency package** (modulo S2b's
  supplied T3/W±). [orig].
- **S4 (three generations).** `Cl(6)` 64-dim -> three generations
  (Furey 1405.4601); sedenion `S_3`/triality (Gourlay 2025). Status:
  **OPEN** [comp].
- **M1 (mass).** DERIVED via node H (mass^2 = wedge area, Lorentz-invariant).
- **M2 (CP).** The spiral-layer Jarlskog: every CP-odd two-family observable
  is an oriented-volume functional; planar content CP-inert at all orders.
  Status: **DERIVED mechanism** (spiral manuscript, landed). The recent
  Gupta-Teli-Singh octonionic-flavor CP work (arXiv 2606.27836) derives CP
  phase laws from the SAME `Cl(6)` three-generation structure - a striking
  convergence with the spiral layer worth a dedicated cross-check [comp].

The SM branch's corrected honest state: colour AND one generation's
electroweak quantum numbers (charge quantization, weak isospin, hypercharge,
Gell-Mann-Nishijima, W± su(2) algebra, anomaly cancellation) are DERIVED as
kernel-checked operators. The precise remaining gaps are S2b (derive W±/T3
from the octonion ladder - currently supplied), S4 (three generations), and
the deepest debt: WHY the octonionic internal algebra, which is SUPPLIED and
not derived from the null-edge substrate. Mass and CP are DERIVED MECHANISMS
but not values.

## 3. The hinge: where the two branches are one

Node H is shared. The 2-spinor `psi` is a matter state (SM branch, S1-S4
act on its internal indices) AND its self-solder `psi psi-dagger` is a
future-null spacetime direction (GR branch). Mass (M1) is the timelike sum
of two null edges - a spacetime invariant built from two matter states.
This is the program's central unification claim, and node H makes it a
theorem rather than a picture. A complete derivation would show the SAME
`psi` carrying the SM internal structure (S1-S4) and generating the GR null
structure (H, G1) compatibly - the compatibility of the internal and
spacetime actions on `psi` is itself an OPEN foundational target once S2-S4
exist.

**The spiral layer is the celestial-sphere calculus of node H.** A second,
already-landed thread meets the hinge here: for a UNIT null edge `psi`, the
soldered rank-one Hermitian `psi psi-dagger` is exactly the spiral-layer
spin-coherent corner projector `P(n) = (1 + n . sigma)/2`, where `n` is the
Bloch/celestial direction and `|n| = 1` (numerically verified 2026-07-17).
Moreover the SPATIAL part of the null 4-vector `nu(psi)`, divided by its
energy `|psi|^2/2`, equals `n`: the null edge points in celestial direction
`n`. Therefore the SPIRAL LAYER (`SpinCornerBargmann` and successors) IS the
calculus of null-edge DIRECTIONS on the celestial sphere: the pair trace
`(1 + a.b)/2` is a two-null-edge overlap, the three-cycle oriented-volume /
solid-angle phase is a geometric phase of three null directions, and the
mass-area law is the timelike sum of two of them. This is now a DERIVED,
KERNEL-CHECKED identification: `NullEdgeSolderingPluckerBridge.rankOne_eq_proj_bloch`
proves `rankOne (unit psi) = SpinCornerBargmann.proj (bloch psi)`, tying
`SpinCornerBargmann` (SM/phase) and `NullEdgeSpinorSoldering` (GR/null) into
one module family. It converts the spiral layer's abstract 2x2 projector
calculus into an explicit statement about the geometry of light-speed edges.

## 4. Honest bottom line and the load-bearing debts

DERIVED (kernel, landed or submitted): SU(3) color; mass = Lorentz-invariant
Plucker area (node H, on landing); CP = oriented volume; the Higgs stress
algebra; the scale-reconstruction boundary; the layer-coherent (2,2) no-go
(a derived OBSTRUCTION that sharpens the GR branch).

SUPPLIED / IMPORTED (the debts, in dependency order for a full derivation):
1. spatial dimension 3 (SUPPLIED in the shell-angular selector; a
   data-selected dimension diagnostic would upgrade it - GR branch);
2. the Benincasa-Dowker operator coefficients (IMPORTED; deriving them from
   null-edge axioms, or tagging the operator lane conditional, is owed);
3. the octonionic internal algebra (SUPPLIED; the deepest SM debt);
4. S2b: derive `W±` and the `T3` eigenvalues from the `alpha_i` octonion
   ladder (SUPPLIED as permutation maps / table today; the electroweak
   quantum numbers and one-generation anomaly cancellation are ALREADY
   DERIVED - only the ladder-origin of `W±`/`T3` is owed);
5. the absolute scale G2 (SUPPLIED; Malament decoration);
6. S4 three generations (OPEN, `Cl(6)`).

PREDICTED numbers confronting experiment: NONE. The program derives
MECHANISMS and STRUCTURE, supplies the specific algebras and calibrations,
and predicts no measured value yet. Any unqualified "we derive the Standard
Model / general relativity" is currently FALSE; the true statement is "we
derive these mechanisms (color, mass-as-area, CP-as-volume, the causal
skeleton of geometry); these structures remain supplied; these steps remain
open."

## 5. Recommended foundational sequence (what to build next)

- SM branch (my lane): **S2b - build the `C(x)H` quaternionic sector that
  supplies su(2)_L** (su(2)_L is beyond Cl(6); do not fabricate an `alpha_i`
  combination). GATED on a full-text study of Furey arXiv:1806.00612 for the
  exact construction, then a Mathlib `Quaternion R` + `C(x)H ~ M(2,C)` build
  (the same `M(2,C)` as the soldering module - a unification), closing via
  the `WeakIsospinLadderDerived` uniqueness handle. Highest-leverage unbuilt
  SM foundation once unblocked by the literature study.
- GR branch (codex lane): the shell-angular 1+3 selector with the three
  required additions (dimension-selection diagnostic, anchor robustness,
  time-line teeth), pushing G1 from continuum-import toward a finite theorem.
- Hinge: on node H landing, prove the compatibility of the SM internal
  action and the GR soldering on the same `psi` - the formal statement of
  "one object, two theories."

## 6. Literature grounding (provenance)

| Result used | Source | arXiv | Tag |
|---|---|---|---|
| SU(3) as octonion element-preserver; one-gen under su(3)c x u(1)em; EW from C(x)H/C(x)O | Furey | 1405.4601, 1756157 | [comp] |
| SM gauge group S(U(2)xU(3)) = intersection of two F4 maximal subgroups | Todorov-Drenska | 1805.06739 | [comp] |
| M(8,C) captures SM reps/charges; quaternions -> Lorentz | Gording-Schmidt-May | 1909.05641 | [comp] |
| Cl(6) minimal ideals; braided one generation | Gresnigt | 1901.01312 | [comp] |
| three generations from sedenion S3 / triality | Gourlay | 2025 thesis | [comp] |
| octonionic-flavor CP phase laws (converges with spiral Jarlskog) | Gupta-Teli-Singh | 2606.27836 | [comp] |
| causal order -> conformal metric | Malament; HKM | (1977; 1976) | [import] |
| Infeld-van der Waerden / null-flag soldering | Penrose-Rindler | (standard) | [import] |

All rows are consulted-and-cited context, not copied code; the repo's
octonion XOR-basis convention differs from Furey/Baez and requires the
`ConventionBridge` for any imported product formula (AGENTS.md).
