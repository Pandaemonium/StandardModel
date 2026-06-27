# M12 P1 release-clean crosswalk patch (report-only)

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run d05908c7-1a67-464b-9a89-4df8261ae039
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

Delivered the M12 P1 release-clean crosswalk patch as the report `AgentTasks/null-edge-m12-p1-release-clean-crosswalk-patch.md`. No theorem statements were altered and no Lean code was changed; per the task ("produce patch text but do not require applying it"), the manuscript/plan edits are provided as exact replacement blocks for a human/Codex integration pass rather than auto-applied.

Key verified finding (checked against the live tree): the Lean convention/provenance banners DID land in both `PhysicsSM/Spinor/PluckerObstruction.lean` and `PhysicsSM/Spinor/PluckerMassCovariance.lean` (metric, spinor, det-mass normalization, `actSpinor` action, SL(2,C) det=1, twistor-separate disclaimer, and the one residual SL(2,C)→SO+(1,3) covering-map gap). However, the manuscript `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` and `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` are still in their pre-correction overclaiming state — the prose corrections the prior Wave-8/9 notes reported as "applied" were never written into those files. So the recommended patch still needs to be made.

The report contains:
- Task 1: seven exact locations (O1–O7, with line numbers) that overclaim trusted Lean status for the absent `PhysicsSM.Spinor.TwistorPluckerMass` module (header anchors, provenance sentence, §8, §11, two §12 rows, and the publication-plan "Banked Lean" paragraph).
- Task 2: seven corrections (U1–U7) upgrading the now-bannered SL(2,C) covariance and the masslessness-obstruction interface from draft to trusted, including the `spinorAction`→`actSpinor` name fix and new §12 rows backed by the verified declarations in the two Spinor files.
- Task 3: six unified-diff-style patch blocks (Patches A–F) with exact replacement text for the manuscript header/provenance, §7, §8, §11, the §12 table+footnotes, and the publication-plan paragraph.
- Task 4: verdict — P1 is "release-clean after the convention-banner rebuild," not "release-clean now." No missing theorem blocks the P1 headline; the two remaining blockers are (a) full-repo `lake env lean` rebuild + `#print axioms` of the two bannered Spinor modules (not rebuildable in this focused snapshot because the imported base `PhysicsSM.Spinor.PluckerMass` is unvendored), and (b) the twistor downgrade. The twistor module remains absent in this tree.
- Strict claim labels (trusted / draft / reported / absent / conceptual / future) used throughout, plus acceptance/failure criteria, prioritized next Lean targets, and axiom/convention notes.
