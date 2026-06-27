# M14: P1 crosswalk patches A-F final application audit

    Type: manuscript/audit

    ## Task prompt

    You are Aristotle. This is a manuscript/audit job, not a proof job.

Context:
M12 and M13 both report that P1 manuscript patches A-F remain recommendations, not applied edits. The repeated issue is that the absent `PhysicsSM.Spinor.TwistorPluckerMass` module is still over-marked as trusted/re-verified in prose, while the bannered Plucker obstruction/covariance files should be upgraded accurately. The user has been letting another agent integrate jobs, so we want an exact final check.

Your task:
1. Inspect the current manuscript, publication plan, and M12/M13 reports.
2. Determine whether Patches A-F are still needed exactly as written, or whether Claude has already applied any of them.
3. Produce a final minimal patch audit:
   - mandatory release-blocking edits;
   - optional clarity upgrades;
   - exact replacement text or unified diff hunks;
   - files affected.
4. Do not rewrite the manuscript broadly.
5. Preserve the safe P1 thesis: finite kinematic Plucker/null-spread obstruction, not all mass mechanisms or continuum dynamics.

Deliverable:
`AgentTasks/null-edge-p1-crosswalk-final-application-audit.md`.

Do not apply the patch; this job should produce a ready-to-apply audit for Codex/Claude/user approval.

    ## Included context files

- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `AgentTasks/null-edge-p1-crosswalk-patches-a-f-ready.md`
- `AgentTasks/null-edge-m12-p1-release-clean-crosswalk-patch.md`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
