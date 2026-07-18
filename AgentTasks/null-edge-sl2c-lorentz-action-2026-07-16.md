# Null-edge SL(2,C) Lorentz action

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Claim grade: `M [comp]` for finite spin/Lorentz matrix algebra only
Status: integrated, built, and independently approved

## Objective

Construct the concrete Pauli/Hermitian action of `SL(2,C)` on real Minkowski
coordinates in the project's `(+---)` convention, package it as a group
homomorphism into the exact eta-Lorentz group, and identify the proved boundary
of the spin-cover statement.

This closes a finite representation-theoretic bridge only.  It does not prove
that a bare graph supplies a rank-four Lorentz sector, that its Lorentz atlas
admits a spin lift, that discrete curvature converges, or that Einstein
dynamics follows.

## Production module

`PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean`

SHA-256:
`a949e1f58c6e9cc539eddfd546c272848d09aed619d3a18da8c591e664ff58fa`

## Landed finite results

- `hermitianCoords` is the explicit inverse coordinate map for the existing
  Pauli/Hermitian lift.
- `hermitianCongruenceLinear` is the real-linear congruence action
  `X |-> A * X * A^dagger`.
- `sl2LorentzLinear` transports that action to `Fin 4 -> Real` Minkowski
  coordinates.
- `sl2LorentzLinear_preserves_minkowskiSq` and
  `sl2LorentzLinear_preserves_minkowskiInner` prove preservation of the
  mostly-minus quadratic form and its associated bilinear form.
- `sl2LorentzMatrix_isEtaLorentz` packages the action as an exact
  eta-preserving matrix.
- `explicitSL2LorentzMatrix_eq_sl2LorentzMatrix` proves that the direct
  Pauli-coordinate matrix submitted to Aristotle is exactly the production
  standard-basis matrix.
- `sl2ToEtaLorentz` is the resulting monoid homomorphism
  `SL(2,C) -> O(1,3)`.
- `sl2LorentzMatrix_isOrthochronous` and
  `one_le_sl2LorentzMatrix_timeTime` prove that every image element is in the
  orthochronous component.
- `sl2LorentzMatrix_det_one` proves that every image matrix has real
  determinant one, and `sl2ToRestrictedLorentz` factors the action through
  the proper-orthochronous Lorentz subgroup.
- `timeCharacter_sl2ToEtaLorentz` proves that the time-component character is
  trivial on the whole image.
- `hermitianLorentzAction_fixed_of_mem_kernel` proves that membership in the
  concrete Lorentz kernel forces congruence to fix every Pauli/Hermitian
  Minkowski vector.  This is the production bridge to the focused exact-kernel
  theorem.
- `sl2ToEtaLorentz_neg` and `minusIdentity_mem_kernel` prove the central-sign
  identification `A` and `-A`, including `-I` in the kernel.
- `hermitianLorentzAction_kernel` proves that fixation of every Pauli-lifted
  Minkowski vector forces `A = I` or `A = -I`.
- `sl2ToEtaLorentz_eq_one_iff` and
  `sl2ToRestrictedLorentz_eq_one_iff` prove that both concrete homomorphisms
  have exact kernel `{+I,-I}`.

No production theorem contains a proof handoff marker.  Build-enforced axiom
guards pin representative results to the standard project axiom footprint.

## Focused properness target

- Source:
  `AgentTasks/aristotle-standalone/null-edge-sl2c-lorentz-action-20260716/SL2CLorentzProperness/Core.lean`
- Context pack:
  `AgentTasks/context-packs/sl2c-lorentz-properness-20260716-20260716-135132.md`
- Exact target:
  `lorentzMatrix_det_one (A : SL2C) : (lorentzMatrix A).det = 1`.
- The focused matrix is defined directly from the four Pauli basis vectors and
  Hermitian congruence.  This makes properness a finite determinant theorem
  over the entries of an `SL(2,C)` matrix rather than an appeal to unformalized
  connectedness.

The submitted focused source typechecked under the pinned toolchain with one
proof handoff marker. Aristotle returned a complete general determinant
identity, and the harvested source passed locally before production adaptation.

## Aristotle

```yaml
aristotle:
  project_id: ca8eab68-063f-4ba5-b5c5-88b5c0fa3428
  task_id: 0cf06c7c-a34d-49be-8b15-dd1e4a8632ef
  target_file: PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean
  expected_module: PhysicsSM.Draft.NullEdge.SL2CLorentzAction
  submission_project: AgentTasks/aristotle-submit/null-edge-sl2c-lorentz-properness-20260716-project
  output_dir: AgentTasks/aristotle-output/ca8eab68-063f-4ba5-b5c5-88b5c0fa3428
  status: harvested_and_integrated
```

## Semantic review checklist

- The Pauli lift must use the repository's mostly-minus convention
  `det(pauliLift x) = x0^2 - x1^2 - x2^2 - x3^2`.
- Congruence must be `A * X * A^dagger`, not an inverse or transpose variant.
- The extracted real matrix agrees with `sl2LorentzMatrix` by the
  kernel-checked theorem `explicitSL2LorentzMatrix_eq_sl2LorentzMatrix`.
- Determinant one establishes properness of the image; it does not establish
  surjectivity onto `SO^+(1,3)`.
- The exact-kernel theorem proves both directions and introduces no
  connectedness, continuity, or spectral hypotheses.
- The existence of the group homomorphism does not prove a graph-derived
  Lorentz atlas has a global spin lift.

## Verification log

- Focused theorem package:
  `lake env lean AgentTasks/aristotle-standalone/null-edge-sl2c-lorentz-action-20260716/SL2CLorentzProperness/Core.lean`
  passed with exactly the expected target handoff warning.
- Aristotle project `ca8eab68-063f-4ba5-b5c5-88b5c0fa3428` was submitted
  from the focused package on 2026-07-16 and registered in the autonomous lab.
- Aristotle task `0cf06c7c-a34d-49be-8b15-dd1e4a8632ef` returned
  `COMPLETE_WITH_ERRORS`, but its unchanged theorem proof was extracted and
  passed under the pinned repository toolchain. The remote status is retained
  rather than rewritten as an unqualified success.
- Production direct check:
  `lake env lean PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean` passed cleanly.
- The dependent targeted build
  `lake build PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary` passed all
  8056 jobs, replaying only pre-existing warnings from
  `AtlasTransitionHolonomy.lean` and `NullStrand.Conventions`.
- Axiom guards for coordinate inversion, explicit-matrix equivalence, eta
  preservation, determinant one, restricted-component membership,
  time-component triviality, and both exact-kernel statements report only
  `propext`, `Classical.choice`, and `Quot.sound`.

## Remaining gates

1. Prove surjectivity onto `SO^+(1,3)` or import a convention-checked theorem
   with full provenance.
2. Define the graph-atlas spin-lift obstruction and prove its vanishing under
   explicit graph hypotheses.
3. Derive a nondegenerate rank-four Lorentz sector from the graph, then develop
   connection curvature, convergence, physical stress-energy, and dynamics.

## Independent semantic review

Claude independently rebuilt the action and boundary modules, checked the
mostly-minus Pauli convention, determinant bridge to the production matrix,
both directions of the exact-kernel theorem, restricted-group factorization,
and the absence of hidden graph, spin-lift, `w2`, refinement, surjectivity, or
continuum claims. Verdict: **APPROVED**, no revisions, at production SHA-256
`a949e1f58c6e9cc539eddfd546c272848d09aed619d3a18da8c591e664ff58fa`.

Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_SL2C_EXACT_KERNEL_2026-07-16.md`.
