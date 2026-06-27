# C19 Gate C release: force the flavored-chirality signs from the actual operator

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

C19 Gate C release job: force the flavored-chirality signs from the actual null-edge operator.

Primary files:
- PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
- PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean if present
- PhysicsSM/Draft/TetrahedralNodalStructure.lean if present
- PhysicsSM/Draft/TetrahedralBranchCount.lean if present
- docs/CONVENTIONS.md
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 23-25

Goal:
The current Gate C mechanism proves that a modeled flavor/taste sign T gives tr(Gamma_s P_null)=0 and tr(Gamma_f P_null)=4 on the null branches. This is promising but not yet a Gate C release. The missing proof is whether the actual flat tetrahedral null-edge operator forces the BCK/minimally-doubled aligned taste signs, rather than letting us choose them by hand.

Please attempt the strongest Lean result you can:
1. Identify the actual branch/taste data available in the current Lean files.
2. State a release criterion theorem tying the full operator's branch decomposition to the flavored chirality T.
3. If possible, prove that the actual branch signs give the existing release witness.
4. If not possible, produce a precise no-build blocker report explaining exactly what data/theorem is missing and what Lean statement should be added next.

Expected output:
- Prefer a new Lean module such as PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean.
- Include theorem names for the release criterion and for any conditional release theorem.
- If the actual sign forcing is not provable yet, return a minimal conditional theorem plus a report that says what future branch data would discharge the condition.

Do not claim Gate C is released unless the signs are forced by the operator data, not merely assigned by a model choice.
