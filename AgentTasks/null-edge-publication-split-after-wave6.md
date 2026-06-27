# Null-edge publication split after the Gate A/B/C wave

**Type: no-build publication-strategy job. Generated 2026-06-26.**

No Lean, Lake, pre-commit, or build/check command was run to produce this report.
It is a planning artifact only and changes no Lean source. Every status label,
gate ordering, and kill-switch rule below is read from the program's own
documents in `materials/` and must be re-verified against the live repo before
any promotion or submission.

Sources consulted (all under `materials/`):

- `Null_Edge_Unified_Mass_Model_Working_Plan.md` (central thesis, claim
  hierarchy §1-§2, mechanism map §4, paper path §5, claim ledger §9, risk
  guardrails §10, gates §20, integration freeze and kill switches §21, P1
  posture and proof-chain spine §18).
- `null-edge-live-proof-verification-report.md` (live re-verification of the four
  draft files: electroweak stabilizer, finite tetrad postulate, scalar kinetic
  reconstruction, anomaly audit).
- `null-edge-super-dirac-sign-counterexamples-report.md` (Gate A sign theorem +
  wrong-grading counterexamples).
- `null-edge-kinetic-normalization-report.md` (A6 `Knull`/`Kfull` naming +
  mass-shell lemma).
- `null-edge-null-solder-frame-foundations-report.md` (Gate B B0→B1→B3→B2).
- `null-edge-high-momentum-branch-proof-report.md` (Gate C T16 finite corner
  classification).
- `null-edge-branch-count-interpretation.md` (Gate C C2b verdict).
- `null-edge-krein-double-counterexample-report.md` (C5+C7 Krein hygiene vs
  stability).
- `null-edge-next-wave-strategy.md`, `null-edge-wave6-gates-native-*.md`,
  `null-edge-aristotle-ambitious-job-backlog-2026-06-26.md` (job IDs, gate
  orderings, scoping).
- `ARISTOTLE.md`, `CONVENTIONS.md` (workflow, locked conventions).

---

## 0. Status taxonomy used in every inventory below

To keep every paper's theorem table comparable, each result is filed under one
of five labels. The first three are evidentiary; the last two are not.

| Label | Meaning | Promotion bar |
| --- | --- | --- |
| **Trusted** | Kernel-checked, `sorry`-free, axioms in `{propext, Classical.choice, Quot.sound}` (+`Lean.ofReduceBool`/`Lean.trustCompiler` only where a `native_decide` example is explicitly noted), **and** semantically reviewed against the locked conventions, with the G1 convention banner attached. Citable as a theorem. | Banner attached; semantic review on file. |
| **Draft** | Kernel-checked and `sorry`-free, but held in `PhysicsSM/Draft/*` pending a dependency, a missing banner, or a gate that has not cleared. Correct as stated; not yet citable as trusted. | Resolve the named dependency/gate + banner. |
| **Aristotle artifact** | A machine-checked Lean deliverable produced by the proof agent whose statement is finite/algebraic and verified, but whose *physical reading* is still under semantic review (no promotion claim). | Semantic review + label fixed (§ G1). |
| **Planned** | A target stated in the program documents with an intended statement, not yet formalized. | Write statement, then prove. |
| **Speculative** | A conceptual/program-level claim with no proof, possibly heuristic or possibly false; appears only as motivation. | Demote to motivation or convert to a Planned target. |

**Convention banner (G1 invariant, Working Plan §21.8).** Every theorem promoted
to Trusted must declare metric signature (mostly-minus `+t²−x²`), grading
conventions (`Γ_s` is spacetime chirality only; never an internal grading
`χ_E`/form degree), kinetic-sign convention (`K_null` normalized to symbol `+p²`,
i.e. `−Box_analytic`), and frame/soldering normalization (dual-soldered `α^a`,
never the diagonal flats `ℓ_a^♭`). The live-verification report flags that **none
of the four currently-verified draft files carries this banner yet**; attaching
it is a hard prerequisite for every promotion below.

---

## 1. Recommended paper sequence (next 3-5 manuscripts)

```text
Paper A  (P1)    Finite Plücker kinematic invariant-mass theorem      [PUSH FIRST]
Paper B  (P1.5)  Finite reconstruction of known mass mechanisms
Paper C  (GateC) Branch-count / no-go audit of the naive flat operator
Paper D  (Plan)  Unified mass-obstruction working-plan / position paper
Paper E  (Bridge) Furey / internal-spectrum anomaly bridge  -> as an APPENDIX
```

Rationale for the ordering:

- **A before everything.** P1 must be made review-safe and standalone *now*
  (Working Plan §21.7) and must not depend on P1.5 or P2. It is the one paper
  whose central claim is already a proved finite identity, so it carries the
  lowest reviewer risk and the highest evidentiary density.
- **B second.** P1.5 turns the "mass as null-edge gap" vision into a small set of
  *reconstruction* theorems (Yukawa checkerboard, Abelian Higgs link stiffness,
  electroweak stabilizer). Two of its three pillars already have Trusted-promotable
  artifacts. It explicitly does **not** assert prediction.
- **C third, and reframed as a constraint/no-go.** The Gate C branch hazards are
  publishable *as findings* — "the naive flat retarded operator has high-momentum
  determinant-level null branches and pervasive complex-energy branches; a cure
  must act on a whole variety" — provided the paper claims no-go/constraint
  status and never claims the cure exists or that no-doubling holds.
- **D fourth, clearly a position/working-plan paper.** The umbrella thesis
  ("mass is the obstruction to a null-edge system remaining a single free null
  ray") is honest only as a program statement, not a theorem. Publish it as such,
  after A/B give it concrete anchors.
- **E as an appendix, not a standalone.** The only machine-checked internal-
  spectrum content in hand is the one-generation anomaly arithmetic
  (`StandardModelAnomalyAudit.lean`). That is enough for a careful appendix to
  P1.5, not for a freestanding Furey-bridge paper, which would require an
  internal-spectrum *operator* result that does not yet exist.

---

## 2. Per-paper dossiers

### Paper A — P1: finite Plücker kinematic invariant-mass theorem

**Central claim.** For a finite family of null spinors `ψ_i` with
`P = Σ_i ψ_i ψ_i†`, the invariant mass squared is the total pairwise Plücker
spread: `det(P) = Σ_{i<j} |ψ_i ∧ ψ_j|²`; and `P` is massless **iff** all `ψ_i`
share one projective null direction (rank-one / projectively collinear). This is
the *finite kinematic origin of invariant mass for a null bundle* — nothing more.

**Theorem inventory.**

| Status | Items |
| --- | --- |
| Trusted (target on close-out) | T1 finite Plücker determinant / mass identity `det(P)=Σ_{i<j}|ψ_i∧ψ_j|²`; T2 massless ⇔ rank-one ⇔ projectively collinear. *(Confirm the exact Lean crosswalk file in the live repo and attach the G1 banner before citing as Trusted.)* |
| Draft | T3 celestial monopole/dipole and rest-frame closure guardrail (frame-relative `m/E` vs invariant `det(P)` distinction). |
| Aristotle artifact | The Lean formalization(s) backing T1/T2 (finite linear-algebra identity over `ℂ`); the twistor / static Dirac-square-root wrappers carried only with explicit status labels. |
| Planned | Theorem-to-Lean crosswalk table; frame-audited normalization corollary separating invariant `det(P)` from `det(ρ_{p|u})`. |
| Speculative | Any reading that `det(P)` is the universal formula for *all* mass — **excluded** (see below). |

**Claims that must be excluded.**

- "All mass is Plücker spread / one universal formula." (Working Plan §10
  overclaim guardrail; demote to: Plücker is the finite kinematic prototype.)
- Any implication that QCD confinement, electroweak breaking, Yukawa matrices,
  neutrino masses, or the *observed* mass spectrum are derived in P1
  (§18.3 "avoid").
- The word **"prediction"** anywhere; and `"spectral gap"` in the abstract/intro
  (reserve the gap language for the program paper). Reserve "origin of mass" /
  "disagreeing light" for an expository companion only.

**Minimum Lean/proof work before submission.**

1. Confirm in the live repo the file(s) proving T1 and T2 are `sorry`-free with
   clean axioms; record the theorem names in the crosswalk.
2. Attach the G1 convention banner (metric/grading n-a here/kinetic n-a/frame)
   and the frame-audited normalization note distinguishing invariant from
   frame-relative mass.
3. Add the explicit massless ⇔ collinear direction if only one direction is
   currently formal.
4. No new heavy proof is required; P1 is a close-out, not a build.

**Likely reviewer objections & responses.**

- *"This is just `det` of a sum of rank-one Hermitian projectors — known linear
  algebra."* Response: yes, and the contribution is the *formalized, frame-audited*
  identification with invariant mass plus the exact massless criterion, offered
  as the kinematic spine of a larger program, not as a new inequality.
- *"Origin of mass is overclaimed."* Response: the claim boundary box restricts
  to *finite kinematic invariant mass of a null bundle*; mechanism papers are
  separate and explicitly not assumed.
- *"Where is the dynamics / why are bundles trapped?"* Response: out of scope by
  construction; this is the kinematic accounting layer (§2 Level 1).

**Safest title / abstract language.**

- Title: *"Invariant Mass from Finite Null-Spinor Bundles: A Frame-Audited
  Plücker Theorem"* (§18.3). Expository companion may use poetic language.
- Abstract verbs: "we prove", "we formalize", "we characterize"; avoid "predict",
  "explain all mass", "spectral gap".

---

### Paper B — P1.5: finite reconstruction of known mass mechanisms

**Central claim.** Three known Standard-Model mass mechanisms admit *finite
null-edge reconstructions* as obstruction/gap quantities: (i) Dirac/Yukawa mass
as a left/right chirality-flip gap (Yukawa checkerboard square + rectangular
singular-value theorem); (ii) Abelian gauge-boson mass as a Higgs link-stiffness
(holonomy-condensate mismatch) quadratic form; (iii) electroweak gauge-boson
mass structure as a stabilizer kernel/rank theorem with the photon as the
stabilizer direction. These are **reconstructions of known physics**, with free
parameters left free — not predictions.

**Theorem inventory.**

| Status | Items |
| --- | --- |
| Trusted (promotable after banner) | T9 electroweak stabilizer: `ker B_EW = span{Q}` (the `u(1)_em` line), `dim ker = 1`, `rank = 3` for `v≠0`, with quadratic-form radical = kernel (`NullEdgeElectroweakStabilizer.lean`; verified clean, statement faithful, `v≠0` load-bearing). Carry the **real-coordinate `ℝ⁴→ℂ²` caveat** as an explicit import. |
| Aristotle artifact | T8 Abelian Higgs link stiffness / inverse-Gram null-kinetic reconstruction (`NullEdgeScalarKineticReconstruction.lean`; verified clean, signature-general; `euclidean_collapse_guardrail` is one-directional). |
| Draft | T8 currently **draft-only**: must be re-audited against Gate B B1/B3 and refactored onto the shared B0 `NullSolderFrame` before promotion. |
| Planned | T5 Yukawa checkerboard square; T6 rectangular singular-value / positive-spectrum equality; T4 abstract mass-shell matching theorem; T12 Higgs radial Hessian (appendix); T7 Majorana/Takagi/seesaw stress test (appendix); T10 electroweak coefficient (`m_W`,`m_Z`) theorem (appendix; **not done** — "coefficient formulas" remains an unproved target). |
| Speculative | Any statement that these reconstructions *fix* Yukawa values, the QCD scale, or neutrino parameters — **excluded**. |

**Claims that must be excluded.**

- Numerical Yukawa values, `m_W`/`m_Z` coefficients, or the QCD scale being
  *derived* (claim ledger §9: "Not established").
- "The gauge symmetry literally breaks." Use stabilizer / covariant-reference-
  section language: holonomies preserving the Higgs section stay gapless;
  holonomies moving it acquire a quadratic cost (§4.3, §10 gauge guardrail).
- QCD as a mechanism theorem. Keep QCD to the bounded sentence: "QCD supplies
  confinement and dynamics; Plücker supplies the invariant accounting"
  (§4.4, §20.10). Do **not** define a `B_QCD` obstruction.
- The non-chirality / non-doubling disclaimer must travel with the anomaly
  appendix (it proves arithmetic, not that the null-edge construction realizes
  the chiral SM).

**Minimum Lean/proof work before submission.**

1. Banner on `NullEdgeElectroweakStabilizer.lean`; lock the real-coordinate
   caveat; optionally add the literal quadratic-form-rank corollary.
2. Formalize T5 (Yukawa checkerboard) and T6 (rectangular SVD) — these are the
   parallelizable first-wave finite-algebra targets (§18.4) and the main missing
   pillar.
3. Refactor T8 onto the B0 `NullSolderFrame` (Gate B) and re-audit vs B1/B3.
4. Keep T10/T12/T7 as clearly-labeled Planned appendices; do not block the paper
   on them.

**Likely reviewer objections & responses.**

- *"You're re-deriving the Higgs mechanism in heavy notation."* Response: correct
  — the claim *is* reconstruction; the value is a uniform finite null-edge
  language and machine-checked statements, with free parameters explicitly free.
- *"Does the construction force the chiral SM?"* Response: no, and we say so; the
  anomaly appendix is arithmetic bookkeeping, not a chirality/doubling claim.
- *"Real- vs complex-coordinate counting could be gamed."* Response: the count is
  pinned as an `ℝ`-linear map `ℝ⁴→ℂ²`; the caveat is an explicit import and a
  `ℂ`-coordinate reading is forbidden as a "fix".

**Safest title / abstract language.**

- Title: *"Null-Edge Reconstructions of Standard-Model Mass Mechanisms: Three
  Finite Theorems"* (avoid "spectral gaps" as a headline noun; it is fine inside
  as program language).
- Abstract verbs: "we reconstruct", "we formalize", "we characterize the kernel
  and rank"; never "predict".

---

### Paper C — Gate C branch-count / no-go audit of the naive flat retarded operator

**Central claim (a constraint / no-go finding, not a viability claim).** For the
flat tetrahedral retarded dual-soldered null-edge Dirac operator, coefficient-
vector–zero analysis is **insufficient**: there exist nonzero null Clifford
symbols (`p(q)≠0`, `p(q)²=0`) at high momentum. Concretely, on the corner set
`{0,π}⁴` exactly five corners are null (1 origin + 4 high-momentum three-π
corners), the warning corner `q=(π,π,π,0)` has `u=(-2,-2,-2,0)` with
`uᵀG⁻¹u=0` while `u≠0`, the determinant-zero set is a *positive-dimensional*
variety, and energy-slice scans show pervasive complex-energy branches with real
propagating roots only on a measure-zero locus. **Therefore the naive
no-doubling argument is refuted, and continuum/stability viability is not
established; a cure must act on a whole variety, not a finite corner list.**

**Theorem inventory.**

| Status | Items |
| --- | --- |
| Trusted (finite identities, after banner) | T16 corner classification (`TetrahedralHighMomentumNullBranch.lean`): `warning_uT_Ginv_u`, `threePi_null`, `corner_qform = k²−3k`, the 16-corner counts by `decide`, `cornerU_eq_zero_iff` (only the origin is coefficient-zero), and `pSq_mink_eq_qform` (genuine mostly-minus Minkowski square = `uᵀG⁻¹u`). Axioms clean; no `native_decide`. |
| Trusted (finite Krein identity + counterexamples) | C5/C7 (`KreinDoubleAndCounterexamples.lean`): `Ddbl_kreinSelfAdjoint` (Layer A hygiene) **paired with** `jselfadj_not_real_spectrum`, `jselfadj_not_stable`, `doubling_not_positive` (Layer B: hygiene ⇏ stability). |
| Aristotle artifact | The branch-count oracle reproductions (corner numbers, 201 grid null points, 18/432 real roots) as kernel-checked finite facts. |
| Draft / interpretation | C2b classification (`null-edge-branch-count-interpretation.md`): each high-momentum corner is a **category-1.6 fatal-doubler candidate, pending**; complex branches are **1.7 fatal-complex candidates, pending**. |
| Planned | The missing load-bearing columns per branch: `krein_sign`, `gauge_content`, `h_scaling`, `growth_rate`, `chirality` decomposition under `Γ_s`. These decide 1.6-vs-1.2-vs-1.4 and 1.7-vs-1.5. |
| Speculative | A definitive 1.8 "requires redesign" kill verdict — **not yet earned** (no admissible cure has been computed and ruled out). |

**Claims that must be excluded.**

- "No-doubling holds" / "the operator is continuum-viable" / "stable" / "real
  spectrum" / "positive energy". The branch-count interpretation puts all of
  these under a hard stop. Mandatory downgraded wording: *"retardedness removes
  coefficient-zero doublers only; high-momentum determinant-level branches
  survive and require an explicit removal mechanism"*, and *"Lorentzian
  adjointness audited; spectral stability open."*
- "Krein `J`-self-adjointness implies stability/positivity/real spectrum." The
  C7 counterexample (`D₋D₊=-I`, spectrum `{±i}`) must travel with any C5 result.
- "These branches are harmless artifacts." The criteria forbid a "looks harmless"
  tag without the computed columns; the honest label is *pending* at 1.6/1.7
  severity.
- A definitive 1.8 redesign verdict (not yet demonstrated).

**Minimum Lean/proof work before submission.**

1. Banner on `TetrahedralHighMomentumNullBranch.lean` and
   `KreinDoubleAndCounterexamples.lean`.
2. Add the in-repo non-vanishing witness for the finite-tetrad `T_frame` (a
   concrete `[∇_a,C_b]≠0` with `T_frame≠0`) so the postulate is demonstrably
   non-vacuous — supports the operator-architecture framing.
3. Optionally formalize at least one *column* (e.g. `energy_real` on the corner
   family, already partly finite) to strengthen the no-go from "refutes the
   coefficient-zero argument" toward a sharper per-branch statement — but do not
   over-formalize; the paper's claim is the refutation + the pending audit, not a
   cure.

**Likely reviewer objections & responses.**

- *"This is just lattice fermion doubling (Nielsen-Ninomiya); nothing new."*
  Response: we agree the hazard is in that family and cite it as such; the
  contribution is the *finite, kernel-checked* demonstration for this specific
  retarded null-edge operator, refuting the program's own earlier coefficient-zero
  no-doubling argument, with a precise pending-classification ledger.
- *"You haven't shown the operator is dead."* Response: exactly — we explicitly
  do not claim 1.8; we publish the refutation of no-doubling and the constraint
  that any cure must act on a positive-dimensional variety.
- *"Krein language is hand-wavy."* Response: the Krein result is a finite
  algebraic identity, paired with explicit counterexamples proving it is hygiene,
  not stability.

**Safest title / abstract language.**

- Title: *"Determinant-Level Null Branches of a Flat Retarded Null-Edge Dirac
  Operator: A Finite No-Doubling Audit"* (or "...Constraints on Naive
  No-Doubling").
- Abstract verbs: "we exhibit", "we refute (the coefficient-zero argument)", "we
  classify as pending"; never "we establish stability/viability/no-doubling".

---

### Paper D — Unified mass-obstruction working-plan / position paper

**Central claim (program statement, not a theorem).** A broad organizing thesis:
*"Mass is the obstruction to a null-edge system remaining a single free null
ray"* (equivalently, "an effective mass is a spectral gap / constraint / rest-
frame invariant of dynamics whose primitive transport steps are null"), with the
Plücker theorem as the proved finite kinematic prototype and the other SM
mechanisms organized as different gap/obstruction types in a shared null-edge
operator architecture.

**Theorem inventory.**

| Status | Items |
| --- | --- |
| Trusted (cited from A/B/C) | T1/T2 Plücker core; T9 electroweak stabilizer; T16 corner classification; C5/C7 Krein hygiene+counterexamples; SM anomaly arithmetic. (All *cited*, none re-proved here.) |
| Draft / Aristotle artifact | Gate A super-Dirac sign theorem `super_dirac_square_sum` and wrong-grading counterexamples (`NullEdgeSuperDiracSignAudit.lean`); A6 kinetic-naming normalization (`Knull`/`Kfull`, `mass_shell_iff`); Gate B `NullSolderFrame` foundations B0-B3 + B2 trace obstruction; finite-tetrad `D_N²` decomposition. |
| Planned | P2 finite super-Dirac operator and graded square; T13 dual-soldered commutator/symbol; the four-principle front-door statement; the canonical-obstruction datum + claim ledger. |
| Speculative | Higgs-boson radial-mode mass, neutrino hidden-sector gap, QCD color-holonomy gap — all explicitly **motivation only** (claim ledger §9: targets / not established). The umbrella slogan itself is a program thesis, not a theorem. |

**Claims that must be excluded.**

- That the umbrella slogan is *proved*. It is a unifying language; only Level-1
  (kinematic) is established (§2).
- "All mass is the same Plücker formula" (§1 replaces this slogan).
- Any prediction language (§17.6: forbidden until the codimension/rank gate).
- Gauge "breaking" language; QCD-as-mechanism language.

**Minimum Lean/proof work before submission.** None new — this paper *organizes*
existing artifacts. Required instead: (i) the four-way claim ledger
(representation / reconstruction / structural theorem / prediction) applied to
every cited result; (ii) the gate map (A convention freeze → B finite algebra →
C branch audit → D continuum → E physics audits → F prediction) with current
status; (iii) explicit statement that only Level-1 is proved.

**Likely reviewer objections & responses.**

- *"This is a manifesto, not a result."* Response: it is labeled a program/
  position paper; its evidentiary backbone is the cited Trusted finite theorems,
  and every speculative item is ledgered as such.
- *"The slogan overpromises."* Response: the claim boundary restricts proved
  content to kinematics; the slogan is offered as organizing language with an
  explicit not-yet-proved ledger.

**Safest title / abstract language.**

- Title: *"Mass as a Null-Edge Obstruction: A Program and Claim Ledger"* (the
  word "program" or "working plan" should appear).
- Abstract: "we propose", "we organize", "we delimit what is proved vs
  conjectured"; never "we show that all mass...".

---

### Paper E — Furey / internal-spectrum anomaly bridge (recommended as an APPENDIX, not standalone)

**Central claim (bounded).** The one-generation Standard-Model hypercharge
spectrum satisfies all four hypercharge-dependent anomaly cancellations
(`U(1)-grav`, `U(1)³`, `SU(2)²U(1)`, `SU(3)²U(1)`), including after adding a
right-handed-neutrino conjugate — a finite arithmetic consistency fact about the
internal representation content, offered as a bridge to internal-spectrum
(division-algebra / Furey-style) constructions.

**Theorem inventory.**

| Status | Items |
| --- | --- |
| Trusted (arithmetic only, after banner) | `grav_anomaly_zero`, `cube_anomaly_zero`, `su2_anomaly_zero`, `su3_anomaly_zero`, `sm_anomaly_cancellation`, `sm_anomaly_cancellation_with_nu` (`StandardModelAnomalyAudit.lean`; verified clean, exact-rational, non-vacuous). |
| Planned | Any internal-spectrum *operator* statement (a division-algebra / Clifford internal-grading realization that *produces* the spectrum, with `χ_E` kept strictly distinct from `Γ_s`). |
| Speculative | That the null-edge / internal-spectrum construction *realizes* the chiral SM, fixes generation number, or selects representations as a prediction — **excluded** until the prediction gate. |

**Claims that must be excluded.**

- Any chirality / doubling / "realizes the chiral SM" claim — the audit is
  representation bookkeeping only; the disclaimer must travel with the theorem.
- "Anomaly-selected representation" stated as a *prediction* (it is a candidate
  only, gated by Gate F).
- Direct copying of Baez/Furey formulas; per `CONVENTIONS.md` use the project's
  `Octonion.ConventionBridge` for any relabeling/sign checks.

**Minimum Lean/proof work before submission.** Banner + non-chirality disclaimer
on the anomaly file. A standalone Furey paper would *additionally* require a new
internal-spectrum operator theorem that does not yet exist — hence the appendix
recommendation.

**Likely reviewer objections & responses.**

- *"Anomaly cancellation is textbook."* Response: yes; here it is a machine-
  checked consistency anchor for the internal-spectrum bridge, explicitly not a
  derivation of the spectrum.
- *"Where is the division-algebra content?"* Response: deferred; the appendix
  claims only the arithmetic bridge, with the operator realization listed as
  Planned.

**Safest title / abstract language (as appendix heading).**

- Heading: *"Appendix: one-generation anomaly arithmetic as an internal-spectrum
  consistency check"*. Avoid "Furey model derives the Standard Model".

---

## 3. Comparison of the five candidate papers

| Paper | Strongest evidence in hand | Reviewer risk | Overclaim hazard | Verdict |
| --- | --- | --- | --- | --- |
| **P1 — Plücker kinematic mass** | Proved finite identity (T1/T2) | Low ("known linear algebra") | "all mass" / "origin of mass" — controllable with claim box | **Push first.** Highest evidence/risk ratio; standalone by design (§21.7). |
| **P1.5 — reconstruction** | T9 Trusted-promotable; T8 artifact; T5/T6 missing | Medium ("re-derivation") | prediction / gauge-breaking / QCD — controllable | **Second.** Needs T5/T6 + B0 refactor first. |
| **Gate C — no-go audit** | T16 + C5/C7 Trusted finite facts | Medium (Nielsen-Ninomiya framing) | "no-doubling refuted" is safe; "viable/stable" is forbidden | **Third, as constraint/no-go.** Publishable now as a *finding*; never as viability. |
| **Unified obstruction — working plan** | Organizes A/B/C; no new proof | Medium-high ("manifesto") | slogan as theorem; prediction language | **Fourth, labeled position paper.** Strong only after A/B anchor it. |
| **Furey / internal-spectrum bridge** | Anomaly arithmetic only | High if standalone | "realizes chiral SM" / "predicts representations" | **Appendix to P1.5**, not standalone yet. |

Key separations the comparison enforces:

- **Reconstruction (P1, P1.5) vs no-go (Gate C) vs program (unified) vs bridge
  (Furey).** Keeping these in separate manuscripts is what lets the positive
  mathematics be published without the operator hazards contaminating it, and
  lets the hazards be published honestly as constraints rather than buried.
- **P1 must not depend on P1.5/P2** (§21.7). The Gate C paper must not gate P1 or
  P1.5: the branch hazards concern the *flat operator* (P2 territory), not the
  Plücker kinematics or the reconstruction theorems.
- The **Gate A** super-Dirac sign result is a *hard promotion prerequisite for
  any finite graded-square theorem* (§21.2); it therefore belongs to the P2 /
  unified-plan track, **not** to P1 or P1.5. No graded-square claim may be
  promoted into P1.5 before Gate A clears in Lean.

---

## 4. First manuscript to push, and first appendix/theorem table to prepare

**First manuscript: Paper A (P1).** It is the only candidate whose central claim
is already a proved finite identity, it is required to be made review-safe
immediately and standalone (Working Plan §21.7), and it carries the lowest
overclaim risk once the claim-boundary box and frame-audited normalization are in
place.

**First appendix/theorem table to prepare: the P1 theorem-to-Lean crosswalk and
trusted/draft/artifact/planned/speculative status map** (§18.3 lists this as a
required P1 component). Concretely, a table with columns:

```text
Theorem label | English statement | Lean decl name + file | Status (§0) |
Axioms | Convention banner attached? | Claim label (repr/reconstruction/
structural/prediction)
```

seeded with T1, T2, T3 and the twistor/Dirac-square-root wrappers. This table is
reusable as the backbone of every subsequent paper's inventory, so building it
first pays compounding dividends. Prepare it *before* writing the P1 abstract, so
the abstract cannot drift ahead of what the table certifies.

A second, near-term table to stage: the **Gate C pending-column ledger** (the
eight load-bearing columns vs computed/not-computed from
`null-edge-branch-count-interpretation.md` §0), which becomes the spine of
Paper C and keeps its claims honest.

---

## 5. How to discuss predictions: reconstruction first, prediction only under the rank/codimension gate

**Default posture: reconstruction first.** Until a formal gate is passed, every
result is described with one of the labels *representation*, *reconstruction*, or
*structural theorem* — never *prediction* (Working Plan §17.6, §18.2, §21.5).
P1 and P1.5 are reconstruction/structural-theorem papers by construction; they
leave Yukawa values, `m_W`/`m_Z` coefficients, the QCD scale, and neutrino
parameters explicitly free (claim ledger §9).

**The prediction gate (Gate F / codimension gate).** A claim may be labeled a
*prediction* only when the finite-to-EFT map

```text
F : M_finite -> M_EFT
```

is shown to be non-surjective in the relevant sense, i.e.

```text
rank(dF) < dim M_EFT,   or   a nontrivial relation  R(theta_EFT) = 0
```

**survives redundancy, gauge-choice, and field-redefinition checks** (simple
parameter counting is only a first screen; §20.9, §16.15). This requires P1,
P1.5, P2a (finite dual-soldered algebra), and P2b (branch-count + scaling
control) to be in place first (§17.6); prediction work waits behind them.

**Practical wording rules for the manuscripts.**

- Reconstruction sentence (allowed now): *"the finite null-edge data reconstruct
  the known mass mechanism X with parameters left free."*
- Prediction sentence (forbidden until Gate F): *"the finite geometry forces /
  restricts EFT parameter Y."* Until the gate, the strongest allowed forward-
  looking phrasing is *"candidate structural constraint"* for items like
  forbidden Pauli terms, restricted Yukawa rank/texture, anomaly-selected
  representations, forced Higgs stabilizer, or generation number — each marked
  *candidate*, not *prediction*.
- Maintain a **moduli-rank ledger** as a standing appendix (§10 prediction-risk
  guardrail) so any future prediction claim is auditable against the redundancy
  checks.

---

## 6. Guardrail compliance summary (carried verbatim into every manuscript)

| Guardrail | Where enforced above |
| --- | --- |
| No new physics predictions unless the prediction gate is passed | §2 (every paper excludes "prediction"); §5 (Gate F definition + wording rules). |
| Do not claim all mass is Plücker spread | §2 Paper A/D exclusions; §1 thesis demotes the slogan; Plücker = finite kinematic prototype only. |
| Do not claim gauge symmetry literally breaks | §2 Paper B exclusion; stabilizer / covariant-reference-section language mandated. |
| Do not imply no-doubling or continuum viability before Gate C | §2 Paper C exclusions; mandatory downgraded wording; Krein C5 paired with C7; 1.8 verdict withheld. |
| Keep QCD language bounded | §2 Paper B/D exclusions; only the bounded "confinement + dynamics / Plücker accounting" sentence; no `B_QCD`. |

---

## 7. One-line recommendation

Prepare the P1 theorem-to-Lean crosswalk table first, attach the G1 convention
banner to the Plücker core, and push **P1 (finite Plücker kinematic invariant-
mass theorem)** as the first manuscript — keeping reconstruction (P1, P1.5)
strictly separated from the Gate C no-go audit and the unified-program position
paper, and admitting prediction language only after the rank/codimension gate
clears.
