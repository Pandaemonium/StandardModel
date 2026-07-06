# Overnight all-mass run (2026-07-06): RUN PLAN

Agent: Claude Opus 4.8 (sole local agent) + Aristotle (proof/strategy fleet,
up to 10 concurrent jobs). Planner: Claude Fable 5 (this document), from the
two grand-strategy reviews (`~/Downloads/strategy1` = whole-project audit run
`15cff974`, `~/Downloads/strategy2` = YM audit run `9d243fd4`), the existing
synthesis (`AgentTasks/fourday-ym-run-2026-07-05/GRAND_STRATEGY_SYNTHESIS_20260705.md`),
and a fresh repo-state survey.

## 0. Mission

Get as close as possible, in one night, to **explaining all of mass using
null-edge theory** - at kernel-checked theorem grade, with the claim
discipline of `AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`
(the normative mass doc: three obstructions T/turn, C/closure, A/aperture;
F-YM-CONFLATE constitution-grade; continuum permanently out).

## 1. Planner's analysis (why these targets)

Both strategy reviews converge on the same map:

1. **The only open proof surface in the whole NullEdge tree is Q6.** All 153
   NullEdge files are `s o r r y`-free except `GateYM/PolymerKPConclusion.lean`
   (3: `pairSum_le_expBound` ~L938 the crux, then
   `kp_convergence_bound_of_selfIncompatible` ~L1264, `kp_tail_bound` ~L1314).
   Codex has since integrated all 5 helper lemmas from the last harvest
   (including `treeRootChildComponent_ne_of_ne`,
   `disjoint_treeRootChildBlock_of_ne` at L773/L817), so the crux is fully
   scaffolded: canonical-root deletion is the ONLY viable route (the
   root-overcounted shape is numerically refuted - do not resurrect it).
2. **The single highest-leverage MISSING OBJECT is the M1/M3 connected
   cut-bearing Wilson slab lattice.** Both audits call it the empty center of
   gravity: it gates genuine RP-LINK and the first PHYSICAL transfer operator
   (the current `finiteMassGap` consumer is the 2x2 toy). Pure finite
   geometry/algebra, no Peter-Weyl dependency, reuses the verified
   `WilsonCutPlaquetteEnsemble` / `ReflectionPositivityKernel` engines.
3. **The NE-U mass ladder is 4/6 proved.** NE-U1 aperture keystone
   (`compositeMassSq_eq_zero_iff_collinear`), NE-U2 mass = turn channel at
   Wilson-Dirac grade, NE-U3 closure/Elitzur, NE-U5 mass-without-mass
   (`massWithoutMass`: zero primitive mass, positive glueball gap) are all
   kernel-checked. NE-U4 (gap as closure cost) rides M1-M3. NE-U6
   (electroweak rung) is unstarted. The co-location verdict
   (`charge_grading_mass_compatible`) settled the octonion-lane coupling
   question honestly.
4. **The honest "all mass" claim is a bundled conjunction + a separation
   theorem**, not a merged mechanism: one capstone theorem per obstruction
   row, PLUS a theorem that the four mass functionals (`quarkMassParameter`,
   regulator mass, spectral/closure mass, `compositeApertureMass`) are
   provably DISTINCT. The mass doc's section 4 lists this as deliverable;
   nothing blocks it tonight.

So the night has two thrusts: **(thrust 1)** close/advance the C-row dynamics
(Q6 crux, M1/M3 slab, physical transfer gap = NE-U4), and **(thrust 2)** land
the all-mass capstone + taxonomy separation + NE-U6 statement layer, which is
achievable REGARDLESS of whether thrust 1's hard proofs fall. Aristotle
carries thrust 1; Opus carries thrust 2 locally between harvests.

## 2. Success tiers

- **FLOOR:** every Aristotle harvest semantically reviewed + integrated or
  honestly rejected; `AllMassFromNullEdges` capstone v1 (bundling the four
  proved rungs + co-location verdict) built and axiom-guarded; the mass
  taxonomy separation theorem proved; NE-U6 statement freeze committed;
  morning report written.
- **TARGET:** floor + the M1/M3 connected slab EXISTS in Lean with the mirror
  holonomy factorization lemma; conditional KP assembly
  (`kp_convergence_bound_of_selfIncompatible` with the crux as explicit
  hypothesis) landed; multi-link product-Haar RP rung landed; fermionic RP-F
  minimal fragment landed.
- **SHOCK:** `pairSum_le_expBound` closes -> immediately submit the two
  downstream Q6 sorries -> KP convergence + tail land -> the Q7 clustering
  bridges go live; AND/OR the slab feeds `rpBlockMatrix` -> first physical
  positive transfer operator -> sector-restricted `finiteMassGap` instance ->
  NE-U4 becomes a THEOREM ("the lightest closed flux composite costs
  energy") -> capstone v2 gains the spectral conjunct. That is the "all mass
  explained" summit at finite grade.

## 3. Aristotle fleet: wave 1 (submit immediately, all 10 slots)

Rules of engagement: unlimited budget, max 10 concurrent THIS-project jobs
(ignore the number-theory project's IDLE jobs: parity-*, frontier-progress,
minor-arc, eglc2, door2-*, structural-deliverables). Prefer focused standalone
packages (Mathlib + copied defs) over full-repo packages - full-repo builds
stall (memory: skip lake build, Mathlib-only). Use
`Scripts/prepare_aristotle_submission.ps1 -IncludeSources -TaskNote X
-ExtraPath Y` for repo packages; `Scripts/aristotle/make_context_pack.py` for
context packs. Every prompt: standalone, verbatim source of every declaration
under review, conventions stated, success/failure criteria, "if the build is
slow or stalls, SKIP lake build and return your best results as text/patch."

NOTE: job `938f8068` (grand-strategy-review-project) was already RUNNING at
plan time - harvest it as if it were slot A10's predecessor.

- **A1 - Q6 crux, attack 1 (canonical-root deletion).**
  `pairSum_le_expBound` as a focused standalone package: copy the polymer
  defs + the full helper scaffolding (`treeRootChildBlock`,
  `treeRootChildBlock_card_pos`, `treeRootChildBlock_card_add_one_le`,
  `treeRootChildComponent_ne_of_ne`, `disjoint_treeRootChildBlock_of_ne`,
  `exists_canonical_root`, `rhs_forest_expand`,
  `factorial_mul_prod_factorial_le`). State the canonical-root deletion
  strategy verbatim from `Q6_PAIRSUM_EXP_BOUND_DAG_PROGRESS.md`. Warn: the
  root-overcounted reduction is FALSE at order x^3 (recorded).
- **A2 - Q6 crux, attack 2 (independent strategy).** Same statement, separate
  package, instructed to IGNORE the deletion route and try strong induction
  on polymer count via the species/exponential-formula decomposition, or a
  direct injective encoding into forests. Two independent searches on the one
  crux that gates everything is the correct use of a free budget.
- **A3 - conditional KP assembly.** Prove
  `kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound` taking
  `pairSum_le_expBound` as an explicit named HYPOTHESIS (so the assembly is
  ready the moment A1/A2 lands, and the proof risk is isolated). Keep
  `hself` threaded everywhere - `kp_convergence_bound_false` is the standing
  disproof of the bare shape.
- **A4 - M1/M3 connected cut-bearing Wilson slab (construction).** Define the
  smallest CONNECTED cut geometry (2x2 torus slab per the YM audit), its
  Wilson slab weight in mirror coordinates, and prove the holonomy
  factorization `hol = e(c,a) * e(c,b)^-1` in the shape
  `WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization`
  consumes. Include `ReflectionCutPlaquetteFamily.lean` +
  `WilsonCutPlaquetteEnsemble.lean` verbatim. Construction job, not proof
  golf: the OBJECT is the deliverable.
- **A5 - physical transfer operator design (rides A4, submit as design job
  now).** Given the A4 slab shape, design + statement-freeze the
  `rpBlockMatrix` instance and the sector-restricted
  `TransferGapDefinition.finiteMassGap` consumer on it, with the NE-U4
  statement shape ("lightest nontrivial center-flux sector state costs
  energy") and a strong-coupling gap lower bound tied to the YM1 area-law
  flux cost. Deliverable: compiling statement layer + lemma DAG, proofs
  optional.
- **A6 - QMF-RP next rung: multi-link product Haar.** Extend the single-link
  substrate (`QMF/*`): `Measure.pi` over `Pi_e SU(N)` links of a finite edge
  set, product-Haar gauge invariance at each link, the link-reflection
  involution on configurations, and the RP bilinear form STATEMENT on the
  doubled configuration space. This is the audited "pending next rung"
  (`QMF_RP_LOAD_BEARING_AUDIT_bb6b33c3.md`). Peter-Weyl stays out of scope.
- **A7 - fermionic RP-F minimal fragment.** The Deliverable-1 minimal
  tractable fragment from `QMF5_DESIGN_HARVEST.md` (12-node lemma DAG,
  D1.3/D3.1): concrete `A` instantiation for `FermionicReflection.
  ReflectedBoundaryCoupling` with the stated reflection-hermiticity
  hypothesis, routed through the existing lifted-projector PSD lemmas. This
  is the gate to the fermionic Ward-subtracted `confinementGap` (NE-U5
  stretch).
- **A8 - NE-U6 electroweak rung (statement freeze + smallest theorem).**
  Finite Z2 (or U(1)) gauge-Higgs toy: transfer operator on the smallest
  lattice, GAUGE-INVARIANT composite operators only, W-like mass as a
  transfer-spectrum feature. Statement layer + the smallest provable finite
  identity (e.g. the composite two-point function's positivity/decay on the
  toy). HARD BOUNDARY in the prompt: Fradkin-Shenker is phase-diagram
  connectivity, NOT mechanism identity; "Higgs = confinement" is a kill
  condition.
- **A9 - mass taxonomy separation theorem.** Prove the four mass functionals
  are pairwise distinct as functionals on a suitable finite model family:
  `quarkMassParameter` (input parameter), Wilson regulator mass (survives
  m=0 at r>0), closure/spectral mass (`z2GlueballMass` positive at zero
  fermion content), `compositeApertureMass` (kinematic, nonzero for
  non-collinear null pairs). Concretely: exhibit finite models where each is
  zero while another is positive. This converts the taxonomy table into
  MATHEMATICS and is the single best guard against the unification
  over-claim.
- **A10 - overnight audit slot (rolling).** First: harvest `938f8068`. Then
  keep one slot reserved for (i) a mid-run load-bearing audit of whatever big
  thing lands first (A4 slab or A1 crux), and (ii) a ~06:00 "morning grand
  strategy" job reviewing the night's commits and recommending the next day.
  Audits are explicitly allowed to return "this is wrong, here is why."

Wave 2 (as slots free): downstream Q6 sorries unconditionally (if crux
lands), RP-LINK on the A4 slab, `ExponentialClustering` consumer, NoNative
structural proofs opportunistically, NE-U5 fermionic `confinementGap`.

## 4. Fleet protocol (the 2-hour rule and the cycle)

Work in 30-45 minute cycles. Each cycle:

1. `aristotle list` (set `PYTHONIOENCODING=utf-8`). Identify THIS-project
   jobs. Track each job's CREATED age in the ledger.
2. **2-hour rule (lead's directive):** any THIS-project job RUNNING for more
   than 2 hours -> stop it and make it return what it has WITHOUT building:
   - `aristotle cancel <id>` (stops the running task), then
   - `aristotle continue --mode instruct --wait <id> "Do NOT run lake build
     or any build step. Finalize what you have: write your best current
     Lean source, partial proofs as documented s o r r y handoffs, and a
     summary of what worked/failed, then finish immediately."`
   - If `continue` itself hangs, download the in-progress snapshot instead
     (`aristotle download <id> --destination X.zip` works while RUNNING).
3. Harvest every IDLE/finished job: download, semantic review FIRST
   (statement alignment, convention drift, hidden hypotheses, widened
   imports), then targeted `lake env lean` / `lake build <module>`, then
   integrate + commit. A rejected harvest with a written reason is a
   result - record it.
4. Refill: keep 10 THIS-project slots occupied while there is genuine work.
   Never submit a duplicate of a still-running job unless it is an
   intentionally independent attack (A1/A2 pattern, note it in the ledger).
5. Between harvests, do LOCAL thrust-2 work (capstone, guards, docs). Never
   sleep-poll; if truly blocked, end the cycle.

## 5. Local (Opus) work queue, priority order

- **L1 - `AllMassFromNullEdges` capstone v1.** New
  `PhysicsSM/Draft/NullEdge/GateI1/AllMassFromNullEdges.lean` on the
  `UnificationCapstone` pattern: one kernel-checked conjunction bundling
  (A) `compositeMassSq_eq_zero_iff_collinear`, (T) the NE-U2 Wilson-Dirac
  chirality theorems, (C) `massWithoutMass` + the Elitzur closure corollary,
  plus `charge_grading_mass_compatible` (mass is charge-blind: co-location).
  Every conjunct discharged by an existing proved theorem; docstring carries
  the T/C/A mechanism reading and the honest claim label (program synthesis,
  finite identities only, NOT the physical YM gap). Add a
  `#guard_msgs in #print axioms` guard.
- **L2 - integrate A9 (or prove it locally if A9 stalls):** the taxonomy
  separation theorem is mostly assembling existing models; Opus can do it
  without Aristotle if slot A9 disappoints.
- **L3 - NE-U6 statement freeze** in the mass doc + a stub module, if A8 has
  not returned by mid-night.
- **L4 - axiom guards** on every new flagship as it lands (template:
  `QMF/AxiomGuard.lean`).
- **L5 - update `NULL_EDGE_MASS_UNIFICATION.md`** rung statuses as things
  land; keep the CAN/CANNOT list enforced.
- **L6 - morning report** `MORNING_REPORT.md`: theorems landed (with axiom
  footprints), harvests rejected + why, jobs still running, the honest
  distance remaining to "all mass," and next-day recommendation (folding in
  the A10 morning strategy job).

## 6. Standing constraints (binding, carried from the four-day run)

- Commit prefix `overnight-mass-202607:`; trailer
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`; explicit
  `git add` paths only; `pre-commit run --all-files` before commits; no push,
  no amend.
- Codex is NOT running tonight, so custody of the whole tree (including
  `PolymerKPConclusion.lean` and GateYM) passes to Opus - BUT check
  `git status` for uncommitted foreign work before first touching any GateYM
  file, and record the custody takeover in this run's LEDGER.
- Claim discipline: F-YM-CONFLATE constitution-grade; never call the GateYM
  aggregator `s o r r y`-free; no continuum/QMF8 language; `hself` threaded
  in all KP statements; sector labels preserved; the Wilson regulator mass
  is an artifact to be SEPARATED, never absorbed; no numerical mass values.
- Text hygiene per AGENTS.md (ASCII, LF, UTF-8 no BOM, spaced escape-hatch
  tokens in prose). No trusted promotion tonight; everything lands as
  draft-trust with honest labels.
- Aristotle wrappers/logging per AGENTS.md if any external Claude/Gemini
  review calls are made (none are planned).

## 7. Stop conditions (report, do not push through)

A needed hypothesis turns out to be a hidden physical premise; a sector label
is not preserved by a candidate kernel; a Q8 bridge smuggles decay in as a
conclusion; an Aristotle result only closes after weakening a statement; the
oracle contradicts a Lean statement shape; any red flag from AGENTS.md. Any
of these -> ledger entry + morning-report item; they are results.
