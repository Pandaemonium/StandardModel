# M13 P1 crosswalk patches A-F (report-only, manuscript patch plan)

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 2580dce3-11aa-4b48-9091-dbb31648a1fe
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

Produced the review-ready P1 crosswalk patch plan at `AgentTasks/null-edge-p1-crosswalk-patches-a-f-ready.md`. No manuscript files were edited — this is a recommendation, as the manuscript is user-owned.

What I did:
1. Inspected the full P1 manuscript (`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`, 815 lines), the working plan, and the Wave 10 ledger.
2. Reconstructed the M12 patch set directly from the current manuscript text plus the ledger findings (the standalone M12 report itself is not bundled in the project, so the plan flags reconstructed details explicitly). The plan operationalizes the two M12 crosswalk facts: the i7 convention banners landed on the trusted `PhysicsSM.Spinor` surface, while `PhysicsSM.Spinor.TwistorPluckerMass` is treated as a present/trusted/kernel-verified module but is actually absent.
3. Enumerated the seven overclaim locations (O1-O7) — header anchors, provenance paragraph, Section 8 attribution, Section 11 "established (kernel-checked)" list, and two Section 12 map rows — all of which mark the absent twistor module as `trusted`/`re-verified`. These are the mandatory, release-blocking fixes.
4. Distinguished them from optional clarity upgrades (U1-U7) enabled by the banner rebuild, flagging U1 (`spinorAction` → `actSpinor`, a wrong Lean identifier) as a correctness fix that should be treated as mandatory.
5. Gave six minimal patch hunks (Patches A-F), each with verbatim current text and exact replacement text, that demote the twistor wrapper from `trusted` to `pending` everywhere and fix the identifier — without deleting any content (the twistor statements, normalization notes, and out-of-scope lists are kept). Added an application-order section, a post-apply verification checklist, and a note to apply the analogous downgrade to the (not-bundled) publication plan.

The plan preserves the safe thesis throughout: P1 remains a finite kinematic Plucker obstruction / origin-of-mass accounting paper (trusted Sections 1-6 untouched), not a claim to all mass mechanisms or continuum dynamics. Verdict matches M12: P1 is release-clean after the convention-banner rebuild, not release-clean now.
