# K2: Krein-positive physical-sector release criterion after C22

    Type: proof/strategy

    ## Task prompt

    You are Aristotle. This is a follow-on job to the integrated C22 branch Krein-signature module.

Context:
C22 proved branch projectors, modeled branch chirality, and modeled Krein signatures. It also proved the honest warning facts:

- the modeled Krein pattern (+,-,+,-) differs from the chirality pattern (+,+,-,-),
- aligned chirality does not imply Krein positivity,
- J-self-adjointness alone does not guarantee spectral stability.

The remaining Gate C safety predicate is `ReleasesKreinPositive`, currently a residual obligation.

Your task:
1. Inspect the included C22/Gate C files.
2. Propose and, if feasible, implement a Lean draft module that gives a useful sufficient condition for `ReleasesKreinPositive`.
3. The target should not assert positivity of all modeled branches, since C22 already shows that is false. Instead, formulate a physical-sector selector, branch lift, quotient, or projection condition under which the surviving physical modes are Krein-positive.
4. Make the relationship to species splitting explicit: which branches are lifted, projected, paired, or retained?
5. If implementation is not feasible, write the exact theorem statements and explain the missing definitions.

Possible output:
`PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`

Acceptance:
A good result is a precise conditional theorem, not a false positivity claim. It should sharpen the release condition and make clear why C22's negative branches are not being swept under the rug.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeFlavoredChirality.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
