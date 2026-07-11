# Aristotle proof task: changing-lattice ultraviolet tail

Prove the unchanged dominated-convergence theorem in
`ChangingLatticeUVTail/Main.lean`.  Start with:

`lake env lean ChangingLatticeUVTail/Main.lean`

The imported live module already proves the exact bulk-plus-tail inequality.
This theorem must show that the `L2` norm of `exact` outside measurable,
monotone bands tends to zero when those bands exhaust the space.  Use the
`MemLp exact 2 mu` envelope and pointwise eventual membership furnished by
`hmono` and `hcover`.  Small measurable-indicator and dominated-convergence
helper lemmas are encouraged.  Do not add finite-measure, sigma-finite, or
continuity assumptions unless the theorem is false without them; in that case
return a precise counterexample and the weakest corrected statement.

Acceptance requires the theorem unchanged, no proof holes, and the target
command passing without compiler-trust shortcuts.

```yaml
aristotle:
  project_id: 7ea06419-d4b9-4a8e-90d9-4645c019d5d6
  task_id: ea3b2af1-b817-4a4d-880f-ea223eccf791
  target_file: ChangingLatticeUVTail/Main.lean
  expected_module: ChangingLatticeUVTail.Main
  submission_project: AgentTasks/aristotle-submit/changing-lattice-uv-tail-20260710-project
  output_dir: AgentTasks/aristotle-output/7ea06419-d4b9-4a8e-90d9-4645c019d5d6
  status: completed-and-integrated
  integrated_file: PhysicsSM/Draft/NullEdge/ChangingLatticePDECore.lean
```
