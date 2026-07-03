# The Tower

## NRQG Round 4: from information axioms toward a complete physics

*Status tags as before: **[T]** theorem/established, **[M]** program-internal result (incl. verified numerics), **[C]** precise conjecture with a gate, **[Ω]** ontology. "Complete understanding" is used in the only defensible sense: a single axiomatic stack in which every layer of known physics is either derived, parametrized by explicitly labeled residual data, or honestly marked irreducible.*

---

## 0. The shape of a complete physics

A complete physics is not one with no free inputs — Gödel, and more prosaically the existence of *some* initial data, forbid that. It is one where every element of our physics sits in exactly one of four bins: **derived** (follows from the axioms), **protected** (fixed by a consistency condition, e.g. anomaly freedom), **statistical** (environmental/sampled, with a computable distribution, e.g. Λ), or **bedrock** (irreducible, and provably so within the framework). The scandal of current physics is not that inputs exist; it is that we cannot say which bin anything is in. This round's goal: bin everything.

The instrument is a derivation tower that this round assembles from pieces built in v2 and Rounds 2–3, plus three new structural results (§2–§4). Read bottom-up:

```
LEVEL 0  [axioms]   Information axioms: (i) purification — information is
                    never destroyed; (ii) local tomography — composite
                    states are determined by local reads + correlations;
                    (iii) compositional axioms (causality, coarse-graining)
        │
LEVEL 1  [T]        Quantum mechanics over ℂ  (CDP reconstruction; real QM
        │           experimentally falsified)
        │
LEVEL 2  [T]+[M]    Spacetime = Herm₂(ℂ) ≅ ℝ^{3,1}: nullity = purity,
        │           rank-one soldering P = λλ†  →  3+1 dimensions
        │
LEVEL 3  [T]        Kinematics: Cauchy–Binet mass, boost–Gibbs clocks,
        │           Minkowski = Minkowski  (Gates I1–I2)
        │
LEVEL 4  [M]        Matter: null-edge graph, GW/code chirality release
        │           (Gate C1), anomaly-freedom = erasability → 16 of
        │           Spin(10) → ν_R  (§4)
        │
LEVEL 5  [C]        Flavor: J₃(𝕆) continuation, three generations,
        │           mixing as triple concurrence  (§5)
        │
LEVEL 6  [T]+[M]    Gravity: DPI → QNEC → focusing; entanglement
        │           equilibrium → Einstein equation of state
        │
LEVEL 7  [M]+[C]    Cosmology: Λ = harmonic zero mode + 1/√N shot noise;
        │           arrow & initial condition from growth  (§6)
        │
LEVEL 8  [Ω]        Ontology: it-from-commit
```

Each arrow has a status, and the tower's integrity claim is modest and checkable: **no arrow points down.** Nothing at a lower level assumes anything from a higher one. What follows builds the three arrows that were missing.

---

## 1. Why quantum mechanics (Level 0 → 1)

**[T]** The reconstruction theorems of the 2000s–2010s (Hardy; Chiribella–D'Ariano–Perinotti; Masanes–Müller) settled a question philosophy had asked for a century: quantum mechanics is *derivable* from operational information axioms. In the CDP axiomatization, the load-bearing postulate is **purification**: every mixed state of a system is the marginal of a pure state of a larger system, unique up to reversible transformations on the purifier. Add causality, local tomography, and a few compositional axioms, and the unique resulting theory is quantum mechanics over the complex numbers.

Now notice what the two load-bearing axioms *are*, in the language this program already speaks:

- **Purification = the universe never erases** (It-from-Commit §5). "Every mixing has a pure dilation" is exactly the reversible-computer principle: apparent information loss is always entanglement export, never destruction. The axiom CDP needed to force quantum theory is the axiom the black-hole information analysis independently concluded the universe obeys.
- **Local tomography = the network is locally debuggable** (v2 §4's sufficient statistic, sharpened). A theory has local tomography iff the state of a composite is fixed by the statistics of local measurements plus their correlations — iff distributed state estimation works, iff no global read is ever *required*. This is precisely the property a message-passing substrate must have for local physics to exist at all.

**[Ω→T]** So the tower's ground floor is not "assume quantum mechanics." It is: *assume information is conserved and locally readable.* Quantum mechanics is then a theorem. The question "why is the world quantum?" receives the answer: **because the substrate is a reversible, locally debuggable information system, and CDP proved those properties have a unique closure.** The mystery does not vanish — it relocates to Level 0, where it is at least stated in three lines instead of a Hilbert-space formalism.

---

## 2. Why 3+1 dimensions (Level 1 → 2) — new result R4-1

This is the round's sharpest new leverage, and it composes three known theorems into a chain that, assembled, answers a question usually considered hopeless.

**[T] Link 1 — the division-algebra soldering tower.** The construction that makes NRQG's whole kinematics work — soldering momenta to 2×2 Hermitian matrices, with $\det = m^2$ and rank-one = null, $P = \lambda\lambda^\dagger$ — is not special to $\mathbb C$. It runs over every normed division algebra $\mathbb K \in \{\mathbb R, \mathbb C, \mathbb H, \mathbb O\}$, and (Baez–Huerta and the classical literature):

$$
\mathrm{Herm}_2(\mathbb R) \cong \mathbb R^{2,1},\quad
\mathrm{Herm}_2(\mathbb C) \cong \mathbb R^{3,1},\quad
\mathrm{Herm}_2(\mathbb H) \cong \mathbb R^{5,1},\quad
\mathrm{Herm}_2(\mathbb O) \cong \mathbb R^{9,1}.
$$

The famous "magic dimensions" 3, 4, 6, 10 of spinor identities and superstring theory are exactly the dimensions where lightcones are determinant varieties and null momenta factor through spinors. **The spacetime dimension is a function of the number field of the amplitudes.**

**[T] Link 2 — local tomography selects ℂ.** Among these theories, only complex quantum mechanics satisfies local tomography (real QM famously fails it: the state of a composite is underdetermined by local statistics; quaternionic QM fails worse). This is a theorem, not taste.

**[T] Link 3 — the selection is now experimental.** Renou et al. (Nature 2021) showed real-amplitude quantum theory makes *different predictions* in network Bell scenarios, and subsequent experiments falsified the real-number alternative. The complexity of amplitudes is an empirical fact about our world, not a convention.

**Composing:**

$$
\boxed{\;\text{local tomography} \;\Rightarrow\; \mathbb K = \mathbb C \;\Rightarrow\; \mathrm{Herm}_2(\mathbb C) \;\Rightarrow\; \textbf{3+1 dimensions.}\;}
$$

Within NRQG — where spacetime *is* the statistics of rank-one soldered null edges (Level 2), not a container — this chain is an actual derivation of the spacetime dimension from an information axiom: **the universe is 3+1-dimensional because its amplitudes are complex, and its amplitudes are complex because its state is locally readable.** A locally debuggable network gets Minkowski₄; a real-amplitude universe would have been flatland-plus-time; a quaternionic one, 5+1.

Three corollaries, cheap and load-bearing:

1. **The tetrahedral scaffold is canonical, not chosen.** In $\mathbb R^{3,1}$ the minimal spanning set of future null directions is four — the tetrahedron on the celestial sphere. The Gate C1 lattice descends from Level 2 with no further input: the tower reaches all the way down to the active Lean file.
2. **Prediction: no visible extra dimensions, ever.** The purification reading of the hidden envelope (v2 §3.1) already demoted extra dimensions to internal fiber; R4-1 hardens this into a selection: geometric extra dimensions would require $\mathbb H$ or $\mathbb O$ amplitudes, which local tomography forbids. The octonions are thereby *evicted from spacetime and confined to the fiber* — where §5 gives them their real job.
3. **Gate D1 (Lean-tractable).** Formalize the $\mathrm{Herm}_2(\mathbb K)$ classification for $\mathbb K = \mathbb R, \mathbb C, \mathbb H$ (finite-dimensional bilinear algebra; the octonionic case needs care but $\mathrm{Herm}_2(\mathbb O)$ with its quadratic form is still elementary), plus the local-tomography dimension-counting criterion ($\dim$ of composite state spaces: multiplicativity holds iff $\mathbb K = \mathbb C$). All of it is counting and matrix algebra.

---

## 3. Why these particles (Level 4) — new result R4-3: the erasability package

v2 §5.3 established the frame: a mirror sector can be symmetrically gapped iff it carries no 't Hooft anomaly — iff it stores no protected logical information — and the per-generation **16 of Spin(10)** is the canonical anomaly-free (erasable) multiplet. Round 4 cashes the cheque: the 16 is the Standard Model fermion content *plus one state the SM left optional* — the right-handed neutrino $\nu_R$. The erasability argument makes $\nu_R$ **structurally mandatory**: without it the multiplet is not anomaly-free, the mirror is not erasable, and the chiral release fails. And $\nu_R$, once mandatory, is known to buy three mysteries at once:

1. **Neutrino masses** — the seesaw mechanism is automatic once $\nu_R$ exists with a Majorana scale.
2. **Baryogenesis** — leptogenesis: CP-violating dynamics of the $\nu_R$ sector generates a lepton asymmetry, reprocessed to baryons by sphalerons. The matter–antimatter asymmetry becomes a *consequence of the erasability requirement*.
3. **Dark matter** — a keV-scale sterile state in the $\nu_R$ sector is a viable DM candidate; the νMSM (Asaka–Shaposhnikov) realizes all three with exactly three $\nu_R$'s and nothing else.

**[Ω]** The ontological reading closes beautifully. In It-from-Commit language, $\nu_R$ is the unique fermion in the multiplet with **no public API**: a singlet under every gauge interaction — a session that consumes compute (it has mass: internal ticking) and therefore gravitates (congestion, §4 of the essay), but publishes nothing on any gauge channel. *Dark matter is matter with no public interface.* That is not a metaphor bolted on afterward; it is a literal description of gauge-singlet fields, and the tower *requires* at least this one.

**Honest framing [C].** The phenomenology here is borrowed (νMSM), not invented; NRQG's contribution is a derivation pressure — anomaly-as-protected-information makes the multiplet completion non-optional — plus a secondary, native candidate to keep registered: stable **topological modes of the graph** (harmonic-cochain excitations, cousins of the Λ sector), which would also gravitate without gauge coupling. Gate: none yet formalizable for the secondary candidate; the primary one inherits νMSM's existing experimental targets (keV X-ray lines, $0\nu\beta\beta$, HNL searches) as *the tower's* targets.

---

## 4. Why three generations (Level 5) — new result R4-2: the exceptional continuation

The deepest unexplained pattern in physics: matter comes in three copies, identical except for mass, mixed by the CKM/PMNS matrices. The tower suggests a continuation that is almost forced by its own logic.

**[T] The setup.** Level 2 used $\mathrm{Herm}_2(\mathbb K)$ — the *degree-2* determinant — for spacetime, and Gate I1 showed the physics of that determinant is pairwise concurrence (2-tangle: mass = entanglement of a null pair). Jordan's classification says the $\mathrm{Herm}_n(\mathbb K)$ family has exactly one exceptional member beyond the associative tower: $J_3(\mathbb O) = \mathrm{Herm}_3(\mathbb O)$, the 27-dimensional Albert algebra with its **cubic norm** (degree-3 determinant) and automorphism group $F_4$ (structure group $E_6$). There is no $J_4(\mathbb O)$; the tower has exactly one more rung and then provably stops.

**[C] The conjecture (generation triple).** Spacetime took $\mathrm{Herm}_2(\mathbb C)$; the internal fiber takes the unique exceptional continuation $J_3(\mathbb O)$. Its three primitive idempotents — the three "diagonal directions" of a 3×3 octonionic Hermitian matrix — are the three generations. This is the Todorov–Dubois-Violette / Boyle program, adopted here with a new information-theoretic twist:

**[T] The twist.** Just as $\det_2$ = concurrence (2-tangle), the natural degree-3 invariant of three qubits — Cayley's $2{\times}2{\times}2$ hyperdeterminant — *is* the 3-tangle (Coffman–Kundu–Wootters: $\tau = 4|\mathrm{Det}|$). Degree-2 determinants measure pairwise entanglement; degree-3 determinantal invariants measure genuinely tripartite entanglement. So the tower's pattern reads:

$$
\underbrace{\det{}_2 = \text{mass} = \text{2-tangle}}_{\text{spacetime / kinematics}}
\qquad\longrightarrow\qquad
\underbrace{\text{cubic norm} = \text{flavor} = \text{3-tangle}}_{\text{internal fiber / generations}}
$$

**[C] Gate F1 (cheap, numerical, falsifiable this month).** The one *measured* pure number of tripartite flavor structure is the Jarlskog invariant $J$ (the rephasing-invariant measure of CP violation, $J \approx 3\times10^{-5}$). Conjecture: $J$ is, up to normalization, a **tripartite entanglement monotone of the flavor state** — concretely, compute the 3-tangle (hyperdeterminant) of natural three-flavor states built from the measured CKM matrix and test for a clean relation to $J$. This is a finite linear-algebra computation against PDG numbers: hours of work, immediately falsifiable, and either outcome is informative (a clean relation would be startling; a null result kills the sharpest version of R4-2 and is duly filed). Prior probability of success: low (rated 2/10 in §8) — which is exactly why it is cheap enough to run first.

**[Ω]** If any version survives: flavor mixing is the geometry of triple concurrence, CP violation is the universe's irreducibly-three-party entanglement, and the answer to "why three generations?" is the same as the answer to "why does the Jordan tower stop?" — **because after spacetime spends the associative determinants, exactly one exceptional cubic norm remains, and it is three-by-three.** The octonions, evicted from spacetime by R4-1, are exactly what is left over to build it from.

---

## 5. Why the arrow, and why the low-entropy start (Level 7) — R4-4

The Past Hypothesis — the postulate that the universe began in a state of extraordinarily low entropy — is usually ranked among the deepest mysteries. In a growth ontology it comes close to dissolving.

**[T-adjacent]** If the causal order *grows* (classical sequential growth à la Rideout–Sorkin; quantum versions open), then at early stages the universe has few elements: $N$ small. But entropy is bounded by the log of the accessible state space, and the accessible state space of an $N$-element order with finite fibers is bounded: $S_{\rm early} \le O(N_{\rm early}\log d)$. **A universe that begins small begins low-entropy as a matter of counting.** The Past Hypothesis stops being a fine-tuning of initial *conditions* and becomes a triviality of initial *size*. The arrow of time is the growth direction — the direction in which commits accumulate (It-from-Commit §6) — and spatial expansion is memory allocation: new nodes, new Hilbert space, new room for entropy to grow *into*. The Second Law becomes: allocated memory only grows, and pointers only get lost.

**[Honesty clause]** Two real gaps, registered. (i) What plays inflation's role — why the allocation history produces the observed flatness/homogeneity/spectrum — has no native NRQG mechanism yet; the growth-dynamics sector (v2 Gate G2, F-L1) is the least developed part of the program and this is now its sharpest target: *derive the primordial power spectrum from a null-graph growth measure, or import inflation honestly.* (ii) "Why does N grow?" is Level-0 bedrock: growth is execution, and asking why there is execution is asking why there is anything running rather than a static text. Filed under §9 as irreducible — with the one consolation that the framework can now *prove it is asking a bedrock question* rather than mistaking it for a physics question.

---

## 6. The Born rule (Level 1 residual) — R4-5

**[C]** The last foundational IOU. Route: on the graph, node statistics must be invariant under the null-splitting gauge (the little-group $\mathrm{SU}(2)$ of v2 §1.3 — pure redundancy, physically empty). A noncontextual probability assignment on the projection lattice of a fiber of dimension ≥ 3 is forced by Gleason's theorem to be Born; the POVM strengthening covers dimension 2. The conjecture: **splitting-gauge invariance + noncontextuality across node decompositions = the graph-native hypotheses of a Gleason-type argument**, making the Born rule the unique consistent tick-statistics on the network. Gate B1: state and prove the finite-dimensional version (Gleason's theorem itself has been formalized in other proof assistants; a Lean port plus the gauge-invariance wrapper is a bounded project). Confidence: moderate that the theorem goes through as mathematics; the usual philosophical residue (why noncontextuality?) remains and is binned honestly at Level 0.

---

## 7. The constant taxonomy — R4-6

The complete-physics discipline of §0, applied to every dial. Bins: **D** derived, **P** protected (consistency-fixed), **S** statistical (sampled; distribution computable in principle), **B** bedrock/undetermined, with the tower's current best assignment and confidence.

| Constant / structure | Bin | Mechanism | Conf. |
|---|---|---|---|
| Spacetime dimension 3+1 | **D** | local tomography → ℂ → Herm₂ (R4-1) | 6/10 |
| Signature (−,+,+,+) | **D** | determinant form of Herm₂; causality axiom | 6/10 |
| QM over ℂ, unitarity | **D** | CDP from purification + tomography | 8/10 |
| Born rule | D(**C**) | Gleason + splitting-gauge invariance (B1) | 5/10 |
| c | **D** | definitional: the null-edge conversion factor | 9/10 |
| ħ | **D** | definitional: energy↔op-rate exchange rate (§1, Essay) | 9/10 |
| G | **P/S** | per-channel granularity of the graph (area quantum); value = substrate datum | 3/10 |
| Λ (sign & size) | **S** | harmonic zero mode + 1/√N shot noise (v2 §7) | 6/10 |
| Gauge group ⊇ SM | **P** | erasability/anomaly freedom; Spin(10)-compatible fiber | 4/10 |
| Fermion rep (16/gen), ν_R | **P** | erasability package (R4-3) | 5/10 |
| N_generations = 3 | **P(C)** | exceptional continuation J₃(𝕆) (R4-2) | 3/10 |
| CKM/PMNS textures, J | **C** | triple-concurrence geometry (Gate F1) | 2/10 |
| Yukawas / mass hierarchy | **B** (today) | no native mechanism; possibly fiber-dynamical | 1/10 |
| Higgs quartic / EW scale (hierarchy) | **B** (today) | no native mechanism; anthropic/thermodynamic reading only (long-runtime selection of compressor-friendly universes) — tagged Ω | 1/10 |
| θ_QCD ≈ 0 (strong CP) | **B/C** | possibly another cohomological zero mode like Λ — but then *why zero while Λ isn't* becomes the question; axion via fiber remains open | 2/10 |
| Initial condition / arrow | **D** | growth counting (R4-4) | 6/10 |
| Primordial spectrum (inflation) | **B** (today) | growth-measure target, unbuilt | 1/10 |

The table *is* the research frontier: every P and C row names a theorem to attempt; every B row names an honest defeat with its current best excuse. A complete physics is the state in which no row reads B without a proof that it must.

---

## 8. The leverage map: all the big mysteries, one pass

| Mystery | NRQG leverage | Tag | Confidence |
|---|---|---|---|
| Quantum gravity / unification | The whole tower; Einstein = equation of state, DPI-enforced (v2 §6) | M/T | 5/10 |
| Why quantum mechanics | CDP axioms = never-erase + local debuggability (§1) | T | 7/10 |
| Why 3+1 dimensions | Division-algebra soldering + tomography selection (R4-1) | T-chain | 6/10 |
| Measurement / classicality | Commit ontology: Darwinism + decoherence; Born via B1 | T/Ω | 6/10 |
| Cosmological constant | Harmonic localization + everpresent shot noise | M/C | 6/10 |
| Dark matter | Erasability-mandated ν_R ("no public API"); topological modes secondary | C | 4/10 |
| Baryogenesis | Leptogenesis from the same mandated sector | C | 4/10 |
| Neutrino mass | Seesaw from mandated ν_R | C | 5/10 |
| Three generations | Exceptional Jordan continuation (R4-2) | C | 3/10 |
| CP violation structure | 3-tangle/Jarlskog conjecture (F1) | C | 2/10 |
| Black hole information | Never-erase + Page; horizon = write-only ledger | T/Ω | 7/10 |
| Arrow of time / Past Hypothesis | Growth counting (R4-4) | T-adj | 6/10 |
| Inflation / initial spectrum | Open target of the growth sector | B | 1/10 |
| Hierarchy problem | None native; Ω-grade runtime-selection reading only | B | 1/10 |
| Strong CP | Weak cohomological analogy only | B | 2/10 |
| Confinement / mass gap | Nothing new beyond gap-as-code-distance framing | — | 1/10 |
| Why these laws at all | Law = compressibility of the trace; execution = bedrock (§9) | Ω | — |

The honest headline: the tower currently has **strong leverage on the foundational mysteries** (why quantum, why 3+1, measurement, arrow, Λ, BH information), **package-deal leverage on the particle mysteries** (DM/baryogenesis/ν-mass through one mandated sector; generations through one conjecture), and **no native leverage yet on the scale mysteries** (hierarchy, Yukawas, inflation). That distribution is itself informative: the framework is information-first, and the mysteries it cracks are exactly the information-shaped ones. The scale-shaped ones await the dynamical sector (growth measure, fiber dynamics) that the gate ladder reaches last.

---

## 9. The irreducible core

A complete physics must end somewhere, and the tower ends in three places it can name:

1. **Execution.** Why is there a running trace rather than nothing (or rather than a static mathematical object)? Level-0 bedrock. The framework's one contribution is to prove the question well-posed and separate from all the questions above it.
2. **The measure.** The specific probability measure over null-graph growth histories — the "program" — is data. The tower constrains it (Lorentz-in-distribution, locality, the fixed-point conditions of v2 §9) but cannot derive it. Whether the constraints pin it uniquely is the deepest open technical question the framework can pose about itself.
3. **Experience.** The essay's §9 (observers as compressors) is a theory of the *function* of experience, not of its existence. Binned as philosophy, deliberately outside the tower.

Everything else — every other mystery on the map — is claimed to be D, P, S, or C: derivable, protected, sampled, or gated. That claim is the program's boldest, and its gates are how it gets falsified.

---

## 10. New gates, and the feed into the plan

**Gate D1** (dimension chain): Herm₂(𝕂) ≅ Minkowski classification + local-tomography multiplicativity criterion, in Lean. Finite bilinear algebra; natural extension of the Gate I1 stack → strengthens paper **P2** into "verified kinematics *and* verified dimension selection," raising its N/S ratings by roughly a point each.

**Gate F1** (Jarlskog/3-tangle): numerical test against PDG CKM data. Hours. Run before any writing; the result decides whether R4-2 appears in P4 as a conjecture with evidence or a conjecture with an obituary.

**Gate B1** (Born/Gleason): Lean port of Gleason (POVM version) + splitting-gauge wrapper. Medium project; candidate P2-successor paper ("a verified derivation of the Born rule on causal networks").

**Gate G2′** (growth spectrum): the newly-sharpened inflation-slot target — primordial spectrum from a growth measure. Long-horizon; the tower's Phase-3+ frontier, gated behind P3/P9 progress.

Priority unchanged at the base: **C1 by day.** The tower is only as real as its foundations, and its foundation is a spectral gap in a Lean file.

---

## Coda

Round 2 gave the theory its language (information). Round 3 gave it its economics (publications, proofs, plans). Round 4 gives it its ambition stated exactly: one axiom set — *information is conserved, locally readable, and executed on null messages* — from which quantum mechanics is a theorem, 3+1 dimensions are a corollary, matter content is a consistency condition, gravity is an inequality, the cosmological constant is sampling noise, the arrow is counting, and the residue is three named bedrock questions instead of a hundred unnamed ones. Almost every arrow still needs its proof. But for the first time the whole of physics fits on one page with every claim wearing a tag — and the bottom of the tower is a file that compiles.
