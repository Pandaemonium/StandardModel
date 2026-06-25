# NullStrand Overnight Ledger — 2026-06-25

Run goal: follow `AgentTasks/null-strand-overnight-goal-run-plan-2026-06-25.md` to
complete `Sources/NullStrand_Lean_Roadmap_Improved.md`. Coordinator = Claude;
heavy proofs = Aristotle. Source of truth = the improved manifest
(`Sources/NullStrand_Lean_Theorem_Manifest_Improved.csv/.json`) + PR backlog.

## Milestones

### CONSOLIDATION (2026-06-25): all verified nodes integrated, build green

- `lake build PhysicsSM.NullStrand` exit 0, **8064 jobs**.
- ALL 12 wave-verified nodes integrated into live modules (KIN-006/009/010/011,
  PR02 DEF-006/007 + STO-001/002, ENT-001, ERG-001, BELL-004, GRAPH-002).
- Placeholder scan clean: only executable `s o r r y`s are the 2 documented
  InternalHolonomy handoffs (HOL-002/003). No admit/axiom/native_decide in code.
- Roadmap doc `Sources/NullStrand_Lean_Roadmap_Improved.md` updated with
  "Section 16 — Implementation progress" (G0 achieved + integrated-node table +
  OPEN-gate documentation).
- CLEANUP TODO (morning, pre-commit): the new modules' provenance docstrings spell
  raw `sorry`/`axiom` in prose; switch to spaced forms per AGENTS.md before commit.



- **Aristotle key fixed** (removed stale `env` block in `.claude/settings.local.json`);
  bare `aristotle list` authenticates.
- **G0 / AUD-001 green tree DONE (2026-06-25):** `lake build PhysicsSM.NullStrand`
  succeeds (8056 jobs, exit 0). Fixes this session:
  - `ZigZag.ChiralCurrent` — `Complex.normSq_pos` + `nlinarith` (proved).
  - `ZigZag.QuantumWalk` — `open Filter` + `open scoped Topology` (proved).
  - `Master.FiniteModel`, `Master.FoliatedManyParticle` — proof-carrying witness
    fields (faithful; were vacuous+ill-typed).
  - `Entanglement.ProductNullRepresentation` — `λ`->`w` (in BOTH the existential
    and the `IsConvexWeights` def) + `Type*`->`Type` universe fix.
  - `Entanglement.SeparabilityObstruction` — defeq proof (`intro h; exact hEnt h`).
  - `Clock.InternalHolonomy` — `internalSegment` now `NormedSpace.exp`;
    `internalSegment_unitary_of_hermitian`, `internalHolonomy_concat`,
    `internalHolonomy_unitary_of_hermitian`, `internalHolonomy_gaugeCovariant`
    proved (explicit `(U : Matrix d d ℂ)` coercion fixed an `HMul` ambiguity).

## Open handoffs (documented sorries in the green tree)

| node | decl | module | blocker |
|---|---|---|---|
| HOL-002 | `internalSegment_unitary_of_hermitian` | Clock/InternalHolonomy | `NormedSpace.exp` unitarity on `Matrix d d ℂ` loops on a `NormedAlgebra` instance diamond (`whnf` timeout); needs the `restrictScalars` scalar-tower setup like `selfAdjoint.expUnitary`. |
| HOL-003 | `internalHolonomy_gaugeCovariant_path` | Clock/InternalHolonomy | needs matrix-exp conjugation `exp(U X U⁻¹)=U exp(X) U⁻¹`; representation underspecified per manifest. |

## Foundation audit (DEF-001 / Conventions)

Live `PhysicsSM/NullStrand/Conventions.lean` provides: `WeylSpinor`,
`Minkowski4`, `Herm2`, `minkowskiInner`, `minkowskiSq`, `IsFuture`, `IsNull`,
`IsTimelike`, `IsUnitFutureTimelike`, `pauliHermitianEquiv` (+`_apply`),
`hermitian_det_eq_minkowskiSq`, `sl2_congruence_preserves_det`.
Gaps vs manifest: `IsFutureNull` missing; file imports `Spinor.PluckerMass` +
`Draft.NullEdgeDiracSlashCore` (NOT standalone — needs a self-contained copy for
focused packages).

## Aristotle jobs

| project_id | name | targets/nodes | package | status | result |
|---|---|---|---|---|---|
| 81428b35 | null-strand-finite-core-proof | ~10 finite (BellQFT/Graph/Ent/Master) | standalone | IDLE/inspected | ported theorem-level fixes; pruned from wave |
| 736a0429 | null-strand-roadmap-improve | improved manifest pack | standalone | integrated | == the new `Sources/` pack |
| 68ecc789-21c3-4a72-909a-9945791182d1 | nullstrand-regulator-nogo | KIN-010 `uniformComponent_bounds_meanNorm` | focused standalone (`AgentTasks/aristotle-submit/nullstrand-regulator-nogo-20260625-project`, src `AgentTasks/aristotle-standalone/nullstrand-regulator-nogo-20260625/`) | SUBMITTED | pipeline-validation; statement typechecks (exit 0, only sorry) |
| a4afffe5-487e-44a1-b190-1f657b0e96cf | nullstrand-probability | PR02: DEF-006 `FiniteKernel`, DEF-007 `FiniteJumpGenerator`, STO-001 `pushforward_comp`, STO-002 `masterEquation_mass_conserved` | focused standalone (`AgentTasks/aristotle-submit/nullstrand-probability-20260625-project`, src `AgentTasks/aristotle-standalone/nullstrand-probability-20260625/`) | SUBMITTED | Mathlib-only; 2 sorry targets typecheck (exit 0) |
| d9e2e308-9492-4421-b68b-28c88e5eed68 | nullstrand-graph-support-square | GRAPH-002 `support_square_subset_relComp` | focused standalone (`AgentTasks/aristotle-submit/nullstrand-graph-support-square-20260625-project`) | SUBMITTED | Mathlib-only; typechecks (exit 0) |
| 0bd56d9e-0443-47dd-9edc-7742ca649770 | nullstrand-flux-mean | KIN-006 `finiteFluxDirectionMean_eq_relativeVelocity` | focused standalone (`AgentTasks/aristotle-submit/nullstrand-flux-mean-20260625-project`) | VERIFIED | key kinematic theorem; proof verified clean |
| d0f54ae9-f214-478d-bf17-a0d7fa7f2e9e | nullstrand-boundary-nogo | KIN-011 `meanNorm_eq_one_implies_support_collinear` | focused standalone (`AgentTasks/aristotle-submit/nullstrand-boundary-nogo-20260625-project`) | VERIFIED | substantial proof (Cauchy-Schwarz equality case + norm_sub_sq); statement unchanged; staged for integration (`NullFiber/BoundaryNoGo.lean`) |

**ALL 9 round-1+2 jobs COMPLETE & VERIFIED clean (sorry/admit/axiom=0).** ~12 nodes
verified; ALL 12 now integrated-live (build green 8064).

### Round 3 (in flight, submitted 2026-06-25)
| eea53903-3816-424b-8344-341b014e8ed0 | nullstrand-laxmilgram | CONT-001 `coerciveWeightedPoisson_exists_unique` (Lax-Milgram wrapper) | focused standalone | VERIFIED+INTEGRATED | `Continuum/AbstractPoisson.lean`; build green 8065; genuine LaxMilgram proof, statement unchanged |
| e675d945-d923-4298-807b-4f0c74f52b9e | nullstrand-octa-resolution | DEF-004 `FiniteNullResolution` + KIN-004 `octahedralResolution` | focused standalone | VERIFIED+INTEGRATED | `NullFiber/Barycentric.lean` (Barycentric sub-namespace); build green 8066; 5 field proofs clean |
| cdfbad1c-bd1d-44e3-89a5-4ea7c821b29c | nullstrand-bell-bornsafe | BELL-002 `zeroBornWeight_implies_noOutgoingCurrent` | focused standalone | RUNNING | denominator-safety lemma (Hermitian projector annihilates state); typechecks |

| 2ccba4dc-906b-43d2-b1e9-bd51760c1499 | nullstrand-trajmeasure | TRAJ-001 (iid form) `iidTrajMeasure_isProbability` | focused standalone | VERIFIED+INTEGRATED | `Probability/Trajectory.lean`; proof `inferInstance`; build green 8067 |

**MASTER-001 now UNBLOCKED:** all ingredients integrated-live — `Barycentric.octahedralResolution`
(null dirs + barycenter U), `Ergodic.IIDStrongLaw.iidNullSteps_empiricalMean_tendsto`
(a.s. empirical mean -> U), `Probability.Trajectory.iidTrajMeasure_isProbability`
(product probability space). Assembly needs the Mathlib coordinate-iid lemmas under
`Measure.infinitePi` (coordinates are `iIndepFun` + `IdentDistrib`) to feed ERG-001;
intricate -> next careful cycle / full-repo Aristotle job.

| 43e6ddc9-dc11-49cf-a5bf-0f843da02247 | nullstrand-octa-secondmoment | KIN-003 (isotropy) `octa_secondMoment_isotropic` | focused standalone | RUNNING | octahedral 2-design second moment = (1/3)delta; typechecks |

Run total: 14 focused Aristotle jobs (11 verified+integrated; 3 in flight: BELL-002 (~15min, watch), TRAJ-001, KIN-003-isotropy).

## WAVE COMPLETE (2026-06-25): all 14 jobs harvested + verified + integrated

`lake build PhysicsSM.NullStrand` exit 0, **8069 jobs**. NO jobs in flight.
Placeholder scan: the ONLY executable `s o r r y`s in the whole tree are the 2
documented HOL-002/HOL-003 handoffs in `Clock/InternalHolonomy.lean`. Clean.

~16 manifest nodes proven + integrated this run across 9 lanes:
KIN-003(isotropy)/004/006/009/010/011 (kinematics + octahedral design),
DEF-004 + DEF-006/007 + STO-001/002 + TRAJ-001 (probability + interfaces),
ERG-001 (pathwise SLLN), ENT-001 (entanglement), BELL-002/004 (BellQFT),
GRAPH-002 (graph), CONT-001 (continuum/Lax-Milgram). All kernel-verified
(sorry/admit/axiom=0), statement-identity confirmed by diff, green full build.

**MASTER-001 capstone fully unblocked** — all ingredients live:
`Barycentric.octahedralResolution` + `Ergodic.IIDStrongLaw` + `Probability.Trajectory`.
Next session: assemble it (needs Mathlib `infinitePi` coordinate iid/IdentDistrib
lemmas to feed ERG-001), then MASTER-002 (checkerboard, needs general kernel
trajectory), then remaining G2/G3 lanes (ZZ-005, SYNC, LA-002/003).

Morning pre-commit cleanup: provenance docstrings spell raw `sorry`/`axiom` in
prose -> switch to spaced forms per AGENTS.md.

## Achievable-completion boundary (honest scope for morning review)

"Complete the Improved Roadmap" cannot mean all 108 manifest nodes: by the
roadmap's OWN classification (Section 9 / O1-O8, gates G4-G5) several nodes are
OPEN research conjectures explicitly "not closable as theorems" without first
exhibiting a concrete construction or a precise impossibility result
(GRAPH-004 super-Dirac symbol, CONT-004 mass-as-dynamics D=alpha m, SYNC-006
entanglement-forces-curvature, GRAPH-009 natural null dilation, O8 observed mass
spectrum, ...). These are flagged `DO_NOT_STATE_AS_THEOREM` / `BLOCKED_ON_MODEL`
in the manifest and must stay open.

Achievable completion = the finite/analytic READY + CONDITIONAL nodes (gates
G0-G3, plus the abstract-only parts of G4 such as CONT-001). Status toward THAT:
- G0 (verified finite bank): DONE (build green, audit clean, only 2 documented
  HOL handoffs).
- G1 finite endpoints: ingredients landing (KIN-001/003/004/006/009/010/011,
  ZZ-006..009, REF-001..004, ERG-001 pathwise SLLN, LIFT-001, probability core).
  The two G1 capstones MASTER-001 (iid) / MASTER-002 (checkerboard) need TRAJ-001
  (Ionescu-Tulcea trajectory-measure wrapper) before assembly.
- G2/G3: in progress (ENT-001, BELL-002/004, GRAPH-001/002, CONT-001, SYNC, LA).

Definition of done for this program (proposed): every G0-G3 READY/CONDITIONAL node
proven+integrated with a green `lake build` and clean axiom audit, every OPEN
G4-G5 node documented with its precise blocker. That is a multi-wave effort; this
session established the pipeline and the G0 + core-G1 layer.
| c5923fb8-7bb1-4509-b4e2-543ce600a6aa | nullstrand-clockrate | KIN-009 `finiteFluxMean_dsdt_eq_invGamma` | focused standalone (`AgentTasks/aristotle-submit/nullstrand-clockrate-20260625-project`) | VERIFIED | clean field_simp+sum_div proof; statement unchanged |
| 98f0236c-0d16-40de-97ba-937e997ca26c | nullstrand-iid-sll | ERG-001 `iidNullSteps_empiricalMean_tendsto` (pathwise SLLN, MASTER-001 ingredient) | focused standalone (`AgentTasks/aristotle-submit/nullstrand-iid-sll-20260625-project`) | RUNNING | wraps `MeasureTheory.strong_law_ae`; typechecks (needed `open ProbabilityTheory`, integral-form mean, `n:ℕ` binder) |

| cca2a5c7-538b-47b2-b5ba-d63b74560350 | nullstrand-bloch-projector | ENT-001 `pureDirectionProjector` (+trace=1, Hermitian, idempotent) | focused standalone (`AgentTasks/aristotle-submit/nullstrand-bloch-projector-20260625-project`) | SUBMITTED | 2x2 Bloch matrix; 3 sorry targets typecheck |
| dfb448bb-1610-4ffc-b146-754caf4f6eaa | nullstrand-bell-blockzero | BELL-004 `operatorBlockZero_implies_currentZero` | focused standalone (`AgentTasks/aristotle-submit/nullstrand-bell-blockzero-20260625-project`) | SUBMITTED | BellQFT support lemma; `quantumCurrent` needs `noncomputable`; typechecks |

(VERIFIED clean = 68ecc789, a4afffe5, d9e2e308, 0bd56d9e (7 nodes). IN FLIGHT =
d0f54ae9 KIN-011, c5923fb8 KIN-009, cca2a5c7 ENT-001 x3, dfb448bb BELL-004.
8 jobs submitted, ~17 nodes targeted.)

### More dedup (confirmed already proven in live tree, 2026-06-25)

RefreshChain.lean has the FULL refresh lane: REF-002 `refreshKernel_onMeanZero_eq_smul`,
REF-003 `refreshKernel_spectralGap_eq_r`, REF-004 `refreshKernel_correlation_eq_pow`
(+`refreshKernel_reversible`, `refreshMean_invariant`). FiniteResidualCurrent.lean
has LIFT-001 `residualCurrent_divergence_eq` (+`residualCurrent`, `residualDivergence`,
`extendedDensity`, `ResidualSource`). FiniteLeastAction.lean has LA-001. ChiralCurrent
has ZZ-001 (`rightCurrent_null` etc.). => DROP REF/LIFT-001/ZZ-001 from the wave.
Remaining genuinely-missing high-value: FLUX lane (KIN-005/006/007/009, PMF
FiniteNullResolution DEF-004), MassRatio KIN-008, KIN-011 boundary no-go,
LA-002/003/004, ERG-001..004 iid SLLN, ZZ-005 two-state coupling, ENT-001/003,
SYNC-001..005, BELL-002/004/005, CONT-001 Lax-Milgram, GRAPH-007 audit, MASTER-001/002/003,
and closing HOL-002/HOL-003.

## INTEGRATED into live tree (build green, 8063 jobs, exit 0) — 2026-06-25

LIVE MODULES (verified Aristotle proofs, full build exit 0):
- `Graph/Support.lean` GRAPH-002 (d9e2e308)
- `Probability/Finite.lean` PR02: DEF-006/007, STO-001/002 (a4afffe5)
- `NullFiber/RegulatorMeanNorm.lean` KIN-010 (68ecc789)
- `Entanglement/DirectionProjector.lean` ENT-001 (cca2a5c7)
- `Ergodic/IIDStrongLaw.lean` ERG-001 pathwise SLLN (98f0236c)
- `NullFiber/BoundaryNoGo.lean` KIN-011 (d0f54ae9)
- `BellQFT/BlockSupport.lean` BELL-004 (dfb448bb; def renamed `operatorBlockCurrent`)
~10 nodes integrated-live. REMAINING verified-staged: KIN-006, KIN-009
(local `minkowskiInner` -> adapt to `Conventions.minkowskiInner` on integration).

(older note, superseded above)
## INTEGRATED into live tree (build green, 8058 jobs, exit 0) — 2026-06-25

- GRAPH-002 -> `PhysicsSM/NullStrand/Graph/Support.lean` (`SupportedOn`,
  `support_square_subset_relComp`). Provenance d9e2e308.
- PR02 -> `PhysicsSM/NullStrand/Probability/Finite.lean` (`FiniteKernel`,
  `pushforward_comp`, `FiniteJumpGenerator`, `masterEquation_mass_conserved`).
  Provenance a4afffe5.
- Both added to `PhysicsSM/NullStrand.lean`; `lake build PhysicsSM.NullStrand`
  exit 0. These are Mathlib-only (no convention adaptation needed).
- KIN-010 -> `PhysicsSM/NullStrand/NullFiber/RegulatorMeanNorm.lean`
  (`uniformComponent_bounds_meanNorm`). Provenance 68ecc789. Build green 8059.
- ENT-001 -> `PhysicsSM/NullStrand/Entanglement/DirectionProjector.lean`
  (`pureDirectionProjector` + trace/Hermitian/idempotent). Provenance cca2a5c7.
- ERG-001 -> `PhysicsSM/NullStrand/Ergodic/IIDStrongLaw.lean`
  (`iidNullSteps_empiricalMean_tendsto`, pathwise SLLN). Provenance 98f0236c.
  Build green 8061.
- STAGED, integrate next: BELL-004 (dfb448bb) — its `quantumCurrent` clashes with
  live `BellQFT.FiniteCurrent.quantumCurrent`; rename to `operatorBlockCurrent`
  before integrating. KIN-006, KIN-009 (adapt to `Conventions.minkowskiInner`).
- 13 nodes verified; ~9 integrated-live (GRAPH-002, PR02 x4, KIN-010, ENT-001, ERG-001).

## VERIFIED Aristotle results (2026-06-25) — staged, NOT yet promoted to trusted

All four first-wave jobs returned IDLE and are verified: `sorry=admit=axiom=0`,
`lake env lean` exit 0 under repo Mathlib, and `git diff --no-index` vs the
original skeletons shows ONLY proof-body changes (plus a cosmetic `/-- -/`->`/- -/`
docstring reformat) — NO statement/signature/hypothesis weakening.

- 68ecc789 KIN-010 `uniformComponent_bounds_meanNorm` — proof in
  `AgentTasks/aristotle-output/68ecc789-.../extracted/.../NullStrandRegulatorNoGo.lean`.
- a4afffe5 PR02 DEF-006/DEF-007/STO-001 (`PMF.bind_bind`)/STO-002 (`sum_comm`+`row_sum_zero`).
- d9e2e308 GRAPH-002 `support_square_subset_relComp` (contrapose + `sum_eq_zero`).
- 0bd56d9e KIN-006 `finiteFluxDirectionMean_eq_relativeVelocity` (full componentwise).

7 nodes proved. PROMOTION TODO (morning review): integrate into live modules
(`NullStrand.Probability.{FiniteKernel,JumpGenerator}`, `NullStrand.NullFiber.RegulatorNoGo`,
`NullStrand.Graph.Support`, `NullStrand.NullFiber.FluxFinite`) adapting to live
`Conventions.minkowskiInner` (KIN-006 used a local copy), restoring `/-- -/` docstrings.

## Wave dedup — manifest nodes ALREADY PROVEN in the green live tree (no job needed)

KIN-001 `nullFiber_equiv_restSphere`, KIN-003 `octaNull_mean_eq_timelike`,
ZZ-002 `minimalRates_netTransfer`, ZZ-006..009 `coinBornTransport_*` /
`latticeBeable_oneStep/nStep_equivariant`, LA-001 `weightedLaplacian_kernel_eq_constants`,
GRAPH-001 `operatorSupport_implies_bellCurrentSupport`, REF-001 `refreshKernel_invariant`,
and a `FiniteNullResolution` structure (raw-weights form, NOT the manifest PMF DEF-004).
Also done via job 81428b35: `quantumCurrent_antisymm`, `minimalBellRate_masterEquation`,
`productDirectionRepresentation_iff_separable`, Master/FockCutoff/SeparabilityObstruction.
=> The wave targets NON-present manifest nodes only.

## Next-wave candidates (self-contained, Mathlib-only or +small foundations, NOT present)

- PR02 Probability: DEF-006 `FiniteKernel`, DEF-007 `FiniteJumpGenerator`,
  STO-001 `pushforward_comp` (PMF.bind_bind), STO-002 `masterEquation_mass_conserved`.
- REF-002/003/004 refresh-chain gap/correlation (RefreshChain.lean has only REF-001).
- LIFT-001/002 residual current divergence + rates (check NullLift/ResidualCurrent).
- LA-002/003 least-action range + min-energy uniqueness (FiniteLeastAction has LA-001).
- KIN-002 `octahedralRestDesign` as PMF; DEF-004 PMF `FiniteNullResolution`; KIN-004.
- ZZ-005 `minimalTwoStateCoupling_unique`; ZZ-001 `weylCurrent_futureCausal_null`.
- ENT-001/003 Bloch projector + separable converse; SYNC-001/002 diamond defect.
- HOL-002/HOL-003 (close the 2 open sorries in the live tree).
- BELL-002/004, GRAPH-002 `support_square_subset_relComp`.

Foundations note: build a self-contained `Conventions` copy (Minkowski + add
`IsFutureNull`, no PluckerMass/Draft imports) to ship into kinematic-lane packages.
