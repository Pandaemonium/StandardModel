# Morning report: overnight YM run 2026-07-03

## 1. Executive summary

- GateYM went from scattered YM scaffolds to a coherent finite-group lattice ensemble stack, with Wilson local weights, reflection scaffolding, a D12 flux-qualified `finiteMassGap` definition slot, and full-repo `lake build` green.
- YM3 Route B closed the Wilson kernel PSD engine; RP-LINK proper was deliberately not claimed, because the lattice cut/factorization/PSD assembly is still real work.
- YM1 closed the Z2 rectangular-loop Theorem 2' combinatorial formula, integrated the finite-group Lemma 2a character-fusion step from Aristotle after catching and fixing a normalization bug, and assembled Theorem 2's fusion/iteration half at the concrete Wilson weight (`Theorem2AreaLaw.lean`) - the ensemble/tree-gauge bridge (Lemma 2b) remains the one piece separating this from a full expectation-value theorem.
- Literature sprint verified the standing register, found two important novelty/claim-language constraints, and unblocked the KP statement freeze.
- No trusted promotion happened; all new Lean is draft GateYM code, with explicit remaining gaps and no hidden `s o r r y` in the project modules.

## 2. Theorems landed

Verification shorthand: every module below was covered by targeted `lake env lean` / `lake build PhysicsSM.Draft.NullEdge.GateYM...` checks recorded in `LEDGER.md`, repeated aggregate GateYM builds, final `lake build` (8295 jobs), and `pre-commit run --all-files`. Axiom footprints below are the audited footprints recorded during the run.

### YM3 PSD and transfer atoms

- `wilsonKernel_posSemidef`, `reCharGram_posSemidef`, `hadamard_posSemidef`, `hadamard_pow_posSemidef` in `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean` (`fb4df44`).
  Verification: `lake build PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity`, aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `transferMatrix_posSemidef`, `compression_posSemidef`, `singleLinkWilsonKernel_diagCongruence_posSemidef` in `TransferPositivity.lean`.
  Verification: targeted module build, aggregate GateYM build; Aristotle red-team led to the rename/re-scope in `9c4b4d2`. Axioms: `[propext, Classical.choice, Quot.sound]`.

### YM1 2D exact-solution core

- `eq_empty_or_univ_of_zero_boundary_bits`, `eq_or_compl_of_sameBoundary`, `sum_zeroBoundary_weights`, `sum_sameBoundary_weights`, `ratio_sameBoundary_zeroBoundary_weights`, `rectInside_card`, `ratio_rectInside` in `TorusEvenCover.lean` (`8bcd861` for the rectangular loop closure).
  Verification: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/TorusEvenCover.lean`, aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `IsClassFunction`, `lemma2a_fusion_convolution`, `iterConv_character_fusion_cross`, `convLeft`, `iterConv`, `iterConv_eigen`, `iterConv_eigen_at_one` in `FusionConvolution.lean` (`6abcd91` for the Lemma 2a integration).
  Verification: targeted file/module checks and aggregate GateYM build. Axioms for `lemma2a_fusion_convolution` and `iterConv_character_fusion_cross`: `[propext, Classical.choice, Quot.sound]`.
  Aristotle project `3435c7a3` supplied the proof; the v1 statement was refuted at the trivial representation with `w = 1`: LHS `= |G|`, buggy RHS `= |G|^2`.
- `wilsonPlaquetteSumC`, `wilsonPlaquetteSum_pos`, `wilsonPlaquetteSumC_ne_zero`, `wilsonLocalWeightC_class`, `wilsonLocalWeightC_inv_of_unitary`, `wilson_gamma`, `wilson_iterConv_eigen_at_one`, `wilson_iterConv_normalized_at_one`, `wilsonNormalizedGamma`, `wilson_iterConv_normalizedGamma_at_one` in `Theorem2AreaLaw.lean`.
  Verification: targeted file/module checks, axiom audit, and aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
  This is the Wilson-weight convolution iteration identity plus per-plaquette scalar normalization; nonzero of the normalizer is proved from positivity of Wilson weights, and the normalized area-law scalar is named for downstream statements. It still does not identify the convolution with a normalized lattice expectation.

### YM0/T3 finite-group lattice and reflection stack

- `stepHol_gauge`, `hol_gauge`, `classFunction_hol_gauge_closed`, `gaugeEquiv`, `sum_comp_gauge`, `Walk.append`, `Walk.reverse`, `hol_append`, `hol_reverse` in `GaugeCoreGeneral.lean`.
  Verification: targeted file/module checks and aggregate GateYM builds. Axioms: standard project footprint where audited.
- `Plaquette.hol_gauge`, `Plaquette.classFunction_hol_gauge`, `actionSum_gauge`, `productWeight_gauge` in `PlaquetteCore.lean`.
  Verification: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean`, aggregate GateYM build. Axioms: standard project footprint.
- `partition`, `numerator`, `expectation`, positivity, gauge-change-of-variables, and `gaugeOrbitAverageObservable` numerator equality in `LatticeEnsemble.lean`.
  Verification: targeted/module/aggregate checks. Axioms: standard project footprint.
- `PlaquetteEnsemble.lean` and `WilsonLocalWeight.lean`: finite product-plaquette partition/numerator/expectation, positive local weight -> positive partition, Wilson local weight class-function invariance, unitarity-dependent inversion symmetry, Wilson partition positivity.
  Verification: targeted checks and aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `WilsonReflectionCompatibility.lean`: `rhoOppositeInv`, `rhoOppositeInv_mul`, `rhoOppositeInv_one`, `rhoOppositeInv_unitary`, `wilsonLocalWeight_rhoOppositeInv`, and `productWeight_reflectLinkField_mirrorPlaquette_wilson`.
  Verification: direct file check, targeted module build, axiom audit, and aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
  This closes the Wilson/opposite inverse-representation bridge at the product-weight level: reflecting a Wilson plaquette product for `rho` becomes the mirrored product for the opposite inverse representation `rhoOppositeInv rho`. It still does not prove same-family reflection invariance, cut factorization, or RP-LINK.
- `TransferGapDefinition.lean`: D12 shell separating Gauss invariance, zero momentum, and trivial 't Hooft flux; `finiteMassGap` real-valued spectral-ratio definition (`-Real.log (lambda1 / lambda0)`) plus elementary log nonnegativity/positivity lemmas under `0 < lambda1 <= lambda0`. No transfer matrix construction, spectral theorem, or oracle-number evaluation is claimed.
  Verification: targeted check and aggregate GateYM build.
- `ReflectionCore.lean`, `ReflectionCutExample.lean`, `ReflectionWalk.lean`, `ReflectionEnsemble.lean`, `PlaquetteReflection.lean`, `PlaquetteReflectionEnsemble.lean`: link-reflection structure, two-layer cut sanity model, opposite-group reflected-walk theorem, reflection finite-sum change-of-variables, plaquette holonomy lift, product-weight reflection bridge, paired mirror-family constructor, mirror-stable-family product bookkeeping, and plaquette-ensemble numerator/expectation reflection lifts including paired-family specializations (`1033caa`, `4e3fcba`, `45eb172`, `eb0a90b`).
  Key names: `reflectLinkField_involutive`, `twoLayerCutReflection_cutLink`, `op_hol_reflectLinkField_mirrorWalk`, `reflectLinkFieldEquiv`, `expectation_observable_comp_reflectLinkField_of_weight_invariant`, `op_hol_reflectLinkField_mirrorPlaquette`, `productWeight_reflectLinkField_mirrorPlaquette`, `IsMirrorStableFamily`, `mirrorPairFamily_isMirrorStable`, `productWeight_reflectLinkField_of_mirrorStable`, `productWeight_reflectLinkField_of_mirrorPair`, `weight_reflectLinkField_of_mirrorStable`, `numerator_observable_comp_reflectLinkField_of_mirrorStable`, `expectation_observable_comp_reflectLinkField_of_mirrorStable`, `weight_reflectLinkField_of_mirrorPair`, `numerator_observable_comp_reflectLinkField_of_mirrorPair`, `expectation_observable_comp_reflectLinkField_of_mirrorPair`.
  Verification: targeted file/module checks, axiom audits, aggregate GateYM build. Axioms: `[propext]` or `[propext, Quot.sound]` for the reflected-step/walk/plaquette/product bridge facts.

### QCD1 and YM4 side lanes

- `Dov_sub_one_unitary`, `gamma5_mul_Dov_isHermitian` in `BanksCasherShadow.lean`.
  Verification: targeted check and aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `PolymerSystem` and `KPCondition` in `PolymerKPCriterion.lean`.
  Verification: targeted check and aggregate GateYM build. This is a statement freeze only; no cluster-expansion conclusion is claimed.

## 3. Aristotle registry final state

- `ac230cc8` `ym-ladder-strategy-20260703`: COMPLETE + HARVESTED. Findings drove sequencing: harden finite results, U(1) Fourier RP before Peter-Weyl, QCD1 before KP/Peter-Weyl, and keep finite-volume/finite-G disclaimers sharp.
- `cb437537` `ym3-semantic-redteam-20260703`: COMPLETE + HARVESTED. Findings integrated in `9c4b4d2`: TransferPositivity was renamed/re-scoped and one inert hypothesis removed.
- `9627f7ea` `ym1-fusion-2dexact-20260704` v1: CANCELED/IDLE after a real normalization bug was found. The v1 theorem had an extra `|G|` factor; trivial representation with `w=1` refutes it.
- `3435c7a3` `ym1-fusion-2dexact-20260704b` v2: COMPLETE + HARVESTED + INTEGRATED. Corrected statement removes the extra factor and preserves the oracle-pinned `h^-1 * A` convolution order. Integrated as `lemma2a_fusion_convolution` in `FusionConvolution.lean`; Aristotle reported axiom footprint `[propext, Classical.choice, Quot.sound]`.
- `203fd831` `gate-c2-flux2d-witness`: RUNNING at last poll; non-YM Gate C2 carryover, do not duplicate. See the T0 registry row in `LEDGER.md`.
- Older visible IDLE projects remain retired/previous-run-ledgered unless the user asks to reopen them.

## 4. Integration debt

- Finish finite-G Theorem 2 from `Theorem2AreaLaw.lean`: connect the normalized Wilson-weight convolution identity to lattice expectations by proving the tree-gauge independence layer and the partition/prefactor identification.
- Harvest `203fd831` when it completes; it is Gate C2, not tonight's YM ladder, but it is still owned by the carryover registry.
- RP-LINK is not assembled. Missing pieces: concrete reflection-stable plaquette-family instantiation, the same-family local compatibility needed by `PlaquetteReflectionEnsemble`, cut factorization, positive-side observable algebra, and PSD assembly. The Wilson/opposite inverse-representation bridge is now proved in `WilsonReflectionCompatibility.lean`.
- QCD1-i/ii are not proved. The banked C2/GW-circle facts need a designed `lambda_hat` spectral map and chiral-pairing theorem.
- KP conclusion is not proved. `PolymerKPCriterion.lean` freezes the condition; Ursell/cluster combinatorics and convergence statements are future infrastructure.
- Primary-source Osterwalder-Seiler PDF text was not extracted; LINK-vs-SITE geometry is strongly corroborated by secondary sources but still wants primary-source confirmation before paper claim language.

## 5. Decisions and reviews

- `design:ym3-unitarity`: adopted explicit unitarity hypotheses for Wilson representation facts; unitarizability remains future work.
- `review:t1-routeB`: ACCEPTED with scope note. Route B proves the PSD kernel engine, not the character-coefficient positivity/Bochner chain.
- `review:t2-even-cover-core`: ACCEPTED; follow-up added kernel-checked wraparound redundancy/global constancy lemmas.
- `idea:rp-link-scope`: accepted. RP-LINK proper needs the lattice probability/reflection/cut layer, not just more PSD algebra.
- `review:t3-general-gauge-core`: ACCEPTED; multiplication order and reverse-step convention checked.
- `review:reflection-core-first-pass`: ACCEPTED as finite scaffolding, with claim gate until reflection/source convention and downstream compatibility are checked.
- Reflection walk attempted theorem was rejected: naive nonabelian same-group inverse identity has an order obstruction. Correct formulation uses `MulOpposite`.
- `review:t2-lemma2a-aristotle-submission`: v1 rejected for normalization; corrected v2 `3435c7a3` succeeded and was integrated.
- `review:t3-plaquette-reflection`: ACCEPTED; then extended with product-weight bridge.
- No disagreements are parked for the user; the main open issues are ordinary integration debt above.

## 6. Build and hygiene status

- `lake build PhysicsSM.Draft.NullEdge.GateYM`: passed repeatedly; final aggregate was 8053 jobs with known unrelated warnings in Elitzur/Transfer/GateC2 files, pre-existing and unchanged by this run.
- `lake build`: passed after live-tree changes, 8295 jobs. Existing info/linter/deprecation messages appeared outside the new YM changes; no errors.
- `pre-commit run --all-files`: passed before the final commits.
- One stale-build near-miss was caught and fixed: `678b386` reported aggregate GateYM green while `lake env lean` on the just-edited `ReflectionWalk.lean` failed on a shadowed section variable; fixed in `1033caa`. Before promotion, rerun per-file `lake env lean` on files touched in the last review cycle.
- Baseline checks recorded at T0: GateYM build green, oracle v0.2 `validate_lgt_core.py` 36/36, Neo4j reachable, Aristotle list reconciled.
- Integrated Lemma 2a and iteration checks: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/FusionConvolution.lean`, `lake build PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution`, `lake env lean PhysicsSM/Draft/NullEdge/GateYM/Theorem2AreaLaw.lean`, targeted Theorem2AreaLaw build, axiom audits for the new fusion/iteration theorems, aggregate GateYM build, `pre-commit run --all-files`, and full `lake build` passed.

## 7. Ideas raised but out of scope

- U(1) Fourier RP as the next flagship route before full Peter-Weyl.
- Finite-G RP as a separate publication unit, but only with a sharp finite-volume disclaimer.
- Shared Schur/Hadamard PSD lemmas as future Mathlib upstream candidates.
- The remaining finite-G Theorem 2 assembly layer after the normalized Wilson convolution identity: expectation bridge, partition prefactor, and tree-gauge independence.
- Site reflection is distinct from link reflection and should not be mixed into the current RP-LINK layer.
- YM6 / continuum mass gap language must be re-audited in light of arXiv:2606.19362 before any summit-facing claims are made.

## 8. Recommended next three actions

1. Finish finite-G YM1 Theorem 2 around `Theorem2AreaLaw.lean`: prove the tree-gauge/independence bridge from `PlaquetteEnsemble` to `iterConv`, then discharge the partition-prefactor identification.
2. Instantiate the paired mirror-family constructor in a concrete lattice shape, use `WilsonReflectionCompatibility.lean` to connect the reflected Wilson product to the opposite inverse representation, then prove or correctly restate the same-family local compatibility needed by the plaquette-ensemble reflection lift. That is the closest YM3 paper unit after tonight's T3 work.
3. Poll/harvest `203fd831`; then restore the one-job Aristotle budget rule. The temporary lift paid off, but the v1 Lemma 2a bug showed why cross-review and narrow packages still matter.

## 9. Literature log summary

- Verified/cross-confirmed: Osterwalder-Seiler citation existence, Elitzur 1975, KP/Ueltschi criterion shape, Wegner 1971, Wilson 1974, Banks-Casher 1980, Jaffe-Witten/CMI rules, 2D YM rigorous constructions, Balaban/Magnen-Rivasseau-Seneor scope.
- Novelty check found no prior formalization of lattice gauge theory, Wilson-action gauge invariance, or interacting gauge-theory reflection positivity, but did find important adjacent art: Douglas et al. 2026 Lean formalization of free-field OS/GJ axioms and LeanMillenniumPrizeProblems statement-only work.
- Major caution: arXiv:2606.19362 claims a full SU(N) YM mass-gap/confinement construction. It is not treated as settled prior art, but the user should personally review it before the program's YM6/summit language is touched.
- LINK-vs-SITE reflection geometry: secondary sources strongly confirm link reflection cuts temporal links between time slices, matching `ReflectionCore.lean`'s no-on-plane-vertices design.
- No load-bearing new paper was ingested into Zotero/Neo4j tonight; the Faizal/Shabir paper was intentionally left for user review before ingestion.
