# Aristotle proof task: invariant mass as qubit mixedness (Sol section 1)

Overnight publication run 2026-07-11, Fable lane; incorporates the Sol
strategy memo's minimal-companion-paper package. Focused standalone
Mathlib-only package; all identities self-verified by hand before seeding
(Cayley-Hamilton at unit trace; Lagrange; per-pair Cauchy-Binet; Pauli
algebra).

Targets: T1 det rho = (1 - tr rho^2)/2 at unit trace; T2 normalized-det
scaling; T3 Lagrange/trace-distance form |wedge|^2 = |psi|^2|phi|^2 -
|<psi,phi>|^2; T4 family determinant = sum of pairwise distinguishability
combinations; T5 Pauli convention trace/det (P = E I + p.sigma); T6
maximally-mixed witness (purity 1/2, det/T^2 = 1/4) + pure-state control.

Manuscript consequence: kernel-checks the core of Sol's proposed companion
paper "Invariant Mass as Qubit Mixedness and Null-Direction
Distinguishability"; upgrades the GA manuscript's visibility section and
the headline "mass is qubit mixedness, kernel-checked." Integration must
reconcile with existing NullEdgeQubitConcurrence (trace identity) and
MassCoherenceDuality (visibility duality).

```yaml
aristotle:
  project_id: 2f819742-b3e0-4b4e-9aeb-33fb8a85e78d
  target_file: MassMixedness/Main.lean
  expected_module: MassMixedness.Main
  submission_project: AgentTasks/aristotle-submit/fable-pub-mass-mixedness-20260710-project
  output_dir: AgentTasks/aristotle-output/2f819742-b3e0-4b4e-9aeb-33fb8a85e78d
  status: landed
  run: overnight-publication-run-2026-07-11
  owner: Fable
```
