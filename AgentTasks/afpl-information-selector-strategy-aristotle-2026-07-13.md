# Aristotle strategy-to-theorem job: information-natural channel selector

- Work item: `LAB-BOOTSTRAP-001` (classification-paper frontier)
- Role: Visionary / Assassin / Builder
- Priority: decomposition classification
- Date: 2026-07-13
- Aristotle project: `686f31b0-39c5-4997-a687-966f2394708c`

## Mission

Turn the non-unique four-channel decomposition into a rigorous selector
classification. Determine whether maximum Shannon entropy or minimum KL
divergence to a named uniform prior selects the equal-third point on the
three-channel fixed-total fibre, and state exactly in what sense that selector
is natural and in what sense the prior remains extra structure.

## Inputs to inspect

- `PhysicsSM/Draft/NullEdge/ChannelDecompositionModuliCapstone.lean`
- `PhysicsSM/Draft/NullEdge/ChannelQuadraticSelectorFamily.lean`
- `PhysicsSM/Draft/NullEdge/ChannelRefinementTorsor.lean`
- `PhysicsSM/Draft/NullEdge/FiniteUniformMaxEntropy.lean`
- active target
  `AgentTasks/aristotle-targets/afpl_s3_quadratic_selector_classification.lean`

## Required output

Return a decision memo and a typechecking Lean target skeleton for one of these
pre-registered outcomes:

1. **Positive relative selector:** on nonnegative normalized channel shares,
   the unique entropy maximizer/KL minimizer relative to the displayed uniform
   prior is equal thirds, and it coincides with every strictly transverse,
   fully permutation-symmetric quadratic selector.
2. **Sharper no-go:** no selector can be invariant under both the full
   zero-sum refinement translation and channel relabelling while remaining a
   section of every nontrivial fixed-total fibre.

The target must include the exact `(1/3,1/3,1/3)` point, the existing
`(6/11,3/11,2/11)` unequal-metric control, and a boundary showing why the
uniform prior or transverse metric is load-bearing. Give imports, missing
lemmas, and a 30/90/240-minute proof ladder.

## Kill and honesty conditions

- Do not report a prior-relative selector as an absolute physical
  decomposition.
- Do not restate the already-proved diagonal quadratic theorem or the active
  six-coefficient S3 classification.
- If full refinement-translation invariance makes any section impossible,
  state the no-go cleanly instead of weakening the symmetry silently.
- Do not claim carrier dynamics, locality, or information theory uniquely
  supplies the prior unless a theorem actually derives it.

The result should be ready for immediate proof-job packaging.

## Integration record - 2026-07-13

- Status: integrated after independent Claude-family semantic review.
- Review: `AutonomousLab/reviews/CLAUDE_REVIEW_ChannelInformationSelectorClassification_2026-07-13.md`
  (`ACCEPT`).
- Integrated file:
  `PhysicsSM/Draft/NullEdge/ChannelInformationSelectorClassification.lean`.
- The returned `OvernightTheoryAxiomGuard.lean` was deliberately not copied:
  its dry-run diff was stale and would have deleted 87 lines from the live
  aggregate guard.  The reviewed module's own seven build-enforced guard blocks
  were retained, and the live aggregate imports the module.
- Verification actually run:
  `lake env lean PhysicsSM/Draft/NullEdge/ChannelInformationSelectorClassification.lean`
  and
  `lake build PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification`.
  Both passed; only two non-blocking unused-simp-argument lints remain.
- Claim boundary: maximum entropy/minimum KL selects equal thirds only relative
  to the named uniform prior.  Symmetry plus uniqueness already forces the same
  barycenter, and the explicit skew prior moves the selected point.
