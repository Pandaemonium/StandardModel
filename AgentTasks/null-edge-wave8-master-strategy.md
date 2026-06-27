# Wave 8 master strategy after literature and Wave 7 audits

Date: 2026-06-26.
Type: Strategy (no-build).
Provenance inputs: `PROMPT.md`, `COMMON_CONTEXT.md`, the Wave 1–7 backlog
(`AgentTasks__null-edge-aristotle-ambitious-job-backlog-2026-06-26.md`), and the
two copied planning docs (`Sources__NullStrand_Lean_Roadmap_Improved.md`,
`Sources__Null_Edge_Unified_Mass_Model_Working_Plan.md`).

This document designs the proof-heavy wave that should be launched *after* the
Wave 7 audits return, treating the whole program as a gate system. It is written
to be directly actionable: every recommendation names the affected job IDs from
the backlog and ties them to gate acceptance/failure criteria.

---

## 0. Executive summary

The program is now audit-saturated and proof-thin. Waves 1–7 have stress-tested
nearly every architectural seam (Yukawa, EW, Abelian Higgs, signs, branches,
Krein, FMS, continuum square, anomaly, QCD scope) and added a literature layer
(DEC/Hodge-Dirac, connection-Laplacian, spectral-graph fermions, quiver spectral
action, finite spectral-triple moduli). The binding constraint is no longer "do
we have a strategy"; it is **which finite theorems are now ripe and kernel-safe
to promote, conditioned on Gate C not being fatal**.

The single most important structural fact for Wave 8 scheduling:

> **Gate C (flat branch count / determinant-zero classification) is the program's
> primary kill switch.** Almost every ambitious *continuum* and *prediction*
> claim is downstream of C. But a large block of finite, internal, and
> packaging work is **C-independent** and should be run in parallel rather than
> stalled behind C.

So Wave 8 is deliberately a **two-track wave**:

- **Track G-D-cond (Gate-C-gated continuum):** launch only if Gate C returns
  *nonfatal*. This is the DEC/Hodge-Dirac continuum spine plus curvature/kinetic
  proofs.
- **Track H/B/E-fin (Gate-C-independent finite):** launch now regardless of C.
  This is the internal-spectrum/anomaly Furey bridge, finite square/branch-matrix
  algebra, EW stabilizer, FMS composite, and Plucker promotion — all of which are
  finite linear-algebra theorems whose truth does not depend on the continuum
  branch verdict.

The recommended publication spine is **P1 first, P1.5 second, and the
branch/Krein audit paper held as the publishable hedge** — not the unified mass
architecture paper, which should remain a manuscript skeleton until Gate C, Gate
D, and the moduli-rank gate (Gate F) all clear.

---

## 1. Gate-C conditional launches (launch only if Gate C is nonfatal)

Gate C bundles: flat branch count (C1/C2/C3), massive branch count (C4),
determinant/propagator-zero classification (C14), species/doubler count
(C13/C17), Krein (C5/C6/C7), and chirality (C9/C10/C18). The relevant Wave 7
returns are the audits C13–C18 plus the literature packs L10/L12, and the
acceptance-criteria job G3.

**Definition of "Gate C nonfatal" (acceptance gate, decided by G3 + C14 + C13):**

1. Every high-momentum determinant zero is classified (C14 table) as one of:
   physical pole, gapped taste partner, kinematical/projected artifact — and
   **none** classified as an unavoidable physical doubler or complex instability;
   and
2. the spectral-graph species count (C17) agrees with the momentum-symbol branch
   count (no hidden graph-native zero modes); and
3. modified/flavored chirality (C18) does not reveal that ordinary chirality was
   misclassifying the zero modes in a way that forces a vector-like spectrum.

If (1)–(3) hold, Gate C is **nonfatal** and the following jobs are unlocked.

| Launch-if-C-nonfatal | ID | Type | Depends on |
| --- | --- | --- | --- |
| Continuum estimate framework freeze | D2 | Strategy | G3 acceptance |
| Smooth local symbol asymptotic `[D_h,M_f]=c(df)+O(h)` | D1 | Proof | D2, B1/B3 |
| DEC/Hodge-Dirac convergence adaptation strategy | D13 | Strategy | L9, C nonfatal |
| Connection-Laplacian convergence audit | D14 | Audit | D13, B3 |
| Curvature diamond coefficient theorem | D3 | Proof | D1, D6 |
| Null-diamond holonomy → curvature | D4 | Proof | D1, D14 |
| Commuting-square flat scalar limit | D7 | Proof | D1, D2 |
| Scalar/gauge null kinetic continuum limit | D8 | Proof | D7, S8 re-audit |
| Super-Dirac square with `Phi_H` gradient | D10 | Proof | A1, B4 |
| Massive branch count `det(iD_+ + Gamma_s Phi)=0` | C4 | Audit | C1/C3 |
| Full moduli-rank `F: M_finite→M_EFT` | F9 | Prediction | requires C + D data |

Rationale: D-track continuum convergence is only meaningful if the discrete
operator it converges to has no fatal branch pathology. Spending DEC/connection-
Laplacian effort on an operator that carries unavoidable doublers would prove
convergence *to a broken object*. Hence the hard gate.

**Do not** launch C4, F9, or any "prediction gate" manuscript (F10) before Gate C
is declared nonfatal: a fatal C verdict changes the operator, which invalidates
massive-branch and moduli-rank conclusions.

---

## 2. Gate-D jobs that can proceed while Gate C is pending

A subset of Gate-D-labelled work is actually *framework/source* work whose
correctness does not depend on the branch verdict, because it only fixes
conventions, target formulas, and import scaffolding. These can run concurrently
with Gate C to remove critical-path latency:

| Proceed while C pending | ID | Type | Why C-independent |
| --- | --- | --- | --- |
| Continuum estimate framework selection | D2 | Strategy | Chooses filters/asymptotic API; agnostic to branch verdict |
| Lichnerowicz comparison audit (target formula + sign map) | D6 | Audit | Fixes the *target* continuum formula and conventions; independent of discrete branches |
| DEC/FEEC Hodge-Dirac convergence **source pack** | L9 | Source | Literature anchoring only |
| Generalized Lichnerowicz / Dirac-Yukawa source pack | D16 | Source | Literature anchoring only |
| Causal-set d'Alembertian source pack + falsification probe | L12, D15 | Source/Audit | These *feed* the C/D verdict; they are diagnostics, not built on a passing operator |
| Lorentzian vs Euclidean spectral-action compatibility | D9 | Strategy | Decides what may be imported; convention-level |

Key distinction: D2, D6, D9, D16, L9, L12 are **preparation** that *should*
finish before the C verdict so that the moment C is declared nonfatal, the heavy
D1/D3/D4/D7/D8 proofs can start with conventions already frozen. D15 (causal-set
falsification probe) is special: it is partly a *C/D kill-switch input* and
should be run early precisely because a negative causal-set-style result would
itself contribute to a fatal verdict.

What must **not** proceed while C is pending: any D-track *theorem* that bakes in
the discrete operator's spectrum (D1 beyond the toy symbol, D3, D4, D7, D8, D10),
because a fatal C verdict would force an operator redesign and waste that proof.

---

## 3. Should DEC/Hodge-Dirac convergence become the main continuum track?

**Recommendation: Yes — adopt DEC/Hodge-Dirac convergence (Dabetic–Hiptmair,
arXiv:2507.19405) as the *primary* Gate-D continuum scaffold (D13), with the
connection-Laplacian results (Ramanan; Singer–Wu) as the gauge/Higgs companion
(D14) — but only as the convergence *framework*, not as a correctness guarantee
for the null-edge operator.**

Reasoning:

- The program's biggest Gate-D risk is "inventing a continuum proof from
  scratch," which is analysis-heavy and easy to get wrong. Inheriting an
  established cochain→continuum convergence theorem converts an open-ended
  analysis project into a *hypothesis-checking* project: the work becomes "does
  the null-edge discrete operator satisfy the DEC convergence hypotheses?"
- DEC/Hodge-Dirac is the right comparison class because the null-edge operator is
  a discrete first-order Dirac-type operator on a cell/graph complex; Hodge-Dirac
  on cochains is its natural continuum target. Connection-Laplacian convergence
  (Singer–Wu spectral convergence from samples; Ramanan discrete connection
  Laplacians) supplies the gauge-holonomy and Higgs covariant-gradient pieces
  that pure Hodge-Dirac does not.

**Caveats that must be written into D13 acceptance criteria:**

1. **Lorentzian vs Euclidean.** DEC/FEEC convergence theory is Euclidean/
   Riemannian. The null-edge operator is retarded/Krein/Lorentzian. D13 must
   state explicitly whether convergence is claimed (a) for a Wick-rotated/
   elliptic proxy only, or (b) for the Lorentzian operator. Claim (b) is *not*
   licensed by the cited literature and must be downgraded to (a) unless a
   Krein-compatible convergence result is found (L6/C5/C7 feed this).
2. **The convergence target is Hodge-Dirac, which is Kähler–Dirac-like.** This
   re-raises the species/doubling and mirror-fermion issues (Catterall
   arXiv:2311.02487; H10 Kähler–Dirac anomaly comparison). So D13 cannot be
   declared a chirality win — it converges to an operator whose chirality content
   is exactly what Gate C is still adjudicating. **D13 is therefore gated by Gate
   C, not a substitute for it.**
3. The causal-set d'Alembertian warnings (Boguna–Krioukov arXiv:2506.18745;
   L12/D15) are the explicit falsification probe: if the null-edge retarded
   d'Alembertian shares the nonlocal causal-set convergence failure mode, the DEC
   route does not rescue it. Run D15 *before* committing D3/D4/D7/D8.

Net: DEC/Hodge-Dirac becomes the main *track*; it does not become a *result*
until C is nonfatal and the Lorentzian/Kähler-Dirac caveats are discharged.

---

## 4. Does quiver spectral-action comparison threaten novelty or mainly clarify it?

**Recommendation: It mainly *clarifies* novelty and is net protective — but it is
a genuine novelty-boundary stress test that must be run (E11) before any P1.5/P2
"reconstruction" claim is published.**

Analysis (van Suijlekom et al. Bratteli networks / quiver spectral action,
arXiv:2401.03705):

- The danger it probes: a referee says "this is just a quiver/Bratteli-network
  spectral-action reconstruction of Yang–Mills–Higgs with null labels." The
  COMMON_CONTEXT guardrail already anticipates this (E10 referee response).
- Why it is mainly clarifying, not threatening: the null-edge-specific content is
  **not** "finite graph carries a spectral action" (that is shared with quiver
  models and is *not* claimed as novel). The null-edge-specific content is:
  (i) the **null/Plucker kinematic** invariant accounting (P1: massless iff
  collinear), (ii) **dual soldering** and the **super-Dirac square**
  decomposition `D_N^2 = K_null + C_diamond + T_frame`, and (iii) the
  retarded/Krein causal structure. None of these are quiver-spectral-action
  results. The comparison *sharpens* the claim ledger by forcing every P1.5
  theorem to declare "what here is not generic quiver reconstruction" (G4
  specificity audit).
- Where it *could* threaten: the **prediction** claim. If the finite data is a
  generic quiver spectral action, its parameter count is the EFT parameter count
  (full-rank `F`), and there is no prediction. So the quiver comparison feeds
  directly into Gate F (F12 quiver parameter-count comparison) and is a *real*
  threat to prediction novelty, not to reconstruction novelty.

Action: run E11 (comparison/novelty-boundary audit) and F12 (parameter-count
comparison) as a pair in Wave 8. Treat E11 as protective (clarifies and defends),
F12 as adversarial (can downgrade prediction to reconstruction).

---

## 5. Do finite spectral-triple moduli make prediction claims harder?

**Recommendation: Yes — finite spectral-triple Dirac moduli (Cacic
arXiv:0902.2068; Bochniak–Sitarz arXiv:1804.09482) make prediction claims
*harder*, and this is the most important hidden-free-parameter risk in Gate
H/F. Run H11 (finite spectral-triple moduli audit) as a prediction *gate*, not a
reassurance.**

Reasoning:

- A prediction (per COMMON_CONTEXT) requires `rank(dF) < dim M_EFT` or a
  nontrivial relation `R(theta_EFT)=0`. Finite spectral-triple moduli spaces
  parametrize the allowed internal Dirac operators (the `Phi_H` / internal
  zero-order block). If that moduli space is large enough to independently realize
  the EFT Yukawa/parameter data, then the internal block silently *adds* free
  parameters that exactly fill the EFT, and `F` is full rank → no prediction.
- This is precisely the trap the H-gate scheduling rule warns about: "prediction
  language does not hide free internal parameters." The Cacic moduli result and
  the Bochniak–Sitarz finite pseudo-Riemannian SM triple show the internal Dirac
  operator generally has a **positive-dimensional moduli space**, so the default
  expectation is that prediction is *not* free.
- Consequently the burden is on the program to show the null-edge constraints
  (legal Yukawa flips H4, gauge neutrality + internal oddness + square-to-mass
  H5, anomaly inheritance H3) **cut the moduli down** to a codimension-positive
  locus. H8 (internal-sector codimension audit) is the test; H11 measures the
  ambient moduli dimension that H8 must beat.

Action: schedule H11 immediately (it is C-independent finite theory), and make
its output a required input to F9/F12/H8. Until H11 + H8 show a genuine
codimension reduction, **prediction language must stay off** and the program must
present itself as reconstruction (this matches the safe-thesis guardrail).

---

## 6. Which Lean proof targets are now ripe?

Ripeness criteria used: (a) finite linear-algebra statement provable with current
Mathlib; (b) Gate-C-independent or only weakly C-dependent; (c) Gate A
(convention) prerequisites either met or cleanly importable; (d) high durable
value (feeds P1/P1.5/P2 spine or anomaly safety).

Assessment of the seven candidates named in the prompt:

| Candidate | Ripe now? | Verdict / condition |
| --- | --- | --- |
| **Finite square** `D_N^2 = K_null + C_diamond + T_frame` (B4) | **Partially** | Algebra is ripe but **must not be promoted to trusted surface until Gate A (A1/A2/A6) settles signs/grading**. Develop experimentally in Draft now; promotion blocked. C-independent. |
| **Branch matrix** (C1/C16 finite nodal-structure theorem) | **Yes, as finite data** | The *finite* determinant/nodal-structure theorem (C16) is ripe and turns the branch table into kernel-checked data. Ripe and high-value *as a data theorem*; the physics *verdict* still belongs to G3. |
| **Internal spectrum** (H1 `NullEdgeInternalSpectrum` API) | **Yes — top ripe** | Pure finite definitional API, C-independent, unblocks H2/H3/H4/H5. Launch first. |
| **EW stabilizer** (S2 / E3) | **Yes** | Finite stabilizer kernel + rank is a clean linear-algebra theorem; S2 already submitted — integrate and promote. C-independent. |
| **FMS composite** (E1 gauge-invariance of finite link composite) | **Conditionally ripe** | Ripe *only after* the FMS audit (S11/E12) fixes the *correct* composite. Do not formalize before S11 returns. C-independent once composite is fixed. |
| **Connection-Laplacian toy theorem** (D14-adjacent / D4 toy) | **Not yet** | Gated by Gate C nonfatal + D2/D13 framework. Defer to the C-conditional track. |
| **Plucker promotion** (B6 `B_Pl` as canonical obstruction; B9 covariance) | **Yes** | P1 is the most mature result; promoting `B_Pl` to the canonical obstruction instance (B6) and adding the SL(2,C) covariance wrapper (B9) are ripe and directly feed the P1 publication. C-independent. |

**Ripe-now Lean shortlist (the five highest-value proof jobs) — see §8.**

The two not-yet-ripe: the connection-Laplacian toy theorem (Gate-C-gated), and
massive-branch/moduli proofs (C4/F4/F9, Gate-C-gated and/or post-P2-data).

---

## 7. Which jobs should be halted until sign/convention and branch classification are complete?

Two hard prerequisites act as halt gates, exactly as the backlog's integration-
freeze rule states ("Gate A must pass before any finite square theorem is
promoted"; "Do not launch heavy D-continuum work until C1/C2 return").

**Halt until Gate A (sign/convention) complete (A1 sign audit, A2 grading
counterexamples, A6 kinetic normalization, A3 conventions doc):**

- B4 finite square decomposition **promotion** (develop in Draft, do not promote).
- B5 mass-shell matching `ker(-K⊗I + I⊗B†B)` (sign of the obstruction block is
  the whole content).
- D10 super-Dirac gradient square (depends on the `+Phi_H^2` vs `-Phi_H^2` trap).
- H5 `FureyPhiHBlock` square-to-mass-block (sign + grading critical).
- B11/B12 EW coefficient and Higgs Hessian theorems (physics-Hermitian
  convention must be frozen first).
- Any I4 promotion of a returned draft to trusted surface (blocked by G1 policy +
  G2 sign dashboard).

**Halt until branch classification (Gate C) complete (C13/C14/C16/C17/C18 + G3
acceptance):**

- All §1 C-conditional D-track theorems (D1 beyond toy, D3, D4, D7, D8).
- C4 massive branch count and F9 full moduli-rank (need the settled operator).
- F10 prediction-gate manuscript (needs a surviving codimension relation).
- C8 Nielsen–Ninomiya assumption audit *conclusions* (the assumption audit can be
  drafted, but its verdict waits on branch evidence).
- E8 physics-audit integration review for P2 (needs the chirality verdict).

**Halt until both A and C complete:**

- Any "unified mass architecture paper" assembly (P2 main manuscript). It must
  remain a skeleton (M5) until the finite core (A) and the branch verdict (C) are
  both settled.

---

## 8. Wave 8 deliverables

### 8.1 Wave 8 launch table (priorities and dependencies)

Two tracks. Track FIN runs now (Gate-C-independent). Track CONT launches only on
a nonfatal Gate-C verdict (§1 acceptance criteria via G3 + C14 + C13 + C18).

**Track FIN — launch now (Gate-C-independent finite + integration):**

| Pri | ID | Type | Job | Depends on | Gate |
| --- | --- | --- | --- | --- | --- |
| 1 | I1 | Audit | Wave 7 returns integration triage | Wave 7 returns | (control) |
| 1 | G2 | Audit | Sign/normalization dashboard | returned drafts | A |
| 1 | A1 | Proof | `superDirac_square_sign_audit` (±Phi_H^2) | conventions | A |
| 2 | A2 | Proof | Grading counterexamples | A1 | A |
| 2 | A6 | Proof | `K_null`/`Box_null`/`K_h` normalization | A1 | A |
| 2 | H1 | Proof | `NullEdgeInternalSpectrum` API | — | H |
| 3 | H2 | Proof | Furey→null-edge one-generation bridge | H1 | H |
| 3 | H3 | Proof | Anomaly inheritance from one-generation | H2, S15 | H |
| 3 | H4 | Proof | Legal Yukawa flip classification | H1 | H |
| 3 | B6 | Proof | `B_Pl` as canonical Plucker obstruction | (P1) | B |
| 4 | B9 | Proof | SL(2,C) covariance wrapper for P1 | B6 | B |
| 4 | E11 | Audit | Quiver spectral-action novelty boundary | S11 | E/F |
| 4 | H11 | Audit | Finite spectral-triple moduli audit | H1 | H/F |
| 5 | C16 | Proof | Finite tetrahedral nodal-structure theorem (data) | C13/C14 | C(data) |
| 5 | B4 | Proof | Finite square decomposition (Draft only) | A1, B1/B3 | B (no promote) |
| 5 | E1 | Proof | FMS finite link composite gauge invariance | S11/E12 | E |
| 6 | G4 | Audit | Null-edge specificity audit per P1.5 theorem | E11 | (manuscript) |
| 6 | M1 | Manuscript | P1 formal claim-boundary/title rewrite | B6, B9 | (pub) |
| 6 | I4 | Proof | Promote one passing draft to trusted surface | G1, G2, A1 | (control) |

**Track CONT — launch only if Gate C nonfatal (continuum + prediction):**

| Pri | ID | Type | Job | Depends on |
| --- | --- | --- | --- | --- |
| pre | D2 | Strategy | Estimate-framework freeze (run during C) | — |
| pre | D6 | Audit | Lichnerowicz comparison/target formula (run during C) | — |
| pre | D15 | Audit | Causal-set d'Alembertian falsification probe (run during C) | L12 |
| 1 | D13 | Strategy | DEC/Hodge-Dirac convergence adaptation | D2, L9, C nonfatal |
| 1 | D1 | Proof | Smooth symbol asymptotic `[D_h,M_f]=c(df)+O(h)` | D2 |
| 2 | D14 | Audit | Connection-Laplacian convergence (gauge/Higgs) | D13 |
| 2 | D7 | Proof | Commuting-square flat scalar limit | D1 |
| 3 | D4 | Proof | Null-diamond holonomy → curvature | D1, D14 |
| 3 | D3 | Proof | Curvature diamond coefficient | D1, D6 |
| 3 | D8 | Proof | Scalar/gauge null kinetic continuum limit | D7, S8 re-audit |
| 4 | D10 | Proof | Super-Dirac square with Phi_H gradient | A1, B4 |
| 4 | C4 | Audit | Massive branch count | C1/C3 |
| 4 | F9/F12 | Prediction | Moduli-rank + quiver parameter count | H11, E11, C, D data |

### 8.2 Kill-switch and downgrade matrix

| Trigger (gate) | Detect via | Kill / halt | Downgrade | Publishable fallback |
| --- | --- | --- | --- | --- |
| Unavoidable physical doubler in branch table | C14 + C17 + G3 | Halt all Track CONT | Redesign retarded operator | **P2b branch/Krein no-go audit paper (M6)** |
| Determinant branch fatal | C1/C3/C4 | Halt D3/D4/D7/D8/D10 | Freeze graph-operator branch | P1 only: finite Plucker theorem |
| Krein growing physical modes | C5/C6 + C7 counterexample | Mark retarded/Krein unstable | Finite algebra only, no dynamics | Finite algebra paper (M5) sans dynamics |
| `J`-self-adjoint ⇏ real spectrum bites | C7 | Drop stability claim | Causal structure only, no stability claim | Same, with explicit caveat |
| Causal-set-style nonlocal convergence failure | D15 | Halt D13/D14 | DEC route abandoned for Lorentzian op | Euclidean-proxy convergence only |
| Sign/grading unresolved | A1/A2 + G2 | Block all promotions (I4) | Keep drafts experimental | none needed (internal) |
| FMS composite not gauge-invariant | S11/E1 | Stop EW physical-excitation claims | Keep rank/stabilizer algebra only | EW stabilizer algebra note |
| Chirality forces vector-like | C9/C18 + H10 | No SM chirality claim | Vector-like toy model only | Vector-like reconstruction note |
| `F` full rank, no relation | F9/F12 + H11/H8 | No prediction claim | Reconstruction not prediction | Unified finite-reconstruction architecture |
| Internal moduli fill EFT | H11 + H8 | No internal prediction | Reconstruction-only internal sector | Anomaly-safe internal fiber note (H3) |
| No finite `B_QCD` | Q2/Q3 | Drop QCD mass claims | QCD as motivation/boundary only | QCD boundary language (Q1) |
| Quiver equivalence with no specific content | E11 + G4 | Drop generic-reconstruction novelty | Restrict novelty to null/Plucker/super-Dirac core | P1 + dual-soldering specificity paper |

### 8.3 Five most valuable Lean proof jobs (ripe now)

Ranked by (durable value × ripeness × independence from C):

1. **A1 — `superDirac_square_sign_audit`** (`NullEdgeSuperDiracSignAudit.lean`).
   Locks the `+Phi_H^2` vs `-Phi_H^2` trap with both sign cases, kernel-clean.
   Unblocks every finite-square and mass-block promotion. Highest leverage.
2. **H1 — `NullEdgeInternalSpectrum` API** (`NullEdgeInternalSpectrum.lean`).
   Reusable finite internal charge/grading/multiplet API, Furey-independent.
   Unblocks H2–H5 and the entire Gate-H internal-fiber track.
3. **H3 — internal anomaly inheritance** (`NullEdgeInternalAnomalyInheritance.lean`),
   built on H2 reusing the trusted `standardModelOneGeneration` anomaly package
   (S15). Converts internal-spectrum matching into local + Witten anomaly freedom
   without rebuilding anomaly arithmetic.
4. **B6 (+B9) — Plucker obstruction promotion** (`PluckerObstruction.lean`,
   `PluckerMassCovariance.lean`). Turns P1 from an identity into the first
   canonical-obstruction instance with a Lorentz-covariance theorem — directly
   enables the P1 publication.
5. **C16 — finite tetrahedral nodal-structure theorem** (`TetrahedralNodalStructure.lean`).
   Converts the branch-classification table into reusable kernel-checked finite
   *data* (distinct from the physics verdict, which stays with G3). De-risks Gate
   C by making the branch count a theorem rather than a script output.

(Honourable mention / promote-after-A: **B4** finite square decomposition —
develop in Draft now, promote only after A1/A2.)

### 8.4 Five most valuable no-build audit/source jobs

1. **I1 — Wave 7 returns integration triage** (`aristotle-wave-integration-triage.md`).
   Prevents incompatible returned assumptions from entering docs/Lean. Must run
   first; everything else builds on a clean integrated baseline.
2. **G3 — branch-count acceptance criteria** (`null-edge-branch-count-acceptance-criteria.md`).
   Defines the Gate-C nonfatal verdict *before* seeing branch data, preventing
   post-hoc reinterpretation. This is the gate that opens/closes Track CONT.
3. **H11 — finite spectral-triple moduli audit** (`null-edge-finite-spectral-triple-moduli-audit.md`).
   Measures the internal free-parameter dimension that any prediction claim must
   beat (Cacic; Bochniak–Sitarz). Decisive for honest reconstruction-vs-prediction
   framing.
4. **E11 — quiver spectral-action novelty boundary** (`null-edge-quiver-spectral-action-comparison.md`).
   Pins exactly what is null-edge-specific vs generic quiver reconstruction
   (van Suijlekom). Protective for the manuscript and adversarial for prediction
   (paired with F12).
5. **D15 — causal-set d'Alembertian falsification probe** (`null-edge-causal-dalembertian-falsification-probe.md`).
   Early, cheap kill-switch input for the continuum track (Boguna–Krioukov);
   must precede committing DEC/connection-Laplacian proof effort.

(Source-pack support to run alongside: **L9** DEC/Hodge-Dirac, **L10** graph
species/flavored chirality, **L11** quiver/Bratteli, **L12** causal-set.)

### 8.5 Publication-sequence recommendation

**Recommended order: P1 → P1.5 → (branch/Krein audit paper as the standing hedge);
P2 finite algebra and the unified mass architecture paper held back.**

| Slot | Paper | Status | Gate prerequisites | Why this order |
| --- | --- | --- | --- | --- |
| **P1** | Finite kinematic Plucker theorem (massless iff collinear) | **Ship first** | B6, B9, M1, G4 (specificity); A conventions for sign/normalization appendix | Most mature, fully finite, C-independent, novelty defensible against twistor/spinor-helicity prior art (L1) and quiver reconstruction (E11). Lowest risk, highest certainty. |
| **P1.5** | Finite quadratic-obstruction reconstruction (Yukawa + EW stabilizer + Abelian Higgs + scalar kinetic) | **Second** | A complete; S1/S2/S3 integrated; B16/M4 note; E1 only if FMS audit fixes composite; G4 | Bundles the strongest finite bridge theorems. Honest "reconstruction" framing avoids prediction overclaim. Needs Gate A but not Gate C/D. |
| **Hedge** | **Branch/Krein audit paper (M6)** | **Held ready, ship if Gate C fatal** | C1–C18, C5/C7, G3 | This is the *insurance* publication: a fatal Gate C verdict becomes a publishable no-go/branch-count result rather than a dead end. Keep it skeleton-ready at all times. |
| Later | P2 finite super-Dirac algebra (M5) | Skeleton only | Gate A **and** Gate C nonfatal | The finite operator core is publishable before prediction, but only once signs (A) and branches (C) are settled. |
| Last | Unified mass architecture paper | Manuscript skeleton only | Gate A + C + D + F (moduli rank) | Most ambitious, most exposed. Do not assemble until prediction-vs-reconstruction is honestly resolved (H11/F9/F12). If `F` is full rank, this becomes the "unified finite *reconstruction* architecture" paper, not a prediction paper. |

Decision rule between the ambitious route and the safe route:

> Default to **P1 now, P1.5 next**. Promote P2/unified only when *both* Gate A and
> Gate C clear. If Gate C is fatal, immediately pivot the unified-paper effort
> into the **branch/Krein audit paper (M6)** — a fatal branch result is itself a
> publishable contribution, which is why M6 is the correct hedge rather than the
> unified architecture paper.

---

## 9. One-paragraph standing instruction for Wave 8 execution

Run Track FIN immediately (integration triage I1, sign gate A1/A2/A6, internal-
spectrum API and anomaly bridge H1/H2/H3/H4, Plucker promotion B6/B9, the
novelty/moduli audits E11/H11, and the branch *data* theorem C16), and run the
continuum *preparation* (D2/D6/D15/L9) concurrently with Gate C so conventions
are frozen by the time the C verdict lands. Hold every continuum *theorem*
(D1+/D3/D4/D7/D8/D10) and every prediction job (C4/F9/F12) behind a nonfatal
Gate-C verdict defined by G3+C14+C13+C18. Promote nothing to the trusted surface
until Gate A passes (G1 policy, G2 dashboard). Ship P1 first, P1.5 second, and
keep the branch/Krein audit paper (M6) skeleton-ready as the hedge against a
fatal Gate C.
