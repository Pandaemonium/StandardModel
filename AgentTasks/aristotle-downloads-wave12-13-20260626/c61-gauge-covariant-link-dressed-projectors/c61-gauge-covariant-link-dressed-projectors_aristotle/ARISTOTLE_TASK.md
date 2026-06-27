# C61: Gauge-covariant link-dressed branch projector theorem plan

    Type: strategy/proof-api

    ## Task prompt

    You are Aristotle. This is a Gate C gauge-covariance strategy/API job.

Context:
The free-field Route B projectors use trigonometric filters such as products of `(1 +/- cos q_a)/2`, corresponding to finite combinations of forward/backward null-edge shifts. To be physically meaningful after gauge coupling, these must become link-dressed finite-range covariant projectors or composite fields. C47/C48 makes ghost-zero safety mandatory.

Your task:
1. Design a Lean-facing API for link-dressed branch projectors on a finite graph with gauge link variables.
2. State the transformation law that makes the projector gauge-covariant or gauge-invariant as appropriate.
3. Separate three contexts:
   - strictly retarded causal update block;
   - retarded/advanced Krein spectral double;
   - gauge-invariant composite/interpolating observable.
4. Identify which finite shift combinations are acceptable in each context.
5. If feasible, implement a small draft module skeleton with definitions and easy algebraic lemmas. Otherwise produce a detailed report.
6. Tie the output to GhostZeroSafe: gauge covariance alone is not ghost safety.

Preferred outputs:
- `AgentTasks/null-edge-gauge-covariant-branch-projectors-plan.md`
- optional `PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean`

Do not claim the free-field projectors remain physical after gauge coupling without link dressing and ghost audit.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`
- `PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean`
- `PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md`
- `AgentTasks/null-edge-weber-flavored-qcd-splitting-audit.md`
