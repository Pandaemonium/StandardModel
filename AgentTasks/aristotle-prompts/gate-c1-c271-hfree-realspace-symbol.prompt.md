You are working in the StandardModel Lean 4 repository on Gate C1 of the null-edge program.

Current context:
- PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperator.lean now defines kineticSlashField, freeWilsonKernelField, Kfree, and proves fourierUnitary_kineticSlashField_trig plus fourierUnitary_Kfree_trig.
- PhysicsSM/Draft/NullEdge/GateC1/TetraScalarWilsonSymbol.lean defines the momentum symbol K and the Hermitian sign-kernel symbol H gamma5 D a r rho k := gamma5 * K D a r rho k.

Task:
1. Add a real-space Hfree definition to TetraFreeOperator.lean, probably `matrixFieldAction N gamma5 (Kfree N D a r rho Psi)`.
2. Prove the normalized Fourier diagonalization theorem:
   fourierUnitary N (Hfree N gamma5 D a r rho Psi) m =
     (TetraScalarWilsonSymbol.H gamma5 D a r rho (kOfMom N m)).mulVec
       (fourierUnitary N Psi m)
3. If useful, add a small helper lemma connecting matrixFieldAction after Kfree to matrix multiplication of symbols.
4. Preserve existing theorem names and do not rewrite the Kfree proof unless necessary.

Success criteria:
- `lake build PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator` succeeds.
- No proof placeholders or fake assumptions.
- Keep the theorem finite/free only; do not claim physical C1 closure.
