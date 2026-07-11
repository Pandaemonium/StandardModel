# Aristotle proof job: finite Ward automorphism quotient

## Objective

Close every proof hole in `WardAutomorphismQuotient/Main.lean` without changing
definitions or theorem statements. Run only:

```text
lake env lean WardAutomorphismQuotient/Main.lean
```

The target asks for a complete coordinate classification of the complex
matrices that commute with the finite Ward charge and preserve its Krein form,
followed by the exact physical quotient:

- charge commutation iff the displayed five-parameter family;
- the four exact Krein-unitarity equations;
- the combined automorphism classification;
- physical compression equals the final coordinate `e`;
- physical-identity automorphisms are explicitly constraint-exact;
- a nonidentity imaginary shear in the exact kernel; and
- a physical `i`-phase automorphism that is provably not exact.

Keep the witness/control pair and all equations. Do not replace the final
non-exactness theorem by a compression inequality, use a compiled evaluator,
introduce assumptions, or weaken statements silently. If any coordinate
equation is incorrect, return the exact corrected equation and a concrete
counterexample to the frozen one.

Semantic boundary: this classifies the automorphism quotient of the concrete
three-dimensional Ward witness only. It does not classify the full null-edge
carrier or enforce locality, soldering, gauge, grading, or Clifford data.

```yaml
aristotle:
  project_id: 7399f4a8-60eb-4f69-a373-fbcda8367007
  task_id: 295e9109-abba-4584-8d90-7246051e295a
  target_file: WardAutomorphismQuotient/Main.lean
  expected_module: WardAutomorphismQuotient.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-ward-automorphism-quotient-20260711-project
  output_dir: AgentTasks/aristotle-output/7399f4a8-60eb-4f69-a373-fbcda8367007
  status: integrated-corrected
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

At 08:21 PDT Codex downloaded a proof-complete snapshot. Aristotle correctly
refuted the frozen `U.conjTranspose*G*U=1` condition with the exact shear
witness and made the minimal correction to `=G`. The independent Ward audit
found the same frozen-statement failure. The corrected classification and all
witness/control theorems compiled directly against the pinned toolchain and
were integrated as `Carrier/WardAutomorphismQuotient.lean`.
