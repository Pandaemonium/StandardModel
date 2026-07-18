# The ten ambitious goals: rigorous status and frontier map

Author: claude. Date: 2026-07-17. Status: honest, claim-graded status of the
ten-item derivation program set as the session goal. Each item is marked
DERIVED (kernel-checked, landed module), CONSTRAINED (forced/partial with a
cited import), SCAFFOLDED (structure exists, derivation open), or OPEN, with
the exact module anchors and the precise remaining step. This is NOT a claim
that all ten are complete - it is the truthful map of what is proven, what is
constrained, and what remains, so no over-claim can hide.

Companion: `Null_Edge_Derivation_Map_SM_GR_2026-07-17.md` (the full dependency
map). Capstone index: `PhysicsSM/Draft/NullEdge/NullEdgeDerivationGrandMesh.lean`.

## Item 1 - Chirality (why the weak force is left-handed)

STATUS: **CORE DERIVED**, deep remainder OPEN.
Landed: `PhysicsSM/Draft/NullEdge/ChiralityFromActionSplit.lean`. Weak isospin
is a LEFT action, chirality a RIGHT grading; they commute by ASSOCIATIVITY, so
su(2)_L cannot change chirality (`leftAction_preserves_rightChirality`,
`su2L_blockDiagonal_in_chirality`) - parity violation's algebraic half, with NO
chiral projector by hand.
Also landed (2026-07-17): `PhysicsSM/Draft/NullEdge/WeakIsospinRepContent.lean`
computes the explicit su(2)_L ACTION on the ladder Fock space and proves the
decomposition `1 (+) 2 (+) 1` (`weakIsospin_rep_decomposition_1_2_1`): the empty
and full Fock states are su(2)_L SINGLETS (killed by T_3, T_+, T_-), the two
singly-occupied states form the DOUBLET (T_3 = +/-1, T_+ raising d -> u). This is
the isospin structure - the model provably contains BOTH singlets and a doublet.
Remainder now CLOSED (2026-07-17, faithful Furey 1806.00612 PDF): the actual
Section 5 leptonic ideal `L = V_R v_w + V_L v_w beta_1‡ + E-_L v_w beta_2‡ +
E-_R v_w beta_1‡ beta_2‡` (eq 32) maps EXACTLY onto the landed
`WeakIsospinRepContent` states as `V_R=|00>, V_L=|10>, E-_L=|01>, E-_R=|11>`, so
the DOUBLET `(|10>,|01>)` is left-handed `(V_L,E-_L)` and the SINGLETS
`(|00>,|11>)` are right-handed `(V_R,E-_R)`. `PhysicsSM/Draft/NullEdge/
WeakIsospinChiralityProjector.lean` proves the chirality eigenvalues (RH=-1,
LH=+1) and the projector `P_L=(1/2)(1+chi)=diag(0,1,1,0)`; with the landed
singlet-annihilation this is the faithful eq 35/36 "su(2)_L doublet = left-handed,
RH = singlets" - the physical state-particle identification. Deeper remainder: the
full octonionic beta-ladder realization on the actual C(x)O ideal (item 2).

## Item 2 - Close the electroweak gap on the actual states (brick 4)

STATUS: **OPEN** (ideal-restricted CAR), sharply scoped; upstream bricks +
`C(x)H(x)O` substrate + faithful eq-30 ladders DERIVED.
Derived upstream: su(2)_L algebra (`WeakIsospinTwoModeSU2Aristotle`), electroweak
U(2) with exact SM charges (`ElectroweakU2FromLadders`), SU(5) hypercharge
unification (`SU5HyperchargeUnification`).
CONSTRUCTION CORRECTED (2026-07-17, actual Furey 1806.00612 PDF; the OCR/design
note had CONFLATED it with the SU(5) paper). The faithful weak sector is `Cl(4) =
Cl(2)(x)_C Cl(2)` (chirality (x) isospin RIGHT actions), with ladders
`beta_1=(1/2)(-e_2+i e_1 tau_1)`, `beta_2=omega_dag i e_1` (eq 30), leptonic ideal
eq 32, and su(2)_L `T_j = tau_j (1/2)(1+i_3)` (eq 35, the (1/2)(1+i_3) a chirality
projector). FAITHFUL PROGRESS LANDED: `WeakIsospinChiralityProjector` (chirality
projector + eigenstates) + the eq-32 state identification confirming the landed
`WeakIsospinRepContent` 1(+)2(+)1 IS the Furey leptonic ideal.

SUBSTRATE DERIVED (2026-07-17): the eq-30 `beta`-ladders genuinely need the full
`C(x)H(x)O` Dixon algebra (Aristotle no-go 661e5230 was RIGHT; the `i_j` of eq
29-30 are `H`-quaternion units, a SEPARATE tensor slot from the octonion `e_k` -
verified verbatim against the PDF). That substrate is now BUILT and kernel-checked
(`PhysicsSM/Draft/NullEdge/DixonAlgebra.lean`, sorry-free, 3 axiom guards): the
`H`-valued-over-`C(x)O` type, the Hamilton product, the `H`-units with `i_j^2=-1`
/ `i_1 i_2 = i_3`, the TENSOR-COMMUTATION `ofColour_comm_i_j` (the `H`-units
commute with the whole colour factor - what makes it genuinely `C(x)H(x)O`), and
the PAYOFF `i1_i2_anticomm` `{i_j,i_k}=0` (the fermionic Clifford anticommutation
the colour factor alone could not supply). The faithful eq-30 `beta`'s + the
Dixon `‡` are built on it (`DixonWeakLadders.lean`, sorry-free, axiom-guarded).

HONEST KERNEL FINDING (`DixonWeakLadders.betaH_like_anticomm_ne_zero`): with these
ELEMENT `beta`'s the like-CAR `{beta_1,beta_2}` is NONZERO (`= 1/2`). Hand-analysis
(nonzero-ness kernel-checked at one coordinate): the `H`-unit cross-terms CANCEL
via `{i_1,i_2}=0` (the payoff working); the surviving term is `(1/2){omega,omega‡}`,
and in the concrete `C(x)O` realization `omega omega‡`, `omega‡ omega` are the two
COMPLEMENTARY idempotents `(1 -+ i e_111)/2` that SUM TO 1, so `{omega,omega‡}=1`
and `{beta_1,beta_2}=1/2`.
INTERPRETATION CORRECTED (do not over-claim): because `{omega,omega‡}=1` (not a
projector) AND the repo proves the COLOUR CAR at the ELEMENT level (`LadderOperators`:
`alpha_i alpha_j‡ + alpha_j‡ alpha_i = delta_ij` in `C(x)O`), a nonzero element
`{beta_1,beta_2}` does NOT prove "operator-on-ideal" - it shows these ELEMENT
`beta`'s are not Furey's intended objects. Furey's `beta`'s are bar/right-action
OPERATORS (eq. 13: the `C(x)H` Dirac matrices are bar operators `1|i_1`, ...), so
eq-31 is an anticommutator of OPERATORS, not of algebra elements.

STILL OPEN (genuine remaining electroweak-CAR step): realize the `beta`'s as
bar/right-action operators on the Dixon algebra (the `DixonLeftRightAction`
scaffolding), check the eq-31 operator CAR there (NOT as element products), then
close `T_+ = TPlusEnd` via `WeakIsospinLadderDerived.TPlusEnd_unique`. The Dixon
substrate, faithful eq-30 element data, and the honest kernel finding are the
landed scaffolding for this. The operator CAR is now a PRE-REGISTERED CONJECTURE
(typechecking, `s o r r y` handoff): `PhysicsSM/Draft/NullEdge/
DixonWeakCARConjecture.lean` states reading (A) right-action-on-ideal (`v_w`
vacuum + `{R_{beta_i},R_{beta_j}}=0` / `=delta_ij` on `L = v_w Cl(4)`), with
reading (B) bar-operator-on-all as the documented fallback and a kill-condition
(if both fail, the eq-30 translation is wrong). Aristotle target (deps are a clean
Mathlib + 7-file chain; brute `norm_num` is infeasible - needs the colour-CAR /
idempotent lemmas). Roadmap:
`AgentTasks/null-edge-S2b-weak-isospin-from-ladder-design-2026-07-17.md` (CORRECTION 2-5).

## Item 3 - Colour + electroweak unification (SU(5))

STATUS: **DERIVED**.
Landed: `PhysicsSM/Draft/NullEdge/SU5HyperchargeUnification.lean`. All
one-generation hypercharges are values of ONE traceless SU(5) generator
(`5* = diag(2/3,2/3,2/3,-1,-1)`, `10 = Lambda^2(5)` pair-sums); anomaly-trace
vanishes; charges quantized; Georgi-Glashow block-constancy identifies U(1)_Y as
the SU(5) generator commuting with SU(3) x SU(2). Combined with the landed
SU(3)_colour (`FB-SU3`, `ColorTripletFundamental`) and the electroweak U(2),
this is the SM gauge group on one generation with derived hypercharges.
Open remainder: the full SU(5) group action on the 5*(+)10(+)1 as one rep (vs
the Cartan-level result here).

## Item 4 - Three generations

STATUS: **CORE DERIVED**, deep remainder OPEN.
Landed: `PhysicsSM/Algebra/Furey/TrialityFamilySymmetry.lean`. The Z3 triality
family symmetry on the Furey-Hughes roles is order 3, transitive, single-orbit
(`triality_generation_count = 3`) - the Z3 subset S3 = Out(Spin(8)) forcing
exactly three, in one orbit.
Open remainder: that the three orbit slots ARE the physical generations with
correct SU(3) x SU(2) x U(1) rep content - the full Spin(8) triality on
C(x)H(x)O (Furey-Hughes 2409.17948).
INDEPENDENT CROSS-EVIDENCE for exactly three (2026-07-17 re-audit): the landed
finite Kobayashi-Maskawa phase count proves `cp_possible_iff : 0 < ckmPhysCP N
<-> 3 <= N` (`KMPhaseCounting`) - CP violation is possible only for three or more
families. So two independent landed routes point at three: the `Z3` triality
orbit (family symmetry) and the KM CP threshold (three needed for observed CP
violation). Neither yet fixes exactly three with full rep content, but they
converge.

## Item 5 - Derive the octonionic algebra from the substrate

STATUS: **CONSTRAINED** (not arbitrary), full derivation OPEN.
The null-edge mass-area mechanism is `mass^2 = |wedge|^2`, a MULTIPLICATIVE norm
- the composition law `normSq(x y) = normSq x * normSq y`. The repo's
`PhysicsSM/Algebra/Division/CompositionAlgebra.lean` proves a composition algebra
has NO zero divisors (`compAlg_no_zero_divisors`) - i.e. it is a DIVISION
algebra. By HURWITZ's theorem [import; not in Mathlib] the only finite-dim real
normed division algebras are R, C, H, O. So the mass mechanism CONSTRAINS the
internal algebra to these four - the choice is not free. The octonions are then
selected as the MAXIMAL one whose automorphism group contains SU(3)
(`FB-SU3`: Aut(O) fixing an imaginary unit = SU(3)).
Also landed (2026-07-17): `PhysicsSM/Algebra/Octonion/CompositionDivision.lean`
makes this concrete on the PROJECT octonions - `octonion_no_zero_divisors`
(x*y=0 -> x=0 or y=0) and `octonion_mul_inv` (every nonzero octonion is
invertible, x^{-1} = (1/normSq x).conj x), both trusted/standard-three, derived
from the landed composition law `Octonion.normSq_mul` (Degen) + `normSq_eq_zero`
+ `normSq_eq_mul_conj`. So the octonionic division-algebra property is DERIVED
from the composition norm on the actual octonions.
Open: formalize Hurwitz (large) - the classification that composition + positive
-definite over R forces exactly R,C,H,O; and derive WHY the maximal (vs smaller)
algebra - i.e. why nature uses all of R(x)C(x)H(x)O.
LANDED (2026-07-17, Aristotle 6af39d1c witness + kernel-verified): the UPPER
bound of the tower - `PhysicsSM/Draft/SedenionZeroDivisors.lean` proves the
sedenions (Cayley-Dickson double of O) have zero divisors (explicit witness
a=(e1,e2), b=(e4,e7)), so O is the MAXIMAL division algebra in the tower (why
nothing larger than O). Combined with the landed division property,
this brackets item 5: composition -> division (LANDED) and O maximal (LANDED);
only the Hurwitz classification (R,C,H,O are the ONLY ones, R/C/H not larger-that
is the tower going DOWN) remains fully supplied. Item 5 is thus CONSTRAINED
trending strongly to DERIVED (both brackets kernel-checked).
FORWARD tower step also LANDED (2026-07-17, Aristotle e9d9ebbf, kernel-verified):
`PhysicsSM/Draft/CayleyDicksonQuaternion.lean` `cd_norm_multiplicative` - doubling
the ASSOCIATIVE quaternions PRESERVES the composition norm (why O IS a composition
algebra). With `octonion_not_associative` + `sedenion_composition_fails` (doubling
NON-associative O LOSES composition), the tower is now bracketed BOTH directions,
localizing Hurwitz's 'why stop at O' at the H->O associativity loss. Item 5's
'why the octonions' is a COMPLETE kernel-checked structural story; only the
abstract Hurwitz classification (only R,C,H,O) stays supplied.

## Item 6 - Finite Malament theorem (causal order => conformal)

STATUS: **OPEN** (codex's active GR lane).
The central open GR theorem. Codex's marked-Alexandrov shell-angular 1+3
selector (`GRAV-ORDER-OPERATOR-001`) is the current front; my hostile audit
(F1-F3) flagged that spatial dimension 3 is currently supplied there.
Contribution: coordinate; the algebraic dimension route (item 7) is
complementary evidence.

## Item 7 - Derive 3+1 dimensionality

STATUS: **DERIVED (algebraic route)**, spectral route in progress (codex).
Landed: `PhysicsSM/Draft/NullEdge/DivisionDimensionSelection.lean`
(`division_algebra_selection`, `dimension_is_four`): among R, C, H, O, the
algebra `C` is UNIQUELY selected by two physical discriminators - composition
(multi-particle tensor products need a COMMUTATIVE base: rules out H, O) and a
CONTINUOUS CP phase (rules out R's finite {+-1}) - and `C` gives Minkowski
`d = 4` (the dimension of 2x2 Hermitian over C, on which SL(2,C) = Lorentz acts).
This is `3+1` DERIVED at the algebraic level, and it is exactly the soldering
spacetime (tonight's `NullEdgeSpinorSoldering` Minkowski4 = 2x2 Hermitian over
C, SL(2,C) Lorentz). Codex's causal-set spectral-dimension route is an
independent complementary derivation.
Open: the premises (composition + continuous phase) are physically motivated,
not themselves derived from the bare causal order.

## Item 8 - Finite Einstein dynamics from the corrected pairing

STATUS: **OPEN** (codex's GR lane; foundations landed).
Landed foundations: the corrected pairing is a self-adjoint Lorentzian-signature
operator on concrete carriers (tonight's operator lane); the Higgs stress tensor
sources gravity (`HiggsHilbertStress`). Open: a finite Regge/Benincasa-Dowker
action whose variation gives Einstein/Regge dynamics, and deriving the BD
coefficients from null-edge axioms rather than importing them. Codex's lane.

## Item 9 - Mass-to-matter / Yukawa frontier

STATUS: **MECHANISM + CP STRUCTURE EXTENSIVELY DERIVED** (correcting an earlier
under-claim); mass VALUES OPEN.
On re-audit (2026-07-17), item 9 is far more landed than first credited. Landed,
kernel-checked (standard-three guards), NOT sorry/native:
- **Mass = null-edge disagreement**: `MassNullDecomposition`
  (`massSq_eq_two_null_disagreement`, `det_eq_null_edge_disagreement`) - the
  finite mass functional IS the determinant/null-edge disagreement; plus
  `NullEdgeSpinorSoldering` mass = Plucker area, the mass-energy bound
  (`MassEnergyBound.det_le_half_trace_sq`), and the particle-mass master mesh
  (`ParticleMassMechanismMasterCapstone`, `AllMassGrandMeshCapstone`).
- **CP structure**: the finite Kobayashi-Maskawa suite (`FiniteKMCP`,
  `KMPhaseCounting`, `KMFlagship`, `KMC3FlagshipCapstone`) - a
  rephasing-invariant Jarlskog plaquette, the `N = 2` no-go, an exact unitary
  `N = 3` Jarlskog witness (`J = 6912/78125`), the incidence/corank physical
  phase count `(N-1)(N-2)/2`, and the SHARP THRESHOLD
  `cp_possible_iff : 0 < ckmPhysCP N <-> 3 <= N` (CP violation REQUIRES three or
  more families), plus the neutrino CP/seesaw bridge (`NeutrinoCPSeesawBridge`).
These are MECHANISMS and STRUCTURE, kernel-checked. Still OPEN (the true frontier,
over-claim-prone): deriving the specific mass RATIOS / Yukawa eigenvalues. The
exceptional-Jordan `J3(O)` eigenvalue -> mass-ratio hooks (Singh et al.) and the
octonionic-flavour convergence (Gupta-Teli-Singh 2606.27836) are the leads; no
numeric mass value is claimed anywhere.
LANDED (2026-07-17, Aristotle 0bb218ae, kernel-verified): the STRUCTURAL cubic
characteristic equation of `h3(O)` (`PhysicsSM/Draft/H3OCharacteristicEquation.lean`,
`X^3 = tr(X)X^2 - sigma(X)X + det(X)1`), whose three real eigenvalues are the
algebraic "three generations" of the DVT/Baez reading - a structural identity
`[interp]`, explicitly NOT a mass-value prediction. NB the repo's J3(O)/`H3O`
+ DVT automorphism/structure-group suite (`PhysicsSM/Algebra/Jordan/*`) is already
extensive; this adds only the missing cubic-spectrum identity.

## Item 10 - Grand-mesh capstone

STATUS: **v1 DERIVED, growing**.
Landed: `PhysicsSM/Draft/NullEdge/NullEdgeDerivationGrandMesh.lean` co-certifies
the derived chain (soldering + 3 bridges; su(2)_L; electroweak U(2); SU(5)
hypercharge) in one guarded module. To extend with items 1 (chirality), 4
(triality), 7 (dimension) as they consolidate.

## Honest summary

DERIVED (kernel, landed): item 3 (SU(5) unification), item 7 (algebraic 3+1),
item 10 (capstone v2), item 1 (chirality mechanism CORE + the `1(+)2(+)1` isospin
rep content with Casimir spin `j = 0` singlet / `j = 1/2` doublet), item 4 CORE
(Z3 family symmetry), and - on re-audit - the bulk of item 9's MECHANISM and CP
STRUCTURE (mass = null-edge disagreement; the finite KM/CP suite incl. the sharp
three-family CP threshold `cp_possible_iff` and the exact `N=3` Jarlskog witness).
CONSTRAINED with a cited import: item 5 (composition -> Hurwitz -> division
algebra). OPEN research targets (codex's GR lane or substantial builds): items 2
(octonionic realization on the actual states), 6 (finite Malament), 8 (Einstein
dynamics), the mass VALUES of item 9, and the deep remainders of 1, 4, 5.

Two independent landed routes now converge on THREE generations: the `Z3`
triality orbit (item 4) and the KM CP threshold `0 < ckmPhysCP N <-> 3 <= N`
(item 9's phase count).

No physical mass number is predicted anywhere. "We derive the Standard Model and
general relativity" remains true only in the graded sense above: the MECHANISMS
and much of the GAUGE, FLAVOUR/CP, and DIMENSIONAL structure are derived or
constrained; the specific internal algebra, the mass VALUES, the finite
gravitational dynamics, and the full order->geometry theorem remain supplied,
imported, or open.
