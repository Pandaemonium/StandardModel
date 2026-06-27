# M11 P1/P1.5 release crosswalk after Wave 8

Type: Manuscript/Audit

Context for all Wave 9 jobs, 2026-06-26.

Repository: C:\Projects\StandardModel, Lean 4 / Mathlib project. Follow AGENTS.md and docs/ARISTOTLE.md. The Lean kernel is the source of truth. Do not weaken theorem statements to get a proof. If a statement is false or convention-mismatched, return a precise blocker and proposed corrected statement.

Recent Wave 8 integration summary from Claude:
- Gate A bridge exists in PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean. It ties "Phi_H is chi_E-odd, Gamma_s-even" to the super-Dirac square having +Phi_H^2. It also gives a concrete realization proving gammaS != chiE and a nonzero +1 versus -1 witness.
- Gate C flavored-chirality index exists in PhysicsSM/Draft/NullEdgeFlavoredChirality.lean. It defines Gamma_f = Gamma_s * T and proves a release witness tr(Gamma_s P_null)=0 but tr(Gamma_f P_null)=4 on the proven threePi_null branches.
- Trusted Spinor files PhysicsSM/Spinor/PluckerObstruction.lean and PhysicsSM/Spinor/PluckerMassCovariance.lean now prove B_Pl = Re(det mass), vanishing exactly on the collinear locus, plus SL(2,C) invariance of wedge, B_Pl, det-mass, and the massless locus. They are kernel-clean but still need machine-checkable convention banners before manuscript citation as trusted.
- PhysicsSM/Draft/NullEdgeInternalSpectrum.lean gives an internal-spectrum API plus anomaly-inheritance wrappers over the one-generation table, with Furey treated as one realization rather than an assumption.
- PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean proves chi_E-odd implies vanishing diagonal blocks and same-Weyl bare mass unrepresentable; forbidden_counterterm_codimension = codim (card L)^2 + (card R)^2.
- M10 audit flags that the P1 manuscript over-marks some twistor rows as trusted when those modules are not present.

Current interpretation:
- Gate A is bridged but should be used immediately to anchor the finite square and kinetic normalization.
- Gate C now has a mechanism but is not released: the remaining blocker is whether the full operator forces the modeled chirality/taste signs.
- P1 trusted Spinor promotion is mathematically strong but convention-banner and manuscript-crosswalk cleanup remain.
- Prediction language remains off unless codimension or a forced EFT relation survives the parameter ledger.

General deliverable rule:
- For proof jobs, return a Lean patch or new module plus a short semantic-alignment note.
- For audit/strategy jobs, return a concise but deep report with explicit acceptance/failure criteria and next Lean targets.
- Report any theorem that depends on classical axioms or project conventions. Avoid hidden assumptions.

---

M11 P1/P1.5 release crosswalk after Wave 8.

Primary files:
- Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md
- Sources/Null_Edge_Causal_Graph_Publication_Plan.md
- PhysicsSM/Spinor/PluckerObstruction.lean
- PhysicsSM/Spinor/PluckerMassCovariance.lean
- PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean
- PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
- PhysicsSM/Draft/NullEdgeInternalSpectrum.lean
- PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean

Goal:
Produce a publication-facing release crosswalk after Wave 8. The main question is what P1 can now safely claim, what P1.5 can claim, and what remains P2/Gate C/Gate F.

Tasks:
1. Build a theorem-to-manuscript table with labels: trusted, draft, audit, conceptual, future, or not present.
2. Correct the twistor rows that M10 flagged as over-marked trusted if the relevant modules are absent.
3. Decide how the new Plucker trusted files change P1 readiness.
4. Decide whether Gate A bridge belongs in P1 appendix, P1.5, or P2.
5. Decide how much of the flavored-chirality result can be mentioned without claiming Gate C release.
6. Return exact manuscript edits or a patch plan.

Expected output:
- AgentTasks/null-edge-p1-p15-release-crosswalk-after-wave8.md.
- A short release recommendation: ship P1 now, ship after convention banners, or hold for specific missing theorem.

Keep claim boundaries conservative. Strong finite theorem claims are good; prediction or full unification claims remain gated.
