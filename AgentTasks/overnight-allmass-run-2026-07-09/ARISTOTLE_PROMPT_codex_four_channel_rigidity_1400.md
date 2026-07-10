# codex four-channel rigidity, 2026-07-09 14:00

aristotle:
  project_id: c4b8c4e6-bc96-4e4c-9dbb-cb113c876ca6
  target_file: PhysicsSM/Draft/NullEdge/FourChannelRigidityCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.FourChannelRigidityCapstone
  submission_project: AgentTasks/aristotle-submit/codex-impact-wave-1400-20260709-project
  output_dir: AgentTasks/aristotle-output/c4b8c4e6-bc96-4e4c-9dbb-cb113c876ca6
  status: integrated from in-progress snapshot 2026-07-09 15:08 PDT

You are Aristotle. Prove the strongest honest concrete rigidity theorem for
the landed four-channel mass square.

Target:

```text
PhysicsSM/Draft/NullEdge/FourChannelRigidityCapstone.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.UnifiedMassBudget
import PhysicsSM.Draft.NullEdge.CarrierRigidity
import PhysicsSM.Draft.NullEdge.GradedDecompUniqueness
```

Context pack:

```text
AgentTasks/context-packs/carrier-four-channel-rigidity-20260709-135737.md
```

Key simplification: work first with the explicit rational matrices
`UnifiedMassBudget.QA`, `QC`, `QT`, and `Es`. Their supports expose rational
coordinate functionals. Define

```lean
channelCombination a c t e := a • QA + c • QC + t • QT + e • Es
```

and coordinate readers using entries such as `(0,0)`, `(1,1)`, `(3,3)`, and
`(0,2)`, with the correct normalizations from the concrete matrices.

Required payload:

1. Prove each coordinate reader recovers its coefficient from
   `channelCombination`.
2. Prove the four explicit channel matrices are linearly independent over the
   rationals, preferably both as injectivity of `channelCombination` and as a
   `LinearIndependent` theorem if the API is convenient.
3. Prove uniqueness: any two four-channel presentations of the same matrix
   have identical coefficients.
4. Specialize uniqueness to `UnifiedMassBudget.square_splits`, showing its
   concrete four coefficients are recovered from the carrier square itself.
5. Bundle the positive theorem with the honest negative boundary already in
   `CarrierRigidity.Concrete.shared_type_but_distinct` and
   `NullEdgeCloser.split_not_forced`: concrete coordinate/support data make
   this split rigid, while chirality/Krein type alone does not.

Preferred names:

```lean
channelCombination
readA
readC
readT
readE
channel_coordinates_recover
channelCombination_injective
four_channels_linearIndependent
four_channel_coefficients_unique
carrier_square_coefficients_recovered
four_channel_rigidity_with_boundary
```

Do not claim an abstract canonical four-channel split for every carrier. This
theorem is about the explicit rational witness and the added support/coordinate
selector. Add footprint guard pins and run targeted checks.

## Harvest note, 2026-07-09 15:08 PDT

Codex downloaded the one-hour in-progress snapshot. All requested declarations
were present, but the coordinate-recovery proof left the `(3,3)` and `(0,2)`
matrix-entry reductions unsolved on the pinned toolchain. Replacing the brittle
restricted simplifier with `simp +decide` closed both exact rational goals. The
repaired file passed `lake env lean`, was copied into the live tree, and was
imported by `PhysicsSMDraft.lean`. The remote job was canceled after the local
objective was achieved.
