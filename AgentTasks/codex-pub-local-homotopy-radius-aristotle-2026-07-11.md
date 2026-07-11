# Aristotle proof job: locality of the physical-channel homotopy

## Objective

Close every proof hole in `LocalHomotopyRadius/Main.lean` without changing the
definitions or theorem statements.  Run only:

```text
lake env lean LocalHomotopyRadius/Main.lean
```

The target formalizes the next H1 rung after the landed finite endomorphism
cohomology theorem:

- monotonicity and addition for finite matrix-range bounds;
- additive range under matrix multiplication;
- a quantitative bound for the explicit homotopy `S * X + (P * X) * S`;
- finite range of the exact correction `Q * H + H * Q`;
- a sharp rational `Fin 5` path witness attaining distance two; and
- a distant-entry control proving locality of `P` is load-bearing.

Search Mathlib before writing auxiliary arithmetic.  Keep the exact path
witness and negative control.  Do not replace strict vanishing outside the
radius by a norm estimate, change the radius formulas, use a compiled evaluator,
or weaken the statements silently.  If a displayed radius is false, return the
smallest corrected universal radius and an exact counterexample to the frozen
statement.

Semantic boundary: this proves an abstract finite-range preservation theorem.
It does not derive the constraint differential, contraction, or physical
projector from the live carrier, and it does not classify the physical
automorphism group.

```yaml
aristotle:
  project_id: d683a0c4-5272-4ca1-9260-d7df18d48a2c
  task_id: b6c5782f-ddda-49a9-a4c7-53c032f50de0
  target_file: LocalHomotopyRadius/Main.lean
  expected_module: LocalHomotopyRadius.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-local-homotopy-radius-20260711-project
  output_dir: AgentTasks/aristotle-output/d683a0c4-5272-4ca1-9260-d7df18d48a2c
  status: integrated-hybrid
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

Submission correction: the initially archived target used Lean's Boolean
`!=` notation in the sharp-witness conjunction.  The intended proposition is
`Ne H 0`.  The local source and prepared project copy were corrected, and an
instruct-mode message sent immediately to project `d683a0c4-...` froze that
semantic repair before proof search.  No other statement changed.

At 08:07 PDT Codex harvested the proof-complete generic band algebra and exact
fixtures from the running snapshot, completed the two remaining composition
corollaries locally, and independently compiled the whole target. It was
integrated under the project namespace as
`Carrier/PhysicalHomotopyLocality.lean`. Aristotle was instructed to stop
further proof search and finalize its current source.
