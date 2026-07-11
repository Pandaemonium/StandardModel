# Aristotle audit: Paper F residual moduli and selector sufficiency

Perform a hostile mathematical and semantic audit of the newly landed Paper F
F1/F2 results. This is review-only: do not edit files and do not claim a build
of the live repository.

## Exact current claims

1. `ChannelShearModuli` exhibits a faithful additive determinant-one rational
   shear subgroup preserving the total of three ordered even channels and
   every linear type submodule. With a nonzero middle channel, distinct
   parameters give distinct ordered refinements before quotienting.
2. `ChannelSelectorUniqueness.two_sign_gradings_decomposition_unique` proves
   that two internal decompositions carrying the same pair of sign gradings
   with four distinct joint eigenvalues coincide.
3. The claimed intrinsic content of `CarrierRigidity` remains only the chosen
   exact word-source expansion and the canonical odd/even chirality split.
4. Coordinate readers in `FourChannelRigidityCapstone` are supplied selectors,
   not a derivation of intrinsic four-way canonicity.

## Audit questions

1. Are any of the two landed headlines vacuous, hollow, falsely shaped, or
   stronger in prose than in Lean? Name exact declarations and hypotheses.
2. Does the shear action genuinely preserve the fixed total with the matrix
   convention used, and does `mixed_shear_injective` prove a nondegenerate
   family rather than only a parameter identity?
3. Is the two-sign uniqueness theorem sufficient as stated, or does its use of
   scalar action on all components silently encode more than a grading?
4. State the exact full affine/torsor theorem that should replace the current
   one-subgroup witness. Give Lean-shaped definitions, hypotheses, action,
   freeness/transitivity statement, stabilizer, and quotient boundary.
5. Give a necessary-and-sufficient selector theorem, not merely a sufficient
   theorem, for uniqueness of an ordered four-channel refinement.
6. Audit the candidate intrinsic selectors: word/solder degree, edge exchange,
   locality, physical positivity, information monotonicity, and refinement
   naturality. Which can be defined without naming the desired channels?
7. Identify the smallest exact no-go theorem if no intrinsic second selector
   can be obtained from the current carrier data.
8. End with a publication verdict: `STANDALONE CLASSIFICATION`,
   `SECTION EARNED`, or `NOT YET A PAPER`, plus the three highest-value theorem
   submissions for the next six hours.

## Required output

- `FATAL`, `MAJOR`, `MINOR`, and `CLEAR` findings;
- exact safe replacement language for `exhaustive`, `canonical`, and `unique`;
- Lean-shaped F3 theorem statements with prohibited weakenings;
- a dependency DAG and a publication verdict.

```yaml
aristotle:
  project_id: d4dfeb30-0871-473c-b1ae-a4ea14bb4b31
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-channel-selector-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/d4dfeb30-0871-473c-b1ae-a4ea14bb4b31
  status: harvested
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Codex disposition

Accepted:

- the shear family is genuinely nondegenerate and total-preserving;
- column sums equal to one, not determinant one, are the total-preservation
  mechanism;
- common-submodule closure holds for arbitrary linear mixing and must not be
  advertised as a shear-specific selection principle;
- the two-sign theorem is a strong conditional simultaneous-eigenspace
  uniqueness theorem and does not construct an intrinsic second grading;
- the physical quotient, necessary-and-sufficient selector theorem, residual
  no-go, and abstract/concrete normalization bridge remain the standalone-paper
  gates.

Packaging findings about absent imported modules are rejected as properties of
the deliberately flattened review package: the unchanged live F2 and capstone
sources independently compile and are covered by the consolidated guard. The
documentation-drift finding was accepted; the generated design report now has
a prominent correction naming the actual integrated declarations.

During this audit, Codex independently landed the stronger
`ChannelRefinementTorsor` theorem, classifying the complete fixed-total
type-only fibre by zero-sum additive shifts. This supersedes the report's claim
that only a one-parameter sub-orbit was available. It does not close the
selector-preserving physical quotient.
