# Aristotle job C262: Gate C1 branch-retention audit

This is a non-blocking audit job for the PhysicsSM null-edge Gate C1 program. Codex is currently assembling the finite/free operator locally; do not wait on that.

Context:
- The current free symbol is K(k) = a^{-1}(i Q(sin k) + m(k) I), with m(k)=r sum_A (1-cos k_A)-rho.
- Scalar Wilson is no longer being used as a direct chiral release. It is only the branch-mass term inside the Hermitian overlap kernel.
- We need to know whether scalar Wilson in the first band is enough for one-branch retention for the overlap construction, or whether a flavored/matrix Wilson term is likely required.

Please read the included Gate C1 symbol files and produce a Markdown report named:

GateC1_BranchRetention_Audit.md

Answer:
1. What is the exact finite branch-retention theorem we should state after the Hfree gap theorem?
2. Does the existing uniform scalar gap prove enough to separate the physical branch from all mirror/doubler branches for overlap purposes, or only enough to define sign(H)?
3. What additional low-momentum expansion theorem is needed to prove the retained branch has the right Weyl/Dirac continuum symbol?
4. If scalar Wilson is insufficient, what is the minimal matrix/flavored Wilson escape hatch that preserves gauge safety and the tetrahedral/null-edge interpretation?
5. Give 3 near-Lean theorem statements and the files where they should live.

Be blunt about whether scalar Wilson is enough for branch retention. Do not revive scalar Wilson as direct chiral selection at the origin.
