# B17 Post-Gate-A finite dual-soldered Lichnerowicz square

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

B17 Post-Gate-A finite square theorem.

Primary files:
- PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean
- PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean
- PhysicsSM/Draft/NullEdgeSuperconnectionExpansionCore.lean
- PhysicsSM/Draft/NullEdgeSuperDiracDiamondCurvature.lean if present
- PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean if present
- PhysicsSM/Draft/NullEdgeDualSolderedCommutator.lean if present
- docs/CONVENTIONS.md

Goal:
Use the now-integrated Gate A bridge to prove or sharply stage the finite dual-soldered null-edge generalized Lichnerowicz formula.

Target shape:

  D_N = sum_a C_a nabla_a
  D_N^2 = K_null + C_diamond + T_frame

with

  K_null     = 1/4 sum_{a,b} {C_a,C_b}{nabla_a,nabla_b}
  C_diamond = 1/4 sum_{a,b} [C_a,C_b][nabla_a,nabla_b]
  T_frame   = sum_{a,b} C_a [nabla_a,C_b] nabla_b

Then combine with Gate A for

  D = i D_N + Gamma_s Phi_H

and the sign convention

  D^2 = -K_null - C_diamond - T_frame + Phi_H^2
        - i Gamma_s sum_a C_a [nabla_a,Phi_H]

up to the exact sign conventions already present in Lean. If the existing files use a different normalization, do not silently change it. State the convention map.

Tasks:
1. Search the current repo for existing definitions of K_null, C_diamond, T_frame, or equivalent names.
2. Prefer reusing existing definitions rather than adding parallel APIs.
3. Prove the pure algebraic decomposition in the most general associative ring/matrix context feasible.
4. Connect it to the Gate A sign bridge as a named theorem.
5. If the full theorem cannot be proven because definitions are missing, return a draft module with precise conditional hypotheses and a report naming the missing definitions.

Expected output:
- Prefer PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean.
- Include a short report describing how this theorem should feed P2.
