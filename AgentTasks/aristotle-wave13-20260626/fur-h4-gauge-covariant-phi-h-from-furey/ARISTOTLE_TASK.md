# FUR-H4: Gauge-covariant Phi_H : J -> J* with chi_E oddness

    Type: proof/strategy

    ## Task prompt

    You are Aristotle. This is the lynchpin Furey/null-edge bridge job.

Context:
The null-edge Gate A square has the shape

  D = i D_N tensor 1 + Gamma_s tensor Phi_H,

where `Phi_H` is `chi_E`-odd and `Gamma_s`-even, and its square appears with the correct `+Phi_H^2` sign. So far `Phi_H` is abstract/free. Claude's analysis says Furey/Baez/DVT should supply the internal finite spectral-triple half. The key theorem is to define a gauge-covariant finite internal Dirac/Yukawa map

  Phi_H : J -> J*

or the correct all-left/Dirac-basis equivalent.

Task:
1. Inspect the Furey electroweak/weak-isospin modules and null-edge checkerboard/sign modules.
2. Identify the correct domain/codomain: `J -> J*`, left/right subspaces, or all-left conjugate basis.
3. State and, if feasible, implement a candidate `Phi_H` interface in `PhysicsSM/Draft/NullEdgeFureyPhiH.lean`.
4. Prove the highest feasible subset:
   - gauge covariance or commutation with the derived gauge action;
   - `chi_E` oddness;
   - `Gamma_s` compatibility required for the `+Phi_H^2` sign;
   - legal Yukawa pairing relation to `NullEdgeYukawaCheckerboard`.
5. If actual construction is premature, produce a precise API and proof plan.

Guardrails:
- This does not derive Yukawa eigenvalues.
- Do not collapse the all-left anomaly basis with the physical Dirac L/R basis.
- Do not introduce new axioms or fake assumptions.

This is the most important job of this wave.

    ## Included context files

- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `PhysicsSM/Algebra/Furey/JbarActionTable.lean`
- `PhysicsSM/Algebra/Furey/ElectroweakBridge.lean`
- `PhysicsSM/Algebra/Furey/ElectroweakCompletePackage.lean`
- `PhysicsSM/Algebra/Furey/WeakIsospinDoublets.lean`
- `PhysicsSM/Algebra/Furey/WeakIsospinLadder.lean`
- `PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean`
- `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`
- `PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean`
- `PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean`
- `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
