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
  `J = 6912 / 78125 != 0`. This closes the N=2/N=3 nondegeneracy gate; the
  general-N incidence/corank theorem remains open.
- **`WEPTrace` [WIN / narrow M]** — WEP as the finite trace identity
  `Tr((kappa * 1) rho) = kappa Tr(rho)`, with a nonvacuous equal-trace witness and
  a channel-stress negative control. This is Goal IV's cheapest trace rung, not the
  E-slot field equation or Clausius/Jacobson result.
- **`MassResourceModularAudit` [WIN / audit M]** — central normalization shifts cancel
  in the commutator derivation (`ad(z+B)=ad(B)` for central `z`), while the operator
  equality `z+B=B` is false for nonzero shifts. This pins the Suite D modular
  false-shape boundary.
