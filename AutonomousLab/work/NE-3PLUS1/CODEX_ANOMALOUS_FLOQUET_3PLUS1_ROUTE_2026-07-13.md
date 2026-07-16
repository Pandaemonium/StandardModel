# Anomalous-Floquet route to strict 3+1 null dynamics

Date: 2026-07-13
Role: Codex / Visionary + Research Scientist
Status: primary 3+1 construction route; AF0 landed and cross-family accepted

## Lateral move

The current no-go work asks a periodically updated null-edge system to behave
like a static lattice Hamiltonian. That discards the strongest extra structure
we possess: the full one-period micromotion.

The proposed pivot is to construct a topologically nontrivial Floquet unitary
loop in three spatial dimensions. Its low-quasienergy spectrum should contain
one Weyl crossing, while the compensating integer required by the static
Nielsen--Ninomiya balance is carried by the winding of the full time-dependent
unitary, not by a second low-energy Weyl cone.

This is not speculative precedent. Higashikawa, Nakagawa, and Ueda give a
periodically driven three-dimensional lattice realization of a single Weyl
fermion, explicitly forbidden in static systems, using a topologically
nontrivial Floquet unitary:

- S. Higashikawa, M. Nakagawa, and M. Ueda, *Floquet chiral magnetic effect*,
  arXiv:1806.06868, Phys. Rev. Lett. 123, 066403 (2019).
  <https://arxiv.org/abs/1806.06868>

Bessho and Sato formulate the corresponding extension of Nielsen--Ninomiya:
bulk chiral fermions can occur in dynamical systems because the dynamics has
an intrinsic bulk topology absent in the static theorem.

- T. Bessho and M. Sato, *Nielsen-Ninomiya Theorem with Bulk Topology: Duality
  in Floquet and Non-Hermitian Systems*, arXiv:2006.04204,
  Phys. Rev. Lett. 127, 196404 (2021).
  <https://arxiv.org/abs/2006.04204>

No external implementation is to be copied. The papers supply theorem shape,
topological invariants, and convention checks for a clean-room finite model.

## Why it fits null-edge physics

1. The fundamental object is already a discrete-time unitary update, not a
   static Hamiltonian.
2. A Floquet period naturally decomposes into local null microsteps, matching
   `NullMicrostepHyperdiamond` and the checkerboard ontology.
3. Zero and pi quasienergy are already separated by
   `FloquetTaggedCrossingBalance`.
4. `Strict3Plus1Frontier` identified the exact mistake in a zero-only static
   balance: compensation may live in the pi sector or the full unitary loop.
5. The existing factorized depth-one and symmetric depth-two candidates have
   zero loop winding; their doubling is therefore a control, not evidence
   against the anomalous route.

## Required architecture

Use a finite substep schedule `U_s(q)`, with `s = 0,...,T-1`, where every
substep is a strictly local unitary null shift or on-site channel turn. Define
partial evolution by `V_0(q) = 1`, `V_(s+1)(q) = U_s(q) V_s(q)`, and endpoint
Floquet operator `U_F(q) = V_T(q)`.

The endpoint `U_F` alone is not enough. Two schedules can have the same
endpoint and different loop topology. The invariant must inspect `(q,s)` over
the full three-momentum torus times the periodic time coordinate.

## Lean theorem ladder

### AF0: finite micromotion API

Define a finite schedule, partial products, cyclic timeframe shifts, and the
endpoint Floquet operator. Prove exact unitarity of every partial product from
unitarity of each substep. Include two schedules with the same endpoint but
different ordered histories as an anti-collapse fixture.

Landed in `PhysicsSM/Draft/NullEdge/FloquetMicromotionSchedule.lean`. The module
proves unitary partial/full endpoints and gives two distinct equal-length
unitary schedules, flip-flip and idle-idle, with the same endpoint. Independent
Claude review accepted multiplication order, non-vacuity, scope, provenance,
and standard-three axiom guards. This proves only that endpoint evaluation
forgets ordered history; it does not yet distinguish the schedules by a
winding invariant.

### AF1: tagged crossing census

Reuse `FloquetTaggedCrossingBalance.IsTaggedCrossing` to classify determinant
zeros of `U_F(q)-1` and `U_F(q)+1`. Prove the candidate has exactly one intended
zero-sector Weyl point in the declared finite/sample census and no second
low-energy zero-sector point. This is not yet a global theorem.

### AF2: local Weyl charge

For an isolated crossing, define the finite orientation charge from the sign
of the determinant of the three derivative/tangent coefficients. Prove an
explicit origin witness has charge `+1` or `-1`, with all normalization and
Pauli/Dirac conventions displayed.

### AF3: three-dimensional endpoint degree, with per-gap refinement if needed

Do not define an integer winding of the four-dimensional map
`(q_x,q_y,q_z,t) -> U(N)`: stable `pi_4(U)` is trivial, so that candidate is
vacuous. For the reconstructed HNU witness, define the `pi_3` degree of the
endpoint map `U : T^3 -> SU(2) ~= S^3`; this is the invariant used by the source
and is sufficient because the exact census isolates one zero-sector node while
the pi sector is the extended Brillouin-zone boundary. Prove conjugation and
timeframe robustness and compute degree one exactly. Introduce a separate
per-gap dynamical invariant only for schedules whose endpoint degree and exact
zero/pi census do not already settle the balance. A determinant phase or
first-pulse trace is insufficient.

### AF4: generalized balance composition

First identify each local determinant-sign charge with the Chern charge on an
`S^2` enclosing that Weyl node. For HNU, compose that local charge with the
endpoint degree and the exact zero/pi census; do not pretend the extended pi
boundary is a collection of isolated nodes. For a genuinely per-gap schedule,
state the zero- and pi-gap balances separately. The static control has zero
winding and recovers cancellation. The anomalous witness has endpoint degree
one and permits one net zero-sector Weyl crossing while the global Floquet
topology and pi boundary carry the compensation. This is the decisive theorem.

### AF5: null-support realization

Factor every schedule substep into primitive null shifts and on-site turns.
Prove strict finite domain of dependence, exact probability preservation, and
the intended first-order Weyl tangent. Any substep with a stationary spatial
component must be identified as an on-site internal turn, not called a null
translation.

### AF6: Dirac mass and Standard Model pairing

Pair opposite anomalous Weyl schedules through the live Pluecker rest operator.
Prove the resulting four-component low-energy sector has one massive Dirac
dispersion while the topological charge and gauge anomaly cancel in the
physical representation content. A single anomalous Weyl walk is not yet a
consistent chiral gauge theory.

## Smallest decisive experiment

Reconstruct the explicit Higashikawa--Nakagawa--Ueda substep unitary from the
paper's mathematical definitions, then test four properties independently:

1. each substep is unitary and finite range;
2. the endpoint spectrum has one Weyl point in the target quasienergy sector;
3. the full-period winding is nonzero;
4. the substeps can or cannot be refactored into the project's primitive-null
   shift architecture without changing that winding.

Outcome 4 is the Null-Edge-specific gate. If the known Floquet construction
requires non-null or nonlocal substeps, it is prior art but not our solution.

## Kill conditions

- Every primitive-null factorization of the required unitary loop has zero
  micromotion winding.
- A nonzero winding requires a second physical low-energy species after both
  zero and pi sectors are counted.
- The single Weyl point has no gauge-covariant interacting completion or its
  anomaly cannot be canceled by the intended Standard Model multiplet.
- The apparent one-node spectrum is a branch-cut convention and disappears
  under a timeframe change.
- The construction gives the correct endpoint but violates locality during
  intermediate substeps.
- The Dirac mass coupling closes the anomalous gap or recreates light aliases.

## Relationship to the open-diamond route

The open-diamond route remains useful for finite-region simulation and boundary
diagnostics. Its first 3+1 coins produce exact or asymptotically light boundary
sectors, now interpreted as possible anomaly-inflow surface states rather than
mere defects. The OD5-min oracle finds fixed four-step interior amplitudes
stable across radii 2--6 to `2.8e-17`, with zero boundary probability by radius
5. Thus the combined route is stronger than either alone: anomalous Floquet
topology accounts for a single bulk Weyl crossing, while causal exhaustion can
make its required surface sector irrelevant to compact interior observations.

## Boundary-memory refinement

The open route suggests a second escape from periodic doubling that is
logically independent of anomalous bulk winding. A chiral shift on a finite
interval is not bijective if amplitude is simply discarded at the edge. It can
be completed to an exact permutation by retaining an oriented boundary
channel: bulk states translate by one edge, while an endpoint state flips its
channel and returns through the interior. The compensating information is then
stored at the boundary rather than folded into a second Brillouin-zone cone.

This does not yet produce a single Weyl walk. It changes the topology of the
problem in the precise place where the static no-go uses a periodic momentum
torus. The focused Aristotle job
`85798492-c0be-43d3-87cc-374d5ae75f32` tests the exact finite seed: invertible
reflecting update, nearest-neighbor locality, and exact interior chiral motion.
The successor is a three-coordinate tensor lift with a Pauli coin and a proof
that compact interior observables agree with the intended bulk rule until the
backward causal cone reaches the boundary.

Three focused theorem modules now isolate the load-bearing finite steps:

- `FloquetWeylOrientationCharge.lean` proves the determinant-sign Weyl charge,
  a nondegeneracy consequence, proper-frame invariance, reflection reversal,
  and positive-scale invariance;
- `FloquetMicromotionObservable.lean` proves that equal Floquet endpoints can
  have distinct basis-invariant first-pulse traces, an exact micromotion
  anti-collapse fixture intentionally weaker than winding and explicitly not
  invariant under a change of Floquet time frame;
- `OpenBoundaryReflectingShift.lean` proves an exact finite permutation with an
  explicit inverse, one-edge locality, bulk chiral translation, and reflecting
  boundary memory.

The first submissions `c22b5827-3041-410f-935b-b61a0f4f805e` and
`4770da4b-f70b-433b-86fe-53fa6abd812e` used Boolean inequality coerced to a
proposition and are forbidden integration sources. Corrected independent
replays are `4d78ebba-67b7-4b1c-86fc-72a8e21ef6ba` and
`10a7109d-135f-4e55-af89-06a0b3cdcc2c`; the live modules use propositional
`Ne` directly.

Three strategy/construction jobs attack the composition rather than another
isolated algebraic identity:

- `74fdf32e-1c28-458b-b378-7e5002920abb` reconstructs the published
  single-Weyl Floquet model and audits every substep against primitive-null
  support. It has now returned an exact depth-eight HNU reconstruction, a
  complete zero/pi census, symbolic trace and linearization checks, and a
  scoped obstruction: spin-blind shifts plus constant on-site turns have zero
  winding, while projector-conditioned nearest-neighbor shifts realize the
  nontrivial model. The report is preserved under
  `AgentTasks/aristotle-output/afpl-floquet-model-reconstruction-20260713/`;
- `ba61cbed-a25d-4cad-88d8-f350a3b7a194` designs the finite integer-valued
  noncommutative winding and tagged-charge balance theorem. Its output must be
  rejected or revised if it proposes a four-dimensional `pi_4(U)` invariant;
- `6ef617a4-a5a1-4d57-8a13-b9484257ce94` attempts the three-dimensional Pauli
  lift of the reflecting boundary-memory update, including all boundary modes.

Together these establish a forked strategy: either the compensating chirality
is carried by nontrivial bulk micromotion, or it is carried by explicit
boundary memory outside a compact observer's finite causal past. A complete
3+1 result must say which mechanism is active and must not count causal
inaccessibility as spectral elimination.

The reconstruction opened two exact successor proof jobs:

- `510857de-e789-4e2d-89ed-1f58044381dd` formalizes the corrected HNU
  projector-conditioned substeps, endpoint unitarity, boundary pinning, trace,
  and zero/pi census;
- `34409cf4-8202-404b-aefd-f528046b06a3` formalizes the pointwise theorem that
  scalar spin-blind logarithmic derivatives have zero antisymmetrized cubic
  trace density, with a noncommuting Pauli control required to be nonzero.

## Claim boundary

Current claim: the HNU field-free model has been clean-room reconstructed as a
depth-eight schedule of projector-conditioned nearest-neighbor shifts. Its
single zero-sector Weyl node, pi-boundary degeneracy, exact trace identity,
boundary pinning, and Weyl tangent have independent symbolic or exact
derivations; winding one remains numerical in this repository. The model is
compatible with a projector-conditioned null-shift alphabet but not with the
strict spin-blind alphabet. Until the exact winding, `S^2` charge bridge,
per-gap balance, and physical Null-Edge alphabet decision land, this is a
high-priority construction route, not a completed Null-Edge 3+1 result.

An exact finite magnetic-cell control has also landed in
`GaugeTwistedMagneticDecoder.lean`: breaking the naked anticommuting magnetic
translations while retaining a gauge-dressed abelian pair yields a unique
`+1` eigenline and a complete `1 + 3` zero/pi census; retaining the second naked
translation forces doubling again. This is an algebraic escape witness, not a
Weyl theorem: it has no momentum-dependent family, linear dispersion, or local
topological charge.

The open-boundary and bulk routes are now conjectured to meet in a finite
bulk-boundary correspondence: endpoint/per-gap bulk charge should equal a net
chiral boundary-transport integer. The bare reflecting shift is the required
transport-zero control. Until that equality and a transport-one null-support
witness land, boundary memory is a design route rather than a resolution.

There is a mandatory finite-trace warning: for any finite unitary `U` and cut
projector `P`, cyclicity forces `Tr(U^* P U - P) = 0`. Therefore the boundary
integer cannot be this naive global trace. It must be a localized or relative
causal-region index with the compensating return flow outside the region, a
stabilized finite-volume limit, or a half-space/infinite-volume index. Jobs
`2e6452db-3be3-4383-90bf-bc4be6680fd2` and
`42a7df94-b0a4-4e03-af13-6683e0e09006` formalize the cancellation control and
select the correct successor invariant, respectively.

Two exact alphabet results now land on opposite sides of the ontological fork:
`ProjectorConditionedStep.lean` proves unitary selected-sector motion with the
complement held fixed, while `SpinBlindWindingObstruction.lean` proves that
scalar logarithmic derivatives have identically zero antisymmetrized cubic
trace density and gives a nonzero Pauli control. The latter is pointwise
algebra: deriving the scalar logarithmic derivatives from an actual schedule
remains a separate bridge theorem. Job `ba414c3d-ba06-4a6e-abca-7f677f56d7a0`
tests whether a projector-conditioned family can be reduced even to the narrow
spin-blind-shift plus fixed-coin factorization.

## New half-space pivot

The finite cancellation theorems now make the boundary requirement sharper.
The reflecting update is one transitive cycle of period `2 * (N + 1)`: local
and reversible, but nonchiral. A nonzero bulk-edge certificate must therefore
be localized or relative with a proved cutoff limit, or genuinely
half-space/infinite-volume. Dropping the far-boundary compensator without a
limit theorem is not an index.

The next Aristotle wave attacks distinct missing links:

- `4edbc70c-620c-424d-8895-0a83581753c3`: derive scalar collapse from an actual
  spin-blind schedule;
- `e61eeec5-b470-4d01-a3fd-3f79d8b489ee`: unilateral/Toeplitz rank-one defect;
- `73a1d386-9910-493b-84b2-1867bdf6ef2e`: exact endpoint-degree-one attack;
- `a8178bce-aebf-40b1-98a1-b85869538183`: honest half-space bulk-edge ladder;
- `c626cb61-f1db-49ff-aa41-a9d96e9152ad`: adversarial route audit.

`WeylSphereChargeBridge.lean` proves the finite Pauli algebra, normalized Bloch
map, and determinant-sign chirality. Degree and Chern remain explicit named-
hypothesis handoffs until the missing topology and Berry-bundle APIs land.

## Multiplet-first lateral pivot

The single-Weyl target may be imposing the obstruction before the physics has
had a chance to cancel it.  A single chiral fermion carries an anomaly, whereas
the Standard Model presents an anomaly-free chiral multiplet.  The alternative
target is therefore not an isolated two-component lattice cone.  It is a local
unitary or Hamiltonian system with a light anomaly-free target sector and a
mirror sector that is provably gapped without breaking the target gauge
symmetry.

This changes the theorem ladder:

1. package the already formalized Standard Model anomaly cancellations as an
   explicit integral charge/representation certificate for one generation;
2. define target and mirror finite Fock sectors, with the symmetry action made
   explicit;
3. construct a symmetry-invariant mirror interaction or domain-wall mass and
   prove a nonzero finite-volume spectral gap on every non-vacuum mirror state;
4. prove that the target sector remains in the kernel and that the interaction
   has no target-mirror matrix elements;
5. only then take the locality and scaling limits needed for a physical chiral
   theory.

The finite spectral statement in steps 3-4 is a legitimate Lean target.  It
does not by itself establish a thermodynamic gap, avoid spontaneous symmetry
breaking, or construct the interacting continuum theory.  Those are separate
named gates.  The route is motivated by domain-wall/overlap constructions and
symmetric mirror-gapping work, but source mathematics and conventions must be
checked before any implementation is ported.

This pivot is complementary to the Floquet route.  The Floquet/half-space work
asks where the compensating topological charge lives.  The multiplet-first
route asks whether the physically required collection cancels that charge and
allows the unwanted mirror degrees of freedom to be lifted collectively.

The first finite multiplet audit has now landed in
`TargetMirrorBilinearNoGo.lean`.  In its explicit four-state toy grading, a
genuinely chiral charge assignment admits no nonzero gauge-invariant bilinear
mass, while any chirality-odd mass can only pair target and mirror sectors.  An
explicit vector-like Dirac pairing shows the escape when charges match.  The
same module exposes a crucial vacuity trap: a diagonal mirror chemical
potential satisfies naive finite "target untouched + mirror gap" predicates
but is not a relativistic mass.  A physical successor must therefore use a
many-body, symmetry-preserving interaction and prove a uniform thermodynamic
gap; finite block positivity alone is not enough.

The channel extension of `HalfSpaceDefectIndex.lean` also proves that the
stabilized near-boundary defect is exactly `+m` for `m` right-moving channels,
`-m` after orientation reversal, and additive under channel stacking, while
the full finite trace still cancels.  This is the algebraic multiplicity law
needed by a multiplet construction, not yet a topological or bulk-edge index.

## Harvest update

`SpinBlindScheduleCollapse.lean` now closes the actual-schedule bridge:
every finite spin-blind shift/fixed-coin schedule collapses to one scalar times
one fixed matrix, and the analytic logarithmic derivative is stated with its
exact differentiability and slit-plane hypotheses.  Thus the scalar cubic
winding obstruction applies to the whole declared spin-blind schedule class,
not merely to an assumed derivative shape.

`OpenBoundaryWeyl3DLift.lean` supplies an exact local and unitary finite 3D
Pauli-coupled reflecting construction.  It is a control, not the solution: no
minimality, momentum-space Weyl tangent, full-operator boundary spectrum, or
single-species theorem is proved.  The uniform-eigenvector result applies only
to the bare one-dimensional reflecting permutation.

`HalfSpaceDefectIndex.lean` now proves the finite-cutoff precursor that the
global trace no-go leaves available.  For cutoff `N >= 1`, the truncated
unilateral shift has an exact `+1` source defect and `-1` far-boundary defect.
The global trace cancels, but every fixed near-boundary window has trace `+1`
once the far cutoff lies beyond it.  Aristotle correctly found that the
unqualified statement is false at `N = 0`.  This is cutoff stabilization, not
yet a Fredholm index or bulk-edge theorem; the pinned Mathlib has no Fredholm
operator/index API.

`HNUExactCore.lean` now supplies the exact noncommutative bulk endpoint that
the earlier abstract route lacked.  Its Pauli-conditioned substeps are unitary;
the depth-eight endpoint is unitary with determinant one; its trace is known
exactly; and the closed cube has a proved zero/pi census with explicit
nontrivial witnesses.  This kills the scalar-schedule collapse failure mode at
the level of an actual three-momentum family.  It does **not** yet prove the
three-dimensional winding number is one, a Weyl continuum tangent, strict
real-space primitive-null locality, or bulk-edge correspondence.

`HalfSpaceRelativeFlow.lean` gives a second, infinite-sequence algebraic
precursor: the shifted half-space indicator has a singleton relative defect
with sum `-1`; the unilateral sequence shift is injective with range exactly
the sequences vanishing at the boundary; and its signed crossing count is
`+1`.  The balance between the crossing count and relative-defect sum is an
arithmetic identity.  The module deliberately does not call these facts a
Fredholm index, analytic trace, operator spectral flow, or bulk-edge theorem;
those identifications remain separate analytic gates.

## Transverse-kernel lateral route

A third attack separates tangential topology from transverse sector selection:
first construct an exact one-dimensional transverse kernel, then ask whether a
local three-dimensional operator restricts to the desired Weyl dynamics on
that sector.  The compensating mode must still be exhibited in the bulk,
opposite boundary, Floquet pi gap, or anomaly-free mirror multiplet rather than
hidden.

Aristotle job `9eb52ec3-fafd-4db5-aa32-fe41c9f9e953` produced a useful but
overinterpreted finite witness.  After semantic narrowing, the landed module
`FiniteTransverseWeylLift.lean` proves a connected three-site chain with exact
one-dimensional kernel, rank-one square certificate, transverse complement
identity, and an exact restriction to the **continuum** Pauli symbol.  It does
not prove a domain-wall fermion, a full-operator gap, or a doubling escape: the
tangential factor is nonperiodic and the additive lift lacks an anticommuting
gamma coupling.  The exact audit is in
`CODEX_FINITE_TRANSVERSE_WEYL_LIFT_AUDIT_2026-07-13.md`.

The strongest composite hypothesis is now: use projector-conditioned anomalous
Floquet micromotion to place the required compensating topology in the pi gap,
and use a transverse kernel selector to isolate the desired zero-gap boundary
sector.  This does not evade anomaly accounting; it relocates the compensator
to an explicitly auditable sector.  A successful theorem must construct the
combined local unitary, prove both gap censuses, and show the zero-gap boundary
restriction has one Weyl charge while the total zero-plus-pi ledger cancels.

In parallel, job `9eff30d1-131c-4ae8-83af-975e3832192d` attacks the
many-fermion `3-4-5-0` symmetric-mass-generation route, explicitly rejecting a
diagonal chemical potential as a mirror-gap solution.  Job
`73a1d386-9910-493b-84b2-1867bdf6ef2e` remains focused on the exact HNU
three-dimensional winding value.

Job `da29672d-5b8a-4e65-bac0-4d3d154dda57` attacks the complementary
real-space bridge: finite spin-conditioned nearest-neighbor shifts, exact
unitarity/locality, and a mode-by-mode proof that their Fourier symbol is the
HNU endpoint.  Its audit must decide whether the held-fixed projector sector
violates the stronger primitive-null ontology or can be refined into an
all-moving register without changing the endpoint.

## Compact-auxiliary null-dilation pivot

The real-space bridge has now landed as HNURealSpaceCore.lean and
HNURealSpaceBridge.lean. It proves exact finite-site locality, full-schedule
inner-product preservation, and mode-by-mode equality with HNUExactCore.
It also proves the obstruction rather than hiding it: each conditioned
substep has a nonzero stationary complementary sector.

There is an exact way to attack that obstruction. Refine one coarse tick into
two fine ticks and add one compact auxiliary coordinate. For a selected
projector P and complement Q:

1. on the first fine tick, P moves half a physical edge while Q moves one
   auxiliary edge outward;
2. on the second fine tick, P moves the second half physical edge while Q
   moves one auxiliary edge back.

Projector orthogonality makes all cross terms vanish. The two-tick product is
exactly the original coarse conditioned shift: P acquires the full physical
translation phase and Q returns to its initial auxiliary site. Every branch
moves on each fine tick in the enlarged register. This is a dilation, not a
claim that an on-site hold was null after all.

This pivot combines three formerly separate ideas:

- HNU anomalous Floquet dynamics supplies one zero-sector Weyl node while the
  compensating topology remains in the pi sector
  (<https://arxiv.org/abs/1806.06868>);
- the generalized dynamical Nielsen--Ninomiya theorem says this relocation is
  allowed only with the full topological ledger retained
  (<https://arxiv.org/abs/2006.04204>);
- transverse/domain-wall methods show why an auxiliary direction can select a
  chiral boundary sector, but also warn that opposite chirality can reappear
  elsewhere when topology or gauge fields demand it
  (<https://arxiv.org/abs/hep-lat/0105032>,
  <https://arxiv.org/abs/2502.03045>).

The inference specific to this project is to use the same compact register
both as the null dilation of the stationary HNU branch and, if possible, as the
transverse selector already modeled by FiniteTransverseWeylLift. This could
turn an apparent extra dimension from bookkeeping overhead into the mechanism
that simultaneously provides all-moving microscopic support and physical
sector selection.

Two jobs test the idea independently:

- 6f1114f3-e46c-4282-8c51-a81803ec62e1 proves the exact two-fine-tick
  dilation, symbol identity, and unitarity;
- e9a3645d-b658-46fe-b761-5b260df7ddad performs an adversarial full-spectrum
  audit of the proposed depth-16 HNU lift.

The route fails if the auxiliary Fourier sectors introduce additional
zero-quasienergy Weyl copies, if a local physical decoder cannot isolate the
desired sector, if null soldering requires an unexplained macroscopic
dimension, or if the compensating charge is merely hidden rather than assigned
to a proved pi, bulk, boundary, or mirror sector. Until those gates close, the
result is a new exact architecture for the stationary-branch problem, not a
complete 3+1 theory.

## Compact-dilation verdict and next branch

Both compact-dilation jobs have now returned and replayed locally. The exact
algebra succeeds, but the physical-resolution claim fails.

- `microBack_microOut` and `symbol_dilation` prove that two all-moving fine
  ticks can factor one conditioned move-plus-hold update on an enlarged
  register. With complementary Hermitian projectors, each fine tick is exactly
  inner-product preserving, and a finite cyclic witness moves both branches.
- The full-spectrum audit proves that a cyclic auxiliary register necessarily
  contains the zero-momentum block, where the auxiliary phase is trivial and
  the complementary branch is held. Away from that block there are `N`
  distinct microscopic auxiliary bands.
- The two-tick decoded operator is independent of auxiliary momentum and is
  exactly the original coarse HNU substep. Therefore its winding, Weyl census,
  and every other decoded invariant are unchanged. The construction is a
  faithful factorization, not an obstruction-removal mechanism.

This closes the pure out-and-back compact-dilation route as a solution. The
factorization remains useful as a theorem and diagnostic control, but it must
not be described as completing primitive-null 3+1 dynamics.

The dependency-ready successor is the controlled transverse-sector branch.
`FloquetTransverseComposite/Core.lean` proves that orthogonal transverse
sectors can carry independent exact unitaries `U` and `V`, with nonvacuous
restriction to the desired `U` sector and a dual exact restriction to the
complement. The next theorem must replace the free parameter `V` by an explicit
local complement update and prove all of the following together:

1. a nonzero pi or bulk gap on the complement sector;
2. exact real-space locality and full-step unitarity;
3. the zero-sector HNU/Weyl restriction on the selected transverse kernel;
4. a zero-plus-pi or target-plus-mirror anomaly ledger with no projected-away
   charge;
5. a full-spectrum census showing that no additional zero-quasienergy Weyl
   copy is introduced.

If no such `V` exists in the current finite range and register size, the right
result is a scoped minimality/no-go theorem identifying the extra range,
memory, or channels that are necessary.

Cross-family review approved this disposition in
`AutonomousLab/reviews/CLAUDE_REVIEW_NullDilation_NoGo_ControlledSector_2026-07-13.md`.
The exact factorization is banked in
`PhysicsSM/Draft/NullEdge/NullDilationConditionedShift.lean`, and the controlled
sector interface is banked in
`PhysicsSM/Draft/NullEdge/FloquetTransverseComposite.lean`. Both targeted builds
and the central overnight axiom-guard build pass. Neither integration changes
the route verdict or licenses a complete 3+1 claim.
