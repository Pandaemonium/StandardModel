# Aristotle task: vacuum-Weyl varying-coframe refinement

Date: 2026-07-18
Status: in progress

## Objective

Design and, where feasible, formalize the smallest periodic proper
eta-Lorentz null-edge plaquette refinement that can realize a nonzero
vacuum-Riemann target while satisfying both Euler sectors of the repository's
nonlinear Palatini action.

The job must treat construction and no-go analysis symmetrically. Do not
weaken the target merely to obtain a theorem. If the requested finite ansatz is
impossible, return the strongest precise obstruction and the minimal
additional degrees of freedom needed to escape it.

## Established live results

1. `PhysicalLorentzPlaquetteRefinement.lean` constructs a nonzero exact
   proper eta-Lorentz periodic square with action-visible first-order
   curvature.
2. `PhysicalLorentzPlaquetteEinsteinAudit.lean` proves that every nonzero
   target in that square family fails joint stationarity across a shrinking
   sequence when the coframe is fixed to the identity.
3. `VacuumWeylCurvatureTarget.lean` supplies a two-parameter diagonal local
   curvature family with ordered bivector coordinates
   `(-x-y, y, x, x, y, -x-y)`. It is face-antisymmetric, pair-symmetric after
   lowering both internal indices with eta, satisfies algebraic first Bianchi,
   and has zero mixed Ricci, scalar, and Einstein tensors at the identity
   coframe. The `(x,y)=(1,0)` member is nonzero.
4. `NonlinearLorentzPalatiniEinsteinResponse.lean` identifies coframe
   stationarity exactly with the finite mixed Einstein equations.
5. `NonlinearLorentzPalatiniEuler.lean` gives the exact six-component local
   nonlinear link Euler coefficients.
6. `NonlinearLorentzPalatiniVaryingCoframeLimit.lean` proves the conditional
   stationary varying-coframe refinement-to-Einstein limit theorem.

Semantic context pack:
`AgentTasks/context-packs/null-edge-vacuum-weyl-varying-coframe-20260718-053008.md`.

## Exact research question

Find the smallest credible choice of:

- finite periodic carrier and four commuting shifts;
- shrinking eventually nonzero area sequence;
- proper eta-Lorentz group-valued link connections;
- finite coframes with exact left inverses;
- nonzero multi-face curvature target in the algebraic Riemann sector;

such that the coframe and connection are jointly stationary for the exact
nonlinear Palatini action at every refinement level and converge to a nonzero
vacuum target.

The preferred curvature seed is `unitVacuumWeylTarget.curvature`, but a
tetrad-aware or site-decorated version is acceptable if its relation to that
seed is explicit and all Riemann symmetries are retained in the limiting
coframe convention.

## Required audit points

1. Check periodic exactness/cohomology constraints on a multi-face target.
2. Keep the distinction between raw contravariant bivector coordinates and
   internally lowered pair-exchange symmetry.
3. Evaluate or linearize both the six link Euler and sixteen coframe Euler
   systems; satisfying only the mixed Einstein equation is insufficient.
4. Determine whether a varying coframe can cancel the link obstruction found
   for the static square.
5. State whether Levi-Civita/torsion-free selection follows, must be imposed,
   or remains a separate theorem.
6. Do not claim graph derivation, continuum convergence, or orthochronous
   membership unless proved.

## Post-submission local result

`PeriodicVacuumWeylMeanObstruction.lean` was proved after this job entered its
run. It establishes that every periodic additive curl has componentwise zero
site sum and obeys exact discrete Bianchi. It rules out a site-independent
unit-Weyl target on a fixed carrier and proves that a common scalar decoration
of the unit Weyl shape must be shift invariant. More strongly, both parameters
of the site-decorated diagonal Weyl family must be shift invariant while its
bivector eigenplanes remain fixed. In particular, the zero-mean `2 x 2`
checkerboard is not realizable. Harvest review must compare the
Aristotle proposal with these stronger necessary conditions.

`PeriodicVacuumWeylNullWave.lean` was subsequently proved locally. It gives a
two-site periodically exact additive null-wave curvature whose two transverse
link potentials use independent null-rotation bivectors. The field is nonzero
at both sites with opposite amplitudes, satisfies metric-lowered pair exchange
and both Bianchi identities, and is pointwise Ricci, scalar, and mixed-Einstein
flat at identity coframe. Harvest review should now focus on what Aristotle
adds beyond this linearized construction: nonlinear proper-Lorentz links,
joint link/coframe stationarity, Levi-Civita compatibility, or a stronger
no-go theorem.

`PeriodicVacuumWeylNullWaveProperLift.lean` was then proved locally while this
job remained in progress. It exponentiates the commuting nilpotent
null-rotation links to exact proper eta-Lorentz transports and proves every
plaquette is exactly the exponential of its additive null-wave curl. The
action-visible extractor is exactly area times the curvature, so the identity
coframe satisfies all finite mixed vacuum Einstein equations and is exactly
coframe-stationary. A separate exact coefficient calculation gives
`-2 * area` in the direction-`1`, component-`1` connection equation at site
`1`; hence the identity coframe is not connection- or jointly stationary at
nonzero area. Harvest review must now require a genuinely varying-coframe
joint-stationary construction, a Levi-Civita theorem, or a stronger no-go than
this static-coframe obstruction.

## Requested output

Create
`PhysicsSM/Draft/NullEdge/VacuumWeylPeriodicRefinementAristotle.lean` with one
of the following outcomes:

- a typechecking construction and the strongest proved stationarity and limit
  statements available; or
- a typechecking no-go theorem for a clearly defined ansatz class, plus exact
  definitions and theorem statements for the smallest escape class.

Also return a concise design report naming:

- the finite carrier and link/coframe ansatz;
- equations reduced and remaining unknowns;
- exact proved statements;
- any incomplete proof markers and their blockers;
- semantic risks or convention assumptions;
- the next theorem that should be sent to a proof-only Aristotle job.

## Success criteria

- No weakening or silent convention changes.
- No new assumptions introduced solely to force stationarity.
- Every headline result has explicit nonzero witnesses or a genuine no-go
  conclusion.
- Any incomplete proof marker is confined to draft code and carries a useful
  handoff note.
- The output distinguishes finite identity, conditional asymptotic theorem,
  reconstruction requirement, and physical interpretation.

## Aristotle metadata

```yaml
aristotle:
  project_id: a8d83497-34e4-4151-a122-59b821b3e587
  task_id: 49956b25-fb1b-4877-ac4c-7b25370d1518
  target_file: PhysicsSM/Draft/NullEdge/VacuumWeylPeriodicRefinementAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdge.VacuumWeylPeriodicRefinementAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-vacuum-weyl-varying-coframe-20260718-project
  output_dir: AgentTasks/aristotle-output/a8d83497-34e4-4151-a122-59b821b3e587
  status: in_progress
```

Live check on 2026-07-18 after the local null-wave result: project status
`RUNNING`; task status `IN_PROGRESS`. A 30-second progress-stream check
returned no new event before timing out, so the job was left undisturbed.

Second live check after the exact proper-Lorentz lift and static connection
obstruction were proved locally: the project remained `RUNNING` about two
hours after submission. It was again left undisturbed.
