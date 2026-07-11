# Aristotle task: exact kernel of the even-exterior cover action

Status: submitted.

Target:
`AgentTasks/aristotle-targets/codex_24h_jc5_exact_exterior_kernel.lean`.

Prove every declaration without weakening any statement. Run the target file
first. The hard core is
`evenExterior_identity_implies_trueImage_identity`: on the true product-cover
domain, the total block matrix has determinant one, and identity on exterior
degree four should force the original five-dimensional block matrix to be the
identity. The existing exact product-cover theorem then closes the six-element
kernel classification.

Allowed: small reusable helper lemmas about exterior degree four, determinants,
duals, bases, or minors. Prefer Mathlib APIs. If the statement is malformed or
cannot be proved, return the exact blocker and the strongest typechecked
replacement without editing the target silently.

Required controls already stated in the file:

- every explicit standard kernel element acts identically;
- every element outside the six-element family acts nontrivially.

Manuscript consequence if landed: the continuous true product-cover action on
the complete sixteen-state even exterior module has exact kernel `Z6`, not only
kernel inclusion.

Scope exclusions: no topological quotient, Lie-group smoothness, Jordan-derived
weak/color split, Furey-module intertwiner, chirality derivation, or dynamics.

```yaml
aristotle:
  project_id: ca0e21e7-0b55-4694-9552-79c423742b78
  target_file: AgentTasks/aristotle-targets/codex_24h_jc5_exact_exterior_kernel.lean
  expected_module: handoff target, to be integrated as PhysicsSM.Draft.JordanCliffordExactExteriorKernel
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc5-exact-exterior-kernel-20260711-project
  output_dir: AgentTasks/aristotle-output/ca0e21e7-0b55-4694-9552-79c423742b78
  status: submitted
```
