# Aristotle strategy task: changing-lattice position-space PDE limit

Design the exact Lean theorem stack that upgrades the landed compact-support
momentum-space multiplier convergence to a changing-lattice position-space
Dirac evolution theorem.

Required outputs:

- explicit lattice spacing/index family and Hilbert spaces;
- sampling and interpolation maps with normalization conventions;
- finite/infinite Fourier isometries and inverse transform statements;
- the strongest honest Sobolev or compact-Fourier-support hypotheses;
- uniform-on-bounded-time strong `L2` convergence with an explicit rate when
  available;
- identification of the limiting multiplier with the position-space Dirac
  PDE generator;
- a separate variable-Pluecker-profile successor and its necessary regularity;
- exact Lean-ready lemmas reusing `ContinuumL2MultiplierBridge`,
  `CompactSupportL2WalkBridge`, and `CountableL2WavepacketConvergence`.

Return a proof graph, exact statements, imports, normalization witness, UV-tail
kill control, and any theorem-level obstruction. Do not relabel fixed-momentum
or same-space multiplier convergence as changing-lattice PDE convergence.

```yaml
aristotle:
  project_id: 95febb02-550e-4e73-8ea8-0ff1c56355c3
  task_id: 71cc8cc8-27eb-42a5-9d02-a50d91d20472
  target_file: ChangingLatticePDE/Main.lean
  expected_module: ChangingLatticePDE.Main
  submission_project: AgentTasks/aristotle-submit/changing-lattice-pde-strategy-20260710-project
  output_dir: AgentTasks/aristotle-output/95febb02-550e-4e73-8ea8-0ff1c56355c3
  status: completed-and-harvested
  report: AgentTasks/aristotle-output/95febb02-550e-4e73-8ea8-0ff1c56355c3/extracted/project-files.tar/changing-lattice-pde-strategy-20260710-project_aristotle/AgentTasks/changing-lattice-pde-strategy-DESIGN.md
```
