# D17 Scalar/gauge null quadrature and Higgs-gradient reconstruction

Type: Proof

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

D17 Scalar/gauge null quadrature theorem.

Primary files:
- PhysicsSM/Draft/TetrahedralNullGram.lean if present
- PhysicsSM/Draft/NullSolderFrameSimplex.lean if present
- PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean if present
- PhysicsSM/Draft/NullEdgeDualSolderedCommutator.lean if present
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 24-25

Goal:
Turn the scalar/gauge null-quadrature bridge into a kernel-checked theorem or a precise staged theorem.

Target identity:

  g^{-1}(xi,eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)

for the tetrahedral/null-solder frame, where G^{ab} is the inverse-Gram or reconstruction matrix used by the project.

Then formulate the finite Higgs-gradient reconstruction:

  g^{-1}(D H,D H)
    = or approximates sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>

in the purely finite/algebraic setting available now.

Tasks:
1. Identify the existing null-frame/inverse-Gram API and reuse it.
2. Prove the exact finite quadrature identity if the frame definitions are present.
3. State the gauge/Higgs version with a clean inner-product abstraction.
4. If the full gauge theorem is too much, prove the scalar bilinear identity and return the minimal hypotheses for the covariant version.

Expected output:
- Prefer PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean.
- Also include a note explaining how this theorem prevents the Higgs/W/Z story from being merely ordinary graph Higgs theory with null labels.
