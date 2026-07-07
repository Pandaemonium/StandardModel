# Standing goal - Codex solo carrier/null-edge work

You are the solo active executor for today's carrier/null-edge run unless the
current git state or ledger shows fresh peer activity.  The original master plan
is still `RUN_PLAN.md`, but this prompt supersedes the old two-executor
coordination rules for Codex: do not wait for Claude review before making
progress.  Treat the latest Claude commits, Fable answers, Aristotle outputs,
`THREAD_BOARD.md`, `LEDGER.md`, and the manuscript/status updates as live
steering context.

Mission: develop the new Claude/Fable ideas already present in the repository to
their highest practical potential, while preserving the run's core discipline:
kernel-checked Lean where possible, honest claim grading, axiom guards for
flagships, provenance, frequent Aristotle proof/strategy/audit jobs, and small
verified commits.

## First principles

- **Current state is authoritative.** Before relying on old chat context, inspect
  `git status`, recent commits, `LEDGER.md`, `THREAD_BOARD.md`,
  `AgentTasks/fable_parallel/*.md`, and any relevant task notes.
- **Kernel = truth.** A theorem is trusted only when the intended statement is
  represented correctly in Lean, accepted by the kernel, verified under the
  pinned toolchain, and guarded when it is a flagship.
- **No narrower substitute goals.** Make real progress toward the program, not
  merely the easiest passing subset.  If a statement is false or mis-scoped,
  record the honest correction and move to the next useful target.
- **Work with dirty state.** Do not revert user or peer changes.  If uncommitted
  files are unrelated, leave them alone.  If they affect the task, inspect and
  work around them carefully.
- **Solo does not mean unreviewed.** Replace the old Claude cross-review gate
  with explicit self-review, Aristotle audit jobs after risky integrations, and
  ledger notes that name claim boundaries and over-claim risks.
- **Skip new Fable/model calls.** Do not initiate Fable calls or external
  model-review calls as part of this solo prompt unless the user explicitly asks.
  Harvest and act on the Fable/Claude material already written into the repo.

## Working surface

You may work across the former Codex and Claude lanes when doing solo work:

- Carrier / Weitzenbock / Q_A / Q_T / index / Gupta-Bleuler lanes.
- Closure / Q_C / GateYM / Osterwalder-Seiler / KP / product-Haar lanes.
- New Fable-driven threads: horizon area/entropy, signature/dimension
  selection, real-structure/KO/unimodularity seam, chirality-solder audit,
  equivariant McKean-Singer, RG-Schur, and anomaly gates.

Preserve file-local conventions and ownership history.  If fresh peer activity
appears in `PhysicsSM/Draft/NullEdge/Carrier/**`,
`CarrierAxiomGuard.lean`, `PhysicsSM/Draft/NullEdge/GateYM/**`, or
`SlabAxiomGuard.lean`, coordinate via `LEDGER.md` and git rather than
overwriting it.

## Lane catalog

Keep all of these lanes alive, with priority set by current blockers,
Aristotle returns, and kernel-ready finite targets.  A lane may produce Lean,
an Aristotle proof/audit/strategy job, a no-go certificate, or a parked MEMO
with explicit kill conditions.

1. **Carrier / Weitzenbock square.** Maintain the carrier square stack:
   null-Clifford nilpotency, soldered square = `Q_A`, Weitzenbock master,
   `Q_T` turn/potential slot, `Q_C` closure slot, E-slot/torsion remainder,
   Krein square, concrete torus witnesses, and `CarrierAxiomGuard`.
2. **Gupta-Bleuler / Krein positivity.** Build on the finite GB and
   Kugo-Ojima results: `V'/N`, radical = charge image, nondegenerate quotient,
   descent under unitary/constraint-preserving maps, and the open positivity
   gate.  Do not claim a positive Hilbert quotient without the missing finite
   positivity hypothesis.
3. **GateYM / Q_C / OS1 / KP / RP.** Continue the closure/Q_C normalization,
   scalar and operator Gram checks, strong-coupling OS1 scaffold,
   reflection-positivity/product-Haar infrastructure, and Penrose/KP
   fixed-forest injection route.
4. **Checkerboard-GW / retarded transfer.** Use the exact GW relation,
   edge-reversal grading, palindromic transfer convention, hidden Wilson-term
   dispersion identity, and carrier-level GW generalization/counterexample
   search as one coherent Q06 rail.
5. **Equipartition / Koide / T-solder.** Continue the equipartition sum rule,
   Brannen/phase form, T-solder degree/kappa analysis, tetrahedral corner
   probe P1, and GATE M-KOIDE pre-registered kills.
6. **Fock / second quantization.** Develop the Q08 exterior algebra route:
   `dGamma` square identity, exterior quotient `Fock(V')/rad = Fock(V'/N)`,
   two-particle checkerboard determinant, and finite Pauli-vs-Sym positivity
   selection conjecture.
7. **Horizon / screen area.** Extend only from the proved finite screen-area
   polarization and null-screen wedge positivity.  Audit entropy, BW-cut,
   Jacobson, ANEC, and continuum horizon claims before promoting anything.
8. **Signature / dimension selection.** Kernelize the Q10 ladder:
   definite-no-null, split `Z^(2,2)` frustration, Lorentzian transitivity,
   null-orthogonality rigidity, split tachyonic mass witness, and
   same-chirality scalar-amplitude census.  Boundary: signature from stable
   order; dimension from chirality plus scalar-amplitude reconstruction.
9. **Real-structure / KO / unimodularity seam.** Pursue the Q11 rail:
   top-form-duality `J_R` on `Lambda(C^5)`, sign tables, internal positive
   form, KO placement, RC0/unimodularity equivalence, B-L counterexample,
   C3 Majorana identity, order-condition relocation, and the chirality-solder
   flag.  Do not say unimodularity follows from Krein closure.
10. **Chirality-solder / G2 parity / anomaly gates.** Pursue the Q12 audit:
   G2-parity mechanism, `tau Gamma' = Gamma'`, equivariant McKean-Singer by
   charge sector, PSA anomaly gates, C8 seam/J_R compatibility, and
   convention/lift checks before any safety claim.
11. **Strand-fock / Standard Model selection.** Keep the Q04/Q05 rails active:
    supertrace identity, pentad fiber, turn census, hypercharge/Z_6 rigidity,
    triality-as-monodromy, no-four orbit lemma, Distler-Garibaldi translation,
    and the octonion/Fock convention bridge.
12. **RG-Schur / coarse-graining.** Develop Schur-complement determinant
    identities, RG stability of Krein-self-adjoint Gamma-odd structure,
    instability of per-edge null nilpotency under blocking, and uniform
    majorant gate UM.
13. **Cross-lane real-structure plumbing.** Treat `J_R`, edge-reversal
    conjugation, base/fiber real structures, and `#` compatibility as plumbing
    that connects Q03, Q04 C8, Q06 edge reversal, Q11, and Q12.  Every use
    must say whether it is linear, antilinear, bilinear, or sesquilinear.
14. **Manuscript / scorecard / provenance.** Keep P1 v3, the honest scorecard,
    thread board, ledger, lit log, and claim grades aligned with what is
    actually kernel-checked or explicitly MEMO/OPEN.

## Research goals aligned to the new repo material

1. **Q09 horizon/screen area.** Turn the area-as-relational-aperture memo into
   finite algebra: screen polarization of the `2 x 2` determinant, null-screen
   wedge-count formulas, positivity, and honest boundaries.  Park entropy,
   Jacobson, BW-cut, and ANEC claims as MEMO/strategy until their finite
   hypotheses are stated and checked.
2. **Q10 signature/dimension selection.** Treat signature as the order-side
   theorem rail and dimension as a reconstruction rail.  Kernelize the finite
   ladder first: definite-no-null, the `Z^(2,2)` frustrated-triple obstruction,
   Lorentzian positive-pairing transitivity, null-orthogonality rigidity,
   split-signature tachyonic witnesses, and the same-chirality scalar-amplitude
   census.  Never claim "3+1 from consistency alone"; use the Q10 boundary:
   signature is a theorem about stable order, dimension is conditional on the
   named chirality and scalar-amplitude axioms.
3. **Q11 real-structure / KO / unimodularity seam.** Develop the explicit
   `J_R` construction on `Lambda(C^5)`, the sign tables, positive internal
   form, KO placement, RC0/unimodularity equivalence, B-L counterexample,
   C3 Majorana identity, and order-condition relocation.  Treat the
   "Krein closure gives unimodularity" slogan as corrected/false.
4. **Q12 chirality-solder audit.** Develop the G2-parity thread, the new
   constraint-equivariance hypothesis `tau Gamma' = Gamma'`, the
   charge-resolved equivariant McKean-Singer prerequisite, and the PSA anomaly
   gates.  Treat "factor separation" as superseded by the stronger G2-parity
   mechanism; do not claim safety without the bridge/convention check.
5. **Q06-Q08 synthesis.** Use the new exact-GW/edge-reversal, equipartition
   Koide, Fock-Gupta-Bleuler, and RG-Schur material as active research rails.
   Convert near-free finite identities into Lean, and keep speculative physics
   claims explicitly MEMO or OPEN.
6. **QC-GRAM and Q_C.** Continue the closure/Q_C line: distinguish raw linear
   closure defects from Gram/Laplacian normalization, pursue concrete Carrier
   factorization only with the correct normalization, and keep beyond-leading
   positivity claims open unless proved.
7. **OS1/KP/RP infrastructure.** Continue the Osterwalder-Seiler,
   product-Haar/RP, character/polymer, and Penrose/KP routes when they are the
   highest-EV finite targets.  Prefer exact support lemmas and honest no-go
   statements over broad gap claims.
8. **Manuscript/status alignment.** Keep the P1 v3 manuscript, thread board,
   scorecard, and ledger aligned with what is actually kernel-checked.  New
   MEMO-grade material should improve the roadmap without being promoted to
   PROVED.

## Immediate solo workflow

1. **Harvest fresh in-repo context.** Read and act on new files such as
   `AgentTasks/fable_parallel/Q09_answer.md`,
   `AgentTasks/fable_parallel/Q10_answer.md`,
   `AgentTasks/fable_parallel/Q11_answer.md`,
   `AgentTasks/fable_parallel/Q12_answer.md`, the round-2 packet intro, recent
   `LEDGER.md` entries, and
   `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md`.
2. **Land kernel-ready finite algebra first.** Prefer small exact statements:
   screen-area/aperture polarization (Q09 L1), finite no-go trace arguments,
   G2 parity checks, equivariant index bookkeeping, quotient descent lemmas,
   QC-GRAM/Q_C normalization, and RG-Schur determinant identities.
3. **Use Aristotle early.** For nontrivial proofs, unclear decompositions,
   statement audits, or strategy choices, prepare focused Aristotle jobs.  Use
   both proof jobs and strategy jobs.  Do not churn on hard Lean when a clean
   Aristotle packet can be made.
4. **Keep Q_C / OS1 / KP alive.** The former Codex lane remains important:
   QC-GRAM and concrete Q_C factorization, Osterwalder-Seiler strong-coupling
   scaffold, product-Haar/RP infrastructure, and the Penrose/KP crux.
5. **Promote or park new ideas honestly.** Each Fable proposal should become
   one of: a kernel theorem, an Aristotle task, a documented handoff, a
   ledger/thread-board update, or a rejected/parked claim with a reason.

## Solo cadence

- Every work cycle: inspect state -> choose highest-EV target -> prove or
  document -> verify -> commit -> ledger heartbeat.
- Literature rounds remain valuable, especially before paper-dependent claims.
  Use the Neo4j/vector scripts or MCP tooling as described in
  `Scripts/MCP_SERVERS.md` and log meaningful deltas in `LIT_LOG.md`.
- Run `aristotle list`/`aristotle tasks` regularly enough to harvest completed
  jobs, but do not busy-wait.  Cancel or park stale jobs by the 2-hour rule.
- Keep Aristotle near saturation when there are enough independent lanes.  Aim
  for roughly twelve active StandardModel-relevant jobs during autonomous
  periods, mixing proof, strategy, and adversarial-audit jobs.
- Every Aristotle submission must have a unique descriptive project directory
  and job name, such as `ne-q10-l3-lorentzian-transitivity-20260707`, not a
  generic pack name.  Record project IDs and deliverables in
  `ARISTOTLE_LANE_DOCKET_2026-07-07.md` or its successor.
- For proof-only jobs, prefer focused Mathlib Lake packages.  Lightweight
  context packs are fine for strategy/audit jobs; if a proof job stalls on
  environment setup, cancel or park it and resubmit as a focused package.
- After every 2-4 meaningful integrations, submit or record an adversarial audit
  pass.  Use Aristotle audit jobs when the integration is mathematically risky.
- If new Fable/Claude text appears in the repo, harvest it promptly: summarize
  decisions in `LEDGER.md`, update `THREAD_BOARD.md` when it changes priorities,
  and create exact Lean/Aristotle targets where possible.  Do not initiate a new
  Fable call yourself.

## Claim discipline

- Use explicit grades: PROVED, MODELED, OPEN, MEMO, strategy, handoff, or
  counterexample/no-go.
- Watch the four over-claim modes on every landing: vacuity, hollow telescoping,
  docstring outruns kernel, and false shape.
- Do not weaken theorem statements silently.  If the intended theorem is too
  hard, leave a precise draft/handoff marker or send it to Aristotle.
- Do not import physical meaning from prose into Lean claims.  Say exactly what
  the kernel proves and what remains interpretation or future work.

## Verification

For each Lean increment:

```text
lake env lean PhysicsSM/Path/To/File.lean
lake build PhysicsSM.Path.To.Module
```

For guarded flagships, also check the relevant guard file:

```text
lake env lean PhysicsSM/Draft/NullEdge/Carrier/CarrierAxiomGuard.lean
lake env lean PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean
```

Run `pre-commit run --all-files` before commits.  Do not claim `lake build`
passed unless it was actually run.  For broad or trusted claims, run the
broader build required by `docs/BUILD.md`.

## Commit and log discipline

- Use small commits with prefix `twoday-carrier-202607:`.
- Stage specific files only.  Never `git add -A` blindly.
- Each meaningful commit should have a ledger heartbeat or task note describing:
  what changed, claim grade, verification commands, provenance, and remaining
  issues.
- Leave unrelated untracked context packs, model notes, or peer artifacts alone
  unless they are explicitly part of the harvest being committed.

## Today's north star

The best solo work today turns the newest synthesis into durable artifacts:
kernel-checked finite theorems, guarded statements, exact no-go results,
Aristotle-ready proof packets, and clear claim boundaries.  Be ambitious, but
make the ambition legible to the Lean kernel and to future reviewers.
