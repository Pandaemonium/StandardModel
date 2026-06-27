# FUR-H5: Assemble the null-edge/Furey almost-commutative product and reuse Gate A square

    Type: proof/api

    ## Task prompt

    You are Aristotle. This is an integration/API job for the finite almost-commutative product.

Context:
The working plan now frames the null-edge/Furey fusion as deriving both halves of an almost-commutative spectral triple:

  external: null-edge finite Dirac D_N;
  internal: Furey/Baez/DVT finite algebra, Hilbert space, grading, and Phi_H;
  product:  D = i D_N tensor 1 + Gamma_s tensor Phi_H.

The existing Gate A finite Lichnerowicz bridge already proves the finite square for an abstract `Phi_H` satisfying the right sign/oddness hypotheses.

Task:
1. Inspect the included null-edge square/sign/checkerboard and Furey files.
2. Design the Lean API for `NullEdgeFureyAlmostCommutativeProduct.lean`.
3. If feasible, implement a small module that instantiates the abstract Gate A square with a Furey internal-space placeholder/interface, without pretending the full `Phi_H` construction is complete.
4. Prove a theorem of the form: once a Furey-compatible `Phi_H` satisfies the required hypotheses, the product square is exactly the existing Gate A square specialized to the Furey internal space.
5. Clearly separate theorem-level product architecture from unproved construction of `Phi_H`.

Desired output:
`PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean` or a precise API report.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`
- `PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean`
- `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`
- `PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean`
- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
