# c58-projected-branch-weyl-projector

# Summary of changes for run 2f69c001-8b15-4ce0-8426-c79c6d87ac31
## C58 — Projected branch / Weyl selector and chirality alignment after projection

I added `PhysicsSM/Draft/NullEdgeProjectedBranchChirality.lean`, which constructs an explicit projected branch selector and discharges the **chirality-alignment** part of the remaining Gate C obligation `OperatorForcesAlignmentAfterProjection`. The file builds cleanly (`lake build PhysicsSM.Draft.NullEdgeProjectedBranchChirality`), contains no `sorry`, and the four headline theorems depend only on the standard axioms `propext`, `Classical.choice`, `Quot.sound`.

### Important note on the project snapshot
The C21 module `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean` imports `PhysicsSM.Draft.NullEdgeFlavoredChirality` and `PhysicsSM.Draft.TetrahedralNullBranch`, and the Krein modules import `PhysicsSM.Draft.KreinDoubleAndCounterexamples` — **none of these base modules are present in the project**, so those files do not currently compile and cannot be imported. To still deliver a self-contained, machine-checked result, the new module reproduces exactly the Clifford data C21 uses (the Weyl block symbol `c(p) = [[0,A(p)],[B(p),0]]`, the chirality operator `γ₅`, and the Minkowski square `mink`), and reuses the target chirality pattern `g5 = (+,+,-,-)` verbatim from the standalone module `NullEdgeSymmetryForcedSpeciesSplit`. All operator statements are proved for an arbitrary null covector `p` (`mink p = 0`, `p ≠ 0`); each of the four C21 branch covectors is such a `p`, so the results specialise to every branch. This is documented in the module docstring.

### The explicit projector
`branchProj a v = ½ (v + (g5 a) • γ₅ v)` — the explicit Weyl/chirality projector onto the `γ₅`-eigenline with eigenvalue `g5 a ∈ {±1}`.

### Theorems proved (matching the requested names)
- `projectedKernel_finrank_one` — for any nonzero null covector `p`, the projected branch kernel `ker c(p) ⊓ (γ₅-eigenspace for g5 a)` has `finrank = 1`. This is the operator-level statement that the projection cuts the two-dimensional, chirality-balanced C21 kernel down to a single chirality line. (Proved via explicit Weyl embeddings identifying the projected kernel with the kernel of the 2×2 block `B(p)` or `A(p)`, plus a general lemma `ker2x2_finrank_one` that a nonzero singular 2×2 complex matrix has a 1-dimensional kernel.)
- `projectedBranch_chirality_aligned` — `γ₅ (branchProj a v) = (g5 a) • branchProj a v` for every `v`: after projection, `γ₅` acts by the single chirality sign `g5 a`.
- `operatorForcesAlignmentAfterProjection` — the C21 obligation, restated at projection level (over kernel zero-modes of null covectors) and discharged by `branchProj`.
- `gateC_projected_chirality_clause` — bundles the two facts above into the chirality-alignment clause and proves it.

### Honest scope (no hidden obligations)
The statement closes the chirality-alignment clause of Gate C **only**; it does not claim full Gate C release. The module explicitly records the two remaining independent clauses via the documentation definition `RemainingGateCObligations`: Krein positivity (K2, `NullEdgeKreinPositiveReleaseCriterion`) and ghost safety (C47/C48, `NullEdgeGateCGhostZeroSafety.GhostZeroSafe` / `PostGaugeGhostSafe`). That definition asserts nothing about those clauses.

No existing files were modified or deleted.

---

# c60-species-split-nodal-line-lift

# Summary of changes for run ea86e1cb-8ff3-4337-89af-e724c9c7c7ea
Delivered `PhysicsSM/Draft/NullEdgeSpeciesSplitNodalLine.lean` (C60), a self-contained Lean module (no `sorry`; only the standard `propext`/`Classical.choice`/`Quot.sound` axioms) that proves the species-splitting lift of the exact high-branch nodal curves exposed by C43/C44.

Method/context. I inspected the nodal-set and species-splitting modules. Note: the sibling files `NullEdgeSpectralGraphNodalSet.lean` and `NullEdgeActualCliffordSymbol.lean` do not compile in this project because they import modules (`TetrahedralHighMomentumNullBranch`, `NullEdgeFlavoredChirality`) that are absent. So, following the standalone pattern of `NullEdgeSymmetryForcedSpeciesSplit.lean`, the new module imports only Mathlib and self-containedly reconstructs the minimal nodal-curve machinery (`phaseU`, `qform`, `branchLinePhase`/`branchLineU`, the high `cornerPhase`).

Definitions added. The linear taste function `Tlin s q = ½ Σ_a s_a cos qₐ` (working plan §29.5), the modeled species-splitting term `Msplit r s q = r · Tlin s q`, the tracelessness condition `Traceless s := Σ_a s_a = 0`, and the literature pattern `g5 = (+,+,−,−)`.

Theorems proved.
- `branchLine_qform_zero`: the bare scalar determinant zero `qform u = 0` persists on the whole branch line for all `t` (C43/C44, reproved here) — the splitting does not touch this scalar channel.
- `Tlin_corner`: for traceless `s`, `T_lin` on the high corner `q^(a)` equals the branch sign `s_a`.
- `Tlin_branchLine`: along branch `a`'s exact line, `T_lin = s_a·(1 + cos t)/2`.
- `Tlin_origin`: at the origin endpoint `t = π`, `T_lin = 0` (origin unlifted).
- The lift theorem, as `Msplit_branchLine` (`= r·s_a·(1+cos t)/2`), `Msplit_high_corner_ne_zero` (value `r·s_a ≠ 0` at the high corner `t = 0`), `Msplit_origin_zero` (zero at `t = π`), and `Msplit_branchLine_zero_iff` (for nonzero `r`, `s_a`, the only zeros on the line are at `cos t = −1`, i.e. the origin endpoint).
- `g5_traceless` and `g5_split_lifts_high_branch`: the `(+,+,−,−)` pattern is traceless and realises the lift for every branch and any nonzero `r`.
- `species_split_lift_summary`: packaged statement.

Explicit scope (in the module docstring). What is lifted: the modeled species/taste mass channel `M_split = r·T_lin`, shown nonzero along the high nodal line away from the origin (a modeled branch-taste degeneracy split). What is NOT claimed: the bare scalar determinant zero is unchanged (separate channel), and there is no claim of physical ghost safety, propagator positivity, or Krein/causality control (those require the §29.6 cost-ledger audit, out of scope). Moduli verdict carried over from C45/C46: the coefficient `r` remains a free real modulus — any nonzero `r` realises the lift and none is symmetry-distinguished — so this is reconstruction/branch control, not a magnitude prediction.

The lift theorem is true and well-specified as formalized, so no no-go report was needed. The new file builds cleanly with no warnings; the rest of the project's pre-existing build breakage (missing imported modules) is unrelated and was left untouched.

---

# c61-gauge-covariant-link-dressed-projectors

# Summary of changes for run 58ea75f5-cf5e-4ed2-9bf0-ffa205616775
Completed the C61 gauge-covariant link-dressed branch projector strategy/API job, delivering both requested artifacts.

## Deliverables

1. **Report/plan** `AgentTasks/null-edge-gauge-covariant-branch-projectors-plan.md` — covers all six tasks: (1) the Lean-facing API for link-dressed branch projectors on a finite graph with gauge link variables; (2) the two transformation laws (covariance for an open projector, invariance for a closed composite); (3) the three deployment contexts kept separate (strictly retarded causal update block; retarded/advanced Krein spectral double; gauge-invariant composite/interpolating observable); (4) an admissibility table identifying which finite shift combinations are acceptable in each context, with the key finding that the symmetric `cos`-filter `S + S†` is inadmissible in the strict causal-update context but admissible in the Krein double and (when closed) the composite; (5) the implemented module skeleton; (6) the tie to `GhostZeroSafe` with the explicit guardrail that gauge covariance is necessary but not sufficient and that the free-field projectors are not physical after gauge coupling without link dressing AND a ghost audit.

2. **Lean module** `PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean` — self-contained (`import Mathlib` plus the self-contained C47/C48 ghost-zero file), builds cleanly with no warnings, no `sorry`, and only the standard axioms (`propext`, `Classical.choice`, `Quot.sound`). It proves, at theorem level:
   - transport/link algebra: `gaugeLink_comp` (path covariance via intermediate-gauge cancellation), `dressedHop_gauge`;
   - the central **`dressedProjector_gauge_covariant`** (a link-dressed finite shift combination transforms by a single base-point gauge factor);
   - **`loopComposite_gauge_invariant`** (a closed-loop singlet composite is exactly gauge invariant);
   - the three contexts as `ProjCtx` with `AdmissibleIn`, plus `causal_admissible_iff`, `not_causal_of_advanced`, and the concrete `cosFilter_not_causal`, `cosFilter_kreinDouble`, `retFilter_causal`;
   - the ghost-safety tie-in: **`gaugeCovariant_not_ghostSafe`** (a perfectly gauge-covariant dressed projector can still harbour a Golterman–Shamir fatal ghost), `LinkDressedSafe`, `linkDressedSafe_nonvacuous`, and the summary `c61_gauge_covariance_summary`.

The module reuses (rather than duplicates) the C47/C48 `GhostZeroSafe`, `ZeroDatum`, and witness infrastructure from `NullEdgeGateCGhostZeroSafety` (which builds standalone; the other sibling Draft files import upstream modules absent from this snapshot, a pre-existing condition unrelated to this task). No physical dynamics are assumed: the dressed Clifford symbol, post-gauge-coupling residue signs, and Krein-positivity remain recorded as open obligations. The report's honest verdict is that link dressing secures covariance at theorem level, but Route B stays PENDING-SAFETY on the post-gauge-coupling ghost-zero audit.

---

# c62-composite-interpolating-zero-escape

# Summary of changes for run dcb13858-e5ed-43fb-a31d-3dbca06ff2c1
Delivered the C62 composite/interpolating-field escape API as a new, self-contained, `sorry`-free Lean module: `PhysicsSM/Draft/NullEdgeCompositeZeroEscape.lean`. It builds cleanly (`lake build PhysicsSM.Draft.NullEdgeCompositeZeroEscape`) and the summary theorem `c62_composite_escape_summary` uses only the standard axioms (`propext`, `Classical.choice`, `Quot.sound`). It imports only Mathlib and the C47/C48 module `NullEdgeGateCGhostZeroSafety`, reusing its `ZeroDatum`, `IsFatalGhost`, `WellClassified`, and `GhostZeroSafe` API.

What it does (per the task deliverables):

1. Inspected the existing GhostZeroSafety API and built directly on top of it.

2. Models a propagator zero as a singular symbol `D : Matrix (Fin n) (Fin n) ℝ` (`IsPropagatorZero D := D.det = 0`), with `singular_iff_kernelMode` characterizing it via a nonzero kernel mode. Proposes the Lean-facing escape predicate `CompositeRemovable D z`, a structure bundling: the symbol genuinely has a zero, an `AlgebraicEscape`, and a physical gauge-response contract `z.gaugeCoupledPropagating = false`.

3. States the sufficient conditions distinguishing CompositeRemovable from FatalGhost: `CompositeRemovable.not_fatal` (the gauge-response contract contradicts the gauge-coupled half of the ghost criterion), `CompositeRemovable.wellClassified` (a `compositeRemovable`-labelled zero is well-classified in the C47/C48 sense), and the spectrum-level corollary `compositeRemovable_ghostSafe`.

4. Distinguishes the three field-basis manipulations:
   - Invertible change of basis (`IsInvertibleBasisChange`) is proved a NO-GO: it never removes a zero (`basisChange_preserves_zero`, `not_removable_by_invertibleBasisChange`).
   - Non-invertible projection (`ProjectedArtifact`) can remove a zero when the mode is discarded and the physical sector stays non-degenerate (`projectedArtifact_physical_nondegenerate`), with a concrete non-vacuity witness (`projExample`).
   - Enlarged elementary-plus-composite basis (`CompositeEnlargement`) resolves a zero in a larger invertible interpolating-field symbol, with a concrete witness (`compositeExample`).

5. Implemented the full API with proved logical implications, plus the `AlgebraicEscape` inductive (projection or enlargement only — invertible basis change deliberately excluded).

6. Made explicit what remains analytic/physical and kept the obligation sharp rather than declaring zeros safe by definition: `compositeEnlargement_always` shows an invertible enlargement exists for *every* symbol (so the algebra is cheap), and `algebraicEscape_not_sufficient` exhibits a fatal-ghost `ZeroDatum` whose singular elementary symbol nonetheless carries a valid `AlgebraicEscape`. The decisive missing inputs — gauge response and residue sign — are recorded as the explicit contract field `gaugeResponse` and through the C22 Krein-positivity / `IsFatalGhost` residue criterion, and are documented in the module header.

Note: the pre-existing sibling file `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean` fails to build because it imports an upstream file absent from this snapshot (`NullEdgeBranchKreinSignatures.lean`); this is unrelated to the new module and was left untouched. The new module was kept self-contained so it builds and verifies on its own.

---

# f16-post-route-b-prediction-ledger

# Summary of changes for run ab51a976-703a-407b-a87d-5a0aa36a0585
Delivered the Gate-F post–Route-B prediction ledger at `AgentTasks/null-edge-post-route-b-prediction-ledger.md`. This is a strategy/audit (report-only) job: no Lean was changed, and no axioms or `sorry`s were introduced. The ledger is grounded in the formalized content I read and verified in `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean` (C45/C46), `NullEdgeForbiddenCountertermCodim.lean` (F13 codimension), `NullEdgeInternalSpectrum.lean` (anomaly inheritance), and `NullEdgeGateCReleaseCriterion.lean` (C19 conditional release/forcing), cross-checked against the working plan (§20.9, §25.6, §26.2/§26.3) and the F15/Weber prior audits.

Note on the included-files list: the requested `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` (the C47 "projected Gate C release" module) is genuinely absent from the project — no file under `PhysicsSM/Draft/` matches. I flagged this explicitly in the report (`UNAVAILABLE-SOURCE`), conditioned every projector-route claim on the release-criterion file that is present, and made sure recovering C47 could only strengthen, never silently upgrade, a status.

The report addresses each requested item:
1. Updated prediction ledger — an 8-row status table after C21/C43/C45/K2/C47, using a sharpened vocabulary (PRED / PRED-COND / RECON / CONSIST / DEMOTED / DEAD), each row tied to named theorems. Verdict: no row is currently a Gate-F prediction; the finite→EFT map remains full-rank on the EFT-relevant sector.
2. Live routes — four conditional routes ranked: R1 operator-forced branch-chirality texture (discrete forcing via `aligned_signs_forced`, gated on the posited `OperatorForcesAlignment`), R2 anomaly-selected hypercharge codimension, R3 forbidden-counterterm codimension promoted to M_EFT, R4 external-selector forced texture. Each has its single falsifiable obligation and falsifier stated; generation-count and numerical-coupling routes are marked not alive.
3. Dead/demoted — bare branch-chirality forcing (demoted to conditional), species-splitting magnitude `r` (dead: proven free modulus, `weber_best_case_still_a_modulus`/`coeff_range_full`), and the flavored index as a standalone prediction (demoted to built-in branch count).
4. Manuscript-safe P2/P3 language — drop-in reconstruction wording for P2, conditional structural wording for P3, and a reconstruction-vs-prediction boundary sentence, each naming what is assumed vs. forced.
5. Adversarial discipline — no prediction is invented; "prediction" language is used only for genuine rank/codimension/forcing mechanisms, all currently conditional, with falsifiers identified.

---

# m14-p1-crosswalk-application-audit

# Summary of changes for run 389a2988-7598-4127-9776-be17f750daae
Completed the M14 final application audit of P1 crosswalk patches A–F. Deliverable written to `AgentTasks/null-edge-p1-crosswalk-final-application-audit.md`.

What I checked and found:
- Re-read the manuscript (`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`), the publication plan (`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`), the working plan, and the bundled M12/M13 records.
- Verdict: Patches A–F have NOT been applied. Every overclaim location M12 catalogued (O1–O7, plus the `spinorAction` identifier bug U1) is still present verbatim. The absent `PhysicsSM.Spinor.TwistorPluckerMass` module is still marked trusted/re-verified/established in the header anchors, the provenance paragraph, §8, §11, two §12 table rows, and the publication-plan "Banked Lean" paragraph.

Two additional findings beyond M12/M13:
1. `AgentTasks/null-edge-p1-crosswalk-patches-a-f-ready.md` has no payload — it contains the M13 run summary, not the actual hunks. So the audit reconstructs exact replacement text directly from the live manuscript.
2. No `PhysicsSM` Lean modules exist in this snapshot (only `RequestProject/Main.lean`), so neither the absence of the twistor module nor the presence of the covariance banners can be kernel-verified here. This is why all mandatory edits go in the safe direction (removing unverifiable trusted/re-verified claims), and any promote-to-trusted clarity upgrade is deferred to the live tree.

The audit provides:
- Mandatory release-blocking edits as six line-local unified-diff hunks (Patches A–F) with exact current and replacement text, spanning the two `Sources/` files, demoting the absent twistor wrapper from trusted to pending everywhere and fixing `spinorAction` → `actSpinor`.
- Optional clarity upgrades (the SL(2,C)-covariance promotions) explicitly marked NOT to apply in this snapshot since the bannered files are absent.
- Files affected, application order, and a post-apply verification checklist.

The safe P1 thesis is preserved throughout: P1 remains the finite kinematic Plücker/null-spread mass obstruction, with the trusted `PhysicsSM.Spinor.PluckerMass` core (Sections 1–6 and the corresponding §12 rows) untouched. No manuscript files were edited — this is a ready-to-apply audit for Codex/Claude/user approval, as requested.

---

# s10-route-b-master-strategy-after-c21

# Summary of changes for run 9d53b197-b87d-41c8-9151-eef543a18a18
Delivered the requested no-build master strategy document at `AgentTasks/null-edge-route-b-master-strategy-after-c21.md` (281 lines), synthesized from the post-C21/C22 outcomes, the Wave 11 integration record, the five returned audit notes (k2, c43/c44, c45/c46, c47/c48, f15), the ambitious job backlog, and the roadmap's post-C21 Gate C projected-release architecture.

The document is decisive and addresses all five tasks:

1. **Roadmap for the next 2-3 waves** — Wave 12 (integration freeze + criterion instantiation: restore missing reports, build the projected-release skeleton, instantiate Krein, target nodal-set exhaustion, apply the P1 crosswalk patches); Wave 13 (the actual tetrahedral Clifford-symbol decider + projected one-dim kernel + projected chirality, the decision fork that can close or refute Gate C); Wave 14 (PostGaugeGhostSafe instantiation and the canonical species selector — the kill-switch and the upside).

2. **Proof targets ranked by gate-closing value** — a 7-row table keyed to the post-C21 decomposition (NodalSetControlled, BranchProjectorsControlled, ProjectedKernelOneDim, ProjectedChiralityAligned, ProjectedKreinPositive, GhostZeroSafe, SpeciesSplittingAudited), with projected chirality alignment ranked #1, the symbol decider/one-dim kernel #2, cheap nodal-set exhaustion #3, and the ghost gate flagged as the dominant kill-switch.

3. **Missing/un-integrated work identified** — found that four report files referenced as "preserved verbatim" in the Wave 11 record do not exist in the repo (c43/c44, d19, e13, m13), plus the un-applied m13 P1 crosswalk patches (release-blocking overclaims O1-O7 and the spinorAction→actSpinor fix) and the orphaned d19/e13 modules and the f15 prediction-OFF verdict not yet reflected in manuscripts. Concrete remediation jobs are scheduled.

4. **Publication priority decision** — decisive: P1 cleanup first (small, days, only blocked by the m13 overclaims), then the P1.5 finite-reconstruction + branch-audit paper as the next substantial publication (the modules already exist and are honest), with the Gate C projected-release proof explicitly NOT gating publication but run as a parallel track that publishes as a conditional release or a no-go either way.

5. **Adversarial risk register** — three tiers (KILL: gauge-coupled fatal ghost zero, Krein growing modes, higher-dimensional nodal locus, still-mixed projected chirality; DOWNGRADE: r stays a modulus, no canonical selector, full-rank F→reconstruction, charged FMS composite; ENGINEERING: missing reports, broken default build target, criterion instantiation, convention rebuild).

Prediction claims are not inflated: the document keeps Gate F prediction language OFF throughout, noting that even a fully closed Gate C leaves the species-splitting coefficient r a free modulus, so the program's honest standing is unified finite reconstruction with structural forced-texture the only (still speculative) prediction upside.

This was a strategy/documentation task; the project snapshot contains only the source docs and AgentTasks (the referenced Lean modules live in another snapshot), so no Lean build or proof work was applicable.

---

# fur-h1-computed-internal-spectrum

# Summary of changes for run 57ec9b05-ab13-4d7c-a106-62d3a8df27c9
## FUR-H1 — Computed Furey internal spectrum bridge

I inspected the Furey modules and `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` and implemented the requested draft module `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`.

### Key finding about the checkout
The provided project did **not build at all**: every shipped `.lean` file transitively imports foundational modules that are absent from the checkout (the octonion stack — `Algebra.Octonion.ComplexOctonion`, `Furey.LadderOperators`, `Furey.OperatorRepresentations` — plus `StandardModel.AnomalyPackage`, `StandardModel.OneGenerationTable`, and the electroweak-bridge packages). In particular the octonion-coordinate eigenvalue theorems (`AnomalyBridge.Q_op_vbar1`, …) cannot be imported. This is the exact import boundary the task asked me to identify.

### What I built (all `sorry`-free, axiom-clean)
1. `PhysicsSM/StandardModel/AnomalyPackage.lean` — reconstructed the missing anomaly package as a self-contained, Mathlib-only, pure list/rational development (the API `NullEdgeInternalSpectrum.lean` requires: `ChiralMultiplet`, the five anomaly functionals, `LocalAnomalyFree`/`WittenSU2AnomalyFree`, the `standardModelOneGeneration` table with anomaly-freedom proofs, and the `nCopies` family scaling). This makes the existing draft compile.
2. `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean` — upgrades the bridge from a posited table to charges **computed from the Furey `J` states**, modeling the eight `J` states as the occupation lattice `Finset (Fin 3)` with the number-operator charge `Q = -(1/3)·(occupied modes)` — exactly the level on which `Q_op` is diagonal. Delivered theorems:
   - `fureyJChargeMultiset_eq`: the computed eight-state charge multiset equals `{0,-1/3,-1/3,-1/3,-2/3,-2/3,-2/3,-1}` (matching the `AnomalyBridge` table), with occupation-number count and per-ideal `Σ Q = -4`, `Σ Q³ = -2` lemmas and their cancellation against the charge-conjugate ideal;
   - `fureyJ_realizes_nullEdgeInternalSpectrum`, `fureyJ_localAnomalyFree`, `fureyJ_wittenAnomalyFree` (anomaly freedom inherited, no re-arithmetic);
   - `fureyStyleRealization_eq_computedJ`: the prior bookkeeping instance coincides with the computed instance.

### Boundary preserved
Internal spectrum and anomaly inheritance only — no `Φ_H`, no Yukawa/mass data, no kinetic Gate C. The all-left charge-conjugate basis is kept distinct from the physical Dirac `E_L ⊕ E_R` basis, and the documentation states explicitly that weak-`SU(2)`/hypercharge structure comes from the electroweak bridge, not the single ideal.

### Build
The whole-library build still fails on the other absent octonion modules (pre-existing, untouched). Build the self-contained bridge DAG explicitly:
`lake build PhysicsSM.StandardModel.AnomalyPackage`, `lake build PhysicsSM.Draft.NullEdgeInternalSpectrum`, `lake build PhysicsSM.Draft.NullEdgeFureyInternalSpectrum`. Status notes are in `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md`.

---

# fur-h2-chi-e-from-furey-krasnov-structure

# Summary of changes for run 9eb716ed-38d1-4579-b70b-047e0a08560e
## FUR-H2 — Can Furey/Krasnov complex-structure data discharge `chi_E`?

**Answer: No.** The Furey/Krasnov datum ("right multiplication by `e111` acts as multiplication by `i`") is a **complex structure** `J` with `J² = −1`, whereas `chi_E` is a **Z/2 grading / involution** with `χ² = +1`. They are different invariants; a complex structure cannot serve as `chi_E`, and the project itself already lists `Gamma_s, chi_E, J` as three separate decorations.

### Deliverables
- **`PhysicsSM/Draft/NullEdgeFureyChiE.lean`** — a self-contained Lean module (imports Mathlib only, **no `sorry`**, 12 proved theorems, audited axioms `propext`/`Classical.choice`/`Quot.sound`). It builds independently via `lake build PhysicsSM.Draft.NullEdgeFureyChiE`. It formalizes:
  - `complexStructure_not_grading` / `complexStructure_ne_grading` — a complex structure (`J²=−1`) is never, and never equals, a Z/2 grading (`χ²=+1`) whenever `(1:A) ≠ −1`. This is the formal "do not conflate `×i` with a chirality grading."
  - `grading_of_complexStructure_mul_central` — the only clean way to make an involution from `J` is to twist it by a *second, commuting* square-root of `−1`: `(i·J)² = +1`. This isolates the extra data required.
  - `complexStructure_self_mul_is_trivial` — on the ideal the Krasnov identification makes `i = J`, so the twist degenerates to `−1` (the trivial central involution, grading nothing).
  - `central_cannot_be_internal_grading` / `central_invertible_odd_block_zero` — since `×i` acts as the central scalar `i`, it commutes with everything and so can never make a nonzero `Phi_H` odd, whereas `chi_E` is *defined* by `{chi_E, Phi_H}=0`.
  - `sign_bridge_with_grading` / `complexStructure_cannot_fill_grading_slot` — the Gate A sign dichotomy (`+Phi_H²` with the commuting `Gamma_s`, `−Phi_H²` with the odd `chi_E`); the grading slot must be an involution, so a complex structure can play neither `Gamma_s` nor `chi_E`.
  - Non-vacuity witnesses in `ℂ`.
- **`Sources/FUR_H2_chiE_report.md`** — a precise report covering all five task items: an inventory of the existing definitions, the classification table, the bridge theorem statements, the explicit `chi_E`/`Phi_H`/Gate-A interaction, the `Gamma_s`/`chi_E`/`J`/degree separation guardrail, and the list of missing APIs.

### Key conclusions
1–2. Existing data: the Furey files define `omega = (1−i·e111)/2`, `omega_bar`, the ladder/number operators, but **no** grading/involution on `J`; the complex structure exists only in prose. `NullEdgeInternalSpectrum.grading` (`InternalGrading = even | odd`) is the `chi_E` Z/2 label.
4. The Krasnov datum is a complex structure, **not** a grading, and **not both** — no theorem converts one into the other naively, and the only conversion needs extra commuting-`i` data that degenerates on `J`.
3+5. The correct, separate source of `chi_E` is the number-operator parity `(−1)^(N1+N2+N3)` (equivalently the `omega`/`omega_bar`, particle/antiparticle, L/R reflection): a genuine non-central involution that anticommutes with `Phi_H`. The complex structure instead feeds the central `i` of the `i·D_N` term.

### Build situation
A bridge module *referencing* the real `J`/`grading` objects cannot compile in this delivered subset, because the foundational files those context files import (`ComplexOctonion`, `LadderOperators`, `AnomalyPackage`, the `NullEdgeSuperDirac*`/`NullEdgeFiniteTetradPostulate` files) are absent. The abstract module is written so every symbol maps to a named repository object; the report lists the four missing formal APIs (a formal `rightMulE111` with square `−1`; its identification with `×i`; the number-parity involution `chiN`; and `{chiN, Phi_H}=0`) whose addition would let the abstract theorems transport verbatim to the concrete ideal.

---

# fur-h3-conjugate-ideal-right-handed-sector

# Summary of changes for run 8eaa96db-929b-43e0-baff-b3922ba207e7
## FUR-H3: Conjugate ideal J* and the right-handed singlet sector

### Audit finding
The eight provided `Furey` files sit on top of ~13 foundational modules that are **absent** from the project (`Algebra/Octonion/ComplexOctonion`, `Furey/LadderOperators`, `AnomalyBridge`, `ElectroweakBridge`, `OneGenerationTable`, `AnomalyPackage`, etc.), so the project does not build as delivered. `FureyRightHandedSectorOpen` is a trivial `True`-valued marker, and the 7 right-handed-singlet Weyl states (u_R, d_R, e_R) were appended conventionally rather than derived.

### What was delivered
Because the octonion foundations are missing, I added a **self-contained, kernel-checked** module `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean` (imports only Mathlib, builds independently, no `sorry`/`axiom`/`native_decide`) that formalizes the conjugate-ideal right-handed sector at the same coordinate/charge-table granularity as the project's existing anomaly-bridge files. Its main theorem `fureyRightHandedSectorRealized` bundles:

- **Conjugate-ideal basis**: an 8-dim coordinate model `Jstar` with `JstarBasis` linearly independent over ℂ, every basis vector nonzero, and `finrank ℂ Jstar = 8`.
- **Charge conjugation**: an antilinear, involutive, bijective map `Cconj` (coordinate shadow of complex conjugation exchanging J and J*).
- **Charges by conjugation**: `qJstar = -qJ` (with `qJ` reproducing `QopJEigenBridge.rawQopJ`), spectrum `[1,2/3,2/3,2/3,1/3,1/3,1/3,0]`.
- **Right-handed singlet quantum numbers**: `u_R^c (-2/3,0,-4/3)`, `d_R^c (1/3,0,2/3)`, `e_R^c (1,0,2)`, each the charge conjugate of the physical u_R/d_R/e_R charge and satisfying Gell-Mann–Nishijima `Q = T₃ + Y/2`.
- **Full all-left anomaly cancellation** over the 15-state table *including* the singlets: gravitational/linear U(1), cubic U(1)³, SU(2)²·U(1), SU(3)²·U(1), and the Witten global SU(2) condition; the singlet sub-table contributes exactly the complement of the doublet sub-table and supplies the missing 7 Weyl states.

The main package theorem verifies with only `propext`, `Classical.choice`, `Quot.sound`.

This narrows `FureyRightHandedSectorOpen`: the singlet gauge data is now produced by the conjugate ideal and certified anomaly-compatible rather than merely appended. No mass values and no three-generation claim are made; the all-left handedness convention is used throughout.

### Strategy companion
`Sources/FUR-H3_ConjugateIdeal_Strategy.md` documents the audit, the exact list of reusable `Jbar` facts (with a mapping table), and the minimum missing definitions (`omega_star = (1+i·e₇)/2`, `J* = (ℂ⊗𝕆)·ω*`, the octonion conjugation map and the eigenvalue intertwiner `Q_op∘conj = -conj∘Q_op`) needed to upgrade the coordinate model to the genuine octonion ideal and close the sector outright once the absent `ComplexOctonion`/`LadderOperators` modules are restored.

### Note
The pre-existing modules remain non-building because their foundational imports are not part of the project; reconstructing the full complexified-octonion algebra was out of scope and not feasible here. The new module and strategy document are the verifiable deliverables and do not depend on the missing files.

---

# fur-h4-gauge-covariant-phi-h-from-furey

# Summary of changes for run acd1dc05-df8e-444f-a1ba-eedd2d61240f
## FUR-H4 — Gauge-covariant internal Yukawa map `Φ_H` with `χ_E` oddness

I implemented and proved the requested internal finite spectral-triple half `Φ_H` in the new file `PhysicsSM/Draft/NullEdgeFureyPhiH.lean`. It builds cleanly (no `sorry`, no new axioms — only `propext`/`Classical.choice`/`Quot.sound` — and no linter warnings).

### Inspection (Task step 1)
I read the Furey electroweak/weak-isospin modules (`ElectroweakBridge`, `WeakIsospinDoublets`, `WeakIsospinLadder`, `ElectroweakCompletePackage`, `FureyRealizesOneGeneration`, `MinimalLeftIdeal`, `JbarActionTable`), the null-edge checkerboard/sign/Lichnerowicz/internal-spectrum drafts, and the working plan. Note: the supplied project is an excerpt — most of those files import modules that are not present (e.g. `NullEdgeFiniteTetradPostulate`, `AnomalyPackage`), so only `NullEdgeYukawaCheckerboard.lean` is self-contained and compiles. I therefore made the new file depend only on Mathlib and that checkerboard module, while documenting the conceptual links to the (currently unbuildable) sign-bridge and internal-spectrum files.

### Domain/codomain (Task step 2)
The morally-`J → J*` Yukawa map is realized in the **Dirac `L ⊕ R` basis equivalent**: an off-diagonal chirality-flip block `Φ_H = [[0, M],[Mᴴ, 0]]` on `H_L × H_R`, with the constant block `M : H_R →ₗ[ℂ] H_L` following the checkerboard convention. The docstring states the `J/J*` interpretation and a guardrail keeping this kinetic Dirac basis distinct from the all-left anomaly bookkeeping basis.

### Interface and proofs (Task steps 3–4)
Definitions `chiE`, `phiH M`, `gaugeAct gL gR` on `H_L × H_R`, plus the bundled `structure GaugeCovariantPhiH` (a gauge-intertwining Yukawa datum). Proven theorems:
- **`χ_E` oddness**: `phiH_chiE_odd` (`{χ_E, Φ_H} = 0`) and `chiE_sq` (`χ_E² = 1`).
- **`Γ_s` compatibility / `+Φ_H²` sign**: `phiH_gammaS_even`, the abstract `graded_square_comm`/`graded_square_anticomm`, and `phiH_sign_dichotomy` (pairing with the `Γ_s` restriction gives `+Φ_H²`, pairing with `χ_E` gives `−Φ_H²`), with the non-conflation guardrail `gammaS_internal_ne_chiE`.
- **Gauge covariance**: `phiH_gauge_covariant` (commutes with the gauge action when `M` intertwines the reps) and `chiE_gauge_commutes` (gauge preserves the grading).
- **Legal Yukawa pairing → checkerboard**: `phiH_sq`/`phiH_sq_apply` (`Φ_H² = (M Mᴴ) ⊕ (Mᴴ M)`) and `phiH_sq_nonzero_eigenvalue_correspondence` reusing the checkerboard singular-value theorem.
- **Bundled correctness**: `GaugeCovariantPhiH.isProperPhiH` packages oddness, `Γ_s`-evenness, gauge covariance, and the squared mass block.

### Guardrails honoured
No Yukawa eigenvalues are derived (`M` is arbitrary); the all-left anomaly basis is kept distinct from the physical Dirac `L/R` basis; no axioms or fake assumptions were introduced.

---

# fur-h5-almost-commutative-product-square

# Summary of changes for run b75249bf-0655-4890-903e-2f5af6ca2a25
Delivered `PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean`, the FUR-H5 integration module assembling the finite null-edge/Furey almost-commutative product Dirac operator `D = i D_N ⊗ 1 + Γ_s ⊗ Φ_H` and reusing the Gate A square. The file builds cleanly (no `sorry`, no warnings) and every theorem depends only on the standard axioms `propext`, `Classical.choice`, `Quot.sound`.

Inspection findings (recorded in the file's docstring): of the six included context files, only `NullEdgeYukawaCheckerboard.lean` is self-contained on Mathlib. The other five (`NullEdgeFiniteLichnerowiczBridge`, `NullEdgeSuperDiracSignBridge`, `NullEdgeInternalSpectrum`, and the two `Algebra/Furey/*` files) import `PhysicsSM.*` modules that are not present in this project slice — including the upstream `NullEdgeSuperDiracSignAudit` that defines the abstract Gate A square (`CleanSquareHypotheses`, `super_dirac_square_sum`, `graded_square_*`), the tetrad postulate, the Furey octonion/ladder operators, and `StandardModel.AnomalyPackage`. Consequently those files (and a default project build) do not compile here. To make the deliverable a clean, self-contained artifact, the new module imports only Mathlib and mirrors the Gate A interface verbatim, re-deriving the abstract square (pure finite associative-ring algebra) under the identical `CleanSquareHypotheses`/`superDiracSquare` names; the docstring documents the exact upstream correspondence.

API designed and proved:
- `CleanSquareHypotheses`, `superDiracSquare` — the abstract Gate A finite super-Dirac square `(i D_N + Γ_s Φ)² = -D_N² + Φ² - i(Γ_s ∑_a C_a [∇_a,Φ])`.
- `graded_square_comm` / `graded_square_anticomm` — the abstract `±Φ²` sign lemmas.
- `FureyInternalData` — the internal Furey interface/placeholder (internal chirality `χ_E` with `χ_E²=1`, and a `χ_E`-odd mass block `Φ_H`); no construction of `Φ_H` is asserted, keeping the unproved `Φ_H` construction separate from the product architecture (task point 5).
- `AlmostCommutativeProduct` — the assembled product datum (external Clifford data + Furey internal data + the almost-commutative compatibility hypotheses `[Γ_s,Φ_H]=[C_a,Φ_H]=[∇_a,Φ_H]=0`), with `toCleanSquareHypotheses` exposing it as Gate A data.
- `product_square_eq_gateA` — the headline theorem (task point 4): once a Furey-compatible `Φ_H` satisfies the hypotheses, the product square is exactly the Gate A square specialised to the Furey internal `Φ_H`.
- `product_square_clean` — under the genuine product hypothesis `[∇_a,Φ_H]=0` the Lichnerowicz defect term vanishes, giving `D² = -D_N² + Φ_H²`.
- `product_sign_dichotomy` — the `(Γ_s Φ_H)² = +Φ_H²` / `(χ_E Φ_H)² = -Φ_H²` sign bridge for the Furey internal space.
- A concrete non-vacuity witness on `Matrix (Fin 2) (Fin 2) ℂ` (`Φ_H = σ_x`, `χ_E = σ_z`, trivial external data): `concreteWitness`, `concreteWitness_square` (`D² = 1`), and `concreteWitness_sign_flip` showing the sign flip is genuine (`+1` vs `-1`).

No existing files were modified; the broken upstream context files were left untouched.

---

# fur-h6-dvt-jordan-yukawa-constraint-audit

# Summary of changes for run 707c1a86-7b12-4f98-b481-212ef3f132aa
Delivered the FUR-H6 adversarial audit at `AgentTasks/null-edge-dvt-yukawa-constraint-audit.md`. This is a report-only strategy/audit job (matching the F15 precedent), so it makes no Lean changes — and the audit's own conclusion is that there is currently nothing to prove that would constrain `Phi_H`.

What I inspected: the full DVT/exceptional-Jordan island (`PhysicsSM/Algebra/Jordan/`, ~50 files: DVT stabilizer stack, inner-derivation/su(3) shadow, Cayley-plane cubic norm, complement-module results), the Furey–Hughes triality island (`PhysicsSM/Algebra/Furey/Triality*.lean`), the two null-edge Draft files (`NullEdgeInternalSpectrum.lean`, `NullEdgeForbiddenCountertermCodim.lean`), and the relevant §33 of the working plan plus the F15 ledger.

Decisive cross-check: across the whole `PhysicsSM/` tree the tokens `Phi_H`/`Yukawa` appear only in the two Draft files, and `covariant`/`equivariant`/`Schur` appear nowhere — i.e. the DVT/Jordan/triality island and the `Phi_H` slot are formally disconnected.

Key findings, addressing each task point:
1. Classification into the four requested buckets — structural reconstruction (DVT `(SU(3)×SU(3))/ℤ₃` faithful stabilizer; inner-derivation su(3) shadow; anomaly inheritance; triality role-constant GMN transport), forbidden-texture/zero constraint and rank/codimension (only `forbidden_counterterm_codimension`), and would-be unsupported numerology (the `Prop := True` "three roles = three generations" placeholders, correctly asserted nowhere).
2. The one genuine codimension/forcing result (`(L²+R²)` off-diagonal forcing) comes from the spacetime chirality grading `Γ_s`, NOT from DVT/Jordan/triality, and it only forces `Phi_H` to be off-diagonal; the off-diagonal Yukawa block stays full-rank, so the texture is unconstrained.
3. Proposed four ranked, falsifiable Lean theorem targets (A: an actual internal gauge representation to replace the `True` placeholders; B: a Schur-type forbidden-texture theorem from gauge covariance; C: a positive covariant-Yukawa codimension — the actual Gate-F gate; D: guarded Jordan-cubic/triality rigidity), each with explicit acceptance and falsifier criteria, and none introducing axioms.
4. Adversarial verdict stated plainly: DVT, triality, and the Jordan cubic each do NOT constrain `Phi_H` as formalized; Gate F status is unchanged from F15 (EFT-rich `Phi_H` sector full-rank), so Gate F prediction language must remain off until Targets A→B→C are proved with strictly positive codimension.

---

# fur-e1-electroweak-stabilizer-comparison

# Summary of changes for run a8352886-a846-4609-afe9-b403659c96ae
Implemented the requested Lean bridge in `PhysicsSM/Draft/NullEdgeFureyEWStabilizerComparison.lean`, relating the Furey/Hughes electromagnetic generator to the null-edge FMS photon stabilizer. The file builds cleanly (no `sorry`/`axiom`/`admit`; the main theorem uses only `propext`, `Classical.choice`, `Quot.sound`).

What I found on inspection:
- The null-edge modules (`NullEdgeElectroweakStabilizer`, `NullEdgeFMSFiniteComposite`, `NullEdgeFMSCompositeObservableNext`) build on Mathlib alone. They isolate the photon direction as `span ℝ {Qgen}` (with `Qgen = ![0,0,1,1]` encoding `Q = T₃ + Y/2`), the one-dimensional kernel of the orbit-obstruction map `B_EW` that stabilises the Higgs reference section `H₀`.
- The Furey electroweak modules (`Algebra/Furey/ElectroweakBridge`, `OperatorElectroweakIdentity`, `QopElectroweakConsistency`, `ElectroweakCompletePackage`) cannot be imported in this snapshot: their upstream dependencies (`AnomalyBridge`, `OneGenerationTable`, `QopJbarEigenBridge`, `MinimalLeftIdeal`, `ElectroweakPaperPackage`, `T3OpJbar`, `WeakIsospinDoublets`, `WeakIsospinLadder`) are absent, so those files do not compile. Their shared electromagnetic content, however, is the Gell-Mann–Nishijima relation `Q = T₃ + Y/2` (`ElectroweakBridge.gellMannNishijima_all`, `OperatorElectroweakIdentity.physicalQEnd_eq_targetT3End_add_half_targetYEnd`).

Because the Furey modules are not importable, I made the bridge self-contained: the small dependency-free Furey content actually used — the finite electroweak charge table (`fPhysicalQ`, `fTargetT3`, `fTargetY`) and GMN (`furey_gellMannNishijima`) — is reproduced verbatim with provenance comments pointing to the originals, so the local copies can be swapped back to imports once the upstream files are restored.

The bridge then proves that the Furey electromagnetic generator `Q = T₃ + Y/2` and the null-edge FMS photon stabilizer `span ℝ {Q}` are the same unbroken one-dimensional direction:
- `fureyEMgen_eq_T3_plus_Yhalf` / `Qmat_eq_T3_add_Yhalf`: GMN at the coordinate and matrix level (`Q = T₃ + Y/2 = diag(1,0)`).
- `fureyEMgen_eq_Qgen` / `rho_fureyEMgen`: the Furey EM generator equals the null-edge `Qgen`, with representation `ρ(Q) = Q`.
- `fureyEMgen_stabilizes_vacuum`: `ρ(Q) H₀ = 0`.
- `fureyEMgen_massless`: zero orbit-stiffness mass (massless photon).
- `fureyEMgen_span_eq_photon_stabilizer` / `fureyEMgen_span_eq_massForm_kernel`: `span ℝ {Q} = ker B_EW = {x | massForm v x = 0}`.
- `furey_EM_generator_is_null_edge_photon_stabilizer`: the assembled bridge.

Scope was preserved: this is a stabilizer / orbit-stiffness compatibility result only — no W/Z pole theorem and no mass prediction. Since the Lean bridge was feasible, no markdown fallback was produced.

---

# fur-l1-foundational-literature-source-pack

# Summary of changes for run c6c9f03e-7ae9-4980-b81f-3b62b2158f2c
Produced the requested Furey/Baez foundational source pack at `AgentTasks/null-edge-furey-foundational-source-pack.md`. This is a literature/provenance audit only — no papers were ingested and no Lean code was changed.

What the source pack contains:

1. **Theorem-provenance map** — a per-module, per-declaration table mapping the three audited Furey Lean files (`MinimalLeftIdeal.lean`, `FureyRealizesOneGeneration.lean`, `ElectroweakCompletePackage.lean`) to the correct foundational paper and the relevant project convention (XOR octonion basis, e111 = e_7 via ConventionBridge, the Locked electroweak `Q = T₃ + Y/2` convention). I also flagged that the three files import several sibling modules that are absent from this snapshot, so the same assignments should be propagated when those are curated.

2. **Source → claim cross-index** — explicit attribution of each requested claim: minimal left ideal / idempotent ω (Furey 1806.00612 §2); ladder operators and number-operator charge (Furey 1806.00612 + Furey 2015); gauge group SU(3)×SU(2)×U(1) (Furey 1810.10465); electroweak embedding / hypercharge / Gell-Mann–Nishijima / anomaly bookkeeping (Baez–Huerta 0904.1556 + project EW convention + Peskin–Schroeder §20.2 already cited). I flagged that "SU(3) from G₂" and "DVT/Jordan/triality" are **not** realized in the audited files and their proper sources lie outside the three-paper pack, recommending separate curation rather than mis-attribution.

3. **Provenance-strengthening flags F-1…F-6**, notably: the `T12…T32` SU(3) generators are defined but the SU(3) action is explicitly "not yet formalized" (should be marked as scaffolding); `MinimalLeftIdeal`'s Sources block cites only one arXiv ID though its content also rests on Furey 2015 and Baez–Huerta; `basis_linear_independent`/`omega_bar` record proof-job provenance but not claim provenance; and `FureyRealizesOneGeneration` cites the gauge paper by journal string only (no arXiv ID).

4. **Zotero/Neo4j metadata** — BibTeX-style entries with suggested keys (`Furey2018ideal`, `Furey2018gauge`, `BaezHuerta2010GUT`), keyword tags, a suggested collection, and Neo4j node/relationship templates (`:Paper`, `:LeanModule`, `[:SUPPORTED_BY]`, `[:USES_CONVENTION]`, `[:CLAIM_BOUNDARY]`).

5. **Curator confirmation items C1–C3** — to avoid an unverified bibliographic claim, the arXiv↔journal correspondences for the two Furey papers are listed for confirmation rather than asserted; the repo currently cites the gauge paper only by its EPJC journal string, so that link should be verified before the two citations are merged into one graph node.
