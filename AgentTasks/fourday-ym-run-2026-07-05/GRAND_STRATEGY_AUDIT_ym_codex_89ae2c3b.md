# YM / Null Edge grand strategy audit and roadmap

Status date: 2026-07-05
Author: source-grounded strategy auditor (Aristotle)
Method: static inspection of the shipped `PhysicsSM/` tree, `Scripts/oracle/`,
and the run/paper notes. Claims below are graded by what the Lean source
actually contains (import graph + `sorry`/`axiom` grep + theorem statements),
not by prose in the notes. Where prose and Lean disagree, the Lean wins and the
mismatch is called out. I did not rebuild the full project in this pass; all
"kernel-checked" gradings are inferred from source (`sorry`-freedom + declared
axiom footprints) and should be re-confirmed with `lake build` before any
collaborator-facing promotion.

---

## Executive summary

The program is real, large, and unusually disciplined about its own claim
boundary. The single most important structural fact: across all 153 files in
`PhysicsSM/Draft/NullEdge/`, **exactly one file carries any `sorry` at all** —
`GateYM/PolymerKPConclusion.lean`, with 3 `sorry`s. Everything else in the
Null Edge / GateYM / QMF draft tree is `sorry`-free at standard axioms
(`propext`, `Classical.choice`, `Quot.sound`). That is a strong, verifiable
spine, and it is much cleaner than the sprawling prose suggests.

The equally important fact: **almost none of that spine is the mass gap.** The
verified content is (a) a finite kinematic mass identity ("mass = failure of
null directions to stay collinear"), (b) an exact finite-group 2D area law,
(c) a finite reflection-positivity kernel engine with a zero-cut Wilson
instance, (d) finite OS/GNS range / electric-sector bookkeeping, (e) a tiny
2×2 transfer toy tied to an executable Z2 oracle, and (f) compact-group Haar
invariance for SU(N). These are honest finite theorems and useful lemmas. They
are *prerequisites* for a mass-gap statement, not a mass-gap statement, and the
files say so repeatedly.

The whole "mass gap" arc funnels through three still-open `sorry`s in one file
(Q6/KP) plus two never-built physical objects (the cut-bearing Wilson slab
lattice M1/M3, and any nonabelian character expansion / Peter-Weyl). The best
verified *negative* result in the repo — `kp_convergence_bound_false`, a
kernel-checked disproof of the naive KP bound without self-incompatibility — is
worth as much as several of the positive lemmas and should be advertised as
such.

Blunt bottom line: the finite-math scaffolding is in good shape and the claim
hygiene is genuinely good. The project is nowhere near a Yang-Mills mass gap,
the gap between "current spine" and "physical transfer operator with a sector
gap" is dominated by objects that **do not exist in Lean yet**, and the one
proof bottleneck that is actively worked (Q6 `pairSum_le_expBound`) is a
self-contained finite labeled-rooted-tree species inequality that is the
correct thing to keep hammering.

---

## Verified spine

Graded into the four requested tiers.

### Tier 1 — kernel-checked finite identities (`sorry`-free, standard axioms)

These are the load-bearing *verified* results. All confirmed `sorry`-free by
source scan; axiom footprints as declared in the module docstrings.

- **Finite kinematic mass keystone (Gate I1 / P1 lane).**
  `NullEdgeP1TwoNull*`, `GateI1/*`. The "mass without mass" germ: `det P = m²`
  for a two-null composite, `splitMassSq_eq_zero_iff_left_or_right_zero`,
  `splitMassSq_pos_iff_left_and_right_pos`, `four_mul_split_energy_product_eq_massSq`,
  and the headline `compositeMassSq_eq_zero_iff_collinear`. This is the one
  mechanism the manuscript opening is allowed to assert, and it is genuinely
  proved. It is finite linear algebra, not physics.
- **Exact 2D finite-group area law (YM1 / Theorem 2).**
  `RectTreeGauge.rect_wilson_loop_expectation_area_law` and
  `RectBoundaryExpectation.rect_boundary_wilson_loop_expectation_area_law`:
  Wilson-loop expectation `= χ_R(1)·γ^(Lx·Ly)` on a concrete `Lx×Ly` open
  rectangle for arbitrary finite groups, via a proven comb-gauge
  `PlaquetteCoordinatization` and an expectation-level boundary bridge that
  correctly avoids the false pointwise identity. This is the most complete
  end-to-end physical-looking theorem in the repo and is the natural first
  paper unit.
- **Reflection-positivity kernel engine (YM3, Route B).**
  `ReflectionPositivityKernel.reflectionForm_nonneg` + Schur-product closure
  (`hadamard_posSemidef`, `cutKernel_*_posSemidef`), with a genuine zero-cut
  Wilson instance `doubled_wilson_reflectionForm_nonneg` and its ensemble
  identification. `HermitianFromRealQuadraticForm` and the Schur lemma are
  clean Mathlib-gap fillers (real promotion / upstream candidates).
- **Q4/Q5 spectral facts.** `FDRepUnitarizable` (Weyl unitarian trick in
  matrix algebra, every `FDRep`), `WilsonVacuumDominance`
  (`norm_wilsonNormalizedGamma_le_one'`, `wilsonStringTension_nonneg'`,
  `wilsonNormalizedGamma_re_mem_Icc`), `character_inv_eq_conj`. Unconditional,
  standard axioms — the cleanest promotion candidates.
- **Elitzur (YM1).** `ElitzurLattice` quantitative volume-uniform theorem
  instantiated at the one-site Z2 flip. Real and complete.
- **Compact-group Haar substrate (QMF1-RP).** `QMF/*`:
  `specialUnitaryGroup_isCompact`, `_isTopologicalGroup`, gauge/reflection
  invariance of the SU(N) Haar expectation, and unimodularity from
  compactness. These close four genuine pinned-Mathlib gaps and are reusable
  independent of the gauge story.
- **Finite OS/GNS + sector bookkeeping (Q2/Q3).** `TransferHilbert*`,
  `FluxSectorZ2`, `TransferHilbertZ2Electric`: reflection pairing, `rpBlockMatrix`
  PSD, electric-sector projector algebra, finrank additivity. All finite,
  all abstract.
- **Verified NEGATIVE result.** `kp_convergence_bound_false` — a kernel-checked
  disproof (confirmed `sorry`-free) that the bare Kotecký–Preiss convergence
  bound fails without a self-incompatibility hypothesis. This corrected the C2
  target and is one of the highest-value artifacts in the repo.
- **Penrose tree-graph inequality.** `TreeGraphInequality`:
  `|ursellSum G| ≤ spanningTreeCount G`, abstract finite `SimpleGraph`. Real.

### Tier 2 — executable oracle evidence (NOT kernel-checked)

- `Scripts/oracle/validate_lgt_core.py` (1256 lines) — convention pins C-1..C-8,
  30/30 checks reproduced in two environments (per notes).
- `Scripts/oracle/z2_transfer_oracle.py` (1912 lines) — descriptor-driven exact
  finite Z2 1+1D transfer enumeration: transfer traces, sector blocks,
  two-time correlations, first-gap records, `--verify-record` replay,
  `--write-schema`. This is the strongest part of the "dynamics" story and it
  is *evidence*, not proof. It informs, but does not discharge, the Lean
  transfer surfaces.

### Tier 3 — draft / handoff theorem surfaces (statement-frozen, proof open)

- **Q6/KP (the whole open frontier lives here).**
  `PolymerKPConclusion.lean` — 3 `sorry`s:
  1. `pairSum_le_expBound` (line ~938) — the labeled rooted-tree exponential
     inequality; the true analytic crux. Feeds `touchOnlySum_le_expBound` →
     `boundedTouchSum_succ_le_finitePartial` → `boundedTouchSum_succ_le`.
  2. `kp_convergence_bound_of_selfIncompatible` (line ~1264) — corrected C2 KP
     convergence bound.
  3. `kp_tail_bound` (line ~1314) — metric/coercivity tail bound.
- **Q7/Q8 bridges.** `StrongCouplingPolymerMap`, `ExponentialClustering`,
  `ObservableSupportBridge` — extensive statement/bookkeeping layers, all
  conditional on the Q6 crux; deliberately claim no clustering.
- **Transfer gap.** `TransferGapDefinition.finiteMassGap`, `FiniteGapAssembly`,
  `TwoStateTransfer{Spectrum,Witness,Z2L1}` — the gap API is non-vacuous only
  on the 2×2 toy; no physical Wilson-slab consumer exists.
- **Fermionic RP / QMF3–7.** `FermionicReflection.ReflectedBoundaryCoupling`
  (coupling slot `A` uninstantiated), `BanksCasherShadow`,
  `BerezinMatthewsSalam` — statement scaffolds.

### Tier 4 — speculative physical interpretation (prose only)

- "No primitive mass" / null-edge mass *unification* thesis (`M² = Σ pairwise
  null angles` across fermion/gauge/hadron rows). The two-body germ (`det P=m²`)
  is a theorem; the *unification* across QCD confinement mass is a narrative.
- "Full QCD mass formalism" (QMF7): hadron masses as sector-restricted spectral
  gaps. Entirely a statement-target; no rung above QMF1-RP has a physical proof.
- Any continuum / renormalization / Balaban language (QMF8) — explicitly
  out of scope and on the project's own kill list. Correctly so.

---

## Load-bearing risks

Ranked by how much damage failure would do.

1. **The three `sorry`s in `PolymerKPConclusion.lean` are the entire
   mass-gap-adjacent risk surface.** The GateYM aggregator *imports*
   `PolymerKPConclusion` (line 63), so `lake build …GateYM` is **not globally
   `sorry`-free** — it succeeds only because `sorry` is a warning. Any
   collaborator-facing statement of the form "the GateYM layer is
   kernel-checked" must be qualified: the Q6/KP/clustering modules are
   statement-freeze with 3 open cruxes. This is the most likely source of an
   accidental over-claim.
2. **M1/M3 shared object does not exist.** The concrete cut-bearing reflection
   lattice with a Wilson slab weight in mirror coordinates is the single
   artifact both "genuine RP-LINK" and "first physical transfer operator"
   depend on, and there is no Lean object for it — only the disconnected
   `ReflectionCutPlaquetteFamily` (geometrically distinct but *disconnected*
   plaquettes). Until this is built, the entire transfer/gap story is 2×2 toy
   plus abstract algebra. This is the true center of gravity of the whole
   program and it is empty.
3. **Peter-Weyl / nonabelian character expansion absent (QMF1-PW).** The KP /
   strong-coupling route for SU(N) needs character orthogonality that pinned
   Mathlib lacks. The notes correctly route the *critical* RP→transfer path
   around it, but any claim about SU(3) strong-coupling convergence silently
   depends on machinery that isn't there.
4. **Q6 self-incompatibility is load-bearing and now known to be necessary.**
   Good news dressed as risk: `kp_convergence_bound_false` proves the naive
   target was false. The remaining positive theorems must keep `hself`
   threaded; dropping it anywhere re-introduces a false statement.
5. **Interpretation drift.** The "null-edge unification of all mass including
   QCD confinement" thesis is the most seductive over-claim vector. The
   theorems support a shared mechanism *shape*, not a unified theorem. The
   F-YM-CONFLATE discipline (separate theorems per row) is the correct guard
   and must not be relaxed in any paper.

---

## Top 10 next targets (ranked by expected value / proof effort)

1. **`pairSum_le_expBound`** (`PolymerKPConclusion`). Highest value: it is the
   only crux gating Q6→Q7→Q8, it is self-contained finite combinatorics (a
   labeled rooted-tree exponential-formula inequality; the canonical-root
   deletion strategy is already documented and partially scaffolded via
   `treeRootChildBlock`), and closing it turns three downstream theorems live.
   Keep it as a focused package; two-failure park rule.
2. **`kp_convergence_bound_of_selfIncompatible`.** Once (1) lands, this is the
   assembly using `hself`, `hKP`, `D.treeGraphBound`. Medium effort, unlocks
   the first genuine `ClusterCoeffData` consumer.
3. **Promote Q4/Q5 + Schur lemma to trusted / Mathlib.**
   `FDRepUnitarizable`, `WilsonVacuumDominance` unconditional forms,
   `hadamard_posSemidef`, `HermitianFromRealQuadraticForm`. Near-zero new proof
   effort (already done, standard axioms); high value as the first *promoted*
   results and upstream PR candidates.
4. **Close YM1 Theorem 2 as a self-contained paper unit.** The area law is
   done end-to-end; the remaining work is packaging + a "what is proved / what
   is oracle / what is open" section. Cheap, and it is the one genuinely
   finishable scientific deliverable.
5. **Build the M1/M3 shared cut-bearing Wilson slab lattice (connected).**
   Highest *strategic* value but highest effort. Start with the smallest
   connected cut geometry (2×2 torus slab) and prove its genuine
   `PlaquetteEnsemble.weight` has the mirror cut-factor form feeding
   `WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization`.
6. **Feed that lattice into `rpBlockMatrix` for a first physical positive
   transfer operator**, then instantiate `TransferGapDefinition.finiteMassGap`
   on it. This is the first non-toy consumer of the gap API.
7. **`kp_tail_bound`** with the explicit coercivity hypothesis kept external.
   Rides on (2); statement is already honest about the extra geometry layer.
8. **QMF3 Berezin / Matthews–Salam finite identity** (fermionic Gaussian
   integral = determinant on 1–4 modes). Independent of the mountains, fully
   finite/kernel-checkable, oracle-testable first, publishable standalone.
9. **`FermionicReflection` concrete `A` instantiation** for the Wilson boundary
   coupling with the stated reflection-hermiticity hypothesis, routed through
   the existing lifted-projector PSD lemmas. Only after M1 geometry is pinned.
10. **NE-U1 aperture keystone consolidation** (`compositeMassSq_eq_zero_iff_
    collinear` + Plücker bridge as a named, docstring-clean corollary). Cheap,
    it is the honest core of the unification narrative and worth stating
    crisply so the paper has a defensible spine.

---

## No-go / downgrade warnings

- **Do not call the GateYM aggregator `sorry`-free.** It transitively imports
  the 3 `sorry`s in `PolymerKPConclusion`. Correct phrasing: "the GateYM layer
  is `sorry`-free except the Q6/KP conclusion cruxes."
- **Do not claim volume-uniform KP, exponential clustering, or Q8 for SU(N)**
  until (1)+(2) close AND Peter-Weyl exists. The clustering bridges are
  conditional on hypotheses that are not discharged.
- **The naive bare-KP bound is FALSE (proven).** Do not resurrect any
  statement lacking self-incompatibility; `kp_convergence_bound_false` is the
  standing disproof.
- **No physical transfer operator / Hamiltonian / infinite-volume state /
  physical mass gap exists.** Every `finiteMassGap` positivity is on the 2×2
  toy. Any prose asserting a "mass gap" beyond a finite spectral-ratio
  definition on a toy matrix is an over-claim.
- **The "all mass is null-edge" unification is a thesis, not a theorem.** Only
  the two-body kinematic germ is proved. Confining/hadron mass as a null-edge
  obstruction has no proof and likely will not for the foreseeable roadmap.
- **QMF8 (continuum/renormalization) is a permanent no-go for kernel claims.**
  Correctly on the kill list; keep it there.
- **Likely-false / dead-end shape to avoid:** rooting the KP tree sum at every
  `g`-slot (the "root-overcounted" reduction). The file already records
  (verified numerically and by hand) that this turns Cayley `m^(m-2)` into
  rooted `m^(m-1)` and *exceeds* the RHS at order `x³`. The canonical
  single-root deletion is the only viable route.

---

## Recommended 48-hour execution plan

Assumes the current Q6 Aristotle task returns first (poll/harvest before
submitting new Q6 work, per the standing budget rule).

- **Hour 0–2 — harvest + audit.** Integrate whatever the current Q6 job
  returns only after a semantic review and a targeted `lake build
  PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion`. Re-run the `sorry`
  grep to confirm the count dropped.
- **Parallel lane A (proof, highest value): `pairSum_le_expBound`.** Submit as
  a single focused package with the canonical-root deletion sketch and the
  existing `treeRootChildBlock` / `treeRootChildBlock_card_add_one_le`
  scaffolding named explicitly. This is the only crux worth a high-effort
  search.
- **Parallel lane B (cheap wins, no dependency): promote Q4/Q5 + Schur/
  Hermitian lemmas.** Verify axioms with `#print axioms`, move them to the
  trusted target, and open the Mathlib-facing extraction of
  `hadamard_posSemidef` and `HermitianFromRealQuadraticForm`.
- **Parallel lane C (paper unit): finish YM1 Theorem 2 write-up.** One
  collaborator-facing page: statement, the comb-gauge construction, the
  boundary bridge, and the explicit claim boundary. No new proofs.
- **Hour 12–36 — M1/M3 shared object design.** Do NOT try to prove RP-LINK
  yet. First *define* the smallest connected cut-bearing lattice + Wilson slab
  weight in mirror coordinates and prove the holonomy factorization lemma
  (`hol = e(c,a)·e(c,b)⁻¹`) that `WilsonCutPlaquetteEnsemble` consumes. Ship it
  as a statement-freeze + one Aristotle package.
- **Hour 36–48 — consolidate.** If lane A closes, immediately submit
  `kp_convergence_bound_of_selfIncompatible`. Update the collaborator brief and
  the claim-type table, sync the ledger, and record any negative findings as
  first-class results.
- **Stop conditions (unchanged, enforce them):** a needed hypothesis is a
  hidden physical premise; a sector label is not preserved by the candidate
  kernel; a Q8 bridge smuggles decay in as a conclusion; RP-F needs an unpinned
  reflection convention; oracle contradicts a Lean statement shape. Any of
  these → stop and report; they are useful results.

---

## Which job Codex should run next (after the current Q6 Aristotle task returns)

**Run the M1/M3 shared-object construction job**, *not* another Q6 variation.
Rationale: Q6 is already saturated with one active high-value Aristotle search
(`pairSum_le_expBound`); adding a second Q6 job violates the budget rule and
duplicates effort. The M1/M3 connected cut-bearing Wilson slab lattice is the
single highest-leverage *missing object* in the entire program (it unblocks
both genuine RP-LINK and the first physical transfer operator), it is pure
geometry/finite-algebra (no Peter-Weyl dependency), and it reuses the already-
verified `WilsonCutPlaquetteEnsemble` / `ReflectionPositivityKernel` engines.
Codex's next job = **define the smallest connected cut geometry and prove the
mirror-coordinate holonomy factorization lemma**, leaving RP-LINK itself as the
follow-on. If for scheduling reasons a proof job is preferred over a
construction job, the fallback is `kp_convergence_bound_of_selfIncompatible`
(cheap, unlocked the moment `pairSum_le_expBound` lands).

---

## Exact files / theorems to inspect next

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` — the ONLY file
  with `sorry` in the whole NullEdge/GateYM tree. Targets:
  `pairSum_le_expBound` (~L938), `kp_convergence_bound_of_selfIncompatible`
  (~L1264), `kp_tail_bound` (~L1314). Verified negative to advertise:
  `kp_convergence_bound_false` (`sorry`-free).
- `PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean` — the Q7
  KP-sum bound machinery that consumes the Q6 crux; check
  `plaquetteKP_convergence_bound_of_plaquetteKPBound` still carries the parked
  Q6 dependency.
- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteFamily.lean` +
  `WilsonCutPlaquetteEnsemble.lean` — the disconnected family and the
  conditional assembly bridge; the M1/M3 job must upgrade "disconnected" to
  "connected" here.
- `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlock.lean` +
  `TransferGapDefinition.lean` + `TwoStateTransferZ2L1.lean` — the gap API and
  its only (toy) consumer; the M3 physical instance plugs in here.
- `PhysicsSM/Draft/NullEdge/GateYM/FDRepUnitarizable.lean`,
  `WilsonVacuumDominance.lean`, `HermitianFromRealQuadraticForm.lean`,
  `WilsonWeightPositivity.lean` (`hadamard_posSemidef`) — promotion / Mathlib
  candidates; verify `#print axioms` before promoting.
- `PhysicsSM/Draft/NullEdge/GateYM/RectTreeGauge.lean` +
  `RectBoundaryExpectation.lean` — the finished area-law paper unit.
- `PhysicsSM/Draft/NullEdge/QMF/*` — SU(N) Haar substrate; check the
  Peter-Weyl gap note before any character-expansion claim.
- `PhysicsSM/Draft/NullEdge/GateI1/*` + `NullEdgeP1TwoNull*` — the finite mass
  keystone; the only honest spine for the unification narrative.
- `Scripts/oracle/validate_lgt_core.py`, `Scripts/oracle/z2_transfer_oracle.py`
  — oracle evidence tier; keep exact enumeration as the reference check.
- Adjacent (not YM but sorry-bearing, flagged for hygiene): the `NullStrand/*`
  tree carries most of the project's remaining `sorry`s (Probability, BellQFT,
  Ergodic, NullFiber, Audit) and several `Draft/` files (E8 theta moonshot,
  Spin10 stabilizer, Exceptional Jordan). These are outside the YM ladder but
  should not be conflated with the "verified spine" in any global claim.
