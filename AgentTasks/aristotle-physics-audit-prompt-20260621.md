# Aristotle prompt: null-edge physics/semantics audit

This is an audit and documentation job, not a proof-completion job.

Do not build the whole repository. Do not fill proof bodies. Do not change
definitions, theorem statements, imports, namespaces, proof terms, or executable
code behavior.

Read the complete research goal in:

```text
Sources/Null_Edge_Causal_Graph_Strengthened_Program.md
```

Also read:

```text
Sources/Null_Edge_Causal_Graph_Research_Plan.md
AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md
```

Audit the null-edge theorem surface in the Lean repo, prioritizing:

```text
PhysicsSM/Spinor/PluckerMass.lean
PhysicsSM/Gauge/CausalDiamondHolonomy.lean
PhysicsSM/Draft/TwistorPluckerMass.lean
PhysicsSM/Draft/NullEdgeDiracSlashCore.lean
PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean
PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean
PhysicsSM/Draft/NullEdgeSuperconnectionExpansionCore.lean
PhysicsSM/Draft/NullEdgeCovariantDifferentialCore.lean
PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean
PhysicsSM/Draft/NullEdgeQubitConcurrence.lean
PhysicsSM/Draft/NullEdgePathPairInterchange.lean
PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
PhysicsSM/Draft/NullEdgeGramWeightedOperator.lean
PhysicsSM/Draft/NullEdgeGramWeightedHermitian.lean
```

For each important definition, theorem statement, abbreviation, and convention
wrapper you inspect, give a confidence score from 1 to 10:

- `10`: statement precisely matches the intended physics/mathematics and
  conventions are explicit;
- `7-9`: statement is likely aligned, but needs clearer comments or minor
  convention clarification;
- `4-6`: useful formal algebra, but the physics interpretation is partial,
  overloaded, or missing hypotheses;
- `1-3`: likely convention-mismatched, underspecified, misleading, or too weak
  to support the associated program claim.

For every score below 8, explain:

- what physics claim the statement appears to be supporting;
- what is missing or ambiguous;
- the smallest comment, convention note, or statement revision that would make
  it safer.

You may edit permanent Lean files only to add or improve module docstrings,
declaration docstrings, and explanatory comments. Do not modify theorem
statements or proofs. In comments and docstrings, avoid raw Lean placeholder or
escape-hatch tokens; use spaced or descriptive wording instead. Keep comments
ASCII-only.

Return:

1. An audit table grouped by module.
2. A list of the highest-risk mismatches.
3. A list of the best-aligned theorem clusters.
4. Any comment/docstring-only patches you made.
5. A recommended next audit or proof job.

If the package is too large to audit fully, prioritize the listed modules and
say what you did not inspect.
