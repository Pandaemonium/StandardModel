# Aristotle job: the Plucker mass operator B_z (Pro-review centerpiece)

Date: 2026-07-10 morning (Pro paper-review integration). The reviewer's central fix: derive downstream quantities from ONE operator built canonically from spinor data instead of wiring one scalar into modules. Bz = !![0,z;conj z,0] with z the complex wedge: Hermitian+odd, Bz^2 = det P (no independent mass parameter), hero identity H(k)^2 = (k^2+detP)1, explicit +-|z| rest eigenvectors, phase covariance by a chiral unitary, decomposition independence (wedge(MV) = detV wedge(M), |detV|=1), the DERIVED unitary evolution C(a) with group law (corner phases from z, not supplied), collinear control, and the Hermitian-space uniqueness upgrade of the determinant. Anchors Paper I's sections 2-3 per the review.

```yaml
aristotle:
  project_id: c8b24c90-9957-40a3-aa57-8f34fddb8286
  target_file: AgentTasks/aristotle-standalone/plucker-mass-operator-20260710/PlueckerMassOperator/BzOperator.lean
  expected_module: PlueckerMassOperator.BzOperator
  submission_project: AgentTasks/aristotle-submit/claude-plucker-mass-operator-20260710-project
  output_dir: AgentTasks/aristotle-output/c8b24c90-9957-40a3-aa57-8f34fddb8286
  status: complete; harvested and independently checked
```

The canonical definitions remain in `PluckerMassOperator.lean`. The returned
rest eigenvectors, right-unitary decomposition theorem, and exact mass-coin
group law were clean-room ported into `PluckerMassDynamics.lean` and guarded.
