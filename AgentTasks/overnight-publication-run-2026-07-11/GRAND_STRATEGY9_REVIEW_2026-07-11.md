# codex-pub-grand-strategy9 — freeze-aware grand strategy and hostile semantic audit
Review-only. Kernel is source of truth. Freeze 06:30 PDT, hard audit 07:00 PDT.
Verbatim Lean read: `PlueckerCausalCone.lean`, `HalfWindingFieldPositionClassification.lean`,
`ChannelCommutatorSelectorClassification.lean`, `ChannelKreinSectorSignature.lean`,
`ChannelQuadraticInnerLift.lean` (imports to `PhysicsSM.Draft.NullEdge.*` are outside the
supplied tree, so I could not re-run `lake`; the `#print axioms` guard blocks embedded in each
file are the pinned evidence and are quoted below).

Binding rule used throughout: **an exact finite theorem is not a physical identification, a
continuum result, or an empirical prediction.** Every ranking, verdict, and headline below is
tagged to that boundary.

---

## 0. Decisive freeze-aware theorem ranking

Kernel-footprint legend (verified from the guard blocks):
- **K** = kernel-only `[propext, Classical.choice, Quot.sound]`.
- **K+E** = compiled evaluator, adds `[Lean.ofReduceBool, Lean.trustCompiler]` (i.e. `native_decide`).
- **T|H** = conditional/continuum (physical-identification boundary), not a closed finite theorem.

### Tier 1 — kernel-only, exact, load-bearing, publishable at freeze
1. **A / canonical rest operator + uniqueness.** `pair_diracSymbol_sq`,
   `oddHermitian_eq_massOperator`, `massOperator_sq_eq_momentum_det`, `hermitian_uniqueness`
   (K). *This is the spine of the whole program.* Finite-theorem side only: canonical odd
   Hermitian operator with no independent mass parameter in the fixed two-channel class. **Not** a
   mass-value prediction and **not** an `N>2` Clifford classification.
2. **A / complete all-zone crossing classification + no-gap.** `FullBlochZeroClassification.
   zeroModePolynomial_eq_zero_iff`, `piModePolynomial_eq_zero_iff`, `FullBlochSplitPlus/Minus`
   det factorizations, `no_nonzero_stationary_scale` (K). Strongest *self-limiting* result: the
   framework proves its own doubling/no-gap obstruction. High referee value (answers R3 partially).
3. **E / exact scheduled strong-CAR support.** `bKickL_CARSupported`, `heisenStep_CARSupported`,
   `heisenFoldBlocks_CARSupported`, `bKickL_commute_disjoint`, `bKickL_involutive`,
   `witBlocks_commute` — all guarded **K**. The `numberOp` demotion of `FootprintIn`
   (`footprintIn_numberOp` vs `not_CARSupported_numberOp`, K) is a genuine nonvacuity control.
   Boundary: support lands in `coneRegion = ⋃ blocks`, an **algebraic support envelope, not a
   bounded-speed causal cone** (no graph metric, no radius-by-time; `heisenStep = g∘A∘g` is
   Heisenberg conjugation only at unit phase where `bKickL_involutive` applies).
4. **E / separation from free lifts.** no-`Γ(U)` and no-one-body-generator theorems (`PlueckerPairKickNonQuasiFree`, `PlueckerQuarticNotOneBody`). Exact and decisive that the pair kick is genuinely quartic/interacting.
5. **F / commutator-blind scalar classification + Krein signature + variational family** (all
   guarded **K**): `selector_factors_through_trace` and `no_commutatorBlind_selector_injective`;
   `even_selfadjoint_exists_normalForm`, `normalForm_coordinates_unique`, `normalForm_gram`,
   `negative_plane_strict` (the exhaustive `4+/2−`, self-pairing `a²+d²+e²+g²−2b²−2f²`);
   `weighted_completion_identity`, `selected_unique_of_cost_le`, `positive_metrics_disagree`.
   These are the strongest *no-go / classification* results in the portfolio.
6. **C / same-winding equality.** `winding_witness_eq_counterexample` (K): fields 11 and 2 both
   have derived total turning `2π`. This is the kernel-clean half of Paper C's headline.

### Tier 2 — compiled evaluator (K+E), exact but with a wider trust base
7. **C / four-site discriminant + winding-insufficiency.** `discriminant`/`discriminant_bool`,
   `corrected_bridge`, `selfadj_iff_involution`, `naive_bridge_false`, `winding_blind_to_signature`,
   `counterexample_sector_no_pos`, `counterexample_sector_no_neg` — **K+E** (`native_decide` over
   16 rational fields; guards show `ofReduceBool, trustCompiler`). The positional discriminant
   (two walls ∧ `fixedSingleton = false`) is exact and noncircular (field-level datum). **Hard
   boundary: `counterexample_sector_no_{pos,neg}` are statements about the 4×4 compression `Mof`,
   not the full 8-dim walk `Wof`.**

### Tier 3 — conditional / continuum (physical-identification boundary)
8. **A / continuum control.** `fixed_time_many_step_bound`,
   `walk_error_eLpNorm_tendsto_zero_on_compact_support_any_time`, `band_approx_tendsto_zero`
   (**T|H**). Fixed-symbol/compact-support only; **not** a position-space PDE limit.
9. **A / operational phase witness.** `witness_survival_probability` (`4/5` vs `1`). Exact finite,
   but it is a *witness that the phase is carried*, **not** a proof the free walk forces the
   interaction.

**Freeze verdict:** the program is carried by Tier-1 kernel results. Do not let any headline rest
on a Tier-2 result without the "compiled-evaluator" label, and do not let any headline rest on a
Tier-3 result at all.

---

## 1. Three highest-impact exact targets before 06:30 (one decisive, two insurance)

### PRIMARY (decisive) — E: graph-metric radius-by-time CAR cone
- **Statement shape.** Fix `ι = Fin N` with chain metric `d i j = |i−j|`. Add a *contiguity*
  hypothesis: each `block m` is an interval of width `≤ w`. For a *layered* schedule `ms` prove
  `CARSupported (Metric.ball R (w * ms.length)) (heisenFoldBlocks u ms A)` given `CARSupported R A`
  — i.e. support radius grows by at most `w` per layer (Lieb–Robinson / QCA cone).
- **Required seeds.** `bKickL_CARSupported`, `heisenStep_CARSupported`,
  `heisenFoldBlocks_CARSupported`, `block`, `coneRegion` (all present, K). New: an interval-block
  predicate and a `coneRegion ⊆ metric-ball` lemma; unit-phase hypothesis on `u` (so `bKickL` is
  the involution `bKickL_involutive` and `g∘A∘g` is real Heisenberg conjugation).
- **Mandatory nonzero witness.** `witBlock`/`witBlocks_commute` reused: an `R`-supported observable
  that is genuinely moved by an adjacent interval gate, still commuting with generators outside the
  grown ball.
- **Mandatory negative control.** (a) `numberOp` (`FootprintIn ∅` yet `¬CARSupported ∅`) — footprint
  ≠ locality; (b) an explicitly *non-contiguous* block schedule for which the ball bound fails,
  proving contiguity is load-bearing.
- **Licensed sentence.** "A layered schedule of contiguous finite-range unit-phase Plücker
  pair gates propagates strong CAR support at bounded speed: the Heisenberg image of an
  `R`-supported even observable after `t` layers is supported within graph radius `w·t` of `R`."
  This is the only landable target that converts E from *algebraic support* to a genuine
  physics-grade causal cone.

### INSURANCE 1 — C: promote the counterexample to a full-walk no-mode
- **Statement shape.** `(Wof 2 - 1).det ≠ 0 ∧ (Wof 2 + 1).det ≠ 0` (8×8 rational `native_decide`),
  giving *no full-walk* `±1` mode for field 2, while field 11 keeps a genuine mode.
- **Seeds.** `Wof`, `Mof` already defined; mirror `counterexample_sector_no_{pos,neg}` at 8×8.
- **Witness / control.** field 11 (`twoWall_protected_modes` / `WallModeWitness`) has the mode;
  field 2 has none — a clean present/absent pair.
- **Licensed sentence.** "Same derived `2π` winding, yet the full eight-dimensional walk of the
  counterexample carries no `0` or `π` mode." **Removes Paper C's single most-cited hedge**
  (compressed-sector ≠ full-walk). K+E, low risk, high value.

### INSURANCE 2 — F: instantiate the resolved quotient with the trace selector
- **Statement shape.** Apply `ChannelSelectorQuotient.quotientEquivRange` to the commutator-blind
  functional classified as `(f(1)/4)·trace`: the resolved quotient of the ambiguity group is
  exactly the one-dimensional trace class.
- **Seeds.** `selector_factors_through_trace`, `quotientEquivRange`, `classOf_eq_iff`.
- **Witness / control.** `traceZeroDirection_nonzero` (nontrivial kernel) vs a trace-separated pair.
- **Licensed sentence.** "Under commutator-blindness the entire selector-resolution collapses to
  the one-dimensional trace quotient." Cheap; **strengthens the F no-go core, does not open the
  positive gate.** Rank lowest — it is close to supplied-structure bookkeeping.

Prefer the PRIMARY target and hold both insurance targets as fallbacks if it stalls.

---

## 2. Best use of the remaining window + opportunity cost

**Spend the window on the E graph-metric cone.** It is the only remaining move that adds a *new
capability* rather than reinforcing a closed result, and it is the only one that unlocks a distinct
morning headline (Task 6b). The support algebra is already kernel-clean, so the delta is purely a
metric/contiguity layer — realistic before 06:30.

Opportunity cost:
- **F intrinsic positive selector** is the wrong bet tonight. The literature log (Krein
  `1812.00038`, Petz/Chentsov, Yamaguchi–Mitsuhashi `2411.04766`) shows positivity requires a
  *chosen fundamental symmetry* — deriving one non-circularly is exactly the open gate, with high
  circularity risk and low probability by freeze. `ChannelKreinMetricNoGo` already proves the
  nearest candidate fails. Attempting it burns the window and likely lands nothing.
- **C derived defect-mode bridge** (deriving the reflection/positional datum from the Plücker
  carrier) is valuable but strictly *incremental*: C is already a strong finite obstruction paper.
  The cheap C insurance (full-walk no-mode) captures most of its remaining value at a fraction of
  the cost; the general-`L` index and carrier-derived reflection structure are next-week theorems,
  not freeze targets.

Net: E cone as the one swing; C full-walk no-mode as guaranteed-progress insurance; skip the F
positive selector until a non-circular fundamental symmetry is in hand.

---

## 3. Paper F publication verdict

**Verdict: a coherent *standalone no-go / classification* paper spine — more than an appendix,
not yet a positive-result paper.** The landed set (type-only zero-sum torsor + shear subgroup;
descent kernel criterion; solder-degree and trace-profile kills; `ChannelKreinMetricNoGo`;
`ChannelKreinSectorSignature` exhaustive `4+/2−`; `ChannelCommutatorSelectorClassification`
trace-factorization; inner-product variational family with `positive_metrics_disagree`) is a
self-contained, mutually reinforcing obstruction theory. It clears the "coherent paper" bar as a
*negative* result; it fails it as a *selection* result.

**Shortest honest route to standalone.** Retitle and reframe around the obstruction, e.g. "No
canonical channel selector from the retained Krein–Dirac structure: an exhaustive moduli-and-
obstruction classification." Payload = (i) torsor/shear moduli of admissible refinements; (ii)
descent kernel criterion for intrinsicality; (iii) the exhaustive `4+/2−` even-sector signature;
(iv) commutator-blind linear selectors ≡ trace (hence none injective); (v) variational
metric-dependence (`positive_metrics_disagree`) *as the punchline that positivity alone does not
canonicalize*. Position against Ackermann–Tolksdorf generalized Lichnerowicz and the Krein
fundamental-symmetry literature (already logged). This needs **no new theorem** — only reframing.

**The exact claim that must remain absent.** Do not assert, anywhere, that a positive selector /
metric / fundamental symmetry / permutation symmetry / named-channel span is *physically or
information-theoretically derived* or that the aperture/closure/turn split is *canonically
selected*. Keep the scope qualifier "rational-linear scalar" on the commutator-blind classification
(the `dfe5e4dc` audit's binding warning). A positive/derived-selector claim is the one sentence that
would turn a correct no-go paper into an overclaim.

---

## 4. Five most dangerous surviving semantic overclaims

1. **"Causal cone" attached to the E support results.** Location: module name
   `PlueckerCausalCone.lean`; `coneRegion`; portfolio "Paper E … causal-cone" prose;
   `ARTIFACT_MANIFEST` row "Plücker pair layer and exact scheduled CAR support." The theorem proves
   support in `⋃ blocks` for *arbitrary* embeddings/schedules — **no bounded speed**. The Lean file
   is scrupulously honest ("NOT a causal cone"), so the danger is any prose or name that inherits
   "cone." **Replacement:** "scheduled CAR **support envelope**"; reserve "causal cone" for a proved
   radius-by-time theorem (Task 1 PRIMARY).
2. **"Protected" modes in Paper C.** Location: Lean name `twoWall_protected_modes`; defect-paper
   Theorem "Explicit defect/control separation." The modes are exact and *pinned* by the involutive
   compression, but no stability/perturbation theorem exists (lit log: topological protection is
   established elsewhere and **open/refuted** here). **Replacement:** "exact **pinned** `0/π`
   modes"; drop "protected" until an in-class stability theorem lands.
3. **Compressed-sector no-mode read as full-walk no-mode (C).** Location: defect-paper
   "Same winding, different compression signature" and its release framing;
   `counterexample_sector_no_{pos,neg}` act on the 4×4 `Mof`, not `Wof`. Any sentence that the
   counterexample *walk* has no mode is unproven. **Replacement:** always say "the counterexample's
   **compressed sector** has neither sign mode; full-walk status is open" — or close it via Task 1
   INSURANCE 1 and then upgrade the prose.
4. **"Mass … is an output of null-spinor geometry" (Paper A, abstract opening).** Location: first
   sentence of the abstract. The kernel gives a *canonical identification with no free parameter*,
   not a numerical mass prediction; the abstract itself later concedes "any absolute mass scale
   remain open." As a hostile referee the opening verb "output" is the most quotable overclaim.
   **Replacement:** "the rest gap is **identified with** the null-spinor area — no independent mass
   parameter enters, and no absolute scale is predicted."
5. **"Every finite statement … is checked in Lean 4" / "kernel-checked" without the trust split
   and the missing core.** Location: Paper A abstract closing line; `ARTIFACT_MANIFEST` (R6 MAJOR-1
   notes `two_edge_plucker_mass_identity` was absent from the audit package; no clean Linux/archival
   build). Several exact results are **K+E** (`native_decide`), not kernel-only, and must not be
   called "kernel-only." **Replacement:** adopt the defect paper's discipline everywhere —
   `Kernel` (`propext, Classical.choice, Quot.sound`) vs `Kernel+Eval` (adds
   `ofReduceBool, trustCompiler`); ship the *complete buildable source incl. the trusted core*; and
   qualify "machine-verified" until a clean scoped Linux build exists.

---

## 5a. 06:30 PDT freeze checklist
- [ ] **Freeze the claim set.** No new theorem statements after 06:30; `MANUSCRIPT_CLAIM_MATRIX`
      and `PAPER_GATE_MATRIX` snapshotted and tagged.
- [ ] **Authoritative verifier.** Run `python Scripts/publication/verify_null_edge_paper_a.py`
      twice; confirm 41 modules + aggregate guard PASS and `summary.json` SHA-256 ==
      `D59DF57A2255C77BBC146F1D77A1E6D6E823BF082483D96E1B63A27C024C1C41` on both runs.
- [ ] **Placeholder scan.** `grep -rn "sorry\|admit\|axiom \|@\[implemented_by\]"` over the release
      tree → empty. (Supplied `*.lean` are clean; re-check the full corpus.)
- [ ] **Axiom-footprint enumeration.** For every headline declaration run `#print axioms`; classify
      each as `Kernel` or `Kernel+Eval`; enumerate every `native_decide` and confirm the prose
      label (`Kernel` vs `Kernel+Eval`) matches per declaration. Confirmed at read time:
      all E-cone theorems and `winding_witness_eq_counterexample` are **K**; the four-site
      discriminant family is **K+E**.
- [ ] **Trusted-core presence (R6 MAJOR-1).** Confirm `two_edge_plucker_mass_identity` and every
      `ARTIFACT_MANIFEST` anchor is present in and builds from the release package.
- [ ] **Mint the archive id.** Replace "PENDING AFTER CLAIM FREEZE": commit + immutable tag/DOI;
      record commit hash, `lake-manifest.json` and `lean-toolchain` SHA-256 (already pinned),
      Mathlib `8f9d9cff…`, toolchain `v4.28.0`. No uncommitted working-tree results in the archive.
- [ ] **Anchor freeze.** Every manuscript↔Lean row in `ARTIFACT_MANIFEST` frozen with exact
      declaration names and Kernel/Kernel+Eval tags.

## 5b. 07:00–09:00 PDT hostile audit checklist
- [ ] **Clean-room build.** Fresh Linux checkout at the pinned commit; build the *scoped* null-edge
      target; confirm the headline/guard build passes **independently** of the known SPL/E8 blocker
      (`E8ThetaDim8MF`, `E8SpherePackingImported`, `ThetaDuplicationIdentities`, `E8ThetaSPLBridge`).
      A green scoped Linux build is the release gate; Windows-only is insufficient.
- [ ] **Axiom/placeholder audit.** Re-run `#print axioms` on every headline theorem; fail on any
      axiom outside the allowed set; re-scan for `sorry/admit/@[implemented_by]`.
- [ ] **Nonvacuity audit.** Each headline theorem has an *exact* nonzero witness AND a
      negative/boundary control: `unit_control`/`collinear_control` (A); `witBlock` vs `numberOp`
      (E); field 11 vs field 2 (C); `positive_metrics_disagree`, `traceZeroDirection_nonzero` (F).
- [ ] **Theorem-to-prose audit.** Line-by-line: every manuscript sentence maps to a declaration of
      *matching scope*. Flag any prose stronger than its Lean statement, targeting the four risk
      words: **cone, protected, no-mode/full-walk, canonical/derived**.
- [ ] **Vacuity / false-shape / circularity audit.** No unsatisfiable-hypothesis vacuity; no
      capstone proved only from supplied structure (hollow telescoping); no supplied-structure
      circularity (F metrics/selectors and C reflection structure are *supplied*, not derived — the
      prose must say so).
- [ ] **Literature-novelty audit.** Re-verify: Kitagawa/Asboth/Asboth–Obuse/Cedzich (C, "imported,
      not claimed"); Dittmaier WvdW + Arkani-Hamed–Huang–Huang (A, "Cauchy–Binet overlap");
      Mlodinow–Brun / D'Ariano / Piroli et al. `2007.11905` (E graded-locality warning);
      Ackermann–Tolksdorf + Krein fundamental-symmetry (F). Run the explicit "first machine-verified"
      priority check *before* any such phrase ships.
- [ ] **Artifact release gate.** Verifier PASS + identical `summary.json` hash; complete buildable
      source incl. trusted core; author lines fixed; Kernel/Kernel+Eval labels correct throughout;
      archive id minted; no uncommitted results.

---

## 6. Conditional morning headlines

**If no further theorem lands.** Lead with **Paper A**: a machine-checked derivation chain in which
the Dirac rest gap is *identified with* the null-spinor Plücker area — a canonical odd Hermitian
rest operator unique in the fixed two-channel class, exponentiated into an exactly unitary walk,
carried through directed histories and a local phase connection, and pinned by a complete all-zone
determinant crossing classification and mass-independent no-gap obstruction. State plainly that this
is a finite verified *identification and dynamical chain*, not a mass-value prediction, not a
position-space PDE limit, and not an interacting field theory. Pair it with **Paper C**'s finite
result that equal `2π` winding does not determine the compression signature (the exact repaired
criterion is two walls plus a reflection-position datum), positioned as "imported chiral-walk
topology, new derived-defect obstruction." Both are honest, kernel-anchored, and referee-ready;
neither outruns its statement.

**If the genuine graph-metric CAR cone lands.** Lead with **Paper E**: the first machine-checked
*bounded-speed* causal cone for a spinor-derived interacting fermionic dynamics — a Lieb–Robinson-
type radius-by-time theorem in which a layered schedule of contiguous finite-range unit-phase
Plücker pair gates propagates strong CAR support within graph radius `w·t`, with the number-operator
control proving that support (not mere occupation-transition footprint) is what is bounded. Scope it
exactly: an even-observable cone at unit phase on a chain metric, still one step short of a
composed spatial-walk interacting QFT with a computed scattering/binding observable. This is the one
result that would justify moving Paper E from *Journal of Physics A / JMP* into the *Quantum /
PRResearch* lane, and it is the only headline upgrade the remaining window can plausibly deliver.
