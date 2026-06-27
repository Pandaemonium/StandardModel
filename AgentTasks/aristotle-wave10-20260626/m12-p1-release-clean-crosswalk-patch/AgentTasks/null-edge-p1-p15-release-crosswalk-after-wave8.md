# M11 — P1 / P1.5 release crosswalk after Wave 8

Type: Manuscript / Audit. Wave 9, 2026-06-26.
Primary manuscript: `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`.
Plans: `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`,
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`.

The Lean kernel is the source of truth. No theorem statement was weakened. Where a
claim cannot be verified from the material in this package, the row is downgraded
rather than asserted; see the verification caveat below.

---

## 0. Verification caveat for this audit (read first)

This audit was performed against a **focused snapshot**
(`FOCUSED_PACKAGE_NOTE.md`), not the full `C:\Projects\StandardModel` repo. The
six Lean modules in scope are present and were inspected line-by-line. Each is
**free of `sorry`, `admit`, `axiom`, and `@[implemented_by]`** (verified by source
scan). However, several of them `import` modules that are **absent from this
snapshot** and therefore could not be kernel-rebuilt here:

| Present module | Absent import it depends on |
|---|---|
| `Spinor/PluckerObstruction.lean` | `PhysicsSM.Spinor.PluckerMass` |
| `Spinor/PluckerMassCovariance.lean` | (via `PluckerObstruction`) `PhysicsSM.Spinor.PluckerMass` |
| `Draft/NullEdgeSuperDiracSignBridge.lean` | `…SuperDiracSignAudit`, `…SuperDiracBlockCore`, `…SuperDiracProductGradingKrein` |
| `Draft/NullEdgeFlavoredChirality.lean` | `…TetrahedralHighMomentumNullBranch` |
| `Draft/NullEdgeInternalSpectrum.lean` | `PhysicsSM.StandardModel.AnomalyPackage` |
| `Draft/NullEdgeForbiddenCountertermCodim.lean` | (`import Mathlib` only — self-contained) |

Consequence for the crosswalk: a module being "sorry-free in source" is necessary
but **not sufficient** for a `trusted` label; the kernel rebuild under the pinned
toolchain (AGENTS.md prime directive, step 3) must be re-confirmed in the full
repo. Statuses below distinguish **`trusted (rebuild-pending)`** (source-clean,
needs full-repo kernel re-confirmation + convention banner) from **`draft`**
(kernel-clean experimental surface) and **`not present / audit`** (cannot be
located or verified).

---

## 1. Theorem-to-manuscript status table

Labels: **trusted** (kernel-clean, promoted surface, convention-documented),
**trusted (rebuild-pending)** (source-clean Wave-8 Spinor surface, awaiting
full-repo rebuild + convention banner), **draft** (kernel-clean, experimental
`PhysicsSM.Draft.*`), **audit** (claimed but not verifiable / module absent),
**conceptual** (prose target, no Lean), **future** (gated, no Lean yet),
**not present** (named module/declaration not in repo snapshot).

### 1a. P1 core — finite Plücker mass (already in manuscript §12)

| Manuscript claim | Lean declaration | Manuscript label | Audited label |
|---|---|---|---|
| single null edge is massless | `det_rankOneHermitian_eq_zero` | trusted | trusted¹ |
| two-edge mass = squared wedge | `two_edge_plucker_mass_identity` | trusted | trusted¹ |
| two-edge massless iff wedge zero | `two_edge_mass_zero_iff_wedge_zero` | trusted | trusted¹ |
| wedge zero iff collinear | `spinorWedge_eq_zero_iff_exists_smul_…` | trusted | trusted¹ |
| finite bundle mass = pairwise spread | `fin_bundle_plucker_mass_identity` | trusted | trusted¹ |
| det mass real, nonnegative | `fin_bundle_det_im_eq_zero` / `_det_re_nonneg` | trusted | trusted¹ |
| massless iff common direction | `fin_bundle_mass_zero_iff_common_direction` | trusted | trusted¹ |

¹ Lives in `PhysicsSM.Spinor.PluckerMass`, which is **not in this snapshot** but
is a genuine trusted anchor in the full repo (the present Wave-8 Spinor files
`open` and build on it). M10 did **not** flag these rows. Label retained as
trusted on the strength of the full-repo provenance; flagged here only so the
reviewer re-confirms the rebuild when integrating.

### 1b. P1 covariance / obstruction — **new Wave-8 trusted-grade Spinor files**

These declarations are *present and source-clean in this snapshot*. They are the
ones that change P1 readiness (§3).

| Claim | Lean declaration (file) | Audited label |
|---|---|---|
| B_Pl (two-edge) = Re det of momentum | `twoEdgeObstruction_eq_det_re` (`PluckerObstruction`) | trusted (rebuild-pending) |
| B_Pl (bundle) = Re det of momentum | `bundleObstruction_eq_det_re` (`PluckerObstruction`) | trusted (rebuild-pending) |
| B_Pl = 0 ⇔ massless (bundle) | `bundleObstruction_eq_zero_iff` | trusted (rebuild-pending) |
| B_Pl = 0 ⇔ common null direction | `bundleObstruction_eq_zero_iff_common_direction` | trusted (rebuild-pending) |
| masslessness-obstruction interface | `MasslessObstruction`, `bPlTwoEdge`, `bPlBundle` | trusted (rebuild-pending) |
| SL(2,ℂ) invariance of wedge | `spinorWedge_sl2_invariant` (`PluckerMassCovariance`) | trusted (rebuild-pending) |
| SL(2,ℂ) invariance of B_Pl | `twoEdgeObstruction_sl2_invariant`, `bundleObstruction_sl2_invariant` | trusted (rebuild-pending) |
| SL(2,ℂ) invariance of det-mass | `finBundleMomentum_det_sl2_invariant` | trusted (rebuild-pending) |
| SL(2,ℂ) invariance of massless locus | `pairwiseWedgeZero_sl2_iff` | trusted (rebuild-pending) |

### 1c. Companion / artifact rows (manuscript §12)

| Claim | Lean declaration | Manuscript label | Audited label |
|---|---|---|---|
| celestial moment form (E²−|C|²)/4 | `pluckerMass_eq_energy_sq_sub_closureDefect_sq` | artifact* | artifact (standalone) — unchanged |
| closed fan is rest frame | `closed_spinorFan_is_restFrame` | artifact* | artifact (standalone) — unchanged |
| Dirac slash squares to mass | `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass` | draft** | draft (`NullEdgeBundleDiracPluckerCore`) — unchanged |

### 1d. Twistor rows — **M10 over-marking correction (§2)**

| Claim | Lean declaration | Manuscript label | Audited label |
|---|---|---|---|
| two-twistor mass = wedge | `two_twistor_mass_invariant_eq_plucker` | trusted | **audit — module not located** |
| multi-twistor mass = pairwise | `multi_twistor_momentum_det_eq_pairwiseMass` | trusted | **audit — module not located** |

### 1e. Wave-8 draft modules not yet in the manuscript map

| Concept | Lean declaration(s) (file) | Audited label | Gate |
|---|---|---|---|
| safe `+Φ²` vs tachyonic `−Φ²` sign bridge (abstract) | `super_dirac_sign_bridge`, `super_dirac_square_sum_safe` (`NullEdgeSuperDiracSignBridge`) | draft | Gate A |
| concrete `Deg×Chir` realization, `Γ_s≠χ_E`, ±1 witness | `productGrading_concrete_bridge`, `massBlock_bridge`, `gammaS_ne_chiE` | draft | Gate A |
| naive `Γ_s` index blind, flavored `Γ_f` index sees | `gateC_naive_blind_flavored_sees` (`naive_index_zero` ∧ `flavored_index_ne_zero`) (`NullEdgeFlavoredChirality`) | draft | Gate C (mechanism, **not** release) |
| `Γ_f = Γ_s·T`, five distinct gradings | `GammaF_eq_GammaS_mul_tasteT`, `GammaS_ne_tasteT`, `GammaF_ne_chiE`, … | draft | Gate C |
| taste corner ↔ proven high-momentum null branch | `tasteCorner_high_momentum_null` | draft | Gate C |
| anomaly inheritance over one-generation table | `anomalyFree_of_realizesOneGeneration`, `nGenerations_localAnomalyFree` | draft | internal-spectrum API |
| Furey as one realization (not an assumption) | `fureyStyleRealization_anomalyFree` | draft | internal-spectrum API |
| χ_E-odd ⇒ diagonal blocks vanish; bare same-Weyl mass unrepresentable | `odd_diag_left_zero`, `isOdd_iff_offDiagonal`, `diag_left_nonzero_not_odd` (`NullEdgeForbiddenCountertermCodim`) | draft | codimension (P2/Gate F precursor) |
| forbidden-counterterm codimension = (card L)²+(card R)² | `forbidden_counterterm_codimension` | draft | codimension (P2/Gate F precursor) |

---

## 2. Twistor over-marking correction (Task 2)

**Finding.** The manuscript header (lines 9–19) lists
`PhysicsSM.Spinor.TwistorPluckerMass` among "Lean anchors (trusted unless noted)"
and asserts it was "re-verified to kernel-check"; §8 (lines 586–605) and the §12
map rows for `two_twistor_mass_invariant_eq_plucker` and
`multi_twistor_momentum_det_eq_pairwiseMass` carry the **trusted** label. M10
flagged these as over-marked because the twistor module is **not present**.

**This audit cannot independently confirm presence either** — the module is not in
this snapshot, and (unlike `PluckerMass`) no present file imports or `open`s it, so
there is no provenance chain to it from the verified surface. Under the AGENTS.md
prime directive ("trusted only when the proof is accepted by the kernel and builds
under the pinned toolchain"), an unlocatable module cannot keep a `trusted` label.

**Decision (conservative).** Downgrade both twistor rows and the header anchor from
**trusted** to **audit — module not located**, with a footnote that the trusted
label may be *restored verbatim* once `PhysicsSM.Spinor.TwistorPluckerMass` is
confirmed to kernel-build in the full repo. This neither deletes the rows nor
asserts they are false; it removes an unverifiable trust claim. Exact edits in §6.

Rows correctly marked already (no change): the celestial-moment **artifact***
rows, the **draft\*\*** Dirac-slash row, and the SL(2,ℂ) draft row (the last is
*upgraded* in §3, not because of M10).

---

## 3. How the new Plücker trusted files change P1 readiness (Task 3)

The two present Wave-8 Spinor files (`PluckerObstruction`, `PluckerMassCovariance`)
materially strengthen P1 in three ways:

1. **The SL(2,ℂ) covariance row stops being a draft.** §12 currently marks
   `finBundleMomentum_det_sl2_invariant` as **draft\*\*** ("kernel-clean draft in
   `PhysicsSM.Draft.*`"). It now lives in the trusted-grade Spinor file
   `PluckerMassCovariance.lean`, together with invariance of the wedge, of B_Pl,
   and of the **massless locus** (`pairwiseWedgeZero_sl2_iff`). This converts the
   manuscript's "frame/Lorentz covariance" claim from a draft caveat into a
   trusted-grade row — i.e. P1 can state Lorentz invariance of the mass and of
   masslessness as a checked theorem, not an appendix promise.

2. **The "obstruction" framing the manuscript wants is now first-class.**
   `PluckerObstruction` packages B_Pl = Re det as a reusable `MasslessObstruction`
   structure that vanishes exactly on the collinear/zero-spread locus and is
   nonnegative. This is precisely the "quadratic obstruction to remaining a single
   free gapless null mode" language used in the Working Plan (§17) and lets P1 use
   one uniform interface for the two-edge and bundle cases.

3. **Net effect on readiness:** the trusted Plücker theorem already "carries the
   paper by itself" (manuscript §14.1); these files remove the two weakest
   caveats (covariance was draft; obstruction framing was prose). They do **not**
   by themselves clear submission, because **both files still need the
   machine-checkable convention banner** (Wave-8 summary; AGENTS.md step 5) and a
   full-repo kernel rebuild. So they move P1 from "ship with caveats" to
   "**ship after convention banners**," not "ship now."

**Acceptance criterion for promoting 1b rows to plain `trusted`:**
(a) full-repo `lake env lean` rebuild clean under `leanprover/lean4:v4.28.0`;
(b) a machine-checkable convention banner present in each Spinor file fixing
metric `(+,−,−,−)`, bispinor `ψψ†`, det-vs-trace mass normalization, and SL(2,ℂ)
`det A = 1`; (c) `#print axioms` on the head theorems shows only
`propext`/`Classical.choice`/`Quot.sound`.

---

## 4. Where the Gate A bridge belongs (Task 4)

**Module:** `NullEdgeSuperDiracSignBridge.lean`. Content is **finite ring / matrix
algebra**: with two distinct involutive gradings `Gs` (commuting) and `Xe`
(anticommuting), `(Gs·Φ)² = +Φ²` while `(Xe·Φ)² = −Φ²`
(`super_dirac_sign_bridge`), plus a finite-sum version and a concrete `Deg×Chir`
realization with `Γ_s ≠ χ_E` and an explicit ±1 witness. The docstring is explicit
that **no continuum claim is made**.

**Decision.**
- **The abstract/finite sign theorem → P1 appendix, as a convention anchor.**
  P1's headline observable is the determinant mass, i.e. a *square*. The sign
  bridge is exactly the statement that the safe convention pairs the mass block
  with the grading it **commutes** with, giving `+Φ²`, and that conflating
  `Γ_s := χ_E` is what produces the tachyonic `−Φ²`. This is the convention-freeze
  content of **Gate A** in the Working Plan (§20.3). Including it as a short,
  clearly-labeled P1 appendix banner (not in the main P1 claim chain) anchors the
  sign convention the P1 determinant-mass square implicitly uses, at zero risk: it
  is finite algebra with an explicit witness.
- **The operator-level super-Dirac square (`D = i D_N + Γ_s Φ_H`, `D² = −K −C −T
  +Φ²`) → P2.** Anything that asserts the *physical* operator forces this sign, or
  introduces `D_N`/kinetic normalization dynamically, is Gate B/Gate D territory
  and must not enter P1's trusted claim.
- **Not P1.5.** P1.5 is the Yukawa/Higgs *mechanism* toy-theorem package (Working
  Plan §17.3); the abstract sign bridge is a convention lemma, not a mass
  mechanism, so it does not belong there.

**Caveat to honor in the appendix wording:** label it *draft, kernel-clean* (it
imports the absent `…SuperDiracSignAudit/BlockCore/ProductGradingKrein` trio and
must be rebuilt in the full repo). Claim boundary: "fixes the +Φ² sign
convention," **not** "derives the Standard-Model mass term."

---

## 5. How much of the flavored-chirality result can be stated (Task 5)

**Module:** `NullEdgeFlavoredChirality.lean`. Verified finite facts:
`naive_index_zero : tr(Γ_s·P_null)=0`, `flavored_index_eq_four :
tr(Γ_f·P_null)=4`, hence `gateC_naive_blind_flavored_sees`; plus `Γ_f = Γ_s·T`,
the five gradings provably distinct, and `tasteCorner_high_momentum_null` linking
each taste index to an *already-proven* high-momentum null branch (reused, not
re-proved, from `TetrahedralHighMomentumNullBranch`).

**What may be stated (P1.5 / P2 methodological note, conservative):**
> "A naive spacetime-chirality index `tr(Γ_s P_null)` can vanish by mirror
> cancellation on the four high-momentum null branches while a flavored index
> `tr(Γ_f P_null) = Γ_s·T` is nonzero on the *same* set. Hence a `Γ_s`-only
> 'index = 0 ⇒ no doubling' argument is finitely rejectable."

This is a **finite no-go / kill-switch witness**: it shows a *particular release
argument is invalid*. It is honest to present as such.

**What may NOT be stated:** that Gate C is released/cleared, or that the doubling
question is resolved. The module docstring itself records the live blocker: the
sign patterns `g5`, `tau`, `Pnull` are **model inputs** realizing the BCK
minimally-doubled scenario; **which sign pattern the full operator forces is
unproven**. So the mention must be framed as "Gate C remains a genuine kill
switch; the naive index is insufficient," never "Gate C passes." Keep it out of
P1; it is a P1.5/P2 methodology remark at most.

**Failure criterion (would invalidate the mention):** if the full operator forced
a taste involution misaligned with the chirality grading, `tr(Γ_f P_null)` could
vanish too — exactly the unproven input. So the note must stay conditional on the
explicit model inputs.

---

## 6. Exact manuscript edits / patch plan (Task 6)

All edits are in `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`. Edits
**A** and **B** are corrections (claim accuracy) and have been **applied** by this
job; edits **C–E** are additive recommendations left for the manuscript owner.

**A. (applied) Header anchor downgrade, lines 9–19.** Move
`PhysicsSM.Spinor.TwistorPluckerMass` out of the "trusted unless noted" list and
mark it `(audit — module not located in Wave-9 snapshot; restore trusted on
full-repo rebuild)`. Soften the provenance sentence so it no longer asserts the
twistor module was re-verified.

**B. (applied) §12 map: twistor rows.** Change the **Status** column of
`two_twistor_mass_invariant_eq_plucker` and
`multi_twistor_momentum_det_eq_pairwiseMass` from `trusted` to `audit***`, and add
a third footnote:
`*** module PhysicsSM.Spinor.TwistorPluckerMass not located in the Wave-9 audit
snapshot; restore "trusted" verbatim once it kernel-builds in the full repo (M10).`

**C. (recommended) §12 map: upgrade the SL(2,ℂ) row.** Change
`finBundleMomentum_det_sl2_invariant` from `draft**` to `trusted (rebuild-pending)`
and add new rows for `spinorWedge_sl2_invariant`, `bundleObstruction_sl2_invariant`
and `pairwiseWedgeZero_sl2_iff`, citing `PhysicsSM.Spinor.PluckerMassCovariance`.
Add B_Pl rows from `PluckerObstruction` (`bundleObstruction_eq_det_re`,
`bundleObstruction_eq_zero_iff_common_direction`, `MasslessObstruction`).

**D. (recommended) New appendix "Convention anchor: the +Φ² sign."** One
paragraph citing `super_dirac_sign_bridge` / `productGrading_concrete_bridge`
(draft, kernel-clean), labeled as Gate-A convention freeze, with the explicit
claim boundary from §4 above. Place after §13 (Conventions table).

**E. (recommended) One methodology sentence in §14 (or a P1.5 stub).** Add the
flavored-chirality kill-switch remark from §5, explicitly stating "Gate C remains
a kill switch; not released."

---

## 7. Release recommendation

**Ship P1 after convention banners.** Not "ship now" (two trusted-grade Spinor
files still lack machine-checkable convention banners and a full-repo rebuild, and
the twistor over-marking must be corrected first — edits A/B applied here). Not
"hold for a missing theorem" (no missing theorem blocks the P1 headline: the
trusted Plücker determinant-mass identity + the new SL(2,ℂ) covariance +
obstruction interface are sufficient for the finite-kinematics claim).

Concretely, the gate to submission is:

1. **(blocking)** Full-repo `lake env lean` rebuild of `PluckerObstruction` and
   `PluckerMassCovariance` clean under `leanprover/lean4:v4.28.0`, with
   machine-checkable convention banners added (metric, bispinor, det-vs-trace,
   SL(2,ℂ) det = 1); `#print axioms` clean.
2. **(blocking)** Apply edits A/B (twistor downgrade) — done here — and confirm
   whether `TwistorPluckerMass` exists in the full repo; if yes, restore those two
   rows to trusted (edit reversal), if no, §8 substitution holds.
3. **(recommended)** Apply edits C–E.

**P1 may safely claim:** matter mass = finite Plücker spread = Re det of the summed
null bispinor; massless ⇔ collinear/common-direction; reality and nonnegativity;
SL(2,ℂ) (Lorentz) invariance of mass and of the massless locus; the
masslessness-obstruction interface. All finite, kinematic, kernel-checked.

**P1.5 may claim (as reconstruction toy theorems, not predictions):** the
internal-spectrum anomaly-inheritance API (Furey as *one* realization, not an
assumption); the χ_E-odd forbidden-counterterm structure and its codimension
`(card L)²+(card R)²`; and — as a *methodology* remark only — the flavored-chirality
kill-switch witness. The Gate-A `+Φ²` sign bridge may appear as a convention
appendix in P1 or P1.5.

**Remains P2 / Gate C / Gate F (no release language):** the operator-level
super-Dirac square and kinetic normalization (Gate B/D, P2); Gate C release
(which sign pattern the full operator forces is unproven); any prediction or full
unification claim (Gate F, `rank(dF) < dim M_EFT`). Prediction language stays off.

---

## 8. Next Lean targets (priority order)

1. **Convention-banner lemmas** for `PluckerObstruction` /
   `PluckerMassCovariance`: a small `#eval`/`decide`-checkable banner term or a
   `theorem … : conventionTag = …` so the metric/bispinor/normalization choices
   are machine-checkable, not just prose. (Unblocks promotion of 1b rows.)
2. **Locate or rebuild `TwistorPluckerMass`** in the full repo; if absent, either
   restore it or re-derive the two twistor rows from `PluckerMassCovariance`
   (the `n = 2` and multi-edge cases are already trusted-grade there).
3. **Gate A operator step (P2):** state `D = i D_N + Γ_s Φ_H` over an explicit
   finite carrier and prove `D² = +Φ² + (kinetic/curvature/torsion)` with the
   correct sign, upgrading `super_dirac_square_sum_safe` from abstract gradings to
   a fixed operator. This is the P1→P2 transition flagged in manuscript §14.4.
4. **Gate C forcing (open blocker):** a theorem that the *full* operator forces a
   taste involution aligned with chirality (i.e. derive, not assume, the
   `g5`/`tau`/`Pnull` sign pattern). Until then `gateC_naive_blind_flavored_sees`
   stays a kill-switch witness, not a release.

---

## 9. Axiom / convention dependency notes

- All six present modules: no `sorry`, `admit`, `axiom`, `@[implemented_by]`
  (source scan). `#print axioms` could not be run here (absent imports); expected
  to reduce to `propext`/`Classical.choice`/`Quot.sound` (the Spinor files are
  noncomputable/Classical via Mathlib `Matrix`/`Complex`; `Forbidden…Codim` uses
  `Module.finrank` quotient machinery — Classical).
- `NullEdgeFlavoredChirality` index proofs use `decide`/`norm_num`/`norm_cast` on
  explicit `Fin 4 × Fin 4` matrices — finite, no nonstandard axioms expected.
- Convention dependencies to surface in banners: metric `(+,−,−,−)`; bispinor
  `ψψ†`; mass = det (vs trace-pairing `2·det`); SL(2,ℂ) `det A = 1`; in the Gate-A
  files the strict separation `Γ_s ≠ χ_E` (the entire `+Φ²` vs `−Φ²` dichotomy
  rests on it — `gammaS_ne_chiE`, `GammaF_ne_chiE`).

## Acceptance / failure criteria summary

- **Accept P1 for submission** when: §7 items 1–2 done; B_Pl + covariance rows
  promoted; twistor rows corrected; prediction language absent.
- **Fail / hold** if: any Spinor head theorem fails the full-repo rebuild; a
  convention banner is missing; or any twistor/Dirac-slash row is left labeled
  `trusted` without a located, kernel-building module.
- **Gate C release is explicitly NOT claimed** in P1 or P1.5; the flavored-index
  result is a kill-switch witness only.
