# C43/C44 spectral-graph nodal classification -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 6a90c8ad-8726-4934-9e8b-cec747480d71
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

## C43/C44 deliverable: spectral-graph nodal classification for Gate C Route B

I read the included Gate C modules (`TetrahedralHighMomentumNullBranch`, `NullEdgeFlavoredChirality`, `NullEdgeGateCReleaseCriterion`, `NullEdgeBranchKreinSignatures`) and the working-plan §29 / backlog C43–C44 notes, then implemented a new, self-contained module classifying the determinant-zero / nodal set of the flat tetrahedral null-edge symbol.

### New module: `PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean`
Builds cleanly, **no `sorry`**, all theorems depend only on the standard axioms `propext, Classical.choice, Quot.sound`. It depends only on the two clean existing modules — **not on C21**, and it does **not** assume bare `OperatorForcesAlignment`. (It avoids the pre-existing broken import in `NullEdgeBranchKreinSignatures`, which references a file absent from the project; I left that file untouched.)

Key results (all proven), built on the existing scalar `qform = p(q)²`:
- `qform_one_zero_three_equal`: the nodal cancellation mechanism — if one edge of `u` is `0` and the other three are equal, then `p(q)² = 0` (since `(3v)² = 3·(3v²)`).
- `branchLine_pSq_eq_zero` (**main target**): for each high branch `a`, the line `q_a = 0`, `q_b = π + t` (`b ≠ a`) has `p(q)² = 0` for **all** `t`; `branchLine_mink_eq_zero` gives the same for the explicit mostly-minus Minkowski square.
- `threePiBranch_on_branchLine`: the `t = 0` point is the three-`π` high corner.
- `origin_on_branchLine`: the `t = π` point of every branch line is the origin `u = 0`.
- `branchLine_corner_ne_origin` / `branchLine_extended`: each curve carries two distinct null points, so the high branch is **not** isolated.
- `null_corner_on_some_branchLine`: every `{0,π}^4` null corner lies on one of the four branch lines, linking the discrete corner table to the continuous curves.
- `nodal_classification_summary`: packaged statement.

### Verdict (also written as a report)
The determinant zeros form **extended nodal curves, not isolated species**: the four high branches are `t = 0` endpoints of exact one-dimensional determinant-zero curves connecting each three-`π` corner to the origin at `t = π`. Consequently minimally-doubled species-count language on the bare symbol is not justified without a **branch-control / species-splitting term** (e.g. the `T_lin = ½ Σ_a s_a cos q_a` proposal, which vanishes at the origin). These are certified nodal *components*; whether they exhaust the full zero locus is left explicitly **unresolved** (dimension counting suggests the full complex equation cuts out a higher-dimensional sheet) — flagged, not asserted.

The report `AgentTasks/null-edge-spectral-graph-nodal-classification-plan.md` records the method (Yumoto–Misumi spectral-graph viewpoint as strategy), the proven theorems, the Gate C verdict, the honest unresolved scope, and a proof plan with the missing operator-level definitions (`cliffordSymbol`, `Msplit`) needed for the follow-on kernel/chirality and species-splitting targets.
