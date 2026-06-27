# C20 Massive branch lifting audit for det(iD_+ + Gamma_s Phi_H)

Type: Proof/Audit

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

C20 Massive branch lifting audit.

Primary files:
- PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
- PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean if present
- PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean
- PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 23-25

Goal:
Gate C currently classifies massless determinant-level null branches. The next physical test is whether a constant scalar or matrix Phi_H mass block lifts, preserves, or destabilizes the high-momentum determinant-zero branches.

Analyze and, if feasible, formalize the finite branch test:

  det(i D_+(q) + Gamma_s Phi_H) = 0

for the high-symmetry branch data already present in Lean, especially the three-pi branch family and the warning point analogous to q=(pi,pi,pi,0).

Tasks:
1. State a clean finite algebra theorem for constant scalar mass m: when does a nonzero null Clifford symbol branch remain singular after adding Gamma_s*m?
2. If the existing Clifford model supports it, prove the branch is lifted for m != 0, or prove the exact condition under which it is not lifted.
3. Extend or sketch the matrix Phi_H case with the Gate A convention: Phi_H commutes with Gamma_s but is odd under chi_E.
4. Return a classification table: lifted, preserved, complex/unstable, or not decidable from current data.

Expected output:
- Prefer a Lean module PhysicsSM/Draft/NullEdgeMassiveBranchLifting.lean for the algebraic parts.
- Also return AgentTasks/null-edge-massive-branch-lifting-audit.md explaining what remains before massive Gate C can be released.

Do not assume that adding Phi_H automatically cures the branch. Prove it or label it open.
