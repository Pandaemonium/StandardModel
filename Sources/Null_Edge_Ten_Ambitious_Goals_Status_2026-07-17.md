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
Forward plan: `Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md` (the
detailed P1-P10 research plan - staged bricks, Aristotle wave, kill-conditions).
This status map remains the claim governor; the plan governs what to attempt.

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

RESOLVED 2026-07-18 (CORRECTION 6 - the operator-vs-element question is
CLOSED by the kernel, and the CAR cores are LANDED):

1. **Transcription fix:** eq 30's `beta_1` uses **`tau_3`** (`= omega omega‡ -
   omega‡ omega`), not `tau_1` (OCR trailing-subscript re-parse). The earlier
   kernel "failures" (`-1/2`, `+1/2` cross-CARs) were the kernel faithfully
   refuting the `tau_1` mis-transcription.
2. **Element semantics dead (kernel):** `DixonWeakCARTau3.lean` - the anti-Fock
   element dictionary (`omega^2 = -v`, `(omega‡)^2 = -v*`, `omega omega‡ =
   omega‡ omega = 0`, hence **`tau_3 = 0` identically** at element level). No
   element-level reading of eq 29-31 is faithful.
3. **Composition semantics landed (kernel):** `CompositionWeakLadders.lean` -
   ladders as nested-left-mult COMPOSITION operators (Furey's own semantics,
   explicit in 1910.08395 p.3). GLOBAL free-variable kernel identities:
   `hatOmega^2 = 0`, `hatOmegaDag^2 = 0`, `{hatTau3, hatOmega} = 0`,
   `{hatTau3, hatOmegaDag} = 0` - the colour cores of ALL eq-31 like/cross
   CARs. The omega-mode plane in the ideal is `span{v, nu}` with `hatTau3`
   grading it `+-1` and squaring to identity there (diagonal-CAR home).

ASSEMBLY LANDED 2026-07-18 (`CompositionWeakCAR.lean`, sorry-free,
standard-three guards, derived ALGEBRAICALLY from the kernel cores - no deep
coordinate expansion): the eq-31 **cross-CARs are GLOBAL operator identities on
`C(x)H(x)O`** (`{betaHat_1, betaHat_2} = 0` - the historically blocked
relation - and `{betaHat_1, betaHat_2-dag} = 0`), like-diagonals
`betaHat_2^2 = (betaHat_2-dag)^2 = 0` global, and the STRUCTURAL diagonals
`{betaHat_2, betaHat_2-dag} = M`, `{betaHat_1, betaHat_1-dag} =
(1/2)(id + lift(tau_3-hat^2))` with `M` (the lifted omega-mode anticommutator)
= identity EXACTLY on the mode plane `span{v, nu}` (kernel atoms
`hatOmegaDag v = 0`, `hatOmegaDag nu = v`) - i.e. ALL of Furey eq 31 holds on
the plane where eq 32 builds the leptonic ideal, and the cross relations hold
everywhere. Also landed: the operator-level COLOUR CAR
(`CompositionColorCAR.lean`, all 21 eq-7 identities as maps - the composition
counterpart of the landed element CAR, foundational for P4/P5).

ENDGAME ADVANCED (2026-07-18, final state): `CompositionSU2.lean` FULLY GREEN
(guards) - the complete eq-35 su(2)_L layer: `hatTau1/hatTau2` mode-plane Pauli
action, **the su(2) bracket relations** `[tau_i, tau_j] = -2i tau_k` on the
mode plane (four kernel theorems), the KERNEL-CORRECTED projector
`P_L = (1/2)(1 + i i_3)` proven idempotent (complex `i` required: bare
`(1+i_3)/2` is NOT idempotent since `i_3^2 = -1`; matches `gamma^5 = -i i_3`;
the `i(cid:6)_k` display-pattern rule is pinned in the convention doc), and
**the Fig-4 theorems** `T1/T2/T3_kills_RH`: for every right-handed state
(`i(z i_3) = -z`), `T_j z = 0` GLOBALLY - "the SU(2) symmetries act
automatically on states of only a single chirality", with NO chiral projector
imposed by hand, as a kernel theorem. EQ-36 LAYER CLOSED (2026-07-18, Aristotle eq36-v2 harvest verified,
`CompositionIdealRepContent.lean` zero sorries + guards): all four `adT3`
gradings kernel-proven via the rank-one closed forms. HONEST VERDICT: the
kernel pattern is `(0, +1, +1, +2)` for `(vwHat, X1, X2, X3)` - the
NUMBER-OPERATOR grading - not the eq-36 isospin doublet pattern
`(0, +1, -1, 0)`; `X2`/`X3` carry prominent kernel-verified correction
reports. Coherent with the rank-one collapse (both betaHats raise toward
the `nu`-line). The isospin-grading realization question is REOPENED with
that diagnosis (candidates: the `-tau3` orientation, a PL-projected
adjoint); the `T_+ = TPlusEnd` closure was separately resolved negatively
by the rank-one structure theorem (above).
`DixonWeakCARConjecture.lean` is a supersession record. Roadmap:
`AgentTasks/null-edge-S2b-weak-isospin-from-ladder-design-2026-07-17.md` (CORRECTION 2-6).

GRADING CANDIDATES TRIPLE-KILLED + SLOT CENSUS LANDED (2026-07-18 night,
overnight saturation run): `IsospinGradingSearch.lean`/`RankOneCore.lean`
kernel-kill all three reopened eq-36 grading candidates (`G_R` grades
`(0,2,2,0)`, `G_PL` `(0,1,1,2)`, normalized rotation `(0,1,1,0)`; half-sum
`X2` action provably non-scalar) - the obstruction is SAME-SIGN on `X1/X2`
throughout, coherent with the rank-one collapse. The eq-39 slot census
(`CompositionTransitionCensus.lean`) lands the five single-excitation slots
with the honest residual `Mix11 slotVL = slotDbar1 + (1/8)-residual`.
S2b CORRECTION 11 is the full record; the colour-supported eq-37 su(2)
realization, the grading family no-go, and the census completion are in
flight (Aristotle 5a6bb408 / bc073521 / 2ccad4a3).

RANK-ONE STRUCTURE THEOREM - `T_+ = TPlusEnd` closure RESOLVED NEGATIVELY,
towers collapse (2026-07-18, `CompositionSuSdBridge.lean`, kernel + guards):
free-`z` structure theorems prove (1) **tower collapse**
`hatOmega = hatOmegaRbDag`, `hatOmegaDag = hatOmegaRb`, `hatTau3R = -hatTau3`
GLOBALLY - the left and right omega-nest towers are ONE operator pair; (2)
**rank one**: `hatOmegaRbDag z = phi(z) . vIdemStar`,
`hatOmegaRb z = psi(z) . vIdem` with explicit head-plane-only functionals -
every image is collinear with one fixed state; (3) `nuState = i . vIdemStar` -
the mode plane IS the idempotent plane. CONSEQUENCE (honest, definitive):
`TPlusEnd`'s table needs three linearly independent images, so NO packaging
(single-ideal, doubled `Su (+) Sd`, any other) realizes it via one-sided
omega-nests - the Jbar no-go and route-A battery zeros are corollaries; the
composition su(2)/CAR/chirality layer is a genuine but exactly-2-dimensional
head-plane theory. Weak isospin on COLOURED states must use colour-supported
operators: the eq-37 `B_j` layer (P4, below), whose `Mix11` witness already
exhibits colour content. CORRECTION 9 in the S2b design note is the full
record.

P7 FLAGSHIP LANDED (2026-07-18, `H3ORealSpectrumUnconditional.lean`, kernel
+ guards): **the UNCONDITIONAL real-spectrum theorem for `h3(O)`** -
`h3o_real_spectrum : every Hermitian 3x3 octonionic matrix has a real triple
(r,s,t) whose elementary symmetric functions are EXACTLY (trace, sigma, det)`
- no discriminant hypothesis - plus `h3o_charCubic_discr_nonneg` (the
"remaining analytic step" flagged in `H3OSpectralInvariants` is now a
theorem). Route (original to this campaign): complex-witness invariant
matching - the char-poly coefficients depend on the off-diagonal octonions
only through the three norms and the real triple product, which are always
realizable by an `h3(C)` witness (free phase + the composition law
`normSq_mul`); Mathlib Hermitian spectral theory finishes. Pieces: Aristotle
d3298b14 (both reduction lemmas, verified verbatim, zero sorries) +
`CubicDiscrForward` (discr = Vandermonde^2) + `H3OSigmaClosedForm`.
Provenance: classical statement Dray-Manogue math-ph/9910004 [WEZ86AZW];
formalization route original. Grade: `M`.

P4/Cl(10) OPENING VALIDATED (2026-07-18, `CompositionCl10Probe.lean`, kernel +
guards): the eq-37 Cl(10) `B_j` operators realized in composition semantics
(`B_1 = L_{i e_7} o betaHat_1`, working ordering (a)) satisfy BOTH probed CAR
slots - the like-anticommutator `{A_1, B_1} = 0` AND the mixed
`{B_1, B_1‡} = delta_11 = 1` (the kernel returned exactly the probe state's
own coordinate - identity action) - for BOTH composition orderings (the eq-37
order is not CAR-discriminated at this level; recorded). P3 EXCLUSION SUBSTRATE COMPLETE BOTH SIDES (2026-07-18 lit-cycle session):
NON-MIXING - the eq-42 electroweak set closes as su(2) on the probe state
(`CompositionSU2NonMixing.lean`: all three brackets `[T_i,T_j] = -2i T_k`,
structural proofs via co/PL commutation + the landed mode-plane brackets) and
the eq-41 Gell-Mann bilinears lie in the `R_{e7}`-commutant as FREE-`z`
theorems (`CompositionRe7Commutant.lean`; Furey-Hughes 2210.10126 selection
principle kernel-live; single ladders are associator-split, in neither
commutant nor anticommutant - witness no-gos). MIXING - both eq-40
generators at `j=k=1` are nonzero with colour-supported witnesses
(`Mix11` value `(e4+ie3)/4`; `MixT11` value `-i` times it - the
sector-rotation 2-plane; `CompositionCl10ProbeExt.lean`, with the `j=2`
CAR block validated). The H-upgrade path (interpretive H -> Re7-commutant
characterization) is designed and partially kernel-validated; the
transition census is an in-flight Aristotle job. The eq-40
proton-decay mixing-generator layer (P3) OPENED on this validated set
(same module): `Mix11 = A_1‡ B_1 + B_1‡ A_1` is kernel-proven NONZERO and
SECTOR-MIXING (witness: the mode-plane state is mapped into the `i_2` `H`-slot
with colour value `(e_4 + i e_3)/4`; `Mix11_ne_zero` guarded) - the exclusion
theorem's target generators exist and provably mix, as concrete kernel facts.

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
REMAINDER SUBSTANTIALLY CLOSED at the Lie-algebra level (2026-07-19 night,
`SU5RepresentationAction.lean`, kernel, integrated green, per-theorem
standard-three): the standard su(5) actions on `5*` (dual `-(A^T)`) and
`Lambda^2(5)` (`A W + W A^T`) are PROVEN Lie-algebra representations
(bracket compatibility), the landed charge tables are their EIGENVALUE data
for the diagonal hypercharge generator (`Y5bar` on the dual basis, `Y10`
pair-sums on the wedge basis - both exact, no convention correction
needed), the rep-level anomaly trace vanishes, and block-diagonal
generators commute with the hypercharge generator. Remaining beyond this:
the GROUP-level (exponentiated) action, if ever needed.

## Item 4 - Three generations

STATUS: **CORE DERIVED**, deep remainder OPEN.
Landed: `PhysicsSM/Algebra/Furey/TrialityFamilySymmetry.lean`. The Z3 triality
family symmetry on the Furey-Hughes roles is order 3, transitive, single-orbit
(`triality_generation_count = 3`) - the Z3 subset S3 = Out(Spin(8)) forcing
exactly three, in one orbit.
GROUNDED 2026-07-18 (plan P5): Furey's dedicated three-generation construction
(arXiv:1910.08395, ACTUAL PDF extracted verbatim) is now the preferred route -
48 explicit states (3 generations x u/d/nu/e with SU(3)_C x U(1)_em charges)
from the FOUR-sector split of Cl(6) by the commuting idempotent pairs
`s = (1+ie_7)/2` (left mult) and its right-mult analogue `S` (re-expressed in
left-action chains via the e_7-redundancy identity eq 4/5). Composition-operator
semantics confirmed at source (p.3), matching the item-2 kernel resolution -
ONE shared infrastructure. Design note + convention-bridge warnings (the paper's
`e_1 e_2 = e_4` basis is NOT the repo XOR basis; bridge before transcribing):
`AgentTasks/null-edge-P5-three-generations-1910-08395-grounding-2026-07-18.md`.
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
OVERNIGHT DELTA (2026-07-19, Aristotle saturation run): the P5 grounding is
now KERNEL-LANDED at the Clifford level - `CompositionCl8Generation`
(six sparse colour generators, L1/L2 left quaternion actions with the
HONEST dictionary correction recorded in the harvest log, Chi volume
operator, twisted G7/G8, explicit 64-case `cl8_table`) plus
`Cl8TrialityAction` (the S3/triality signed-permutation action on the six
colour generators; both signed 3-cycles hand-computed then kernel-confirmed
EXACTLY). This is a THIRD independent landed route to the family-count
structure: explicit S3-invariance of the Cl(8) colour sector. Sigma mirror
(S3 completion + braid relation) in flight as `c41f0c06`; campaign record
`AgentTasks/overnight-aristotle-saturation-2026-07-18.md`.

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
OVERNIGHT DELTA (2026-07-19, Aristotle saturation run): the abstract Hurwitz
classification is now PROVEN AT STAGE 5 - `hurwitz_finrank_mem` (a
finite-dimensional unital composition algebra over a char-0 field with
anisotropic norm has `finrank in {1, 2, 4, 8}`), via the internal
Cayley-Dickson doubling ladder (stage-2 doubling laws, stage-3a
`orthogonal_forces_associative` saturation engine, stage-4a ladder-step
theorems, stage-5 seven-rung assembly; jobs d5b0eac8 / c7b3a57b /
2298aa71 / d315d977). CONDITIONAL on exactly the TWO documented Moufang
holes in stage 2 (closure job `1b045f4b` in flight after a live sign-error
course correction). When Moufang lands and the in-repo merge completes,
the item-5 'supplied' import upgrades to a kernel-checked theorem and the
item is DERIVED end-to-end. Campaign record:
`AgentTasks/hurwitz-campaign-2026-07-18.md`.

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

DEEPENED 2026-07-18 (plan P2 LANDED): **the Lorentzian SIGNATURE now emerges
from the quaternions, kernel-checked** - `PhysicsSM/Draft/NullEdge/
DixonDiracGamma.lean` (sorry-free, standard-three guards) realizes Furey eq-13's
Dirac generators as bar operators on the Dixon algebra (`gamma^0 = 1|i_1`,
`gamma^1 = i_1|i_2`, `gamma^2 = i_2|i_2`, `gamma^3 = i_3|i_2`, `(x|y)z = xzy`)
and proves the FULL Clifford table `{gamma^mu, gamma^nu} = 2 eta^{mu nu}` with
`eta = diag(-1,+1,+1,+1)` (mostly-plus; the kernel computed the signature, it
was not assumed), plus `gamma^5` = right mult by `-i i_3` with `(gamma^5)^2 = 1`
and `{gamma^5, gamma^mu} = 0`. Convention pinned in
`Sources/Dixon_CxHxO_Convention_Reference.md` (PhysLean bridge caution:
mostly-minus differs by `gamma -> i gamma`). The bridge itself is now
KERNEL-EXACT: `DixonDiracGammaBridge.lean` (landed 2026-07-18) proves the full
mostly-minus table for `gammaM^mu = i gamma^mu` (`(gammaM^0)^2 = +1`,
`(gammaM^k)^2 = -1`, off-diagonals 0) algebraically from the mostly-plus table
- either convention can now be consumed without sign transport by hand.
Open: the premises (composition + continuous phase) are physically motivated,
not themselves derived from the bare causal order.
SCOPED 2026-07-18 (night, `DixonSignatureClassification.lean`, kernel): the
Lorentzian signature is an EXISTENCE result for the eq-13 quadruple, not a
uniqueness theorem for the unsigned bar-operator class - the kernel exhibits
a mutually anticommuting `(2,2)` quadruple (`1|i1, 1|i2, i1|i3, i2|i3`,
squares `(-,-,+,+)`; `lorentz_signature_not_forced`, full 16-entry square
table). Any "signature emerges" claim must state the selection principle
that picks the Furey generators; anticommutation alone does not.

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

ADVANCED 2026-07-18 (plan P7 steps 2-3 LANDED, strictly structural):
`PhysicsSM/Draft/H3OSpectralInvariants.lean` (sorry-free, standard-three
guards) - scale covariance of the Freudenthal invariant triple
(`trace/sigma/det` transform with weights `(1,2,3)` under `X -> t X`), the two
DIMENSIONLESS spectral ratios `sigma^3/det^2` and `trace^3/det` proved
scale-invariant (the structural "the spectrum fixes mass RATIOS, not masses" -
`[interp]` confined to prose), and the Vieta bridge (conditional on real roots:
the invariant triple IS the elementary-symmetric data of the three
eigenvalues). The real-spectrum lemma LANDED (2026-07-18): Aristotle J4 proved
`discr >= 0 => three real roots` (IVT + discriminant-factor route), harvested +
VERIFIED VERBATIM at the repo pin (standard-three axiom audit), ported to
`PhysicsSM/Draft/CubicRealSpectrum.lean` with guards, and COMPOSED:
`H3OSpectralInvariants.h3o_real_spectrum_of_discr_nonneg` - three real
eigenvalues whose elementary-symmetric data IS `(trace, sigma, det)`,
conditional only on the displayed discriminant hypothesis. The h3(O)-side
discriminant nonnegativity (true for Jordan-hermitian elements) is the
remaining analytic step, pre-registered as the next P7 target.
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
