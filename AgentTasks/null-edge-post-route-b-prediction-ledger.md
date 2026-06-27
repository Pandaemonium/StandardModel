# F16: Post–Route-B prediction ledger (strategy/audit, report-only)

**Type:** strategy/audit for Gate F, after the Route B species-splitting verdict.
**Mode:** no Lean changes. This audit only reads and classifies already-formalized
results. The cited modules build standalone (`import Mathlib`); nothing here adds
axioms or `sorry`s.

**Adversarial stance.** The default verdict for every line below is
*reconstruction until a rank/codimension/forcing mechanism is exhibited in Lean*.
"Looks like a prediction" is not a status. A status is a named theorem whose
conclusion is a `rank(dF) < dim M_EFT` deficit, a strict codimension, or a
discrete forcing with the falsifier identified.

## 0. Scope and provenance

Inputs read for this audit:

- `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean` (C45/C46)
- `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean` (F13 codimension)
- `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` (anomaly inheritance)
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean` (C19 conditional release / forcing)
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` (§20.9, §25.6, §26.2 — Gate C/F)
- `AgentTasks/null-edge-f15-genuine-prediction-candidate-ledger.md` (F15 verdict)
- `AgentTasks/null-edge-weber-flavored-qcd-splitting-audit.md` (C45/C46 verdict)

**Missing input.** `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` (the C47
"projected Gate C release" module) is **not present** in the project tree; no
file under `PhysicsSM/Draft/` matches `Projected`. Every claim below about the
projector route is therefore conditioned on the *criterion* file
`NullEdgeGateCReleaseCriterion.lean` that is present, plus §26.3 of the plan, and
is flagged `UNAVAILABLE-SOURCE` where it would otherwise depend on C47. No status
is upgraded on the strength of a file I could not read.

**Job-ID key (as used in the task prompt; only C45/C46 ship a file I could read):**

- C19 — operator-forced Gate C release criterion → `NullEdgeGateCReleaseCriterion.lean`.
- C21 — Gate C release as reconstruction/safety (verdict reported upstream; treated as input).
- C43 — Route B splitting verdict feeding C45 (treated as input).
- C45/C46 — Weber flavored-QCD no-fine-tuning audit → `NullEdgeSymmetryForcedSpeciesSplit.lean`.
- C47 — projected Gate C release → `UNAVAILABLE-SOURCE` (file absent).
- K2 — kinematic/“keystone” reconstruction input (treated as input).

If C21/C43/C47/K2 ship standalone report files later, re-run this ledger against
them; the verdicts here are stated so that recovering those files can only *add*
demotions, not silently upgrade a status.

## 1. Updated prediction ledger

Status vocabulary (unchanged from F15, sharpened):

- **PRED** — a formalized `rank(dF) < dim M_EFT` deficit / strict codimension /
  discrete forcing. *No row currently holds this.*
- **PRED-COND** — would be PRED if one named, falsifiable Lean obligation is
  discharged. The obligation is stated, not assumed.
- **RECON** — reconstruction: reproduces an SM datum that was put in (gauge group,
  reps, hypercharges, generation count, texture bookkeeping). Full-rank as written.
- **CONSIST** — internal consistency / inheritance / rigidity. Constrains a
  *bare-symmetry* choice but adds or removes no net EFT coordinate.
- **DEMOTED / DEAD** — previously floated as a prediction, now reclassified.

| # | Object | Lean locus | Status | Why (adversarial) |
|---|--------|------------|--------|-------------------|
| 1 | Forbidden diagonal-mass counterterm | `forbidden_counterterm_codimension`, `ambient_eq_admissible_add_codimension`, `admissible_odd_finrank` | **CONSIST→PRED-COND** | A genuine, kernel-checked codimension `(card L)²+(card R)²` of the *finite* operator space. It is a strict subspace, not full-rank. But it is a constraint on the **finite Dirac block**, not yet a forbidden direction in `M_EFT`. PRED only once the cut operator is shown to forbid an EFT Wilson/Pauli coefficient (the `R(θ)=0` step). |
| 2 | Operator-forced branch chirality / flavored index | `gateC_conditional_release`, `aligned_signs_forced`, `antialigned_signs_forced`, `flavoredOp_index_le_four` | **PRED-COND** | Among `±1` branch signs the maximal release index `±4` forces `s = ±g5` — a real *discrete* forcing, and a magnitude bound `≤4`. But it is gated entirely on `OperatorForcesAlignment branchChirality := (branchChirality = g5)`, which is **posited, not derived**. Until the flat tetrahedral symbol is shown to assign `g5 a` to the branch-`a` zero mode, this is conditional. This is the single highest-value PRED-COND target (= F15 Rank 1). |
| 3 | Anomaly inheritance / anomaly-selected hypercharge | `localAnomalyFree_of_realizesOneGeneration`, `anomalyFree_of_realizesOneGeneration`, `wittenAnomalyFree_of_realizesOneGeneration` | **CONSIST (inheritance) / PRED-COND (selection)** | What is proved is *inheritance*: assume `RealizesOneGeneration`, conclude anomaly-free. That is RECON/CONSIST — the SM hypercharges were assumed. A prediction needs the converse-style **selection** theorem: anomaly-freedom forces the hypercharge line (a `R(θ)=0` codimension), with the discrete solution set enumerated. Not formalized. |
| 4 | Route B species-splitting *magnitude* `r` (`M_split = r·T`) | `weber_best_case_still_a_modulus`, `coeff_modulus_injective`, `coeff_range_full`, `c45_c46_audit_summary` | **DEAD as magnitude prediction** | `r ↦ r·g5` is injective with full range ℝ. Even granting the best-case direction-forcing, `r` is a free real modulus: it adds a coordinate to `M_finite` that maps to an independent EFT direction, so it can *never* contribute to a rank deficit. Demoted permanently. See §3. |
| 5 | Route B *direction* / `2+2` partition | `direction_forced_scale_free`, `partitions_in_one_S4_orbit('​)`, `g5_not_S4_invariant`, `invariant_iff_const` | **CONSIST (texture-shape only), not PRED** | Tracelessness + a chosen partition forces `s = (s 0)·g5` (direction fixed, scale free). But `S₄` does **not** pick the partition: the three `2+2` patterns lie in one `S₄` orbit and `g5` is non-constant hence non-invariant. The partition is a non-canonical discrete (`Z₃`) modulus until an external selector is exhibited. At best a *forced-texture* candidate (same admissible category as #1), never a magnitude. |
| 6 | Generation / flavor count (`nCopies n`, `nGenerations_localAnomalyFree`) | `NullEdgeInternalSpectrum` | **RECON** | `n` is a free input; `n` copies of an anomaly-free generation are anomaly-free for every `n`. No mechanism selects `n=3`. Full-rank reparametrization. |
| 7 | Flavored index "4" as a standalone number | `aligned_index_eq_four`, `flavoredOp_index` | **DEMOTED** | `4` is the branch count `card{high-momentum null branches}=4` re-expressed; it is fixed by the `{0,π}⁴` corner combinatorics that were built in, not a prediction. It is meaningful only *relative to* the forcing (#2): `tr=4 ⇔ s=g5`. Standalone, it is bookkeeping. |
| 8 | Furey-style realization, EW "one photon" stabilizer rank, Lichnerowicz/quadrature | `fureyStyleRealization_*`; plan §16.8, §15.7 | **RECON** | Existence/reconstruction of a known SM datum. Full-rank; no codimension claimed. |

**One-line state of the gate.** As of F16, **no row is PRED**. The map
`F : M_finite → M_EFT` remains full-rank on the EFT-relevant sector as formalized,
exactly as F15 found and §25.6 warns. Two rows (#1, #2) and two weaker rows
(#3 selection, #5 texture) are **PRED-COND** with explicitly named falsifiable
obligations. Route B's coefficient (#4) is now **DEAD** as a prediction.

## 2. Prediction routes still alive (PRED-COND)

A route is "alive" only if (a) its target modulus is *designed to be
operator-determined* (not a convention or a free input), and (b) the missing
step is a single falsifiable Lean obligation, not an open research program.

### Alive — Route R1: operator-forced branch chirality / flavored-index rigidity
- **Mechanism:** discrete forcing. `aligned_signs_forced` already proves
  `tr(Γ_flavOp s · P_null)=4 ⇔ s=g5` over `±1` signs, with `|tr|≤4`
  (`flavoredOp_index_le_four`). The chirality texture is rigid *given* the
  branch-chirality eigenvalues.
- **Single obligation:** prove `OperatorForcesAlignment` for the actual flat
  tetrahedral null-edge Clifford symbol, i.e. that the zero mode on branch `a`
  carries spacetime-chirality eigenvalue `g5 a`. Currently `def
  OperatorForcesAlignment bc := (bc = g5)` is a posited hypothesis fed to
  `gateC_conditional_release`.
- **Falsifier (must be checked, per plan §26.3):** the determinant-zero set is
  *not* a finite isolated branch set (extended nodal surfaces / null cones /
  complex sheets), or the symbol assigns a chirality pattern not in the `±g5`
  orbit, or yields a higher-dimensional / Krein-negative branch kernel. Any of
  these kills R1 and triggers redesign rather than a prediction.
- **Verdict:** **highest-value live route.** Status PRED-COND.

### Alive — Route R2: anomaly-selected hypercharge / internal legality
- **Mechanism:** linear codimension. A clean `R(θ)=0` on the five anomaly
  coefficients (`gravitationalU1Anomaly`, `u1CubedAnomaly`, `su2SquaredU1Anomaly`,
  `su3SquaredU1Anomaly`, `su3CubedAnomaly`) restricting the hypercharge
  assignment to a discrete solution set.
- **Single obligation:** state and prove the *selection* theorem (anomaly-freedom
  ⇒ hypercharge line), with the discrete solutions enumerated. The current file
  only proves the *inheritance* direction, which is RECON.
- **Falsifier:** the anomaly variety is positive-dimensional after fixing the
  reps the model actually builds (then no codimension), or admits exotic
  solutions the model cannot exclude.
- **Verdict:** live, second priority. Status PRED-COND.

### Alive — Route R3: forbidden-counterterm codimension promoted to `M_EFT`
- **Mechanism:** codimension. `forbidden_counterterm_codimension` is a real
  strict-subspace result on the finite block. To become a Gate-F prediction it
  must forbid a *physical EFT* operator (a Pauli/irrelevant Wilson coefficient or
  a bare diagonal mass term) — i.e. show the forbidden finite direction maps to a
  forbidden EFT direction (`R(θ)=0`).
- **Single obligation:** the boundary lemma `finite-forbidden ⇒ EFT-forbidden`
  (which EFT coefficient is killed, and that the spectral-action map respects the
  oddness grading).
- **Falsifier:** the spectral-action / cutoff layer re-generates the forbidden
  operator (then the cut is undone downstream — exactly the §25.6 free-Pauli
  hazard). Status PRED-COND, contingent on the EFT-layer being non-trivial.

### Alive (texture-only) — Route R4: structural forced texture after choosing a projector
- **Mechanism:** forced texture (shape, never magnitude). Once a branch
  projector / `2+2` partition is *selected by an external operator argument*,
  `direction_forced_scale_free` fixes the direction `s=(s 0)·g5`.
- **Single obligation:** exhibit a canonical pairing-selecting symmetry of the
  tetrahedral operator (a C/reflection + preferred-covector selector) that picks
  one of the three `Z₃` partitions. C45/C46 prove the *bare* `S₄` does **not** do
  this (`partitions_in_one_S4_orbit`), and the existing tree's
  Krein-vs-chirality mismatch (`kreinSig_ne_chirality`, cited in the C45/C46
  report) is direct evidence *against* a naive selector.
- **Ceiling:** even in best case this yields a forbidden-counterterm/forced-shape
  prediction in the same category as R1/R3 — **never** a value of `r`.
- **Verdict:** alive but weakest; PRED-COND with an external-selector obligation
  that is currently unmet.

### Considered and NOT alive
- **Generation/flavor count constraint:** `nCopies n` free; no selector for `n=3`.
  Not a route (RECON).
- **Coupling-relation / numerical-mass codimension:** explicitly postponed by
  §25.6/§25.7 as too sensitive to spectral-action, threshold, cutoff and
  extra-field assumptions to be a first target. Not invented here.
- **Projected Gate C release (C47):** `UNAVAILABLE-SOURCE`. Cannot be scored.
  If recovered, it can at most strengthen R1/R4 (a projector that selects a
  branch), not create a magnitude prediction.

## 3. Dead or demoted (explicit)

1. **Bare branch-chirality *forcing* — DEMOTED to PRED-COND, not a standalone
   prediction.** The *bare* tetrahedral symmetry forces nothing: `S₄`-invariant
   sign vectors are exactly the constants (`invariant_iff_const`), and `g5` is
   non-constant (`g5_not_S4_invariant`). Branch chirality is forced *only*
   conditionally, via the posited `OperatorForcesAlignment` (Route R1). Any claim
   that chirality is forced "by the symmetry" with no operator input is **dead**.

2. **Species-splitting *magnitude* prediction from `r` — DEAD.** `coeff_range_full`
   /`coeff_modulus_injective` prove `r ↦ r·g5` is injective with full range ℝ;
   `weber_best_case_still_a_modulus` proves that even with the direction forced the
   admissible family is the whole line `{r·g5}`. Weber's arXiv:1611.08388
   mechanism is *technical naturalness* (it forbids competing taste-breaking
   counterterms), **not** a coefficient-fixing result: "no fine-tuning" ≠
   "symmetry-forced coefficient". A free `r` adds an independent EFT coordinate and
   so cannot contribute to `rank(dF) < dim M_EFT`. This prediction is dead and
   should not be resurrected without a genuinely new magnitude-fixing theorem.

3. **Flavored index "4" as a standalone prediction — DEMOTED.** The `4` is the
   built-in count of high-momentum null branches (`{0,π}⁴` corners with exactly
   three `π` edges), re-expressed via `flavoredOp_index`/`aligned_index_eq_four`.
   It is reconstruction of an input combinatorial fact. It carries predictive
   content *only* bundled with the forcing `tr=4 ⇔ s=g5` (Route R1), never alone.

4. **"Gate C solved / no-doubling solved" language — DEAD** (per plan §26.2). The
   safe statement remains: retardedness removes naive coefficient-vector
   doublers; determinant-level Lorentzian branches remain an open audit. Gate C
   release is **reconstruction/safety**, not a coefficient-level prediction (the
   C21/C43 verdict this ledger records).

## 4. Manuscript-safe language for P2 / P3

Two rules. **(i)** Never use "predict(s)/prediction" for any object in §1 that is
not status PRED — and no object is currently PRED. **(ii)** Every reconstruction
sentence must name what was *assumed* (gauge group, reps, hypercharges,
generation count) so a referee cannot read it as a derivation.

### P2 (finite super-Dirac operator) — RECONSTRUCTION
Safe:
> "The finite super-Dirac construction **reconstructs** the Standard-Model chiral
> Yukawa block: the chirality grading **forbids** diagonal (chirality-preserving)
> mass counterterms, cutting the finite operator space by the proven codimension
> `(card L)²+(card R)²` and leaving exactly the off-diagonal Yukawa parameters
> (`forbidden_counterterm_codimension`, `ambient_eq_admissible_add_codimension`).
> The gauge group, representations and hypercharges are **inputs**; anomaly
> freedom is **inherited**, not derived (`anomalyFree_of_realizesOneGeneration`)."

Forbidden in P2: "predicts the Yukawa texture", "predicts anomaly cancellation",
"predicts no diagonal mass" without the words *finite operator space* and without
flagging that the EFT-level forbiddenness (Route R3) is **not yet proved**.

### P3 (predictive constraints) — STRUCTURAL, CONDITIONAL
Safe:
> "The program's first candidate **structural** constraints are *conditional*. (a)
> A discrete forcing of the flavored-chirality texture: any maximal Gate-C release
> over `±1` branch signs requires `s=±g5` (`aligned_signs_forced`,
> `antialigned_signs_forced`), with index bounded `|tr|≤4`
> (`flavoredOp_index_le_four`). This becomes a prediction **only if** the actual
> flat tetrahedral symbol is shown to assign branch chirality `g5`
> (`OperatorForcesAlignment`), an obligation we state but do not discharge. (b) An
> anomaly-selected hypercharge codimension, currently proved only in the
> inheritance direction. We make **no numerical mass prediction** and **no
> prediction of the species-splitting coefficient `r`, which is a free modulus**
> (`weber_best_case_still_a_modulus`)."

Forbidden in P3: any sentence asserting a fixed value of `r`, a fixed generation
number, or a numerical mass/coupling; any "the symmetry forces…" without naming
the operator obligation; the word "prediction" attached to inheritance or to the
flavored index taken alone.

### Reconstruction-vs-prediction boundary sentence (drop-in)
> "Throughout we distinguish **reconstruction** — reproducing Standard-Model
> structure that enters as input (gauge group, representations, hypercharges,
> generation count, Yukawa bookkeeping) — from **prediction**, which we reserve
> for a proved reduction `rank(dF) < dim M_EFT`, a strict forbidden-operator
> codimension in `M_EFT`, or a discrete forcing with its falsifier identified. By
> this standard the present results are reconstruction and consistency; the
> structural prediction candidates are explicitly conditional on the named,
> falsifiable operator obligations above."

## 5. Adversarial bottom line

- No formalized object is a Gate-F prediction. `F` is full-rank on the
  EFT-relevant sector as written (F15 verdict, unchanged).
- Route B closes Gate C only as **reconstruction/safety** (C21/C43), never as a
  coefficient-level prediction: the coefficient `r` is a proven free modulus
  (C45/C46), so its magnitude is **dead** as a prediction.
- Exactly four conditional routes survive, in priority order: **R1**
  operator-forced chirality texture (discrete forcing; needs
  `OperatorForcesAlignment` + the §26.3 branch-geometry falsifier check), **R2**
  anomaly-selected hypercharge (linear codimension; needs the selection
  direction), **R3** forbidden-counterterm codimension promoted to `M_EFT` (needs
  the finite⇒EFT boundary lemma against the free-Pauli hazard), and **R4**
  external-selector forced texture (shape only; needs a canonical partition
  selector the bare `S₄` provably does not supply).
- All four are forbidden-operator / codimension / rank-deficit / discrete-forcing
  mechanisms. **None** is a magnitude. No prediction was invented in this ledger;
  the only honest "prediction" language is conditional and names its falsifier.
- Caveat: C47 (`NullEdgeProjectedGateCRelease.lean`) was not in the tree and could
  not be scored; recovering it can at most strengthen R1/R4, not revive `r`.

## Convergence note (2026-06-27 lateral analysis)

A lateral read of the program independently concluded that the first
prediction-grade output should be a forbidden-operator / absence theorem rather
than a mass magnitude, which matches this ledger's standing verdict (all of
R1-R4 are forbidden-operator / codimension / rank-deficit / discrete-forcing
mechanisms; none is a magnitude). No new prediction is added here. The only
adjustment is emphasis: prioritize R3 (forbidden-counterterm codimension to
`M_EFT`) and the Gate H `LegalFiniteDiracForbiddenOperator` absence theorem as
the near-term publication-safe structural targets, ahead of any spectrum claim.
