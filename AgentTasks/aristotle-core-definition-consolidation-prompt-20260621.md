# Prompt for Aristotle: null-edge core definition consolidation

You are being asked to do theorem-planning and API design, not to fill a
proof hole.

## Hard instruction: do not build

Do not run `lake build`, `lake env lean`, or any Lean compile command. The
purpose of this run is to design the clean `PhysicsSM/NullEdge/Core` layer that
future proof jobs should target.

## Context to read first

Read:

```text
AgentTasks/context-packs/null-edge-core-definition-consolidation-20260621-173119.md
Sources/Null_Edge_Causal_Graph_Strengthened_Program.md
Sources/Null_Edge_Causal_Graph_Research_Plan.md
PhysicsSM/Spinor/PluckerMass.lean
PhysicsSM/Draft/NullEdgeDiracSlashCore.lean
PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean
PhysicsSM/Draft/NullEdgeGenerationBlindnessCore.lean
PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
```

## Goal

Return a Markdown design artifact named:

```text
null-edge-core-definition-consolidation-output.md
```

The output should propose the canonical API for:

- `VisibleSpinor`;
- `rankOneHermitian`;
- `spinorWedge`;
- finite bundle momentum;
- complex and real Pluecker mass;
- determinant-as-nonnegative-real wrapper;
- Weyl-coordinate extraction;
- Dirac slash/Weyl blocks;
- generation-blindness and hidden Gram data boundaries.

## Questions to answer

1. What module tree should replace duplicated draft definitions?
2. Which definitions should live in trusted `PhysicsSM/NullEdge/Core`, and
   which should remain draft?
3. Which existing theorem islands can migrate unchanged, and which need
   convention bridges?
4. What theorem statements should be the next focused Aristotle proof jobs?
5. What statement risks should be guarded before future submissions?

Be ambitious but conservative. Do not claim a theorem is proved unless the
supplied context already proves it. Optional Lean-like skeletons are welcome,
but label them as sketches, not final code.
