# NullStrand Lean roadmap hardening report

Job: `null-strand-roadmap-hardening-20260625`
Date: 2026-06-25
Scope: harden `Sources/NullStrand_Lean_Roadmap_Improved.md` into an
execution-ready program, validated against the live `PhysicsSM/NullStrand/` tree.

This is a strategy and audit deliverable, not a proof attempt. Lean is treated as
authoritative throughout: every claim below was checked against the actual
declarations in the repository, not against the prose roadmap.

Placeholder tokens are written in spaced form (`s o r r y`, `a x i o m`,
`a d m i t`) per `AGENTS.md` text-hygiene rules.

---

## 0. Method and evidence base

What was read:

- Roadmap: `Sources/NullStrand_Lean_Roadmap_Improved.md` (full), legacy
  `Sources/NullStrand_Lean_Roadmap.md`, publication plan
  `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`.
- Metadata: `Sources/NullStrand_Lean_Theorem_Manifest_Improved.csv` (106 nodes),
  `Sources/NullStrand_Lean_PR_Backlog.csv`,
  `Sources/NullStrand_Lean_Claim_Traceability.csv`, and the JSON manifest.
- Governance: `AGENTS.md`.
- Lean: the full `PhysicsSM/NullStrand/` tree (38 files, ~2690 lines; 113
  `theorem`, 15 `structure`, 60 `def`, 17 `abbrev`), plus the four
  `PhysicsSM.Draft.*` cores it imports.

What was verified mechanically (source scans on this checkout):

- No `s o r r y`, `a d m i t`, or `a x i o m` declarations occur in
  `PhysicsSM/NullStrand/`. (The only matches are inside provenance comments of
  the form "verified `s o r r y`/`a x i o m`-free".)
- The four `PhysicsSM.Draft.*` modules imported by the trusted tree
  (`NullEdgeBundleDiracPluckerCore`, `NullEdgeNullStepQuantumWalkCore`,
  `NullEdgeDiracSlashCore`, `SpinorHelicityRankOneAristotle`) are themselves
  `s o r r y`/`a x i o m`-free at present.

What was NOT verified here, and remains required for G0:

- A clean full `lake build` under the pinned toolchain was not re-run in this
  session (the roadmap reports exit 0, 8292 jobs on 2026-06-25). Treat
  "build green" as reported-but-not-reconfirmed in this pass.
- No generated import inventory or capstone `#print axioms` assumption whitelist exists yet.

Net: the live finite tree is in materially better shape than a first read of the
manifest suggests (most G1 leaf lemmas are proven), but the headline capstones
are not what their names imply, and the metadata has drifted from the code. Those
two facts are the core of this report.

---

## 1. Roadmap-vs-Lean validation (Task 1)

### 1.1 Strong points confirmed

The kinematic and finite-probability spine is real and clean:

- Null-fiber core: `nullFiber_equiv_restSphere`, octahedral design lemmas
  (`octaDirection_*`, `octaNull_mean_eq_timelike`, `octa_secondMoment_isotropic`).
- Abstract finite flux: `finiteFluxDirectionMean_eq_relativeVelocity`,
  `finiteFluxMean_dsdt_eq_invGamma` and the regulator no-go
  (`meanNorm_eq_one_implies_support_collinear`).
- Finite probability API: `FiniteKernel`, `FiniteJumpGenerator`,
  `pushforward_comp`, `masterEquation_mass_conserved`.
- Pathwise SLLN: `iidNullSteps_empiricalMean_tendsto` is a genuine, honest
  wrapper of Mathlib `MeasureTheory.strong_law_ae`.
- Checkerboard algebra: `coinBornTransport_isStochastic`,
  `latticeBeable_oneStep_equivariant`, `latticeBeable_nStep_equivariant`,
  `actualShift_speed_eq_c`.
- Refresh chain: invariant, mean-zero eigenvalue, spectral gap, correlation
  (`refreshKernel_*`).
- Entanglement and Bell finite layer, Clock holonomy, finite least action,
  abstract weighted Poisson (Lax-Milgram wrapper) are all present and proven.

These match the roadmap's intent and convention choices.

### 1.2 Critical finding: the G1 capstones are content-free shells

The single most important issue. The roadmap (sections 8.1, 8.2) and the manifest
(MASTER-001, MASTER-002) name two G1 endpoints:

- `finiteIIDNullStrand_master`
- `checkerboardBohmBell_master`

Neither declaration exists anywhere in `PhysicsSM/`. A grep for both names returns
only docstring mentions. What does exist is `Master/FiniteModel.lean`:

```
structure FiniteNullStrandModel where
  Configuration : Type*
  [instFintype : Fintype Configuration]
  eachContinuousStepIsNull : Prop
  positionMarginalIsBorn : Prop
  empiricalVelocityConvergesToBaseCurrent : Prop
  eachContinuousStepIsNull_holds : eachContinuousStepIsNull
  positionMarginalIsBorn_holds : positionMarginalIsBorn
  empiricalVelocityConvergesToBaseCurrent_holds : empiricalVelocityConvergesToBaseCurrent

theorem finiteNullStrand_master (M : FiniteNullStrandModel) :
    M.eachContinuousStepIsNull and M.positionMarginalIsBorn
      and M.empiricalVelocityConvergesToBaseCurrent := ...  -- projects the witnesses
```

This is logically well-typed and not vacuous in the `False`-implies-anything
sense (the module docstring is honest that the witness-free version was both
vacuous and ill-typed). But it carries zero physics content: the three physical
claims are abstract `Prop` fields supplied as hypotheses, and the theorem merely
projects their bundled proofs back out. Critically:

- there is no constructed value of `FiniteNullStrandModel`;
- nothing connects it to the proven concrete pieces (`LatticeBeable`
  equivariance, `actualShift_speed_eq_c`, `iidNullSteps_empiricalMean_tendsto`);
- so G1 is, in substance, not reached, even though every ingredient is proven.

`Master/FoliatedManyParticle.lean` (`foliatedManyParticleNullStrand_master`,
MASTER-005) has the same shape and is honestly a conditional schema, which is
acceptable for G4. For G1 it is not: the program's whole claim is that one
realized history is microscopically null and macroscopically timelike, and that
the checkerboard process is Born-equivariant with null steps. That claim must be
the conclusion of a theorem whose hypotheses are concrete, not a re-export of an
assumed `Prop`.

This is the gate that decides whether the program can credibly say G1 is done.

### 1.3 Scope-overclaim: `fockNullLift_equivariant` (BELL-005)

`BellQFT/FockCutoff.lean` states `fockNullLift_equivariant` as:

```
(hMarg : forall rho q, (sum over omega, L rho q omega) = sum over omega, rho q omega) :
  (sum over q, sum over omega, L rho q omega) = sum over q, sum over omega, rho q omega
```

That is total-mass conservation derived from a per-`q` marginal hypothesis. It is
a marginal identity, not equivariance of the direction marginal under a Born law.
The name asserts more than the statement proves. The roadmap's own W4/W11 rule
("every theorem must state whether it proves a marginal identity, a forward/master
equation, a finite-step kernel, or an actual trajectory measure") is violated by
the name. Action: rename to `fockNullLift_preservesTotalMass` (or strengthen to an
actual direction-marginal equivariance statement) and downgrade BELL-005's claimed
content in the manifest accordingly.

### 1.4 Duplicate / divergent definitions (single-source-of-truth breaks)

The manifest's own CI rule is "one declaration per conceptual claim". Three
violations exist in the live tree:

1. `FiniteNullResolution` is defined twice with incompatible signatures:
   - `NullFiber/Barycentric.lean`: `(Omega) [Fintype Omega] (U : Fin 4 -> Real)`
   - `NullLift/FiniteResidualCurrent.lean`: `(Z Omega) [Fintype Omega]`
   These are different structures sharing a name (DEF-004). Downstream code can
   silently bind the wrong one depending on `open`/import order.
2. `minkowskiInner` is defined twice with different domains:
   - `Conventions.lean`: on `Minkowski4`
   - `NullFiber/Barycentric.lean`: on `Fin 4 -> Real`
   This directly undercuts DEF-001 (one canonical convention package) and is a
   convention-drift hazard for every inner-product-bearing theorem.
3. `uniformComponent_bounds_meanNorm` (KIN-010) is proven twice, in
   `NullFiber/RegulatorMeanNorm.lean` and `NullFiber/RegulatorNoGo.lean`.

None of these are unsound, but each is exactly the kind of latent inconsistency
G0 is supposed to forbid. They should be resolved before any G2 work imports them.

### 1.5 Manifest / code drift (formal_state and declaration names)

The manifest is hand-maintained and has drifted from the code. Examples:

- States understated: `pureDirectionProjector` (ENT-001),
  `internalHolonomy_gaugeCovariant_path` (HOL-003), `FiniteNullResolution`
  (DEF-004) are marked `STATEMENT_DESIGNED` but are proven in the tree.
- Declaration-name drift (manifest name vs. live name):
  - ZZ-006 `coinBornTransport_isKernel` vs. `coinBornTransport_isStochastic`
  - ZZ-008 `actualShift_isNull` vs. `actualShift_speed_eq_c`
  - LA-003 `minimumEnergyFlow_unique` vs. `leastActionDrift_unique`
  - LIFT-001 `surplusDeficitCurrent_divergence_eq` vs. `residualCurrent_divergence_eq`
  - BELL-003 `minimalBellRates_masterEquation` vs. `minimalBellRate_masterEquation`
  - KIN-002 `octahedralRestDesign` vs. the `octaDirection*` design lemmas
- Capstone-name drift: MASTER-001/002 named declarations absent (section 1.2).

This confirms the roadmap's own W0 conclusion: the CSV must become generated
output from Lean annotations, not a prose artifact maintained by hand. Until then,
the manifest cannot be trusted as a status source, and any "x percent done"
statement derived from it is unreliable.

### 1.6 Import-firewall fragility (Draft dependency)

Trusted modules `Conventions.lean`, `FiniteCore.lean`, `ZigZag/ChiralCurrent.lean`,
and `ZigZag/QuantumWalk.lean` import from `PhysicsSM.Draft.*`. The four imported
cores are presently `s o r r y`-free, but the `Draft/` directory as a whole
contains many `s o r r y`-bearing files, and `AGENTS.md` explicitly permits
`s o r r y` under `Draft/`. There is currently no CI guard ensuring that the
transitive closure of a trusted capstone stays `s o r r y`/`a x i o m`-free. A
future edit to a depended-on Draft core would silently weaken trusted results.
The roadmap's import-firewall (section 5) names this risk but the tree does not
yet enforce it. This is in-scope for G0 (AUD-003).

### 1.7 Continuum claims are correctly quarantined

`ZigZag/QuantumWalk.lean` continuum limits (`quantumWalk_coherenceSq_continuum*`)
delegate to `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore`, and CONT-* nodes are
mostly `BLOCKED_ON_LIBRARY`/`BLOCKED_ON_MODEL`. This matches the publication-plan
house rule (lead with finite kernel-checked algebra; keep continuum conjectural)
and needs no change beyond the firewall hardening of 1.6.

---

## 2. Dependency-aware execution order (Task 2)

### 2.1 Prerequisite layer (must precede everything else)

- G0a build-green re-confirmation under the pinned toolchain.
- G0b `Audit/Inventory.lean`: import-only module that `#check`s every banked
  declaration by its real name (fixes 1.5).
- G0c `Audit/Axioms.lean`: `#print axioms` on each public capstone with an
  approved whitelist (`propext`, `Classical.choice`, `Quot.sound`); fail on
  anything else (fixes 1.6 enforcement).
- G0d de-duplication: single `FiniteNullResolution`, single `minkowskiInner`,
  single `uniformComponent_bounds_meanNorm` (fixes 1.4).

### 2.2 Clusters that can be resolved independently (parallelizable now)

- Cluster K (kinematics): KIN-007/008 variance and mass-ratio (standalone proofs
  exist; promote), DEF-005/MEA spike track.
- Cluster R (refresh/ergodic): REF-* are proven; ERG-002/003/004 (coarse velocity
  / clock long-run rate) build directly on `iidNullSteps_empiricalMean_tendsto`.
- Cluster E (entanglement): ENT-002/003/004 converse, on top of proven
  `productDirectionRepresentation_iff_separable`.
- Cluster B (finite Bell): BELL-001/002/003/004 proven; tighten BELL-005 naming.
- Cluster G (graph support): GRAPH-001/002 proven; GRAPH-003 concrete operator
  instance is the next real step.
- Cluster S (synchronization): SYNC-001/002 proven; SYNC-003 path-independence is
  the genuine holonomy target.

These do not block each other and are good parallel Aristotle follow-ups.

### 2.3 Critical path that gates publication readiness (G1)

```
G0 (build + inventory + assumption audit + de-dup)
  -> consolidate FiniteNullResolution / minkowskiInner conventions
  -> Master.FiniteIID:   build a concrete FiniteIIDNullStrandModel from
        actualShift nullity + iidNullSteps_empiricalMean_tendsto
     => prove finiteIIDNullStrand_master (the real statement, not the shell)
  -> Master.Checkerboard: assemble latticeBeable_{one,n}Step_equivariant
        + actualShift_speed_eq_c + a trajectory measure (Ionescu-Tulcea)
     => prove checkerboardBohmBell_master
```

Everything on this path is finite except the already-available strong law and the
Ionescu-Tulcea trajectory measure (both in Mathlib). This is the shortest route
to a defensible "G1 reached" statement.

### 2.4 Second critical path (G3 finite dynamics)

```
finite jump generator (have) -> residualCurrent_divergence_eq (have)
  -> currentPositivePart_rates_masterEquation (LIFT-002)
  -> minimumEnergyFlow_unique (LA-003) + induces_equivariantRates (LA-004)
  -> finiteEquivariantNullLift_master (MASTER-003), as an existence theorem
```

Parallel research tracks (not G1 blockers): intrinsic covariant sphere measure
(MEA/CONT), Bell-pair synchronization curvature (SYNC-004/005), graph super-Dirac
symbol (GRAPH-004/005/006), continuum process existence (CONT-005).

---

## 3. Top 10 highest-impact risks (Task 3)

For each: why risky / minimal scaffold / delegable follow-up.

1. G1 capstones are tautological shells (section 1.2).
   - Risk: the program can appear to have reached G1 while proving nothing
     physical; reviewers will reject this immediately.
   - Scaffold: define concrete model structures whose fields are the proven
     concrete lemmas, then state the masters with concrete hypotheses and the
     SLLN / equivariance conclusions.
   - Follow-up: two focused Aristotle jobs, one per master, after the model
     structures are stated. High priority.

2. No trajectory measure for the checkerboard (MASTER-002).
   - Risk: "Born-equivariant process with null steps" needs an actual measure on
     histories; without it the claim is one-step only.
   - Scaffold: wrap `MeasureTheory` Ionescu-Tulcea / `infinitePi` for the coin
     sequence; reuse `iidTrajMeasure_isProbability` pattern.
   - Follow-up: one Aristotle job on the trajectory-measure plumbing.

3. Manifest/code drift makes status untrustworthy (section 1.5).
   - Risk: planning and merge decisions made against stale names/states.
   - Scaffold: annotate each declaration with a stable node-id attribute or
     comment tag; a script regenerates CSV/JSON/DOT.
   - Follow-up: engineering task, not Aristotle.

4. Duplicate definitions of core objects (section 1.4).
   - Risk: silent convention drift; two `FiniteNullResolution`/`minkowskiInner`
     can diverge and break downstream rewrites.
   - Scaffold: pick the canonical definition, delete the other, add deprecation
     aliases, rebuild.
   - Follow-up: engineering + a small Aristotle re-prove if a signature changes.

5. Draft import firewall unenforced (section 1.6).
   - Risk: a `s o r r y` could leak into trusted capstones via a Draft core.
   - Scaffold: either promote the four depended-on cores into a trusted namespace
     or add a transitive `#print axioms` audit gating CI.
   - Follow-up: engineering.

6. `fockNullLift_equivariant` name overclaims (section 1.3).
   - Risk: a marginal identity is read as equivariance in the paper.
   - Scaffold: rename or strengthen; update BELL-005 claim kind.
   - Follow-up: small Aristotle job if strengthening to true equivariance.

7. MASTER-003 generic null-lift may be misread as uniqueness.
   - Risk: it is an existence/unravelling theorem; presenting it as the dynamics
     overclaims (roadmap section 8.3 warns this).
   - Scaffold: docstring must state non-uniqueness; LA-003/LA-004 supply the
     selected (minimum-energy) instance separately.
   - Follow-up: Aristotle on LA-003/LA-004 to give a concrete selector.

8. Synchronization curvature stated as rule-independent.
   - Risk: SYNC-006 is correctly `DO_NOT_STATE_AS_THEOREM`; pressure to state an
     unconditional entanglement-implies-curvature iff would produce a false or
     rule-dependent claim.
   - Scaffold: keep `HiddenTransportRule` explicit; target
     `flat_on_diamonds_implies_pathIndependent` (SYNC-003) as the honest theorem.
   - Follow-up: Aristotle on SYNC-003.

9. Graph super-Dirac symbol is the load-bearing open problem.
   - Risk: GRAPH-004/005/006 are `BLOCKED_ON_MODEL`; the support-transfer lemmas
     (GRAPH-001/002, proven) are easy and must not be advertised as the operator
     result.
   - Scaffold: exhibit one concrete operator `D` (GRAPH-003) and compute its
     square; do not state an abstract square identity as the physics.
   - Follow-up: a spike, then Aristotle on the concrete instance only.

10. Continuum mixing-gap and node behavior (CONT/O1-O2).
   - Risk: any global continuum spectral-gap or process-existence claim hides
     exclusion of nodes and the massless boundary.
   - Scaffold: keep `HasSpectralGap`/`HasL2Contraction` as explicit certificate
     structures; only stopped/local theorems near nodes.
   - Follow-up: long-horizon library work, kept off the G1-G3 path.

---

## 4. Staged plan: next 2-3 milestone cycles (Task 4)

### Milestone M1 -- "Honest G0 plus real G1" (highest priority)

Definition milestones:
- Canonical `FiniteNullResolution`, `minkowskiInner`, `MinkowskiConventions`
  (de-duplicated).
- `FiniteIIDNullStrandModel` and `CheckerboardModel` concrete structures whose
  fields are existing proven lemmas.

Checkpoint artifacts:
- `Audit/Build.lean`, `Audit/Inventory.lean`, `Audit/Axioms.lean` committed and
  green; generated manifest CSV/JSON/DOT.

Merge criteria:
- `lake build` green under pinned toolchain.
- Source scan: zero `s o r r y`/`a d m i t`/`a x i o m` in trusted tree
  (already true; now CI-enforced including transitive Draft closure).
- `finiteIIDNullStrand_master` and `checkerboardBohmBell_master` exist as real
  theorems with concrete hypotheses and pass the `#print axioms` whitelist.
- Manifest regenerated from code; zero name drift.

### Milestone M2 -- "Finite dynamics and finite nonlocality tests" (G2/G3 leaves)

Definition milestones:
- `WeightedFlowProblem` consolidated; `HiddenTransportRule` instance for the two
  Bell-pair pilots.

Checkpoint artifacts:
- Promote standalone KIN-007/008, ZZ-005, LA-002 into live modules.
- `finiteEquivariantNullLift_master` (MASTER-003) with explicit non-uniqueness
  docstring; LA-003/LA-004 selected instance.
- ERG-002/003/004 coarse-velocity and clock theorems on top of the SLLN.
- ENT converse (ENT-002/003/004), SYNC-003 path-independence.

Merge criteria:
- Each PR closes one dependency cluster, updates manifest + traceability +
  blueprint, and records a falsification/stop condition if the statement changed.

### Milestone M3 -- "Concrete graph operator spike and conditional G4"

Definition milestones:
- One concrete `D` (GRAPH-003) with computed square; `causalOperator_propertyMatrix`
  populated for at least two candidates.

Checkpoint artifacts:
- Spike report on whether a concrete super-Dirac symbol (GRAPH-004/005) exists or
  a precise obstruction is provable.
- G4 capstones kept explicitly conditional; no global continuum gap claimed.

Merge criteria:
- Either a concrete construction or a documented impossibility; no abstract square
  identity promoted as the operator result.

---

## 5. Revised roadmap deltas (Task 5)

Recommended edits to `NullStrand_Lean_Roadmap_Improved.md` (the math is sound; the
status and success criteria need tightening):

1. Section 8.1/8.2: stop describing the masters as if they were proven. Mark
   MASTER-001/002 as "ingredients proven; capstone is a tautological shell until a
   concrete model instance is constructed". Add the explicit success criterion:
   "the master theorem's hypotheses are concrete (named lemmas), not abstract
   `Prop` fields, and an instance is constructed".
2. Section 16 (implementation progress): correct two factual drifts -- (a)
   MASTER-001/002 named declarations do not exist; (b) the shell
   `finiteNullStrand_master` and the conditional `foliatedManyParticleNullStrand_master`
   are present but content-free. State G1 as "ingredients complete, assembly
   pending", not as reached.
3. Add a G0 sub-item: de-duplicate `FiniteNullResolution`, `minkowskiInner`,
   `uniformComponent_bounds_meanNorm`. This is a hard gate; G2 must not import the
   duplicated symbols.
4. Section 5 import firewall: add the enforcement mechanism (transitive
   `#print axioms` audit or promotion of the four Draft cores) as a checkpoint
   artifact, not just a principle.
5. W11/BELL-005: rename `fockNullLift_equivariant` and restate its claim kind as
   "total-mass identity", not "equivariance".
6. Add per-stage verification tasks (section 6 below) to every gate.

Success criteria, sharpened, per stage:
- G0: build green + inventory `#check` all + capstone assumption whitelist + no
  duplicate core defs + manifest regenerated from code.
- G1: both masters are concrete-hypothesis theorems with constructed instances and
  whitelisted assumptions.
- G2/G3: each promoted node has a single canonical declaration, a claim-kind tag
  (marginal identity / forward equation / kernel / trajectory measure), and a
  stop condition.

---

## 6. Pre-batch setup checklist (Task 6)

Before each batch of proofs:

- [ ] `lake build` green under `leanprover/lean4:v4.28.0` from a clean checkout.
- [ ] Source scan: zero `s o r r y`/`a d m i t`/`a x i o m` in the trusted tree
      AND in the transitive import closure of every targeted capstone.
- [ ] `#check` every declaration the batch depends on by its real name (no
      reliance on the hand-maintained manifest name).
- [ ] Convention audit: confirm exactly one definition of each core object the
      batch touches (`FiniteNullResolution`, `minkowskiInner`,
      `MinkowskiConventions`).
- [ ] Claim-kind check: each new theorem's name matches what it proves (marginal
      identity vs. equivariance vs. trajectory measure).
- [ ] Manifest regenerated from code; diff reviewed for name/state drift.
- [ ] For any statement change, record the new falsification/stop condition.
- [ ] Aristotle handoffs are standalone where possible (Mathlib + a few copied
      definitions) to avoid spending budget on full-repo builds.

---

## 7. Exact files / regions to target next

In priority order:

1. `PhysicsSM/NullStrand/Master/FiniteModel.lean` -- replace the abstract shell
   with `finiteIIDNullStrand_master` whose hypotheses are concrete (null
   increments + i.i.d. integrability) and whose conclusion is the a.s. coarse
   limit; build the instance from `Ergodic/IIDStrongLaw.lean` and
   `ZigZag/LatticeBeable.lean` (`actualShift_speed_eq_c`).
2. New `PhysicsSM/NullStrand/Master/Checkerboard.lean` -- state and prove
   `checkerboardBohmBell_master` from `latticeBeable_{one,n}Step_equivariant`,
   `actualShift_speed_eq_c`, and a trajectory measure
   (pattern: `Probability/Trajectory.lean`).
3. `PhysicsSM/NullStrand/NullFiber/Barycentric.lean` and
   `PhysicsSM/NullStrand/NullLift/FiniteResidualCurrent.lean` -- unify
   `FiniteNullResolution`; `PhysicsSM/NullStrand/Conventions.lean` vs.
   `Barycentric.lean` -- unify `minkowskiInner`.
4. `PhysicsSM/NullStrand/NullFiber/RegulatorMeanNorm.lean` vs.
   `RegulatorNoGo.lean` -- remove the duplicate `uniformComponent_bounds_meanNorm`.
5. New `PhysicsSM/NullStrand/Audit/{Build,Inventory,Axioms}.lean` -- G0 artifacts.
6. `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean` -- rename
   `fockNullLift_equivariant` and correct its claim kind.
7. `PhysicsSM/NullStrand/{Conventions,FiniteCore,ZigZag/ChiralCurrent,ZigZag/QuantumWalk}.lean`
   -- decide promotion vs. transitive-audit for the `PhysicsSM.Draft.*` imports.

---

## 8. Prioritized backlog (summary table)

| Rank | Item | Gate | Type | Delegable to Aristotle |
|---|---|---|---|---|
| 1 | Real `finiteIIDNullStrand_master` + instance | G1 | proof+model | yes (after structure stated) |
| 2 | Real `checkerboardBohmBell_master` + trajectory measure | G1 | proof+model | yes |
| 3 | De-duplicate `FiniteNullResolution`/`minkowskiInner` | G0 | engineering | partial |
| 4 | G0 audit modules (build/inventory/assumptions) | G0 | engineering | no |
| 5 | Regenerate manifest from code; fix name drift | G0 | engineering | no |
| 6 | Transitive Draft proof-hole/assumption firewall | G0 | engineering | no |
| 7 | Rename/strengthen `fockNullLift_equivariant` | G2 | proof | yes |
| 8 | LA-003/LA-004 selected least-action lift | G3 | proof | yes |
| 9 | ERG-002/003/004 coarse velocity + clock | G2 | proof | yes |
| 10 | SYNC-003 path-independence holonomy | G3 | proof | yes |
| 11 | GRAPH-003 concrete operator spike | G3/G5 | spike | partial |

---

## 9. Bottom line

The finite kinematic and probabilistic foundation is genuinely proven and matches
the roadmap's conventions. The program is closer to a defensible G1 than the
manifest's status fields suggest. But the two named G1 capstones do not exist as
real theorems -- only a tautological shell does -- and the metadata has drifted
from the code. The single highest-value next action is to convert the proven
ingredients (`iidNullSteps_empiricalMean_tendsto`, the `LatticeBeable`
equivariance lemmas, `actualShift_speed_eq_c`) into concrete-hypothesis master
theorems with constructed instances, on top of a real G0 (build + inventory +
assumption whitelist + de-duplication). Do that, and G1 becomes a credible,
kernel-checked, publication-grade endpoint rather than a named placeholder.
