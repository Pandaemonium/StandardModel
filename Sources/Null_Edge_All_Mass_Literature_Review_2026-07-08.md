# All-mass program: comprehensive literature review (2026-07-08)

**Scope.** Prior art for the all-mass / null-edge manuscript
(`Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`) and its strengthening roadmap
(`AgentTasks/overnight-allmass-run-2026-07-08/STRENGTHENING_ROADMAP.md`), across
13 themes. Compiled via scholarly search (arXiv / INSPIRE-HEP / Semantic
Scholar). For each theme: key references (with arXiv/INSPIRE ids), what they
establish, the program's relation, and the **novelty gap** (what is genuinely
new vs. prior). Status: research aid, not a final bibliography; identifiers
should be convention-checked before outward citation (cf.
`Sources/Null_Edge_References.md`).

**Bottom line up front.** The program sits in a *more crowded neighbourhood*
than the current §2a admits. Several framings the manuscript treats as novel -
fermion doubling cured by indefinite/Krein structure, confinement as positivity
violation, a null-face 4D checkerboard Dirac, machine-verified physics - each
have substantial, sometimes very close, prior art that must be cited and
positioned against. The **genuinely unoccupied combination** is narrower and
should be stated as such: *a finite Krein carrier whose square is graded into a
four-channel budget answering to the kernel-checked Plücker mass invariant, with
a pre-registered kill-discipline and a kernel-verified constructive-QFT chain.*
No single prior work holds that combination; but nearly every individual
ingredient is occupied. Three items below are close enough to demand explicit
engagement: **Foster–Jacobson 2016** (4D null-face checkerboard), **Bizi–
Brouder–Besnard 2016** (Krein spectral triple solving fermion doubling), and
**Barrett 2007** (Lorentzian NCG Standard Model).

---

## 1. Spinor-helicity / Plücker kinematics (the §3 core)

- **Elvang–Huang, "Scattering Amplitudes"** (arXiv:1308.1697) - the canonical
  review; spinor-helicity, little group, momentum twistors.
- **Cheung, TASI Lectures on Scattering Amplitudes** (arXiv:1708.03872).
- **SAGEX Review ch.1** (Brandhuber–Plefka–Travaglini, arXiv:2203.13012).
- **Marzolla** (arXiv:1705.09678) - little-group fixing of 3-pt massive/massless
  amplitudes.

*Relation.* Confirms the manuscript's own honesty: `det P = sum |psi_i^psi_j|^2`
is classical spinor-helicity kinematics (invariant mass as pairwise
non-collinearity). **Novelty gap:** none in the identity; the program's
contribution is (i) the kernel-checked Plücker/Cauchy–Binet formalization and
(ii) using this invariant as the organizing quantity. §2a already cedes this
correctly; keep it.

## 2. Finite / Lorentzian / Krein spectral triples & NCG Standard Model

- **Bizi–Brouder–Besnard, "Space and time dimensions of algebras ... Lorentzian
  noncommutative geometry"** (arXiv:1611.07062) - **the closest NCG prior art.**
  Builds an *indefinite (pseudo-Riemannian) spectral triple over Krein spaces*,
  writes a Lorentzian almost-commutative Lagrangian, and **exhibits a space of
  physical states solving the fermion-doubling problem** - exactly the
  Krein-positive-sector move the program makes (§6 escape, §8). Must cite.
- **Barrett, "A Lorentzian version of the non-commutative geometry of the
  Standard Model"** (hep-th/0608221; J. Math. Phys. 2007) - direct prior art for
  "finite Krein + Standard Model"; Fable flagged its absence as the one
  positioning gap a knowledgeable referee will catch. *Identifier to verify.*
- **Connes, "NCG and the standard model with neutrino mixing"**
  (hep-th/0608226) - the KO-dimension-6 twist that *resolves fermion doubling*
  and yields SM+gravity+see-saw; a mass relation at unification.
- **Chamseddine–Connes–Marcolli** (hep-th/0610241, per Pro) - the spectral SM
  with neutrino mixing coupled to gravity.
- **Figueroa–Gracia-Bondía–Lizzi–Varilly** (hep-th/9701179) - superconnection
  spectral action. **Sakellariadou** reviews (arXiv:1204.5772, 1008.5348).
- (Already in the repo map: "Gauge networks in NCG", arXiv:1301.3480.)

*Relation.* This is the program's true intellectual neighbourhood. **Novelty
gap:** the *indefinite/Krein spectral triple solving fermion doubling* is NOT
new (Bizi et al; Barrett; Connes KO-6). The program's distinct moves are: finite
*null-edge* soldering, the four-channel budget tied to `det P`, the
kill-discipline, and kernel verification. §2a's novelty claim (i) must **narrow
to** "finite Krein + null-edge + kernel-checked kill-discipline", not "finite
Krein" simpliciter.

## 3. Dirac from quantum walks / quantum cellular automata

- **Bakircioglu–Arnault–Arrighi, "Fermion Doubling in Quantum Cellular
  Automata"** (arXiv:2505.07900) - **key F7 prior art.** Rigorously extends the
  doubling analysis to discrete-time QCAs, gives a *chiral*, doubler-free,
  neutrino-like QCA, and explains *how it coexists with Nielsen–Ninomiya*. This
  is precisely the F7 program (which NN hypothesis is traded, at what cost).
- **Gupta–Short** (arXiv:2601.15885) - fermion doubling and pseudo-doublers in
  Dirac quantum walks; vacuum-stability implications.
- **Jolly–Di Molfetta, "Twisted quantum walks ..."** (arXiv:2212.13859) - a
  dispersion term acts as an *effective mass regularizing doubling* - a mass-as-
  regulator reading adjacent to the turn channel.
- **Debbasch** (arXiv:2202.11181) - minimal QW, single-component (no doubling).
- **Beenakker–Sánchez–Tworzydło** (arXiv:2607.05112) - single-cone Dirac QW is
  *fundamentally more fragile in 2D* (non-symmorphic protection) - a caution for
  F8's higher-dimensional ambition.
- **Di Molfetta–Debbasch–Brachet** (arXiv:1212.5821, 1309.4923) - QW continuum
  limit = Dirac fermion in curved / gauge fields.

*Relation.* The QW/QCA lineage is the discrete-Dirac-with-doubling literature the
program's §8 and F7 live in. **Novelty gap:** "doublers handled by a discrete
Dirac scheme" is a busy field; the program's distinct claim is *doublers as
Krein-null ghosts quotiented in `V'/N`* (F7) - which overlaps Bizi et al's
Krein fermion-doubling solution and must be positioned against both.

## 4. Feynman checkerboard (the continuum bridge, F8/T6)

- **Foster–Jacobson, "Spin on a 4D Feynman Checkerboard"** (arXiv:1610.01142) -
  **the single closest prior art to the null-edge carrier, and a must-cite.**
  Discretizes the Weyl equation on a *time-diagonal hypercubic lattice with null
  faces*; step amplitudes are *spin projection operators* in the step direction;
  the retarded propagator is a product of projectors; **fermion doubling does not
  occur**; a Dirac mass is a chirality-flip amplitude, a Majorana mass a
  charge-conjugation amplitude. This is startlingly close to the program's
  null-edge Clifford-soldered carrier with reflection sectors - it may partially
  *pre-empt* the 4D construction, which the manuscript must engage honestly (it
  is also the strongest evidence that F8/T6 is the right bridge).
- **Li–Horsley** (arXiv:2504.06329) - overlooked aspects of the checkerboard
  applied to the Dirac equation.
- **Kull** (quant-ph/0212053) - checkerboard on a *dense rational subset* of 2D
  Minkowski (non-continuous spacetime) with continuum-close propagators - a
  precedent for finite/discrete null-edge kinematics.
- (Classic 1+1D: Gersch; Jacobson–Schulman - already cited in §2a.)

*Relation.* F8/T6's whole thesis (extend the one proven continuum bridge).
**Novelty gap:** a *null-face 4D checkerboard Dirac without doubling* already
exists (Foster–Jacobson). The program's distinct content would be the *Krein*
structure and the four-channel budget on top of it - so the honest F8 claim is
"cast the Foster–Jacobson null-face checkerboard as a Krein carrier and read its
mass budget", not "a new 3+1D checkerboard".

## 5. Confinement / Kugo–Ojima / Gribov–Zwanziger / positivity violation (F2, F10, §6)

- **Zwanziger, "Vanishing of zero momentum lattice gluon propagator and color
  confinement"** (Nucl. Phys. B 1991; INSPIRE 323786) - **the F2 anchor.**
  Hypothesizes exactly the program's picture: *color-singlet gauge-invariant
  states are stabilized by reflection positivity giving them a real mass, while
  color non-singlets are unstable / develop complex mass*. The balanced-closure
  no-go is a finite shadow of this.
- **Alkofer–Fischer–von Smekal** (hep-ph/0301107, nucl-th/0301048) - KO criterion
  <-> GZ horizon condition <-> IR gluon/ghost propagators; *positivity violation
  of the gluon spectral function*.
- **Cucchieri–Maas–Mendes** (hep-lat/0701011) - lattice IR-suppressed gluon
  propagator. **Capri et al** (arXiv:1611.10077) - BRST-invariant, gauge-
  parameter-independent positivity violation as a confinement signature (F10:
  the data-adjacent comparison).

*Relation.* F2 (balanced closure = finite KO/quartet signature) and F10 (finite
`J Q_C` inertia <-> measured propagator positivity violation). **Novelty gap:**
confinement-as-positivity-violation is a *mature, measured* story; the program
does NOT add physics here. Its contribution is a *finite, kernel-checked* toy in
which the signature is a theorem-adjacent fact - useful as verified structure,
not as new confinement physics. State F2/F10 as weak claims (the manuscript
already does).

## 6. Nielsen–Ninomiya / chiral lattice fermions (F7, §8)

- **Nielsen–Ninomiya, "Absence of Neutrinos on a Lattice"** (Nucl. Phys. B 1981;
  INSPIRE 155854) - the no-go itself (equal L/R Weyl species in the continuum
  limit under hermiticity + locality + chirality + translation invariance).
- **Bakircioglu–Arnault–Arrighi** (arXiv:2505.07900) - see §3; the QCA-era NN
  evasion.
- **Minimally-doubled fermions** (Karsten–Wilczek, Borići–Creutz): Capitani–
  Weber–Wittig (arXiv:0910.2597), Bedaque et al (arXiv:0804.1145) - chiral
  symmetry + minimal doubling on non-orthogonal / hyperdiamond lattices, at the
  cost of hypercubic-symmetry-breaking operators.

*Relation.* F7's target. **Novelty gap:** the program's honest F7 claim is
specific - *which* NN hypothesis is traded (hermiticity -> Krein
`J`-hermiticity) and at what cost (indefiniteness) - and that doublers become
Krein-null. This is distinct from the GW / minimally-doubled routes, but overlaps
Bizi et al's Krein fermion-doubling solution; cite both.

## 7. Proton mass decomposition (§4/§6 budget, the Ji target)

- **Yang et al, "Proton Mass Decomposition from the QCD Energy Momentum Tensor"**
  (arXiv:1808.08677; PRL 2018) - quark energy 32(4)(4)%, glue field energy
  36(5)(4)%, quarter-trace-anomaly 23%, scalar condensate 9% at μ=2 GeV in MS-bar.
- **Liu, "Proton mass decomposition and hadron cosmological constant"**
  (arXiv:2103.15768) - the *RG-invariant* trace-of-EMT decomposition vs. the
  *scheme/scale-dependent* Hamiltonian/GFF decomposition; the trace anomaly as
  vacuum glue condensate giving a confining restoring pressure. **The precise
  reference for the §4a/§5 scheme-dependence caveat.**
- **Liu** (arXiv:2302.11600) - trace anomaly, hadron "cosmological constant",
  superconductor-vortex analogy.
- (Ji original decomposition; Lorcé; Metz–Pasquini–Rodini on decomposition
  ambiguity - Fable's recommended inoculation refs; *to add*.)

*Relation.* Grounds the manuscript's demotion of the strong Ji claim (term
dominance is scheme-dependent) and the scheme-robust weak claim (|b_T| small).
**Novelty gap:** none claimed; these are `[import]` targets. The finite model
is a *toy Ji budget*, explicitly not a lattice replacement.

## 8. Koide / lepton mass / neutrino oscillations (§5, §8, P-ν)

- **Koide** (arXiv:0706.2534, 1711.03221) and the **Sumino model** (Koide
  1701.01921) - the charged-lepton mass relation `Q = 2/3` and the QED-running
  problem (the "Sumino bar") - the route the program *killed* (κ=3/2, §5).
- **NuFIT-6.0** (arXiv:2410.05380, per Pro) - the neutrino oscillation global
  fit; `Delta m^2_21`, `|Delta m^2_3l|`, ordering - the P-ν comparison target.

*Relation.* §5's kill (tetrahedral Koide) and the P-ν pre-registered prediction.
**Novelty gap:** the manuscript correctly owns only the massless *count*, not the
ratio; keep the P-ν discipline.

## 9. Positive-mass/energy theorems + metric-affine gravity (F4, §7)

- **Cecchini–Lesourd–Zeidler** (arXiv:2307.05277) - positive mass for spin
  initial data with *dominant-energy shields*, via *an additional independent
  timelike direction in the spinor bundle* - directly the shape of F4 (a finite
  DEC-conditioned nonnegative boundary invariant).
- **Wieland, "Witten spinors and the quantisation of length"** (arXiv:1711.01276)
  - the Witten equation as a boundary spinor whose norm gives *length as a
  discrete-spectrum operator* - a concrete Witten-spinor <-> length/proper-time
  link (Pro's "proper time as turn density" register).
- **Dai** (math-ph/0406006) - Lorentzian positive energy theorem.
- **Geometric trinity:** Capozziello–Finch–Levi Said–Magro (arXiv:2108.03075,
  3+1 formalism); **Golovnev, "Is there any Trinity of Gravity ...?"**
  (arXiv:2411.14089) - a *skeptical critique* worth citing honestly (the
  torsion/non-metricity formulations may be "unobservable geometrical
  inventions"); Mancini–Tino–Capozziello (arXiv:2501.06487) - trinity vs. the
  Equivalence Principle (relevant to Pro's EP-as-theorem speculation).

*Relation.* F4 (finite Witten positive-mass for the E channel) and §7 (the
torsion+non-metricity trinity split, after the pure-torsion kill). **Novelty
gap:** the finite *algebra* of the trinity split is the program's own (M); the
*geometric* reading is C and must cite both the trinity program and Golovnev's
critique so it does not overclaim significance.

## 10. Entanglement monogamy (F3)

- **Coffman–Kundu–Wootters** (the original CKW inequality, PRA 2000).
- **Osborne–Verstraete** (quant-ph/0502176) - general n-qubit CKW monogamy proof.
- **Ou–Fan–Fei** (arXiv:0711.2865) - a *proper* monogamy inequality for arbitrary
  (higher-dimensional) states (CKW fails in general dimension).
- **Nandi** (arXiv:2204.13649) - *G-concurrence* monogamy in `C^d (x) C^d (x)
  C^d` - the higher-dimensional wedge/determinant concurrence closest to the
  Plücker mass.

*Relation.* F3 (mass monogamy as Plücker superadditivity/inequalities). **Novelty
gap:** monogamy of *entanglement* is mature; the program's F3 recasts it as
*Plücker mass* superadditivity (mass created off-diagonally on bundle union =
the kinematic root of the `Delta` binding energy). To the search's knowledge
this *packaging* (mass, not entanglement) is unoccupied - a genuinely novel, if
modest, finite theorem. The G-concurrence line (Nandi) is the right technical
bridge.

## 11. Celestial / Carrollian holography (F9)

- **Melton–Michaelsen–Ruzziconi, "Observing Massive Scattering from Null
  Infinity"** (arXiv:2606.27421) - **the F9 anchor.** States plainly that
  *massive particles asymptote to timelike rather than null infinity*, so
  celestial/Carrollian holography "struggles to describe massive external
  states" - i.e. mass is exactly the obstruction to living on null infinity,
  almost verbatim the program's thesis. An active frontier lacking finite,
  exactly-solvable models with honest indefinite structure.

*Relation.* F9 (finite carrier as a discrete celestial model; reflection-sectored
Lefschetz index as celestial monodromy). **Novelty gap:** the *conceptual match*
(mass = obstruction to null infinity) is real and current; the program may hold
a finite exactly-solvable instance. Register as C; do not overclaim a holographic
dictionary.

## 12. Constructive QFT / cluster expansions (the infrastructure pillar)

- **Ueltschi** (math-ph/0304003) - cluster expansions for continuous+discrete
  systems, extending the Kotecký–Preiss criterion; correlation-function
  estimates.
- **Fernández–Procacci** (math-ph/0605041) - improved KP/Dobrushin convergence
  via the *Penrose identity + iterated tree-graph transformations* - **directly
  the "forest-injection" bounty's target abstraction.**
- (Already in the repo map: Osterwalder–Seiler; Seiler, *Gauge Theories as a
  Problem of Constructive QFT*.)

*Relation.* The guard-pinned RP->OS->gap->clustering chain and the polymer/
cluster-expansion Lean library. **Novelty gap:** the *mathematics* is classical
(KP, Penrose, Procacci); the program's contribution is *kernel verification* of
these fragments - plausibly among the first machine-checked constructive-QFT
lemmas. This is the most defensible near-term contribution and should be stated
as verification, not new constructive QFT.

## 13. Machine-verified physics (the methodology pillar)

- **Tooby-Smith, "HepLean: Digitalising high energy physics"** (arXiv:2405.08863)
  - **must-cite.** Formalizes HEP in Lean 4 (CKM matrices, anomaly cancellation,
  Higgs physics). Machine-verified physics *already exists*.
- **MerLean** (arXiv:2602.16554) - agentic autoformalization of theoretical-
  physics papers into Lean 4 - the methodology the program itself exemplifies.
- (PhysLean is the renamed/expanded HepLean; verify the current name/id.)

*Relation.* The novelty pillar "kernel-checked physics". **Novelty gap:**
*significant.* The program is NOT the first machine-verified physics (HepLean
predates it). Its distinct methodological claim must narrow to the *grading
discipline with pre-registered kills + oracle quarantine + Krein/kill-condition
program calculus applied to a speculative unification* - a working methodology,
not "first verified physics".

---

## Synthesis: the honest novelty positioning

**Occupied (cite, do not claim):** finite/Krein spectral triples solving fermion
doubling (Bizi et al, Barrett, Connes KO-6); null-face 4D checkerboard Dirac
without doubling (Foster–Jacobson); confinement as positivity violation
(Zwanziger, KO, GZ); QW/QCA discrete Dirac + doubling evasions; machine-verified
physics (HepLean); constructive-QFT cluster expansions (KP, Procacci); spinor-
helicity `det P` kinematics.

**Genuinely unoccupied (the defensible novelty), stated narrowly:**
1. The *combination*: a finite Krein carrier whose square is graded into a
   four-channel mass budget *answering to the kernel-checked Plücker mass
   invariant `det P`*, with a pre-registered kill-discipline.
2. **Mass monogamy** (F3) as *Plücker* superadditivity (mass, not entanglement) -
   and its identification with the off-diagonal `Delta` binding energy.
3. **Kernel verification** of the RP->OS->gap->clustering constructive-QFT chain
   and of the kill-conditioned program calculus.

**The one existential caveat unchanged:** until a continuum reduction exists for
at least one channel, all channel-name physics is grade C; the honest frontier
contribution is new finite theorems + sharpened finite diagnoses of known
continuum obstructions + verified infrastructure.

## Priority actions (for §2a and the reference map)

1. **Add to §2a as prior art the manuscript currently omits** (novelty-critical):
   Bizi–Brouder–Besnard 2016 (1611.07062), Barrett 2007 (hep-th/0608221),
   Foster–Jacobson 2016 (1610.01142), Bakircioglu–Arnault–Arrighi 2025
   (2505.07900), Zwanziger 1991, HepLean (2405.08863). **Narrow novelty claim (i)**
   accordingly (finite Krein is not new; the *combination* is).
2. **Ground existing caveats with citations:** Liu 2103.15768 (proton-mass scheme
   dependence, §4a/§5); NuFIT-6.0 2410.05380 (P-ν); Melton et al 2606.27421 (F9);
   Golovnev 2411.14089 (trinity critique, §7); Cecchini–Lesourd–Zeidler 2307.05277
   (F4); Osborne–Verstraete / Nandi (F3); Fernández–Procacci math-ph/0605041
   (forest-injection bounty).
3. **Ingest into Zotero/Neo4j** (pre-add existence check on arXiv id first;
   canonical bare-key convention per `docs/` and the reference map): the ~15
   novelty-critical + caveat-grounding refs above. (Neo4j MCP was disconnected
   this session; use `Scripts/lit/lit_ingest.py` when the graph is back.)
