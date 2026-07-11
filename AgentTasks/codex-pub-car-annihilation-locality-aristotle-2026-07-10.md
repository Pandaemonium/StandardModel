# Aristotle proof task: annihilation covariance and support locality

Prove every theorem in `CARAnnihilationLocality/Main.lean` without changing any
statement.  The imported determinant-minor lift now has exact creation
covariance, functoriality, adjoint compatibility, inverse, and Fock-inner-product
preservation.

Requirements:

- preserve the exact covariance orientation
  `a_j Gamma(U) = sum_i U(j,i) Gamma(U) a_i`;
- prove both creation/annihilation adjoint identities for the displayed finite
  Fock inner product;
- retain arbitrary finite linearly ordered mode type and both unitary identities;
- prove relation-filtered creation and annihilation support laws without adding
  symmetry or transitivity assumptions on the relation;
- retain the explicit nonzero swap control;
- no compiler-trusting shortcut, extra assumption, or statement weakening.

If the annihilation orientation is false, return an exact counterexample rather
than changing it silently.  If a later support theorem blocks, return the
largest proof-complete prefix and exact goal.

Boundary: these are exact finite operator/support statements, not an interacting
causal net, Lieb-Robinson bound, or continuum QFT locality theorem.

```yaml
aristotle:
  project_id: 7989d240-ddd1-45b0-8985-d99a9b3d898c
  target_file: CARAnnihilationLocality/Main.lean
  expected_module: CARAnnihilationLocality.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-car-annihilation-locality-20260710-project
  output_dir: AgentTasks/aristotle-output/7989d240-ddd1-45b0-8985-d99a9b3d898c
  status: two-hour-stalled/no-new-prefix
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Two-hour stall disposition

Downloaded the active snapshot and instructed immediate return. None of the
six requested statements had a proof-complete body in the snapshot. The live
creation-support theorem remains valid and guarded; annihilation adjointness,
covariance, relation-filtered support, and the swap control remain open. The
next attempt must split the inner-product adjoint lemma from covariance and
support rather than resubmit the six-theorem cluster.
