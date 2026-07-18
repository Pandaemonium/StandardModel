# Aristotle job: null-edge soldering capstone (2-spinors are future-null directions)

Date: 2026-07-17
Context: null-edge FOUNDATIONS. The single load-bearing bridge between the
program's two landed islands - the Pluecker mass-area calculus on Weyl
2-spinors (`PhysicsSM.Spinor.PluckerMass` / `PluckerMassCovariance`) and the
SL(2,C) -> SO+(1,3) Lorentz action (`SL2CLorentzAction`). It solders a null
edge (2-spinor) to a future-null Minkowski direction, SL(2,C)-equivariantly,
and identifies rest mass as the invariant length of the timelike sum of two
non-parallel null edges = their Pluecker wedge area. This is the shared root
of the GR half (null structure + Lorentz) and the matter half (spinors +
mass).

```yaml
aristotle:
  project_id: 77a20238-4b8d-4f83-8f4a-5d28f8bafe61
  task_id: harvested-2026-07-17
  target_file: NullEdgeSpinorSoldering/NullEdgeSpinorSoldering.lean
  expected_module: NullEdgeSpinorSoldering.NullEdgeSpinorSoldering
  submission_project: AgentTasks/aristotle-submit/null-edge-spinor-soldering-20260717-project
  source_root: AgentTasks/aristotle-standalone/null-edge-spinor-soldering-20260717
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/NullEdgeSpinorSolderingAristotle.lean
```

## Statements (11, placeholder-proof targets, do not weaken)

Helpers: `vecOfHerm_hermOfVec` (soldering involution on Hermitian data),
`hermOfVec_det_eq_minkowskiSq` (metric = determinant). Capstones:
`nullEdgeVector_minkowskiSq` (null), `nullEdgeVector_time` (energy = spinor
norm/2), `nullEdgeVector_time_nonneg` (future-directed, zero iff psi=0),
`nullEdgeVector_smul` (scale covariance / phase-blind direction),
`rankOne_mulVec` (SL(2,C) congruence equivariance),
`twoEdge_minkowskiSq_eq_wedge` (mass^2 = wedge area^2),
`twoEdge_timelike_iff_wedge_ne_zero` (massive iff non-parallel),
`twoEdge_minkowskiSq_sl2_invariant` (rest mass a Lorentz scalar),
`rest_frame_witness` (two orthogonal null edges -> unit rest vector).

## Preflight

- Statements typechecked 2026-07-17: `lake env lean` EXIT 0 (11 placeholder
  warnings only).
- All five physical claims verified numerically (numpy, mostly-minus
  signature, residuals < 1e-12): future-null with time = |psi|^2/2;
  SL(2,C)-equivariance nu(A psi) = Lambda(A) nu(psi); phase-blindness;
  two-edge minkowskiSq = |wedge|^2 (timelike for independent, null for
  parallel); rest-frame witness (1,0)+(0,1) -> (1,0,0,0), mass 1.
- Convention matches the repo's `MinkowskiConvention.eta = diag(1,-1,-1,-1)`;
  det(psi psi-dagger) = 0 = minkowskiSq consistently.

## Semantic review checklist (for integration)

- Mostly-minus signature must be preserved end to end; `vecOfHerm` real-part
  extraction (`x2 = -(X 0 1).im`) must not be silently flipped.
- `rankOne psi i j = psi i * conj (psi j)` (NOT conj on the first slot) - the
  Hermitian is `psi psi-dagger`, positive semidefinite, future-directed.
- The two-edge mass identity is the physical headline; confirm it is
  `normSq (spinorWedge psi chi)` and not a sign-flipped or conjugated variant.
- Axiom audit per theorem; no compiled-evaluator tactic.

## Integration plan

On landing: integrate to `PhysicsSM/Draft/NullEdge/` with standard-three axiom
guards, then add a BRIDGE lemma set connecting `rankOne` /
`nullEdgeVector` here to the repo's `PluckerMassCovariance.finBundleMomentum`
and `SL2CLorentzAction.hermitianCoords`, so the capstone is anchored to the
actual landed modules rather than a parallel redefinition. Provenance:
Infeld-van der Waerden / Penrose null-flag soldering (clean-room; [import] for
the classical identities, [orig] for the null-edge reading + mass-area-Lorentz
assembly).
