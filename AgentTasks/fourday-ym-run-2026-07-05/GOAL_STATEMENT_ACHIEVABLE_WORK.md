# Goal statement: achievable work from the current YM/dynamics state

Status date: 2026-07-05

Audience: Codex, Claude, Aristotle packet authors, and human collaborators who
want a clear target list for the next autonomous cycles.

## North-star goal

Turn the current finite Yang-Mills scaffold into an honest, reproducible
finite-volume dynamics layer while continuing to close the proof bottlenecks
that make a mass-gap-style statement non-vacuous.

The immediate target is not a continuum theorem, not a Hamiltonian simulator,
and not a Monte Carlo package. The target is a verified finite Euclidean
transfer model with exact enumeration as its oracle, sector-resolved spectral
data, and Lean theorem surfaces that say exactly what has been checked.

## What is already available

The repo now has enough verified infrastructure to make the next work concrete:

- finite link-field, plaquette, Wilson-weight, and expectation scaffolding;
- finite reflection-positivity kernel algebra and several concrete RP tiers;
- finite OS/GNS range and Z2 electric-sector bookkeeping;
- finite spectral-ratio/gap prerequisite packages, including
  `FiniteGapSpectralWitness`;
- executable Z2 1+1D transfer oracle infrastructure with exact enumeration,
  descriptor-requested two-time correlation profiles, sector blocks,
  full/sector first-gap records, descriptor-file input, optional
  reproducibility matrix emission, and JSON summary output plus
  descriptor-schema emission and saved-record replay verification;
- `TwoStateTransferSpectrum.lean`, a tiny Lean-facing transfer-spectrum
  payload with vacuum/local eigenvector equations and D12 gap identities;
- `TwoStateTransferWitness.lean`, a tiny whole-sector witness adapter that
  wraps the two-state matrix as a `Module.End` and instantiates
  `FiniteGapSpectralWitness`;
- `TwoStateTransferZ2L1.lean`, a one-link Z2 slab bridge proving the oracle's
  smallest gauge-summed transfer kernel has the two-state matrix shape and
  concrete symmetry/Hermitian identities and supplies a positive
  descriptor/witness for `beta > 0`, with contraction factor `tanh beta`,
  explicit slab eigenvector equations, one-step partition and flux-insertion
  trace identities, one-step plus/minus center-projected trace identities, a
  normalized `T = 1` flux-expectation theorem, `T = 2` partition and raw
  two-time flux-correlation numerator identities, a
  normalized `T = 2`, `tau = 1` autocorrelation ratio theorem, and a one-link
  spatial-flux insertion that is Hermitian, involutive, and swaps the
  vacuum/local eigenvectors; it also formalizes the L=1 global-center flip and
  plus/minus projectors, including center-flip involution, projector
  idempotence, left/right center-flip eigenprojector laws, flux/center
  anticommutation and center-sector toggle laws, their vacuum/local action, and
  commutation with the one-link transfer;
- strong-coupling/KP statement infrastructure, now narrowed to the
  `pairSum_le_expBound` combinatorial crux;
- RP-F finite spin/projector/reflection-unitary/lattice-index PSD foundations.

## Highest-value lanes

### Lane 1: descriptor-driven finite transfer oracle

Goal: evolve `Scripts/oracle/z2_transfer_oracle.py` from a narrow prototype
into a small descriptor-driven exact finite dynamics engine.

Achievable deliverables:

- define a stable JSON descriptor schema for finite Z2 transfer models;
- support `L`, `T`, boundary convention, coupling, observables, and sector
  labels from the descriptor;
- emit a complete reproducibility record: conventions, matrices, spectra,
  trace identities, correlation checks, and tolerances;
- add regression rows to `validate_lgt_core.py`;
- keep tiny exact enumeration as the reference check for every transfer trace.
- Current status: the descriptor can request spatial-flux autocorrelation tau
  values, and the JSON record emits transfer-trace, full-spacetime, and
  spectral evaluations for each requested tau. The regression harness checks
  the requested profile and rejects unsupported correlation labels. Optional
  matrix output now includes spatial-state labels, the spatial-flux insertion,
  the global-center flip, and center projectors in the full state basis. The
  oracle also has a `--verify-record` path that validates saved JSON summaries
  and replays matrix-backed partition, flux, correlation, transfer-kernel
  symmetry/center-commutation, spatial-flux insertion algebra,
  center-projector algebra, flux/center sector-toggle checks, and
  full/center-sector positive-eigenvalue lists, plus emitted center-sector
  block matrices. It now also emits the explicit JSON-schema-style descriptor
  contract through `--write-schema`, and records full/center-sector first-gap
  fields derived from the positive eigenvalue lists.

Done when:

- `python Scripts\oracle\validate_lgt_core.py` passes with the new descriptor
  checks;
- at least one checked descriptor reproduces `Tr(K^T)`, inserted observables,
  two-time correlations, and sector-block spectra.

### Lane 2: Lean/oracle bridge for the first transfer payload

Goal: connect the executable transfer evidence to small Lean theorem surfaces
without pretending the full Wilson slab has been formalized.

Achievable deliverables:

- add a Lean descriptor/witness adapter around `TwoStateTransferSpectrum`;
- for the smallest Z2 two-state model, package the transfer matrix, vacuum
  vector, local/flux vector, ordered eigenvalues, and contraction factor;
- expose the corresponding one-link flux insertion as an observable matrix,
  including Hermitian/involutive laws and its action on the vacuum/local
  eigenvectors;
- expose the corresponding one-link center-sector algebra, including the center
  flip involution, plus/minus projector idempotence, and center-flip
  eigenprojector laws;
- expose the one-link spatial-flux insertion as a center-sector toggling
  operator;
- if feasible, expose a `Module.End` wrapper so the payload can feed the shape
  of `FiniteGapSpectralWitness`;
- document exactly which hypotheses are still external: cyclicity, sector
  identification, and Wilson-slab identification.

Done when:

- the new Lean file checks directly and via the GateYM aggregator;
- no theorem claims a physical transfer matrix, Hamiltonian, infinite-volume
  state, or physical mass gap.

### Lane 3: Q6 strong-coupling combinatorial closure

Goal: close or further narrow the `pairSum_le_expBound` bottleneck.

Achievable deliverables:

- harvest Aristotle projects `7c0ed511` and `31facfbb` as soon as they finish;
- if a proof returns, integrate only after semantic review and targeted build;
- if both stall, isolate the next smallest sublemma around the canonical-root
  deletion / multinomial multiplicity estimate;
- write the sublemma as a focused standalone Aristotle package rather than
  churning locally.
- Current status: Aristotle project `7c0ed511` completed as a partial
  narrowing, not a closure. Three locally verified helper lemmas are
  integrated: `exists_canonical_root`, `rhs_forest_expand`, and
  `factorial_mul_prod_factorial_le`. The remaining named blocker is still the
  geometric root-deletion/block-reindex/fiber-count part of
  `pairSum_le_expBound`. Project `31facfbb` continuation task `6fc4005c`
  returned no new target-file progress.

Done when:

- either `pairSum_le_expBound` is kernel-checked, or the remaining blocker is
  a smaller named theorem with a clear proof plan and no claim promotion.

### Lane 4: conservative Q7/Q8 observable bridge

Goal: prepare the observable-to-clustering interface without depending on an
unproved Q6 metric-tail theorem.

Achievable deliverables:

- keep any new Q8 bridge conditional: decay remains a hypothesis;
- if implemented, add a thin `ObservableSupportBridge.lean` interface only for
  support bookkeeping, following the Q8 audit verdict;
- add finite-support lemmas only when they remove real friction for a later
  concrete observable expansion.
- Current status: `ObservableSupportBridge.lean` now provides the thin
  `LocalPlaquetteObservable` / `ObservableSupportBridge` identity layer, plus
  an optional anchored-observable carrier with anchor-membership and
  anchor-tail-to-support-tail wrappers. It also provides pass-through
  support-tail cardinality, empty-support and zero-tail zero-correlator
  wrappers, and uniform anchored-tail/uniform-energy conditional clustering
  wrappers. The bridge remains bookkeeping only.

Done when:

- support bookkeeping is easier to use, but no file claims concrete clustering,
  volume-uniform KP, or observable expansion closure.

### Lane 5: RP-F reflected-block assembly

Goal: move from lattice-index projector PSD to the concrete reflected Wilson
boundary block, but only after the interface is pinned.

Achievable deliverables:

- define the boundary-coupling matrix `A` for the reflected Wilson block;
- state the exact link-field reflection-symmetry hypothesis needed for
  `Theta D Theta = D^dagger`;
- prove PSD for the concrete block by routing through the existing lifted
  projector lemmas;
- if the Berezin/measure interface is clear, formulate the next wrapper toward
  reflection-form nonnegativity.
- Current status: `FermionicReflection.ReflectedBoundaryCoupling` now names
  the boundary-coupling `A` slot, defines plus/minus reflected projector
  blocks, specializes them to the temporal direction, and proves the
  plus/minus blocks and their temporal sum PSD and Hermitian for any
  instantiated coupling. The concrete Wilson boundary-coupling formula and
  reflection-hermiticity hypothesis remain explicitly open.

Done when:

- the actual `A` slot is instantiated for a concrete reflected Wilson boundary
  coupling, or the remaining hypothesis is explicitly parked as a named design
  blocker.

### Lane 6: finite gap witness instantiation

Goal: make `FiniteGapSpectralWitness` non-vacuous on a tiny model before aiming
at the full Wilson slab.

Achievable deliverables:

- use the two-state transfer payload as a testbed for the witness shape
  (the current toy whole-sector adapter does this; the remaining work is a
  physical-sector Wilson-slab consumer);
- identify the smallest sector/local-algebra package that can be supplied
  honestly;
- if full cyclicity is too heavy, add a partial witness structure or note that
  cyclicity is the blocker, not the spectral data.

Done when:

- the gap witness API has one tiny concrete consumer, or a precise handoff note
  explains which field blocks instantiation.

### Lane 7: paper-unit and collaborator-facing synthesis

Goal: keep the scientific story legible while the proof/software layers move.

Achievable deliverables:

- keep `dynamical-simulation-layer-brief.md` synced with actual code state;
- add a theorem/file table for the finite dynamics lane;
- write a short "what is proved / what is oracle evidence / what is open"
  section suitable for collaborators;
- avoid novelty or physical-continuum language unless separately source
  verified.
- Current status: the brief now includes a current artifact map and a
  claim-type table separating kernel-checked finite algebra, executable oracle
  evidence, the finite dynamics prototype, strong-coupling blockers, and the
  still-open physical mass-gap claims. The Z2 transfer oracle JSON also now
  includes a `lean_surfaces` provenance section naming the Lean modules and
  theorem surfaces its finite evidence is meant to inform, including the
  one-link `TwoStateTransferZ2L1` bridge and its flux-insertion observable
  surface, including concrete transfer symmetry/Hermiticity, the one-step and
  two-step partition/flux trace identities, the normalized one-link `T = 1`
  flux expectation, and the normalized one-link `T = 2` autocorrelation
  ratio, plus L=1 center flip/projector theorem surfaces. It also records
  descriptor-requested spatial-flux autocorrelation profiles and
  full/center-sector first-gap fields as finite oracle evidence.

Done when:

- a collaborator can see the next implementation target and the claim boundary
  in under five minutes.

## Suggested execution order

1. Poll and harvest Q6 Aristotle jobs before submitting new Q6 work.
2. If Q6 is still running, work Lane 1 or Lane 2 because both are independent
   and directly advance the dynamics goal.
3. Touch RP-F only after the concrete boundary-coupling interface is clear.
4. Keep Q8 conditional unless Q6/Q7 supply the missing metric-tail and
   observable-expansion hypotheses.
5. End each cycle by updating the ledger and syncing the collaborator brief if
   the public state changed.

## Verification gates

For Lean work:

- direct `lake env lean <file>`;
- targeted `lake build PhysicsSM.Draft.NullEdge.GateYM.<Module>`;
- aggregator `lake env lean PhysicsSM\Draft\NullEdge\GateYM.lean`;
- aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM`;
- escape-hatch scan on touched Lean files;
- dependency audit for new public theorems.

For oracle work:

- run the specific oracle command;
- run `python Scripts\oracle\validate_lgt_core.py`;
- run `python -m py_compile` on touched scripts;
- record descriptor, command, tolerance, and expected identity.

For docs-only work:

- `git diff --check`;
- diff-added raw-token scan;
- scoped `pre-commit run --files <paths>`.

## Hard claim boundaries

Do not claim:

- a physical Yang-Mills mass gap;
- an infinite-volume or continuum theorem;
- a Hamiltonian or real-time dynamics layer;
- a production Monte Carlo simulator;
- a full Wilson slab transfer construction until the Lean object exists;
- Q6/KP convergence, Q8 clustering, or RP-F measure positivity before the
  named blockers are closed.

Safe claim:

```text
We have a kernel-checked finite lattice-gauge scaffold, a growing exact
finite-transfer oracle, and the first small Lean spectral bridge needed to
turn finite transfer experiments into theorem-shaped evidence.
```

## Stop conditions

Stop and report rather than forcing progress if:

- a theorem needs a new assumption that is really a hidden physical premise;
- the transfer sector label is not preserved by the candidate kernel;
- a proposed Q8 bridge smuggles decay in as a conclusion rather than a
  hypothesis;
- RP-F requires an unpinned reflection convention for the link field;
- oracle evidence contradicts a Lean statement shape.

Failures of this kind are useful results and should be recorded in the ledger.
