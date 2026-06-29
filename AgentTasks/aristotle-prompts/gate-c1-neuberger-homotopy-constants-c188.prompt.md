Project name: gate-c1-neuberger-homotopy-constants-c188

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C170/C181 define the sub-gap criterion:
  ||H_ne - H_ref|| <= kappa + omega + rho + alpha + beta < gamma_ref.
C186 is expected to propose Wilson/Neuberger overlap plus CKM texture as the concrete operator architecture.

Task:
Specialize the C170/C181 constants to a Wilson/Neuberger-with-CKM-texture architecture.

Requested output:
1. Define H_ref and H_ne at a level sufficient to assign kappa, omega, rho, alpha, beta.
2. Identify which constants should vanish in the ideal construction:
   - same kinetic reference?
   - same branch frame?
   - same R/m0?
   - same gauge admissibility class?
3. For nonzero constants, give computable finite or operator-norm bounds.
4. Give retuning strategies if the inequality fails: mass parameter m0, Wilson r, admissibility bound, intermediate homotopy, reference gap, frame alignment.
5. State a Lean/API theorem compatible with C170R and C181.
6. Explain how the shifted CKM window interacts with the Wilson/Neuberger reference gap.

Do not assume constants are small. We need a realistic audit plan.
