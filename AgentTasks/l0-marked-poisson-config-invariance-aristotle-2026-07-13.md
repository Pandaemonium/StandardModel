# Aristotle task: marked finite-Poisson configuration invariance

- Work item: `L0-DIST-001`
- Role: Builder / Assassin
- Target: `AgentTasks/aristotle-targets/afpl_marked_poisson_config_invariance.lean`
- Priority: P93 distributional Lorentz/decorations

## Objective

Fill the two proof holes without changing any definition, theorem statement,
import, or namespace.  First prove that the graph law obtained by attaching a
measurable deterministic mark is measure-preserved by the product action when
the base law is preserved and the mark is pointwise equivariant.  Then compose
that result with the landed mixed-Poisson configuration theorem.

## Semantic constraints

- Keep decoration equivariance as a displayed hypothesis; do not derive it
  from invariance of the bare point law.
- Prove invariance in distribution, not pointwise invariance of samples.
- Preserve the Poisson count mixture; do not replace the complete law by a
  fixed-cardinality fibre.
- Do not add a Lorentz group, infinite-volume process, canonical frame, or
  physical scale interpretation.
- Use no trust-expanding declarations or evaluator shortcuts.

## Verification

Run:

```text
lake env lean AgentTasks/aristotle-targets/afpl_marked_poisson_config_invariance.lean
```

Return the completed target and state exactly where measurability and the
probability-measure instance for the pushed-forward graph law enter.
