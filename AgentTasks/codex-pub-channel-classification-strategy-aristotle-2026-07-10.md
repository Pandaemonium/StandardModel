# Aristotle strategy: classify finite carrier channel decompositions

Design a publication-grade mathematical classification program from the exact
carrier-square rigidity and non-rigidity results supplied in the package. This
is a hostile strategy/formalization-design job, not authority to edit the live
repository.

## Starting facts to audit

1. `CarrierRigidity.square_decomposition` gives an exact four-term word-source
   expansion of the chosen carrier square.
2. `parity_decomposition_unique`, `square_oddPart`, and `square_evenPart` make
   only the chirality odd/even split canonical from the displayed axioms.
3. `CarrierRigidity.Concrete.shared_type_but_distinct` and
   `NullEdgeCloser.split_not_forced` show that type and block count do not force
   the aperture/closure/turn refinement.
4. `FourChannelRigidity` gives coefficient recovery and linear independence for
   one explicit rational witness after coordinate/support selectors are added.

## Questions

1. Define the correct objects `CarrierDatum`, `ChannelDecomposition`, and
   selector-preserving equivalence. Which data belong to the carrier and which
   would circularly encode the desired channel names?
2. State the smallest nontrivial type-only moduli theorem. It must do more than
   observe that a vector sum can be rewritten: identify an explicit group
   action, orbit/stabilizer, affine variety, torsor, or quotient and state the
   exact nondegeneracy conditions.
3. Give a typechecking Lean theorem ladder for an explicit one-parameter family
   of alternative even-sector refinements with fixed total, including a proof
   that the family is genuinely inequivalent under a clearly stated initial
   equivalence relation.
4. Formulate an abstract commuting-involution or commuting-idempotent theorem
   that would make joint eigenspace decomposition unique. Explain how
   chirality parity, solder/word degree, and edge exchange might instantiate it,
   and flag any selector that is not intrinsic or does not commute.
5. Rank the candidate selectors -- locality, causal support, checkerboard
   compatibility, physical positivity, gauge/frame covariance, information
   monotonicity, and refinement/RG naturality -- by mathematical independence
   and likely ability to reduce the moduli.
6. State a necessary-and-sufficient selector theorem that would make the paper
   publishable, and the sharp residual-moduli no-go if uniqueness fails.
7. Identify the nearest mathematical literatures and precise novelty boundary:
   Weitzenboeck/superconnection decompositions, simultaneous eigenspace
   decompositions, invariant theory/moduli, operator systems/positive cones,
   and quantum resource theories.
8. Give a Lean architecture that reuses Mathlib abstractions and the supplied
   declarations rather than baking the explicit `4x4` matrices into the main
   theorem.
9. Audit the phrases `exhaustive`, `four channel types are forced`, `unique`,
   and `canonical`. Give exact safe replacements at each retained-data level.
10. Finish with a ranked 6-hour theorem sequence and a paper verdict:
    `STANDALONE CLASSIFICATION`, `SECTION OF PAPER F`, or `NOT YET A PAPER`.

## Required output

- `FATAL`, `MAJOR`, `MINOR`, and `CLEAR` findings about the current reading.
- Exact definitions and theorem statements in Lean-shaped pseudocode.
- At least one explicit nondegenerate family and one uniqueness/control case.
- Prohibited weakenings and circular selectors.
- A theorem dependency DAG and honest publication headline.

```yaml
aristotle:
  project_id: cb571b0d-b79a-41a2-ad6a-3294b9c13a76
  target_file: review-only classification report
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-channel-classification-20260710-project
  output_dir: AgentTasks/aristotle-output/cb571b0d-b79a-41a2-ad6a-3294b9c13a76
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Codex disposition

Accepted:

- the displayed four-term square equation is an exact chosen monomial grouping,
  not by itself a four-type rigidity theorem;
- chirality supplies the intrinsic odd/even split, while the even refinement
  retains moduli unless further selectors are justified;
- a second separating grading or commuting-projector structure is the right
  conditional uniqueness mechanism;
- coordinate readers are circular evidence for intrinsic canonicity;
- the abstract and concrete carrier normalizations need an explicit bridge.

Rejected as a review-package artifact:

- the report's claim that the live `FourChannelRigidityCapstone.lean` does not
  elaborate. The flattened Aristotle package omitted project-qualified import
  context; the unchanged live file compiled independently under the pinned
  project toolchain.

Outcome: integrated into
`FOUR_CHANNEL_CLASSIFICATION_REVIEW.md`, the Paper F program, and the two
guarded successor modules. Current publication verdict: a strong section is
earned; a standalone classification paper remains theorem-gated.
