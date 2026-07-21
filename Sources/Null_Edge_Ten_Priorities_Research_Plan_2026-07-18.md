# Null-Edge Program - Ten-Priority Research Plan (2026-07-18)

Status: PLANNING document (no claims). Claims are governed by
`Sources/Null_Edge_Ten_Ambitious_Goals_Status_2026-07-17.md` (the status map);
this plan governs *what to attempt next and how*. Conventions are governed by
`Sources/Dixon_CxHxO_Convention_Reference.md` (read before touching the weak
sector) and `docs/NULLSTRAND.md`. Claim calculus: `T` (source-verified theorem),
`T|H` (conditional on displayed hypotheses), `M` (machine-verified,
program-internal), `C` (pre-registered conjecture with gate and kill-condition);
originality tags `[orig]/[comp]/[import]/[interp]`.

Written after the 2026-07-17/18 overnight run. Verification discipline for this
document: every "landed" statement below is either (V) kernel-verified in-repo
during the 07-17/18 sessions, or (L) recorded in `AutonomousLab/state/LEDGER.md`
/ the status map with its own verification note. Nothing here outruns those.

---

## 1. Strategic frame

The program is two kernel-checked towers plus a hinge:

- **SM tower** (division algebras): colour `Cl(6)` ideal + ladder CAR (V),
  electroweak shadow su(2)_L / U(2) / SU(5) hypercharge (L), chirality
  projector + RH=singlets (V), and - new overnight - the `C(x)H(x)O` Dixon
  substrate with the H-unit Clifford structure (V:
  `PhysicsSM/Draft/NullEdge/DixonAlgebra.lean`).
- **GR tower** (causal order / null edges): rank-four Lorentz carrier lane (L),
  and - new overnight, codex - the finite Palatini variational identity
  `stationarity <-> link Euler + mixed Einstein` (V:
  `NonlinearLorentzPalatiniEinsteinBridge/Response`, builds kernel-clean,
  standard-three guards).
- **Hinge**: spinor soldering capstone + Plucker mass-area (L),
  `DivisionDimensionSelection` (C selects 3+1) (L), the mass-mechanism suite (L).

Three kinds of moves, in priority order within each lane:

- **Closures**: turn the last supplied tables into theorems (P1, P4, P6, P7).
- **New headlines**: newly buildable, community-exciting results that resolve
  recognized obstructions (P2 signature-from-H, P3 proton-decay blocking, P8
  finite Einstein dynamics, P9 finite Malament).
- **The crown**: does the causal substrate *force* the algebra menu (P10)?

Sequencing DAG (arrows = "feeds"):

```text
P2 (Dirac gammas) --> P1 (weak CAR, reading B) --> P4 (Cl(10) ideal) --> P3 (proton decay)
P1 (reading A) ----/                                       |
P6 (Hurwitz) ----------------------------------------> P10 (forcing)
P7 (h3(O) spectral) ---------------------------------> P10
P5 (triality) independent (needs Dixon substrate only)
P8, P9 (GR, codex lane) parallel; hinge audits both ways
```

Resourcing model: 2-3 Aristotle jobs in flight continuously; Claude self-builds
probes, definitions, and audits; codex owns P8/P9 execution with Claude hostile
review; cross-family review binding both directions.

---

## 2. The ten priorities

### P1. Close the electroweak realization ("the weak force is left-handed" on the actual states)

**Objective.** Kernel-check Furey eq-31's Cl(4) CAR for the weak ladders
`beta_1 = (1/2)(-i_2 + i i_1 tau_1)`, `beta_2 = omega‡ i i_1` as OPERATORS on
the Dixon algebra, then the su(2)_L generators `T_j = tau_j (1/2)(1+i_3)`
(eq 35), then close `T_+ = TPlusEnd` against the abstract uniqueness handle,
ending with the Fig-4 theorem: SU(2) acts on states of a single chirality
automatically, with no projector imposed by hand. Claim target: `M` upgrading
the status-map electroweak row from supplied to derived.

**Landed base.** (V) Dixon substrate + H-unit anticommutation
(`DixonAlgebra.i1_i2_anticomm`); (V) faithful eq-30 elements + `conjH`
(`DixonWeakLadders.lean`); (V) the element-level like-CAR FAILS
(`betaH_like_anticomm_ne_zero`, `{beta_1,beta_2}_element = 1/2`), so the CAR is
an operator relation; (V) pre-registered conjecture file
`DixonWeakCARConjecture.lean` with reading (A) right-action-on-ideal
(`v_w = beta_1‡ beta_2‡ beta_2 beta_1`, `L = v_w Cl(4)`, eq 32 - a minimal
RIGHT ideal), reading (B) bar-operator fallback, and a kill-condition; (L)
abstract su(2)_L shadow (`WeakIsospinTwoModeSU2Aristotle`,
`WeakIsospinRepContent` 1(+)2(+)1, `WeakIsospinChiralityProjector`,
`WeakIsospinLadderDerived.TPlusEnd_unique`).

**Plan.**

1. Cheap discriminator probes (self-build): compute the four ideal basis
   states `v_w`, `v_w beta_1‡`, `v_w beta_2‡`, `v_w beta_1‡ beta_2‡` as
   explicit Dixon elements; kernel-test reading (A)'s three conjecture
   statements on each basis state separately (finite `norm_num`/`simp`
   computations, one coordinate first as a smoke test). This either confirms
   (A) on generators or falls through to (B).
2. If (A) survives generators: hand the full `for all c` statements to
   Aristotle (standalone package; see Aristotle wave table). If (A) dies:
   define the bar-operator forms on Dixon (`Lmul`/`Rmul` at Dixon level -
   small self-build extension of `DixonLeftRightAction`), re-run step 1 for
   (B). If both die: the kill-condition fires - the eq-30 translation is
   wrong; re-derive from the PDF (sign/factor/H-triple/parenthesization
   audit) before any further CAR attempt.
3. Daggered CARs: `{beta_i‡, beta_j‡} = 0` and the mixed `delta_ij` rows,
   same route.
4. Build `T_1, T_2, T_3` (eq 35; note `(1/2)(1+i_3)` uses the H-unit `i_3` -
   the chirality projector lives in the H factor). Prove the su(2) brackets
   on the ideal and the eq-36 rep content `L ~ 1 (+) 2 (+) 1`.
5. Close `T_+ = TPlusEnd` via `TPlusEnd_unique` (the uniqueness handle makes
   this a matching problem, not a search problem).
6. The Fig-4 theorem (the headline): `T_j` annihilates the RH slots (`V_R`,
   `E-_R` - the 1's) and preserves the LH doublet, i.e. single-chirality
   action with no imposed projector. Finite check on the ideal basis.
7. Status map + capstone updates; cross-family review (codex) on semantic
   alignment before promoting the row.

**Aristotle strategy.** One standalone package per CAR reading (the 7-file
dependency chain `Octonion.Basic -> ComplexOctonion -> Conjugation ->
LadderOperators -> DixonAlgebra -> WeakBetaLaddersFromColor -> DixonWeakLadders`
is clean; copy it into the package). Brute `norm_num` over 4-to-6-fold
non-associative products will melt - instruct Aristotle to factor through the
landed colour-CAR and idempotent lemmas (`LadderOperators`,
`MinimalLeftIdeal`).

**Kill-conditions (pre-registered).** (i) Both readings refuted on generators
=> translation error, stop and re-derive; a kernel refutation is a real
result and gets recorded, not patched. (ii) `T_+` matches no `TPlusEnd`
candidate => the abstract shadow and the concrete realization disagree;
that is a finding about the shadow, escalate to review.

**Success.** All eq-31 rows + eq-35/36 + Fig-4 statement kernel-checked with
standard-three guards; status-map electroweak row upgraded; capstone grown.

---

### P2. Minkowski signature from the quaternions (Dirac algebra as bar operators)

**Objective.** Build eq-13's Dirac generators as bar operators on the Dixon
substrate - `gamma^0 = 1|i_1`, `gamma^1 = i_1|i_2`, `gamma^2 = i_2|i_2`,
`gamma^3 = i_3|i_2`, `(x|y) z = x z y` - and kernel-check the full Clifford
table `{gamma^mu, gamma^nu} = 2 eta^{mu nu}`. The headline: the Lorentzian
signature (1,3) EMERGES from `C(x)H`; it is not an input. Claim target: `M`
finite identity, `[comp]` (construction from Furey [46] sec 4.7),
normalization `[orig]`.

**Landed base.** (V) Dixon algebra with H-units; (V) `DixonLeftRightAction`
`Lmul/Rmul/bar` scaffolding at `ComplexOctonion` level; (V) eq-13 extracted
verbatim from the PDF (p. 5). (L) `SL2CLorentzAction` + soldering capstone for
the downstream connection.

**Plan.**

1. Lift `Lmul`/`Rmul`/`bar` to `Dixon` (self-build; the H-slot shuffles are
   4x4 coefficient permutations with signs - mechanical).
2. Define the four `gammaMu : Dixon -> Dixon` bar operators.
3. Kernel-compute the 10 anticommutators `{gamma^mu, gamma^nu}` as operator
   identities (`for all z`, coordinate `ext` + the Dixon `mul` simp set).
   IMPORTANT discipline: compute first, READ OFF the signature, and only then
   pin `eta` in the docstring - do not assume `(+,-,-,-)` in advance.
   Cross-check the resulting convention against PhysLean's gamma conventions
   (`lean-explore packages=["Physlib"]`) and record the bridge in the
   convention reference doc.
4. Chirality: `gamma^5` as right multiplication by `-i i_3` (per [46] sec
   4.7 as cited in the PDF p. 4); check `(gamma^5)^2 = 1`,
   `{gamma^5, gamma^mu} = 0`, and that its eigenspaces are exactly the
   Psi_L/Psi_R ideals (eq 8/9).
5. Connect to the hinge: the bar-operator Lorentz generators
   `L = exp(r_j i_j + b_j i i_j)` acting as `Psi_L -> L Psi_L`,
   `Psi_R -> L* Psi_R` (p. 4), against the landed `SL2CLorentzAction`.
6. Convention doc + status map updates.

**Aristotle strategy.** Probably self-buildable (each identity is a finite
4x4-with-signs computation over `ComplexOctonion` scalars); if the operator
`ext` blows up, one standalone job for the anticommutator table.

**Kill-conditions.** If the computed table is NOT `2 eta` for any signature
(e.g. off-diagonal terms survive), the eq-13 transcription or the Dixon
Hamilton conventions are misaligned - stop, audit against the convention doc,
record. Do not tune signs to force the answer.

**Success.** Ten guarded anticommutator identities + `gamma^5` suite; a
one-paragraph "signature from H" note added to the status map; unblocks P1
reading (B) and the P4 Cl(10) layer.

---

### P3. The proton-decay blocking theorem (division-algebraic selection rule)

**Objective.** Formalize the paper's central physical claim (eq 37-42): the 24
SU(5) ladder-symmetry generators split into 12 "mixing" generators
`A_j‡ B_k + B_k‡ A_j`, `i A_j‡ B_k - i B_k‡ A_j` (eq 40) and 12 non-mixing
ones (eq 41: Lambda_1..Lambda_8 -> SU(3)_C; eq 42: I|T_1..T_3 -> SU(2); plus
number-operator U(1)s). Prove, kernel-checked: (i) the non-mixing set closes
as a Lie algebra `su(3) (+) su(2) (+) u(1)`; (ii) on the one-generation ideal
(P4), the eq-40 generators induce exactly the quark-slot <-> lepton-slot
(baryon-number-violating) transitions; (iii) the conditional theorem `T|H`:
IF conceptually distinct algebraic actions do not mix (the model's stated
principle, `[interp]` hypothesis H), THEN the realized symmetry is
`SU(3) x SU(2) x U(1) / Z_6` and the B-violating transitions are absent.

**Honest boundary (pre-registered).** We do NOT prove protons are stable. We
prove an algebraic selection rule conditional on H. The claim label is
`T|H + [interp]`, stated in exactly that form in every docstring. This is
still the community headline: minimal SU(5) is ruled out BY proton decay;
this model keeps SU(5)'s structure while excluding precisely those
generators.

**Landed base.** (V) eq 37-42 extracted verbatim (pp. 9-10), including
`A_i = a_i|I`, `B_j = i e_7|beta_j`, `v_t = ... = v_c|v_w` (eq 38), the
16-slot ideal (eq 39), and both generator families. (L) SU(3) ladder symmetry
+ `ColorTripletFundamental`; (L) `SU5HyperchargeUnification` (the
abstract-level SU(5) row).

**Plan.**

1. After P4 lands the operator layer: define A-type and B-type bar operators
   and the 24 generator candidates as endomorphisms.
2. Bracket closure of the non-mixing 12 (+U(1)): finite computations;
   compare structure constants against the landed abstract su(3)/su(2)
   modules.
3. Transition census: each eq-40 generator applied to each of the 16 ideal
   slots; kernel-check the induced slot map crosses the quark/lepton
   partition. (This is where "these are the proton-decay directions" becomes
   kernel fact rather than prose.)
4. State and prove the conditional reduction theorem; hostile review by
   codex specifically against over-claim mode "docstring-outruns-kernel."

**Aristotle strategy.** Steps 2-3 are large finite computations on a 32-dim
complex module - well-suited to one or two standalone jobs once P4's
definitions exist.

**Kill-conditions.** If the non-mixing set fails to close, or eq-40
generators do NOT map across the partition, the operator translation is wrong
(most likely the `i e_7` colour slot) - stop and re-ground against the PDF.

**Success.** The three numbered results guarded; a status-map row "proton
decay blocked `T|H`"; manuscript paragraph drafted with the exact conditional
phrasing.

---

### P4. One generation as a single object: the Cl(10) minimal ideal

**Objective.** Construct `v_t = v_c|v_w` (eq 38) and the 32-C-dimensional
minimal left ideal `S = Cl(10) v_t` (eq 39) with all 16 particle slots and
antiparticles on the Dixon substrate, and re-verify IN ONE OBJECT: the landed
hypercharge assignments, anomaly-trace-zero, and the SU(5) -> SM branching.
Claim target: `M`; the natural grand-mesh capstone growth.

**Landed base.** (V) colour idempotent `v_c` = `MinimalLeftIdeal.omega`
`(1 - i e_111)/2` with idempotence + annihilation + membership lemmas; (V/P1)
weak vacuum `v_w` (`DixonWeakCARConjecture.vw`); (V) eq 37-39 verbatim; (L)
`ElectroweakU2FromLadders` exact SM charges, `SU5HyperchargeUnification`
anomaly traces, `ConjugateIdeal` antiparticle structure.

**Convention guard (recorded to prevent a known re-confusion).** The
operators `B_j = i e_7|beta_j` live at the **Cl(10) layer** (eq 37). The
**Cl(4) weak layer** (eq 29-31) does NOT use `i e_7`. An earlier design-note
conflation put the `B_j` form at the weak layer; both layers are now
correctly grounded - keep them separate.

**P4 pre-registered question (2026-07-18, forced by the composition
resolution).** The anti-Fock element dictionary (`DixonWeakCARTau3`:
`tau_3 = 0` as an ELEMENT) means eq 37's bar slots cannot contain the
element `beta_j` (the `beta_1`-element collapses to `-i_2/2`). The Cl(10)
ladder operators must be read in composition semantics:
`B_j = (left-mult by i e_7) o (weak beta_j-hat operator)` - and step 1 of P4
must determine the exact composition order/side against eq 5's right-mult
re-expression (`f e_7` as a left-action chain, 1910.08395) before any CAR
check. A kernel probe of BOTH orderings on the ideal basis is the
discriminator; do not assume.

**Plan.**

1. (After P1 fixes the beta-operator reading.) Define the ten Cl(10) ladder
   operators (eq 37) as Dixon endomorphisms; kernel-check their CAR (eq 21 +
   31 composition - "trivial to confirm" per the paper; verify, do not
   trust).
2. Build `v_t` and the 16 basis states of eq 39 explicitly.
3. Charge audit: electric charge = number operator (paper [50], landed
   abstractly) evaluated on all 16 slots; hypercharge and anomaly sums
   re-verified on the ideal.
4. Branching: the eq-41/42 generators' action slot-by-slot, matching
   `1 (+) 5* (+) 10 (+) 10* (+) 5 (+) 1` and the SM decomposition.
5. Grow `NullEdgeDerivationGrandMesh` to co-certify the ideal + its charge
   table; status map update.

**Aristotle strategy.** Steps 1 and 4 are the heavy finite computations - one
standalone job each, with the P1 package as the base.

**Kill-conditions.** CAR failure at the Cl(10) layer after P1 passed at
Cl(4) => the `i e_7` slot or the `v_c|v_w` split is mistranslated; stop and
re-ground. Any charge mismatch against the landed tables is a hard stop
(one of the two is wrong - find which before proceeding).

**Success.** The ideal exists in Lean with guarded CAR + charge + branching
suites; capstone co-certifies; P3 unblocked.

---

### P5. Three generations with correct rep content (triality, item 4 deep)

**Objective.** Upgrade the landed Z_3 generation counting to rep content:
either (a) Spin(8) triality permuting the three 8-dim reps `8_v, 8_s, 8_c`
realized on the Dixon substrate, or (b) clean-room formalization of Furey's
dedicated three-generation construction (the 2018 one-algebra paper,
reference [51] "Three generations, two unbroken gauge symmetries, and one
eight-dimensional algebra"). Claim target: `M` for whichever route survives
contact with the kernel; a mapped no-go is an acceptable outcome.

**Landed base.** (L) `TrialityFamilySymmetry` (Z_3 single orbit); (L)
`KMPhaseCounting.cp_possible_iff` (CP needs >= 3 families - the independent
"why three" pincer); (V) Dixon substrate; (V) `TrialityCompanions` octonion
infrastructure exists in-repo.

**Plan.**

1. Literature grounding FIRST (the P1 lesson): WebFetch the actual [51] PDF,
   pdfplumber, extract the construction verbatim; record in a design note.
2. Feasibility fork: (a) needs a workable finite presentation of the triality
   automorphism (check Mathlib + PhysLean for `Spin(8)`/triality - almost
   certainly absent; then a concrete matrix/octonion realization per
   Baez 2002 sec 2.4, via `ConventionBridge`); (b) needs only Cl(6)
   machinery the repo already has. Pick by tractability after step 1;
   pre-register the choice.
3. Target statement: an order-3 algebra automorphism whose orbit carries the
   FULL one-generation rep content (not just a label), acting compatibly
   with the SU(3) sector.
4. Connect to P7: the three h3(O) eigenvalues as the same threeness
   (`[interp]` bridge, kept in prose until a theorem exists).

**Kill-conditions.** If neither route produces rep-content replication
kernel-side, record the precise obstruction (e.g. "triality mixes the gauge
action") as a mapped frontier - this is publishable program knowledge, not a
failure to hide.

**Success.** Either the rep-content triality theorem (guarded) or a
documented no-go with the exact failing statement.

---

### P6. Hurwitz classification (the last supplied algebra piece)

**Objective.** Kernel-check: every finite-dimensional composition algebra
over R with positive-definite norm has dimension 1, 2, or 4, or 8
(first target), and is isomorphic to R, C, H, or O (stretch). This converts
the "why the octonions" story from constrained to derived and is the
load-bearing input to P10. Claim target: `T` (textbook mathematics,
`[import]` statement, `[comp]` formalization).

**Landed base.** (V) concrete tower bracketed both directions:
`CompositionDivision` (composition -> division for O),
`SedenionZeroDivisors` + `sedenion_composition_fails` +
`octonion_not_associative` (doubling past O fails),
`CayleyDicksonQuaternion.cd_norm_multiplicative` (doubling H works). (L)
`CompositionAlgebra.compAlg_no_zero_divisors` abstract layer exists.

**Plan.**

1. Search first (`lean_leansearch` / `lean_loogle` / `lean-explore`, incl.
   PhysLean): Hurwitz is very likely absent from Mathlib at our pin, but
   quadratic-form and Clifford infrastructure
   (`Mathlib.LinearAlgebra.QuadraticForm.*`, `CliffordAlgebra.*`) is rich -
   inventory what the proof can lean on before writing anything.
2. Abstract skeleton (self-build): `structure RealCompositionAlgebra` (unital
   f.d. R-algebra, pos-def quadratic norm, `N(xy) = N(x) N(y)`), polarized
   bilinear form, conjugation `x-bar = 2<x,1>1 - x`, and the standard
   identity toolkit (Osborn/Schafer lemma chain).
3. The doubling lemma (the crux, one focused Aristotle job): a proper unital
   composition subalgebra `A` with `a` orthogonal to `A`, `N(a) != 0`, forces
   `A (+) aA` to be a composition subalgebra with the Cayley-Dickson product,
   and doubling preserves composition IFF `A` is associative.
4. Dimension ladder: iterate doubling from `R 1`; associativity is lost
   exactly at dimension 8 (the repo's concrete
   `octonion_not_associative` is the model statement); conclude
   `dim in {1,2,4,8}`.
5. Stretch: isomorphism to the four concrete algebras (needs
   basis-transport work; schedule only after 4 lands).

**Aristotle strategy.** Steps 3-4 as a Mathlib-only standalone campaign (2-3
jobs); this is the single best "top Lean prover" target in the plan -
classical, self-contained, hard.

**Kill-conditions.** None mathematical (the theorem is true); the risks are
scope creep (cap step 5) and infrastructure mismatch (if Mathlib's quadratic
form API fights the unital-algebra packaging, record the friction and
re-scope to a bespoke structure).

**Success.** `dim in {1,2,4,8}` guarded; status-map item 5 flips to derived
(classification-strength noted); P10 gains its load-bearing input.

---

### P7. Mass-ratio invariants from h3(O) (item 9, strictly structural)

**Objective.** With the characteristic equation landed, develop the spectral
side: real eigenvalue existence, `(tr, sigma, det)` as the complete
symmetric-invariant triple, and dimensionless mass-ratio invariants as
functions of them - connecting to the landed KM/CP suite (same invariant
algebra as Jarlskog). Discipline: structural theorems ONLY; every statement
that could be read as a numeric mass prediction is pre-registered with a
gate and kill before it is attempted. Claim target: `M` structural;
`[interp]` kept in prose.

**Landed base.** (V per ledger + guard) `H3OCharacteristicEquation`
`X^3 = tr X^2 - sigma X + det 1` (Jordan product, standard-three); (L) the
KM/CP suite (`FiniteKMCP` exact N=3 Jarlskog, `KMPhaseCounting`); (L) the
mass-mechanism suite; (L) `PhysicsSM/Algebra/Jordan/*` J3(O)/DVT
infrastructure (inventory before building - the repo is mature here).

**Plan.**

1. Real-spectrum lemma: the characteristic cubic of a Jordan-hermitian
   element has three real roots (via discriminant >= 0 or IVT + symmetry;
   check what `Mathlib.Analysis.SpecialFunctions.Polynomials`/cubic API
   offers). Aristotle candidate.
2. Invariant completeness: `(tr, sigma, det)` determine the eigenvalue
   multiset (elementary symmetric functions; mostly Mathlib
   `Polynomial.roots` plumbing).
3. Ratio invariants: define the two dimensionless invariants (e.g.
   `sigma^3/det^2`-type normalized combinations), prove scale-covariance
   `X -> t X` transforms `(tr, sigma, det)` as `(t, t^2, t^3)` so the ratios
   are scale-free - the structural statement behind "mass RATIOS, not
   masses."
4. Bridge lemma to KM: state (as `C`, gated) the conjectured relation
   between the h3(O) invariants and the landed Jarlskog invariant; attempt
   only after 1-3.

**Kill-conditions.** Any step requiring an unjustified identification of
eigenvalues with physical masses stops at an `[interp]` prose note. The
pre-registered kill for step 4: if the invariant algebras do not map, record
the mismatch.

**Success.** Steps 1-3 guarded; item 9 row upgraded from
"mechanism landed / values open" to "mechanism + structural invariants
landed / values open."

---

### P8. GR: from Einstein identity to Einstein dynamics (codex lane; Claude complements)

**Objective.** Extend the landed finite Palatini identity to physics: (a)
Levi-Civita/torsion selection from the connection Euler equation; (b) lattice
Bianchi/curvature identification for the extracted plaquette field; (c) the
vacuum-Weyl gravitational-wave sector; (d) matter coupling - the soldered
SM-branch Dirac operator as stress-energy source, targeting
`joint stationarity <-> Einstein equation with source`. Claim labels stay
"finite identity" until a continuum statement is actually proved.

**Landed base.** (V) `palatiniDensityFirstVariation_eq_det_mul_mixedEinstein`
and `nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein`
build kernel-clean with standard-three guards; (V) `VacuumWeylCurvatureTarget`
and `PeriodicVacuumWeylMeanObstruction` build; (V - problem)
`PeriodicVacuumWeylNullWave.lean` is build-broken (syntax error line ~150 +
heartbeat timeouts), untracked/in-progress.

**Coordination protocol (this is codex's execution lane).**

1. Claude sends codex a message flagging the broken module (do not
   unilaterally rewrite an in-progress codex file).
2. Claude's hostile audits on request: the Einstein-bridge semantic audit
   (six-coordinate bivector conventions vs the project Hodge/Krein
   conventions) and each Weyl-sector landing, against the four over-claim
   modes - especially "false shape" (a stationarity identity is not yet a
   dynamical law) and Krein-audit boundaries per `docs/NULLSTRAND.md`.
3. Claude's constructive complement is (d) ONLY (no file overlap with
   codex's (a)-(c)): define the finite Dirac action via the soldering
   capstone's `sum_a c(alpha^a) nabla_ell_a` architecture on the Palatini
   lattice, compute its coframe first variation, and state the sourced
   stationarity theorem. Stage 1 is the free (quadratic) fermion action
   coupling; matter self-interaction is out of scope.

**Kill-conditions.** Per NULLSTRAND: no continuum-Riemann claims from finite
identities; Krein self-adjointness is not positivity; retardedness is not a
no-doubling proof. Any wave-sector claim must display its mean/obstruction
hypotheses (codex's own `PeriodicVacuumWeylMeanObstruction` pattern).

**Success.** (d) sourced-Einstein theorem guarded on my side; (a)-(c) rows
advanced by codex with Claude audit sign-offs; the broken module resolved by
its owner.

---

### P9. Finite Malament completion (order -> geometry; codex lane + the scale half)

**Objective.** Complete both halves of the Malament split on finite carriers:
(i) causal order supplies the conformal class (codex's
rank-four/shell-angular route); (ii) decorations supply exactly the scale
(`BareGraphScaleReconstruction` direction). A finite Malament theorem with an
explicit decoration-to-scale reconstruction would be the causal-set-adjacent
headline.

**Landed base.** (L) corrected-pairing difference-operator chain +
`HasLorentzianInertia` five-event witness (independently reviewed); (L)
`RankFourCarrierProbeSector` + sector API; (V - in tree)
`BareGraphScaleReconstruction.lean` draft is modified/in-progress; HANDOFF
explicitly requests Claude's hostile audit of the marked-Alexandrov
shell-angular 1+3 design BEFORE codex assigns seeds.

**Plan.**

1. Deliver the requested audit first (it is the named blocker): check the
   three pre-run gates (predecessor shell antichain; disjoint
   radial/shell supports; conditional (+---) corrected Gram on independent
   triples) as STATEMENTS - are they the right gates, are they
   non-vacuous, do they exclude the known degenerate seeds?
2. Scale half: sharpen `BareGraphScaleReconstruction` into a theorem of the
   form "order isomorphism + decoration data => unique edge-scale up to
   global factor," with the AGENTS.md guardrail displayed (a bare graph does
   NOT canonically supply a tetrad - decorations are declared inputs).
3. Joint capstone (after both halves): finite conformal-class + scale =>
   finite metric reconstruction statement, claim-labeled "reconstruction."

**Kill-conditions.** If the shell-angular gates cannot exclude the R4/R5
degenerate seeds that killed the frozen-atlas architecture, say so in the
audit and do not let seeds be assigned. The scale theorem must not smuggle a
frame via decoration choice - vacuity check against an explicit two-scale
model witness.

**Success.** Audit delivered with pass/fail per gate; scale theorem guarded;
the joint reconstruction statement drafted with honest labels.

---

### P10. The crown: does causal structure force the algebra menu?

**Objective.** Prove or refute, in stages, the forcing chain: null-edge
substrate + multiplicative mass functional => finite-dimensional composition
algebra structure on the fiber => (by P6 Hurwitz) fiber in {R, C, H, O} =>
(by the landed `DivisionDimensionSelection`) C(x)H spacetime sector in 3+1,
with O as the internal factor. Either a forcing theorem or a precisely mapped
impossibility - both satisfy the north star. Claim target: starts as `C`
with displayed gates; every stage independently labeled.

**Landed base.** (L) mass = Plucker area, Lorentz-invariant (soldering
capstone); (L) mass-area composition behavior recorded as the item-5
CONSTRAINT (status map); (L) `DivisionDimensionSelection` (C -> d=4); (V/P6)
the concrete R,C,H,O tower results.

**Plan (stage-gated; each stage is its own pre-registered attempt).**

1. **Gate statement (prose -> Lean).** Write the exact hypothesis: what
   object does the null-edge substrate hand the fiber (a normed
   R-module with a product induced by edge composition? over which
   operations is the mass functional multiplicative?). This is a design
   task; the P1-P4 operator layer will inform what "edge composition"
   algebraically is. Deliverable: a design note with the candidate
   `H_forcing` hypothesis displayed, reviewed hostilely by codex.
2. **The multiplicativity theorem.** Prove `H_forcing => N(xy) = N(x) N(y)`
   for the fiber product (upgrading the status-map constraint to a theorem),
   or find the counterexample model. This is the genuinely novel
   mathematical content `[orig]`.
3. **Compose with P6**: fiber in {R,C,H,O} (pure plumbing once 2 and P6
   exist).
4. **Selection**: spacetime factor = C(x)H via the landed dimension
   selection; the internal-factor question ("why O and not H internally")
   stated honestly as the residual open choice unless a maximality argument
   (largest composition algebra) is formalized as the selector - which P6
   makes available.
5. **Impossibility branch**: if stage 2 fails structurally (multiplicativity
   requires importing the algebra), map the frontier: the minimal extra
   axiom that closes the gap, proved minimal by exhibiting models with and
   without.

**Kill-conditions.** Stage 2 counterexample => publish the mapped frontier
(stage 5); no silent weakening of `H_forcing` to make stage 2 pass - any
hypothesis change goes back through stage-1 review.

**Success.** Stage 1 note + stage 2 outcome (theorem or counterexample)
within this plan's horizon; stages 3-4 if 2 lands. Either way the program
gains its sharpest statement of what is derived vs chosen.

---

## 3. Aristotle first wave (keep 2-3 in flight)

| # | Job | Type | Base package | Blocked by |
|---|-----|------|--------------|------------|
| J1 | P1 reading-(A) CAR on the ideal (3 statements + daggered rows) | standalone | 7-file octonion/Dixon chain + `DixonWeakCARConjecture` | P1 step-1 probes |
| J2 | P6 doubling lemma (composition subalgebra + Cayley-Dickson) | standalone, Mathlib-only | fresh skeleton | nothing - submit early |
| J3 | P2 gamma anticommutator table (only if self-build stalls) | standalone | Dixon chain + bar operators | P2 steps 1-2 |
| J4 | P7 real-spectrum cubic lemma | standalone, Mathlib-only | `H3OCharacteristicEquation` defs | nothing |
| J5 | P4 Cl(10) ladder CAR | standalone | P1 package + eq-37 defs | P1, P4 step 1 |

Submission discipline (unchanged): context pack via
`Scripts/aristotle/make_context_pack.py` for non-tiny jobs; verify every
return VERBATIM in-repo before citing (mid-run snapshots do not
kernel-check); `COMPLETE_WITH_ERRORS` is often a false alarm - always check
the artifact.

## 4. Continuous disciplines (apply to every priority)

- Kernel first: standard-three (or fewer) axiom guards on every flagship;
  the guard build runs before any "landed" claim.
- Honest grading both directions; audit every landing (mine and codex's)
  against the four over-claim modes (vacuity, hollow telescoping,
  docstring-outruns-kernel, false shape).
- Ground every hard target in the actual paper PDF (WebFetch -> pdfplumber);
  never garbled OCR. The costliest errors this run were convention errors -
  the convention reference doc is authoritative and gets updated the moment
  a new convention is pinned (P2's `eta`, P4's Cl(10) layer).
- Draft `s o r r y` only as documented handoffs with proof plans;
  pre-registered kill-conditions on every speculative target; a kernel
  refutation is a result.
- Lab hygiene: inbox/leases each cycle; ledger entries per landing; status
  map + capstone growth; full-repo build periodically (note: currently
  blocked by codex's in-progress `PeriodicVacuumWeylNullWave.lean` - flag,
  don't fix unilaterally).
- Repo hygiene: the overnight tree is large and uncommitted; commit
  checkpoints at each landing boundary now that `git add .` works again.

## 5. Cross-references

- Claims: `Sources/Null_Edge_Ten_Ambitious_Goals_Status_2026-07-17.md`
- Conventions: `Sources/Dixon_CxHxO_Convention_Reference.md`,
  `docs/CONVENTIONS.md`, `docs/NULLSTRAND.md`
- Electroweak lane detail:
  `AgentTasks/null-edge-S2b-weak-isospin-from-ladder-design-2026-07-17.md`
  (CORRECTIONs 2-5)
- Capstone: `PhysicsSM/Draft/NullEdge/NullEdgeDerivationGrandMesh.lean`
- Lab state: `AutonomousLab/state/` (HANDOFF, LEDGER, WORK_ITEMS)
- Aristotle mechanics: `docs/ARISTOTLE.md`
