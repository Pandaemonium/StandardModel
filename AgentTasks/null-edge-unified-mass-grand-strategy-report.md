# Null-edge unified mass plan: grand-strategy report

**No-build strategy/audit deliverable. Generated 2026-06-26.**

Scope and method. This report is a written strategy and proof-architecture
review. No Lean, Lake, or build command was run. It synthesizes the program's
own source documents:

- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` (primary),
- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`,
- `docs/NULLSTRAND.md`,
- `Sources/NullStrand_Lean_Roadmap_Improved.md`,
- `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`,
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`,
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`,
- `AgentTasks/context-packs/null-edge-unified-mass-strategy-context-pack.md`,
- `AGENTS.md` (repo culture and guardrails only).

Companion deliverables:

- `AgentTasks/null-edge-unified-mass-proof-chain.md` (Section B: the full
  theorem chain P1 -> P1.5 -> P2, with formal-shape recommendations);
- `AgentTasks/null-edge-unified-mass-aristotle-next-jobs.md` (Section G: the
  next wave of Aristotle jobs).

This report covers Sections A, C, D, E, F, and the closing executive summary.

---

## A. Central thesis and claim boundary

### A.1 Is "mass as quadratic obstruction" the best umbrella language?

Yes, with one refinement. The program already converged (Working Plan
Section 16) on **mass as quadratic obstruction** as the top-level umbrella, and
this is the right call. It is the unique phrase that:

- is literally true of every mechanism in the table (each mass-squared is a
  norm-square or eigenvalue of a map `B` measuring failure to lie in a
  distinguished subspace);
- does not commit to a single formula (avoids the "all mass is Pluecker"
  overclaim, the explicit core guardrail);
- is mathematically disciplined rather than metaphorical, because it names a
  concrete object (`m^2 = value or eigenvalue of B^dagger B`).

The refinement, which the Working Plan already states and which this report
endorses as load-bearing, is the **non-vacuity criterion**: the template
`m^2 = B^dagger B` is content-free unless `B` is *canonical* -- geometrically or
physically forced, not chosen after the fact. Any positive matrix is some
`B^dagger B`. So the umbrella language must always be paired with a statement of
*which* `B` is forced and *by what*. The umbrella is "mass as quadratic
obstruction by a canonical obstruction map." Drop "canonical" and a referee
correctly dismisses the whole frame as reparametrization.

Recommended single most-defensible sentence (already drafted, Working Plan
16.18 / PROMPT thesis): keep it verbatim. It correctly leads with "We do not
claim that all mass is literally the same Pluecker spread formula."

### A.2 Is the manuscript-level thesis strong enough to be interesting but safe?

The current thesis is correctly positioned, but the *interest* and the *safety*
live in two different claims that must be kept separate in the prose:

- **Safe and proved (P1):** a finite, machine-checked kinematic identity
  (`det(sum psi psi^dagger) = sum |psi_i wedge psi_j|^2`) with an exact massless
  criterion. This is genuinely interesting as a formalized result and as the
  `n`-edge generalization of massive spinor-helicity, but it is "only"
  kinematics.
- **Interesting but not yet proved (P1.5/P2):** that the *same* obstruction
  template organizes Yukawa, W/Z, Higgs-scalar, and (loosely) QCD mass inside a
  single null-edge operator architecture.

The thesis is strong enough to be interesting precisely because it proposes the
common architecture; it is safe enough only if every sentence about the common
architecture carries a claim-type label (representation / reconstruction /
structural theorem / prediction). The danger is not the thesis -- it is
unlabeled drift between the proved kinematic core and the aspirational operator
program. The four-way claim ledger (Working Plan 16.14) is the single most
important safety device and should appear in every paper, not just the working
notes.

Net assessment: the thesis is well-calibrated. The remaining risk is entirely
in execution discipline, not in the statement.

### A.3 Where should "spectral gap" be used, and where avoided?

The Working Plan's resolution (Section 16) is correct and should be enforced
mechanically:

Use `spectral gap` ONLY for:

- operator spectra (Dirac square, Hamiltonian);
- Hessians (Higgs radial mode, `m_h^2 = 2 lambda v^2`);
- mass matrices and their eigenvalues (Yukawa `M^dagger M`, seesaw block);
- the `K psi = B^dagger B psi` mass-shell matching context.

AVOID `spectral gap` for:

- the P1 Pluecker mass. It is a **rest-frame invariant of a state / finite
  bivector norm**, not an operator spectral-gap theorem. Calling it a spectral
  gap is a subtle but real overclaim and will draw a correct referee objection.
- broad introductions. There use **"obstruction to remaining a single free
  gapless null ray"** (kinematic, mechanism-agnostic).

Concrete rule for authors: in P1, the words "spectral gap" should appear zero
times in the abstract and introduction, and only in a clearly-scoped forward
pointer to P1.5/P2. In P1.5 and P2 the term becomes the natural technical
language for Yukawa/electroweak/Higgs/Dirac-square sections.

### A.4 Exact claim-boundary paragraph P1 should use

The Working Plan (16.5) already drafted a near-final version. Recommended P1
claim-boundary box, to sit immediately after the abstract:

```text
This paper proves a finite kinematic theorem: a bundle of null spinor momenta
has invariant mass precisely to the extent that its null directions fail to
remain projectively collinear, with mass squared equal to the total pairwise
Pluecker spread. It does not derive the Standard Model mass spectrum, QCD
confinement, electroweak symmetry breaking, or Yukawa couplings; those belong
to later operator and dynamics layers. The theorem supplies the square-level
invariant that any null-edge dynamics must reproduce.

Scope of "mass": invariant particle or bound-state mass, or a spectral mass
parameter in a relativistic field theory. We do not address gravitational
source energy, ADM/Bondi mass, black-hole mass, or cosmological vacuum energy.
```

This is the right boundary because it (i) states exactly what is proved, (ii)
names the four things readers will assume are proved and disclaims them, (iii)
gives the program a forward role for the theorem ("square-level invariant any
dynamics must reproduce"), and (iv) excludes gravitational/cosmological mass,
which is a frequent reviewer trap for "origin of mass" titles.

One title caution: the current draft title "The Origin of Mass: matter as
trapped, disagreeing light" is excellent for the expository P1-E but is too
strong for the formal P1-F. For the formal venue use the publication plan's
contract title: "Invariant Mass from Finite Null-Spinor Bundles: A
Frame-Audited Pluecker Theorem." Keep the poetic title for the expository
companion only.

### A.5 Should P1 mention the unified-mass program prominently or as outlook?

Keep it as a **short, clearly-labeled outlook**, not a prominent co-headline.

Reasoning:

- P1's strength is that it is fully proved and reviewable. Anything that makes a
  referee suspect the paper is "really" about the unproved grand program weakens
  the one thing P1 has that the rest of the program lacks: completeness.
- The unified program is genuinely interesting, so it belongs in the paper -- as
  one outlook section and one claim ledger, framed as "the operator-theoretic
  form the later mechanisms must take," with explicit "not proved here" labels.
- The expository companion (P1-E) is the right vehicle for prominent program
  framing, because expository venues tolerate vision; the formal venue does not.

Recommended split: P1-F mentions the program in (a) one sentence in the
abstract ("...the finite kinematic core of a broader null-edge origin-of-mass
program..."), (b) one outlook section near the end, (c) the claim ledger. The
Part-I high-school narrative and the full mechanism table move to P1-E.

---

## C. Hardest mathematical blockers (ranked)

For each: what counts as success, what counts as failure, and the smallest
useful theorem/audit. Ranking is by combined difficulty and centrality.

### C.1 (Hardest) Finite-to-continuum symbol and square limits

This is the master blocker; without it the whole "null edges do real work"
claim is unsupported (Strengthened Program "Remaining" list; Open Questions
Q5/Q6; NULLSTRAND scaling tests).

- Success: a commuting-square theorem -- finite super-Dirac square, then
  `h -> 0`, equals the continuum Dirac/Lichnerowicz square with correct kinetic
  normalization (`Box` symbol `-p^2`, mass-shell `p^2 = m^2`), correct Pauli
  coefficient, and no surviving frame term.
- Failure: surviving `T_frame` at `O(h^{-1})`, wrong Lichnerowicz endomorphism,
  wrong holonomy normalization, or high-frequency branches that do not
  decouple.
- Smallest useful target: the **flat fixed-graph symbol theorem** on a periodic
  tetrahedral patch -- prove `p(q) = h^{-1} sum_a (exp(i q_a) - 1) alpha^a` and
  that the finite symbol converges to `c(p)` as `q -> 0`, before any curvature.

### C.2 Super-Dirac grading and signs

The `+Phi^2` vs `-Phi^2` sign is determined entirely by how `Phi_H` commutes
with the chirality `Gamma_s` used in `D = i D_N + Gamma_s Phi_H`
(NULLSTRAND; Open Questions 6.9).

- Success: a graded square theorem with three *separately tracked* gradings
  (`Gamma_s` spacetime chirality, `chi_E` internal, `epsilon_form` cochain
  degree) under the explicit hypotheses
  `{Gamma_s, C_a} = 0`, `[Gamma_s, nabla_a] = 0`, `[Gamma_s, Phi] = 0`,
  `[C_a, Phi] = 0`, yielding
  `D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi]`.
- Failure: `Phi` made odd under the *same* `Gamma_s`, flipping `Phi^2` to
  `-Phi^2` (tachyonic mass) -- the single most likely silent error.
- Smallest useful target: a **two-by-two abstract block lemma** proving the
  sign under the four commutation hypotheses, with a companion lemma showing the
  sign flips when the hypothesis on `[Gamma_s, Phi]` is replaced by
  anticommutation. The negative companion is the audit value.

### C.3 Branch-count / no-doubling determinant tests

Retardedness rules out coefficient-zero doublers only; the physical test is at
the determinant level (NULLSTRAND; Open Questions 6.13.7).

- Success: a determinant-level theorem characterizing the full zero set of
  `det D_+(q)` on the periodic patch, identifying real and complex branches,
  kernel dimensions, and chirality, and showing only the continuum point gives a
  physical massless mode.
- Failure: a "no-doubling" claim resting only on `p(q) = 0 iff q = 0`, ignoring
  that nonzero null `p(q)` can still produce a Clifford kernel.
- Smallest useful target: compute `det D_+(q)` symbolically for the
  tetrahedral retarded operator on a 1- or 2-mode periodic patch and enumerate
  its zeros; even a low-dimensional case is a real audit.

### C.4 Krein / Lorentzian self-adjointness vs physical stability

The Lorentzian operator must be audited as `J`-self-adjoint (Krein), not naive
Hilbert self-adjoint (NULLSTRAND; Publication Plan P2-F Lorentzian audit).

- Success: a finite Krein API (`J = J^dagger = J^{-1}`, `[u,v]_J = <u, J v>`,
  `A^sharp = J A^dagger J`) and a proof that the doubled operator
  `D_dbl = [[0, D_-],[D_+, 0]]` with `D_- = D_+^sharp` is `J`-self-adjoint.
- Failure: claiming positivity, unitary evolution, real spectrum, stability,
  anomaly cancellation, or a chiral SM sector *from* Krein self-adjointness.
  Krein self-adjointness implies none of these.
- Smallest useful target: the finite Krein-double self-adjointness lemma plus an
  explicit caveat lemma/example showing a `J`-self-adjoint operator with
  complex spectrum (to prevent the overclaim).

### C.5 Electroweak stabilizer normalization and gauge-invariant composites

The kernel/rank statement is clean; the coefficient formulas depend on
normalization, and the gauge-invariant-composite target is genuinely open
(Working Plan 16.8-16.9).

- Success: stage 1, `ker B_EW = u(1)_em`, `rank q = 3`, proved purely from the
  SM electroweak group and Higgs representation; stage 2, the coefficient form
  `q(X) = v^2/8 (g^2((W^1)^2+(W^2)^2) + (g W^3 - g' B)^2)` with `m_W = g v/2`,
  `m_Z = sqrt(g^2+g'^2) v/2`, `m_gamma = 0`, in a documented normalization.
- Failure: presenting photon masslessness as a *prediction*. It is reconstruction
  / structural theorem *given* the SM group and Higgs rep, and only predictive if
  null-edge axioms force that group and rep.
- Smallest useful target: stage 1 alone (kernel and rank), as a finite
  representation-theory lemma over `C^2`. This is the most tractable nontrivial
  electroweak statement in the whole program.

### C.6 Anomaly / chirality constraints

A chiral gauge theory must be anomaly-consistent; a finite/lattice construction
must show it can support the observed chiral structure (Strengthened Program;
context-pack hyperdiamond/doubling note).

- Success: an audit showing the finite construction admits a chiral assignment
  with cancelled gauge anomalies (at minimum, that the doubling structure does
  not force a vector-like spectrum).
- Failure: a model that can only realize vector-like (doubled) fermions, i.e.
  cannot host the SM chiral content.
- Smallest useful target: a chirality/anomaly *audit note* (no-build) plus, as a
  later proof job, a finite per-generation anomaly-sum vanishing check over the
  SM hypercharges.

### C.7 Spectral-action / moduli-rank constraints (the prediction gate)

Distinguishes reconstruction from prediction via `F : M_finite -> M_EFT`
(Working Plan 16.15).

- Success: either `rank(dF) < dim M_EFT` at a generic point, or a nontrivial
  relation `R(theta_EFT) = 0` on the image (a codimension constraint, e.g. a
  Chamseddine-Connes-style coupling relation).
- Failure: `F` is generically full rank -- the finite model has enough knobs to
  fit all SM parameters and predicts nothing.
- Smallest useful target: build the *ledger* (enumerate `M_finite` and `M_EFT`
  coordinates) and compute a naive parameter count as a first, honest
  reconstruction-vs-prediction screen. Codimension is the real criterion, but
  the count is the cheap first pass.

### C.8 QCD / confinement gap (if attempted)

This is the weakest leg of the obstruction template; there is no clean finite
`B` yet (Working Plan 16.2 table).

- Success (long-horizon): a finite confining color Hamiltonian or holonomy
  theorem with a genuine mass gap.
- Failure: any sentence implying the Pluecker theorem "derives proton mass."
- Smallest useful target: *do not* attempt a QCD theorem now. The correct
  near-term deliverable is the disciplined boundary sentence "QCD supplies
  confinement and dynamics; Pluecker supplies invariant accounting," plus a
  trace-anomaly disclaimer.

### C.9 Markov / stochastic null-edge dynamics (if relevant)

Lower priority for the *mass* program (it belongs to the Bohm-Bell dynamics
line, Roadmap W3/W11). Smallest useful target if pursued: a finite CTMC
regenerative SLLN / Poisson-equation route for coarse-grained timelike motion
from null steps. Keep out of the mass papers unless a specific mass result needs
it.

---

## D. Hardest physics blockers and conceptual traps

### D.1 The false "all mass is Pluecker spread" claim

The central trap, and the program's own stated guardrail. Pluecker spread is a
*kinematic accounting* invariant of a bundle of given null momenta; it is not a
mechanism for Yukawa, electroweak, scalar, or QCD mass. Mitigation: the
quadratic-obstruction umbrella with per-mechanism canonical `B`; never let the
Pluecker formula stand as the universal mass formula. Status discipline: P1 =
finite identity; the rest = distinct obstruction forms.

### D.2 QCD overclaim

"Mass without mass" is the program's best public hook and its biggest liability.
The honest statement is that ~95% of hadron mass is confined relativistic/field
energy (Wilczek), and the Pluecker theorem is the clean kinematic skeleton of
that picture, not a derivation. Mitigation: keep QCD as motivation/bridge in
P1; never as a toy theorem unless a real finite confinement result exists;
explicitly disclaim the trace anomaly and hadron spectrum.

### D.3 Gauge-symmetry-breaking wording errors

A local gauge symmetry is a redundancy and does not "break" as an observable.
Saying it does is both physically wrong and a guaranteed referee strike
(FMS caution). Mitigation (Working Plan 16.9): use covariant-reference-section
language -- "the Higgs field defines a covariant internal reference section;
holonomies that fail to preserve it acquire a quadratic edge cost; stabilizer
directions remain gapless." The exact finite object `|U_e H_t - H_s|^2` is
gauge-invariant; W/Z mass terms appear only after a vacuum/trivialization
expansion. Target the FMS-style gauge-invariant link composite
`O_e^a = H_s^dagger tau^a U_e H_t` as the physical excitation.

### D.4 Timelike emergent worldlines vs null primitive steps

The obvious objection: "if every primitive step is null, why do massive
particles move on timelike worldlines?" Answer (Working Plan 16.12): the
primitive transport steps are null; the observed timelike trajectory is a
coarse-grained/spectral object. A timelike momentum is a sum/average of null
momenta; a massive mode satisfies a null kinetic equation with internal
obstruction `K = m^2`; a bound state has a rest frame even with massless
constituents. P1 proves the kinematic instance exactly. Trap to avoid:
implying the null *primitive* step is itself a slower-than-light trajectory, or
that a Higgs vertex value is a sub-luminal particle path (a vertex section is
not a trajectory).

### D.5 Invariant mass of a state vs spectral gap of an operator

These are different objects and conflating them is the subtle version of D.1.
P1's `det(P) = m^2` is a state invariant; Yukawa/electroweak/Higgs masses are
operator spectra. Mitigation: the A.3 vocabulary rule (no "spectral gap" for
Pluecker), and the explicit separation of `det(P)` (invariant) from the
normalized `det(rho_{p|u})` (frame-relative `m/E`).

### D.6 Mass double-counting between Pluecker kinetic invariant and Phi_H^2

The single most dangerous *internal* consistency trap (Working Plan Section 2,
10; context-pack hits 1 and 3). The Pluecker/null spread is the **kinetic
symbol invariant**; `Phi_H^2` is the **zero-order internal mass block**. They
are the two sides of one on-shell condition `K_h(xi) = eigenvalue(Phi_H^2)`,
NOT two additive mass sources. Mitigation: every operator-level statement must
exhibit the on-shell matching, and the super-Dirac square must keep fermion
mass in `Phi_H^2` and W/Z mass in `|nabla^A H|^2`, never adding a second
Pluecker term inside `Phi_H^2`.

### D.7 What would make the framework predictive rather than reconstructive

The honest current status is reconstruction (and partly representation). To
become predictive, the finite null-edge geometry must force at least one SM
input that is normally free. The realistic early prediction *candidates* are
structural, not numerical (Working Plan 15.12): forbidden Pauli counterterms;
restricted Yukawa rank/texture/zero pattern; anomaly-forced representation
class; forced Higgs representation or stabilizer; a spectral-action relation
among `g, g', g_s, lambda, v`; a finite-geometry reason for the generation
number; a specific Lorentz-dispersion correction. Until one such constraint is
proved, the correct label is "unified reconstruction," not "derivation of the
mass spectrum."

---

## E. Manuscript architecture

Recommended sequence (unchanged from the Working Plan, with sharper scoping):
P1 (finite kinematic core) -> P1.5 (toy mass mechanisms) -> P2 (dual-soldered
super-Dirac) -> later prediction/rank paper. Split each formal paper from its
expository companion (P1-F / P1-E pattern).

### E.1 P1 -- finite kinematic core

Include: definitions/conventions; the determinant/Pluecker theorem; massless-iff
projectively-collinear; the frame-audited normalization (`P` vs `rho_{p|u}`,
invariant vs `m/E`); celestial monopole/dipole moment form; `SL(2,C)`
covariance; twistor-chart matching with explicit determinant-vs-trace
normalization; the static Dirac square root as a labeled forward pointer to P2;
prior-art differentiation; the claim ledger; reproducibility appendix.

Defer: any operator dynamics; any SM mass spectrum; QCD/Higgs/neutrino as
*results* (keep as bridges only). Defer the full mechanism table and high-school
narrative to P1-E.

Key figures/tables: (1) two opposite photons in a box; (2) fanned celestial
sphere, energy monopole vs net momentum dipole, with the mass deficit; (3)
theorem-status map (trusted / draft / artifact / future), as a typeset figure;
(4) the theorem-to-Lean crosswalk table; (5) the conventions table.

Safe claims: the determinant identity, reality/nonnegativity, the exact massless
criterion, covariance, twistor matching. Pre-submission action: promote the
celestial-moment artifact and the `SL(2,C)`/Dirac-slash drafts into the trusted
surface, or quarantine them as clearly-labeled appendices (do not present drafts
as trusted).

### E.2 P1.5 -- toy mass mechanisms

Include three finite toy theorems, in this order (most-decisive first):

1. Yukawa checkerboard / chirality-flip gap: `K_L psi_L = M M^dagger psi_L`,
   `K_R psi_R = M^dagger M psi_R`, plus the rectangular singular-value theorem
   `spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M)`.
2. Abelian Higgs link stiffness: the exact gauge-invariant theorem
   `S_H = v^2 sum_e |w_e - 1|^2` with `w_e = sigma_s^{-1} U_e sigma_t`, then the
   small-holonomy expansion to `v^2 epsilon^2 A_e^2` as *interpretation*.
3. Electroweak stabilizer: stage 1 (`ker B_EW = u(1)_em`, `rank = 3`); stage 2
   (coefficient formulas, appendix).

Add as short appendices: Higgs radial Hessian (`m_h^2 = 2 lambda v^2`) and the
seesaw stress-test (`M_light ~ -m_D M_R^{-1} m_D^T`).

Defer: any continuum limit; any claim that the toy theorems predict parameters;
neutrino model selection.

Key figures/tables: the quadratic-obstruction master table (mechanism ->
canonical `B` -> meaning of `B^dagger B`); the four-way claim ledger applied to
each toy theorem; the L/R checkerboard lattice picture.

Safe claims: each toy theorem as labeled reconstruction/structural-theorem; the
gauge-invariant link-stiffness identity (exact); the stabilizer kernel/rank
(structural, given SM group+rep). Unsafe: calling any of these a prediction; the
W/Z mass interpretation without the "after expansion" qualifier.

Critical wording discipline for P1.5: the Abelian Higgs theorem alone is close
to standard lattice gauge-Higgs theory. State plainly (Working Plan 16.10) that
null edges add content only inside the surrounding package (null-supported
kinetic terms, fermions and holonomies on the same null substrate, dual-soldered
symbol recovery, super-Dirac square). Without that package P1.5 is a graph
discretization with null labels -- say so.

### E.3 P2 -- dual-soldered super-Dirac operator

Include: the operator `D_h(A,H) = i sum_a c(alpha^a) nabla_a^A + Gamma_s Phi_H`;
the dual-soldered commutator/symbol theorem (the missing seam, Publication Plan
P2-F); the graded square with separated gradings; the decomposition
`D_N^2 = Box_null + C_diamond + T_frame`; the finite tetrad postulate
`[nabla_a, C_b] = 0` and the frame-term audit with defect classification; the
Krein double and its caveat; the mass-shell matching `K_h(xi) = spec(Phi_H^2)`;
the Pauli diamond normalization audit; the no-doubling determinant protocol.

Defer: the continuum-limit *proof* (state it as the gate, give the flat symbol
case); chirality/anomaly *resolution* (give the audit); any prediction.

Key figures/tables: the term-role table (`K_h`, `Phi_H^2`, `C_diamond`,
`T_frame`, `[nabla, Phi]`); the grading table; the scaling-test order
(flat symbol -> flat determinant -> curved tetrad -> commuting square).

Safe claims: the finite square as a finite identity/reconstruction; the
dual-soldered symbol theorem; Krein `J`-self-adjointness of the double. Unsafe:
any continuum, stability, or new-physics claim from the finite square alone --
"the dual-soldered square is currently a reconstruction and finite identity, not
new physics by itself" (NULLSTRAND).

Convention hard rule (NULLSTRAND): the active architecture is
`sum_a c(alpha^a) nabla_a` (null support `ell_a`, dual-covector soldering
`alpha^a`). Do NOT revive `sum_a c(ell_a^flat) nabla_ell_a` -- the diagonal
trace obstruction is known.

### E.4 Later -- prediction / moduli-rank paper

Include: the map `F : M_finite -> M_EFT`; the full moduli-rank ledger; the
codimension/`rank(dF)` criterion; a spectral-action attempt; the structural
prediction candidates (forbidden counterterms, Yukawa texture, anomaly-forced
rep, generation number, dispersion correction).

Defer: numerical mass predictions unless a constraint is actually proved.

Key figures/tables: the `M_finite` vs `M_EFT` coordinate ledger; a
reconstruction-vs-prediction decision tree; the fast-failure-test checklist.

Safe claims: parameter counts and explicit codimension statements. Unsafe: any
"we derive the masses" framing without a proved relation.

---

## F. Referee-facing posture

### F.1 Strongest skeptical referee report

> The paper repackages well-known facts in new vocabulary. (1) That two
> back-to-back null momenta have timelike invariant mass is textbook
> spinor-helicity; the `n`-edge "Pluecker spread" is a Gram/Cauchy-Binet
> determinant identity, not a new physical mechanism. (2) The "unified mass"
> thesis is a list of standard mechanisms (Higgs/Yukawa, Higgs mechanism for
> W/Z, QCD binding energy, Higgs potential curvature) relabeled as "quadratic
> obstructions"; since every positive mass-squared is trivially some
> `B^dagger B`, the template is vacuous. (3) Nothing is predicted: Yukawa
> matrices, gauge couplings, `v`, `lambda`, and `Lambda_QCD` are all inputs, so
> the model reconstructs at best and reparametrizes at worst. (4) The
> "null edges" carry no proven weight: the Abelian Higgs result is ordinary
> lattice gauge-Higgs theory, and no continuum/no-doubling/anomaly theorem shows
> the null substrate yields the chiral Standard Model. (5) The gauge-boson
> story risks the usual error of treating a gauge redundancy as a broken
> observable symmetry. (6) The title "origin of mass" overclaims relative to a
> finite kinematic identity.

### F.2 Authors' best response

> We accept that the ingredients are standard and state so explicitly. The
> contribution of P1 is narrow and exact: a finite, machine-checked theorem
> identifying invariant mass with the total pairwise Pluecker spread of a null
> bundle, with an exact massless criterion, reality, Lorentz covariance, and
> twistor matching -- the `n`-edge forward direction of massive spinor-helicity,
> not the textbook reverse. On vacuity: we agree the `B^dagger B` template is
> empty unless `B` is canonical, and we only claim it where `B` is forced
> (Pluecker minors, the Yukawa block, the Higgs orbit map); QCD is explicitly
> left without a clean finite `B`. On prediction: we label every claim as
> representation, reconstruction, structural theorem, or prediction, and we
> state plainly that P1-P1.5 are reconstruction, not numerical derivation; the
> prediction question is deferred to an explicit moduli-rank gate. On null edges:
> we agree the Abelian Higgs piece alone is lattice gauge-Higgs theory, and we
> specify exactly which surrounding theorems (dual-soldered symbol, graded
> square, no-doubling determinant test) are required before null edges earn
> their keep. On gauge wording: we use gauge-invariant link-stiffness language
> and the FMS-style composite, never "the symmetry breaks." On the title: the
> formal paper is titled as a frame-audited Pluecker theorem; "origin of mass"
> is reserved for the expository companion.

### F.3 Phrases to avoid

- "We explain the origin of all mass."
- "All mass is (the same) Pluecker spread / trapped light."
- "The Pluecker theorem derives the proton mass."
- "The gauge symmetry breaks" / "spontaneous breaking of a local symmetry"
  (as an observable).
- "mass is stuff" / "mass is bottled-up motion" in the formal paper.
- "spectral gap" applied to the P1 Pluecker invariant.
- "predicts" / "derives" for any quantity that is an input.
- "the null lattice gives the Standard Model" (without the theorem package).
- "Krein self-adjoint, therefore stable/unitary/real spectrum."

### F.4 Phrases to use

- "mass as quadratic obstruction" (with a named canonical `B`).
- "obstruction to remaining a single free gapless null ray" (intro).
- "spectral gap" for operator spectra, Hessians, mass matrices, Dirac squares.
- "finite kinematic core / invariant of a state / rest-frame obstruction" (P1).
- "QCD supplies confinement and dynamics; Pluecker supplies invariant
  accounting."
- "covariant internal reference section; holonomies that move it acquire
  quadratic edge cost; stabilizer directions remain gapless."
- "reconstruction / representation / structural theorem / prediction" (labels).
- "the square-level invariant any null-edge dynamics must reproduce."
- "machine-checked / kernel-clean" (only for genuinely trusted declarations).

### F.5 One-paragraph answers

**Is this just the Standard Model on a null lattice?** Not in P1, which is a
representation-independent kinematic identity about null momentum bundles, with
no lattice and no gauge dynamics. In P1.5/P2 the honest answer is: the Abelian
Higgs piece is close to lattice gauge-Higgs theory, and the null substrate adds
content only if the accompanying theorems hold -- null-supported kinetic terms, a
dual-soldered continuum symbol, a graded super-Dirac square with correct
kinetic/curvature/frame/`Phi^2` terms, and a determinant-level no-doubling
result. We state this gate explicitly rather than asserting novelty.

**Does this predict any masses?** No, not yet. P1-P1.5 reconstruct the standard
mass mechanisms from null-edge primitives with the Standard Model inputs left
free. Prediction would require the finite null-edge geometry to constrain a
normally-free parameter, tested via a moduli-rank/codimension gate
`F : M_finite -> M_EFT`. The realistic early targets are structural (forbidden
counterterms, restricted Yukawa texture, anomaly-forced representations, a
spectral-action coupling relation, a generation-number reason), not numerical
masses.

**Why care if parameters are still input?** Because a disciplined, machine-checked
demonstration that the distinct Standard Model mass mechanisms all instantiate a
single quadratic-obstruction template on a common null-edge substrate is a real
structural result, even before any parameter is fixed. It sharpens what
"origin of mass" can mean, separates kinematic invariants from operator spectra,
and defines an explicit, falsifiable gate (the moduli-rank ledger) for when the
program would cross from reconstruction to prediction.

**How is this different from spinor-helicity bookkeeping?** Spinor-helicity
writes one massive momentum as a pair of null spinors (the `n = 2` reverse
direction). The contribution here is the `n`-edge forward direction -- an
arbitrary finite bundle, with mass equal to the total pairwise spread, an exact
massless-iff-collinear criterion, reality/covariance/twistor wrappers, and a
kernel-checked formalization. The geometry (sum of squared `Gr(2,n)` Pluecker
coordinates, massless locus = rank-one cone) is the organizing object, not a
single two-spinor pairing.

**How is this different from lattice gauge theory?** The bare Abelian Higgs edge
functional is essentially lattice gauge-Higgs theory and we do not claim
otherwise. The intended difference is structural: edges are null (lightlike
support), the Clifford symbol is dual-soldered (`c(alpha^a)` on the dual
covector, not `c(ell_a)` on the null direction), fermions/holonomies/Higgs
differences live on the same null substrate, and the program targets a
dual-soldered continuum Dirac symbol with a determinant-level no-doubling test
rather than a Euclidean plaquette action. These are claims to be proved, not
assumed; absent the theorem package, P1.5 is a null-labeled discretization.

---

## Executive summary

**Strongest thesis (use verbatim).**
Primitive spacetime transport is null; effective mass is a *quadratic
obstruction* to a null-edge system remaining a single free gapless null mode --
a Pluecker rest-frame invariant for finite null bundles, a chirality-flip gap
for fermions, a condensate-holonomy stiffness for W/Z, a radial Hessian gap for
the Higgs amplitude, and a confined color-dynamics gap for hadrons. We do not
claim all mass is the same Pluecker formula. P1 proves the finite kinematic
prototype exactly; P1.5/P2 organize the other mechanisms as distinct canonical
obstruction maps on a shared null-edge operator.

**Top five proof-chain steps** (detail in the proof-chain report):
1. P1 Pluecker bundle identity + exact massless criterion (proved; promote
   wrappers).
2. Yukawa checkerboard square + rectangular singular-value theorem.
3. Abelian Higgs gauge-invariant link-stiffness identity.
4. Electroweak stabilizer: `ker B_EW = u(1)_em`, `rank = 3` (stage 1).
5. Dual-soldered graded super-Dirac square with separated gradings and correct
   `-K + Phi^2` sign.

**Top five blockers.**
1. Finite-to-continuum symbol/square limit (the master blocker).
2. Super-Dirac grading/sign correctness (`+Phi^2` vs `-Phi^2`).
3. Determinant-level no-doubling / branch count.
4. Krein/Lorentzian self-adjointness vs physical stability (no overclaim).
5. The prediction gate: moduli-rank codimension of `F : M_finite -> M_EFT`.

**Top five manuscript changes.**
1. Adopt "quadratic obstruction (by a canonical `B`)" as umbrella; restrict
   "spectral gap" to operator/Hessian/mass-matrix contexts.
2. Insert the A.4 claim-boundary box and the four-way claim ledger into every
   paper.
3. Retitle the formal P1 as a frame-audited Pluecker theorem; move the poetic
   "origin of mass" and the mechanism table to the expository companion.
4. Replace all gauge-breaking wording with covariant-reference-section /
   link-composite language.
5. State the "null edges vs lattice gauge theory" gate explicitly in P1.5 and
   keep `det(P)` (invariant) separate from `det(rho_{p|u})` (`m/E`).

**Top five next Aristotle jobs** (detail in the next-jobs report):
1. Proof: Yukawa checkerboard square + rectangular SVD theorem.
2. Proof: electroweak stabilizer kernel/rank (stage 1).
3. Proof: Abelian Higgs gauge-invariant link-stiffness identity.
4. Audit (no-build): super-Dirac grading/sign and `Phi_H^2` double-counting.
5. Strategy (no-build): moduli-rank prediction ledger and codimension gate.
