Project name: gate-c1-subgap-constants-instantiation-c181

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C170R gave the quantitative certificate:
  ||H_ne - H_ref|| <= kappa + omega + rho + alpha + beta
where the constants bound kinetic mismatch, W_branch mismatch, R/m0 mismatch, gauge/admissibility perturbation, and branch-frame mismatch.
Gate C1 needs the inequality
  kappa + omega + rho + alpha + beta < gamma_ref.

Task:
Design the concrete instantiation plan for these constants in the null-edge CKM/reference-import route.

Requested output:
1. Define what each constant should measure in the null-edge operator:
   - kappa: kinetic/Dirac-symbol mismatch;
   - omega: branch Wilson/flavored-mass mismatch;
   - rho: R and m0 shift mismatch;
   - alpha: gauge/admissibility perturbation;
   - beta: branch-frame/tetrad/soldering mismatch.
2. State computable or finite-dimensional bounds for each term in a finite-sector/corner model.
3. Give retuning options if the inequality fails: change m0, r, R, reference gap, admissibility window, frame alignment, or intermediate homotopy.
4. Provide Lean/API certificate structures compatible with C170R.
5. Identify which constants are likely zero in the ideal matching case and which are genuinely hard.

This is both theorem design and practical audit. Do not claim the constants are small without hypotheses.
