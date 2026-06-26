# NullStrand Lean roadmap — review report

**Reviewer:** Aristotle (Harmonic)
**Date:** 2026-06-25
**Scope:** `NullStrand_Lean_Roadmap_Improved.md` and supporting manifest / backlog /
traceability / publication-plan / ledger files in this repository.
**Method:** documents read in full; the Lean kernel and the actual file tree are
treated as the source of truth, per the review prompt. Mathlib lemma names cited
below were checked against the pinned Mathlib (`v4.28.0`).

---

## Executive verdict

The roadmap is, as a *planning document*, unusually disciplined and largely
sound. Its central design choices are correct:

- separating "reported" from "kernel-verified";
- separating definition / theorem / conditional / no-go / conjecture / computation;
- separating kinematic identities from dynamical claims;
- making the **finite i.i.d. null model** and the **exact 1+1 checkerboard model**
  the first publication-grade endpoints, with all continuum/QFT/graph material
  pushed behind explicit hypotheses.

However, there is **one overriding blocker that dominates every other finding:
none of the claimed Lean code exists in this repository.** The only Lean file
present is `RequestProject/Main.lean`, which contains imports and `set_option`
lines and no declarations. There is no `PhysicsSM/` tree, no `AgentTasks/`
directory, no audit modules, and no proofs. The single git commit ("Initial
commit") contains only the planning documents.

Consequently, every "VERIFIED+INTEGRATED", "build green / 8069 jobs",
"REPORTED_EXISTING", and "Banked" claim in the roadmap (§16), the overnight
ledger, the next-wave file, and the publication plan is **unverifiable against
the kernel in this artifact**. They must be treated as *reported*, maturity
level 0, until the tree is actually committed and rebuilt here. This is exactly
the failure mode the roadmap itself warns about ("Reported banked results are not
called verified"); the roadmap's own §16 then violates that rule by asserting a
green 8069-job build that is not present.

Net assessment:

- **Plan quality:** high. The decomposition, gate philosophy, claim boundaries,
  and import firewall are appropriate and publishable as a methodology.
- **Evidence quality in this repo:** effectively zero. No theorem is proved here.
- **First action is not a proof at all** — it is to land the actual Lean tree (or
  reconstruct it) into this project and execute gate G0 honestly. Until then the
  manifest "formal_state" column is the only believable status field, and even it
  disagrees with §16 and the ledger.

---

## Critical blockers

1. **No Lean artifacts in the repository (severity: fatal to all claims).**
   `find . -name '*.lean'` returns only `RequestProject/Main.lean` (empty of
   declarations). The roadmap's §16 "Implementation progress", the overnight
   ledger's "8064/8069 jobs green", and the publication plan's "Banked"
   `PhysicsSM.Spinor.PluckerMass` etc. all reference code that is absent here.
   Nothing can be kernel-confirmed. **Promotion, audit, and publication framing
   are all blocked on first importing/reconstructing the tree.**

2. **Manifest "formal_state" was never reconciled with roadmap §16 / ledger.**
   The manifest lists e.g. KIN-006, KIN-009, KIN-010, ERG-001, GRAPH-002,
   BELL-004, REF-001..004, LA-001 as `READY_TO_PROVE`/`STATEMENT_DESIGNED`, while
   §16 and the ledger call the same nodes "proven+integrated". Three sources
   disagree on the same nodes. The manifest is supposed to be the source of truth
   (W0: "keep Lean declarations as the source of truth... CSV is generated
   output"), but here it is stale relative to the prose.

3. **HOL-002 / HOL-003 status is internally contradictory in one file.** The
   overnight ledger states in one place "HOL-002/HOL-003 are fully proven in
   `Clock/InternalHolonomy.lean`" and in another (carried into roadmap §16) that
   they "remain two documented Aristotle handoffs" (i.e. `sorry`). Both cannot be
   true. This is a live correctness-tracking failure on the matrix-exponential
   unitarity result.

4. **The G1 capstones are *not* actually unblocked despite being advertised as
   such.** The ledger admits `MASTER-001` assembly "needs the Mathlib
   coordinate-iid lemmas under `Measure.infinitePi` (coordinates are `iIndepFun`
   + `IdentDistrib`)... intricate", and `MASTER-002` "needs general kernel
   trajectory". The manifest nonetheless marks both `risk=low`. The remaining
   plumbing is real work, not a one-line assembly. (The good news: the needed
   lemmas do exist — see job recommendations.)

5. **Cross-gate dependency on a non-present "bank".** Several G1/G2/G3 nodes
   depend on `AUD-002` ("reported bank is verified") and on banked
   observer-channel / super-Dirac theorems (KIN-008, GRAPH-005, GRAPH-007, C9).
   Since the bank is not in the repo, these nodes are blocked on reconstruction,
   not merely on their own proofs.

---

## Gate-by-gate roadmap audit

### G0 — verified finite bank
Correctly placed first. **But G0 is reported "ACHIEVED" with no evidence in this
repo.** AUD-001 (green build), AUD-002 (`#check` inventory), AUD-003 (`#print
axioms` whitelist) are all still `READY_TO_RUN` and *must actually be run here*.
Recommendation: treat G0 as **not started** in this artifact. The three audit
nodes are well-specified and are the correct first deliverables.

### G1 — exact finite null-strand models
The strongest gate and the right first publication target. Ordering is mostly
correct. Issues:
- **MASTER-001 / MASTER-002 are `READY_AFTER_DEPS`, not done.** MASTER-002 needs
  a *general* kernel trajectory measure (Ionescu–Tulcea), which is heavier than
  the i.i.d. `TRAJ-001` used by MASTER-001; the manifest's `risk=medium` for
  MASTER-002 vs `low` for MASTER-001 is right in spirit but both understate the
  trajectory-plumbing cost.
- **HOL-002 (`internalHolonomy_unitary_of_hermitian`) is mis-gated into G1.** The
  internal-holonomy lane is not on the critical path to either capstone and
  carries a genuine Mathlib `NormedAlgebra`/matrix-exponential risk. Move the
  whole `Clock`/holonomy lane to a parallel internal-algebra track (effectively
  G2/G3), so it cannot stall the G1 publication endpoint.
- **KIN-008 depends on `AUD-002` + a banked observer-channel determinant
  theorem.** That is a G0/bank dependency leaking into G1; it is implementable
  only after the bank is reconstructed and the factor-of-two energy normalization
  is reconciled (its own stop condition).

### G2 — covariant kinematics, finite nonlocality
Reasonable. The abstract flux theorem being generic over a barycentric measure
(DEF-005 / MEA-*) is a good design. The `MEA-001` sphere-measure *spike* before
`MEA-002..007` is correctly sequenced (`BLOCKED_ON_SPIKE`). `MEA-004`
(Lorentz covariance) is correctly `BLOCKED_ON_MODEL`. ENT-004 is a clean
`READY_AFTER_DEPS` no-go once ENT-002 lands. **Watch:** the ledger claims a full
`productDirectionRepresentation_iff_separable` *iff* is already proven, which
would subsume ENT-002/003/004 and contradicts both the manifest's careful
one-direction split and roadmap W9 ("prove the easy direction first"). Reconcile
scope before promoting.

### G3 — selected finite dynamics & finite QFT interfaces
Coherent. `ERG-005` (general finite-Markov SLLN) is correctly demoted to a
`LIBRARY_PROJECT` and kept off the G1 critical path — good. `CONT-001` (abstract
Lax–Milgram) is parked here but is genuinely abstract and could be done any time
(Mathlib already has it; see below). `GRAPH-007` is `REPORTED_EXISTING` with a
stop condition flagging mass double-counting — do **not** promote it without the
semantic audit.

### G4 — continuum / many-particle conditional theory
Correctly entirely conditional. CONT-002/003/005, MASTER-004/005, GRAPH-004/005/006
are appropriately `BLOCKED_ON_MODEL`/`BLOCKED_ON_LIBRARY`. CONT-003
(`exp(-2Ds)` sphere correlation) is honestly flagged as having *no* underlying
diffusion process in the project — keep it a research target, not a theorem.

### G5 — graph-derived candidate dynamics
Correctly the highest bar, gated on exhibiting a *concrete* operator. SYNC-006,
CONT-004, GRAPH-009, MASTER-006 are appropriately `DO_NOT_STATE_AS_THEOREM` /
`CONJECTURE`. No change to ordering; the only risk is premature promotion.

**Gate-ordering verdict:** the G0→G5 ordering is sound. The two concrete moves I
recommend are (a) **demote the `Clock`/holonomy lane out of G1**, and (b)
**make explicit that KIN-008 and GRAPH-005/007 carry a G0-bank dependency**, so
they are not scheduled as if self-contained G1/G3 items.

---

## Manifest and backlog consistency audit

Confirmed inconsistencies (kernel/file-tree vs documents, and documents vs each
other):

1. **Existence:** manifest/backlog/traceability/§16/ledger all reference
   `PhysicsSM.NullStrand.*` and `PhysicsSM.Spinor.*` modules that **do not exist
   in this repo**.
2. **Stale state column:** ~16 nodes the ledger calls "integrated-live" are still
   `READY_TO_PROVE`/`STATEMENT_DESIGNED` in the manifest (KIN-006/009/010,
   ERG-001, ENT-001, BELL-004, GRAPH-002, REF-001..004, LA-001, CONT-001, ...).
3. **Declaration-name drift** between manifest and ledger/§16:
   - BELL-004: manifest `operatorBlockZero_implies_rateZero` vs ledger/§16
     `operatorBlockZero_implies_currentZero` (def renamed `operatorBlockCurrent`).
   - KIN-004: manifest `octahedral_isFiniteNullResolution` vs ledger
     `octahedralResolution`.
   - LIFT-001: manifest `surplusDeficitCurrent_divergence_eq` vs ledger/§16
     `residualCurrent_divergence_eq`.
   - REF-003: manifest `refreshKernel_absoluteGap_eq_r` vs ledger
     `refreshKernel_spectralGap_eq_r`.
   - HOL-002: manifest `internalHolonomy_unitary_of_hermitian` vs §16
     `internalSegment_unitary_of_hermitian` (two different decls).
4. **ID reuse:** "KIN-003" labels two distinct theorems in the ledger
   (`octaNull_mean_eq_timelike` and `octa_secondMoment_isotropic`).
5. **Node count mismatch:** manifest CSV has 106 nodes (107 lines incl. header);
   the ledger repeatedly says "all 108 manifest nodes". 106 ≠ 108.
6. **HOL-002/003 status contradiction** within the overnight ledger (proven vs
   open `sorry`), propagated into §16.
7. **Scope contradiction on entanglement:** ledger "full iff proven" vs manifest
   ENT-003/ENT-004 still open vs roadmap W9 "easy direction first".
8. **Backlog exit criteria not satisfiable as written:** PR08 ("Finite
   capstones") lists `#print axioms approved; examples execute`, but its inputs
   (MASTER-001/002) are blocked on the `infinitePi` iid plumbing and a general
   trajectory measure per the ledger. PR08 is not closable in the state implied
   by §16.
9. **Two separate codebases conflated by the publication plan.** The plan's
   "Banked" P1-F rests on `PhysicsSM.Spinor.PluckerMass` / `PhysicsSM.Draft.*`,
   which is a *different* module namespace from the roadmap's
   `PhysicsSM.NullStrand.*`. Neither is present. The plan's "Banked/Near" labels
   are unverifiable here and should not be cited as evidence for the roadmap.

**Recommendation:** stop maintaining the CSV/JSON manifest by hand. Generate it
from in-tree Lean annotations after G0, exactly as W0 prescribes, and add a CI
check that fails if a node's claimed state disagrees with the presence/`sorry`
status of its declaration. Until then, trust the manifest `formal_state` column
over the prose, and trust the kernel over the manifest.

---

## Promotion recommendations

Because nothing is in the tree, "promotion into trusted `PhysicsSM/NullStrand`"
has a prerequisite step:

**Step 0 (gating everything): land the code.** Commit/reconstruct the
`PhysicsSM/NullStrand` tree into this repository, then run AUD-001/002/003 here:
clean `lake build`, an `Audit/Inventory.lean` that `import`s and `#check`s every
claimed declaration, and `#print axioms` on every public capstone with a
whitelist (`propext`, `Classical.choice`, `Quot.sound`, plus `Lean.ofReduceBool`
only if `native_decide`/`decide` is used). No promotion before this passes here.

**First promotion wave (Mathlib-only, convention-independent — lowest risk):**
- PR02 probability primitives: DEF-006 `FiniteKernel`, DEF-007
  `FiniteJumpGenerator`, STO-001 `pushforward_comp` (`PMF.bind_bind`), STO-002
  `masterEquation_mass_conserved`.
- GRAPH-002 `support_square_subset_relComp`.
- ERG-001 `iidNullSteps_empiricalMean_tendsto` (wraps
  `ProbabilityTheory.strong_law_ae`).
- CONT-001 `coerciveWeightedPoisson_exists_unique` (abstract Lax–Milgram; Mathlib
  has `InnerProductSpace.continuousLinearMapOfBilin` +
  `unique_continuousLinearMapOfBilin`).

These need no `Conventions` reconciliation and are the safest trusted surface.

**Second wave (need a self-contained `Conventions` with `IsFutureNull`):**
- KIN-006/007/009 flux mean/variance/clock-rate, KIN-010/011 no-go lemmas — all
  must be re-expressed over the canonical `Conventions.minkowskiInner` (the
  ledger notes KIN-006 used a *local* `minkowskiInner` copy, which is exactly the
  convention-drift G0/DEF-001 is meant to prevent). Do not promote with a local
  copy.

**Hold (do not promote yet):**
- GRAPH-007 `superDirac_sq_decomposition` (`REPORTED_EXISTING`, stop condition =
  mass double-counting): audit first.
- Anything labelled "iff separable" until the ENT-002/003/004 scope contradiction
  is resolved.
- HOL-002/003 until the proven-vs-`sorry` contradiction is resolved by an actual
  `#print axioms` here.

---

## New Aristotle job recommendations

All jobs assume the tree has been landed and `import Mathlib` is available. Each
states a target, key imports/context, and expected difficulty. Difficulty is
relative to a strong proof specialist.

1. **G0 audit harness (AUD-001/002/003).** *Not a theorem job* — engineering:
   green `lake build`, `Audit/Inventory.lean` (`#check` every claimed decl),
   `Audit/Axioms.lean` (`#print axioms` + forbidden-token scan). **Difficulty:
   low**, but it is the precondition for everything.

2. **PR02 finite probability primitives.** Targets DEF-006/007, STO-001
   `pushforward_comp` (`PMF.bind_bind`), STO-002 `masterEquation_mass_conserved`
   (`Finset.sum_comm` + row-sum-zero). Imports: `Mathlib` (PMF monad). **Low.**

3. **GRAPH-002 `support_square_subset_relComp`.** `D q q'' = ∑ D q k * D k q''`;
   contrapositive + `Finset.sum_eq_zero`. Imports: `Mathlib` (`Matrix`).
   **Low.**

4. **ERG-001 `iidNullSteps_empiricalMean_tendsto`.** Wrap
   `ProbabilityTheory.strong_law_ae` for `Minkowski4 = EuclideanSpace ℝ (Fin 4)`
   valued i.i.d. increments; conclude a.s. empirical-mean → barycenter `U`.
   Context: `open ProbabilityTheory`, integral-form mean, integrability of bounded
   null directions. **Medium.**

5. **ERG-002 `iidNullTrajectory_coarseVelocity_tendsto_timelike`.** Derive
   `(1/N)·(X_N − X_0) → U` a.s. from ERG-001 by telescoping the partial sums;
   watch the documented off-by-one indexing. Imports: `Mathlib`, depends on #4.
   **Low–medium.**

6. **KIN-006/007/009 flux identities over canonical conventions.** Re-prove
   `finiteFluxDirectionMean_eq_relativeVelocity`, `..._variance_eq_invGammaSq`,
   `finiteFluxMean_dsdt_eq_invGamma` against `Conventions.minkowskiInner` (not a
   local copy). Mostly `field_simp`/`Finset.sum_div`/`Cauchy–Schwarz`. Context:
   the factorization `π(w) ∝ (n·k(w)) ν(w)`, `observerDir = k/(n·k) − n`.
   **Medium.**

7. **CONT-001 abstract Lax–Milgram wrapper.** State a bounded coercive bilinear
   form on a complete real inner-product space has a unique weak solution; build
   on `InnerProductSpace.continuousLinearMapOfBilin` and
   `unique_continuousLinearMapOfBilin`. **Crucially keep it abstract** (its stop
   condition is "accidentally claims a sphere PDE instance"). Imports:
   `Mathlib.Analysis.InnerProductSpace.Dual`. **Medium.**

8. **REF-002/003/004 refresh-chain spectrum.** For the rank-one refresh kernel
   `P = (1−r)·Id + r·(𝟙 πᵀ)`: invariant law, mean-zero eigenvalue `(1−r)`,
   absolute gap `r`, direction correlation `(1−r)^k`. Pure finite linear algebra;
   give a precise "absolute gap" definition to satisfy REF-003's stop condition.
   Imports: `Mathlib` (`Matrix`, eigenvalues). **Medium.**

9. **ENT-001 + ENT-002 easy direction.** `pureDirectionProjector` (2×2 Bloch
   `½(I + n·σ)`: trace 1, Hermitian, idempotent) and
   `productDirectionMixture_isSeparable` (convex combo of product rank-one
   projectors is separable). Keep ENT-003 (converse, needs Bloch/Schmidt
   parametrization) and ENT-004 as separate later jobs — do **not** let the job
   silently prove the full iff. Imports: `Mathlib`. **Medium.**

10. **MASTER-001 assembly.** Combine `Barycentric.octahedralResolution`
    (or any FiniteNullResolution), ERG-002 (#5), and an i.i.d. trajectory measure
    into `finiteIIDNullStrand_master`. The decisive missing plumbing — i.i.d.
    coordinates of a product measure — is available in Mathlib:
    `Mathlib/Probability/Independence/InfinitePi.lean` (`iIndepFun_uncurry`,
    coordinate `iIndepFun` + `IdentDistrib`) feeding `strong_law_ae`. Provide
    these names in context. **Medium–hard** (this is the real G1 endpoint, not a
    one-liner). Its docstring must say the result is *kinematic* (its stop
    condition: "mislabeled as Bohm–Bell dynamics").

Secondary queue, smaller and independent: ZZ-005 `minimalTwoStateCoupling_unique`
(uniqueness of the minimum-off-diagonal coupling of two 2-state Born laws);
LA-002 `zeroSum_source_in_laplacian_range` and LA-003 `minimumEnergyFlow_unique`
(connected-graph weighted Laplacian); SYNC-001/002 diamond defect /
order-independence; BELL-002 `zeroBornWeight_implies_noOutgoingCurrent`.

---

## Items to split into smaller proof-specialist jobs

- **MASTER-001** → (a) `infinitePi` coordinate-iid wiring lemma; (b) ERG-002 from
  ERG-001; (c) final conjunction/packaging. (Job #10 above is really these three.)
- **MASTER-002** → (a) ZZ-005 unique two-state coupling; (b) ZZ-006..009 one-/
  n-step equivariance assembly; (c) a *general* (non-iid) Ionescu–Tulcea
  trajectory measure `TRAJ-001`; (d) the conjunction capstone. Do not submit as
  one job.
- **LA lane** → LA-001 (done?) / LA-002 / LA-003 / LA-004 as four separate jobs;
  LA-003 uniqueness and LA-004 induced-rates are independent of each other.
- **Graph super-Dirac (GRAPH-004/005/006)** → split "exhibit one concrete
  order-complex operator + soldering map" from "compute its local symbol" from
  "square = weighted Plücker mass". Most value is in the *construction* job.
- **ZZ lane** → keep ZZ-002 (algebraic minimal-rate transfer, finite) separate
  from ZZ-004 (Dirac-PDE instantiation), which should be deferred entirely.
- **KIN flux** → mean / variance / clock-rate / mass-ratio as four small jobs
  (they share the same factorization lemma, which should itself be one job).

---

## Items to keep as conjectures or model-design tasks (not Lean theorems yet)

These are correctly classified in the manifest and should stay open; do not
schedule them as provable theorems:

- **O1–O8** open registry (covariant mixing gap, continuum process near nodes,
  entanglement-vs-curvature, operational internal clock, graph super-Dirac
  symbol, null-local/continuum operator, natural null dilation, observed mass
  spectrum).
- GRAPH-004, GRAPH-006, GRAPH-009 (`CONJECTURE`/`BLOCKED_ON_MODEL`).
- CONT-003, CONT-004, CONT-005 (need a constructed diffusion semigroup / SDE that
  does not exist in Mathlib at the needed generality).
- SYNC-005, SYNC-006 (rule-dependent computation / `DO_NOT_STATE_AS_THEOREM`).
- HOL-004 (operational clock — needs a readout-coupling model first).
- MASTER-004/005/006 (continuum / many-particle / graph master theorems —
  conditional only).
- ZZ-004 (Dirac-PDE transfer) and MEA-004 (Lorentz covariance) until the
  supporting analytic/model infrastructure is built.
- ERG-005 (general finite-Markov SLLN) — pursue as a standalone Mathlib-facing
  library project, off the critical path.

---

## Publication positioning recommendations

The publication plan's house rule ("lead with finite kernel-checked algebra; keep
continuum physics explicitly conjectural") is correct and should be enforced
literally.

- **Coherent first paper (theorem paper).** Once G0 + the first promotion wave are
  *actually in the kernel here*, the honest first artifact is the **finite i.i.d.
  null-strand kinematics + the abstract finite flux theorem**: nullity of every
  increment, exact position law, a.s. timelike coarse drift (MASTER-001), plus the
  observer-flux mean/variance/clock-rate identities (KIN-006/007/009) and the
  no-go guardrails (KIN-010/011). This is self-contained, finite, and provable
  with current Mathlib. Frame it strictly as **kinematics / formalized
  mathematics**, not as "Bohm–Bell dynamics" (the manifest's own MASTER-001 stop
  condition).
- **Second paper.** The exact 1+1 **checkerboard Bohm process** (MASTER-002):
  unitary wave evolution + exact Born equivariance + a genuine infinite
  trajectory + null-at-every-tick. This is the cleanest "actual Bohmian null-step
  theory" claim, but it requires the general trajectory-measure work, so it should
  trail the first paper.
- **The publication plan's P1-F ("mass as Plücker spread")** is a *different*
  codebase (`PhysicsSM.Spinor.*`) and is not part of the NullStrand tree. It may
  well be the most banked artifact in the broader program, but its "Banked" status
  cannot be confirmed from this repository. Do not let the NullStrand roadmap
  borrow P1-F's "Banked" label as if it were NullStrand evidence.
- **Explicitly defer** (cite as future targets only, with status labels): all
  continuum mixing/gap claims (no universal gap as `m→0`), the synchronization
  curvature ↔ entanglement equivalence (rule-dependent), the graph super-Dirac
  unification (no concrete operator yet), the Yukawa/mass spectrum (nothing
  derives it), and any "internal phase is a physical clock" claim (no readout
  coupling).
- **Claim-status matrix is mandatory** in every manuscript, with the plan's
  Theorem / Draft-theorem / Conjecture / Analogy / Ontology labels, and a
  reproducibility appendix (commit hash, toolchain, `#print axioms` output,
  paper-notation ↔ Lean-declaration crosswalk). Given finding #1, the appendix is
  the single most important honesty device: a referee must be able to rebuild the
  exact theorems.

---

## Concrete edit list for the roadmap

1. **§16 "Implementation progress": replace all "achieved/green/integrated"
   language with reported status pending a rebuild in *this* repository.** State
   plainly that the `PhysicsSM/NullStrand` tree is not present in this artifact and
   that G0 (AUD-001/002/003) has not been executed here. This is the single most
   important edit.
2. **Add a "maturity ledger" table** mapping each cited node to {reported, in-tree
   with `sorry`, in-tree `sorry`-free, axiom-audited} and *generate it from the
   kernel*, not by hand.
3. **Fix the manifest `formal_state` column** so it matches reality, or delete the
   prose status claims in §16 that contradict it. Pick one source of truth (the
   kernel) and regenerate the CSV/JSON from annotations (per W0).
4. **Reconcile declaration names** across manifest/§16/ledger for BELL-004,
   KIN-004, LIFT-001, REF-003, HOL-002 (list in the consistency-audit section).
   One canonical name per node.
5. **Resolve the HOL-002/HOL-003 contradiction** by an actual `#print axioms`
   here; mark them `sorry` until proven in-tree. Move the entire `Clock`/holonomy
   lane out of G1 (to a parallel internal-algebra track).
6. **Resolve the entanglement scope contradiction:** decide whether only the easy
   direction (ENT-002) or the full iff is in scope; update W9, ENT-003/004, and
   the ledger to agree.
7. **Annotate KIN-008, GRAPH-005, GRAPH-007 and claim C9 with their G0-bank
   dependency** so they are not scheduled as self-contained.
8. **Fix the node count** (manifest = 106 nodes; ledger says 108) and the "all 108
   nodes" language.
9. **In the critical-path diagram, expand `MASTER-001` and `MASTER-002`** to show
   the trajectory-measure / `infinitePi` iid plumbing as explicit prerequisite
   nodes, so they are not read as trivial assemblies.
10. **Separate the publication plan's two namespaces** (`PhysicsSM.Spinor.*` P1-F
    vs `PhysicsSM.NullStrand.*`) in any cross-reference, and do not inherit P1-F's
    "Banked" label into NullStrand claims.
11. **Add a CI rule** (already implied by §11/§12) that fails when a manifest node
    state disagrees with the in-tree `sorry`/presence status of its declaration,
    and when any public capstone's `#print axioms` leaves the whitelist.

---

### One-line bottom line
The roadmap is a good plan wrapped around an unverified claim of completion: the
plan's methodology is sound and the G1 finite endpoints are genuinely reachable
with current Mathlib, but **no NullStrand Lean code exists in this repository**,
so every "verified/banked/green" status must be downgraded to "reported" until
the tree is landed and gate G0 is actually executed here.
