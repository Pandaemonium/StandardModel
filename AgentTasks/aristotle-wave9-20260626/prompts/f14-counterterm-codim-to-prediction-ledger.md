# F14 Forbidden counterterm codimension to prediction ledger bridge

Type: Prediction/Audit/Proof

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

F14 Forbidden counterterm codimension to prediction ledger bridge.

Primary files:
- PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean
- PhysicsSM/Draft/NullEdgeInternalSpectrum.lean
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 22, 23, 25
- AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md

Goal:
Wave 8 proved a strong structural theorem: chi_E-odd implies vanishing diagonal blocks, so same-Weyl bare mass is unrepresentable, with codimension (card L)^2 + (card R)^2. Determine whether this is already a real Gate F codimension result or only an internal consistency statement.

Tasks:
1. Audit the theorem semantically: what exact finite parameter space is being reduced?
2. Connect the theorem to the Gate F rule: prediction requires rank(dF) < dim M_EFT or a forced relation R(theta_EFT)=0.
3. If feasible, prove a small abstract Lean theorem saying that forbidding diagonal blocks cuts the full block matrix space by the stated codimension.
4. Identify which Standard Model/EFT counterterms this corresponds to and which it does not.
5. Decide whether this can be advertised as a first structural prediction, a consistency theorem, or a reconstruction constraint.

Expected output:
- Prefer a report AgentTasks/null-edge-forbidden-counterterm-prediction-ledger.md.
- Include optional Lean patch only if there is a clean theorem missing from NullEdgeForbiddenCountertermCodim.lean.
- Be adversarial: if the codimension is already built into the choice of chi_E-odd Phi_H, say so.
