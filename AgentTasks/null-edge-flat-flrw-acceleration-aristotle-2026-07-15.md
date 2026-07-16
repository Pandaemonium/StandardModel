# Flat-FLRW acceleration control: Aristotle semantic audit

```yaml
aristotle:
  project_id: fa3db7f5-0b0d-4aa9-85d2-518a51fb2b3d
  task_id: 35e5e299-c4d7-441a-9523-fe122bf08473
  target_file: PhysicsSM/Draft/NullEdge/FlatFLRWAccelerationControl.lean
  expected_module: PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl
  submission_project: AgentTasks/aristotle-submit/null-edge-flat-flrw-acceleration-20260715-project
  output_dir: AgentTasks/aristotle-output/fa3db7f5-0b0d-4aa9-85d2-518a51fb2b3d
  status: complete, harvested, and integrated 2026-07-15
```

## Objective

Audit the conditional scale-factor Euler--Lagrange and acceleration control
built on the previously audited flat-FLRW reduced action. Check both
variational derivatives, history compatibility, pressure sign, equivalence to
the spatial Friedmann equation, combination with the lapse equation, all
constants, and the exact witness. Preserve declarations unless a genuine
mathematical or convention defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-flat-flrw-acceleration-20260715-20260715-030842.md
```

## Locked interpretation

1. Signature is `(+---)` and the spatially flat continuum metric
   `ds^2=N(t)^2 dt^2-a(t)^2 dx^2` is assumed, not graph derived.
2. The imported Einstein--Hilbert convention is
   `(R-2 Lambda)/(16 pi G)` with exactly the curvature and total-derivative/GHY
   convention documented in `FlatFLRWFriedmannControl`.
3. The reduced action is
   `-3*a*adot^2/(8*pi*G*N)-Lambda*N*a^3/(8*pi*G)
   +a^3*(velocity^2/(2*N)-N*V)`.
4. The Euler--Lagrange sign convention is
   `partial_a L-d/dt(partial_adot L)=0`. Coordinate velocities, lapse, and
   potential are fixed in `partial_a`; the history theorem requires
   `d a/dt=scaleVelocity(t)` explicitly.
5. The expected spatial equation is
   `2*(1/N)*dH/dt+3*H^2=Lambda-8*pi*G*p`.
6. Combining it with the independently derived lapse equation should yield
   `addot/(a*N^2)-adot*Ndot/(a*N^3)
   =Lambda/3-(8*pi*G/6)*(rho+3*p)`.
7. No theorem derives the FLRW ansatz, Einstein--Hilbert action, boundary term,
   lapse, scale factor, constants, full Einstein equation, or graph dynamics.

## Required audit

1. Run only
   `lake env lean PhysicsSM/Draft/NullEdge/FlatFLRWAccelerationControl.lean`.
2. Independently differentiate the reduced action with respect to `a` and
   `adot`; verify the scale momentum and its time derivative for arbitrary
   lapse.
3. Check the exact algebra from the Euler--Lagrange residual to the spatial
   Friedmann equation, including every sign and factor of `2`, `3`, `N`, `a`,
   `8*pi*G`, pressure, and `Lambda`.
4. Check the acceleration theorem uses two independent field equations and
   does not smuggle in a continuity equation or scalar equation of motion.
5. Audit every nonzero hypothesis for necessity under Lean's totalized
   division and propose concrete degeneracy countercontrols where appropriate.
6. Verify the witness `G=3/(8*pi)`, `Lambda=0`, `v=0`, `V=1`, and
   `N=a=adot=addot=1`, `Ndot=0` against every displayed equation.
7. Audit all prose against imported-versus-derived confusion, vacuity,
   hollow algebra, false shape, and overclaiming of Einstein dynamics.
8. Recommend the strongest next bridge toward graph dynamics or a general
   inhomogeneous Einstein-equation control.

## Required report

Return command results, independent calculations, declaration-by-declaration
verdicts, assumption footprints, exact corrections, degeneracy controls, and a
remaining-obligations ledger. Finish with statement changes, proof holes,
axioms, and all convention assumptions used.

## Submission record

- Submitted project: `fa3db7f5-0b0d-4aa9-85d2-518a51fb2b3d`.
- Submitted task: `35e5e299-c4d7-441a-9523-fe122bf08473`.
- Initial task state: `QUEUED`.
- Focused package contains exactly the four required Lean modules, task note,
  context pack, and Mathlib project metadata; no `.lake` cache was submitted.

## Harvest record

- Aristotle found no statement, proof, sign, boundary-convention, or constant
  defect. It independently recovered both action derivatives, the arbitrary-
  lapse spatial equation, and the acceleration equation without using a
  continuity equation or scalar equation of motion.
- The audit confirmed the exact witness and that nonzero `G`, `N`, and `a` are
  all load-bearing for residual/spatial-equation equivalence under totalized
  division. Its three recommended degeneracy witnesses are now build-checked
  in the live module.
- Detailed report:
  `AgentTasks/aristotle-output/fa3db7f5-0b0d-4aa9-85d2-518a51fb2b3d/extracted/project-files.tar/null-edge-flat-flrw-acceleration-20260715-project_aristotle/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/fa3db7f5-0b0d-4aa9-85d2-518a51fb2b3d/extracted/project-files.tar/null-edge-flat-flrw-acceleration-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`.
