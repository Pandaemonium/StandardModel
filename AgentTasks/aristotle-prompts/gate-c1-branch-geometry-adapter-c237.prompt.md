Gate C1 high-momentum branch geometry adapter, C237

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C232 proved a generic theorem:

```text
nullBranch_chiralIndex_zero:
  nonzero null covector p
  + idempotent gamma5-commuting projector P onto ker(cliffordSymbol p)
  -> chiralIndex gamma5 P = 0.
```

To specialize this to the actual high-momentum branch, we need geometry facts
for `branchP a`:

```text
branchP_ne_zero;
branchP_mink_zero.
```

C235 is still running as a broader branch-kernel proof package. This job is a
smaller adapter task: connect `TetrahedralHighMomentumNullBranch` to the generic
C232 theorem, or report the exact missing declarations.

Included live files:

```text
PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean
PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean
PhysicsSM/Draft/NullEdge/GateC1/BranchKernelChiralIndexZero.lean
```

Task:

1. Identify where `branchP`, `mink`, `pCov`, `threePi_null`, and
   nonzero-branch facts actually live.
2. State the minimal adapter lemmas needed:
   `branchP_mink_zero`, `branchP_ne_zero`, or their live equivalents.
3. If feasible, write a small bridge module specializing
   `nullBranch_chiralIndex_zero` to actual branch data.
4. If not feasible, return the exact missing declarations and proof package
   needed next.

Constraints:

- Do not fabricate branch geometry inline if it would diverge from the live
  C16/C18 branch classification.
- Preserve the actual gamma convention.
- Preserve the obstruction interpretation: zero chiral index, not release.

Requested output:

- dependency map;
- adapter lemma statements;
- bridge theorem if feasible;
- exact blockers if not;
- next local patch/proof package.
