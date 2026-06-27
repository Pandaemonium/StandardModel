# C22 branch projectors and Krein signatures -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run ae1f310f-93b7-4cbb-8ccd-4c555fe43d8c
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

## C22: Branch projectors and Krein signatures — delivered

Added a new `sorry`-free module `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean` (registered in `PhysicsSMDraft.lean`) plus a report `AgentTasks/null-edge-c22-branch-projectors-krein-report.md`. The module builds under the pinned toolchain; all results depend only on the standard axioms `propext, Classical.choice, Quot.sound`.

**Verdict: CONDITIONAL.** A complete finite branch-projector + Krein-signature package is delivered for the *modeled* gradings of the existing Wave-8 finite model (`GammaS`, `kreinJ`). It is conditional because the actual flat tetrahedral 4×4 Clifford symbol, its per-branch kernels, and the chirality/Krein eigenvalues on those kernels are not formalized anywhere in the current tree (only the scalar quadratic form and its null corners are). Promotion to a *forced* Gate C statement is PENDING on C21 supplying the actual operator eigenspaces.

**Proved (per task), reusing the existing `Pbranch`/`GammaFlavOp`/`kreinJ`/`g5` rather than duplicating them:**
1. Branch-projector algebra: idempotence (`Pbranch_idem`), mutual orthogonality (`Pbranch_orthogonal`), symmetry (`Pbranch_symm`), rank one (`Pbranch_trace = 1`), and completeness over the branch sector (`Pbranch_completeness`: `∑_a P_a = P_null`).
2. Projector-based flavored chirality `Γ_f = Σ_ρ ε_ρ P_ρ Γ_s P_ρ` reused with the per-branch reduction `P_a Γ_s P_a = g5 a • P_a`.
3. Connection to the C19 index criterion: `branchChirality a := tr(Γ_s P_a) = g5 a`, hence `tr(GammaFlavOp s · P_null) = Σ_a s a · branchChirality a`.
4. Branch Krein signatures (for the modeled `kreinJ`): `branchKreinSig a := tr(J P_a) = (-1)^a`, pattern `(+,-,+,-)`; the branch sector is Krein-indefinite with signature `(2,2)` (signatures sum to zero) and Krein-negative branch modes exist. Both proved and explicitly flagged as computed against modeled (not operator-forced) gradings.
5. Overclaim guards: the Krein pattern `(+,-,+,-)` differs from the chirality pattern `(+,+,-,-)` (`kreinSig_ne_chirality`), so chirality alignment does not entail Krein positivity; even with aligned branch chirality the modeled release is not Krein-positive (`modeled_release_not_kreinPositive`); and a re-export of the existing finite counterexample shows Krein J-self-adjointness alone does not imply spectral stability (`branch_krein_no_stability_guard`).

The honest residual obligation is recorded as the `Prop` predicate `ReleasesKreinPositive` (alongside the existing `OperatorForcesAlignment`) — stated, not assumed — together with explicit acceptance criteria for what C21 must supply to upgrade the verdict to RELEASED, and the failure modes (higher-dimensional kernels, extended/complex branch loci, non-`±g5` signs, or Krein-negative physical modes) to report if the actual symbol disagrees. No axioms or `@[implemented_by]` were introduced.
