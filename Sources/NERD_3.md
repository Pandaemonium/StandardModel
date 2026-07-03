# NRQG Development Round 3: New Results, Publication Portfolio, Research Plan

---

# Part A — Theory development: four new results

These extend v2. Results A1 and A2 are exact and finite-dimensional (immediate Lean targets). A3 is a formulated conjecture with a complete numerical protocol. A4 is positioning intelligence from a literature check that materially affects the C1 paper.

## A1. The boost–Gibbs form: momentum is a thermal state of the boost

Solder a massive future momentum as usual, $P = E\,\mathbb 1 + \mathbf p\cdot\boldsymbol\sigma$, and write $E = m\cosh\eta$, $|\mathbf p| = m\sinh\eta$ with rapidity $\eta$. Since $(\hat p\cdot\boldsymbol\sigma)^2 = \mathbb 1$:

$$
\boxed{\;P \;=\; m\, e^{\,\eta\,\hat p\cdot\boldsymbol\sigma}\;}
$$

The soldered momentum is **mass times a Gibbs exponential of the boost generator** (in the chiral spinor representation, boosts act via $\tfrac{\eta}{2}\hat n\cdot\boldsymbol\sigma$). Consequences, each exact:

1. **Rapidity is inverse temperature.** The normalized state $\rho = P/2E = e^{\eta\hat p\cdot\sigma}/Z$ is a Gibbs state of the helicity operator at "inverse temperature" $\eta$. Mass is the prefactor — the partition-function normalization that survives when you *don't* normalize (this is exactly why the unnormalized-determinant fix of §3 works: normalizing divides out $m$'s invariant home).

2. **The Doppler factor is the Boltzmann factor.** The eigenvalues of $\rho$ are $\lambda_\pm = \tfrac{1\pm v}{2}$, so
$$
\frac{\lambda_+}{\lambda_-} = \frac{1+v}{1-v} = e^{2\eta},
$$
the squared longitudinal Doppler factor, playing the role of detailed-balance weight. Relativistic Doppler = KMS condition of the momentum state.

3. **Entropy–velocity relation.** $S(\rho) = H_2\!\big(\tfrac{1+v}{2}\big)$: zero for null ($v\to1$, pure), maximal — exactly **one bit** — at rest. *A particle at rest is a maximally mixed momentum state: rest mass is one bit of momentum entropy, spread over the two null constituents.* This is the quantitative closure of v2 §3.1.

4. **Finite Bisognano–Wichmann property (Gate I2.2, now a theorem in the minimal case).** The modular Hamiltonian of $\rho$ is
$$
-\ln\rho \;=\; -\eta\,\hat p\cdot\boldsymbol\sigma + \ln Z \;\propto\; \text{boost generator along } \hat p,
$$
with rapidity as the modular parameter. The continuum Bisognano–Wichmann theorem ("the vacuum modular Hamiltonian of a wedge is the boost") has an exact two-dimensional shadow at the level of a single soldered momentum. The modular flow is
$$
\rho^{it}\,\lambda\,\rho^{-it} \;=\; e^{i\eta t\,\hat p\cdot\sigma}\,\lambda\;(\cdots)
$$
— a **rotation about the momentum axis**, i.e. a little-group rotation. Combined with v2 §1.3 (little group = null-splitting gauge), this says: *the node clock ticks by rotating the two null constituents into each other along the splitting-gauge orbit.* Time is motion along the gauge orbit of the null decomposition. The de Broglie internal clock is this precession read in the rest frame.

**Honesty clause.** The theorem is about the momentum matrix treated as a state; that this modular flow *is* the physical node clock remains the thermal-time postulate (F-M1). What A1 does is make Gate I2.2 exactly true where it can be checked, and make the postulate maximally sharp.

**Lean status:** items 1–4 are $2\times2$ matrix exponentials and eigenvalue computations. Days, not weeks, on top of the Gate I1 stack.

## A2. Relativistic kinematics is PSD matrix analysis: Minkowski = Minkowski

The reverse triangle inequality of special relativity — the mass of a composite is at least the sum of the masses, $m(P_1+P_2) \ge m_1 + m_2$ for future-causal momenta — is, under the soldering, **precisely Minkowski's determinant inequality** for positive semidefinite matrices:

$$
\det(A+B)^{1/2} \;\ge\; \det(A)^{1/2} + \det(B)^{1/2}, \qquad A,B \succeq 0\ (2\times2),
$$

with equality iff $B \propto A$ — i.e. iff the momenta are parallel (comoving), exactly matching the physics. Both inequalities are due to the same Hermann Minkowski; the correspondence closes the pun a century late. Corollaries in the same breath:

- **Binding energy is a superadditivity gap** of $\det^{1/2}$ on the PSD cone.
- **Concavity of mass.** $\det^{1/2}$ is concave on PSD matrices, so mass is a concave function on the future cone — the same structural fact that makes entropies concave, and no accident:
- **Log-mass is a Gaussian entropy.** $\log\det P$ is (up to constants) the entropy of the Gaussian with covariance $P$. Combined with Cauchy–Binet (v2 §1.2): the Gaussian entropy of the null-edge covariance counts pairwise Plücker correlations. The v2 slogan "the metric is a covariance" now has its conjugate: **mass is the entropy of that covariance.**

This module (A1 + A2 + v2 Gate I1) forms a self-contained, fully elementary, fully verifiable dictionary: *relativistic kinematics = analysis on the PSD cone; QIT quantities = kinematic quantities.* Nothing in it is individually unknown to all specialists, but the assembled dictionary, with machine-checked proofs, does not exist anywhere.

## A3. Discrete QNEC: a formulated conjecture with a ready protocol

v2 §6 argued QNEC is the *native* energy condition of a null-edge ontology. Make it discrete and testable.

**Setup.** Gaussian (free) fermions on a 1+1d null-edge chain (checkerboard/discrete-time walk geometry). A null cut at strand position $s$ splits the chain; the reduced state of the outside is Gaussian, so its entropy $S(s)$ is computable exactly from the two-point correlation matrix (Peschel's method) at any system size.

**Conjecture (discrete QNEC, 2d form).** For the appropriate discretization $T_{kk}(s)$ of the null-null stress tensor and the discrete second difference $\Delta^2 S(s) = S(s{+}1) - 2S(s) + S(s{-}1)$:

$$
2\pi\,a^2\,\langle T_{kk}(s)\rangle \;\ge\; \Delta^2 S(s) \;+\; \frac{6}{c}\,\big(\Delta S(s)\big)^2 \;-\; O(a^{\#}),
$$

matching Wall's 2d QNEC in the continuum limit, with the discretization-error exponent to be measured. Three regimes to test: (i) massless (2d CFT — continuum QNEC is *saturated*, so the discrete deficit isolates pure lattice artifacts: the cleanest possible calibration); (ii) massive (strict inequality; measure the gap against the concurrence mass of A1/v2 §1); (iii) quenched/excited states.

**Why this is feasible now.** The entire toolchain is standard: correlation-matrix entropies; and Eisler–Peschel's line of work on lattice entanglement Hamiltonians (which approximate the Bisognano–Wichmann boost form on intervals) provides the discrete modular side for the companion test, the **discrete first law** $\delta S = \delta\langle K\rangle$ on lattice causal diamonds — which is Gate G1′.2's numerical shadow.

**Upside.** If the Gaussian discrete QNEC can be *proved* (plausible: continuum free-field QNEC proofs exist, and Gaussian entropy formulas are exact), it would be — as far as a to-be-completed literature check shows — the first discrete-native quantum energy condition theorem, and a candidate for the first *machine-verified energy condition* in physics. If numerics find violations at finite spacing, that is itself a publishable discovery about what discretization does to QNEC, directly constraining every discrete-spacetime program, not just this one. The experiment cannot fail to produce a paper; it can only fail to produce the *preferred* paper.

## A4. Positioning intelligence: the tetrahedral kernel has neighbors

A literature check confirms the tetrahedral/null-direction lattice has adjacent prior art that the C1 paper must engage, and that engagement *strengthens* the paper:

- **Hyperdiamond lattices** (4d graphene generalizations, five bond vectors at mutual angle $\cos\theta = -1/4$) were searched for chiral fermion actions by Bedaque–Buchoff–Tiburzi–Walker-Loud, who found the symmetric hyperdiamond action has *more than minimal* doubling and that imposing the $\mathbb Z_5$ symmetry is incommensurate with minimal doubling.
- **Kimura–Misumi** showed minimal doubling and hyperdiamond structure are compatible *only in two dimensions*.
- **Creutz–Borici minimally doubled fermions** carry one exact chiral symmetry but break hypercubic symmetry and require fine tuning (Bedaque et al.).
- **Creutz–Kimura–Misumi** already built overlap operators from *non-standard* (naive/minimally doubled) kernels using flavored mass terms — the closest prior art to "overlap on an exotic kernel," and directly adjacent to the $M_{\rm br}$ flavored-mass fallback in the C1 architecture.

The differentiators that survive contact with this literature, cleanly: (1) the **rank-4 tetrahedral direction set with null/Lorentzian interpretation** (four future null directions, not five Euclidean bonds; the object being discretized is the lightcone, not the metric); (2) the architecture goes **Wilson + overlap from the start** rather than chasing minimal doubling — and the cited no-go results are exactly the reasons why; (3) **formal verification**, which nobody in the lattice literature has. The prior art converts from threat to scaffolding: the C1 paper's comparison section writes itself as "here is why every alternative on this lattice family is known to fail, and here is the machine-checked proof that this one doesn't."

---

# Part B — Publication portfolio

Landscape fact shaping everything below: physics formalization in Lean has just become a recognized genre — PhysLean/Physlib exists as a community library (covering QFT-adjacent material, the Higgs potential, special relativity) with stated ambitions to be "Mathlib for physics"; a generalized quantum Stein's lemma formalization explicitly pioneered the *verify-a-new-result* mode; an end-to-end QEC formalization exists; and the community is actively discussing quality standards for AI-generated Lean physics code. This is the single most favorable external development for this program: the unique asset (research-level physics operator theory, formally verified, produced by an independent researcher with an AI-assisted pipeline) now has a community, venues, and a citation graph to land in.

Ratings: **N** = novelty, **S** = significance (expected, conditional on landing), both /10; **F** = feasibility. Calibration notes are part of the rating — inflated scores would be a disservice.

## Tier 1 — the wedge (publish first, low risk, establishes credibility)

**P2. "Mass as concurrence: a verified information-theoretic dictionary for relativistic kinematics."**
Content: Gate I1 + A1 + A2 complete — nullity=purity, Cauchy–Binet mass identity, little group as splitting gauge, boost–Gibbs form, finite Bisognano–Wichmann, entropy–velocity, Minkowski=Minkowski, purification reading, $\det P = \Phi^\dagger\Phi$ bridge — with a complete Lean formalization, ideally integrated into PhysLean.
**N 6 / S 6 / F very high (weeks of slack-time work).**
Calibration: every individual atom is known to some specialist (spinor-helicity identities, massive spinor-helicity, Minkowski's inequality, mass–entanglement literature à la Fullwood–Vedral). The contribution is the assembled dictionary + first formalization of spinor-helicity-grade kinematics. Within the formalization community S rises to 7: it is exactly the kind of coherent, physics-meaningful module PhysLean wants.
Venue: arXiv (math-ph or quant-ph) + PhysLean PR; optionally an ITP/CPP tool-paper companion.

**P8. "Relativistic kinematics as matrix analysis" (expository companion to P2).**
The boost–Gibbs form, Doppler-as-Boltzmann, one-bit rest mass, Minkowski=Minkowski, written for physicists at AJP/SIGMA level.
**N 5 / S 4 / F very high.** Pure visibility-per-effort play; expository gems travel far and recruit readers to P2/P1.

**P5. "Semantic auditing of AI-generated Lean proofs in physics" (methods/tooling).**
The auditing toolkit already prototyped in the program, written up against the community's live "how do we detect formally-correct-but-meaningless Lean physics" problem.
**N 6 / S 5–6 / F high (mostly writing + hardening existing tools).** Timeliness is the asset: the discussion is happening now and there is little published methodology. Venue: ITP/CPP/CICM or arXiv cs.LO + a PhysLean-community RFC.

## Tier 2 — the core results (the papers the program is *for*)

**P1. "A verified chiral lattice fermion: machine-checked spectral gap, self-adjointness, and Ginsparg–Wilson release for a tetrahedral null-direction kernel."** (= Gate C1 complete.)
**N 7 / S 7 / F high — this is the active critical path.**
Calibration: as a lattice construction, adjacent prior art exists (A4) and must be engaged; the null interpretation and the verification are the genuinely new content. As a formalization result it is first-of-kind: no lattice-QFT operator theorem (gap, GW relation, no-mirror) has ever been machine-checked. Positioning: dual-audience paper — hep-lat body, formalization appendix — or a pair of papers sharing one artifact.
Venue: arXiv hep-lat crosslisted cs.LO; journal options SciPost Physics (open review, content-driven) or PRD, with the Lean artifact as the credibility anchor.
Downside protection: if the gap *fails*, the obstruction result joins the Bedaque et al. genre of well-cited no-gos for exotic lattices — pre-register this framing.

**P3. "Discrete quantum null energy condition on null lattices" (= A3 executed).**
Numerics across the three regimes; Gaussian proof attempt; discrete first-law companion measurement on lattice diamonds.
**N 8* / S 7–8 with a theorem, 6 numerics-only / F medium (numerics cheap; theorem uncertain).**
*The asterisk: N=8 is conditional on the literature check confirming the discrete-native niche is open (continuum QNEC proofs and CFT saturation studies exist; a lattice-native formulation with systematic discretization analysis appears absent — verify at execution).
Venue: quant-ph/hep-th crosslist; SciPost or JHEP if the theorem lands.
Strategic weight: this is the paper that makes v2 §6 (gravity as DPI) *empirical* at the toy level, and it is the program's best shot at a result the holography/QI community must cite.

## Tier 3 — the program papers (publish after the wedge exists)

**P4. "Null-Edge Relational Quantum Geometry: an information-theoretic route to unification" (the v2 treatise, hardened).**
**N 6 (as a framing; ingredients borrowed with attribution) / S: potential 8–9, expected materially lower / F high to *write*, low to *land*.**
Calibration, bluntly: program papers by independent researchers are read in proportion to the verified results attached to them. Jacobson could publish an equation-of-state essay on physical argument alone; this program buys the equivalent attention with Lean artifacts. Sequence strictly after P1+P2 (+P3 if possible), citing them as existence proofs of the method. Venue: Foundations of Physics, SciPost Physics Core, or arXiv gr-qc essay + FQXi-style contest as a visibility channel.

**P6. "Discrete Hodge decomposition, formalized" + the Λ-localization note (Gate Λ1).**
mathlib PR for finite-complex Hodge theory (likely absent from mathlib; verify) + a short paper connecting it to the cohomological localization of Λ and the everpresent-Λ counting argument.
**N 5 / S 4–5 standalone, infrastructure value high / F high.** The mathlib PR is reputation currency in exactly the community P1/P2 need.

**P7. Krein housekeeping ("the three J's", γ₅-Hermiticity = Krein self-adjointness, two-grading discipline).**
**N 4–5 / S 4 / F high.** Krein spectral triple literature (van den Dungen, Paschke–Sitarz, Strohmaier lineage) likely contains fragments; survey first. Default: fold into P4 as an appendix unless the survey reveals a real gap.

## Tier 4 — the moonshot (name it, gate it, don't schedule it yet)

**P9. "A machine-verified entanglement first law and the Einstein equation of state on causal graphs" (Gate G1′.2–3).**
The landmark version of the program: discrete first law proved (not just measured) on graph diamonds, feeding a verified discrete equation-of-state derivation.
**N 9 / S 9–10 / F low near-term.** Everything in Tiers 1–3 is, from this vantage, the construction of the tools and credibility to attempt P9. Gate: attempt only if P3's Gaussian theorem lands (it is the technical rehearsal) and the F-M2 type-mismatch problem shows any crack.

## Portfolio summary

| ID | Title (short) | N | S | F | Depends on |
|---|---|---|---|---|---|
| P2 | Mass as concurrence (verified) | 6 | 6 | ★★★ | Gate I1 (slack-time) |
| P8 | Kinematics as matrix analysis | 5 | 4 | ★★★ | P2 content |
| P5 | Semantic Lean auditing | 6 | 5–6 | ★★★ | existing toolkit |
| P1 | Verified chiral lattice fermion | 7 | 7 | ★★☆ | Gate C1 (critical path) |
| P3 | Discrete QNEC | 8* | 6–8 | ★★☆ | A3 protocol; lit-check |
| P6 | Hodge/Λ + mathlib | 5 | 4–5 | ★★★ | Gate Λ1 |
| P4 | NRQG program paper | 6 | high-var | ★★☆(write) | P1+P2 landed |
| P7 | Krein three-J's | 4–5 | 4 | ★★★ | survey |
| P9 | Verified first law → Einstein | 9 | 9–10 | ★☆☆ | P3 theorem + F-M2 progress |

---

# Part C — Research plan

## C0. Strategic logic

The program has exactly one asset no competing unification program has: **an operating pipeline that turns physics-grade operator theory into machine-checked theorems.** Everything in the plan is ordered to compound that asset. The sequencing principle is: *verified finite-dimensional theorems first (cheap, undeniable), the flagship operator theorem second (the proof the pipeline scales), the empirical toy third (the bridge to the QI/holography audience), the program paper last (when there is a citation graph to stand on).* Speculation is never on the critical path; it rides in documents like v2, gated by theorems.

The independent-researcher constraint is handled structurally, not wishfully: arXiv endorsement and community standing come through the formalization community (PhysLean/Physlib, Lean Zulip, mathlib PRs), where contributions are judged by artifacts that compile. That community is currently small, growing, hungry for research-level physics content, and actively worried about AI-generated proof quality — three facts that P2, P1, and P5 respectively are shaped to serve.

## C1-phase plan (indicative durations; C1 = the Lean gate, unchanged)

**Phase 0 — now → ~2 months. "Hold the critical path, build the wedge."**
- Critical path (unchanged from v2 §13): finish `TetraFreeOperatorGap_equalN` → self-adjointness → sign/GW layer. No new active-proof scope. All new ideas queue behind this.
- Slack-time track: Gate I1 + A1 + A2 in Lean (finite matrix algebra; the EG-program experience prices this in weeks). Draft P2 concurrently — the paper is mostly already written across v2 §1/§3 and Part A.
- Community track: open contact with PhysLean/Physlib (P2 as the offered contribution); establish arXiv endorsement route; small mathlib/PhysLean PRs as calling cards.
- Decision artifact: pre-register P1's two outcomes (gap proved / obstruction found) so either result publishes without narrative rewrites.

**Phase 1 — ~2 → 5 months. "Land the wedge, fire the flagship."**
- Submit P2 (arXiv + PhysLean PR). Spin off P8 in the same month (it is a rewrite, not new work).
- C1 lands → write P1 with the A4 positioning section (hyperdiamond no-gos; Creutz–Kimura–Misumi overlap-from-exotic-kernels as nearest neighbor; verification as the differentiator). Dual-audience structure.
- Start P3 numerics: correlation-matrix code for the 1+1d null chain (days of Python), massless calibration run first (QNEC saturation isolates lattice artifacts). Run the literature check that resolves the N=8* asterisk.
- P5: harden the auditing toolkit against the P2/P1 codebases (dogfooding is the evaluation section), draft the methods paper.

**Phase 2 — ~5 → 10 months. "The empirical bridge."**
- P3: massive and quenched regimes; attempt the Gaussian discrete-QNEC theorem; measure the discrete first law on lattice diamonds (Gate G1′.2's numerical shadow). Publish whichever of {theorem+numerics, numerics, violation-discovery} materializes.
- Gate I2 (finite Bisognano–Wichmann, three-J separation) formalized — small, and it is the formal backbone of P3's interpretation.
- P6: mathlib Hodge PR + Λ note.
- Begin Gate C2 Lean work (gauge-covariant shifts, γ₅/J_K-covariance audits) as the new critical path.

**Phase 3 — ~10 → 18 months. "The program paper, from strength."**
- P4: the v2 treatise hardened by citing P1/P2/P3 as delivered gates; failure modes updated with what the numerics taught; venue Foundations of Physics or SciPost.
- P7 survey decision (standalone vs. P4 appendix).
- P9 go/no-go review: attempt only if the P3 Gaussian theorem landed and the type-mismatch problem (F-M2) has shown any tractable finite-to-continuum handle. Otherwise Gate C2/C3 remain the critical path and P9 stays a named target.

## C2. Risk register (deltas to v2 §12)

- **R1 — C1 gap failure.** Mitigated by pre-registered obstruction-paper framing (Phase 0). The tetrahedral no-go would itself engage the Bedaque et al. genre.
- **R2 — scooping on P3.** The QI/holography community moves fast; the discrete-QNEC niche could close. Mitigation: the numerics are cheap — front-run with an arXiv note as soon as the calibration run is clean.
- **R3 — attention failure on P4.** Accepted by design: P4's expected value is carried by the wedge papers; the program's health is measured in gates closed, not essay readership.
- **R4 — pipeline credibility.** AI-assisted Lean invites the "slop" suspicion. P5 is the structural answer: publish the auditing methodology *before* skeptics ask, and apply it publicly to the program's own artifacts.
- **R5 — single-researcher bus factor & burnout.** Two programs (EG analytic + NRQG) share one person. The plan deliberately makes Phases 0–1 heavy on *small closable units* (I1, A1, A2, P8) so that morale-bearing wins arrive monthly, and it shares all Lean infrastructure (operator-theory lemmas, auditing toolkit, CI) between EG and NRQG so neither program taxes the other's tooling.

## C3. What "strong enough shape" means, concretely

The program should consider itself to have crossed from *promising* to *established* when the following four artifacts exist simultaneously: (1) a PhysLean-integrated verified kinematics module (P2 merged); (2) a machine-checked chiral lattice fermion theorem on arXiv with a compiling artifact (P1); (3) a discrete QNEC result — theorem or measured discovery — in the QI citation graph (P3); (4) a program paper that cites the first three as closed gates rather than promises (P4). At that point the moonshot (P9) stops being a fantasy and becomes a proposal that a collaboration — human or otherwise — could reasonably join.

## C4. One-line priorities

This month: **C1 critical path by day; Gate I1 in Lean by night; one email to the PhysLean maintainers.**
