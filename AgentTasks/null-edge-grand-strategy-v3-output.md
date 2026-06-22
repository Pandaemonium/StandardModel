# Null-edge grand strategy v3 — Aristotle roadmap output

Date: 2026-06-22
Mode: strategy / scaffold only. No repository build was performed (per the
prompt's "do not build the whole repository" instruction). The standalone
scaffolds and trusted anchors were read directly. Where this note says a
declaration is "checked", it means it is reported checked by the cycle that
produced it **and** the active (non-commented) Lean in the scaffold is visibly
free of `s o r r y`; it was **not** re-run through a kernel build in this strategy
pass. No new kernel-proof claim is made here.

This document answers the eight deliverables of the v3 prompt:

1. the 10 highest-value next theorem targets, ranked by scientific leverage;
2. proof-ready-now vs definition-risky;
3. standalone focused packages vs full-repo packages;
4. which standalone artifacts to promote into trusted `PhysicsSM` first, in order;
5. a six-cycle autonomous run plan (one job per cycle, expected outputs);
6. accompanying manuscript work (P1, P3, P7, P9);
7. tempting claims to keep avoiding;
8. an audit of whether P9 is now stronger, weaker, or just cleaner.

---

## 0. What materially changed since grand-strategy v2

The overnight P9 and relative-entropy work moved three of v2's "open" clusters
to **banked-at-standalone-scaffold level**. This changes the frontier.

* **Cluster A (spinor-network closure / moment-map identity) — the *angular*
  half is done standalone.** `LeanContext/SpinorNetworkClosure/Finite.lean`
  proves `pluckerMass_eq_energy_sq_sub_closureDefect_sq`
  (`pairwiseAngularMass = (E² − |C|²)/4`) and `closed_spinorFan_is_restFrame`.
  What is *still open* is the bridge tying this real angular functional to the
  **trusted complex determinant** `Spinor.PluckerMass.finPairwisePluckerMassReal`
  via the Bloch map. That bridge is now the single most valuable A-job (T1 below).

* **Cluster G (P9 source visibility) — definitions + Layer-1 lemmas done
  standalone.** `LeanContext/P9/NullEdgeDiamondSourceVisibilityRoadmap.lean`
  checks `boundaryExact_implies_bfClosed` (finite `d∘d=0` via
  `Finset.sum_involution`), `bfClosed_source_zero`, `boundaryExact_source_eq_zero`,
  `closureDefect_glue` (defect is additive under disjoint gluing),
  `diamondSource_additive_iff_orthogonal` (the correct replacement for the
  rejected squared-source additivity), `visibleMass_four_mul_identity`,
  `closed_visibleFan_mass_eq_restEnergy`, the flagship separation
  `visibleClosure_not_sourceInvisibility_counterexample` (antipodal toy), and
  `visiblePluckerMass_sources_bulkTerm`. Only Layer-2 (observer/recoverability)
  remains, and it is a *commented* design block, not active code.

* **P7 / relative entropy — the classical finite spine is done standalone.**
  `LeanContext/RelativeEntropy/NullEdgeRelativeEntropyObserverRoadmap.lean`
  checks `FinDist`, `FinObs` (column-stochastic), `applyObs`/`pushforward`,
  `FinObs.comp`, `klDiv`, `klDiv_self`, `klDiv_nonneg` (Gibbs),
  `klDiv_eq_zero_iff`, `klDiv_dataProcessing` (DPI — headline; not in Mathlib),
  `observerLoss_nonneg`, and `observerLoss_zero_of_exactRecovery` (finite exact
  Petz). The `recoverabilityGap` is defined.

* **Cluster B (celestial channel) — the *scalar isotropic* sub-case is done.**
  `LeanContext/CelestialScalarChannel/Finite.lean` proves
  `scalarChannel_massRatioSq_mono_of_contraction`. The full affine-Bloch /
  SO(3) / unital-contraction class (v2's B) is still open (T8).

Net: A (angular), G-Layer-1, and P7-classical are banked as **standalone
artifacts not yet promoted to trusted `PhysicsSM` modules**. The highest-value
work is now (i) the few *bridge* theorems that connect these islands to the
trusted complex `PluckerMass` and concurrence anchors, and (ii) **promotion** of
the clean islands into trusted modules with de-duplicated definitions.

---

## 1. Ten highest-value next theorem targets (ranked by scientific leverage)

Ranking criterion (unchanged from v2): (decisive finite theorem) × (low
convention risk) × (unlocks downstream / reuses banked anchors) ÷ (new
definitions required). A *bridge that unifies two banked islands* outranks a
fresh restatement.

| # | Target | One-line content | Cluster | Why it leads |
|---|---|---|---|---|
| **T1** | `pluckerMass_eq_energy_sq_sub_closureDefect_sq_bundle` + `hermitian_det_eq_energy_sq_sub_bloch_sq` | trusted complex det mass `= ¼(E² − |C|²)` with `E = Σ|ψ_i|²`, `C = Σ blochVector(ψ_iψ_i†)` | A | unifies the trusted determinant theorem with the banked angular identity; the headline equation for P1 §4 and the shared prerequisite for both physics branches (G and C-via-closure) |
| **T2** | `visibleMixedness_eq_concurrenceSq` + `visibleMixedness_monotone_under_classical_observer` | `4 det ρ_vis` is the eigenvalue-distribution mixedness, monotone under a *unital* classical observer channel | P7 | turns the banked KL/DPI spine into actual program content; the single decisive finite theorem P7 needs |
| **T3** | `recoverabilityGap_pos_of_irreversible_merge` (+ gap `=0` for a reversible embedding) | a concrete 2→1 merge with explicit non-recovering `R` has `recoverabilityGap > 0`; a reversible embedding has gap `= 0` | P7/P9 | a *checked witness* that the exact-recovery story is non-vacuous, before any continuum recoverability claim; very cheap, very high credibility |
| **T4** | `twoEdge_mass_eq_klein_simplicityDefect` + `decomposable_is_simple` + `massless_iff_repeated_principal_spinor` | pairwise null-edge masslessness `=` single-bivector simplicity defect `B∧B=0` on the Klein quadric | C | gives the bivector/Grassmannian slogan a checked finite core; mostly composition of banked `PluckerMass` lemmas |
| **T5** | `properTimeRate_eq_two_sqrt_det_visibleDensity` + `properTimeRate_eq_concurrence` | `m/E = 2√det ρ_vis = concurrence` under exact trace-1 normalization | E | completes the physics-facing proper-time wrapper over the banked reduced-density det layer |
| **T6** | `relativeEntropyDataProcessing_for_diamondObserver` (+ `Screen`→`FinObs.ofFun` bridge, `sjDiamondReferenceState`) | the P9 screen coarse-graining is a `FinObs`; DPI is a one-line instance | P9×P7 | connects the P9 source API to the KL spine; the finite ANEC/QNEC-analogue positivity guardrail (advertise as analogue only) |
| **T7** | `fakeFlat_vertical_compose` + decide `fakeFlat_interchange` (prove **or** bank the obstruction) | crossed-module / 2-group surface transport over the proved `pathPairDefect_interchange` | D | builds the 2-group layer the interchange law licenses; pure group algebra; extends P3 |
| **T8** | `unitary_channel_preserves_massRatio` + `unital_contraction_massRatio_monotone` | full affine-Bloch class: SO(3) preserves `m/E`; unital contraction does not decrease it | B | generalizes the banked scalar-isotropic channel to the whole contraction class; sharpens the l=1 relaxation story |
| **T9** | `closureDefect_glueFamily` (additive over a `Finset` of screens) + `diamondSource_orthogonalFamily_additive` | the BF Gauss-law defect is additive over a refinement family; squared source adds only under pairwise orthogonality | G | the abelian coarse-graining backbone P9 needs; low-risk extension of the proved `closureDefect_glue` |
| **T10** | `superDirac_sq_eq_laplacian_plus_curvature_plus_higgs` (assembly) | `D_{U,Φ}² =` graph Laplacian + diamond curvature + Higgs/Yukawa + visible Plücker block on one finite order complex | F | the program's "master criterion" operator and true falsification test — but gated on the Cluster-H convention freeze |

Tranche structure:

* **First tranche (do now): T1, T2, T3, T4.** Each is a single decisive finite
  theorem resting on banked anchors with bounded convention risk; T1 and T2 are
  the two that change a publication's headline.
* **Second tranche: T5, T8, T9.** Physics-facing completions over banked layers.
* **Gated / definition-first: T6, T7, T10.** Each needs a definition pass or a
  convention freeze before the proof job is honest.

---

## 2. Proof-ready now vs definition-risky

**Proof-ready now** (all required definitions exist in a banked scaffold or
trusted module; the subagent can be handed the statement directly):

* **T1** — needs only `blochVector`/`hermTrace` defs (4 lines) over trusted
  `PluckerMass`; the math is `Matrix.det_fin_two` + Hermiticity of
  `finBundleMomentum`. The angular target it lands on is *already proved*
  standalone, so T1 is purely the complex↔real reconciliation.
* **T2** — banked `klDiv_dataProcessing` + banked `concurrenceSqComplex = 4 det`;
  the only new defs are `eigDist`, `visibleMixedness`, `IsUnital`.
* **T3** — needs only the proved relative-entropy API + `decide`/`norm_num` on a
  fixed 2→1 channel.
* **T4** — thin composition of banked `two_edge_mass_zero_iff_wedge_zero`,
  `spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero`,
  `two_edge_plucker_mass_identity`; `decomposable_is_simple` is one `ring`.
* **T5** — real-`sqrt` algebra over banked
  `normalizedVisibleDensity_det_eq_plucker_over_trace_sq` and the concurrence
  wrapper (thread `trace > 0`, Hermitian/PSD hypotheses explicitly).
* **T8** — `Matrix.orthogonalGroup` inner-product preservation +
  `Real.sqrt_le_sqrt`; the scalar case is a banked template.
* **T9** — `Finset.sum_biUnion` / induction over the proved `closureDefect_glue`.

**Definition-risky** (require a definition-design pass *before* any proof job;
submitting a proof job now would bank a vacuous or mis-typed statement):

* **T6** — needs `Microstate`, the `Screen → FinObs.ofFun` reduction, and
  `sjDiamondReferenceState : FinDist` (define as a finite distribution **only**;
  do **not** attach an area law). The DPI itself is then free.
* **T7** — needs a local `CrossedModule` (verify Mathlib lacks one;
  `lean_local_search` for `CrossedModule`/2-group first) and, critically, the
  genuine open question is whether the *surface-label* interchange holds, not
  just the boundary defect. Prove it or **bank the obstruction**; do not weaken
  to `True`.
* **T10** — needs a concrete finite order complex, a transport-twisted `d_U`,
  its adjoint `δ_U`, and the chiral grading, all on one state space. Must wait
  for the Cluster-H convention freeze (§4) or the assembly will be re-typed.

---

## 3. Standalone focused packages vs full-repo packages

**Standalone focused (import one trusted module or one Mathlib-only scaffold):**

* **T1** — import `PhysicsSM.Spinor.PluckerMass` only.
* **T3** — import the relative-entropy scaffold only (Mathlib-only).
* **T4** — import `PhysicsSM.Spinor.PluckerMass` only.
* **T8** — import the celestial-channel scaffold only (Mathlib-only).
* **T9** — import the P9 source-visibility scaffold only (Mathlib-only).
* **T2** — standalone, but it spans two islands (concurrence + KL spine). Best
  shipped as a single self-contained file that inlines the two banked anchors it
  needs, then reconciled at promotion. Mathlib-only.
* **T5** — standalone over the mixedness + concurrence drafts.

**Full-repo (need several `PhysicsSM.Draft` imports; keep them focused assembly
jobs with the block lemmas named):**

* **T6** — needs the P9 API + the relative-entropy spine + the screen reduction;
  once those are promoted (so it imports trusted modules, not scaffolds) it
  becomes a one-line DPI instance.
* **T7** — needs `Gauge.CausalDiamondHolonomy` + `NullEdgePathPairInterchange`.
* **T10** — needs `SuperDiracBlockCore`, `SuperconnectionExpansion`,
  `CovariantDifferential`, `TopologicalDiracBianconi`, `OrderComplexCochain`,
  `BundleDiracPlucker`.

Rule carried from the loop plan: **do not submit a full-repo job until its
trusted dependencies are promoted** (otherwise it imports unstable scaffolds and
will be re-typed). This is why T6/T10 sit behind the promotion order in §4.

---

## 4. Promotion order: standalone artifacts → trusted `PhysicsSM` modules

The loop ledger marks `spinor-network-closure`, `celestial-channel`,
`diamond-source-core`, and the relative-entropy spine as **integrated as
standalone artifacts but not yet promoted**. Promote in this order; the order is
chosen so each promotion is a dependency of the next and so the duplicated
`Vec3`/`dot`/`normSq`/`CSpinor`/`blochVector` definitions are consolidated once
rather than five times.

1. **`PhysicsSM.Spinor.CelestialClosure`** ← `SpinorNetworkClosure/Finite.lean`.
   First, because it is the cleanest banked island, central to P1, and the
   re-export prerequisite for the P9 guardrail
   (`closed_visibleFan_mass_eq_restEnergy`). Promote the *real angular* identity
   as-is; do not inline a second copy in P9.

2. **`PhysicsSM.Info.RelativeEntropy`** ← the relative-entropy scaffold.
   Second, because it is **Mathlib-only with zero `PhysicsSM` dependencies**
   (lowest promotion risk) and is shared by both P7 and P9. Promoting it early
   lets T2/T3/T6 import a trusted surface instead of a scaffold.

3. **The T1 bridge into `PhysicsSM.Spinor.PluckerMass`** (or a new
   `PhysicsSM.Spinor.CelestialMomentMap`). After T1 lands, promote it so the
   trusted determinant theorem itself carries the moment-map form
   `m² = ¼(E² − |C|²)`. This is the promotion that most upgrades P1.

4. **`PhysicsSM.Spinor.CelestialChannel`** ← `CelestialScalarChannel/Finite.lean`
   (small; the scalar-isotropic monotonicity). Promote after T8 generalizes it,
   or promote the scalar case now and extend in place.

5. **`PhysicsSM.Gauge.DiamondSourceVisibility`** ← P9 Layer-1, **last among the
   Layer-1 promotions and only after a Cluster-H mini-consolidation**, because
   the scaffold currently *re-defines* `Vec3`/`dot`/`VisibleFanOnScreen` that
   should be **re-exports** of module 1. Promote it re-exporting
   `CelestialClosure`, not duplicating it. Keep the toy `Bivector := Fin 3 → ℝ`
   carrier explicitly labelled "toy `su(2)_L` stand-in, no linear-simplicity
   sector".

**Do not promote yet:** anything in P9 Layer-2/3 (observer/recoverability,
ANEC/QNEC-analogue) — those stay scaffold until T6's definition pass lands; the
SJ reference state (pre-area-law); and any Cluster-F assembly (gated on H).

A **Cluster-H mini-pass** (design only, no retypes) should precede promotion 5:
fix one canonical home for `Vec3`/`dot`/`normSq3`/`blochVector`/`CSpinor` so the
five islands stop duplicating them. Scope it narrowly to the structures with no
trusted home (`Screen`, `Bivector`, `FinObs`); treat the spinor/Bloch names as a
documented re-export proposal, not a forced rewrite.

---

## 5. Six-cycle autonomous run plan (one job per cycle)

Keep two-to-four active jobs max; the "one job per cycle" below is the *headline*
proof/design job each cycle, with its integration and manuscript follow-through.

### Cycle 1 — T1 closure↔determinant bridge (proof, standalone)
* **Submit:** standalone job importing `Spinor.PluckerMass`; targets
  `hermitian_det_eq_energy_sq_sub_bloch_sq` and
  `pluckerMass_eq_energy_sq_sub_closureDefect_sq_bundle`, plus the rest-frame
  corollary on the bundle.
* **Expected output:** a checked standalone file proving the trusted complex
  determinant mass equals `¼(E² − |C|²)`, with `E`, `C` the bundle's trace and
  Bloch closure. Unifies Clusters A-angular and the trusted det theorem.
* **Follow-through:** none beyond inspection; feeds Cycle 2 promotion.

### Cycle 2 — Promotion + P1 manuscript (integration, no heavy search)
* **Do:** promote `CelestialClosure` (promotion 1) and the T1 bridge
  (promotion 3) into trusted modules; run the Cluster-H mini-pass design note.
* **Expected output:** trusted `PhysicsSM.Spinor.CelestialClosure` + moment-map
  form on `PluckerMass`; P1 §4 (celestial moment form) rewritten to cite the now
  *trusted* identity instead of a standalone artifact; theorem table updated
  (trusted vs draft).
* **Background job:** submit T2 so it runs during integration.

### Cycle 3 — T2 P7 mixedness monotonicity (proof, standalone)
* **Submit:** `eigDist`, `visibleMixedness`, `visibleMixedness_eq_concurrenceSq`,
  `visibleMixedness_monotone_under_classical_observer` (bundle PSD + trace-1 +
  `IsUnital`).
* **Expected output:** the decisive finite P7 theorem — `4 det ρ_vis` is the
  eigenvalue mixedness and is monotone under unital classical observers — over
  the banked KL/DPI spine. Promote `RelativeEntropy` (promotion 2) this cycle.
* **Follow-through:** start the **P7 manuscript skeleton** (see §6).

### Cycle 4 — T4 Klein-quadric simplicity (proof, standalone)
* **Submit:** `decomposable_is_simple`, `twoEdge_mass_eq_klein_simplicityDefect`,
  `massless_iff_repeated_principal_spinor`. Fix the `Λ²ℂ⁴` basis ordering and
  Klein sign pattern once and cite them.
* **Expected output:** a checked finite Klein/simplicity core identifying
  pairwise masslessness with `B∧B=0`. Cheap; add the T3 recoverability toy as a
  second small job this cycle (validates the recovery story).
* **Follow-through:** note in P1 §7 (relation to prior work) the simplicity link.

### Cycle 5 — T5 reduced-density proper-time concurrence (proof, standalone)
* **Submit:** `properTimeRate_eq_two_sqrt_det_visibleDensity`,
  `properTimeRate_eq_concurrence` (thread `trace > 0`, Hermitian/PSD).
* **Expected output:** the physics-facing `m/E = 2√det ρ_vis = concurrence`
  wrapper over the banked det layer. Promote `CelestialChannel` (promotion 4).
* **Follow-through:** feed into the P7 manuscript's "mass as celestial
  mixedness" section.

### Cycle 6 — T6 diamond-observer DPI (definition pass + one-line instance)
* **Do first:** definition pass for `Microstate`, `Screen → FinObs.ofFun`
  reduction, `sjDiamondReferenceState : FinDist` (state only, pre-area-law).
* **Submit:** `relativeEntropyDataProcessing_for_diamondObserver` as a one-line
  instance of the promoted `klDiv_dataProcessing`.
* **Expected output:** the finite ANEC/QNEC-*analogue* positivity guardrail
  connecting the P9 source API to the P7 KL spine. Promote P9 Layer-1
  (promotion 5) re-exporting `CelestialClosure`.
* **Follow-through:** update the **P9 gate note** with the demotion ledger; do
  **not** open Layer-3 ANEC/QNEC or any Λ claim.

Beyond six cycles, the next wave is **T8** (full Bloch channel class), **T9**
(family gluing), then **T7** (crossed-module — prove or bank the obstruction),
with **T10** (super-Dirac assembly) only after the Cluster-H freeze.

---

## 6. Accompanying manuscript work (P1, P3, P7, P9)

**P1 — Mass as Plücker spread of null spinors (Banked; skeleton started).**
* After Cycle 1–2, rewrite §4 (celestial moment form) to cite the now-*trusted*
  `m² = ¼(E² − |C|²)` instead of the standalone artifact; keep the guardrail
  sentence ("visible closure `C=0` is rest-frame, not source invisibility")
  verbatim — it is the program's correct lesson.
* Convert the theorem inventory into the polished trusted-vs-draft table the
  skeleton's "immediate writing tasks" already lists.
* Write the two-page Cauchy–Binet proof sketch in conventional prose.
* Decision (recommended): **promote the closure module before submission** (it
  becomes trusted in Cycle 2), so P1 cites a trusted result, not an appendix
  handoff.

**P3 — Causal-diamond holonomy: finite gauge curvature without plaquettes
(Banked).**
* Start a P3 manuscript skeleton mirroring P1's structure, anchored on
  `Gauge.CausalDiamondHolonomy` + `NullEdgePathPairInterchange` (Abelian
  invariance, non-Abelian covariance, class-function invariance, composition,
  interchange).
* Reserve a "discussion / next" section for the crossed-module/fake-flatness
  layer (T7) — but write it conditionally: the 2-group surface-transport claim
  is only included once T7 proves the surface-label interchange (or the
  obstruction is banked). Cross-reference the abelian BF gluing law
  (`closureDefect_glue`) as the P9-facing analogue.

**P7 — Observer channels and relative-entropy monotonicity (Synthesis →
promotable to Near after Cycle 3).**
* Write the P7 skeleton now: the classical finite spine is banked standalone.
  Structure: `FinDist`/`FinObs` (column-stochastic, *not* doubly stochastic);
  `klDiv`; Gibbs; the **data-processing inequality** (headline; flag that
  Mathlib has `InformationTheory.klDiv` but **no DPI**, so this is built from
  scratch); observer loss; finite exact recoverability (Petz analogue); then the
  T2 `visibleMixedness` bridge as the program-content section ("mass as
  celestial mixedness, monotone under unital classical observers").
* Claim boundary (state explicitly): this is the **classical / commutative
  Type-I** layer. Not a quantum (non-commuting) DPI; not ANEC/QNEC; not
  Fawzi–Renner; not an SJ area law. The `AbsCont` support-inclusion hypothesis
  is load-bearing and must be in every statement.

**P9 — Cosmological-constant source visibility from diamond closure
(Aspirational; keep as a gate note, NOT a paper yet).**
* Fold the source-visibility API note into a single P9 gate document: the
  visible-closure / BF-closure / observer-invisibility separation discipline;
  the checked separation lemma; `boundaryExact_implies_bfClosed` (finite
  `d∘d=0`); `diamondSource_additive_iff_orthogonal` (with the explicit rejection
  of unconditional squared-source additivity); and the 8-item demotion ledger.
* Keep the boundary clause in every P9 section: "this finite algebra does not
  prove Sorkin everpresent-Λ, Benincasa–Dowker curvature, Jacobson/Clausius
  balance, ANEC/QNEC, or Sorkin–Johnston entropy." Those are motivation only.
* P9 graduates to a paper only after T6 + a homology-gap model + a recoverability
  toy all land **and** the amplitude-tension failure mode is addressed.

---

## 7. Tempting claims to keep avoiding

Carried and refreshed from v2/the P9 and relative-entropy notes; these would
bank a false or vacuous statement.

1. **`diamondSource = 0 ⇒ massless / source-free`.** Channel conflation; the
   antipodal toy is the standing counterexample. The visible-mass channel and
   the BF bulk channel must never share a symbol.
2. **Unconditional squared-source additivity under gluing.** Only the *defect*
   is additive (`closureDefect_glue`); the squared source adds **iff** the
   defects are orthogonal (`diamondSource_additive_iff_orthogonal`).
3. **`visible closure ⇒ BF closure`.** Independent constraints on different data;
   neither implies the other.
4. **Bare proper-time / concurrence / mixedness monotonicity.** False without an
   explicit `IsUnital` / LOCC / classical-channel class — entangling hidden
   channels can *increase* concurrence. Always split the channel-class predicate
   from the inequality.
5. **Quantum (non-commuting) matrix DPI in this repo.** No Mathlib support for
   operator convexity / Lieb concavity; do not open. If ever needed, restrict to
   **commuting** `ρ, σ`, which reduces exactly to the proved classical `klDiv`.
6. **"Recoverability gap controls source visibility" as a theorem.** The gap is
   defined and `≥ 0`; the inequality against a source defect is a **conjecture**
   until `R_petz` is constructed and computed in a toy (T3 is the validation
   step, not a proof of the inequality).
7. **SJ diamond reference state carrying an area law.** Define it as a finite
   `FinDist` only and flag it **pre-truncation / pre-area-law**.
8. **Any cosmological-constant / everpresent-Λ leverage from the finite API.**
   Interpretive; the branch survives only if a homology gap and the
   amplitude-tension mechanism are added. Ship the algebra, not the Λ claim.
9. **`n > 2` bundle `=` a single simple bivector.** Keep Cluster C strictly
   pairwise; multi-edge must go through closure (Cluster A), not one `B`.
10. **Labelling affine-Bloch maps "CPTP"; "mass is an l=1 flip-count";
    conflating `Sym²S` curvature with the `Λ²S` Plücker bracket; full twistor
    incidence / Penrose transform; continuum Dirac universality.** All are
    stronger than, or orthogonal to, anything currently provable; keep them as
    motivation or named conjectures.

---

## 8. Audit: is P9 stronger, weaker, or just cleaner?

**Verdict: substantially CLEANER, modestly STRONGER as finite mathematics, and
UNCHANGED (still gated/Aspirational) as cosmology.**

*Cleaner — the dominant effect.* Before the scaffolds, P9 was prose carrying a
latent headline error: treating visible closure `C = 0` as source invisibility.
The source-visibility scaffold makes the three notions rigidly separate
(visible/rest-frame closure vs BF/Gauss-law closure vs observer invisibility),
proves the flagship separation as a checked counterexample (the antipodal fan
has `C = 0` but mass `1`), and replaces the *false* squared-source additivity
with the correct `additive-defect` / `additive-iff-orthogonal` pair. The
relative-entropy scaffold adds a checked classical DPI + exact-recovery backbone,
so the positivity/recoverability guardrail is now a theorem-shaped object rather
than an analogy. The demotion ledger (8 explicit failure modes) sharpens the
program's own falsification discipline. This is a large gain in rigor and
honesty.

*Modestly stronger.* There is now a checked finite source algebra and a checked
information-theoretic positivity spine where v2 had only target statements:
`boundaryExact_implies_bfClosed` is a genuine finite `d∘d = 0`;
`klDiv_dataProcessing` is a real DPI not present in Mathlib. So the branch is
better-defined and more defensible, and its two adjacent papers (P1's closure
form, P7's observer channels) are strengthened by the same work.

*Not stronger in physics reach.* None of this touches the actual Λ claim, and the
scaffolds are explicit about the gaps that keep P9 Aspirational:
* the `Bivector := Fin 3 → ℝ` carrier is a **toy `su(2)_L` stand-in** with no
  linear-simplicity (EPRL vs degenerate vs `II±`) sector tracking;
* the SJ reference is **pre-area-law / pre-truncation**;
* the model actually used has **no homology gap** demonstrated
  (`IsBoundaryExact` vs `IsBFClosed` are stated distinct, but a *closed-not-exact*
  witness is not yet built — and that gap is exactly where the physics lives);
* `recoverabilityGap controls sourceVisibility` is still only a **conjecture**;
* the **everpresent-Λ amplitude tension** has no new suppression mechanism.

So P9's *leverage* (highest-risk, highest-reward cosmology branch) is unchanged,
but its *floor* rose: the finite skeleton is now clean, checked, and correctly
separated, which is precisely what lets the next agent build the homology-gap and
recoverability layers without re-deriving the separation each time. The right
status label remains **Aspirational**, now with a trustworthy finite spine
underneath it.

---

## Appendix — convention checklist (attach to every job)

Unchanged from v2; copy into each focused job prompt:

* metric signature `(+---)`; Pauli order/sign (`σy = [[0,−i],[i,0]]`);
* `spinorWedge ψ φ = ψ0 φ1 − ψ1 φ0`; Plücker normalization matches
  `finPairwisePluckerMass`;
* `m² = det P`; never silently mix with the trace pairing;
* Bloch normalization fixed once (`r = (2x,2y,2z)`,
  `det = ¼(E² − |r|²)` for the unnormalized Hermitian block);
* `klDiv` carries the `AbsCont` (support-inclusion) hypothesis everywhere;
* `FinObs` is column-stochastic; bundle `IsUnital` only where a
  unitality-dependent monotonicity is wanted;
* internal Gram/hidden labels tagged orthonormal-vs-coherent (a decohered
  theorem is never applied to a coherent case);
* P9 `Bivector` is a toy `su(2)_L` carrier (no linear-simplicity sector); the
  visible-mass channel and BF bulk channel never share a symbol.
