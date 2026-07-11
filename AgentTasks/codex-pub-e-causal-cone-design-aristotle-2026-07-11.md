# Aristotle design job: exact causal cone for local Pluecker pair-kick layers

Name this project `codex-pub-e-causal-cone-design-20260711`.

Read the supplied finite CAR, second-quantization, quartic-transfer, pair-kick,
and no-one-body modules. Design the smallest exact spatial embedding that turns
the displayed Pluecker pair kick into a genuinely local many-fermion update and
supports a finite Heisenberg causal-cone theorem.

Current exact result: on four abstract modes, the pair kick is unitary, fixes
all one-particle states, is not any determinant-minor exterior lift, and its
Hermitian quartic generator is not any number-preserving one-body CAR generator.
No spatial support, local layer, commutator cone, exponential flow, scattering,
or continuum theorem exists.

Requirements:

1. Specify a finite chain mode type, region/support predicate, local pair gate,
   brickwork layer, observable algebra, and Heisenberg evolution with conventions
   compatible with the supplied CAR signs.
2. State the exact one-step support theorem and its `t`-step cone corollary.
3. Include a nontrivial cone-saturating witness and an exactly commuting
   outside-cone control; reuse the nonzero disjoint-pair phase amplitude.
4. State whether fermionic parity strings require graded commutators or an even
   observable restriction; do not hide this issue.
5. Produce a focused Lean theorem ladder or, if the proposed exact cone is
   false, the smallest counterexample and corrected hypothesis.

Do not use “local,” “Lieb--Robinson,” “scattering,” or “measurable” as a result
unless the corresponding support/commutator theorem is explicitly present.

```yaml
aristotle:
  project_id: 0388c69e-854c-46d1-824b-dd3eed71184c
  target_file: review/design
  expected_module: review/design
  submission_project: AgentTasks/aristotle-submit/codex-pub-e-causal-cone-design-20260711-project
  output_dir: AgentTasks/aristotle-output/0388c69e-854c-46d1-824b-dd3eed71184c
  status: declared-set-module-integrated-geometric-successor-running
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## 2026-07-11 04:02 PDT in-progress semantic audit

Downloaded the in-progress snapshot. It already contains a proof-complete
`PlueckerCausalCone.lean`; running the snapshot file against the live project
with `lake env lean` passed in 113.4 seconds, with linter warnings only and no
placeholder/escape-hatch scan hits. The exact CAR-word commutation,
disjoint-block gate commutation, involutivity, and nonzero placed pair-transfer
witness are promising.

The proposed `FootprintIn R f` headline was rejected as false shape. It only
requires basis transitions to preserve occupations outside `R`; a globally
configuration-dependent diagonal multiplier therefore has empty footprint even
though it is not an operator supported on the empty region. This cannot support
the words "local observable" or "causal cone."

Sent an Aristotle `--mode instruct` correction: retain `FootprintIn` only as an
occupation-transition bound and replace the headline support API by the strong
even-CAR criterion that `A` commute with every creation and annihilation
generator outside `R`. Prove local block support, one-step Heisenberg growth,
the list/`t`-step cone, and retain the disjoint-gate and nonzero witness controls.
Integration is blocked until this stronger semantic ladder compiles.

## 2026-07-11 04:16 PDT final integration

Aristotle accepted the semantic correction and returned the strong ladder plus
an explicit counterexample: the global number operator has empty
occupation-transition footprint but is not `CARSupported` on the empty region.
The final returned module compiles unchanged against the live project. It was
integrated as `PhysicsSM/Draft/NullEdge/PlueckerCausalCone.lean`, with exact
strong support, one-step and finite-schedule Heisenberg cones, disjoint-gate
commutation, unit-phase involutivity, nonzero phase transfer, the weak-support
counterexample, and standard-three axiom guards. Claim/gate/artifact/portfolio/
document-map/manuscript synchronization completed. Remaining scope: no
composition with the spatial free walk, odd-observable ordinary commutation,
operator exponential, scattering, continuum, or higher-dimensional
Jordan--Wigner theorem.

## 2026-07-11 04:24 PDT second semantic audit and demotion

The strong CAR predicate repairs the occupation-footprint defect, but a second
scope audit found that it still does not establish a geometric finite-speed
cone. `Block := Fin 4 -> ι` is any four-mode embedding, not a contiguous block
of a graph or chain, and `heisenFoldBlocks_CARSupported` accepts an arbitrary
list of such blocks. Its `coneRegion` is therefore the union of a supplied
schedule, with no graph metric, finite interaction range, local-layer
predicate, or radius-versus-time theorem. In addition, the fold theorem is
stated for arbitrary phase `u`; interpreting `gAg` as Heisenberg conjugation
requires the separately proved unit-phase involutivity hypothesis.

The live records have accordingly been demoted from “strict causal cone” to
“exact declared-set CAR support and scheduled support propagation.” A second
Aristotle instruction requests a genuine chain/graph theorem with contiguous
finite-range gates, parallel local layers, a `t`-step neighborhood bound, an
explicit unit-phase conjugation corollary, outside-cone commutation, and a
nonzero boundary-saturating witness. Until that ladder lands and survives
hostile audit, bounded-speed geometric causality remains open.

## 2026-07-11 05:05 PDT in-progress geometric-cone audit

Downloaded the second-task snapshot and inspected the new
`PlueckerGeometricCone.lean`. Its core theorem shape is now the right one:
strong CAR support is propagated through a disjoint-pruned schedule and bounded
by an iterated graph neighborhood under a load-bearing `BlockLocal` condition.
Before integration, sent another `instruct` correction for four remaining
semantic gaps. The list is sequential gates, not parallel layers; involutivity
proves algebraic conjugation but not Hilbert-space unitarity; the nonzero pair
transfer does not by itself prove sharpness of the observable-support bound;
and an explicit nonlocal block must witness failure of `BlockLocal`. Aristotle
must also restore all standard-three guards. No geometric-cone claim is landed
until the corrected file compiles locally and passes a hostile source audit.

## 2026-07-11 06:12 PDT construction-freeze rejection

Downloaded the 06:03 remote snapshot and rejected integration. The core
`heisenFoldBlocks_geometric_cone` theorem is proof-complete and has the intended
graph-neighborhood shape for a sequential list of `BlockLocal` gates. However,
the snapshot still contains a proof hole in `witBlock_BlockLocal`, comments out
all axiom guards, calls the merely invertible gate product "unitary" without an
inner-product theorem, calls a nonzero transfer amplitude "saturating" without
a smaller-support failure theorem, and supplies no explicit nonlocal block with
`not BlockLocal`. The project remains remote-running. The live tree retains only
the already-landed declared-set/scheduled-support theorem; no graph-metric cone
claim has been promoted.

## 2026-07-11 06:40 PDT corrected successor integrated

The user waived the construction cutoff, and Aristotle's corrected snapshot
cleared every quarantining gate.  `PlueckerGeometricCone.lean` now has no proof
holes, restores per-module standard-three guards, describes a sequential gate
list rather than parallel layers, and calls `heisenFoldBlocks_isConj` only an
algebraic invertible conjugation result.  It explicitly denies cone sharpness.
The load-bearing controls are both present: `witBlock_BlockLocal` proves the
contiguous block `{0,1,2,3}` is radius-three local and
`not_BlockLocal_farBlock` proves `{0,1,2,7}` is not radius-one local.  The
nonzero boundary transfer remains a nontriviality witness only.

The exact returned source compiled unchanged against the live project before
integration.  It is imported by `PhysicsSMDraft`, pinned by the consolidated
overnight guard, and covered by the publication verifier.  Remaining scope is
the pairwise-disjoint parallel-layer theorem, free-walk composition, a local
Hamiltonian/action or exponential derivation, scattering/binding, continuum,
and graded odd-observable locality.
