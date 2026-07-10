# ARCHITECTURE AUDIT REPORT

Codex audit 02: is this one theory or an organized analogy map?

Auditor stance: hostile but constructive theory-architecture review. No files
were edited and no full Lean build was run. Sources read: the manuscript
(`Sources/Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex`), the three Pro
essays (`A_broader_physics_of_finite_null_information.md`,
`A_moduli_theory_of_self-decoding_null_information.md`,
`Toward_a_complete_finite_null-information_theory.md`), `Null_Edge_Future_Directions.md`,
`RUN_PLAN.md`, `THEORY_COMPLETION_MATRIX.md`, `MANUSCRIPT_CLAIM_MATRIX.md`,
`SIMULATION_BENCHMARKS.md`, `DOCUMENT_INTAKE_MAP.md`, `COLLABORATOR_BRIEF_2026-07-10.md`,
and the 18 shipped Lean files under `PhysicsSM/`.

--------------------------------------------------------------------------------
## 0. One-line verdict

There is one genuine, small, compositional theory inside this run -- "invariant
mass squared is the summed pairwise disagreement of null directions, realized by
a finite carrier and an exact finite history sum" -- and it is wrapped in an
aspirational atlas (the three essays plus the completion matrix) that is, today,
an organized analogy map rather than a second theory. The finite core derives an
observable (a mass scalar) from primitive spinor data through named finite
theorems. The advertised object -- a "candidate complete finite null-information
theory" of state, mass, interaction, and geometry -- is not yet one
compositional theory: its own completion matrix grades almost every layer `B`
(bridge conjecture) or `O` (open), and the single end-to-end composition chain it
demands has more absent/conditional arrows than derived ones (Section 2).

The run is honest about this at the leaf level (every claim carries T/M/C
labels, kill conditions are recorded). The architectural failure is one level
up: information-theoretic readings are placed beside finite identities and joined
by conjunction (`AND`), not by derivation. The flagship Lean object
`four_channel_path_action_capstone` is literally a large `AND` of independent
finite facts, and its own docstring says "This is a composition theorem, not new
mathematics." A conjunction of true statements is a checked collection, not a
derivation spine.

--------------------------------------------------------------------------------
## 1. Postulates: present, implied, imported

### 1a. Postulates actually PRESENT (declared as objects with finite theorems)

- P1. A future null direction is a rank-one positive-semidefinite bispinor
  `psi psi^dagger` (Pauli map). PRESENT and load-bearing; the whole mass
  invariant rests on it.
- P2. Mass squared of a bundle is `det P`, `P = sum_i psi_i psi_i^dagger`, and
  `det P = sum_{i<j} |psi_i wedge psi_j|^2` (Cauchy-Binet). PRESENT; and, via the
  uniqueness theorem `detP_unique`, non-arbitrary among quadratic forms vanishing
  on all null edges. This is the strongest structural postulate in the run.
- P3. A finite Dirac-type carrier `D = sum_e c(alpha_e) grad_e + Gamma phi` with
  `c(alpha_e)^2 = 0`, whose Krein-adjoint square splits into four blocks
  (aperture, closure, turn, soldering). PRESENT as an algebraic identity
  (`carrier_krein_square`), but the carrier is POSITED, not derived from P1/P2.
- P4. Physical states live in constraint cohomology of a nilpotent `Q`
  (`Q^2 = 0`), with a separately chosen positive sector. PRESENT as finite
  linear algebra (Kugo-Ojima, GenericFiniteHodge). The positivity is an added
  choice, not a consequence (KreinHodgeNoGo).
- P5. A 1+1 null history carries amplitude `(i eps m)^{corners}`. PRESENT and
  exact (`exact_path_sum_eq_closed_kernel`, Dirac recursion, lattice dispersion).

### 1b. Postulates only IMPLIED (used as if primitive, never declared)

- I1. A primitive ontology: "finite oriented null events/edges, amplitudes,
  labels, composition." The completion matrix lists this as Layer 1 and grades it
  `B` ("specify"). No Lean type for it exists in the shipped corpus. Everything
  downstream (carrier, cohomology, histories) is defined on abstract vector
  spaces / matrices, NOT on a constructed event space. This is the single most
  important missing primitive: the theory names its ground floor but has not
  built it.
- I2. A selection principle for the physical positive sector. The manuscript
  states there is "no canonical notation (ker Q / range Q)^+"; a physical
  Hilbert space "requires additional decoder data." That decoder data is an
  implied postulate, instantiated only by one hand-built 3-dimensional witness.
- I3. A generator/Hamiltonian choice. The action modules prove that stationary
  pairs are carrier solutions, but "the generator choice is a named boundary, not
  an implicit theorem." So "which operator evolves the state" is an implied
  postulate supplied by hand (D#D, or B(lambda,kappa), or the walk step).
- I4. A dictionary from the four carrier blocks to continuum field sectors
  (kinetic / gauge-curvature / scalar / geometric). Used throughout the naming,
  declared conjectural (C), never derived.

### 1c. Postulates IMPORTED from established physics

- IM1. Special-relativistic mass shell `E^2 = |k|^2 + m^2` and Minkowski
  signature (Pauli-map, mostly-minus normalization). Imported; the run does not
  derive Lorentz signature.
- IM2. The Mandelstam / spinor-helicity dictionary `|psi_i wedge psi_j|^2 =
  2 p_i . p_j = s_{ij}` (cited as classical, ElvangHuang / ArkaniHamed).
- IM3. The Wootters concurrence formula `C_W = 2|det M|` (imported to read `det P`
  as entanglement).
- IM4. The Dirac equation / checkerboard correspondence as the TARGET of the walk
  (Feynman-Hibbs, Jacobson-Schulman, D'Ariano et al.). The continuum Dirac
  operator is imported as the thing the finite walk hopes to reproduce.
- IM5. Beta-function / running-coupling input for RG and dimensional
  transmutation (the brief explicitly flags "a supplied running coupling can
  define an invariant scale without deriving the beta function").
- IM6. In the essays only: BRST cohomology, AQFT nets, Wilsonian RG, Jacobson's
  entanglement-equilibrium derivation of Einstein's equation, the Page curve.
  These are imported frameworks re-narrated in information language, not results
  of this theory.

Honest scorecard: the derivational content is concentrated in P1-P2 (and their
finite consequences P3-P5 as *algebra*). The physics reach comes from IM1-IM6
plus the implied postulates I1-I4. The gap between "present" and "imported/implied"
is exactly the gap between the small real theory and the advertised complete one.

--------------------------------------------------------------------------------
## 2. Dependency graph: primitive null data -> at least one observable

The completion matrix demands this chain:

```
primitive null data
  -> gauge-equivalence class
  -> positive physical state
  -> finite action / evolution
  -> spectral or closure observable
  -> calibrated units
  -> known-physics benchmark
  -> falsifiable extrapolation
```

Arrow-by-arrow grading (DERIVED / CONDITIONAL / IMPORTED / CIRCULAR / ABSENT):

1. primitive null data -> gauge-equivalence class : **ABSENT (posited).**
   There is no declared primitive-data type in the shipped corpus; the
   cohomology quotient `ker Q / range Q` acts on an abstract space `V`, not on a
   constructed null-event space. The arrow is asserted, not built. (Layer 1 =
   `B` in the matrix, "specify".)

2. gauge-equivalence class -> positive physical state : **CONDITIONAL.**
   `PositiveHodgeDecoder` produces exactly one explicit witness (the class of
   `e2`: closed, non-exact, harmonic, positive Krein norm). The matched sign
   no-go and `KreinHodgeNoGo` show positivity is NOT automatic. General selection
   of a nonzero invariant maximal positive sector is open. Works for the hand
   fixture; not a general law.

3. positive physical state -> finite action / evolution : **IMPORTED/posited.**
   The generator is inserted (I3). `UnifiedActionVariation` and the Cayley step
   derive updates *from a supplied H*; they do not select the physical H.

4. finite action / evolution -> spectral or closure observable : **DERIVED
   (finite).** This is the one strong arrow. `free_mass_operator_eq_plucker`
   (`P adj(P) = det(P) I`) ties the Gram invariant to a least eigenvalue; the
   walk ties the turn parameter to the zero-momentum quasienergy gap; B(lambda,
   kappa) gives least eigenvalue lambda-kappa; closure gives a binding shift.
   Caveat: these are SEVERAL DISTINCT observables all called "mass" (Section 3),
   welded only on hand fixtures, not proven mutually equal in general.

5. spectral/closure observable -> calibrated units : **ABSENT.**
   The theory is entirely dimensionless. Scale-setting (dimensional
   transmutation, absolute scale) is an open `O` layer. No units exist to carry.

6. calibrated units -> known-physics benchmark : **ABSENT / would be IMPORTED.**
   Every `SIMULATION_BENCHMARKS.md` row is "queued", artifacts "TBD", none
   executed. The reproduction rows are explicitly V2 (imported dictionary/inputs),
   which by the matrix's own rule "may not be called a prediction."

7. known-physics benchmark -> falsifiable extrapolation : **ABSENT.**
   No V4 pre-registered prediction exists; the V4 row is "select", owner "both",
   status none.

Score: 1 derived, 1 conditional, 1 imported/posited, 4 absent (counting the
first as absent), across 7 arrows. The chain is NOT executable end to end.

Circularity watch (where a definition and its justification chase each other):

- "particle = positive Hodge eigen-code" (arrow 2) and "mass = least eigenvalue
  of D#D on the positive class" (arrow 4) share the *chosen* positive sector and
  the *inserted* decoder D_mu. Positivity is selected to make the eigen-code
  positive, and the eigen-code is called physical because it is positive.
  NEAR-CIRCULAR until an independent positive-sector existence/selection theorem
  breaks it. (The moduli essay's variational mass `m^2([psi]) = inf <phi, D#D phi>`
  over the positive class inherits the same loop.)
- By contrast, the "why the determinant" objection is NOT circular: `detP_unique`
  derives the determinant from universal null-vanishing. This is the model of what
  the other arrows should look like.

The only fully non-circular, derived sub-chain is:

```
null spinor pair -> P = sum psi psi^dagger -> det P = |wedge|^2 (Cauchy-Binet)
  -> free mass operator least eigenvalue = det P -> mass observable
```

That sub-chain is a real theory. Everything past "calibrated units" is prose.

--------------------------------------------------------------------------------
## 3. One physical word, several mathematically different objects

The run is careful about a few of these (the brief flags Q vs Q*Q+QQ* vs D#D,
and the manuscript flags positivity). But the SAME word still denotes distinct
objects across layers, and the essays multiply the senses. Table:

- **mass** (at least 5 objects called m or m^2):
  (a) `det P`, the Gram determinant = summed spinor-wedge area (kinematic);
  (b) rank of P (the discrete massless/massive boundary, a different, integer
      invariant);
  (c) least eigenvalue of the free mass operator `P adj(P) = det(P) I` (spectral;
      equals (a) only because dim 2);
  (d) the checkerboard turn parameter = zero-momentum quasienergy gap `e^{-i m a}`
      (a FREQUENCY, tied to (a) by convention, not by theorem);
  (e) `B(lambda,kappa)` least eigenvalue `lambda - kappa` (a carrier-compression
      eigenvalue);
  (f) moduli/variational `m^2([psi]) = inf <phi, D#D phi>` over a positive class,
      and separately "the Hessian of the information action" (moduli sec 9).
  These are joined by chosen dictionaries, not proven equal. See Package 1 and 2.

- **positivity** (4 objects):
  (a) `det P >= 0` (Cauchy-Binet, always true);
  (b) Krein positivity of a *selected* physical sector (model-dependent, can fail);
  (c) Hilbert-adjoint Hodge positivity via `Delta_Q = Q*Q + QQ*` (auxiliary
      positive-definite inner product);
  (d) positive-definiteness of B iff `|kappa| < lambda`.
  The manuscript warns (b) != (c); good. But "positive" still floats.

- **locality** (4 objects):
  (a) no-signaling: partial-trace invariance under local Kraus
      (`FiniteNoSignaling`) -- a two-tensor-factor statement;
  (b) two-region microcausality (`TwoRegionTensorMicrocausality`);
  (c) null-front / causal-cone via principal symbol (`LowerOrderChannelCausality`);
  (d) AQFT net locality (essay, absent). The brief itself says (a) "is not
      emergent spacetime locality" -- yet the essays narrate them as one idea.

- **gauge** (5 objects):
  (a) nilpotent BRST/Kugo-Ojima constraint Q and its cohomology quotient;
  (b) chain-homotopy "decoder gauge" `D' = D + QR + RQ` (moduli);
  (c) U(1) vertex-phase gauge on edge transport (closure holonomy);
  (d) local coframe frame-change `e -> g e` (soldering covariance);
  (e) the Yang-Mills gauge GROUP as a "decoder automorphism group" (essay,
      absent/derivation missing). Five different "gauges."

- **particle** (3 objects):
  (a) positive Hodge eigen-code (closed, non-exact, harmonic, positive Krein
      norm, D#D eigenvalue);
  (b) "spectral answer" / pole of boundary response (essay);
  (c) Fock occupation excitation with gap `lambda - kappa` (`FockMassGap`).

- **entropy** (4 objects):
  (a) linear entropy `S_L = 1 - tr rho^2 = 2 det rho` (identified with normalized
      mass^2 -- a dim-2-specific identity, NOT general);
  (b) decoherence monotone under pinching;
  (c) proper-time "entropy clock" (essay);
  (d) horizon / black-hole entropy (essay).

- **action** (4 objects):
  (a) quadratic carrier action budget `psi^T (4 D#D) psi`;
  (b) history-local additive `S_w(h) = sum_a w_{chi(a)}`, phase `exp(i S)`;
  (c) Lagrange-multiplier variational action whose stationary pairs are carrier
      solutions;
  (d) "information free energy" / self-consistent action (moduli sec 8).
  The capstone even admits its four action components "remain free inputs."

- **geometry** (4 objects):
  (a) finite soldering defect `T_xy = e_y - U_xy e_x`, metric `g[e] = e^T eta e`,
      volume `det e` (matrix geometry);
  (b) spectral / chain distance;
  (c) three named "curvatures" -- projective (`det P`), spectral (`D#D`), moduli
      (Berry `dA + A wedge A`) -- moduli sec 20, which itself opens "The word
      curvature has been used in several ways";
  (d) emergent spacetime metric / GR (absent).

Diagnosis: the run's discipline catches the dangerous pairs (positivity, the
three Q-operators). The remaining overloads -- especially "mass" (a-f) and
"gauge" (a-e) -- are exactly where an analogy map masquerades as a theory. Each
overload is an unproven identification asking to be a theorem.

--------------------------------------------------------------------------------
## 4. Three shortest cross-layer theorem packages (highest coherence gain)

Each package welds two layers that are currently only juxtaposed, is finite, and
recombines already-landed lemmas, so each is attainable in one focused sitting.
They are ordered by coherence-per-effort.

### Package 1 -- Free mass coincidence theorem (Kinematics <-> Positivity/Spectral)

Statement (target):
For a rank-two future Gram `P` with the induced free carrier, the moduli
variational mass equals the kinematic invariant:
```
inf { <phi, D#D phi>_J : [phi] in H_Q, R_+ representative, <phi,phi>_J = 1 }
  = det P.
```
Reduces, in the free 2x2 case, to `least_eigenvalue(P adj P = det P I) = det P`
plus attainment of the Rayleigh infimum on the positive class.

Witness: the existing non-collinear rational fixture with `det P = 4/25`.
Control: a collinear pair with `det P = 0` (massless class, infimum 0).
Falsifier: any *interacting* P where the variational minimum drops below
`det P` -- this is precisely the binding regime, so the theorem's SCOPE
("free") becomes a theorem boundary instead of prose. Kills the accusation that
"mass = det P" and "mass = spectral cost" are two unrelated readings.

Why first: it converts overload "mass (a),(c),(f)" from a dictionary into a
single equation with an explicit free/interacting boundary, and it breaks the
near-circularity in arrow 2/4 for the free case.

### Package 2 -- Turn-parameter is Gram mass (Kinematics <-> Dynamics/histories)

Statement (target):
For the 1+1 checkerboard with right/left null step spinors `psi_R, psi_L`, the
corner weight parameter `m` satisfies
```
m^2  proportional to  det( psi_R psi_R^dagger + psi_L psi_L^dagger )
                    =  |psi_R wedge psi_L|^2,
```
so the walk's mass is literally the pairwise null-direction disagreement of its
two step directions.

Witness: the R/L spinors plus the nonzero one-turn history `[R,L,R]` (already
`t3_mass_dependent_witness`).
Control / falsifier: exhibit `m != 0` while `psi_R wedge psi_L = 0` (collinear
steps). If that configuration is admissible, the identification is FALSE and the
"mass = turns" and "mass = wedge" readings are genuinely different -- a decisive
kill either way.

Why second: it is the missing bridge between the run's two headline mechanisms
("mass is disagreement of null directions" and "mass enters histories only at
corners"). Right now they share a symbol `m` and nothing else.

### Package 3 -- De-conjoin the capstone into one implication (Action <-> Observable)

Statement (target): replace the top-level `AND`-bundle
`four_channel_path_action_capstone` by a single derivation
```
carrier Krein-square identity
  => state action budget  S_A + S_C + S_T + S_E = psi^T (4 D#D) psi
  => on-shell condition  det(Dop E k m) = 0
  => mass shell  E^2 = k^2 + m^2,
```
with each former conjunct demoted to a named lemma USED in the chain.

Witness: `(E,k,m) = (5,3,4)`, tuple `(64,0,64,0)`, total 128, `det Dop = 0`
(already `three_four_five_channel_action_witness`).
Falsifier: an off-shell symbol where the budget is nonzero but `det != 0`
(control already present). If no such implication holds, the capstone was never a
composition theorem and must be presented as a checklist, not a spine.

Why third: this is the single most visible place where the run confuses
conjunction with derivation. Its own docstring concedes "This is a composition
theorem, not new mathematics." Turning one flagship `AND` into one `=>` does more
for the "is this one theory" question than any new leaf lemma.

--------------------------------------------------------------------------------
## 5. Recommended manuscript table of contents

Design rule: announce the theory in the front matter, put the composition chain
and the proof frontier where a referee sees them first, and never let a C-graded
identification borrow credibility from an adjacent M-graded lemma.

```
Front matter
  0. Thesis in one paragraph: null-direction disagreement is the proposed common
     origin of mass; state exactly how far that is carried.
  0.1 Postulate ledger: PRESENT / IMPLIED / IMPORTED (Section 1 of this audit),
      three explicit columns, on page 1.
  0.2 The one composition chain, every arrow graded derived/conditional/
      imported/absent (Section 2). This replaces the current buried composition
      test.

Part A -- The derived core (lead with strength)
  1. Primitive null data and the canonical invariant: Cauchy-Binet mass, rank
     boundary, and the uniqueness theorem detP_unique (the anti-cherry-pick).
  2. Coherence readings that are theorems, not analogies: concurrence identity,
     linear-entropy identity, with explicit dim-2 scope stated inline.
  3. Finite histories: exact checkerboard sum, Dirac recursion, exact lattice
     dispersion and zero-momentum gap, quantitative one-step O(eps^2) bound.

Part B -- The candidate dynamical theory (state boldly, gate precisely)
  4. The finite carrier and its Krein square; the four blocks as NEUTRAL labels.
  5. From data to state: cohomology, Krein vs Hilbert Hodge, and the positivity
     SELECTION problem stated as an open interface (not hidden).
  6. The mass coincidence theorem (Package 1) + turn=Gram bridge (Package 2):
     the section that makes the several "masses" one object on its stated domain.
  7. Structure without derivation-of-SM: closure binding with the wrong-plane
     control; family/CP no-gos; soldering matrix geometry. Each ends with its
     continuum falsifier.

Part C -- The proof frontier (do not hide it; weaponize it)
  8. One frontier table: every B/O layer with exact next statement, witness,
     falsifier, benchmark. This is the honest version of the completion matrix.
  9. Simulation protocol: V0-V4 tiers, no-prediction disclaimer, negative
     controls required.
 10. Relation to prior work (quantum walks, discrete gravity, BRST) and scope
     boundaries: what is imported.

Appendix
  A. Machine-verification manifest: reproducible build target, axiom guard
     output, and a declaration-to-equation table WHOSE PATHS RESOLVE in the
     released commit (see Section 6 caveat).
```

What this TOC refuses to do: it does not open with "a complete finite
null-information theory," and it does not let Parts on gravity/cosmology/SM
dictionary appear as chapters of results. Those live only in the frontier table
(Chapter 8) with kill conditions.

--------------------------------------------------------------------------------
## 6. Verdict on headlines

### Lead now (responsible, backed by derived arrows)

"Invariant mass squared is the summed pairwise disagreement of null directions --
a canonical, machine-checked finite identity." Backed by Cauchy-Binet
(`det P = sum |wedge|^2`), the rank boundary, and crucially `detP_unique`
(uniqueness among null-vanishing quadratic forms), which defeats the "you picked
the determinant to get the answer" objection. The companion finite-dynamics
headline -- "an exact finite null-history sum reproduces the discrete Dirac
recursion and pins the corner mass parameter to the zero-momentum quasienergy
gap" -- is equally lead-worthy. The present title, "Mass as Null-Edge Spectral
Area," is the correct responsible lead.

### Requires exactly one missing theorem (bold conditional, allowed)

"Null information is the common origin of quantum state and mass: particles are
positive Hodge eigen-codes whose spectral cost IS the kinematic mass." This is
one theorem away: Package 1 (free mass coincidence) plus a nonzero
invariant-positive-sector existence theorem (currently a single hand-built
witness). State it boldly AS a candidate, gated explicitly on those two results.
Do NOT hedge it with "may/might/suggests"; name the missing theorem instead.

### Kill (cannot responsibly lead, keep only as labeled frontier conjecture)

- "One operator, both forces" / the four carrier blocks ARE kinetic + QCD +
  Yukawa + gravitational mass (P-L in future directions). Rests entirely on
  C-graded identifications with an ABSENT continuum limit and an admitted
  abstract non-uniqueness of the carrier. Kill as a headline.
- "Everything moves at the speed of light" as a universal claim. The manuscript
  itself demotes this to a principal-symbol statement conditional on a
  field-by-field audit; the universal phrasing must not lead.
- Any cosmology / Lambda / "candidate COMPLETE theory" headline. The completion
  matrix grades cosmology `B/O`, units are absent, and no V4 prediction exists.
  "Complete" is the word most likely to convert a reviewer from sympathetic to
  hostile; kill it until the composition chain in Section 2 has no absent arrows.

--------------------------------------------------------------------------------
## 7. Cross-cutting finding: the reproducibility / corpus gap (flag before submission)

Not requested, but it bears directly on whether the "machine-verified" spine is
real. The shipped checkout contains 18 flat Lean files under `PhysicsSM/` with no
`sorry` and no `axiom`/`@[implemented_by]` (good). But the manuscript's anchor
table (Table 2) cites roughly 40 declarations under a `PhysicsSM/Draft/NullEdge/...`
tree that does NOT exist in this checkout. Of 14 headline anchors spot-checked,
only 4 are present here (`exact_path_sum_eq_closed_kernel`,
`positive_hodge_mass_witness`, `four_mul_det_gram_eq_concurrence_sq`,
`endpointMassSq_eq_pairDisagreement`); the other 10 -- including the flagship
`i1_5_cauchy_binet_mass_identity`, `detP_unique`, `carrier_krein_square`,
`spinorWedge_sl2_invariant`, `exact_quantum_walk_dispersion_verdict`,
`four_channels_linearIndependent`, `B_least_eigenvalue`,
`jarlskog_Vwitness_ne_zero`, `three_generations_not_forced`,
`nondegenerate_soldering_geometry_verdict` -- are absent from the supplied files.

Consequence for the architecture verdict: the two arrows I graded "derived"
(Section 2, arrow 4; and the anti-cherry-pick uniqueness in Section 2 note) rest
on declarations that cannot be checked from this checkout. Before any submission,
either ship the `Draft/NullEdge` tree or repoint Table 2 at the files that
actually exist. A verification spine that a referee cannot rebuild from the
released artifact is, architecturally, still prose.

--------------------------------------------------------------------------------
## 8. Bottom line

Do not reward the domain inventory. The completion matrix, the intake map, and
the essays enumerate ~19 physics domains; that breadth is the run's chief
temptation and its chief risk. The defensible product tonight is narrow and real:
a finite, non-arbitrary theory of mass as null-direction disagreement, with an
exact history dynamics and a positive-sector witness. Lead with it. Weld its
internal seams with Packages 1-3 so that "mass" means one thing. Move every
gravity/SM/cosmology claim into a single frontier table with kill conditions.
Then the paper announces a theory with an honest edge, instead of an atlas that
hopes its regions are one continent.
