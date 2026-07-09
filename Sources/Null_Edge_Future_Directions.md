# Null-edge mass program — future directions and candidate papers

**Status: speculative / research-program (grade C or lower throughout).** This
document collects conceptual reframings and candidate future papers for the
null-edge mass program. It is deliberately *outside* the manuscript
(`Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`), which is held to grade
discipline (only **T/M** claims, with **C** pre-registered and killable). Nothing
here is a result; these are directions, organized so that the backed pieces can be
grown into them. Sourced primarily from two external frontier-model analyses (Fable-5
and "Pro"/GPT-5, 2026-07-08), triaged against what the manuscript already proves.

Legend: **[in-paper M]** already a kernel theorem in the manuscript; **[job]** a
running/queued Aristotle target; **[C]** pre-registered conjecture; **[spec]** honest
speculation, no near-term handle.

---

## The grand reframing (the organizing bet)

> **The Standard Model may be less a list of particles and forces than a stable
> *phase catalogue* of finite null-coherence carriers.** Particles are the
> positive-sector eigenmodes; forces are the four canonical ways their null coherence
> changes (aperture opens disagreement, closure cancels/redistributes it, turn flips
> chirality, soldering measures it); mass is the invariant residue of that change.

The ontology shifts from *particles* to *coherence patterns*. Mass is not a substance
but a **relational geometry**: lightlike parts that cannot agree. This is grade
**[spec]** as an ontology, but it is grounded in an **[in-paper M]** core (mass =
Plücker/wedge disagreement) and organizes every direction below.

---

## The four flagship theorem SUITES (2026-07-09 run target frame)

Fable-5's 2026-07-08 stretch analysis reorganizes every direction in this doc into
**four theorem suites**, each designed so success is a publishable grand theorem and
failure is a clean no-go. This is the strategic frame the 2026-07-09 overnight run
executes (`AgentTasks/overnight-allmass-run-2026-07-09/RUN_PLAN.md` sec 2b); the
suites are umbrellas over the landed harvest modules, the in-flight jobs, and the
four assembly Goals. **Governing rule:** every rung returns a theorem, a
counterexample, or a sharpened missing axiom (Builder / Assassin / Oracle /
Registrar hats). All grade **[spec]/[C]** here; a rung is quoted below at the grade
its Lean actually earns only after it lands and is recorded in HARVEST RESULTS.

- **Suite A — Null Reconstruction Theorem.** Finite null info + positive decoding +
  composable quantum systems + CP phase => (1,3)-Lorentzian complex two-spinor
  geometry. Signature/dimension/causality are OUTPUTS, not inputs. Rungs:
  `SignatureForcing` [M], `DivisionDimensionSelection` [M], `SpectralDistance` [M],
  `RPSelectsLorentzian` [M], `FiniteCPT` [M]; NEW: full Lorentzian
  operator-to-geometry recovery on T2. Ties to P-B, P-G, Layer 1, conjectures M-U.
- **Suite B — Path-Sum Universality Theorem.** Finite null path sums flow to the
  Dirac/Weyl universality class; `Q_A,Q_C,Q_T,E` are its relevant/marginal
  coordinates (basin membership, not analogy). Rungs: `CheckerboardCarrierBridge`
  [M], `FiniteLevinson` [M], Goal III (critical RG, z=1, nu=1); NEW: path-sum
  semantics `rho_dir`, Cl(4)/3+1D checkerboard lift, Levinson index. Ties to P-H,
  P-J, the channel-name conjecture (S4a).
- **Suite C — Positive-Code Particle Theorem.** Particles = stable positive-sector
  eigen-codes; confinement = non-decodability; binding = compression advantage;
  masslessness = index/quotient/rank-one codes; generations = inequivalent positive
  completions (or underdetermined without a new axiom). Rungs:
  `PositiveSectorClassification` [M], `ConfinementPositivity` [M],
  `CarrierClosurePlane` [M], `WindingLowModes` [M], `FamilyIndexNoGo` [no-go],
  `FamilyRankNoGo` [no-go], `KMPhaseCounting` [M arithmetic-count anchor],
  `FiniteKMCP` [M N=2 no-go + N=3 witness], Goals I + II, `FiniteCPT` [M]; NEW:
  general-N incidence/corank theorem, functorial confinement, index=anomaly. Ties
  to P-A, P-F.
- **Suite D — Mass Resource Theorem.** Mass = positive-sector resource cost of
  compressing finite null histories (entropy = concurrence = compression cost =
  1/localization = thermodynamic response). Rungs: `MassThermodynamics` [M],
  `ModularSelection` [M], `MassResourceModularAudit` [M false-shape guard],
  `SchurSeesaw` [M], `WEPTrace` [M trace identity], Goal IV (Clausius/Jacobson); NEW: the
  mass resource theory (free states `det P=0`, monotones, conversion laws), entropy
  monotonicity under Schur compression, modular selection stretch, small-mass
  naturalness, finite Compton bound. Ties to P-C, P-D, P-I, conjecture V.

**The event horizon (unchanged, kept sharp).** Even if all four suites land, the
framework still does NOT derive the absolute mass scale, the Born rule, initial
conditions, or the number of null edges (see "What stays untouchable" below). The
most ambitious sentence the run may work to make true, at the grade each rung earns:
*spacetime, particles, forces, and mass are the decodable geometry, codewords,
defects, and compression costs of finite null information.*

---

## Candidate future papers

### P-A. "Finite null-edge Dirac carriers: Plücker mass, positive sectors, signed closure binding" (the surgical next paper)
Both external reviewers independently recommend **not** writing "All Mass from Null
Edges" but a tight 4-claim paper: (1) null-bundle mass = Plücker disagreement
**[in-paper M]**; (2) the carrier square decomposes into signed channels
**[in-paper M]**; (3) a concrete `Cl(4)` carrier has a positive physical sector with a
mass gap (`T2_positive_mass`) **[in-paper M]**; (4) closure lowers the ground mass
(binding defect `Δ=−κ`) **[in-paper M, block]**. Conjectural section: *if* these
carriers refine to continuum gauge/Dirac systems, the channel names become physics.
This is essentially the current manuscript, scoped tighter. **Lowest-risk, highest-
credibility next output.**

### P-B. "Mass as failure of projective synchronization: a phase theory"
Elevate `det P = Σ|ψᵢ∧ψⱼ|²` from an identity to the **primitive order parameter** of
the theory: mass is a *synchronization defect* of null directions. Generalize the
`3×3` block `B(λ,κ)` (spectrum `{λ−κ,λ,λ+κ}`, three phases now **[in-paper M]**:
massive `|κ|<λ`, critical `|κ|=λ`, over-closure `|κ|>λ`) to a **multi-channel mass
phase vector** `b = (b_A, b_C, b_T, b_E)` — aperture/closure/turn/soldering as signed
budget channels — and classify the phases of the 4-parameter Hermitian block. Target
phases: aperture-dominated massive, closure-cancelled critical, turn-dominated
(Higgs-shaped, **[C]**), index-protected **[in-paper M, §8]**, indefinite/unphysical.
**[job: multi-channel-phasediagram]**.

### P-C. "Proper time is the entropy clock of hidden null motion"
The mass↔entropy dictionary is **[in-paper M]** (null ⇔ `S=0` "does not age";
timelike ⇔ `S>0`; rest ⇔ `S=log 2`). Grow it into an *information-theoretic* account:
inertial mass = entropy-resistance; time dilation = fraction of the internal null
bundle visible as coherent motion vs hidden as rest-frame mixture; decay = entropy
redistribution into lower-entropy outgoing bundles. Provable-target inequalities:
entropy monotonicity under Schur decimation; mass monogamy; binding defect bounded by
entanglement deficit **[job: bindingdeficit]**. This is the most quantitatively
tractable reframing (mass/entropy and mass/concurrence identities already M).

### P-D. "Binding is negative information curvature"
Sharpen `m²_bound = m²_free + Δ`, `Δ<0`, controlled by *signed* closure. Binding is
not extra glue energy but **negative projective curvature** — the closure channel
rearranges null disagreement so the whole has less mass than the visible sum. New
classification of composites: additive (weak cross-disagreement), bound (large
cross-disagreement + closure lowering the ground state), resonant (near the critical
surface), **confined** (gauge constraints forbid a positive isolated-constituent
sector while a singlet sector has positive mass). *Confinement as "which quotient
sectors admit positive mass spectra"* is a genuinely new **[spec→C]** angle, adjacent
to the S1-CC sector machinery. Depends on **[job: bindingplane]** (does the carrier's
own `K` bind?).

### P-E. "Gauge curvature is a signed mass operator, not energy"
Already partly **[in-paper]**: the manuscript distinguishes the positive Wilson/defect
`|F|²` energy from the signed `σ·F`-shaped `Q_C` mass channel. Grow into a clean
two-object statement: `E_closure ∼ |1−U_□|²` (positive gauge action) vs
`Q_C ∼ [γ,γ][∇,∇]` (signed spectral mass). Thesis: *where mass comes from* and *where
gauge energy is stored* are different questions. A short, sharp paper.

### P-F. "Generations as inequivalent null-coherence modules — a family index theorem"
The manuscript correctly refuses lepton-mass numerology (Koide killed; neutrino ratio
a category error without a family index + scale map). The deep reframing: a
"generation" is **not** a repeated particle with a bigger scalar mass but a *different
irreducible way* the same strand/charge data sits in the carrier category. Shared
external charges (same strand occupancy) + different projective-coherence modules
(different masses); mixing matrices = overlap maps between modules; neutrino lightness
= modules near index-protected/reflection loci. **The prize target:** a *family index
theorem* — prove the finite carrier category has exactly **three** inequivalent
positive-sector completions for a given charge pattern. Far deeper than fitting three
numbers. **[job: family-index]** (very hard; may return "not forced," itself
informative).

### P-G. "Gravity is the defect of the null ruler"
The soldering `E`-slot changes *what it means for two null directions at neighboring
sites to be comparable* — gravity is the **holonomy of the measuring apparatus for
mass**, not another additive force term. A finite equivalence principle: locally one
can gauge the null ruler coherent; the soldering-gradient defect records the failure
to globalize. Transformation law first (does `E_#` transform like discrete
contorsion/nonmetricity?), dynamics second. `E_#` splits into torsion + nonmetricity,
pure-torsion is dead **[in-paper M]**. **[job: eslotgeometry]**.

### P-L. "One operator, both forces": the unified gravity + QFT program (2026-07-09)
The framework already carries gravity and matter as graded channels of ONE finite Krein
Dirac square `4 D#D = Q_A + Q_C + 4Q_T + 4E_#` (aperture/closure/turn = matter/gauge/Higgs;
soldering `E_#` = gravity). The unification program is to bring the gravity channel to parity
with the matter channels and to prove they are *the same operator's* pieces. Two established
routes to "gravity + matter from one object", each with a discrete precedent this program can
imitate finitely:

1. **Spectral action (Connes–Chamseddine).** One functional `Tr f(D/Lambda)` gives
   Einstein–Hilbert + Yang–Mills + Higgs at successive heat-kernel orders (Chamseddine–Connes–
   Marcolli, hep-th/0610241 "Gravity and the standard model with neutrino mixing" `[import]`).
   **Discrete precedent:** the spectral action on quivers / Bratteli networks (arXiv:2401.03705)
   `[import]`, finite-spectral-triple Dirac moduli (arXiv:0902.2068), and semi-Riemannian /
   Krein NCG-SM (arXiv:1812.00038, 1210.6575) `[import]` — our carrier IS a finite Krein
   spectral triple, so a finite polynomial-cutoff spectral action is the natural home.
   → **[job: spectral-action-avatar 2db9868c]** — one finite `S(D)=a0 tr1 + a2 tr D^2 + a4 tr D^4`
   whose order-2 term is the gravity (soldering) sector and order-4 term is the matter (channel)
   sector; "one action, both forces", finitely.
2. **Thermodynamic / equation-of-state (Jacobson).** The field equation follows from imposing
   the Clausius relation `delta Q = T delta S`, `S ~ area`, across every local causal horizon
   (Jacobson, gr-qc/9504004 "Thermodynamics of space-time: the Einstein equation of state";
   entanglement-equilibrium version 1505.04753; causal-diamond version 1812.01596; non-equilibrium
   / entropy-production f(R) extension gr-qc/0602001 `[import]`).
   → **[job: jacobson-clausius 4aa9db52]** — finite avatar: area = pierced-edge count, heat =
   soldering-budget flux, `T` = a finite Unruh constant; the finite soldering field equation IS
   the integrability condition of `delta Q = T delta S`.

The two additional unification rungs tie the routes to the matter side:
- → **[job: gravity-source-matter 5466cd30]** — the finite field equation `solderingCurv =
  kappa * matterBudget`: geometry (soldering) is sourced by the MATTER channels (Q_A+Q_C+Q_T),
  channel-blind (= the weak equivalence principle). The finite `G = kappa T` coupling.
- → **[job: unified-mass-budget 65b5558c]** — the one-theorem statement: matter mass
  (Q_A+Q_C+Q_T) and gravity mass (E_#) are graded pieces of one operator `4 D#D`, their shares
  sum to one budget, and that budget equals the SAME kinematic null-disagreement `det P`. One
  operator, one invariant, four channels, both forces.

**Honest boundary (sharpened by the §7 audit).** This is a finite structural unification: gravity
and matter as channels of one finite Dirac square, kernel-checked at the finite level. It is NOT
quantum gravity in the LQG/string sense (no dynamical quantized metric, no graviton, no UV
completion) and NOT a continuum QFT (RP/OS/RG are finite; only the 1+1D checkerboard→Dirac limit is
imported). Two further limits the manuscript §7 correction makes explicit, and which this program
inherits: (i) the finite `tr(D²)` = Einstein–Hilbert identification is *definitional bookkeeping*,
**not** the Chamseddine–Connes heat-kernel theorem — a finite module has no manifold or short-time
limit, so the content that makes order-2 = curvature (`a₂ ∝ ∫R√g`, with the sign/`G` normalization)
is `[import]`, not reproduced here; (ii) the variational, Jacobson equation-of-state, teleparallel,
and WEP routes are *known-equivalent* presentations of one field equation (TEGR ≡ GR is a theorem),
not independent corroborations. The channel↔physics identifications stay `[C]`; absolute scales stay
outside. The gravity side is the thinner half and these four jobs are its parity push.

**Cosmological constant.** The one big-ticket cosmology item where this framework has a genuine,
already partly-kernel-checked handle is `Lambda`, via the causal-set "everpresent `Lambda`"
mechanism (`Lambda ~ 1/sqrt(V)`, the observed `~10^-122`; the scaling arithmetic is M in
`NullEdgeP9EverpresentLambdaScaling`), plus `Lambda` as the order-0 term of the spectral action
(the `spectral-action-avatar` job). Full analysis, grades, honest boundary, and the proposed
`lambda-edge-count` rung: `Sources/Null_Edge_Cosmological_Constant_2026-07-09.md`.

### P-H. "The continuum dictionary through quantum walks"
Route: finite null carrier → quantum walk/checkerboard → Dirac/Weyl continuum →
gauge-coupled field theory. **Not** QCD-first. First prove: *our finite carrier
specializes to a known quantum-walk Dirac model* (Foster–Jacobson 4D checkerboard,
arXiv:1610.01142; Mlodinow–Brun symmetry-forced Dirac walk, arXiv:1802.03910 — both
already cited), and the Plücker mass / turn amplitude / aperture−closure gap coincide
with known walk parameters in the scaling limit. **[job: checkerboardbridge]**. The
highest-stakes bridge (decides whether the channel names are physics).

### P-I. "Mass monogamy: a conservation law for relational mass"
Mass monogamy is **[in-paper M]** (`pairwiseMass_append`: `m²(A∪B) = m²(A)+m²(B)+
m²_cross`). Grow into a conservation principle: mass can be **redistributed but not
copied**. Constrains decay (daughter mass budget), binding (missing mass encoded as
signed closure + cross-disagreement), and — **[spec]** — *dark sectors as
null-disagreement sectors weakly soldered to visible charge*: dark mass would not need
dark massive primitives, only hidden null bundles that gravitate/solder but barely
enter the visible gauge budget. Flag the dark-sector reading as highly speculative.

### P-J. "Mass is scatterable geometry: a mass profile is an index of refraction for null coherence"
Oracle-grade in the manuscript (`carrier_scattering_sim`: transmission falls with
barrier mass, → transparency as the gap → 0). Reframe: a massless region is
transparent (preserves projective coherence); a massive region scatters (forces
incoming null directions to turn/mix/dephase); a bound state is a standing wave of
trapped null coherence. **Experimentally simulable** in photonic quantum walks,
trapped ions, superconducting circuits: build a coin/mass barrier, tune toward the
aperture–closure critical line, watch scattering become transparent. The most
near-term *experimental* analogue.

---

## The research-program order (both reviewers converge)

Do these in order; **fit no physical numbers until forced**:

1. **Carrier rigidity** — is the four-block square essentially unique given the
   axioms? The single most important mathematical frontier: if it holds, the carrier
   is a finite universality class; if not, identify the selecting axiom. **[job:
   carrierrigidity]**.
2. **Positive-sector classification** — classify which Clifford/Krein/constraint data
   yield positive sectors, balanced sectors, protected-null sectors. Generalize
   `T2_positive_mass` from example to theorem; the dream is a finite phase diagram
   `massive |κ|<λ / critical / indefinite`. **[job: positive-sector-classification]**.
3. **Mass-phase classification** — the multi-channel phase diagram (P-B).
4. **Continuum dictionary via quantum walks** (P-H).
5. **Physical ratios — last.** Only after 1–4: dimensionless, protected, structural
   ratios (never absolute masses or premature proton decompositions).

---

## Graduated to the manuscript (no longer future work)

- **Masslessness taxonomy** — Pro proposed it as a frontier; it turned out all four
  kinds are already kernel theorems (collinear §3, critical §4, index-protected §8,
  gauge-quotient §6), so it was added to §8 as a backed result, not a direction.
- **Finite mass phase diagram (3-phase)** — completed in §4 (added the over-closure
  tachyonic phase).
- **Mass = concurrence² (general n)** and the **mass↔entropy dictionary** — landed as
  M this run (§3a).

---

## Cross-reference: running Aristotle frontier jobs (2026-07-08)

| Direction | Job | ID |
|---|---|---|
| Universal null decomposition (mass = coherence failure) | nulldecomp | 15f19a55 |
| F6 chiral-index protected modes (extends §8) | chiralindex | bd0349a8 |
| F8 binding defect = entanglement deficit (P-C/P-D) | bindingdeficit | b76379eb |
| F5 carrier `K` in the binding plane (P-D) | bindingplane | 6b0d5321 |
| F4 structured/winding low modes | windinglowmodes | 0c848e8e |
| F1 checkerboard continuum bridge (P-H) | checkerboardbridge | 5511075a |
| F2 carrier rigidity (program step 1) | carrierrigidity | 0e0f0db4 |
| F7 gravity E-slot transformation law (P-G) | eslotgeometry | cf0ecc48 |

Follow-up jobs queued from Pro's round-2 analysis: multi-channel phase diagram (P-B),
positive-sector classification (program step 2), family index / three generations
(P-F).

---

## Deeper organizing layers (round-3 analysis) — all grade [spec]

Two successively deeper reframings of the same kernel-checked core. Neither is a
result; both are candidate *ontologies* that would sit under the whole program.

### Layer 1 — the projective null-coherence field
The primitive is not a particle or even a null bundle but a **field of null rays**
`[ψ_e] ∈ ℂP¹` over the finite complex, with transport `∇`, chirality turn `Γφ`, and
Krein sector `J`. Then:
- **Massless = global projective synchronization** (`[ψ_e]=[ψ_f]` for all visible
  edges); massive = synchronization failure.
- **Mass = curvature of the projectivized null-ray connection.** Transport a ray
  around a finite loop: if it returns to the same projective direction the loop is
  coherence-flat; if rotated, it has opened projective area — measured by the same
  wedge norms that give mass. Slogan: *unification is decomposition of
  projective-coherence curvature.*
- **Three separated scales** the theory should never conflate: projective *angle*
  (dimensionless, protected ratios — what the theory owns), *amplitude* (absolute
  MeV/GeV scale — NOT derived), *sector* (does the Krein form admit a positive
  physical sector). This is why the theory is strong on counts/signs/ratios/phases
  and silent on absolute masses.

### Layer 2 — finite quantum information (the deepest condensation)
The primitive is finite quantum information: pure directional messages, finite
registers, coherent path sums, and loss/protection of distinguishability.
- **Mass = visible mixedness of the direction register after hidden which-direction
  information is coarse-grained.** `ρ = P/tr P`; collinear ⇒ rank-1 (massless);
  disagreeing ⇒ rank-2 (massive); `det P = Σ w_i w_j |ψ_i∧ψ_j|²`; `det ρ =
  (1−tr ρ²)/2` = linear entropy = (two-edge) concurrence². [in-paper M] for the
  identities.
- **The path-conditioned visible state** `ρ_dir = Σ_{h,h'} a_h ā_{h'} Ω_{hh'}
  |ψ_h⟩⟨ψ_{h'}|` with coherence matrix `Ω_{hh'}=⟨E_{h'}|E_h⟩` contains the whole
  theory: `Ω=1` fully coherent (interference), `Ω=δ` fully decohered (mixture). Mass
  is *retained which-null-direction information after hidden histories are traced
  out* — a failure of coherent compression, **not** mere ignorance (which is why
  signed closure can *lower* mass: it reorganizes coherence, it is not noise).
- **The four channels are four information defects:** aperture = directional
  distinguishability cost; closure = loop memory/holonomy (signed, phase-sensitive
  ⇒ binding possible); turn = cost of converting one protected register into another
  (Higgs = the resource permitting the chirality gate); soldering = drift of the
  directional *codebook* (gravity = failure to globalize the null-direction
  dictionary).
- **Confinement = non-decodability:** a colored algebraic excitation may exist in the
  raw (indefinite) amplitude ledger but fail to define an isolated positive codeword;
  singlets are the composite codewords that survive the positive-sector quotient.
- **Binding = compression advantage:** a bound codeword stores the same external
  information at lower visible mass cost than its separated constituents.
- **RG = repeated lossy compression;** emergent mass = hidden pure structure turned
  into visible entropy under coarse-graining (visible mass can rise even as total
  information cannot — mass is visible *mixedness*, not total information).

Condensed thesis (grade [spec]): *matter is compressed lightlike information; mass is
the mixedness left over when the compression cannot be made coherent* — equivalently,
**mass = the obstruction to representing a finite quantum history ensemble by one pure
null-direction message.**

**The finite quantum automaton picture.** The whole theory presents as a finite
quantum automaton over registers `|vertex, direction, internal⟩`, with local gates
(null step `c(α)∇`, turn `Γφ`, internal transport, soldering comparison); the finite
path sum is the sum over automaton histories, `D` is the update/constraint rule,
`D^#D` the information-cost operator, and the spectrum of `D^#D` on the positive code
sector gives the stable masses. So **a particle is a stable eigen-code of a finite
quantum automaton** — the sharpest form of "particle = positive-sector codeword."

**The Standard-Model ↔ information dictionary** (grade [spec] — a translation, not a
derivation):

| Usual language | Information-theoretic language |
|---|---|
| Particle | positive-sector stable codeword |
| Mass | visible mixedness / null-direction distinguishability |
| Gauge charge | internal label preserved by allowed code transformations |
| Gauge field | path-dependent internal relabeling rule |
| Curvature | loop memory / non-erased path information |
| Higgs/Yukawa | chirality-register coupling gate |
| Gravity/soldering | drift of the directional codebook |
| Confinement | failure of non-singlet messages to decode positively |
| Bound state | joint codeword with a compression advantage |
| Massless particle | rank-one, protected, or quotient-null codeword |
| Generation | inequivalent positive-sector encoding of the same external labels |

"Unification is decomposition" reads: **the forces are the four canonical information
defects in a finite null-code** — unified not by being identical but by being the four
terms of one information-cost square `D^#D` (directional distinguishability + loop
memory + chirality conversion + codebook drift).

**Naturalness = protection of low-rank information.** A small mass is stable only if
the visible direction state is kept near rank-one for a structural reason — the same
three mechanisms as the manuscript's masslessness taxonomy (§8): projective
(near-collinear), index (unpaired chiral sector), or critical (aperture ≈ closure).
A small mass without one of these is unnatural in the theory.

---

## Pre-registered conjectures (with kill conditions)

From the round-3 analysis. Each is grade **[C]**; three map to already-running jobs,
three are newly jobbed (see below).

- **A. Coherence-curvature rigidity.** The four-channel split is *forced* by finite
  null soldering + Krein positivity + chirality + local transport. *Kill:* a fifth
  independent channel, or two inequivalent decompositions under the same axioms.
  → job `carrierrigidity` (0e0f0db4).
- **B. Sector confinement.** Non-singlet gauge sectors fail to admit an isolated
  positive mass sector; singlets can. *Kill:* a colored positive sector with stable
  isolated mass and correct constraint descent. → **new job** `confinementpositivity`.
- **C. Family index three.** The SM charge pattern has exactly three inequivalent
  positive-sector completions. *Kill:* prove one/two/four/∞ under the same axioms.
  → job `familyindex` (4f822368).
- **D. CP phase as projective holonomy.** The physical CP phase is the
  gauge-invariant phase of a triple/quadruple null-ray holonomy
  `(ψ₁∧ψ₂)(ψ₂∧ψ₃)(ψ₃∧ψ₁)`; magnitudes give disagreement, phases give a Bargmann
  invariant. *Kill:* all such phases gauge away in the relevant carrier.
  → **new job** `cpholonomy`.
- **E. Small mass from protected Schur leakage (finite seesaw).** A chiral/index-
  protected massless mode acquires mass only through Schur-mediated leakage into a
  hidden heavy block, suppressed as `m_eff ~ (visible–hidden overlap)² / M_hidden`.
  *Kill:* the protected mode stays exactly massless under all allowed leakage, or
  receives unsuppressed mass generically. → **new job** `schurseesaw`.
- **F. Structured (not random) closure creates condensate shadows.** Near-zero
  accumulation needs coherent/topological closure backgrounds. *Kill:* random
  backgrounds robustly raise near-zero counts under refinement. → job
  `windinglowmodes` (0c848e8e).

New conjecture-driven jobs (round-3), all submitted 2026-07-08:
- `schurseesaw` `9fb722f7` (E — neutrino-lightness: `m_eff ≤ ‖Bᴴv‖²/λ_min(M) → 0`)
- `cpholonomy` `c57c871b` (D — CP as the phase of the triple null-ray holonomy `J`)
- `confinementpositivity` `f30e34a2` (B — colored ⇒ indefinite, singlet ⇒ positive)

---

## Round-4 (Fable): theorem-shaped sharpenings — with a large "already done" surprise

Fable's round-4 recast the two ontology layers as *theorem-shaped* claims with kills.
Triage found that several are already proven in the repo (Fable is blind to it), one
**landed** this pass, and four are genuinely new and jobbed.

### Landed / already M
- **`mass ≤ energy`, extremal at rest [LANDED M].** `det P ≤ (tr P/2)²` (`m ≤ E`),
  equality iff `P` scalar = rest = max-mass & max-mixedness at fixed energy
  (`MassEnergyBound.det_le_half_trace_sq`, M, guard-pinned; added to §3a). Fable's
  "do first" M-target — an afternoon of Lean, now in the trusted core.
- **Conjecture G (mass–coherence duality) — substantially ALREADY M.** The EGY-type
  `mass² + visibility² = 1` is essentially `NullEdgeCelestialMixednessAristotle`'s
  `blochDensity_det_eq_one_sub_radius_sq` (`det ρ = 1 − r²`) + purity/linear-entropy
  lemmas. No job needed; surface it as the P-C payload.
- **Conjecture D (CP as Bargmann holonomy) — substantially ALREADY M.** Fable's
  *correction* to `cpholonomy` (use the phase-gauge-invariant **Bargmann** triple
  `⟨ψ₁|ψ₂⟩⟨ψ₂|ψ₃⟩⟨ψ₃|ψ₁⟩`, not the wedge triple which kills on a gauge artifact) is
  already `NullEdgeBargmannPhaseInvariance.bargmannTriple_phase_invariant` (+ smul,
  trace versions). The submitted `cpholonomy` job (wedge triple) is superseded by
  this module — don't over-integrate it; the CP-oddness + "phase = celestial solid
  angle" geometric reading are the only remaining pieces. Twistor chart
  (`TwistorPluckerMass`) and celestial Bloch machinery already exist too.

### New conjectures (Fable's format) + jobs
- **H. WAY-turn no-go.** No isospin-conserving closed-carrier unitary implements the
  chirality gate with trivial ancilla (`[U,Q_s⊗1+1⊗Q_a]=0 ∧ U=u⊗1 ⇒ [u,Q_s]=0`); the
  turn needs a charge-coherence ancilla (the Higgs), `m ∝ φ` with 1/variance
  corrections. The no-go half is a near-term M. *Kill:* an exact charge-conserving
  chirality gate with trivial ancilla. → job `wayturn` `10a914e3`.
- **I / paper P-K. Design hierarchy of mass.** `|ψ∧φ|² = sin²(θ/2)` ⇒ bundle mass is
  a chordal-energy on S²; sub-bundle mass spectra see higher moments; spherical
  t-designs are the mass-uniform bundles; Cohn–Kumar universal optimality (completely
  monotone) transfers → LP bounds on mass budgets. Pure §3 kinematics, imports the
  sphere-packing toolkit wholesale. *Kill:* two non-isomorphic 2-designs with
  distinguishable pair-mass multisets. → job `massdesigns` `a02602f5`.
- **J. Modular selection.** The Gibbs state in `B` has modular flow = `exp(−itB)`, so
  D2's generator is *derived*, not posited (Connes–Rovelli thermal time, finite); the
  channel-GGE equipartition gives "do the four channels thermalize to one β?". *Kill:*
  KMS generator on T2 provably not ∝ `B`. → job `modularselection` `0053fc61`.
- **L. Finite Levinson.** Bound-state count of the barrier walk = scattering-phase
  winding = reflection-sector index (+ a finite optical theorem). Gives P-J a theorem
  spine (Cedzich–Grünbaum–Werner discrete Levinson as [import]). *Kill:* a
  rational-fixture walk with count ≠ winding. → job `finitelevinson` `10bf50fd`.
- **K. Code distance = area law** — folds into `confinementpositivity` as its proof
  strategy: don't attack colored-sector positivity head-on; bound colored-sector norms
  via the M-grade strong-coupling area law (Gauss sector = BRST cohomology wearing a
  QEC code; code distance = minimal disagreement to expose color, grows with region).

### Two strategy notes
- **Twistor literature gates P-B.** The projective layer IS discrete twistor theory
  (Penrose/Perjés/Hughston n-twistor massive particles carry internal symmetry —
  SU(2)×U(1) for two twistors, SU(3) for three). Checkable on the Cl(4) carrier: does
  the k-edge strand charge algebra reproduce the k-twistor internal symmetry algebra?
  Either a huge legitimacy anchor for P-B, or a clean kill. P-B must cite this.
- **Program order:** insert the P-K extremal/design layer immediately after steps 1–2
  (rigidity, positive-sector classification) and *ahead* of the multi-channel phase
  diagram — it's pure §3 kinematics, all M-targets, zero interpretive risk, and
  credibility compounds fastest where the grades are highest.

---

## Round-5 (Fable): foundations — converting inputs into theorems

The prior rounds extended the framework *outward*; round-5 goes *underneath*, at the
four structures currently taken as given (signature, dimension, the complex, the
operator->geometry arrow) — each convertible from input to theorem-target. Several
land on the Q5 dimension/signature-selection thread.

### Landed this pass (M)
- **O. Subluminality [LANDED M].** From the pinned dispersion `cos w = cos k cos th`
  (`ContinuumLimit`), `v_g^2 <= 1` with luminal deficit `1 - cos^2 th = sin^2 th >= 0`;
  every massive mode STRICTLY subluminal, only the massless (`th=0`) luminal
  (`SubluminalBound.massive_implies_subluminal`, `luminal_iff_massless`, M,
  guard-pinned; added to S2a/S9/S11). "Nothing outruns light, only the massless reach
  it" is now a theorem. Boost symmetry NOT derived (critical-point only) -> Conj Q.

### Foundational conjectures (M-U) + jobs
- **M. Signature forcing.** null primitive (`c(v)^2=0, c(v)!=0`) => indefinite Gram
  (rung 1, one line); slab RP fails for two-time signatures => exactly one time (rung
  2, probe vs the M-grade RP pillar; cross-check: null quadric `(S^{p-1}xS^{q-1})/Z2`
  is connected iff `p=1` or `q=1`). *Kill:* a `(2,2)` carrier passing OS positivity.
  -> job `signatureforcing` `d58cb415`.
- **N. Division-algebra dimension selection [HIGH VALUE, feeds Q5].** `2x2` Hermitian
  over R,C,H,O = Minkowski d=3,4,6,10; composition (tensor products) + continuous
  abelian CP phase (Bargmann) jointly force K=C, d=4 (R: real wedge, no phase; H:
  noncommutative Sp(1), no cyclic triple; O: associator obstructs). *Kill:* a
  quaternionic Bargmann invariant with tensor composition. Bonus: the `3x3`
  octonionic (exceptional Jordan) failure mode is where the family index (Conj C)
  lives, NOT d=4. Heavy existing scaffolding (`Algebra/Division/*`, `SpinorTenfold*`
  d=10 CAR, Furey/triality). -> job `divisionselection` `79b0b772`.
- **P. Spectral geometry recovery.** Lorentzian Connes distance on T2 reproduces the
  complex's metric (finite Malament: order=>topology, decorations=>conformal
  factor=mass scale, E-channel = order-vs-scale mismatch). *Kill:* distance
  degenerates. -> job `spectraldistance` `be0b5442` (the one piece genuinely absent
  from the repo).
- **R. Finite CPT [M].** `Theta = C.Gamma_rev.#` antiunitary, `Theta D Theta^{-1} = D^#`,
  spectrum conjugate-paired. Edge-reversal + `chiral_det` machinery already exist
  (`GWEdgeReversalBridge`, `FermionicReflection`, `ChiralZeroModeParity`). *Kill:*
  axiom-satisfying carrier with unpaired spectrum. Landed on an explicit `C^4`
  Clifford/color witness as `FiniteCPT` (`e690c3b3`); arbitrary-carrier CPT remains
  a separate generalization target.
- **Q. Critical universality [oracle probe, not jobbed].** Decimation flow at `k=l`
  has free-Dirac RG eigenvalues, dynamical exponent `z=1` (emergent isotropy = birth
  of boost symmetry), non-channel couplings irrelevant. Reframes S4a: "channel names
  are physics" = "carrier in the free-Dirac universality basin". Measure with
  `carrier_rgflow_sim` (numerical), NOT an Aristotle proof. *Kill:* `z!=1` or a
  relevant direction with no channel name.
- **S. Index = anomaly [sharpens `windinglowmodes`].** Winding closure backgrounds
  shift the protected-mode count by the winding (finite 't Hooft vertex); S8 index =
  finite axial anomaly; folds baryogenesis + condensate into "what does winding do to
  the CHIRAL index?" (caution: S8's vanishing invariant was the double-pinning object,
  a different index). -> the running `windinglowmodes` job's core question.
- **T. Enhanced criticality symmetry [C, logged].** A symmetry generated by the `k=l`
  zero mode pins the critical line; near-critical lightness becomes pseudo-Goldstone /
  't Hooft-natural. *Kill:* the zero mode generates nothing constraining `k-l`.
  [M-target: find/refute the enhanced symmetry on `B(l,l)`.]
- **U. Compton bound [C, logged].** No `J`-positive state localizes below `1/(l-k)`
  (finite Hegerfeldt/Newton-Wigner); sub-Compton localization forces negative-Krein
  components (finite image of pair creation) — the mass gap becomes a length. *Kill:*
  an explicit sub-Compton state in the T2 positive sector.

### Sharper implications (all [spec] / [C])
- **Hierarchy = a symmetry hunt.** Three natural masses (index-zero, critical-cancelled,
  generic O(l)); small-nonzero is either Schur seesaw (jobbed) or near-criticality
  (natural only if Conj T's symmetry exists).
- **Dark matter shape.** Empty strand list => gauge-invisible, still solders, mass only
  via seesaw leakage => the framework predicts dark mass is ALWAYS seesaw-suppressed
  (light/warm, no heavy WIMP primitives) — a falsifiable shape, not a number.
- **Finite Sakharov.** Once CPT (R) is a theorem, asymmetry is from the state: C = strand
  reversal asymmetry, CP = Bargmann celestial-area phase (D), non-equilibrium = non-KMS
  modular states (J), B-violation = chiral-index flow on winding (S).
- **Finite Euclidean gravity.** D5 ensemble over soldering decorations at fixed area =
  finite Euclidean QG; first law = a D5 identity; gravitons = coherences between
  soldering configs (E-channel second quantization).

### What stays untouchable even if all of M-U land (the program's event horizon)
The absolute mass scale (ratios only, ever); the Born rule / measurement (the finite QI
layer USES quantum probability, doesn't derive it); initial conditions (why THIS ensemble
state); and the number of null edges. A framework that knows its own event horizon is
more credible inside it.

---

## Round-6 (Pro, meta-feedback on Fable round-5): synthesis + one new target

Pro's round is a **synthesis** of the round-4/5 material — the finite-null-information
ontology, mass-as-decoding-rank, the coherence matrix `Omega`, the four info-defect
channels, signature forcing, division selection, subluminality (landed), geometry
recovery, universality, CPT/Sakharov, Compton, dark-matter shape, and the "event
horizon" boundary are all already logged above or jobbed. One genuinely-new target:

- **V. Mass thermodynamics / Gibbs–Duhem [new M-target, jobbed].** The budget
  `b_A + b_C + b_T = 1` (kernel-checked) makes mass an equation of state:
  differentiate to get `Sum_X chi_{XY} = 0` (susceptibility sum rule), compute the
  susceptibility matrix in closed form on `B(l,k)`, and prove a channel
  susceptibility **diverges as `k -> l`** — the thermodynamic signature of the
  massless transition, stated with already-M objects. *Kill:* the sum rule fails /
  no divergence at criticality. -> job `massthermo` `2e522ee0`.

### The five-laws synthesis (grade [spec], organizing framing)
Pro's compact statement of the developed theory, worth recording as the target
skeleton for the eventual "finite null information dynamics" framing:
1. **Null purity** — elementary messages are rank-one null direction states
   `rho_edge = |psi><psi|`.
2. **Mass as decoding rank** — a bundle is massive iff hidden null histories cannot
   compress to one rank-one direction state; `m^2 = det P`. [in-paper M for the identity]
3. **Forces as decoding defects** — `D^#D = aperture + closure + turn + codebook drift`.
4. **Physicality as positivity** — a particle is a codeword in
   `(ker Q / im Q)^+` (Krein-decoded positive sector).
5. **Spacetime as recovered code geometry** — signature, dimension, causal order,
   distance, and the speed limit are RECOVERED from null information + composition +
   reflection positivity + spectral distance + critical universality (jobs M/N/P/Q +
   the landed subluminality O).

Candidate mature title (grade [spec], for a much later paper, NOT the current
manuscript): *"Finite Null Information Dynamics: Mass, Causality, and Geometry as
Decoding Obstructions"*; one-line thesis: *mass is the positive-sector spectral cost
of compressing finite null histories into one visible direction message.*

**Meta-note (recorded for discipline):** external analyses have now fully converged —
rounds 3-6 increasingly restate the same ontology and re-propose already-done or
already-jobbed work. The conceptual layer is saturated. Next action is a **harvest
pass** over the ~22 running frontier jobs, integrating what survives the kernel and
recording the no-gos — not further intake.

---

## HARVEST RESULTS (2026-07-08) — what the frontier jobs returned

Kernel verdicts after downloading, building in-project, and semantic-reviewing each
completed job. All integrated modules build green with footprint
`[propext, Classical.choice, Quot.sound]`.

### Proof jobs — clean M (integrated into the manuscript)
- **nulldecomp** — the converse: all mass IS null-edge disagreement (bidirectional). §3.
- **chiralindex (F6)** — `dim ker >= index`, perturbation-stable, >=1 protected mode. §8.
  (Only the >=1 bound; "exactly one" needs full-rank corner, out of scope.)
- **bindingdeficit (F8)** — `Delta = kappa = C(rho)*lambda`, binding = entanglement deficit;
  closes §3a target (ii) **C->M**.
- **schurseesaw (E)** — `|m_eff| <= ||B^H v||^2/lambda_min(M) -> 0`, finite seesaw. §10.
- **massenergy (O-adjacent)** and **subluminal (O)** — landed earlier this run.

### Strategy jobs — M / structural wins (integrated as draft modules)
- **F5 bindingplane [WIN, C->M]** — the carrier's OWN `K = closureCurvature`, so the
  carrier binds UNCONDITIONALLY (`CarrierClosurePlane.carrier_closure_binds`). This is the
  decisive upgrade of §9's DerivedInteraction from "closure *can* bind" to "*this* carrier
  binds". → manuscript §9.
- **F1 checkerboardbridge [WIN]** — the 1+1D Dirac quantum walk IS a Krein null-edge carrier;
  kinetic/mass/D all Krein-self-adjoint, channel names match (`CheckerboardCarrierBridge`).
  First evidence that the channel names are physics (the P-H continuum bridge, first rung).
- **F7 eslotgeometry [WIN]** — the E-slot has a genuine transformation law (tensorial on the
  metric-preserving group), splits into contorsion (metric-compatible) + nonmetricity, with
  no double-counting vs `Q_C` (`ESlotGeometry`). Gravity channel gets real geometry (P-G).
- **F4 windinglowmodes [WIN, +Conj S]** — winding-`w` closure background has `>= w` protected
  zero modes, disorder-robust (`WindingLowModes.winding_protects_low_modes`); index = w.
  Structured (not random) backgrounds accumulate low modes — and this IS the finite 't Hooft
  vertex (Conjecture S).
- **positive-sector classification (step 2) [WIN]** — `A PosDef => (A + B^H B) PosDef`, mass
  gap `>= 1` (`PositiveSectorClassification`); generalizes the `T2 = 1 + B^H B` positivity
  beyond the `Cl(4)` witness (closure entering squared can never destabilize a positive
  aperture).
- **Conjecture B confinementpositivity [WIN]** — colored (traceless) sub-sector is negative-
  definite (no isolated positive mass); the color singlet is positive. Confinement as a finite
  positivity dichotomy (`ConfinementPositivity`).
- **Conjecture D cpholonomy [SUPERSEDED]** — the three wedge-triple identities are true M, but
  the wedge triple is not phase-gauge-invariant; the gauge-invariant CP object is the already-
  proven `NullEdgeBargmannPhaseInvariance.bargmannTriple_phase_invariant`. Not integrated.

### Strategy jobs — honest NO-GOs / nuanced verdicts (recorded, not over-claimed)
- **F2 carrierrigidity [NON-RIGID, but structured]** — `CarrierRigidity.square_decomposition`
  proves the exact four-block identity `2(D#D) = Q_A + Q_C + 2E_# + 2Q_T` with **no fifth
  block** (the channel TYPE-count is forced), AND the four channels have distinct even/odd
  Krein grades. But full rigidity (uniqueness of the split) is **NOT forced** — two extra
  structures make it non-unique. So "unification is decomposition" is disciplined: the
  four-block *structure* is forced; the *decomposition* is not unique without a further axiom.
- **Conjecture C familyindex [NO-GO]** — the count of inequivalent positive-sector completions
  is exactly `n+1` (strand rank `n`), `= 3` iff `n = 2` (`FamilyIndexNoGo.count_completions`,
  `three_not_forced`). "Three generations" is NOT forced by the finite carrier category; the
  missing ingredient is precisely a rank-fixing axiom (`n = 2`). Honest negative — the
  replication index is underdetermined, exactly as pre-registered. **Closer landed
  (`FamilyRankNoGo.three_generations_not_forced` [M], 2026-07-09):** sharpens the no-go —
  each candidate rank-fixer (triality's S3, anomaly cancellation, the exceptional Jordan
  algebra J3(O)) is realizable at some `n != 2`, and `forcing_iff_rankfixing` proves any
  structure that DOES force `n=2` is logically equivalent to the datum `n=2` itself. So
  "three" must be an explicit input; none of the geometric/algebraic candidates derive it.

### Round-2 harvest (the four closers, 2026-07-09)
The four follow-up closers from the 2026-07-08 round all landed (all [M], footprint
`[propext, Classical.choice, Quot.sound]`, integrated as draft modules):
- **`finitecpt` (Conjecture R) [WIN]** -> `NullEdge/FiniteCPT` — a finite CPT theorem on an
  explicit non-degenerate `C^4` Clifford(x)color witness: `Theta` antiunitary,
  `Theta D Theta^-1 = D^#`, spectrum conjugate-paired. Suite C's CPT rung. Honest scope:
  the concrete witness, not arbitrary carriers.
- **`siglorentz` (Suite A rung 2) [WIN]** -> `NullEdge/RPSelectsLorentzian` — the minimal
  Osterwalder-Schrader toy: the `(1,3)` signature is reflection-positive with a nondegenerate
  physical sector, and **any second time direction (in particular `(2,2)`) FAILS** reflection
  positivity. Selects one time direction; also settles Suite A's A1 Assassin rung in the good
  direction (no OS-positive `(2,2)` toy). Honest scope: single-mode two-site toy, not full OS
  reconstruction.
- **`bargmanncp` (Conjecture D) [WIN w/ caveat]** -> `NullEdge/BargmannCP` — the Bargmann/
  Pancharatnam triple is CP-odd (`bargmann_CP_odd`), with `Im B != 0` a genuine
  non-gaugeable CP-violating invariant (`bargmann_CP_genuine_iff`). What is KERNEL-PROVED
  about the phase is the algebraic tangent identity `tan(arg B) = n1.(n2 x n3)/(1 + n1.n2 +
  n2.n3 + n3.n1)` (`bargmann_tan_arg_unit`); that this RHS is the Van Oosterom-Strackee
  expression for `tan(Omega/2)`, hence `arg B = Omega/2` (half the celestial solid angle), is
  geometric COMMENTARY — no solid-angle object is formalized (needs spherical-triangle theory
  absent from Mathlib). (Audit: Codex 2026-07-09, docstring-outruns-statement — tightened.)
  **Supersedes the `cpholonomy` wedge triple**; the CP-oddness half is the Bargmann object
  Goal II (finite KM / CP phase counting) builds on.
- **`rigidityaxiom` (F2 uniqueness) [NUANCED / abstract-only]** -> `NullEdge/GradedDecompUniqueness`
  — the delivered project had no carrier, so Aristotle formalized the GENERIC kernel: for an
  internal-direct-sum grading by an operator with pairwise-distinct eigenvalues the blocks are
  forced (`blocks_eq_eigenspaces`), the decomposition is unique (`decomposition_unique`), and
  the type-count alone does NOT force the split (`split_not_forced`). A true general lemma and
  the honest backbone for "which axiom upgrades type-count to uniqueness" (answer: candidate
  (a), nondegenerate soldering) — but it is NOT a carrier-specific uniqueness claim; wiring it
  to the real `2(D#D) = Q_A + Q_C + 2E_# + 2Q_T` carrier is separate work (open).

### Codex Goal II / IV seed landings (2026-07-09)

- **`KMPhaseCounting` [WIN / narrow M]** — finite CKM bookkeeping: the parameter split
  `N^2 = angles + removable phases + physical CP phases` and the threshold
  `0 < ckmPhysCP N <-> 3 <= N`. This gives the arithmetic spine for Goal II, but the
  real KM theorem still needs the constructive N=2 rephasing no-go and an explicit
  nonzero N=3 Jarlskog witness.
- **`FiniteKMCP` [WIN / M]** — the first substantive finite KM rung: plaquette/Jarlskog
  invariance under rephasing, the N=2 no-go (`jarlskog_two_eq_zero` and
  `exists_real_rephasing_two`), and an exact unitary N=3 `3-4-5` witness with
  `J = 6912 / 78125 != 0`. This closes the N=2/N=3 nondegeneracy gate.
- **`IncidenceCorank` [WIN / M]** — the general-N graph-incidence count now lands:
  for the complete-graph coboundary map on edge phases, `rank = N-1` and
  `corank = (N-1)(N-2)/2` over an arbitrary field, with N=2/N=3 fixtures.
  Honest scope: this is the linearized phase-count theorem, not a full unitary
  matrix normal-form theorem.
- **`WEPTrace` [WIN / narrow M]** — WEP as the finite trace identity
  `Tr((kappa * 1) rho) = kappa Tr(rho)`, with a nonvacuous equal-trace witness and
  a channel-stress negative control. This is Goal IV's cheapest trace rung, not the
  E-slot field equation or Clausius/Jacobson result.
- **`WEPActionBridge` [WIN / narrow M]** — turns the WEP trace source into a
  finite trace-level multiplier action: stationarity against all matrix
  variations is equivalent to `G = K`, and a channel-blind coupling gives source
  side `kappa * Tr rho`. Nonzero source witness included. Honest scope:
  trace/source bridge only, not the E-slot geometric action.
- **`MassResourceModularAudit` [WIN / audit M]** — central normalization shifts cancel
  in the commutator derivation (`ad(z+B)=ad(B)` for central `z`), while the operator
  equality `z+B=B` is false for nonzero shifts, now universally in the background
  operator `B`. This pins the Suite D modular false-shape boundary.
- **`IndexAnomalyInterface` [WIN / M interface]** — packages a signed finite toy
  index, proves the finite winding anomaly
  `toyIndex (Kw N w) - toyIndex (Kw N 0) = w`, and names the exact reduction
  hypothesis needed for an analytic index claim. Honest scope: finite rank-nullity
  only; no Fredholm/Atiyah-Singer content.
- **`GateI1.MassEntropyMonotone` [WIN / M]** — binary entropy is antitone in
  speed on `[0,1]`; visible entropy is monotone in invariant mass ratio on
  future-cone momenta; the bundled finite resource measure has null momenta as
  free states. Naming caveat: the current `ResourceMonotone` API is faithful and
  nonnegative; its order/monotonicity content is carried by separate lemmas.
- **`SuiteCDNextRungs` [WIN / M]** — collector of small next rungs: U(N) parameter
  decomposition, finite C3 relative-index identity, traceless Suite D channel
  charges, linear independence of the four coordinate-basis channel charges,
  pairwise commutativity, and commutation with `Bsum`. Honest scope:
  arithmetic/interface rungs, not a continuum theory and not a derived
  GGE/modular dynamics.
- **`KMFamilyRankBridge` [WIN / M]** — bridges Goal II to the family-rank no-go:
  exactly one physical CP phase is equivalent, in the finite arithmetic model,
  to `N=3`, to `n=2`, and to three positive-sector completions. Honest scope:
  this supplies the explicit rank-fixing datum; it does not physically derive
  the number of generations.
- **`KMFlagship` [WIN / M]** — the Goal II flagship composition now lands:
  `FiniteKM.physicalPhases N` equals the complete-graph incidence corank for
  `1 <= N`, while the low-N summary bundles the constructive N=2 rephasing
  no-go and the exact N=3 nonzero Jarlskog witness. Honest scope: linearized
  phase-count/corank theorem plus low-N witnesses; no global unitary normal form
  for arbitrary `N`.
- **`IndexProtectionBridge` [WIN / M]** — composes the finite winding anomaly
  with low-mode protection: the relative signed finite index equals `w` and
  at least `w` kernel modes are protected, with a `w=1` fixture. Honest scope:
  finite rank-nullity only; no analytic index theorem.
- **`WEPActionResourceBridge` [WIN / narrow M]** — packages the channel-blind
  total-budget source from the stationary trace action with the finite
  mass-entropy resource witness pair (null zero / rest positive). Honest scope:
  source/resource bridge only; no Clausius/Jacobson step.
- **`MassResourceConsistency` [WIN / M]** — bundles Suite D guardrails:
  Gibbs-Duhem tracelessness, coordinate-charge linear independence,
  finite commutativity/conservation by `Bsum`, central-shift generator
  invariance plus raw-operator false-shape guard, and mass-entropy faithfulness.
  Honest scope: consistency bundle, not a thermodynamic-limit derivation.

### Claude assembly Goal landings (2026-07-09)

- **`Goal3ExactRG` (Goal III) [WIN / M, all 4 rungs]** — exact rational RG of the chain
  carrier: `R(lam,kap) = (lam - 2 kap^2/lam, -kap^2/lam)`; critical line `|kap|=|lam|`
  invariant (non-deg witness `R(1,1/2)=(1/2,-1/4)`); Jacobian `[[3,-4],[1,-2]]`, relevant
  eigenvalue exactly 2 (=> `nu=1` as the standard RG reading); conical shell `(k.sz)^2=k^2`
  (=> `z=1`). Honest: critical LINE invariant as a set (period-2 sign flip), not a strict
  fixed point; `nu`/`z` are interpretive readings of the kernel eigenvalue/dispersion data;
  finite rational, no continuum.
- **`Goal3BoostCov` (Goal III rung e) [HELD — delivered but does NOT build in-project]** —
  discrete boost covariance is EMERGENT: `Boost c s = [[c,s],[s,c]]` with `c^2-s^2=1`
  preserves `Q=w^2-k^2` (3-4-5 witness `Boost(5/3,4/3)`, det=1, !=1); the massless light cone
  maps to itself (`massless_walk_boost_covariant`), while off criticality the same boost LEAVES
  the lattice shell `cos w = cos k cos th` (`massive_walk_boost_covariance_fails`, explicit
  `(pi/3,0)->(5pi/9,4pi/9)`). Honest: covariance = mass-shell-set + Q-form invariance, NOT a
  fixed-operator spinor intertwiner; massive breaking is a lattice effect of the transcendental
  dispersion. **NOT LANDED: the module does not build in-project within budget (SIGTERM at
  582s even solo — a pathological elaboration cost, likely the transcendental-trig fixture
  proofs `cos(5pi/9)<0` etc.). Per run discipline it is HELD as a draft-handoff (preserved at
  `AgentTasks/overnight-allmass-run-2026-07-09/harvest/boostcov/`), NOT a landed M anchor, and
  is NOT in the manuscript. Follow-up: re-derive the fixtures with a bounded, fast proof (or a
  `maxHeartbeats`-scoped rational-cosine bound) so it builds here.** The exact-RG result
  `Goal3ExactRG` already carries the "relativity born on the critical period-2 line" story that landed.
  **RESOLVED: `Goal3BoostCovRational` [M, landed 2026-07-09]** re-derives the buildable core
  over Q (no trig): `Boost(5/3,4/3)` has det 1, preserves `Q=w^2-k^2`, `!= 1`, and maps the
  massless light cone `Q=0` to itself (rational witness `(3,3)->(9,9)`, moved but on-cone) =>
  emergent Lorentz covariance of the massless walk; `massive_shell_not_invariant` gives the
  rational "mass breaks the critical-line degeneracy" (`(1,0)->(5/3,4/3)` on the same shell).
  Builds ~17s. The lattice-trig dispersion-breaking half stays in the held transcendental version.
- **`SuiteDEntropyMonotone` (Suite D rung D2) [WIN on review; HELD — does NOT build in-project]** — the mass/entropy resource
  monotone: pinching channel `Pinch t rho = (1-t)rho + t diag(rho)`; closed form
  `det(Pinch t rho) = det rho + (2t-t^2)|z|^2`; `mass_monotone_under_pinch` (decohering hidden
  coherence can only INCREASE mass^2 = linear entropy); `signed_closure_exception` (a rational
  3-4-5 closure rotation before pinching LOWERS post-pinch mass, `49/2500 < 1/4`). Non-degeneracy
  `massSq 0 = 0` vs `massSq 1 = 1/4`. **NOT LANDED: despite rational witnesses, the module works
  over `C` (Hermitian `!![p,z;conj z,1-p]`, Complex det/congruence/`conj` with `simp`-unfolding)
  and does NOT build in-project (SIGTERM at 389s). Refined lesson: heavy symbolic COMPLEX matrix
  computation is as slow as Real transcendentals here. HELD (preserved at `harvest/d2/`);
  follow-up = re-derive over `R`/`Q` (real symmetric 2x2, `det = pd - z^2`), avoiding `C`.**
  **`EntropyMonotoneReal` — RESOLVED, now LANDED [M] (2026-07-09, post-restart).** Restating over
  real symmetric `!![p,x;x,1-p]` (`det = p(1-p)-x^2`), all 4 targets (`pinch_is_state`, `det_pinch`,
  `mass_monotone_under_pinch`, `signed_closure_exception`). The earlier "does not build" verdict was
  a MEASUREMENT ARTIFACT: the machine was memory-starved; after a restart this module builds in
  ~18s. Edge + anchor row added. (Correcting the earlier "deeper than C/transcendentals" note —
  the proofs were fine; the system was thrashing.)
- **`Goal1Rung5Tie` (Goal I rung-5 tie) [HONEST KILL / M]** — the true bound eigenvector's
  closure SHARE is `b_C = 16/5 >= 0` (`closure_share_nonneg`), not the seed's modelled `<0`,
  though closure ENERGY is `-16 < 0` (`closure_energy_neg`). Budget computed from `v=(2,1,0)`,
  not posited (see the `Goal1Hadron` correction above). Rational, builds ~25s.
- **`Goal3ChannelRG` (Goal III / Suite B S4a kill-test) [WIN / M — basin-membership survives]** —
  adding a chiral turn coupling `tau` to the decimation gives the exact 3-coupling flow
  `R3(lam,kap,tau) = (lam - 2(kap^2+tau^2)/lam, -(kap^2-tau^2)/lam, -2 kap tau/lam)` = the
  free-Dirac chiral square `z' = -z^2/lam` for `z = kap + i tau` (`R3_closed_form`: turn-free
  subspace invariant). At criticality `(1,1,0)` the Jacobian `[[3,-4,0],[1,-2,0],[0,0,-2]]` has
  char poly `(x-2)(x+1)(x+2)` => eigenvalues 2 (RELEVANT, aperture-closure plane), -1 (MARGINAL),
  -2 (RELEVANT, the pure TURN axis) (`rg_eigenvalues`, `kill_test`). VERDICT: the turn coupling
  is a NEW relevant direction but lies IN the named channel basis, so the S4a channel-name /
  basin-membership conjecture is NOT killed — sharpened: turn is relevant, not marginal. Rational
  (HasDerivAt + char-poly factoring), builds ~15s. Follows buildable-proof rule v3.
- **`Goal3ChannelRG4` (full 4-channel RG) [WIN / M — all four channels are RG coordinates]** —
  extends the S4a model with the fourth channel, soldering `E` (on-site block `lam*I + E*S`,
  `S^2=I`): `R4_closed_form` with `d=lam^2-E^2`; the critical `4x4` Jacobian at `(1,1,0,0)` is
  block `[[3,-4,0,0],[1,-2,0,0],[0,0,-2,0],[0,0,0,3]]`, char poly `(x-2)(x+1)(x+2)(x-3)`
  (`rg_charpoly`), so the soldering eigenvalue is `3` — RELEVANT, even more relevant than
  aperture's `2` (`soldering_verdict`). VERDICT: all four named channels
  (aperture/closure/turn/soldering) are genuine relevant/marginal RG coordinates; geometry does
  NOT decouple from the Dirac critical regime. Strongest kernel-checked
  support yet that the channel basis is the right coordinate system (still short of the continuum
  reduction). Rational, rule v3.

### Claude frontier batch (2026-07-09, post-restart — all M, verified in-project, ~5s each)
- **`Goal1Confinement` (Goal I dynamical confinement) [WIN / M — deconfinement kill does NOT fire]** —
  on the toy hadron, `confinement_ordering`: `leastEigenvalue Hsing = -1 < 1 <= leastEigenvalue Hcol`,
  with `colored_ground_ge_threshold` proved via an explicit sum-of-squares (`Hcol - 1` is PSD). The
  lightest two-particle excitation is the color SINGLET bound state; the colored channel is gapped
  above it. Closes the pre-registered "dynamical deconfinement" kill on `Goal1Hadron`.
- **`Goal4FieldEquation` (Goal IV field-equation rung) [WIN / M — Codex-lane cross-check]** —
  gamma-stationarity on the null cone <=> the finite field equation `M(psi) gamma = mu eta gamma`
  (`field_equation`, both directions via HasDerivAt), with `multiplier_nonzero` (explicit witness
  `psi*=(2,3), gamma*=(1,1)`, `mu=-6 != 0`, ruling out `0=0`) and `wep_corollary` (`M(psi1)=M(psi2)`
  => same stationary set = channel-blind coupling). **@Codex: this OVERLAPS your Goal IV lane
  (19113426 action/WEP) — treat as an independent cross-check; reconcile before either goes in the
  manuscript §7.**
- **`SuiteDResourceCore` (Suite D rung D1) [WIN / M]** — the mass resource theory core over R
  (`free_states_characterized`: `det P = 0` <=> rank<=1 null Gram; `free_ops_preserve`: rotations
  preserve `det`; `mixing_creates`: mixing distinct null directions creates exactly the Pluecker
  amount `det = t(1-t)(u0 w1 - u1 w0)^2 > 0`). Witness `det = 4/25`. Mass = the resource created by
  which-direction mixing, invariant under the free (rotation) group.
- **`SuiteDCriticalSymmetry` (Suite D rung D4) [WIN / M — critical lightness is symmetry-protected]** —
  on `B(lam,kap)`, an explicit involution `T` (`T_involution`, `T_ne_one/negOne`) with
  `symmetry_iff_kap_zero`; the zero mode is forced at criticality (`zero_mode_at_criticality`), and
  `naturalness_verdict_finetuning`: WITHOUT the symmetry, `B(1,1/2)` has NO zero mode (light level `1/2 != 0`)
  — so critical lightness is natural IFF the Z2 is imposed, else fine-tuning. Both halves proved.
- **`SuiteBCl4Walk` (Suite B rung B2) [WIN / M]** — the Cl(4) checkerboard lift: real 4x4 gammas
  (Clifford relations, Krein `J` indefinite trace-0), kinetic + mass parts Krein-self-adjoint, mass
  chiral-ODD, and `D(m)^2 = (a^2+m^2) 1` (the 3-4-5 shell `a=3,m=4 => D^2=25`). The 4-component real
  walk IS a finite Krein null-edge carrier — the Cl(4) lift of the landed 1+1D bridge.
- **`SuiteAQuatBargmann` (Suite A kill) [WIN / M — with an honest Aristotle self-correction]** —
  hardens `DivisionDimensionSelection`: the C-Bargmann triple is rephasing-invariant + cyclic, but
  over H the cyclic pivot-rephasing yields a true conjugation `star u . B . u` (`quaternion_rephasing_fails`)
  and cyclic reordering fails (`quaternion_cyclic_fails`) — so H admits no composable cyclic abelian
  Bargmann CP invariant of this form. NOTE: Aristotle correctly caught that the NAIVE middle-vector
  rephasing is vacuous (adjacent phases cancel even over H) and proved the FAITHFUL pivot-rephasing
  form instead — a good honest correction. Honest scope: this construction, not every conceivable one.
- **`Goal1Hadron` (Goal I) [WIN / M, 5 rungs — with a rung-5 scope boundary]** — the verified
  toy hadron on the actual 12-dim `Cl(4) (x) C^3` (`eta4 (x) Gcolor`): rung 1 confinement
  dichotomy (singlet PosDef, colored NegDef; both sectors `finrank>0` pinned; witnesses
  `(1,1,1)`/`(1,-1,0)`); rung 2 `H2` Hermitian; rung 3 bound ground energy exactly `-1 <`
  threshold `1` (witness `d=(0,1,7)`, `kap=4`, 3-4-5, discr 25); rung 4 exact spectrum
  `{-1,8,9}` => positive gap 9; rung 5 signed budget `b_C=-1/2<0` was a MODELLED witness.
  **CORRECTED by `Goal1Rung5Tie` (2026-07-09, an honest kill):** tying the budget to the
  ACTUAL rung-3 bound eigenvector `v=(2,1,0)` gives shares `b_A=-11/5, b_C=16/5>=0, b_T=0`
  (`closure_share_nonneg`) — the modelled `b_C<0` does NOT survive. The transparent reason:
  closure ENERGY is genuinely negative (`<v,H_C v> = -16 < 0`, `closure_energy_neg` — binding
  IS closure-driven at the energy level), but the total energy `<v,H2 v> = -5 < 0`, so
  normalizing flips the share sign. So the genuine chained result is rungs 1-4 (dichotomy +
  bound singlet below threshold + positive gap on the real 12-dim carrier); "binding = negative
  closure SHARE" is FALSE for this toy's ground state (though closure ENERGY is negative). The
  program's proven negative-closure-share result lives on the SEPARATE 18-dim S1-CC witness
  (manuscript §6, `b_C=-32/223<0`), a different object. Finite toy, no pion/rho, no continuum.
- **`SuiteAOp2Geom` (Suite A op-to-geometry) [WIN / M, all 4 incl stretch]** — finite Malament
  split on the 2-point Krein carrier: causal `dCausal m 0 1 = 1/m` (witnesses 1/3, 5/3),
  `CausalLE` a partial order recovering edge orientation, order/conformal class
  mass-independent while scale `Eslot m m' = m'/m`. Honest scope: 2-point witness only, not
  escalated to the C^4 FiniteCPT carrier; Franco-Eckstein recipe ported specialized.
- **`PathSumSemantics` (Suite B rung B1) [HELD — delivered, does NOT build in-project]** — the path-conditioned visible
  state `rhoDir = sum a_h conj(a_h') Om(h,h') |psi_h><psi_h'|`: PSD/Hermitian; fully coherent
  (`Om=1`) => pure `|Psi><Psi|`, `det=0` (massless); decohered (`Om=delta`) =>
  `det = sum_{h<h'} |a_h|^2 |a_h'|^2 |psi_h ^ psi_h'|^2` (mass = retained which-direction
  info); `det rho(t) = t(2-t) D` monotone under decoherence. Non-collinear witness `det=4/25`.
  Honest: "mass^2 = det rhoDir" is the normalization-robust invariant (trace=1 only in the
  decohered case). **RESOLVED, now LANDED [M] (2026-07-09, post-restart):** the earlier "SIGTERM
  595s solo" was a memory-starvation MEASUREMENT ARTIFACT — after a machine restart this exact
  `Complex`-determinant module builds in ~24s (with `ComptonBoundSq`). Edge + anchor row added.
- **`ComptonBound` (Suite D rung D5) [HELD — delivered, does NOT build in-project]** — the mass gap is a length
  floor: for every `J`-normalized state `(1/2)/m <= width`, saturated by `(1/sqrt2, 1/sqrt2)`
  (fixture `width 3 = 1/6`), and `width = (1/2) dCausal m 0 1` — the localization floor IS half
  the Connes distance. Kills stated + avoided (`no_sub_compton`, floor `>0`, mass-dependent).
  Honest: exact up to the structural constant `c=1/2` (each point at half the inter-point
  distance from the midpoint). **NOT LANDED: does not build in-project within budget (SIGTERM
  at 595s solo — the `Real.sqrt` width/optimizer proofs `width 3 = 1/6` are pathologically slow
  under our pin). HELD as a draft-handoff (preserved at `harvest/D5/`); follow-up = cheap
  rational re-derivation avoiding `Real.sqrt` (e.g. work with `widthSq` throughout).**
  **`ComptonBoundSq` — RESOLVED, now LANDED [M] (2026-07-09, post-restart).** The SQUARED-width
  form `widthSq m psi >= 1/(4 m^2)` (`compton_floor_sq`, `no_sub_compton_sq`, saturated at
  `p0=p1=1/2`, `widthSq 3 = 1/36`, `widthSq = (1/4) dCausal^2`). The earlier "SIGTERM" was
  memory-starvation, not the proofs; after a restart it builds in ~24s. Edge + anchor row added.
  (The `Real.sqrt`-form `ComptonBound` stays superseded by this squared form.)
